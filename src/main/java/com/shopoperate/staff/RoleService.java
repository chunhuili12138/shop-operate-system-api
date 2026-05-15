package com.shopoperate.staff;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.shopoperate.utils.CacheUtil;

import java.math.BigInteger;
import java.util.List;

public class RoleService {

    public static final RoleService me = new RoleService();

    /**
     * 角色列表（含权限数量）
     */
    public List<Record> list() {
        return Db.find(
            "SELECT r.*, (SELECT COUNT(*) FROM role_permissions rp WHERE rp.role_id = r.id) AS perm_count " +
            "FROM roles r ORDER BY r.id"
        );
    }

    /**
     * 角色详情（含全部权限ID）
     */
    public Record info(BigInteger roleId) {
        Record role = Db.findById("roles", roleId);
        if (role == null) return null;

        List<Record> perms = Db.find(
            "SELECT permission_id FROM role_permissions WHERE role_id = ?", roleId
        );
        List<BigInteger> permIds = perms.stream()
            .map(r -> r.getBigInteger("permission_id"))
            .collect(java.util.stream.Collectors.toList());

        role.set("permissionIds", permIds);
        return role;
    }

    /**
     * 新增角色
     */
    public boolean add(String name, String description) {
        Record role = new Record().set("name", name).set("description", description);
        return Db.save("roles", role);
    }

    /**
     * 编辑角色
     */
    public boolean update(Integer id, String name, String description) {
        Record role = Db.findById("roles", id);
        if (role == null) return false;
        if (name != null) role.set("name", name);
        if (description != null) role.set("description", description);
        return Db.update("roles", role);
    }

    /**
     * 设置角色权限
     * 操作完成后会：
     * 1. 失效该角色下所有员工的权限缓存
     * 2. bump 全局权限版本号（Perm 拦截器检测到版本变化后自动重新加载）
     */
    public boolean setPermissions(BigInteger roleId, List<BigInteger> permissionIds) {
        boolean ok = Db.tx(() -> {
            Db.update("DELETE FROM role_permissions WHERE role_id = ?", roleId);
            if (permissionIds != null) {
                for (BigInteger permId : permissionIds) {
                    Record rp = new Record();
                    rp.set("role_id", roleId);
                    rp.set("permission_id", permId);
                    Db.save("role_permissions", rp);
                }
            }
            return true;
        });
        if (ok) {
            CacheUtil.evictPermsByRole(roleId);
            CacheUtil.bumpPermVersion();
        }
        return ok;
    }
}
