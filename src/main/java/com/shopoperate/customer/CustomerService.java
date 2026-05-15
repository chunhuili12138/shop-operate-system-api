package com.shopoperate.customer;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.shopoperate.marketing.CouponService;

import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.Date;
import java.util.List;

public class CustomerService {

    public static final CustomerService me = new CustomerService();

    public Page<Record> page(int pageNum, int pageSize, String keyword, String phone, String source, String tag, BigInteger shopId) {
        StringBuilder select = new StringBuilder("SELECT c.*");
        StringBuilder from = new StringBuilder(" FROM customers c WHERE c.is_deleted = 0");
        if (shopId != null) from.append(" AND c.shop_id = ").append(shopId);

        if (keyword != null && !keyword.isEmpty())
            from.append(" AND (c.nickname LIKE '%").append(keyword.replace("'","''")).append("%' OR c.phone LIKE '%").append(keyword.replace("'","''")).append("%')");
        if (phone != null && !phone.isEmpty())
            from.append(" AND c.phone LIKE '%").append(phone.replace("'","''")).append("%'");
        if (source != null && !source.isEmpty())
            from.append(" AND c.source = '").append(source.replace("'","''")).append("'");
        if (tag != null && !tag.isEmpty())
            from.append(" AND c.tags LIKE '%").append(tag.replace("'","''")).append("%'");

        from.append(" ORDER BY c.created_at DESC");
        return Db.paginate(pageNum, pageSize, select.toString(), from.toString());
    }

    public Record info(BigInteger customerId, BigInteger shopId) {
        String sql = "SELECT * FROM customers WHERE id = ? AND is_deleted = 0";
        if (shopId != null) sql += " AND shop_id = " + shopId;
        Record c = Db.findFirst(sql, customerId);
        if (c == null) return null;
        String wSql = "SELECT * FROM customer_wallets WHERE customer_id = ?";
        if (shopId != null) wSql += " AND shop_id = " + shopId;
        Record wallet = Db.findFirst(wSql, customerId);
        List<Record> points = Db.find("SELECT * FROM points_records WHERE customer_id = ? ORDER BY created_at DESC LIMIT 20", customerId);
        c.set("wallet", wallet);
        c.set("points", points);
        return c;
    }

    public boolean add(BigInteger shopId, String nickname, String phone, Integer gender, String birthday, String remark, String source, String avatarUrl) {
        // 同一店铺手机号不能重复
        if (phone != null && !phone.isEmpty()) {
            long dup = Db.queryLong("SELECT COUNT(*) FROM customers WHERE shop_id = ? AND phone = ? AND is_deleted = 0", shopId, phone);
            if (dup > 0) return false;
        }
        Record c = new Record().set("shop_id", shopId).set("nickname", nickname).set("phone", phone)
                .set("gender", gender).set("source", source != null && !source.isEmpty() ? source : "offline")
                .set("remark", remark).set("is_deleted", 0)
                .set("created_at", new Date()).set("updated_at", new Date());
        if (avatarUrl != null && !avatarUrl.isEmpty()) c.set("avatar_url", avatarUrl);
        if (birthday != null && !birthday.isEmpty()) {
            try {
                // 支持带时间的日期格式
                if (birthday.contains(" ")) {
                    c.set("birthday", java.sql.Timestamp.valueOf(birthday));
                } else {
                    c.set("birthday", java.sql.Date.valueOf(birthday));
                }
            } catch (Exception e) {
                // 日期格式错误，忽略该字段
            }
        }
        Db.save("customers", c);
        // 创建钱包
        Record w = new Record().set("shop_id", shopId).set("customer_id", c.getBigInteger("id"))
                .set("balance", BigDecimal.ZERO).set("total_recharged", BigDecimal.ZERO).set("total_spent", BigDecimal.ZERO);
        boolean ok = Db.save("customer_wallets", w);
        // 有手机号则自动发放新人优惠券
        if (ok && phone != null && !phone.isEmpty()) {
            CouponService.me.autoGrantOnRegister(shopId, c.getBigInteger("id"));
        }
        return ok;
    }

