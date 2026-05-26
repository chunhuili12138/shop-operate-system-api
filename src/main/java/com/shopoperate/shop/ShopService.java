package com.shopoperate.shop;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.shopoperate.staff.StaffService;
import com.shopoperate.utils.CacheUtil;

import java.math.BigInteger;
import java.util.Date;
import java.util.List;

public class ShopService {

    public static final ShopService me = new ShopService();

    public Page<Record> page(int pageNum, int pageSize, String keyword, BigInteger ownerStaffId, Integer status,
                            BigInteger loginShopId, boolean isSuperAdmin) {
        StringBuilder select = new StringBuilder("SELECT s.*, st.name AS owner_name");
        StringBuilder from = new StringBuilder(" FROM shops s ");
        from.append("LEFT JOIN staff st ON s.owner_staff_id = st.id ");
        from.append("WHERE s.is_deleted = 0");

        // 非超管：只展示当前登录店铺
        if (!isSuperAdmin && loginShopId != null) {
            from.append(" AND s.id = ").append(loginShopId);
        }

        if (keyword != null && !keyword.isEmpty()) {
            from.append(" AND (s.name LIKE '%").append(keyword.replace("'", "''"))
                .append("%' OR s.contact_phone LIKE '%").append(keyword.replace("'", "''"))
                .append("%')");
        }
        if (ownerStaffId != null) {
            from.append(" AND s.owner_staff_id = ").append(ownerStaffId);
        }
        if (status != null) {
            from.append(" AND s.status = ").append(status);
        }

        from.append(" ORDER BY s.created_at DESC");

        return Db.paginate(pageNum, pageSize, select.toString(), from.toString());
    }

    public Record info(BigInteger shopId) {
        Record shop = Db.findFirst(
            "SELECT s.*, st.name AS owner_name, st.phone AS owner_phone, " +
            "ss.seat_no, ss.id AS seat_subscription_id " +
            "FROM shops s LEFT JOIN staff st ON s.owner_staff_id = st.id " +
            "LEFT JOIN seat_subscriptions ss ON s.seat_id = ss.id " +
            "WHERE s.id = ? AND s.is_deleted = 0", shopId
        );
        return shop;
    }

    public boolean add(BigInteger seatId, String name, String address, String contactPhone,
                        Integer maxCapacity, String description) {
        return Db.tx(() -> {
            Record seat = Db.findById("seat_subscriptions", seatId);
            if (seat == null) return false;
            if (seat.getInt("status") != 1) return false;

            // 检查席位是否已被其他店铺占用
            Record boundShop = Db.findFirst(
                "SELECT id FROM shops WHERE seat_id = ? AND is_deleted = 0", seatId
            );
            if (boundShop != null) return false;

            BigInteger ownerStaffId = seat.getBigInteger("staff_id");

            // 检查商户席位数（FOR UPDATE 防止并发超建）
            Record staff = Db.findFirst(
                "SELECT * FROM staff WHERE id = ? FOR UPDATE", ownerStaffId
            );
            if (staff == null) return false;

            Long usedSeats = staff.getLong("used_seats");
            Long maxSeats = staff.getLong("max_seats");
            if (usedSeats != null && maxSeats != null && usedSeats >= maxSeats) {
                return false;
            }

            // 创建店铺
            Record shop = new Record();
            shop.set("owner_staff_id", ownerStaffId);
            shop.set("seat_id", seatId);
            shop.set("name", name);
            shop.set("address", address);
            shop.set("contact_phone", contactPhone);
            shop.set("max_capacity", maxCapacity != null ? maxCapacity : 20);
            shop.set("description", description);
            shop.set("status", 1);
            shop.set("is_deleted", 0);
            shop.set("created_at", new Date());
            shop.set("updated_at", new Date());
            Db.save("shops", shop);

            // 更新 used_seats
            staff.set("used_seats", (usedSeats != null ? usedSeats : 0) + 1);
            Db.update("staff", staff);

            return true;
        });
    }

    public boolean update(BigInteger shopId, String name, String address,
                           String contactPhone, Integer maxCapacity, String description, String signPhoto) {
        Record shop = Db.findById("shops", shopId);
        if (shop == null) return false;

        if (name != null) shop.set("name", name);
        if (address != null) shop.set("address", address);
        if (contactPhone != null) shop.set("contact_phone", contactPhone);
        if (maxCapacity != null) shop.set("max_capacity", maxCapacity);
        if (description != null) shop.set("description", description);
        if (signPhoto != null) shop.set("sign_photo", signPhoto);
        shop.set("updated_at", new Date());

        return Db.update("shops", shop);
    }

    public boolean delete(BigInteger shopId) {
        // 查出所有关联该店铺的员工，用于事务后失效缓存
        List<Record> relatedStaff = Db.find("SELECT staff_id FROM staff_shops WHERE shop_id = ?", shopId);

        boolean ok = Db.tx(() -> {
            Record shop = Db.findById("shops", shopId);
            if (shop == null) return false;

            shop.set("is_deleted", 1);
            shop.set("seat_id", null);
            Db.update("shops", shop);

            BigInteger ownerStaffId = shop.getBigInteger("owner_staff_id");
            Record staff = Db.findById("staff", ownerStaffId);
            if (staff != null) {
                Long usedSeats = staff.getLong("used_seats");
                staff.set("used_seats", Math.max(0, (usedSeats != null ? usedSeats : 1) - 1));
                Db.update("staff", staff);
            }

            return true;
        });

        // 事务提交后失效缓存
        if (ok) {
            for (Record r : relatedStaff) {
                CacheUtil.evictShopAccess(r.getBigInteger("staff_id"), shopId);
            }
        }
        return ok;
    }

