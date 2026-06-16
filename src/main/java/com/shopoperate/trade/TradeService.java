package com.shopoperate.trade;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

public class TradeService {
    public static final TradeService me = new TradeService();

    // ========== Purchases ==========
    public Page<Record> purchasePage(int pn, int ps, BigInteger customerId, String keyword, String channel,
                                      String status, String startDate, String endDate, BigInteger shopId) {
        StringBuilder sb = new StringBuilder(" FROM purchases p LEFT JOIN packages pk ON p.package_id=pk.id LEFT JOIN customers c ON p.customer_id=c.id WHERE p.is_deleted=0");
        if (shopId != null) sb.append(" AND p.shop_id=").append(shopId);
        if (customerId != null) sb.append(" AND p.customer_id=").append(customerId);
        if (keyword != null) sb.append(" AND (c.nickname LIKE '%").append(keyword.replace("'","''")).append("%' OR pk.name LIKE '%").append(keyword.replace("'","''")).append("%')");
        if (channel != null) sb.append(" AND p.channel='").append(channel.replace("'","''")).append("'");
        if (status != null) sb.append(" AND p.status=").append(status);
        if (startDate != null) sb.append(" AND p.created_at>='").append(startDate).append("'");
        if (endDate != null) sb.append(" AND p.created_at<='").append(endDate).append(" 23:59:59'");
        sb.append(" ORDER BY p.created_at DESC");
        return Db.paginate(pn, ps, "SELECT p.*, pk.name AS package_name, c.nickname AS customer_name", sb.toString());
    }

