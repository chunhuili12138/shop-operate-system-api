package com.shopoperate.common.intercept;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.jfinal.aop.Interceptor;
import com.jfinal.aop.Invocation;
import com.jfinal.core.Controller;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.redis.Redis;
import com.shopoperate.common.annotation.RequireLogin;
import com.shopoperate.common.vo.User;
import com.shopoperate.utils.ApiReturn;
import org.apache.commons.lang.StringUtils;

import java.math.BigInteger;

public class TokenInterceptor implements Interceptor {

    public void intercept(Invocation inv){
        RequireLogin requireLogin = inv.getMethod().getAnnotation(RequireLogin.class);
        if (requireLogin == null) {
            requireLogin = inv.getController().getClass().getAnnotation(RequireLogin.class);
        }

        if (requireLogin == null) {
            inv.invoke();
            return;
        }

        Controller controller = inv.getController();
        String authorization = controller.getHeader("Authorization");

        if(StringUtils.isBlank(authorization)){
            controller.renderJson(new ApiReturn().loginInvalid());
            return;
        }

        // 提取 token 和 shopId
        // 支持两种格式：
        //   超管/未选店铺: "Bearer {token}"
        //   已选店铺:      "Bearer-{shopId}-{token}"
        String token = null;
        BigInteger shopId = null;

        if (authorization.startsWith("Bearer-")) {
            String rest = authorization.substring(7);
            String[] dashParts = rest.split("-", 2);
            if (dashParts.length == 2) {
                try {
                    shopId = new BigInteger(dashParts[0]);
                    token = dashParts[1];
                } catch (NumberFormatException e) {
                    token = rest;
                }
            } else {
                token = rest;
            }
        } else if (authorization.startsWith("Bearer ")) {
            String rest = authorization.substring(7);
            String[] dashParts = rest.split("-");
            if (dashParts.length >= 2) {
                try {
                    shopId = new BigInteger(dashParts[0]);
                    token = rest.substring(dashParts[0].length() + 1);
                } catch (NumberFormatException e) {
                    token = rest;
                }
            } else {
                token = rest;
            }
        } else {
            token = authorization;
        }

        if (token == null) {
            controller.renderJson(new ApiReturn().loginInvalid());
            return;
        }

        final String finalToken = token;
        String infoStr = Redis.call(j -> j.get("token:" + finalToken));

        if (StringUtils.isBlank(infoStr)) {
            controller.renderJson(new ApiReturn().loginInvalid());
            return;
        }

        JsonObject jsonObject = JsonParser.parseString(infoStr).getAsJsonObject();
        User user = new Gson().fromJson(jsonObject, User.class);

        // ========== shopId 校验逻辑（带 Redis 缓存）==========
        boolean isSuperAdmin = user.getIsSuperAdmin() != null && user.getIsSuperAdmin() == 1;
        String actionKey = inv.getActionKey();

        if (!isSuperAdmin) {
            // /auth/info 和 /auth/shops 免 shopId 校验（用户尚未选择店铺，需要这些接口获取信息）
            if (!"/api/auth/info".equals(actionKey) && !"/api/auth/shops".equals(actionKey)) {
                if (shopId == null) {
                    controller.renderJson(new ApiReturn()
                        .addMsg("请选择店铺后再操作")
                        .fail());
                    return;
                }
                // 从 Redis 缓存查询用户有权访问的店铺列表
                String shopAccessKey = "staff_shops:" + user.getId() + ":" + shopId;
                Boolean hasAccess = Redis.call(j -> j.exists(shopAccessKey));
                if (!hasAccess) {
                    long count = Db.queryLong(
                        "SELECT COUNT(*) FROM staff_shops WHERE staff_id = ? AND shop_id = ?",
                        user.getId(), shopId
                    );
                    if (count == 0) {
                        count = Db.queryLong(
                            "SELECT COUNT(*) FROM shops WHERE id = ? AND owner_staff_id = ? AND is_deleted = 0",
                            shopId, user.getId()
                        );
                    }
                    if (count == 0) {
                        controller.renderJson(new ApiReturn()
                            .addMsg("无权访问该店铺")
                            .fail());
                        return;
                    }
                    final BigInteger finalShopId = shopId;
                    Redis.call(j -> {
                        j.setex(shopAccessKey, 86400, "1");
                        return null;
                    });
                }
                user.setLoginShopId(shopId);
            }
        }

        controller.setSessionAttr("userinfo", user);
        controller.setSessionAttr("token", token);
        inv.invoke();
    }
}
