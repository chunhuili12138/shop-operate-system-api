package com.shopoperate.staff;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.shopoperate.utils.CacheUtil;
import com.shopoperate.utils.PasswordUtil;

import java.math.BigInteger;
import java.util.Date;
import java.util.List;

public class StaffService {

    public static final StaffService me = new StaffService();

    /**
     * 员工分页列表
     */
    public Page<Record> page(int pageNum, int pageSize, String keyword, BigInteger roleId, Integer status, BigInteger shopId) {
        StringBuilder select = new StringBuilder(
            "SELECT s.*, sa.username, " +
            "GROUP_CONCAT(DISTINCT r.name ORDER BY r.id SEPARATOR ',') AS role_names");
        StringBuilder from = new StringBuilder(" FROM staff s ");
        from.append("LEFT JOIN staff_roles sr ON s.id = sr.staff_id ");
        from.append("LEFT JOIN roles r ON sr.role_id = r.id ");
        from.append("LEFT JOIN staff_shops ss ON s.id = ss.staff_id ");
        from.append("LEFT JOIN staff_accounts sa ON s.id = sa.staff_id AND sa.is_deleted = 0 ");
        from.append("WHERE s.is_deleted = 0 AND s.boss_status = 0");

        if (keyword != null && !keyword.isEmpty()) {
            from.append(" AND (s.name LIKE '%").append(keyword.replace("'", "''"))
                .append("%' OR s.phone LIKE '%").append(keyword.replace("'", "''"))
                .append("%')");
        }
        if (roleId != null) {
            from.append(" AND sr.role_id = ").append(roleId);
        }
        if (status != null) {
            from.append(" AND s.status = ").append(status);
        }
        if (shopId != null) {
            from.append(" AND ss.shop_id = ").append(shopId);
        }

        from.append(" GROUP BY s.id ORDER BY s.created_at DESC");

        return Db.paginate(pageNum, pageSize, select.toString(), from.toString());
    }

    /**
     * 员工详情
     */
    public Record info(BigInteger staffId) {
        Record staff = Db.findFirst(
            "SELECT * FROM staff WHERE id = ? AND is_deleted = 0",
            staffId
        );
        if (staff == null) return null;

        // 角色列表
        List<Record> roles = Db.find(
            "SELECT r.* FROM roles r INNER JOIN staff_roles sr ON r.id = sr.role_id WHERE sr.staff_id = ?",
            staffId
        );

        // 关联店铺
        List<Record> shops = Db.find(
            "SELECT s.* FROM shops s INNER JOIN staff_shops ss ON s.id = ss.shop_id WHERE ss.staff_id = ? AND s.is_deleted = 0",
            staffId
        );

        // 账号信息
        Record account = Db.findFirst(
            "SELECT id, username, wechat_openid, last_login_at FROM staff_accounts WHERE staff_id = ? AND is_deleted = 0",
            staffId
        );

        staff.set("roles", roles);
        staff.set("shops", shops);
        staff.set("account", account);

        return staff;
    }

    /**
     * 新增员工
     */
    public boolean add(String name, String phone, String username, String password,
                        List<BigInteger> roleIds, BigInteger shopId,
                        Integer employmentType, String remark) {
        return Db.tx(() -> {
            Record existAccount = Db.findFirst(
                "SELECT id FROM staff_accounts WHERE username = ? AND is_deleted = 0", username);
            if (existAccount != null) {
                throw new RuntimeException("用户名 '" + username + "' 已存在，请使用其他用户名");
            }

            Record staff = new Record();
            staff.set("boss_status", 0);
            staff.set("name", name);
            staff.set("phone", phone);
            staff.set("employment_type", employmentType != null ? employmentType : 1);
            staff.set("remark", remark);
            staff.set("status", 1);
            staff.set("is_deleted", 0);
            staff.set("created_at", new Date());
            staff.set("updated_at", new Date());
            Db.save("staff", staff);

            BigInteger staffId = staff.getBigInteger("id");

            Record account = new Record();
            account.set("staff_id", staffId);
            account.set("username", username);
            account.set("password_hash", PasswordUtil.hashPassword(password));
            account.set("is_deleted", 0);
            account.set("created_at", new Date());
            Db.save("staff_accounts", account);

            if (roleIds != null) {
                for (BigInteger roleId : roleIds) {
                    Record sr = new Record();
                    sr.set("staff_id", staffId);
                    sr.set("role_id", roleId);
                    Db.save("staff_roles", sr);
                }
            }

            // 员工绑定单个店铺（staff_shops 中一个 staff_id 只有一条记录）
            if (shopId != null) {
                Record ss = new Record();
                ss.set("staff_id", staffId);
                ss.set("shop_id", shopId);
                ss.set("created_at", new Date());
                Db.save("staff_shops", ss);
            }

            // 反向员工自动识别：同店铺内已有顾客的 wechat_openid → 写入 staff_accounts
            if (phone != null && !phone.isEmpty() && shopId != null) {
                matchCustomerByPhoneAndShop(phone, shopId, staffId);
            }

            return true;
        });
    }