    public String addPurchase(BigInteger shopId, BigInteger customerId, BigInteger packageId, String channel,
                                String paymentMethod, BigDecimal totalAmount, BigDecimal paidAmount,
                                String thirdPartyCouponCode, BigInteger couponUsageId,
                                String remark, BigInteger operatorId,
                                String paymentType, String ipAddress) {
        final String[] err = {null};
        Db.tx(() -> {
            Record pkg = Db.findById("packages", packageId);
            if (pkg == null) { err[0] = "套餐不存在"; return false; }
            if (pkg.getInt("is_active") != null && pkg.getInt("is_active") != 1) { err[0] = "套餐已下架"; return false; }
            if (totalAmount == null || totalAmount.compareTo(BigDecimal.ZERO) <= 0) { err[0] = "金额无效"; return false; }
            String type = pkg.getStr("type");
            Date now = new Date();
            String pt = paymentType != null ? paymentType : "direct";

            // 1. 系统优惠券: 校验 + 核销 + 计算抵扣金额（仅 direct/wallet 支付模式）
            BigDecimal couponDiscount = BigDecimal.ZERO;
            if (!"coupon".equals(pt) && couponUsageId != null) {
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
                if (!"purchase".equals(coupon.getStr("use_scene"))) { err[0] = "该优惠券不适用于购买套餐"; return false; }
                BigDecimal minOrder = coupon.getBigDecimal("min_order_amount");
                if (minOrder != null && minOrder.compareTo(BigDecimal.ZERO) > 0 && totalAmount.compareTo(minOrder) < 0) {
                    err[0] = "订单金额不满足优惠券最低消费要求（需≥" + minOrder + "元）"; return false;
                }
                int perLimit = coupon.getInt("per_user_limit");
                if (perLimit > 0) {
                    long usedCount = Db.queryLong("SELECT COUNT(*) FROM coupon_usages WHERE customer_id=? AND coupon_id=? AND status=2 AND is_deleted=0", customerId, coupon.getBigInteger("id"));
                    if (usedCount >= perLimit) { err[0] = "该优惠券已达到每人使用上限"; return false; }
                }
                int ctype = coupon.getInt("type");
                BigDecimal cvalue = coupon.getBigDecimal("value");
                if (ctype == 1) couponDiscount = cvalue.min(totalAmount);
                else if (ctype == 2) couponDiscount = totalAmount.multiply(cvalue).divide(new BigDecimal("100"), 2, BigDecimal.ROUND_HALF_UP).min(totalAmount);
                else if (ctype == 3) couponDiscount = totalAmount;
                usage.set("status", 2).set("used_at", now);
                Db.update("coupon_usages", usage);
            }

            // 2. 储值钱包: 检查余额并扣减（扣减金额 = totalAmount - couponDiscount）
            BigDecimal walletBalanceBefore = BigDecimal.ZERO;
            BigDecimal walletBalanceAfter = BigDecimal.ZERO;
            if ("wallet".equals(pt)) {
                BigDecimal walletDeduct = totalAmount.subtract(couponDiscount);
                if (walletDeduct.compareTo(BigDecimal.ZERO) < 0) walletDeduct = BigDecimal.ZERO;
                Record wallet = Db.findFirst("SELECT * FROM customer_wallets WHERE customer_id=? AND shop_id=? AND is_deleted=0 FOR UPDATE", customerId, shopId);
                if (wallet == null) { err[0] = "钱包不存在"; return false; }
                BigDecimal balance = wallet.getBigDecimal("balance");
                if (balance.compareTo(walletDeduct) < 0) { err[0] = "钱包余额不足"; return false; }
                walletBalanceBefore = balance;
                walletBalanceAfter = balance.subtract(walletDeduct);
                wallet.set("balance", walletBalanceAfter);
                BigDecimal spent = wallet.getBigDecimal("total_spent");
                wallet.set("total_spent", (spent != null ? spent : BigDecimal.ZERO).add(walletDeduct));
                wallet.set("updated_at", now);
                Db.update("customer_wallets", wallet);
                Db.save("wallet_transactions", new Record().set("wallet_id", wallet.getBigInteger("id"))
                    .set("shop_id", shopId).set("customer_id", customerId)
                    .set("type", 2).set("amount", walletDeduct).set("balance_after", walletBalanceAfter)
                    .set("reference_type", "purchase").set("remark", "购买套餐扣款")
                    .set("is_deleted", 0).set("created_at", now));
            }

            // 3. 第三方券码: 写入核销日志
            if ("coupon".equals(pt) && thirdPartyCouponCode != null && !thirdPartyCouponCode.isEmpty()) {
                long dup = Db.queryLong("SELECT COUNT(*) FROM coupon_verification_logs WHERE third_party_coupon_code=?", thirdPartyCouponCode);
                if (dup > 0) { err[0] = "该第三方券码已被核销"; return false; }
                Db.save("coupon_verification_logs", new Record().set("shop_id", shopId)
                    .set("third_party_coupon_code", thirdPartyCouponCode).set("channel", channel)
                    .set("operation", 2).set("result", 1).set("operator_staff_id", operatorId)
                    .set("is_deleted", 0).set("created_at", now));
            }

            // 4. 保存购买记录
            BigDecimal finalPaid = totalAmount.subtract(couponDiscount);
            if ("wallet".equals(pt)) {
                // 钱包已扣，paid_amount = totalAmount - couponDiscount
            } else if ("direct".equals(pt)) {
                // 直接付款：以传入的 paidAmount 为准（前端已算好优惠后金额）
                finalPaid = paidAmount != null ? paidAmount : finalPaid;
            }
            Record purchase = new Record().set("shop_id", shopId).set("customer_id", customerId)
                .set("package_id", packageId).set("purchase_type", "purchase")
                .set("channel", channel != null ? channel : "store")
                .set("third_party_coupon_code", thirdPartyCouponCode)
                .set("coupon_usage_id", couponUsageId)
                .set("start_date", new java.sql.Date(now.getTime()))
                .set("total_amount", totalAmount)
                .set("coupon_discount", couponDiscount)
                .set("paid_amount", "wallet".equals(pt) ? finalPaid : finalPaid)
                .set("payment_method", "wallet".equals(pt) ? "wallet" : paymentMethod).set("status", 1)
                .set("operator_staff_id", operatorId).set("remark", remark)
                .set("is_deleted", 0).set("created_at", now).set("updated_at", now);
            Db.save("purchases", purchase);
            BigInteger purchaseId = purchase.getBigInteger("id");

            // 5. 回填 coupon_usages.used_in_purchase_id
            if (couponUsageId != null && couponDiscount.compareTo(BigDecimal.ZERO) > 0) {
                Db.update("UPDATE coupon_usages SET used_in_purchase_id=? WHERE id=?", purchaseId, couponUsageId);
            }

            // 6. 填写 prepayments 预收款
            BigDecimal prepayAfter = "wallet".equals(pt) ? walletBalanceAfter : totalAmount;
            Db.save("prepayments", new Record().set("shop_id", shopId).set("purchase_id", purchaseId)
                .set("amount", totalAmount).set("balance_before", walletBalanceBefore)
                .set("balance_after", prepayAfter).set("is_deleted", 0).set("created_at", now));

            // 7. 为券码流水回填 purchase_id
            if ("coupon".equals(pt) && thirdPartyCouponCode != null && !thirdPartyCouponCode.isEmpty()) {
                Db.update("UPDATE coupon_verification_logs SET purchase_id=? WHERE third_party_coupon_code=? AND shop_id=? ORDER BY id DESC LIMIT 1", purchaseId, thirdPartyCouponCode, shopId);
            }

            // 8. 生成 customer_sessions
            int sessionCount = "WEEKLY".equals(type) ? 7 : "MONTHLY".equals(type) ? 30 : 1;
            Calendar cal = Calendar.getInstance();
            for (int i = 0; i < sessionCount; i++) {
                cal.setTime(now);
                cal.add(Calendar.DAY_OF_YEAR, i);
                Db.save("customer_sessions", new Record().set("shop_id", shopId).set("customer_id", customerId)
                    .set("purchase_id", purchaseId).set("session_date", new java.sql.Date(cal.getTimeInMillis()))
                    .set("status", 1).set("created_at", now));
            }

            // 9. 操作日志
            String actionDesc = "direct".equals(pt) ? "直接付款" : "wallet".equals(pt) ? "储值钱包" : "第三方券码";
            String detail = "{\"packageId\":" + packageId + ",\"amount\":" + totalAmount + ",\"couponDiscount\":" + couponDiscount + "}";
            Db.save("operation_logs", new Record().set("shop_id", shopId).set("operator_id", operatorId)
                .set("operator_type", 1).set("action", actionDesc + "购买").set("target_type", "purchase")
                .set("target_id", purchaseId)
                .set("detail", detail)
                .set("ip_address", ipAddress)
                .set("created_at", now));

            return true;
        });
        return err[0];
    }

