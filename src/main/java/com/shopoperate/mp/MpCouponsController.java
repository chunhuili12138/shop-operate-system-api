package com.shopoperate.mp;

import com.jfinal.core.Controller;
import com.jfinal.core.Path;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.shopoperate.common.annotation.MethodValidation;
import com.shopoperate.common.annotation.RequireLogin;
import com.shopoperate.utils.ApiReturn;
import org.apache.log4j.Logger;
import java.math.BigInteger;
import java.util.*;

@Path(value = "/api/mp/coupons")
public class MpCouponsController extends Controller {
    private static final Logger log = Logger.getLogger(MpCouponsController.class);
    @RequireLogin @MethodValidation("GET")
    public void my() {
        BigInteger customerId = MpHelper.getCustomerId(this);
        if (customerId == null) { renderJson(new ApiReturn().loginInvalid()); return; }
        String status = getPara("status");
        try {
            StringBuilder w = new StringBuilder("WHERE cu.customer_id = ? AND cu.is_deleted = 0");
            List<Object> ps = new ArrayList<>(); ps.add(customerId);
            if (status != null && !status.isEmpty()) { w.append(" AND cu.status = ?"); ps.add(Integer.parseInt(status)); }
            List<Record> list = Db.find("SELECT cu.*, c.name AS coupon_name, c.type AS coupon_type, c.value, c.min_order_amount, c.valid_days " +
                "FROM coupon_usages cu LEFT JOIN coupons c ON cu.coupon_id = c.id " + w + " ORDER BY cu.received_at DESC", ps.toArray());
            List<Map<String, Object>> result = new ArrayList<>();
            for (Record r : list) {
                Map<String, Object> m = new HashMap<>();
                m.put("id", r.getBigInteger("id")); m.put("couponId", r.getBigInteger("coupon_id"));
                m.put("couponName", r.getStr("coupon_name")); m.put("type", r.getInt("coupon_type"));
                m.put("value", r.getBigDecimal("value")); m.put("minOrderAmount", r.getBigDecimal("min_order_amount"));
                m.put("status", r.getInt("status")); m.put("expiresAt", r.getDate("expires_at")); result.add(m);
            }
            renderJson(new ApiReturn().addData("list", result).addData("total", result.size()).success());
        } catch (Exception e) { log.error("优惠券异常", e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }
}