    public boolean update(BigInteger customerId, BigInteger shopId, String nickname, String phone, Integer gender, String birthday, String remark, String tags, String source, String avatarUrl) {
        Record c = Db.findById("customers", customerId);
        if (c == null) return false;
        if (shopId != null && !shopId.equals(c.getBigInteger("shop_id"))) return false;
        // 同一店铺手机号不能重复（排除自身）
        if (phone != null && !phone.isEmpty()) {
            long dup = Db.queryLong("SELECT COUNT(*) FROM customers WHERE shop_id = ? AND phone = ? AND is_deleted = 0 AND id != ?", shopId, phone, customerId);
            if (dup > 0) return false;
        }
        if (nickname != null) c.set("nickname", nickname);
        if (phone != null) c.set("phone", phone);
        if (gender != null) c.set("gender", gender);
        if (birthday != null && !birthday.isEmpty()) {
            try {
                // 支持带时间的日期格式
                if (birthday.contains(" ")) {
                    c.set("birthday", java.sql.Timestamp.valueOf(birthday));
                } else {
                    c.set("birthday", java.sql.Date.valueOf(birthday));
                }
            } catch (Exception e) {
                // 日期格式错误，忽略该字段
            }
        }
        if (remark != null) c.set("remark", remark);
        if (tags != null) c.set("tags", tags);
        if (source != null) c.set("source", source);
        if (avatarUrl != null) c.set("avatar_url", avatarUrl);
        c.set("updated_at", new Date());
        return Db.update("customers", c);
    }

    public Page<Record> purchases(BigInteger customerId, String status, int pageNum, int pageSize) {
        StringBuilder select = new StringBuilder("SELECT p.*, pk.name AS package_name, pk.type AS package_type");
        StringBuilder from = new StringBuilder(" FROM purchases p LEFT JOIN packages pk ON p.package_id = pk.id WHERE p.customer_id = ? AND p.is_deleted = 0");
        if (status != null && !status.isEmpty()) from.append(" AND p.status = ").append(status);
        from.append(" ORDER BY p.created_at DESC");
        return Db.paginate(pageNum, pageSize, select.toString(), from.toString(), customerId);
    }

    // ========== 钱包 ==========
    public Record wallet(BigInteger customerId, BigInteger shopId) {
        String sql = "SELECT * FROM customer_wallets WHERE customer_id = ?";
        if (shopId != null) sql += " AND shop_id = " + shopId;
        return Db.findFirst(sql, customerId);
    }

    public List<Record> walletTransactions(BigInteger customerId) {
        return Db.find("SELECT * FROM wallet_transactions WHERE customer_id = ? ORDER BY created_at DESC LIMIT 50", customerId);
    }

    public boolean adjustWallet(BigInteger customerId, BigInteger shopId, int type, BigDecimal amount, String remark, BigInteger operatorId) {
        return Db.tx(() -> {
            String sql = "SELECT * FROM customer_wallets WHERE customer_id = ?";
            if (shopId != null) sql += " AND shop_id = " + shopId;
            sql += " FOR UPDATE";
            Record wallet = Db.findFirst(sql, customerId);
            // 钱包不存在则自动创建
            if (wallet == null) {
                BigInteger wsId = shopId;
                if (wsId == null) {
                    Record c = Db.findById("customers", customerId);
                    if (c == null) return false;
                    wsId = c.getBigInteger("shop_id");
                }
                wallet = new Record().set("shop_id", wsId).set("customer_id", customerId)
                        .set("balance", BigDecimal.ZERO).set("total_recharged", BigDecimal.ZERO).set("total_spent", BigDecimal.ZERO);
                Db.save("customer_wallets", wallet);
            }
            BigDecimal oldBalance = (BigDecimal) wallet.get("balance");
            BigDecimal newBalance;
            if (type == 1) { // 充值
                newBalance = oldBalance.add(amount);
                wallet.set("total_recharged", ((BigDecimal) wallet.get("total_recharged")).add(amount));
            } else { // 扣减
                newBalance = oldBalance.subtract(amount);
                wallet.set("total_spent", ((BigDecimal) wallet.get("total_spent")).add(amount));
            }
            wallet.set("balance", newBalance);
            Db.update("customer_wallets", wallet);

            Record tx = new Record().set("wallet_id", wallet.getBigInteger("id"))
                    .set("shop_id", wallet.get("shop_id")).set("customer_id", customerId)
                    .set("type", type).set("amount", amount).set("balance_after", newBalance)
                    .set("remark", remark).set("created_at", new Date());
            Db.save("wallet_transactions", tx);
            return true;
        });
    }