    // ========== Game Sessions ==========
    public List<Record> availableSessions(BigInteger customerId, BigInteger loginShopId) {
        StringBuilder sb = new StringBuilder("SELECT cs.*, pk.name AS package_name FROM customer_sessions cs " +
            "LEFT JOIN purchases p ON cs.purchase_id=p.id LEFT JOIN packages pk ON p.package_id=pk.id " +
            "WHERE cs.customer_id=? AND cs.status=1 AND cs.session_date <= CURDATE() AND cs.is_deleted=0 AND p.is_deleted=0 AND p.status=1");
        if (loginShopId != null) sb.append(" AND cs.shop_id=").append(loginShopId);
        sb.append(" ORDER BY cs.session_date");
        return Db.find(sb.toString(), customerId);
    }

    public boolean checkin(BigInteger customerId, BigInteger customerSessionId, BigInteger staffId, BigInteger loginShopId) {
        return Db.tx(() -> {
            Record cs = Db.findById("customer_sessions", customerSessionId);
            if (cs == null || cs.getInt("status") != 1) return false;
            if (!customerId.equals(cs.getBigInteger("customer_id"))) return false;
            if (loginShopId != null && !loginShopId.equals(cs.getBigInteger("shop_id"))) return false;
            java.util.Date sessionDate = cs.getDate("session_date");
            if (sessionDate != null && sessionDate.after(new java.sql.Date(System.currentTimeMillis()))) return false;

            cs.set("status", 2).set("used_at", new Date());
            Db.update("customer_sessions", cs);

            Record gs = new Record().set("shop_id",cs.get("shop_id")).set("customer_id",customerId)
                .set("customer_session_id",customerSessionId).set("staff_id",staffId)
                .set("start_time",new Date()).set("status",1).set("is_deleted",0).set("created_at",new Date());
            Db.save("game_sessions", gs);

            cs.set("game_session_id", gs.getBigInteger("id"));
            Db.update("customer_sessions", cs);
            return true;
        });
    }

