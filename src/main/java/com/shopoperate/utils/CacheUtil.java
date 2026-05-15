package com.shopoperate.utils;

import com.jfinal.plugin.redis.Redis;

import java.math.BigInteger;

/**
 * Redis 缓存管理工具
 * 用于在数据变更时主动失效/刷新缓存，解决 TTL 过期前的数据不一致问题。
 */
public class CacheUtil {

    // ========== 店铺访问权限缓存 ==========

    /** 用户在商铺的访问权限缓存 key */
    private static String shopAccessKey(BigInteger staffId, BigInteger shopId) {
        return "staff_shops:" + staffId + ":" + shopId;
    }

    /** 失效用户的某个店铺访问缓存 */
    public static void evictShopAccess(BigInteger staffId, BigInteger shopId) {
        if (staffId != null && shopId != null) {
            Redis.call(j -> { j.del(shopAccessKey(staffId, shopId)); return null; });
        }
    }

    // ========== 权限缓存 ==========

    /** 用户权限列表缓存 key */
    private static String permsKey(BigInteger staffId) {
        return "perms:" + staffId;
    }

    /** 全局权限版本号 key（每次权限变更时 +1） */
    private static final String PERM_VERSION_KEY = "perm_version:global";

    /** 失效单个用户的权限缓存 */
    public static void evictPerms(BigInteger staffId) {
        if (staffId != null) {
            Redis.call(j -> { j.del(permsKey(staffId)); return null; });
        }
    }

    /** 全局权限版本号 +1（使所有用户的权限缓存失效）*/
    public static void bumpPermVersion() {
        Redis.call(j -> { j.incr(PERM_VERSION_KEY); return null; });
    }

    /** 获取当前全局权限版本号 */
    public static long getPermVersion() {
        String v = Redis.call(j -> j.get(PERM_VERSION_KEY));
        return v != null ? Long.parseLong(v) : 0L;
    }

    // ========== 批量操作 ==========

    /** 失效某个角色下所有员工的权限缓存 */
    public static void evictPermsByRole(java.math.BigInteger roleId) {
        // 查出该角色的所有员工
        java.util.List<com.jfinal.plugin.activerecord.Record> staffList =
            com.jfinal.plugin.activerecord.Db.find(
                "SELECT staff_id FROM staff_roles WHERE role_id = ?", roleId
            );
        for (com.jfinal.plugin.activerecord.Record r : staffList) {
            evictPerms(r.getBigInteger("staff_id"));
        }
    }
}
