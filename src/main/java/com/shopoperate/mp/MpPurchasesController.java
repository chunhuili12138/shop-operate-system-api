package com.shopoperate.mp;

import com.jfinal.core.Controller;
import com.jfinal.core.Path;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.shopoperate.common.annotation.MethodValidation;
import com.shopoperate.common.annotation.RequireLogin;
import com.shopoperate.utils.ApiReturn;
import org.apache.log4j.Logger;
import java.math.BigInteger;
import java.util.*;

@Path(value = "/api/mp/purchases")
public class MpPurchasesController extends Controller {
    private static final Logger log = Logger.getLogger(MpPurchasesController.class);
    @RequireLogin @MethodValidation("GET")
    public void list() {
        BigInteger customerId = MpHelper.getCustomerId(this);
        if (customerId == null) { renderJson(new ApiReturn().loginInvalid()); return; }
        int page = getParaToInt("page", 1); int size = getParaToInt("size", 20);
        String status = getPara("status");
        try {
            StringBuilder w = new StringBuilder("WHERE pr.customer_id = ? AND pr.is_deleted = 0");
            List<Object> ps = new ArrayList<>(); ps.add(customerId);
            if (status != null && !status.isEmpty()) { w.append(" AND pr.status = ?"); ps.add(Integer.parseInt(status)); }
            Page<Record> pg = Db.paginate(page, size, "SELECT pr.*, pkg.name AS package_name, pkg.type AS package_type",
                "FROM purchases pr LEFT JOIN packages pkg ON pr.package_id = pkg.id " + w + " ORDER BY pr.created_at DESC", ps.toArray());
            List<Map<String, Object>> list = new ArrayList<>();
            for (Record r : pg.getList()) {
                Map<String, Object> m = new HashMap<>();
                m.put("id", r.getBigInteger("id")); m.put("packageId", r.getBigInteger("package_id"));
                m.put("packageName", r.getStr("package_name")); m.put("packageType", r.getStr("package_type"));
                m.put("channel", r.getStr("channel")); m.put("paymentMethod", r.getStr("payment_method"));
                m.put("totalAmount", r.getBigDecimal("total_amount")); m.put("paidAmount", r.getBigDecimal("paid_amount"));
                m.put("status", r.getInt("status")); m.put("startDate", r.getDate("start_date"));
                m.put("createdAt", r.getDate("created_at")); list.add(m);
            }
            renderJson(new ApiReturn().addData("list", list).addData("total", pg.getTotalRow()).addData("page", page).addData("size", size).success());
        } catch (Exception e) { log.error("购买记录异常", e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }
}
