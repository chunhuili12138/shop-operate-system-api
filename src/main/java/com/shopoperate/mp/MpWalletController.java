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
import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.*;

@Path(value = "/api/mp/wallet")
public class MpWalletController extends Controller {
    private static final Logger log = Logger.getLogger(MpWalletController.class);
    @RequireLogin @MethodValidation("GET")
    public void info() {
        BigInteger customerId = MpHelper.getCustomerId(this);
        if (customerId == null) { renderJson(new ApiReturn().loginInvalid()); return; }
        try {
            Record w = Db.findFirst("SELECT * FROM customer_wallets WHERE customer_id = ? AND is_deleted = 0", customerId);
            Map<String, Object> d = new HashMap<>();
            d.put("balance", w != null ? w.getBigDecimal("balance") : BigDecimal.ZERO);
            d.put("totalRecharged", w != null ? w.getBigDecimal("total_recharged") : BigDecimal.ZERO);
            d.put("totalSpent", w != null ? w.getBigDecimal("total_spent") : BigDecimal.ZERO);
            renderJson(new ApiReturn().addData("data", d).success());
        } catch (Exception e) { log.error("钱包异常", e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }
    @RequireLogin @MethodValidation("GET")
    public void transactions() {
        BigInteger customerId = MpHelper.getCustomerId(this);
        if (customerId == null) { renderJson(new ApiReturn().loginInvalid()); return; }
        int page = getParaToInt("page", 1); int size = getParaToInt("size", 20);
        String type = getPara("type");
        try {
            StringBuilder w = new StringBuilder("WHERE customer_id = ? AND is_deleted = 0");
            List<Object> ps = new ArrayList<>(); ps.add(customerId);
            if (type != null && !type.isEmpty()) { w.append(" AND type = ?"); ps.add(Integer.parseInt(type)); }
            Page<Record> pg = Db.paginate(page, size, "SELECT *", "FROM wallet_transactions " + w + " ORDER BY created_at DESC", ps.toArray());
            List<Map<String, Object>> list = new ArrayList<>();
            for (Record r : pg.getList()) {
                Map<String, Object> m = new HashMap<>();
                m.put("id", r.getBigInteger("id")); m.put("type", r.getInt("type"));
                m.put("amount", r.getBigDecimal("amount")); m.put("balanceAfter", r.getBigDecimal("balance_after"));
                m.put("remark", r.getStr("remark")); m.put("createdAt", r.getDate("created_at")); list.add(m);
            }
            renderJson(new ApiReturn().addData("list", list).addData("total", pg.getTotalRow()).addData("page", page).addData("size", size).success());
        } catch (Exception e) { log.error("钱包流水异常", e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }
}
