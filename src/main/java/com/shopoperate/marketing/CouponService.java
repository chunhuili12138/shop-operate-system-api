package com.shopoperate.marketing;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;

import java.math.BigInteger;
import java.util.Date;
import java.util.List;

public class CouponService {

    public static final CouponService me = new CouponService();

    /** 新人注册自动发放：遍历 auto_grant_on_register=1 的券，检查 per_user_limit 后发放 */
    public void autoGrantOnRegister(BigInteger shopId, BigInteger customerId) {
        List<Record> coupons = Db.find(
            "SELECT * FROM coupons WHERE shop_id=? AND is_active=1 AND is_deleted=0 AND auto_grant_on_register=1", shopId);
        for (Record coupon : coupons) {
            int limit = coupon.getInt("per_user_limit");
            if (limit > 0) {
                long already = Db.queryLong(
                    "SELECT COUNT(*) FROM coupon_usages WHERE customer_id=? AND coupon_id=? AND is_deleted=0", customerId, coupon.getBigInteger("id"));
                if (already >= limit) continue;
            }
            int validDays = coupon.getInt("valid_days");
            BigInteger couponId = coupon.getBigInteger("id");
            Db.tx(() -> {
                Record locked = Db.findFirst("SELECT id, remain_stock FROM coupons WHERE id=? AND shop_id=? FOR UPDATE", couponId, shopId);
                if (locked == null || locked.getInt("remain_stock") < 1) return false;
                Db.save("coupon_usages", new Record().set("shop_id", shopId).set("coupon_id", couponId)
                    .set("customer_id", customerId).set("status", 1)
                    .set("received_at", new Date())
                    .set("expires_at", new Date(System.currentTimeMillis() + validDays * 86400000L)));
                locked.set("remain_stock", locked.getInt("remain_stock") - 1);
                return Db.update("coupons", locked);
            });
        }
    }
}