    public Page<Record> gameSessionList(BigInteger customerId, String status, String startDate, String endDate, String keyword, int pn, int ps, BigInteger shopId) {
        StringBuilder sb = new StringBuilder(" FROM game_sessions gs LEFT JOIN customers c ON gs.customer_id=c.id LEFT JOIN staff s ON gs.staff_id=s.id LEFT JOIN customer_sessions cs ON gs.customer_session_id=cs.id LEFT JOIN purchases p ON cs.purchase_id=p.id LEFT JOIN packages pk ON p.package_id=pk.id WHERE 1=1");
        if (customerId != null) sb.append(" AND gs.customer_id=").append(customerId);
        if (status != null) sb.append(" AND gs.status=").append(status);
        if (startDate != null) sb.append(" AND gs.start_time>='").append(startDate).append("'");
        if (endDate != null) sb.append(" AND gs.start_time<='").append(endDate).append(" 23:59:59'");
        if (keyword != null && !keyword.isEmpty()) sb.append(" AND (c.nickname LIKE '%").append(keyword.replace("'","''")).append("%' OR c.phone LIKE '%").append(keyword.replace("'","''")).append("%')");
        if (shopId != null) sb.append(" AND gs.shop_id=").append(shopId);
        sb.append(" ORDER BY gs.created_at DESC");
        return Db.paginate(pn, ps, "SELECT gs.*, c.nickname AS customer_name, s.name AS staff_name, pk.name AS package_name, pk.duration_minutes", sb.toString());
    }