    /**
     * 编辑员工（不允许换店，要换店需删除后在其他店铺重建）
     */
    public boolean update(BigInteger staffId, String name, String phone,
                           List<BigInteger> roleIds,
                           Integer status, Integer employmentType, String remark) {
        // 先查旧 shopId，用于失效缓存
        Record oldShopRec = Db.findFirst("SELECT shop_id FROM staff_shops WHERE staff_id = ?", staffId);
        BigInteger oldShopId = oldShopRec != null ? oldShopRec.getBigInteger("shop_id") : null;
        final boolean phoneProvided = phone != null && !phone.isEmpty();

        boolean ok = Db.tx(() -> {
            Record staff = Db.findById("staff", staffId);
            if (staff == null) return false;

            if (name != null) staff.set("name", name);
            if (phone != null) staff.set("phone", phone);
            if (employmentType != null) staff.set("employment_type", employmentType);
            if (status != null) staff.set("status", status);
            if (remark != null) staff.set("remark", remark);
            staff.set("updated_at", new Date());
            Db.update("staff", staff);

            if (roleIds != null) {
                // 角色白名单：禁止分配超管(2)或店长(3)
                for (BigInteger roleId : roleIds) {
                    if (roleId.equals(BigInteger.valueOf(2L)) || roleId.equals(BigInteger.valueOf(3L))) {
                        return false;
                    }
                }
                Db.update("DELETE FROM staff_roles WHERE staff_id = ?", staffId);
                for (BigInteger roleId : roleIds) {
                    Record sr = new Record();
                    sr.set("staff_id", staffId);
                    sr.set("role_id", roleId);
                    Db.save("staff_roles", sr);
                }
                // 角色变了 → 权限缓存失效
                CacheUtil.evictPerms(staffId);
            }

            return true;
        });

        if (ok) {
            if (oldShopId != null) CacheUtil.evictShopAccess(staffId, oldShopId);
            // 反向员工自动识别：手机号变更时检测同店铺顾客
            if (phoneProvided && oldShopId != null) {
                matchCustomerByPhoneAndShop(phone, oldShopId, staffId);
            }
        }
        return ok;
    }

    /**
     * 切换在职/离职状态
     */
    public boolean updateStatus(BigInteger staffId, Integer status) {
        Record staff = Db.findById("staff", staffId);
        if (staff == null) return false;
        staff.set("status", status);
        staff.set("updated_at", new Date());
        return Db.update("staff", staff);
    }

    /**
     * 重置密码
     */
    public boolean resetPassword(BigInteger staffId, String newPassword) {
        Record account = Db.findFirst(
            "SELECT * FROM staff_accounts WHERE staff_id = ? AND is_deleted = 0",
            staffId
        );
        if (account == null) return false;

        account.set("password_hash", PasswordUtil.hashPassword(newPassword));
        return Db.update("staff_accounts", account);
    }

    /**
     * 删除员工（逻辑删除）
     */
    public boolean delete(BigInteger staffId) {
        // 先查旧 shopId
        Record oldShopRec = Db.findFirst("SELECT shop_id FROM staff_shops WHERE staff_id = ?", staffId);
        BigInteger oldShopId = oldShopRec != null ? oldShopRec.getBigInteger("shop_id") : null;

        boolean ok = Db.tx(() -> {
            Record staff = Db.findById("staff", staffId);
            if (staff == null) return false;
            staff.set("is_deleted", 1);
            staff.set("deleted_time", new Date());
            Db.update("staff", staff);

            Record account = Db.findFirst(
                "SELECT * FROM staff_accounts WHERE staff_id = ?", staffId
            );
            if (account != null) {
                account.set("is_deleted", 1);
                account.set("deleted_time", new Date());
                Db.update("staff_accounts", account);
            }

            return true;
        });

        if (ok && oldShopId != null) CacheUtil.evictShopAccess(staffId, oldShopId);
        return ok;
    }

    /**
     * 级联删除员工（含关联表物理删除，供店铺/商户级联删除调用）
     * 在调用方事务内执行
     */
    public BigInteger cascadeDeleteStaff(BigInteger staffId) {
        Record oldShopRec = Db.findFirst("SELECT shop_id FROM staff_shops WHERE staff_id = ?", staffId);
        BigInteger oldShopId = oldShopRec != null ? oldShopRec.getBigInteger("shop_id") : null;

        Date now = new Date();
        Record staff = Db.findById("staff", staffId);
        if (staff != null) {
            staff.set("is_deleted", 1);
            staff.set("deleted_time", now);
            Db.update("staff", staff);
        }

        Record account = Db.findFirst("SELECT * FROM staff_accounts WHERE staff_id = ?", staffId);
        if (account != null) {
            account.set("is_deleted", 1);
            account.set("deleted_time", now);
            Db.update("staff_accounts", account);
        }

        Db.update("DELETE FROM staff_roles WHERE staff_id = ?", staffId);
        Db.update("DELETE FROM staff_shops WHERE staff_id = ?", staffId);
        Db.update("DELETE FROM staff_schedules WHERE staff_id = ?", staffId);

        return oldShopId;
    }

    /**
     * 反向员工自动识别：同店铺内已有顾客的 wechat_openid → 写入 staff_accounts
     */
    private void matchCustomerByPhoneAndShop(String phone, BigInteger shopId, BigInteger staffId) {
        if (phone == null || phone.isEmpty()) return;
        Record matchedCustomer = Db.findFirst(
            "SELECT * FROM customers WHERE phone = ? AND shop_id = ? " +
            "AND wechat_openid IS NOT NULL AND is_deleted = 0 LIMIT 1",
            phone, shopId);
        if (matchedCustomer != null) {
            Db.update(
                "UPDATE staff_accounts SET wechat_openid = ? WHERE staff_id = ? AND wechat_openid IS NULL",
                matchedCustomer.getStr("wechat_openid"), staffId);
        }
    }
}