    /**
     * 级联软删除店铺及其下所有业务数据（含员工）
     * 在单个事务内完成，供商户级联删除调用
     */
    public boolean cascadeDelete(BigInteger shopId) {
        List<Record> relatedStaff = Db.find("SELECT staff_id FROM staff_shops WHERE shop_id = ?", shopId);

        boolean ok = Db.tx(() -> {
            Date now = new Date();

            Record shop = Db.findById("shops", shopId);
            if (shop == null) return false;

            // 1. 标记店铺软删除
            shop.set("is_deleted", 1);
            shop.set("deleted_time", now);
            shop.set("seat_id", null);
            shop.set("updated_at", now);
            Db.update("shops", shop);

            // 释放席位：递减商户 used_seats
            BigInteger ownerStaffId = shop.getBigInteger("owner_staff_id");
            Record staff = Db.findById("staff", ownerStaffId);
            if (staff != null) {
                Long usedSeats = staff.getLong("used_seats");
                staff.set("used_seats", Math.max(0, (usedSeats != null ? usedSeats : 1) - 1));
                Db.update("staff", staff);
            }

            // 2. 级联软删除店铺下员工
            for (Record sr : relatedStaff) {
                StaffService.me.cascadeDeleteStaff(sr.getBigInteger("staff_id"));
            }

            // 3. 软删除所有店铺级业务数据
            softDeleteByShop("customers", shopId, now);
            softDeleteByShop("customer_wallets", shopId, now);
            softDeleteByShop("wallet_transactions", shopId, now);
            softDeleteByShop("points_records", shopId, now);

            softDeleteByShop("packages", shopId, now);
            Db.update("UPDATE package_bom SET is_deleted = 1, deleted_time = ? WHERE package_id IN (SELECT id FROM packages WHERE shop_id = ?)", now, shopId);

            softDeleteByShop("purchases", shopId, now);
            softDeleteByShop("prepayments", shopId, now);
            softDeleteByShop("customer_sessions", shopId, now);
            softDeleteByShop("game_sessions", shopId, now);
            softDeleteByShop("revenue_records", shopId, now);
            softDeleteByShop("refund_records", shopId, now);

            softDeleteByShop("materials", shopId, now);
            softDeleteByShop("inventory", shopId, now);
            softDeleteByShop("inventory_transactions", shopId, now);

            softDeleteByShop("suppliers", shopId, now);
            softDeleteByShop("purchase_orders", shopId, now);
            Db.update("UPDATE purchase_order_items SET is_deleted = 1, deleted_time = ? WHERE order_id IN (SELECT id FROM purchase_orders WHERE shop_id = ?)", now, shopId);
            Db.update("UPDATE purchase_payments SET is_deleted = 1, deleted_time = ? WHERE order_id IN (SELECT id FROM purchase_orders WHERE shop_id = ?)", now, shopId);

            softDeleteByShop("expense_categories", shopId, now);
            softDeleteByShop("expenses", shopId, now);
            softDeleteByShop("commission_rules", shopId, now);
            softDeleteByShop("commission_settlements", shopId, now);
            softDeleteByShop("invoices", shopId, now);

            softDeleteByShop("coupons", shopId, now);
            softDeleteByShop("coupon_usages", shopId, now);
            softDeleteByShop("coupon_verification_logs", shopId, now);

            softDeleteByShop("articles", shopId, now);
            softDeleteByShop("article_categories", shopId, now);

            softDeleteByShop("queue_entries", shopId, now);
            softDeleteByShop("feedbacks", shopId, now);

            // 物理删除店铺级关联表
            Db.update("DELETE FROM staff_shops WHERE shop_id = ?", shopId);
            Db.update("DELETE FROM staff_schedules WHERE shop_id = ?", shopId);

            return true;
        });

        // 事务提交后失效缓存
        if (ok) {
            for (Record r : relatedStaff) {
                CacheUtil.evictShopAccess(r.getBigInteger("staff_id"), shopId);
                CacheUtil.evictPerms(r.getBigInteger("staff_id"));
            }
        }
        return ok;
    }

    private void softDeleteByShop(String table, BigInteger shopId, Date now) {
        Db.update("UPDATE " + table + " SET is_deleted = 1, deleted_time = ? WHERE shop_id = ? AND is_deleted = 0", now, shopId);
    }

    public boolean toggleStatus(BigInteger shopId, Integer status) {
        Record shop = Db.findById("shops", shopId);
        if (shop == null) return false;
        shop.set("status", status);
        shop.set("updated_at", new Date());
        return Db.update("shops", shop);
    }

    /**
     * 生成/刷新店铺太阳码
     * @return 太阳码相对路径，失败返回 null
     */
    public String generateMpQrcode(BigInteger shopId) {
        Record shop = Db.findById("shops", shopId);
        if (shop == null || shop.getInt("is_deleted") == 1) return null;

        String scene = "sid=" + shopId;
        String page = "pages/index/index";
        String fileName = shopId + "/qrcode.png";
        String outputPath = "C:/shop-operate/" + fileName;

        boolean ok = com.shopoperate.utils.WechatApiUtil.generateWxaCode(scene, page, 430, outputPath);
        if (ok) {
            shop.set("mp_qrcode_path", fileName);
            shop.set("updated_at", new Date());
            Db.update("shops", shop);
            return fileName;
        }
        return shop.getStr("mp_qrcode_path"); // 返回旧路径
    }
}
