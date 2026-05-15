package com.shopoperate.admin;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.shopoperate.shop.ShopService;
import com.shopoperate.utils.CacheUtil;
import com.shopoperate.utils.PasswordUtil;

import java.math.BigInteger;
import java.util.Date;
import java.util.List;

public class TenantService {

    public static final TenantService me = new TenantService();

    public Page<Record> page(int pageNum, int pageSize, String keyword, String phone, Integer banStatus) {
        StringBuilder select = new StringBuilder("SELECT s.*, sa.username, ");
        select.append("(SELECT COUNT(*) FROM shops WHERE owner_staff_id = s.id AND is_deleted = 0) AS shop_count, ");
        select.append("(SELECT GROUP_CONCAT(r.name) FROM staff_roles sr INNER JOIN roles r ON sr.role_id = r.id WHERE sr.staff_id = s.id) AS role_names");
        StringBuilder from = new StringBuilder(" FROM staff s LEFT JOIN staff_accounts sa ON s.id = sa.staff_id AND sa.is_deleted = 0 WHERE s.boss_status = 1 AND s.is_deleted = 0");
        
        // 排除超管账号（role_id = 2）
        from.append(" AND s.id NOT IN (SELECT sr.staff_id FROM staff_roles sr WHERE sr.role_id = 2)");

        if (keyword != null && !keyword.isEmpty()) {
            from.append(" AND (s.name LIKE '%").append(keyword.replace("'", "''"))
                .append("%' OR s.phone LIKE '%").append(keyword.replace("'", "''"))
                .append("%')");
        }
        if (phone != null && !phone.isEmpty()) {
            from.append(" AND s.phone LIKE '%").append(phone.replace("'", "''")).append("%'");
        }
        if (banStatus != null) {
            from.append(" AND s.is_ban = ").append(banStatus);
        }

        from.append(" ORDER BY s.created_at DESC");
        return Db.paginate(pageNum, pageSize, select.toString(), from.toString());
    }