    /** 钱包充值（支持优惠券抵扣），返回 null=成功，否则返回错误信息 */
    public String recharge(BigInteger customerId, BigInteger shopId, BigDecimal amount,
                             String paymentMethod, BigInteger couponUsageId,
                             String remark, BigInteger operatorId) {
        final String[] err = {null};
        Db.tx(() -> {
            Date now = new Date();
            BigDecimal couponDiscount = BigDecimal.ZERO;
            if (couponUsageId != null) {
                Record usage = Db.findFirst("SELECT * FROM coupon_usages WHERE id=? AND is_deleted=0 FOR UPDATE", couponUsageId);
                if (usage == null) { err[0] = "优惠券不存在"; return false; }
                if (!shopId.equals(usage.getBigInteger("shop_id"))) { err[0] = "无权使用该优惠券"; return false; }
                if (!customerId.equals(usage.getBigInteger("customer_id"))) { err[0] = "该优惠券不属于当前顾客"; return false; }
                if (usage.getInt("status") != 1) { err[0] = "该优惠券已使用或已过期"; return false; }
                if (usage.getTimestamp("expires_at") != null && usage.getTimestamp("expires_at").before(now)) { err[0] = "该优惠券已过期"; return false; }
                Record coupon = Db.findById("coupons", usage.getBigInteger("coupon_id"));
                if (coupon == null) { err[0] = "优惠券已删除"; return false; }
                if (coupon.getInt("is_active") != 1) { err[0] = "该优惠券已禁用"; return false; }
                if (coupon.getInt("is_deleted") == 1) { err[0] = "该优惠券已删除"; return false; }
                if (!"recharge".equals(coupon.getStr("use_scene"))) { err[0] = "该优惠券不适用于充值"; return false; }
                BigDecimal minOrder = coupon.getBigDecimal("min_order_amount");
                if (minOrder != null && minOrder.compareTo(BigDecimal.ZERO) > 0 && amount.compareTo(minOrder) < 0) {
                    err[0] = "充值金额不满足优惠券最低消费要求（需≥" + minOrder + "元）"; return false;
                }
                int perLimit = coupon.getInt("per_user_limit");
                if (perLimit > 0) {
                    long usedCount = Db.queryLong("SELECT COUNT(*) FROM coupon_usages WHERE customer_id=? AND coupon_id=? AND status=2 AND is_deleted=0", customerId, coupon.getBigInteger("id"));
                    if (usedCount >= perLimit) { err[0] = "该优惠券已达到每人领取上限"; return false; }
                }
                int ctype = coupon.getInt("type");
                BigDecimal cvalue = coupon.getBigDecimal("value");
                if (ctype == 1) couponDiscount = cvalue.min(amount);
                else if (ctype == 2) couponDiscount = amount.multiply(cvalue).divide(new BigDecimal("100"), 2, BigDecimal.ROUND_HALF_UP).min(amount);
                else if (ctype == 3) couponDiscount = amount;
                usage.set("status", 2).set("used_at", now);
                Db.update("coupon_usages", usage);
            }
            Record wallet = Db.findFirst("SELECT * FROM customer_wallets WHERE customer_id=? AND shop_id=? FOR UPDATE", customerId, shopId);
            if (wallet == null) {
                wallet = new Record().set("shop_id", shopId).set("customer_id", customerId)
                    .set("balance", BigDecimal.ZERO).set("total_recharged", BigDecimal.ZERO).set("total_spent", BigDecimal.ZERO);
                Db.save("customer_wallets", wallet);
            }
            BigDecimal oldBalance = wallet.getBigDecimal("balance");
            BigDecimal newBalance = oldBalance.add(amount);
            wallet.set("balance", newBalance);
            wallet.set("total_recharged", wallet.getBigDecimal("total_recharged").add(amount));
            wallet.set("updated_at", now);
            Db.update("customer_wallets", wallet);
            Db.save("wallet_transactions", new Record().set("wallet_id", wallet.getBigInteger("id"))
                .set("shop_id", shopId).set("customer_id", customerId)
                .set("type", 1).set("amount", amount).set("balance_after", newBalance)
                .set("remark", remark != null ? remark : "手动充值").set("created_at", now));
            BigDecimal paidAmount = amount.subtract(couponDiscount);
            Record p = new Record().set("shop_id", shopId).set("customer_id", customerId)
                .set("purchase_type", "recharge").set("channel", "store")
                .set("coupon_usage_id", couponUsageId)
                .set("total_amount", amount).set("coupon_discount", couponDiscount)
                .set("paid_amount", paidAmount)
                .set("payment_method", paymentMethod != null ? paymentMethod : "other")
                .set("status", 1).set("start_date", new java.sql.Date(now.getTime()))
                .set("operator_staff_id", operatorId).set("remark", remark)
                .set("is_deleted", 0).set("created_at", now).set("updated_at", now);
            Db.save("purchases", p);
            if (couponUsageId != null && couponDiscount.compareTo(BigDecimal.ZERO) > 0) {
                Db.update("UPDATE coupon_usages SET used_in_purchase_id=? WHERE id=?", p.getBigInteger("id"), couponUsageId);
            }
            String detail = "{\"recharge\":" + amount + ",\"couponDiscount\":" + couponDiscount + ",\"paid\":" + paidAmount + "}";
            Db.save("operation_logs", new Record().set("shop_id", shopId).set("operator_id", operatorId)
                .set("operator_type", 1).set("action", "钱包充值").set("target_type", "recharge")
                .set("target_id", p.getBigInteger("id")).set("detail", detail).set("created_at", now));
            return true;
        });
        return err[0];
    }

