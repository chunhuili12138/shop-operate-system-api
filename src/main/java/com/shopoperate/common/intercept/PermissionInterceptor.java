package com.shopoperate.common.intercept;

import com.jfinal.aop.Interceptor;
import com.jfinal.aop.Invocation;
import com.jfinal.core.Controller;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.redis.Redis;
import com.shopoperate.common.annotation.RequirePermission;
import com.shopoperate.common.vo.User;
import com.shopoperate.utils.ApiReturn;
import com.shopoperate.utils.CacheUtil;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * 权限校验拦截器
 * 配合 @RequirePermission 注解使用。
 *
 * 缓存策略：
 * - 用户权限列表缓存在 Redis key "perms:{staffId}"，TTL 5 分钟
 * - 全局版本号 "perm_version:global"：权限变更时 +1
 * - 每次请求对比版本号，版本不一致则重新加载
 * - 这样修改角色权限后，下次请求立即生效（不用等 5 分钟 TTL）
 */
public class PermissionInterceptor implements Interceptor {

    private static final int PERMS_CACHE_SECONDS = 300;

    @Override
    public void intercept(Invocation inv) {
        RequirePermission requirePerm = inv.getMethod().getAnnotation(RequirePermission.class);
        if (requirePerm == null) {
            requirePerm = inv.getController().getClass().getAnnotation(RequirePermission.class);
        }

        if (requirePerm == null) {
            inv.invoke();
            return;
        }

        Controller controller = inv.getController();
        User user = controller.getSessionAttr("userinfo");

        if (user == null) {
            controller.renderJson(new ApiReturn().loginInvalid());
            return;
        }

        if (user.getIsSuperAdmin() != null && user.getIsSuperAdmin() == 1) {
            inv.invoke();
            return;
        }

        String requiredPermission = requirePerm.value();
        String cacheKey = "perms:" + user.getId();

        // 获取缓存的版本号
        long cachedVersion = Redis.call(j -> {
            String v = j.get(cacheKey + ":ver");
            return v != null ? Long.parseLong(v) : 0L;
        });

        // 获取全局版本号
        long globalVersion = CacheUtil.getPermVersion();

        // 版本不一致或没有缓存 → 重新加载
        List<String> userPerms = null;
        if (cachedVersion == globalVersion) {
            userPerms = Redis.call(j -> {
                Set<String> cached = j.smembers(cacheKey);
                return cached != null ? new ArrayList<>(cached) : null;
            });
        }

        if (userPerms == null || userPerms.isEmpty()) {
            userPerms = Db.find(
                "SELECT DISTINCT p.menu_code FROM permissions p " +
                "INNER JOIN role_permissions rp ON p.id = rp.permission_id " +
                "INNER JOIN staff_roles sr ON rp.role_id = sr.role_id " +
                "WHERE sr.staff_id = ? AND p.is_active = 1 AND p.is_deleted = 0",
                user.getId()
            ).stream().map(r -> r.getStr("menu_code")).collect(Collectors.toList());

            final List<String> finalUserPerms = userPerms;
            Redis.call(j -> {
                j.del(cacheKey);
                for (String perm : finalUserPerms) {
                    j.sadd(cacheKey, perm);
                }
                j.expire(cacheKey, PERMS_CACHE_SECONDS);
                j.setex(cacheKey + ":ver", PERMS_CACHE_SECONDS, String.valueOf(globalVersion));
                return null;
            });
        }

        if (userPerms.contains(requiredPermission)) {
            inv.invoke();
        } else {
            controller.renderJson(new ApiReturn()
                .addMsg(requirePerm.message())
                .fail());
        }
    }
}
