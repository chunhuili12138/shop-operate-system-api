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

@Path(value = "/api/mp/gameSessions")
public class MpGameSessionsController extends Controller {
    private static final Logger log = Logger.getLogger(MpGameSessionsController.class);
    @RequireLogin @MethodValidation("GET")
    public void list() {
        BigInteger customerId = MpHelper.getCustomerId(this);
        if (customerId == null) { renderJson(new ApiReturn().loginInvalid()); return; }
        int page = getParaToInt("page", 1); int size = getParaToInt("size", 20);
        try {
            Page<Record> pg = Db.paginate(page, size,
                "SELECT gs.*, pkg.name AS package_name",
                "FROM game_sessions gs LEFT JOIN customer_sessions cs ON gs.customer_session_id = cs.id " +
                "LEFT JOIN purchases pr ON cs.purchase_id = pr.id LEFT JOIN packages pkg ON pr.package_id = pkg.id " +
                "WHERE gs.customer_id = ? AND gs.is_deleted = 0 ORDER BY gs.start_time DESC", customerId);
            List<Map<String, Object>> list = new ArrayList<>();
            for (Record r : pg.getList()) {
                Map<String, Object> m = new HashMap<>();
                m.put("id", r.getBigInteger("id")); m.put("customerSessionId", r.getBigInteger("customer_session_id"));
                m.put("packageName", r.getStr("package_name")); m.put("staffId", r.getBigInteger("staff_id"));
                m.put("startTime", r.getDate("start_time")); m.put("endTime", r.getDate("end_time"));
                m.put("status", r.getInt("status")); list.add(m);
            }
            renderJson(new ApiReturn().addData("list", list).addData("total", pg.getTotalRow()).addData("page", page).addData("size", size).success());
        } catch (Exception e) { log.error("核销记录异常", e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }
}

@Path(value = "/api/mp/sessions")
class MpSessionsController extends Controller {
    private static final Logger log = Logger.getLogger(MpSessionsController.class);
    @RequireLogin @MethodValidation("GET")
    public void list() {
        BigInteger customerId = MpHelper.getCustomerId(this);
        if (customerId == null) { renderJson(new ApiReturn().loginInvalid()); return; }
        int page = getParaToInt("page", 1); int size = getParaToInt("size", 20);
        try {
            Page<Record> pg = Db.paginate(page, size,
                "SELECT cs.*, pr.package_id, pkg.name AS package_name, pkg.type AS package_type",
                "FROM customer_sessions cs LEFT JOIN purchases pr ON cs.purchase_id = pr.id " +
                "LEFT JOIN packages pkg ON pr.package_id = pkg.id " +
                "WHERE cs.customer_id = ? AND cs.is_deleted = 0 ORDER BY cs.session_date DESC", customerId);
            List<Map<String, Object>> list = new ArrayList<>();
            for (Record r : pg.getList()) {
                Map<String, Object> m = new HashMap<>();
                m.put("id", r.getBigInteger("id")); m.put("purchaseId", r.getBigInteger("purchase_id"));
                m.put("packageId", r.getBigInteger("package_id")); m.put("packageName", r.getStr("package_name"));
                m.put("packageType", r.getInt("package_type")); m.put("sessionDate", r.getDate("session_date"));
                m.put("status", r.getInt("status")); m.put("usedAt", r.getDate("used_at")); list.add(m);
            }
            renderJson(new ApiReturn().addData("list", list).addData("total", pg.getTotalRow()).addData("page", page).addData("size", size).success());
        } catch (Exception e) { log.error("次卡列表异常", e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }
}
