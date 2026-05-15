package com.shopoperate.common.intercept;

import com.jfinal.aop.Interceptor;
import com.jfinal.aop.Invocation;
import com.jfinal.core.Controller;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.shopoperate.common.vo.User;
import com.shopoperate.utils.ApiReturn;

import java.math.BigInteger;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 数据隔离拦截器（shop_id 越权防护）
 *
 * 校验当前请求中的 shop_id 是否属于当前登录用户的可访问店铺。
 * 适用于需要按店铺隔离数据的接口。
 * 超管（isSuperAdmin=1）可跳过此校验。
 *
 * 使用方式：在 Controller 方法上添加 @Before(ShopDataIsolationInterceptor.class)
 * 请求中需携带 shop_id 参数（query、path 或 json body 中的 shopId）
 */
public class ShopDataIsolationInterceptor implements Interceptor {

    @Override
    public void intercept(Invocation inv) {
        Controller controller = inv.getController();
        User user = controller.getSessionAttr("userinfo");

        if (user == null) {
            controller.renderJson(new ApiReturn().loginInvalid());
            return;
        }

        // 超管跳过数据隔离校验
        if (user.getIsSuperAdmin() != null && user.getIsSuperAdmin() == 1) {
            inv.invoke();
            return;
        }

        // 获取当前用户可访问的店铺 ID 列表
        List<BigInteger> userShopIds = Db.find(
            "SELECT shop_id FROM staff_shops WHERE staff_id = ?",
            user.getId()
        ).stream().map(r -> r.getBigInteger("shop_id")).collect(Collectors.toList());

        // 如果用户没有关联任何店铺，放行（可能是平台级操作）
        if (userShopIds.isEmpty()) {
            inv.invoke();
            return;
        }

        // 从请求中获取 shop_id（支持多种来源）
        BigInteger requestShopId = null;

        // 1. 从查询参数获取
        String shopIdStr = controller.getPara("shopId");
        if (shopIdStr == null) {
            shopIdStr = controller.getPara("shop_id");
        }
        // 2. 从路径参数获取
        if (shopIdStr == null) {
            shopIdStr = controller.getPara(0);
        }
        // 3. 从 header 获取
        if (shopIdStr == null) {
            shopIdStr = controller.getHeader("X-Shop-Id");
        }

        if (shopIdStr != null && !shopIdStr.isEmpty()) {
            try {
                requestShopId = new BigInteger(shopIdStr);
            } catch (NumberFormatException ignored) {
            }
        }

        // 如果请求中没有 shop_id，说明是全局操作，放行
        if (requestShopId == null) {
            inv.invoke();
            return;
        }

        // 检查请求的 shop_id 是否在用户的可访问列表中
        if (userShopIds.contains(requestShopId)) {
            // 将 shopId 设置到 user 对象中，方便后续使用
            user.setLoginShopId(requestShopId);
            inv.invoke();
        } else {
            controller.renderJson(new ApiReturn()
                .addMsg("无权访问该店铺的数据")
                .fail());
        }
    }
}