    // ========== 积分 ==========
    public Page<Record> points(BigInteger customerId, int pageNum, int pageSize) {
        return Db.paginate(pageNum, pageSize, "SELECT *", "FROM points_records WHERE customer_id = ? ORDER BY created_at DESC", customerId);
    }

    public boolean adjustPoints(BigInteger customerId, BigInteger shopId, int points, String remark) {
        Record last = Db.findFirst("SELECT balance_after FROM points_records WHERE customer_id = ? ORDER BY created_at DESC LIMIT 1", customerId);
        int currentBalance = (last != null ? last.getInt("balance_after") : 0);
        int balanceAfter = currentBalance + points;
        Record r = new Record().set("shop_id", shopId != null ? shopId.intValue() : 0).set("customer_id", customerId)
                .set("type", 4).set("points", points).set("balance_after", balanceAfter)
                .set("source", "manual").set("remark", remark).set("created_at", new Date());
        return Db.save("points_records", r);
    }

    // ========== 删除 ==========
    public boolean delete(BigInteger customerId, BigInteger shopId) {
        return Db.tx(() -> {
            Record c = Db.findById("customers", customerId);
            if (c == null) return false;
            if (shopId != null && !shopId.equals(c.getBigInteger("shop_id"))) return false;

            Date now = new Date();
            Db.update("UPDATE customers SET is_deleted = 1, deleted_time = ? WHERE id = ?", now, customerId);
            Db.update("UPDATE customer_wallets SET is_deleted = 1, deleted_time = ? WHERE customer_id = ?", now, customerId);
            Db.update("UPDATE wallet_transactions SET is_deleted = 1, deleted_time = ? WHERE customer_id = ?", now, customerId);
            Db.update("UPDATE purchases SET is_deleted = 1, deleted_time = ? WHERE customer_id = ?", now, customerId);
            Db.update("UPDATE customer_sessions SET is_deleted = 1, deleted_time = ? WHERE customer_id = ?", now, customerId);
            Db.update("UPDATE game_sessions SET is_deleted = 1, deleted_time = ? WHERE customer_id = ?", now, customerId);
            Db.update("UPDATE points_records SET is_deleted = 1, deleted_time = ? WHERE customer_id = ?", now, customerId);
            Db.update("UPDATE coupon_usages SET is_deleted = 1, deleted_time = ? WHERE customer_id = ?", now, customerId);
            Db.update("UPDATE queue_entries SET is_deleted = 1, deleted_time = ? WHERE customer_id = ?", now, customerId);
            Db.update("UPDATE feedbacks SET is_deleted = 1, deleted_time = ? WHERE customer_id = ?", now, customerId);
            return true;
        });
    }
}