    public boolean finish(BigInteger gameSessionId, BigInteger loginShopId) {
        return Db.tx(() -> {
            Record gs = Db.findById("game_sessions", gameSessionId);
            if (gs == null || gs.getInt("status") != 1) return false;
            if (loginShopId != null && !loginShopId.equals(gs.getBigInteger("shop_id"))) return false;
            Date now = new Date();
            gs.set("end_time", now).set("status", 2);
            Db.update("game_sessions", gs);

            BigInteger shopId = gs.getBigInteger("shop_id");
            BigInteger staffId = gs.getBigInteger("staff_id");
            Record cs = Db.findById("customer_sessions", gs.getBigInteger("customer_session_id"));
            if (cs != null) {
                Record purchase = Db.findById("purchases", cs.getBigInteger("purchase_id"));
                if (purchase != null) {
                    long totalSessions = Db.queryLong("SELECT COUNT(*) FROM customer_sessions WHERE purchase_id=? AND is_deleted=0", purchase.getBigInteger("id"));
                    BigDecimal unitPrice = totalSessions > 0
                        ? ((BigDecimal)purchase.get("total_amount")).divide(BigDecimal.valueOf(totalSessions), BigDecimal.ROUND_HALF_UP)
                        : BigDecimal.ZERO;
                    Db.save("revenue_records", new Record().set("shop_id", shopId)
                        .set("game_session_id", gameSessionId).set("purchase_id", purchase.getBigInteger("id"))
                        .set("customer_id", purchase.getBigInteger("customer_id"))
                        .set("payment_method", purchase.getStr("payment_method"))
                        .set("amount", unitPrice).set("confirmed_at", now).set("confirmed_by", staffId)
                        .set("created_at", now));

                    // BOM 扣库存
                    BigInteger packageId = purchase.getBigInteger("package_id");
                    List<Record> boms = Db.find("SELECT pb.*, m.min_stock, m.name AS material_name FROM package_bom pb JOIN materials m ON pb.material_id=m.id AND m.is_deleted=0 WHERE pb.package_id=? AND pb.is_deleted=0", packageId);
                    for (Record bom : boms) {
                        BigInteger materialId = bom.getBigInteger("material_id");
                        BigDecimal qty = bom.getBigDecimal("quantity");
                        Record inv = Db.findFirst("SELECT * FROM inventory WHERE shop_id=? AND material_id=? AND is_deleted=0 FOR UPDATE", shopId, materialId);
                        if (inv != null) {
                            BigDecimal invBefore = inv.getBigDecimal("quantity");
                            BigDecimal after = invBefore.subtract(qty);
                            boolean overConsumed = after.compareTo(BigDecimal.ZERO) < 0;
                            inv.set("quantity", overConsumed ? BigDecimal.ZERO : after);
                            inv.set("updated_at", now);
                            Db.update("inventory", inv);
                            Db.save("inventory_transactions", new Record().set("shop_id", shopId).set("material_id", materialId)
                                .set("transaction_type", 2).set("quantity", qty)
                                .set("balance_after", inv.getBigDecimal("quantity"))
                                .set("reference_type", "game_session").set("reference_id", gameSessionId)
                                .set("operator_staff_id", staffId).set("remark", "游玩核销消耗")
                                .set("is_deleted", 0).set("created_at", now));
                            // 超额消耗提醒
                            if (overConsumed) {
                                List<Record> warnStaff = Db.find("SELECT sr.staff_id FROM staff_roles sr JOIN staff_shops ss ON sr.staff_id=ss.staff_id INNER JOIN staff s ON sr.staff_id=s.id WHERE sr.role_id IN (3,5) AND ss.shop_id=? AND s.status=1 AND s.is_deleted=0", shopId);
                                // 补充店铺老板
                                Record boss = Db.findFirst("SELECT sr.staff_id FROM staff_roles sr INNER JOIN staff s ON sr.staff_id=s.id INNER JOIN shops sh ON sh.owner_staff_id=s.id WHERE sr.role_id IN (3,5) AND sh.id=? AND s.status=1 AND s.is_deleted=0", shopId);
                                if (boss != null) { boolean found = false; for (Record r : warnStaff) { if (r.getBigInteger("staff_id").equals(boss.getBigInteger("staff_id"))) { found = true; break; } } if (!found) warnStaff.add(boss); }
                                for (Record ws : warnStaff) {
                                    Db.save("notification_logs", new Record().set("shop_id", shopId)
                                        .set("recipient_type", 2).set("recipient_id", ws.getBigInteger("staff_id"))
                                        .set("channel", 3).set("title", "库存超额消耗")
                                        .set("content", "物料 " + bom.getStr("material_name") + " 超额消耗！消耗:" + qty + " 原有:" + invBefore + " 差额:" + after.abs())
                                        .set("status", 1).set("created_at", now));
                                }
                            }
                            // 库存预警
                            BigDecimal minStock = bom.getBigDecimal("min_stock");
                            if (!overConsumed && minStock != null && inv.getBigDecimal("quantity").compareTo(minStock) <= 0) {
                                List<Record> warnStaff = Db.find("SELECT sr.staff_id FROM staff_roles sr JOIN staff_shops ss ON sr.staff_id=ss.staff_id INNER JOIN staff s ON sr.staff_id=s.id WHERE sr.role_id IN (3,5) AND ss.shop_id=? AND s.status=1 AND s.is_deleted=0", shopId);
                                // 补充店铺老板
                                Record boss = Db.findFirst("SELECT sr.staff_id FROM staff_roles sr INNER JOIN staff s ON sr.staff_id=s.id INNER JOIN shops sh ON sh.owner_staff_id=s.id WHERE sr.role_id IN (3,5) AND sh.id=? AND s.status=1 AND s.is_deleted=0", shopId);
                                if (boss != null) { boolean found = false; for (Record r : warnStaff) { if (r.getBigInteger("staff_id").equals(boss.getBigInteger("staff_id"))) { found = true; break; } } if (!found) warnStaff.add(boss); }
                                for (Record ws : warnStaff) {
                                    Db.save("notification_logs", new Record().set("shop_id", shopId)
                                        .set("recipient_type", 2).set("recipient_id", ws.getBigInteger("staff_id"))
                                        .set("channel", 3).set("title", "库存预警")
                                        .set("content", "物料 " + bom.getStr("material_name") + " 库存不足，当前:" + inv.getBigDecimal("quantity") + " 预警线:" + minStock)
                                        .set("status", 1).set("created_at", now));
                                }
                            }
                        }
                    }
                }
            }
            return true;
        });
    }