    public List<Record> list(String keyword, String phone, Integer banStatus) {
        StringBuilder sql = new StringBuilder("SELECT s.*, sa.username, ");
        sql.append("(SELECT COUNT(*) FROM shops WHERE owner_staff_id = s.id AND is_deleted = 0) AS shop_count, ");
        sql.append("(SELECT GROUP_CONCAT(r.name) FROM staff_roles sr INNER JOIN roles r ON sr.role_id = r.id WHERE sr.staff_id = s.id) AS role_names ");
        sql.append("FROM staff s LEFT JOIN staff_accounts sa ON s.id = sa.staff_id AND sa.is_deleted = 0 WHERE s.boss_status = 1 AND s.is_deleted = 0");
        
        // 排除超管账号（role_id = 2）
        sql.append(" AND s.id NOT IN (SELECT sr.staff_id FROM staff_roles sr WHERE sr.role_id = 2)");

        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" AND (s.name LIKE '%").append(keyword.replace("'", "''"))
                .append("%' OR s.phone LIKE '%").append(keyword.replace("'", "''"))
                .append("%')");
        }
        if (phone != null && !phone.isEmpty()) {
            sql.append(" AND s.phone LIKE '%").append(phone.replace("'", "''")).append("%'");
        }
        if (banStatus != null) {
            sql.append(" AND s.is_ban = ").append(banStatus);
        }

        sql.append(" ORDER BY s.created_at DESC");
        return Db.find(sql.toString());
    }

    public Record info(BigInteger staffId) {
        Record staff = Db.findFirst(
            "SELECT s.*, sa.username, " +
            "(SELECT COUNT(*) FROM shops WHERE owner_staff_id = s.id AND is_deleted = 0) AS shop_count, " +
            "(SELECT GROUP_CONCAT(r.name) FROM staff_roles sr INNER JOIN roles r ON sr.role_id = r.id WHERE sr.staff_id = s.id) AS role_names " +
            "FROM staff s LEFT JOIN staff_accounts sa ON s.id = sa.staff_id AND sa.is_deleted = 0 WHERE s.id = ? AND s.is_deleted = 0", staffId
        );
        if (staff == null) return null;
        return staff;
    }

    public boolean add(String name, String phone, String username, String password,
                        Long maxSeats, String remark) {
        return Db.tx(() -> {
            Record existAccount = Db.findFirst(
                "SELECT id FROM staff_accounts WHERE username = ? AND is_deleted = 0", username);
            if (existAccount != null) {
                throw new RuntimeException("用户名 '" + username + "' 已存在，请使用其他用户名");
            }

            Record staff = new Record();
            staff.set("boss_status", 1);
            staff.set("name", name);
            staff.set("phone", phone);
            staff.set("max_seats", maxSeats != null ? maxSeats : 0);
            staff.set("used_seats", 0);
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

            Record sr = new Record().set("staff_id", staffId).set("role_id", 3);
            Db.save("staff_roles", sr);
            return true;
        });
    }

    public boolean update(BigInteger staffId, String name, String phone, String remark) {
        Record staff = Db.findById("staff", staffId);
        if (staff == null) return false;
        if (name != null) staff.set("name", name);
        if (phone != null) staff.set("phone", phone);
        if (remark != null) staff.set("remark", remark);
        staff.set("updated_at", new Date());
        return Db.update("staff", staff);
    }

    public boolean toggleBan(BigInteger staffId, Integer banStatus) {
        Record staff = Db.findById("staff", staffId);
        if (staff == null) return false;
        staff.set("is_ban", banStatus);
        staff.set("updated_at", new Date());
        return Db.update("staff", staff);
    }

    public boolean resetPassword(BigInteger staffId, String newPassword) {
        Record account = Db.findFirst(
            "SELECT * FROM staff_accounts WHERE staff_id = ? AND is_deleted = 0", staffId
        );
        if (account == null) return false;
        account.set("password_hash", PasswordUtil.hashPassword(newPassword));
        return Db.update("staff_accounts", account);
    }

    public boolean delete(BigInteger staffId) {
        // Step 1: 终止席位订阅 [事务1]
        boolean step1 = Db.tx(() -> {
            Date now = new Date();
            Db.update("UPDATE seat_subscriptions SET status = 3, updated_at = ? WHERE staff_id = ? AND status = 1", now, staffId);
            Db.update("UPDATE staff SET max_seats = 0, used_seats = 0, updated_at = ? WHERE id = ?", now, staffId);
            return true;
        });
        if (!step1) return false;

        // Step 2: 级联删除该商户下所有店铺 [每个店铺一个事务]
        List<Record> shops = Db.find("SELECT id FROM shops WHERE owner_staff_id = ? AND is_deleted = 0", staffId);
        for (Record shop : shops) {
            boolean ok = ShopService.me.cascadeDelete(shop.getBigInteger("id"));
            if (!ok) {
                // 单个店铺删除失败，记录日志但继续处理下一个
                System.err.println("Cascade delete shop failed: " + shop.getBigInteger("id"));
            }
        }

        // Step 3: 清理商户的人员关联表 [事务]
        Db.tx(() -> {
            Db.update("DELETE FROM staff_roles WHERE staff_id = ?", staffId);
            Db.update("DELETE FROM staff_shops WHERE staff_id = ?", staffId);
            Db.update("DELETE FROM staff_schedules WHERE staff_id = ?", staffId);
            return true;
        });

        // Step 4: 标记商户本身软删除 [事务]
        boolean step4 = Db.tx(() -> {
            Date now = new Date();
            Record staff = Db.findById("staff", staffId);
            if (staff == null) return false;
            staff.set("is_deleted", 1);
            staff.set("deleted_time", now);
            staff.set("updated_at", now);
            Db.update("staff", staff);

            Record account = Db.findFirst("SELECT * FROM staff_accounts WHERE staff_id = ?", staffId);
            if (account != null) {
                account.set("is_deleted", 1);
                account.set("deleted_time", now);
                Db.update("staff_accounts", account);
            }
            return true;
        });
        if (!step4) return false;

        // Step 5: 清理 Redis 缓存
        CacheUtil.evictPerms(staffId);
        for (Record shop : shops) {
            CacheUtil.evictShopAccess(staffId, shop.getBigInteger("id"));
        }

        return true;
    }

    // ========== 席位管理 ==========

    public boolean addSeat(BigInteger staffId, Integer subscriptionType, Integer subscriptionNum,
                            java.math.BigDecimal amount, String paymentMethod) {
        return Db.tx(() -> {
            Record staff = Db.findById("staff", staffId);
            if (staff == null) return false;

            Date now = new Date();
            Record seat = new Record();
            seat.set("staff_id", staffId);
            seat.set("start_date", now);
            // end_date 根据 subscriptionType 计算（月付+30天，年付+365天）
            java.util.Calendar cal = java.util.Calendar.getInstance();
            cal.setTime(now);
            cal.add(java.util.Calendar.DAY_OF_YEAR,
                subscriptionType == 2 ? 365 * subscriptionNum : 30 * subscriptionNum);
            seat.set("end_date", cal.getTime());
            seat.set("status", 1);
            seat.set("created_at", now);
            seat.set("updated_at", now);
            Db.save("seat_subscriptions", seat);

            BigInteger seatId = seat.getBigInteger("id");
            String seatNo = "SEAT-" + String.format("%06d", seatId.longValue());
            seat.set("seat_no", seatNo);
            Db.update("seat_subscriptions", seat);

            Record tx = new Record();
            tx.set("seat_id", seatId);
            tx.set("amount", amount);
            tx.set("payment_method", paymentMethod);
            tx.set("subscription_type", subscriptionType);
            tx.set("subscription_num", subscriptionNum);
            tx.set("status", 1);
            tx.set("created_at", now);
            Db.save("seat_subscriptions_transactions", tx);

            // 更新 max_seats
            Long currentMax = staff.getLong("max_seats");
            staff.set("max_seats", (currentMax != null ? currentMax : 0) + subscriptionNum);
            Db.update("staff", staff);

            return true;
        });
    }

    public boolean renewSeat(BigInteger seatId, Integer subscriptionType, Integer subscriptionNum,
                              java.math.BigDecimal amount, String paymentMethod) {
        return Db.tx(() -> {
            Record seat = Db.findById("seat_subscriptions", seatId);
            if (seat == null) return false;
            if (seat.getInt("status") != 1) return false;

            Date now = new Date();
            java.util.Calendar cal = java.util.Calendar.getInstance();
            Date oldEndDate = seat.getDate("end_date");
            if (oldEndDate != null && oldEndDate.after(now)) {
                cal.setTime(oldEndDate);
            } else {
                cal.setTime(now);
            }
            cal.add(java.util.Calendar.DAY_OF_YEAR,
                subscriptionType == 2 ? 365 * subscriptionNum : 30 * subscriptionNum);
            seat.set("end_date", cal.getTime());
            seat.set("status", 1);
            seat.set("updated_at", now);
            Db.update("seat_subscriptions", seat);

            Record tx = new Record();
            tx.set("seat_id", seatId);
            tx.set("amount", amount);
            tx.set("payment_method", paymentMethod);
            tx.set("subscription_type", subscriptionType);
            tx.set("subscription_num", subscriptionNum);
            tx.set("status", 1);
            tx.set("created_at", now);
            Db.save("seat_subscriptions_transactions", tx);

            // 更新 max_seats
            BigInteger staffId = seat.getBigInteger("staff_id");
            Record staff = Db.findById("staff", staffId);
            if (staff != null) {
                Long currentMax = staff.getLong("max_seats");
                staff.set("max_seats", (currentMax != null ? currentMax : 0) + subscriptionNum);
                Db.update("staff", staff);
            }

            return true;
        });
    }

    public boolean deleteSeat(BigInteger seatId) {
        Record seat = Db.findById("seat_subscriptions", seatId);
        if (seat == null) return false;
        // 检查是否有关联的店铺，有则不允许删除
        Record boundShop = Db.findFirst(
            "SELECT id FROM shops WHERE seat_id = ? AND is_deleted = 0", seatId
        );
        if (boundShop != null) return false;
        seat.set("status", 2);
        seat.set("updated_at", new Date());
        return Db.update("seat_subscriptions", seat);
    }

    public List<Record> seatList(BigInteger staffId) {
        return Db.find(
            "SELECT ss.*, " +
            "(SELECT GROUP_CONCAT(s.name) FROM shops s WHERE s.seat_id = ss.id AND s.is_deleted = 0) AS shop_names " +
            "FROM seat_subscriptions ss WHERE ss.staff_id = ? ORDER BY ss.created_at DESC", staffId
        );
    }

    public List<Record> unboundSeats(BigInteger staffId) {
        StringBuilder sql = new StringBuilder(
            "SELECT ss.*, st.name AS staff_name FROM seat_subscriptions ss " +
            "LEFT JOIN staff st ON ss.staff_id = st.id " +
            "WHERE ss.status = 1 AND NOT EXISTS (" +
            "SELECT 1 FROM shops s WHERE s.seat_id = ss.id AND s.is_deleted = 0)"
        );
        if (staffId != null) {
            sql.append(" AND ss.staff_id = ").append(staffId);
        }
        sql.append(" ORDER BY ss.created_at DESC");
        return Db.find(sql.toString());
    }

    public List<Record> subscriptionTransactionList(BigInteger staffId, BigInteger seatId) {
        StringBuilder sql = new StringBuilder(
            "SELECT sst.*, ss.seat_no FROM seat_subscriptions_transactions sst " +
            "INNER JOIN seat_subscriptions ss ON sst.seat_id = ss.id WHERE 1=1"
        );
        if (staffId != null) {
            sql.append(" AND ss.staff_id = ").append(staffId);
        }
        if (seatId != null) {
            sql.append(" AND sst.seat_id = ").append(seatId);
        }
        sql.append(" ORDER BY sst.created_at DESC");
        return Db.find(sql.toString());
    }

    public boolean refundTransaction(BigInteger transactionId, java.math.BigDecimal refundAmount, Integer deductedDays) {
        return Db.tx(() -> {
            Record tx = Db.findById("seat_subscriptions_transactions", transactionId);
            if (tx == null) return false;
            if (tx.getInt("status") != 1) return false;

            java.math.BigDecimal amount = tx.getBigDecimal("amount");
            if (amount == null) return false;
            if (refundAmount.compareTo(java.math.BigDecimal.ZERO) <= 0 || refundAmount.compareTo(amount) > 0) return false;

            Integer subscriptionNum = tx.getInt("subscription_num");
            if (subscriptionNum == null || subscriptionNum <= 0) return false;
            Integer type = tx.getInt("subscription_type");
            Integer totalDays = (type != null && type == 2) ? 365 * subscriptionNum : 30 * subscriptionNum;
            if (deductedDays == null || deductedDays <= 0 || deductedDays > totalDays) return false;

            BigInteger seatId = tx.getBigInteger("seat_id");
            Record seat = Db.findById("seat_subscriptions", seatId);
            if (seat != null) {
                java.util.Calendar cal = java.util.Calendar.getInstance();
                cal.setTime(seat.getDate("end_date"));
                cal.add(java.util.Calendar.DAY_OF_YEAR, -deductedDays);
                java.util.Date newEndDate = cal.getTime();
                seat.set("end_date", newEndDate);
                if (newEndDate.before(new java.util.Date())) {
                    seat.set("status", 2);
                }
                seat.set("updated_at", new java.util.Date());
                Db.update("seat_subscriptions", seat);

                BigInteger staffId = seat.getBigInteger("staff_id");
                Record staff = Db.findById("staff", staffId);
                if (staff != null) {
                    Long currentMax = staff.getLong("max_seats");
                    staff.set("max_seats", Math.max(0, (currentMax != null ? currentMax : 0) - subscriptionNum));
                    Db.update("staff", staff);
                }
            }

            tx.set("status", 2);
            tx.set("refund_amount", refundAmount);
            tx.set("refund_days", deductedDays);
            Db.update("seat_subscriptions_transactions", tx);

            return true;
        });
    }
}
