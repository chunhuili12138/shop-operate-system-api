package com.shopoperate.app;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.shopoperate.marketing.CouponService;

import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.Date;

public class AppCustomerService {

    public static final AppCustomerService me = new AppCustomerService();

    /**
     * 绑定手机号并合并账号
     * 1. 根据 wechatOpenid 找到目标顾客（微信端账号）
     * 2. 根据 phone + shopId 查找源顾客（后台创建，无 wechat_openid）
     * 3. 迁移源顾客所有数据到目标顾客，删除源顾客
     */
    public boolean bindPhoneAndMerge(String wechatOpenid, String phone, BigInteger shopId) {
        return Db.tx(() -> {
            // 1. 查找目标顾客（微信端）
            Record target = Db.findFirst(
                "SELECT * FROM customers WHERE wechat_openid = ? AND shop_id = ? AND is_deleted = 0",
                wechatOpenid, shopId);
            if (target == null) return false;

            BigInteger targetId = target.getBigInteger("id");
            boolean targetHadPhone = target.getStr("phone") != null && !target.getStr("phone").isEmpty();

            // 2. 查找源顾客（后台创建，同手机号，无 openid）
            Record source = Db.findFirst(
                "SELECT * FROM customers WHERE phone = ? AND shop_id = ? AND wechat_openid IS NULL AND is_deleted = 0 AND id != ?",
                phone, shopId, targetId);

            // 3. 更新目标顾客手机号
            if (!targetHadPhone) {
                target.set("phone", phone);
                target.set("updated_at", new Date());
                Db.update("customers", target);
            }

            // 无源顾客则发放新人券 + 员工识别后返回
            if (source == null) {
                CouponService.me.autoGrantOnRegister(shopId, targetId);
                matchStaffByPhoneAndShop(wechatOpenid, phone, shopId);
                return true;
            }

            BigInteger sourceId = source.getBigInteger("id");

            // 4. 钱包累加合并
            Record targetWallet = Db.findFirst("SELECT * FROM customer_wallets WHERE customer_id = ?", targetId);
            Record sourceWallet = Db.findFirst("SELECT * FROM customer_wallets WHERE customer_id = ?", sourceId);

            if (targetWallet != null && sourceWallet != null) {
                BigDecimal targetBal = (BigDecimal) targetWallet.get("balance");
                BigDecimal sourceBal = (BigDecimal) sourceWallet.get("balance");
                BigDecimal targetRech = (BigDecimal) targetWallet.get("total_recharged");
                BigDecimal sourceRech = (BigDecimal) sourceWallet.get("total_recharged");
                BigDecimal targetSpent = (BigDecimal) targetWallet.get("total_spent");
                BigDecimal sourceSpent = (BigDecimal) sourceWallet.get("total_spent");

                targetWallet.set("balance", targetBal.add(sourceBal));
                targetWallet.set("total_recharged", targetRech.add(sourceRech));
                targetWallet.set("total_spent", targetSpent.add(sourceSpent));
                Db.update("customer_wallets", targetWallet);
            }

            // 5. 迁移所有关联表 customer_id
            BigInteger targetWalletId = targetWallet != null ? targetWallet.getBigInteger("id") : null;
            BigInteger sourceWalletId = sourceWallet != null ? sourceWallet.getBigInteger("id") : null;

            // wallet_transactions: 更新 customer_id + wallet_id
            if (targetWalletId != null) {
                Db.update("UPDATE wallet_transactions SET customer_id = ?, wallet_id = ? WHERE customer_id = ?",
                    targetId, targetWalletId, sourceId);
            }

            // purchases
            Db.update("UPDATE purchases SET customer_id = ? WHERE customer_id = ?", targetId, sourceId);

            // customer_sessions
            Db.update("UPDATE customer_sessions SET customer_id = ? WHERE customer_id = ?", targetId, sourceId);

            // game_sessions
            Db.update("UPDATE game_sessions SET customer_id = ? WHERE customer_id = ?", targetId, sourceId);

            // points_records
            Db.update("UPDATE points_records SET customer_id = ? WHERE customer_id = ?", targetId, sourceId);

            // coupon_usages
            Db.update("UPDATE coupon_usages SET customer_id = ? WHERE customer_id = ?", targetId, sourceId);

            // queue_entries
            Db.update("UPDATE queue_entries SET customer_id = ? WHERE customer_id = ?", targetId, sourceId);

            // feedbacks
            Db.update("UPDATE feedbacks SET customer_id = ? WHERE customer_id = ?", targetId, sourceId);

            // 6. 软删除源顾客和源钱包
            Date now = new Date();
            Db.update("UPDATE customers SET is_deleted = 1, deleted_time = ? WHERE id = ?", now, sourceId);
            if (sourceWalletId != null && !sourceWalletId.equals(targetWalletId)) {
                Db.update("UPDATE customer_wallets SET is_deleted = 1, deleted_time = ? WHERE id = ?", now, sourceWalletId);
            }

            // 7. 绑定手机后自动发放新人优惠券（per_user_limit 防重复）
            CouponService.me.autoGrantOnRegister(shopId, targetId);

            // 8. 正向员工自动识别
            matchStaffByPhoneAndShop(wechatOpenid, phone, shopId);

            return true;
        });
    }

    /**
     * 根据 wechatOpenid + shopId 查找已存在的顾客（微信端自动注册时使用）
     */
    public Record findByWechatOpenid(String wechatOpenid, BigInteger shopId) {
        return Db.findFirst(
            "SELECT * FROM customers WHERE wechat_openid = ? AND shop_id = ? AND is_deleted = 0",
            wechatOpenid, shopId);
    }

    /**
     * 微信小程序端自动注册新顾客
     */
    public Record registerByWechat(String wechatOpenid, String nickname, String avatarUrl, BigInteger shopId) {
        Date now = new Date();
        Record c = new Record()
            .set("shop_id", shopId)
            .set("wechat_openid", wechatOpenid)
            .set("nickname", nickname)
            .set("avatar_url", avatarUrl)
            .set("source", "miniapp")
            .set("is_deleted", 0)
            .set("created_at", now)
            .set("updated_at", now);
        Db.save("customers", c);
        BigInteger customerId = c.getBigInteger("id");

        Record w = new Record()
            .set("shop_id", shopId)
            .set("customer_id", customerId)
            .set("balance", BigDecimal.ZERO)
            .set("total_recharged", BigDecimal.ZERO)
            .set("total_spent", BigDecimal.ZERO);
        Db.save("customer_wallets", w);

        return c;
    }

    /**
     * 正向员工自动识别：同店铺内顾客 phone 匹配员工 phone → 写入 staff_accounts.wechat_openid
     */
    private void matchStaffByPhoneAndShop(String wechatOpenid, String phone, BigInteger shopId) {
        if (phone == null || phone.isEmpty()) return;
        Record matchedStaff = Db.findFirst(
            "SELECT s.* FROM staff s " +
            "INNER JOIN staff_shops ss ON s.id = ss.staff_id " +
            "WHERE s.phone = ? AND ss.shop_id = ? AND s.is_deleted = 0 AND s.status = 1 LIMIT 1",
            phone, shopId);
        if (matchedStaff != null) {
            Db.update(
                "UPDATE staff_accounts SET wechat_openid = ? WHERE staff_id = ? AND wechat_openid IS NULL",
                wechatOpenid, matchedStaff.getBigInteger("id"));
        }
    }
}