    public Record gameSessionInfo(BigInteger id, BigInteger shopId) {
        String sql = "SELECT gs.*, c.nickname AS customer_name, c.phone AS customer_phone, " +
            "s.name AS staff_name, pk.name AS package_name FROM game_sessions gs " +
            "LEFT JOIN customers c ON gs.customer_id=c.id LEFT JOIN staff s ON gs.staff_id=s.id " +
            "LEFT JOIN customer_sessions cs ON gs.customer_session_id=cs.id " +
            "LEFT JOIN purchases p ON cs.purchase_id=p.id LEFT JOIN packages pk ON p.package_id=pk.id WHERE gs.id=?";
        if (shopId != null) sql += " AND gs.shop_id=" + shopId;
        return Db.findFirst(sql, id);
    }

    public List<Record> purchaseSessionList(BigInteger purchaseId, BigInteger loginShopId) {
        StringBuilder sb = new StringBuilder("SELECT cs.*, pk.name AS package_name FROM customer_sessions cs " +
            "LEFT JOIN purchases p ON cs.purchase_id=p.id LEFT JOIN packages pk ON p.package_id=pk.id " +
            "WHERE cs.purchase_id=? AND cs.is_deleted=0");
        if (loginShopId != null) sb.append(" AND cs.shop_id=").append(loginShopId);
        sb.append(" ORDER BY cs.session_date");
        return Db.find(sb.toString(), purchaseId);
    }

    // ========== Refunds ==========
    public Page<Record> refundPage(int pn, int ps, String keyword, String status, String startDate, String endDate, BigInteger shopId) {
        StringBuilder sb = new StringBuilder(" FROM refund_records rr LEFT JOIN purchases p ON rr.purchase_id=p.id LEFT JOIN customers c ON p.customer_id=c.id WHERE 1=1");
        if (shopId != null) sb.append(" AND rr.shop_id=").append(shopId);
        if (keyword != null) sb.append(" AND c.nickname LIKE '%").append(keyword.replace("'","''")).append("%'");
        if (status != null) sb.append(" AND rr.status=").append(status);
        if (startDate != null) sb.append(" AND rr.created_at>='").append(startDate).append("'");
        if (endDate != null) sb.append(" AND rr.created_at<='").append(endDate).append(" 23:59:59'");
        sb.append(" ORDER BY rr.created_at DESC");
        return Db.paginate(pn, ps, "SELECT rr.*, p.total_amount AS purchase_amount, p.payment_method, c.nickname AS customer_name", sb.toString());
    }

    public Record refundPreview(BigInteger purchaseId, BigInteger loginShopId) {
        StringBuilder sb = new StringBuilder("SELECT p.*, pk.name AS package_name FROM purchases p LEFT JOIN packages pk ON p.package_id=pk.id WHERE p.id=? AND p.is_deleted=0");
        if (loginShopId != null) sb.append(" AND p.shop_id=").append(loginShopId);
        Record purchase = Db.findFirst(sb.toString(), purchaseId);
        if (purchase == null) return null;
        long total = Db.queryLong("SELECT COUNT(*) FROM customer_sessions WHERE purchase_id=? AND is_deleted=0", purchaseId);
        long used = Db.queryLong("SELECT COUNT(*) FROM customer_sessions WHERE purchase_id=? AND status=2 AND is_deleted=0", purchaseId);
        long expired = Db.queryLong("SELECT COUNT(*) FROM customer_sessions WHERE purchase_id=? AND status=3 AND is_deleted=0", purchaseId);
        long remaining = total - used - expired;
        BigDecimal paidAmount = purchase.getBigDecimal("paid_amount");
        if (paidAmount == null) paidAmount = BigDecimal.ZERO;
        BigDecimal suggestedAmount = total > 0
            ? paidAmount.multiply(BigDecimal.valueOf(remaining)).divide(BigDecimal.valueOf(total), BigDecimal.ROUND_HALF_UP)
            : BigDecimal.ZERO;
        Record r = new Record();
        r.set("purchase_id", purchaseId);
        r.set("total_sessions", (int)total);
        r.set("used_sessions", (int)used);
        r.set("expired_sessions", (int)expired);
        r.set("remaining_sessions", (int)remaining);
        r.set("suggested_amount", suggestedAmount);
        r.set("paid_amount", paidAmount != null ? paidAmount : BigDecimal.ZERO);
        r.set("total_amount", purchase.getBigDecimal("total_amount"));
        r.set("package_name", purchase.getStr("package_name"));
        return r;
    }

    public boolean applyRefund(BigInteger purchaseId, String reason, BigDecimal refundAmount, BigInteger loginShopId) {
        return Db.tx(() -> {
            Record purchase = Db.findFirst("SELECT * FROM purchases WHERE id=? AND is_deleted=0", purchaseId);
            if (purchase == null || purchase.getInt("status") != 1) return false;
            if (loginShopId != null && !loginShopId.equals(purchase.getBigInteger("shop_id"))) return false;
            // 防止重复申请：检查是否已有处理中(1)的退款单
            long pendingRefund = Db.queryLong("SELECT COUNT(*) FROM refund_records WHERE purchase_id=? AND status=1 AND is_deleted=0", purchaseId);
            if (pendingRefund > 0) return false;
            BigDecimal paidAmount = purchase.getBigDecimal("paid_amount");
            if (paidAmount == null) paidAmount = BigDecimal.ZERO;
            if (refundAmount == null || refundAmount.compareTo(BigDecimal.ZERO) < 0 || refundAmount.compareTo(paidAmount) > 0)
                return false;
            long total = Db.queryLong("SELECT COUNT(*) FROM customer_sessions WHERE purchase_id=? AND is_deleted=0", purchaseId);
            long used = Db.queryLong("SELECT COUNT(*) FROM customer_sessions WHERE purchase_id=? AND status=2 AND is_deleted=0", purchaseId);
            long expired = Db.queryLong("SELECT COUNT(*) FROM customer_sessions WHERE purchase_id=? AND status=3 AND is_deleted=0", purchaseId);
            long remaining = total - used - expired;
            BigDecimal suggestedAmount = total > 0
                ? paidAmount.multiply(BigDecimal.valueOf(remaining)).divide(BigDecimal.valueOf(total), BigDecimal.ROUND_HALF_UP)
                : BigDecimal.ZERO;
            BigDecimal deductedAmount = suggestedAmount.subtract(refundAmount);
            Db.save("refund_records", new Record().set("shop_id",purchase.get("shop_id")).set("purchase_id",purchaseId)
                .set("refund_amount",refundAmount).set("reason",reason)
                .set("deducted_amount", deductedAmount.compareTo(BigDecimal.ZERO) > 0 ? deductedAmount : BigDecimal.ZERO)
                .set("refund_prepay_amount",BigDecimal.ZERO).set("refund_wallet_amount",BigDecimal.ZERO)
                .set("refunded_sessions",(int)remaining).set("status",1).set("created_at",new Date()).set("updated_at",new Date()));
            purchase.set("status", 2).set("updated_at", new Date());
            Db.update("purchases", purchase);
            Db.update("UPDATE customer_sessions SET status=4 WHERE purchase_id=? AND status=1", purchaseId);
            return true;
        });
    }

    public boolean approveRefund(BigInteger refundId, BigInteger operatorId, String ipAddress, BigInteger loginShopId) {
        return Db.tx(() -> {
            Record rr = Db.findFirst("SELECT * FROM refund_records WHERE id=? AND is_deleted=0", refundId);
            if (rr == null || rr.getInt("status") != 1) return false;
            if (loginShopId != null && !loginShopId.equals(rr.getBigInteger("shop_id"))) return false;
            Date now = new Date();
            BigInteger purchaseId = rr.getBigInteger("purchase_id");
            Record purchase = Db.findFirst("SELECT * FROM purchases WHERE id=? AND is_deleted=0", purchaseId);
            if (purchase == null) return false;
            BigDecimal refundAmount = rr.getBigDecimal("refund_amount");
            BigInteger customerId = purchase.getBigInteger("customer_id");
            BigInteger shopId = purchase.getBigInteger("shop_id");

            // 储值钱包退款
            if ("wallet".equals(purchase.getStr("payment_method"))) {
                Record wallet = Db.findFirst("SELECT * FROM customer_wallets WHERE customer_id=? AND shop_id=? AND is_deleted=0 FOR UPDATE", customerId, shopId);
                if (wallet != null) {
                    BigDecimal balanceBefore = wallet.getBigDecimal("balance");
                    BigDecimal balanceAfter = balanceBefore.add(refundAmount);
                    wallet.set("balance", balanceAfter);
                    BigDecimal spent = wallet.getBigDecimal("total_spent");
                    wallet.set("total_spent", (spent != null ? spent : BigDecimal.ZERO).subtract(refundAmount));
                    wallet.set("updated_at", now);
                    Db.update("customer_wallets", wallet);
                    Db.save("wallet_transactions", new Record().set("wallet_id", wallet.getBigInteger("id"))
                        .set("shop_id", shopId).set("customer_id", customerId)
                        .set("type", 3).set("amount", refundAmount).set("balance_after", balanceAfter)
                        .set("reference_type", "refund").set("reference_id", refundId)
                        .set("remark", "退款返还").set("is_deleted", 0).set("created_at", now));
                    rr.set("refund_wallet_amount", refundAmount);
                }
            }

            // 预收款冲销
            List<Record> prepays = Db.find("SELECT * FROM prepayments WHERE purchase_id=? AND is_deleted=0", purchaseId);
            for (Record pp : prepays) {
                pp.set("balance_after", BigDecimal.ZERO).set("is_deleted", 1);
                Db.update("prepayments", pp);
            }
            rr.set("refund_prepay_amount", refundAmount);

            rr.set("status", 2).set("operated_by", operatorId).set("updated_at", now);
            Db.update("refund_records", rr);

            // 生成退款负收入记录（冲减收入，金额为负数）
            Record negRev = new Record().set("shop_id", shopId).set("game_session_id", BigInteger.ZERO)
                .set("purchase_id", purchaseId).set("customer_id", customerId)
                .set("payment_method", purchase.getStr("payment_method"))
                .set("amount", refundAmount.negate()).set("confirmed_at", now).set("confirmed_by", operatorId)
                .set("created_at", now);
            Db.save("revenue_records", negRev);
            rr.set("revenue_id", negRev.getBigInteger("id"));
            Db.update("refund_records", rr);

            // 退款支出记录（退款金额作为支出）
            Record refundExp = new Record().set("shop_id", shopId)
                .set("category_id", Db.queryLong("SELECT id FROM expense_categories WHERE shop_id=? AND name='退款支出' LIMIT 1", shopId))
                .set("amount", refundAmount).set("payment_method", purchase.getStr("payment_method"))
                .set("expense_date", new java.sql.Date(now.getTime()))
                .set("source_type", "refund").set("source_id", refundId)
                .set("operator_staff_id", operatorId)
                .set("remark", "退款-" + (purchase.getStr("remark") != null ? purchase.getStr("remark") : ""))
                .set("created_at", now);
            if (refundExp.getBigInteger("category_id") == null) {
                refundExp.set("category_id", BigInteger.ZERO);
            }
            Db.save("expenses", refundExp);

            // 操作日志
            Db.save("operation_logs", new Record().set("shop_id", shopId).set("operator_id", operatorId)
                .set("operator_type", 1).set("action", "确认退款").set("target_type", "refund")
                .set("target_id", refundId).set("detail", "{\"purchaseId\":" + purchaseId + ",\"amount\":" + refundAmount + "}")
                .set("ip_address", ipAddress)
                .set("created_at", now));

            return true;
        });
    }

    public boolean rejectRefund(BigInteger refundId, String reason, BigInteger loginShopId) {
        return Db.tx(() -> {
            Record rr = Db.findById("refund_records", refundId);
            if (rr == null || rr.getInt("status") != 1) return false;
            if (loginShopId != null && !loginShopId.equals(rr.getBigInteger("shop_id"))) return false;
            rr.set("status", 3).set("reason", reason).set("updated_at", new Date());
            Db.update("refund_records", rr);
            BigInteger pid = rr.getBigInteger("purchase_id");
            Record p = Db.findById("purchases", pid);
            if (p != null) { p.set("status", 1); Db.update("purchases", p); }
            Db.update("UPDATE customer_sessions SET status=1 WHERE purchase_id=? AND status=4", pid);
            return true;
        });
    }
}
