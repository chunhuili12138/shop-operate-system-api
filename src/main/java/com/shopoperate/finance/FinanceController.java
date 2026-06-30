package com.shopoperate.finance;

import com.jfinal.core.Controller;
import com.jfinal.core.Path;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.shopoperate.common.annotation.*;
import com.shopoperate.common.vo.User;
import com.shopoperate.dashboard.DashboardService;
import com.shopoperate.utils.ApiReturn;
import org.apache.log4j.Logger;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.Date;
import java.util.List;

@Path(value = "/api")
public class FinanceController extends Controller {
    private static final Logger log = Logger.getLogger(FinanceController.class);

    // ---- Revenues ----
    @RequireLogin @MethodValidation("GET") public void revenues() {
        User u = getSessionAttr("userinfo");
        BigInteger sid = u.getLoginShopId();
        try {
            if ("summary".equals(getPara(0))) {
                String rsd = getPara("startDate"), red = getPara("endDate");
                StringBuilder cond = new StringBuilder(" WHERE rr.shop_id=").append(sid);
                if (rsd != null && !rsd.isEmpty()) cond.append(" AND rr.confirmed_at>='").append(rsd).append("'");
                if (red != null && !red.isEmpty()) cond.append(" AND rr.confirmed_at<='").append(red).append(" 23:59:59'");
                Record sum = new Record();
                sum.set("totalRevenue", Db.queryBigDecimal("SELECT COALESCE(SUM(amount),0) FROM revenue_records rr"+cond));
                sum.set("totalCount", Db.queryLong("SELECT COUNT(*) FROM revenue_records rr"+cond));
                sum.set("avgAmount", Db.queryBigDecimal("SELECT COALESCE(AVG(amount),0) FROM revenue_records rr"+cond+" AND amount>0"));
                renderJson(new ApiReturn().addData("data",sum).success());
                return;
            }
            StringBuilder select = new StringBuilder("SELECT rr.*, s.name AS staff_name, c.nickname AS customer_name, pk.name AS package_name, p.total_amount AS purchase_amount");
            StringBuilder from = new StringBuilder(" FROM revenue_records rr LEFT JOIN staff s ON rr.confirmed_by=s.id LEFT JOIN customers c ON rr.customer_id=c.id LEFT JOIN purchases p ON rr.purchase_id=p.id LEFT JOIN packages pk ON p.package_id=pk.id WHERE rr.shop_id=").append(sid);
            String sd = getPara("startDate"), ed = getPara("endDate");
            BigInteger staffId = getBigInteger("staffId");
            BigInteger customerId = getBigInteger("customerId");
            if (sd != null && !sd.isEmpty()) from.append(" AND rr.confirmed_at>='").append(sd).append("'");
            if (ed != null && !ed.isEmpty()) from.append(" AND rr.confirmed_at<='").append(ed).append(" 23:59:59'");
            if (staffId != null) from.append(" AND rr.confirmed_by=").append(staffId);
            if (customerId != null) from.append(" AND rr.customer_id=").append(customerId);
            from.append(" ORDER BY rr.created_at DESC");
            Page<Record> p = Db.paginate(getParaToInt("page",1), getParaToInt("size",20), select.toString(), from.toString());
            renderPage(p);
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("查询失败").fail()); }
    }

    // ---- Expenses ----
    @RequireLogin @MethodValidation("GET") public void expenses() {
        User u = getSessionAttr("userinfo");
        BigInteger sid = u.getLoginShopId();
        try {
            if ("summary".equals(getPara(0))) {
                String ssd = getPara("startDate"), sed = getPara("endDate");
                StringBuilder cond = new StringBuilder(" WHERE shop_id=").append(sid);
                if (ssd != null && !ssd.isEmpty()) cond.append(" AND expense_date>='").append(ssd).append("'");
                if (sed != null && !sed.isEmpty()) cond.append(" AND expense_date<='").append(sed).append("'");
                Record sum = new Record();
                sum.set("totalExpense", Db.queryBigDecimal("SELECT COALESCE(SUM(amount),0) FROM expenses"+cond));
                sum.set("totalCount", Db.queryLong("SELECT COUNT(*) FROM expenses"+cond));
                List<Record> cats = Db.find("SELECT ec.name, COALESCE(SUM(e.amount),0) AS total FROM expense_categories ec LEFT JOIN expenses e ON ec.id=e.category_id"+
                    (ssd != null && !ssd.isEmpty() ? " AND e.expense_date>='"+ssd+"'" : "")+
                    (sed != null && !sed.isEmpty() ? " AND e.expense_date<='"+sed+" 23:59:59'" : "")+
                    " WHERE ec.shop_id="+sid+" GROUP BY ec.id, ec.name ORDER BY total DESC");
                sum.set("categories", cats);
                renderJson(new ApiReturn().addData("data",sum).success());
                return;
            }
            StringBuilder select = new StringBuilder("SELECT e.*, ec.name AS category_name, s.name AS operator_name");
            StringBuilder from = new StringBuilder(" FROM expenses e LEFT JOIN expense_categories ec ON e.category_id=ec.id LEFT JOIN staff s ON e.operator_staff_id=s.id WHERE e.shop_id=").append(sid);
            String sd = getPara("startDate"), ed = getPara("endDate");
            BigInteger categoryId = getBigInteger("categoryId");
            BigDecimal amountMin = getPara("amountMin")!=null?new BigDecimal(getPara("amountMin")):null;
            BigDecimal amountMax = getPara("amountMax")!=null?new BigDecimal(getPara("amountMax")):null;
            if (sd != null && !sd.isEmpty()) from.append(" AND e.expense_date>='").append(sd).append("'");
            if (ed != null && !ed.isEmpty()) from.append(" AND e.expense_date<='").append(ed).append("'");
            if (categoryId != null) from.append(" AND e.category_id=").append(categoryId);
            if (amountMin != null) from.append(" AND e.amount>=").append(amountMin);
            if (amountMax != null) from.append(" AND e.amount<=").append(amountMax);
            from.append(" ORDER BY e.expense_date DESC");
            Page<Record> p = Db.paginate(getParaToInt("page",1), getParaToInt("size",20), select.toString(), from.toString());
            renderPage(p);
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("查询失败").fail()); }
    }
    @RequireLogin @RequirePermission("btn:expense:add") @MethodValidation("POST") public void expensesAdd() {
        try {
            User u = getSessionAttr("userinfo");
            renderBool(Db.save("expenses", new Record().set("shop_id",shopId()).set("category_id",getBigInteger("categoryId"))
                .set("amount",new BigDecimal(getPara("amount","0"))).set("payment_method",getPara("paymentMethod"))
                .set("expense_date",java.sql.Date.valueOf(getPara("expenseDate"))).set("remark",getPara("remark"))
                .set("source_type","manual").set("operator_staff_id",u.getId())
                .set("created_at",new Date())));
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }
    @RequireLogin @RequirePermission("btn:expense:edit") @MethodValidation("PUT") public void expensesUpdate() {
        try {
            User u = getSessionAttr("userinfo");
            Record e = Db.findById("expenses", getBigInteger("expenseId")); if (e==null) { renderBool(false); return; }
            if (!u.getLoginShopId().equals(e.getBigInteger("shop_id"))) { renderJson(new ApiReturn().addMsg("无权限操作该支出记录").fail()); return; }
            if (getPara("amount")!=null) e.set("amount",new BigDecimal(getPara("amount")));
            if (getPara("paymentMethod")!=null) e.set("payment_method",getPara("paymentMethod"));
            if (getPara("expenseDate")!=null) e.set("expense_date",java.sql.Date.valueOf(getPara("expenseDate")));
            if (getPara("remark")!=null) e.set("remark",getPara("remark"));
            renderBool(Db.update("expenses", e));
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }
    @RequireLogin @RequirePermission("btn:expense:delete") @MethodValidation("DELETE") public void expensesDelete() {
        try {
            User u = getSessionAttr("userinfo");
            BigInteger expenseId = getBigInteger("expenseId");
            Record e = Db.findById("expenses", expenseId); if (e==null) { renderBool(false); return; }
            if (!u.getLoginShopId().equals(e.getBigInteger("shop_id"))) { renderJson(new ApiReturn().addMsg("无权限操作该支出记录").fail()); return; }
            e.set("is_deleted", 1).set("deleted_time", new Date());
            renderBool(Db.update("expenses", e));
        } catch (Exception ex) { log.error(ex); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }
    @RequireLogin @MethodValidation("GET") public void expenseCategories() {
        User u = getSessionAttr("userinfo");
        try {
            List<Record> list = Db.find("SELECT * FROM expense_categories WHERE shop_id=? ORDER BY id", u.getLoginShopId());
            renderJson(new ApiReturn().addData("data",list).success());
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("查询失败").fail()); }
    }
    @RequireLogin @MethodValidation("POST") public void expenseCategoriesAdd() {
        renderBool(Db.save("expense_categories", new Record().set("shop_id",shopId()).set("name",getPara("name")).set("created_at",new Date())));
    }
    @RequireLogin @MethodValidation("PUT") public void expenseCategoriesUpdate() {
        try { User u = getSessionAttr("userinfo");
            Record c = Db.findById("expense_categories", getBigInteger("categoryId")); if (c==null) { renderBool(false); return; }
            if (!u.getLoginShopId().equals(c.getBigInteger("shop_id"))) { renderBool(false); return; }
            if (getPara("name")!=null) c.set("name",getPara("name")); renderBool(Db.update("expense_categories", c));
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }
    @RequireLogin @MethodValidation("DELETE") public void expenseCategoriesDelete() {
        try { User u = getSessionAttr("userinfo");
            BigInteger catId = getBigInteger("categoryId");
            Record c = Db.findById("expense_categories", catId); if (c==null) { renderBool(false); return; }
            if (!u.getLoginShopId().equals(c.getBigInteger("shop_id"))) { renderBool(false); return; }
            long cnt = Db.queryLong("SELECT COUNT(*) FROM expenses WHERE category_id=?", catId);
            if (cnt > 0) { renderJson(new ApiReturn().addMsg("该分类下有"+cnt+"条支出记录，不可删除").fail()); return; }
            c.set("is_deleted",1).set("deleted_time",new Date()); renderBool(Db.update("expense_categories", c));
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }

    // ---- Cash Flow (收支流水合并视图) ----
    @RequireLogin @MethodValidation("GET") public void cashFlow() {
        User u = getSessionAttr("userinfo");
        BigInteger sid = u.getLoginShopId();
        try {
            String sd = getPara("startDate"), ed = getPara("endDate"), ft = getPara("flowType");
            BigDecimal amMin = getPara("amountMin")!=null?new BigDecimal(getPara("amountMin")):null;
            BigDecimal amMax = getPara("amountMax")!=null?new BigDecimal(getPara("amountMax")):null;
            int pn = getParaToInt("page",1), ps = getParaToInt("size",20);
            String cond = "";
            if (sd != null && !sd.isEmpty()) cond += " AND flow_date>='"+sd+"'";
            if (ed != null && !ed.isEmpty()) cond += " AND flow_date<='"+ed+" 23:59:59'";
            if (amMin != null) cond += " AND amount>="+amMin;
            if (amMax != null) cond += " AND amount<="+amMax;
            String revPart = "(SELECT '收入' AS flow_type, rr.amount, c.nickname AS relate_name, pk.name AS desc_name, rr.confirmed_at AS flow_date, rr.created_at FROM revenue_records rr LEFT JOIN customers c ON rr.customer_id=c.id LEFT JOIN purchases p ON rr.purchase_id=p.id LEFT JOIN packages pk ON p.package_id=pk.id WHERE rr.shop_id="+sid+" AND rr.amount>0"+cond.replace("flow_date","rr.confirmed_at").replace("created_at","rr.created_at")+")";
            String expPart = "(SELECT '支出' AS flow_type, e.amount, ec.name AS relate_name, e.remark AS desc_name, e.expense_date AS flow_date, e.created_at FROM expenses e LEFT JOIN expense_categories ec ON e.category_id=ec.id WHERE e.shop_id="+sid+cond.replace("flow_date","e.expense_date").replace("created_at","e.created_at")+")";
            String unionSql;
            if ("收入".equals(ft)) unionSql = revPart;
            else if ("支出".equals(ft)) unionSql = expPart;
            else unionSql = revPart + " UNION ALL " + expPart;
            unionSql += " ORDER BY flow_date DESC";
            Page<Record> p = Db.paginate(pn, ps, "SELECT *", " FROM ("+unionSql+") AS t");
            renderPage(p);
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("查询失败").fail()); }
    }

    // ---- Invoices ----
    @RequireLogin @MethodValidation("GET") public void invoices() {
        User u = getSessionAttr("userinfo");
        try {
            StringBuilder from = new StringBuilder("FROM invoices WHERE shop_id=").append(u.getLoginShopId());
            String sd = getPara("startDate"), ed = getPara("endDate");
            if (sd != null && !sd.isEmpty()) from.append(" AND issued_at>='").append(sd).append("'");
            if (ed != null && !ed.isEmpty()) from.append(" AND issued_at<='").append(ed).append("'");
            from.append(" ORDER BY created_at DESC");
            Page<Record> p = Db.paginate(getParaToInt("page",1), getParaToInt("size",20), "SELECT *", from.toString());
            renderPage(p);
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("查询失败").fail()); }
    }
    @RequireLogin @MethodValidation("POST") public void invoicesAdd() {
        try {
            renderBool(Db.save("invoices", new Record().set("shop_id",shopId())
                .set("reference_type",getPara("referenceType")).set("reference_id",getBigInteger("referenceId"))
                .set("invoice_number",getPara("invoiceNumber")).set("amount",new BigDecimal(getPara("amount","0")))
                .set("issued_at",getPara("issuedAt")!=null?java.sql.Date.valueOf(getPara("issuedAt")):new Date())
                .set("image_path",getPara("imagePath")).set("remark",getPara("remark"))
                .set("created_at",new Date())));
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }
    @RequireLogin @MethodValidation("DELETE") public void invoicesDelete() {
        try { User u = getSessionAttr("userinfo");
            Record inv = Db.findById("invoices", getBigInteger("invoiceId")); if (inv==null) { renderBool(false); return; }
            if (!u.getLoginShopId().equals(inv.getBigInteger("shop_id"))) { renderBool(false); return; }
            inv.set("is_deleted",1).set("deleted_time",new Date()); renderBool(Db.update("invoices", inv));
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }

    // ---- Commission Rules ----
    @RequireLogin @MethodValidation("GET") public void commissionRules() {
        User u = getSessionAttr("userinfo");
        try {
            Page<Record> p = Db.paginate(getParaToInt("page",1), getParaToInt("size",20),
                "SELECT cr.*, r.name AS role_name",
                "FROM commission_rules cr LEFT JOIN roles r ON cr.role_id=r.id WHERE cr.shop_id=? ORDER BY cr.created_at DESC", u.getLoginShopId());
            renderPage(p);
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("查询失败").fail()); }
    }
    @RequireLogin @MethodValidation("POST") public void commissionRulesAdd() {
        renderBool(Db.save("commission_rules", new Record().set("shop_id",shopId()).set("role_id",getBigInteger("roleId"))
            .set("rule_type",getParaToInt("ruleType")).set("value",new BigDecimal(getPara("value","0")))
            .set("description",getPara("description")).set("is_active",1).set("created_at",new Date())));
    }
    @RequireLogin @MethodValidation("PUT") public void commissionRulesUpdate() {
        try {
            User u = getSessionAttr("userinfo");
            Record r = Db.findById("commission_rules", getBigInteger("ruleId")); if (r==null) { renderBool(false); return; }
            if (!u.getLoginShopId().equals(r.getBigInteger("shop_id"))) { renderJson(new ApiReturn().addMsg("无权限操作该提成规则").fail()); return; }
            if (getPara("ruleType")!=null) r.set("rule_type",getParaToInt("ruleType"));
            if (getPara("value")!=null) r.set("value",new BigDecimal(getPara("value")));
            if (getPara("description")!=null) r.set("description",getPara("description"));
            renderBool(Db.update("commission_rules", r));
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }
    @RequireLogin @MethodValidation("PUT") public void commissionRulesStatus() {
        try { 
            User u = getSessionAttr("userinfo");
            Record r = Db.findById("commission_rules", getBigInteger("ruleId")); if (r==null) { renderBool(false); return; }
            if (!u.getLoginShopId().equals(r.getBigInteger("shop_id"))) { renderJson(new ApiReturn().addMsg("无权限操作该提成规则").fail()); return; }
            r.set("is_active",getParaToInt("isActive",0)); renderBool(Db.update("commission_rules", r));
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }
    @RequireLogin @MethodValidation("GET") public void commissionSettlements() {
        User u = getSessionAttr("userinfo");
        try {
            StringBuilder from = new StringBuilder("FROM commission_settlements cs LEFT JOIN staff s ON cs.staff_id=s.id WHERE cs.shop_id=").append(u.getLoginShopId());
            String period = getPara("settlementPeriod");
            if (period != null && !period.isEmpty()) from.append(" AND cs.settlement_period='").append(period).append("'");
            from.append(" ORDER BY cs.created_at DESC");
            Page<Record> p = Db.paginate(getParaToInt("page",1), getParaToInt("size",20),
                "SELECT cs.*, s.name AS staff_name", from.toString());
            renderPage(p);
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("查询失败").fail()); }
    }
    @RequireLogin @MethodValidation("POST") public void commissionSettlementsGenerate() {
        User u = getSessionAttr("userinfo");
        try {
            String period = getPara("settlementPeriod");
            if (period == null || !period.matches("\\d{4}-\\d{2}")) { renderJson(new ApiReturn().addMsg("结算周期格式错误，应为 yyyy-MM").fail()); return; }
            List<Record> staffList = Db.find("SELECT DISTINCT gs.staff_id FROM game_sessions gs WHERE gs.shop_id=? AND gs.status=2 AND DATE_FORMAT(gs.created_at,'%Y-%m')=?", u.getLoginShopId(), period);
            for (Record staff : staffList) {
                BigInteger sid = staff.getBigInteger("staff_id");
                long totalSessions = Db.queryLong("SELECT COUNT(*) FROM game_sessions WHERE staff_id=? AND shop_id=? AND status=2 AND DATE_FORMAT(created_at,'%Y-%m')=?", sid, u.getLoginShopId(), period);
                BigDecimal totalRevenue = Db.queryBigDecimal("SELECT COALESCE(SUM(rr.amount),0) FROM revenue_records rr INNER JOIN game_sessions gs ON rr.game_session_id=gs.id WHERE gs.staff_id=? AND gs.shop_id=? AND DATE_FORMAT(gs.created_at,'%Y-%m')=?", sid, u.getLoginShopId(), period);
                if (totalSessions == 0) continue;
                BigDecimal commission = null;
                String ruleSnapshot = "[]";
                List<BigInteger> roleIds = new java.util.ArrayList<>();
                for (Record r : Db.find("SELECT role_id FROM staff_roles WHERE staff_id=?", sid)) {
                    roleIds.add(r.getBigInteger("role_id"));
                }
                if (!roleIds.isEmpty()) {
                    StringBuilder ids = new StringBuilder();
                    for (int i = 0; i < roleIds.size(); i++) {
                        if (i > 0) ids.append(",");
                        ids.append(roleIds.get(i));
                    }
                    List<Record> rules = Db.find("SELECT * FROM commission_rules WHERE shop_id=? AND is_active=1 AND FIND_IN_SET(role_id, ?) AND is_deleted=0", u.getLoginShopId(), ids.toString());
                    if (!rules.isEmpty()) {
                        BigDecimal totalCommission = BigDecimal.ZERO;
                        StringBuilder snapshot = new StringBuilder("[");
                        for (int i = 0; i < rules.size(); i++) {
                            Record rule = rules.get(i);
                            int rt = rule.getInt("rule_type");
                            BigDecimal val = rule.getBigDecimal("value");
                            BigDecimal ruleAmt = BigDecimal.ZERO;
                            if (rt == 1) ruleAmt = BigDecimal.valueOf(totalSessions).multiply(val);
                            else if (rt == 2) ruleAmt = totalRevenue.multiply(val).divide(new BigDecimal("100"), BigDecimal.ROUND_HALF_UP);
                            else if (rt == 3) ruleAmt = val;
                            totalCommission = totalCommission.add(ruleAmt);
                            if (i > 0) snapshot.append(",");
                            snapshot.append("{\"rule_id\":").append(rule.getBigInteger("id")).append(",\"type\":").append(rt).append(",\"value\":").append(val).append(",\"amount\":").append(ruleAmt).append("}");
                        }
                        snapshot.append("]");
                        ruleSnapshot = snapshot.toString();
                        commission = totalCommission;
                    }
                }
                if (commission == null) continue;
                Db.save("commission_settlements", new Record().set("shop_id",u.getLoginShopId()).set("staff_id",sid)
                    .set("settlement_period",period).set("total_sessions",(int)totalSessions)
                    .set("total_revenue",totalRevenue).set("commission_amount",commission)
                    .set("rule_snapshot", ruleSnapshot).set("status",1).set("created_at",new Date()));
            }
            renderJson(new ApiReturn().success());
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }
    @RequireLogin @MethodValidation("PUT") public void commissionSettlementsPay() {
        try { 
            User u = getSessionAttr("userinfo");
            Record cs = Db.findById("commission_settlements", getBigInteger("settlementId")); if (cs==null) { renderBool(false); return; }
            if (!u.getLoginShopId().equals(cs.getBigInteger("shop_id"))) { renderJson(new ApiReturn().addMsg("无权限操作").fail()); return; }
            cs.set("status",2);
            // 同步写入 expenses 表（提成支出）
            BigInteger shopId = cs.getBigInteger("shop_id");
            BigDecimal commission = cs.getBigDecimal("commission_amount");
            String staffName = "";
            Record staff = Db.findById("staff", cs.getBigInteger("staff_id"));
            if (staff != null) staffName = staff.getStr("name");
            Long categoryId = Db.queryLong("SELECT id FROM expense_categories WHERE shop_id=? AND name='提成支出' LIMIT 1", shopId);
            Record expense = new Record().set("shop_id", shopId)
                .set("amount", commission).set("payment_method", "cash")
                .set("expense_date", new java.sql.Date(System.currentTimeMillis()))
                .set("source_type", "commission").set("source_id", cs.getBigInteger("id"))
                .set("operator_staff_id", u.getId())
                .set("remark", "提成发放-" + staffName + "-" + cs.getStr("settlement_period"))
                .set("created_at", new Date());
            if (categoryId != null) expense.set("category_id", new BigInteger(String.valueOf(categoryId)));
            else expense.set("category_id", BigInteger.ZERO);
            Db.save("expenses", expense);
            cs.set("expense_id", expense.getBigInteger("id"));
            renderBool(Db.update("commission_settlements", cs));
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }

    // ---- Attendance ----
    @RequireLogin @MethodValidation("GET") public void attendanceRecords() {
        User u = getSessionAttr("userinfo");
        BigInteger sid = u.getLoginShopId();
        try {
            String keyword = getPara("keyword");
            String startDate = getPara("startDate");
            String endDate = getPara("endDate");
            Integer status = getParaToInt("status");

            StringBuilder select = new StringBuilder("SELECT ar.*, s.name AS staff_name");
            StringBuilder from = new StringBuilder(" FROM attendance_records ar LEFT JOIN staff s ON ar.staff_id=s.id WHERE ar.shop_id=" + sid);

            if (keyword != null && !keyword.isEmpty()) {
                from.append(" AND s.name LIKE '%").append(keyword.replace("'", "''")).append("%'");
            }
            if (startDate != null && !startDate.isEmpty()) {
                from.append(" AND ar.date >= '").append(startDate).append("'");
            }
            if (endDate != null && !endDate.isEmpty()) {
                from.append(" AND ar.date <= '").append(endDate).append("'");
            }
            if (status != null) {
                from.append(" AND ar.status = ").append(status);
            }
            from.append(" ORDER BY ar.date DESC");

            Page<Record> p = Db.paginate(getParaToInt("page",1), getParaToInt("size",20), select.toString(), from.toString());
            renderPage(p);
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("查询失败").fail()); }
    }
    @RequireLogin @RequirePermission("btn:attendance:checkin") @MethodValidation("POST") public void attendanceRecordsCheckIn() {
        User u = getSessionAttr("userinfo");
        try {
            Record existing = Db.findFirst("SELECT * FROM attendance_records WHERE staff_id=? AND date=CURDATE()", u.getId());
            if (existing != null) { renderJson(new ApiReturn().addMsg("今日已打卡").fail()); return; }
            renderBool(Db.save("attendance_records", new Record().set("shop_id",shopId()).set("staff_id",u.getId())
                .set("check_in_time",new Date()).set("date",new java.sql.Date(System.currentTimeMillis())).set("status",1).set("created_at",new Date())));
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }
    @RequireLogin @RequirePermission("btn:attendance:checkout") @MethodValidation("PUT") public void attendanceRecordsCheckOut() {
        try { User u = getSessionAttr("userinfo");
            Record ar = Db.findById("attendance_records", getBigInteger("recordId")); if (ar==null) { renderBool(false); return; }
            if (!u.getLoginShopId().equals(ar.getBigInteger("shop_id"))) { renderBool(false); return; }
            ar.set("check_out_time",new Date()); renderBool(Db.update("attendance_records", ar));
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }

    // ---- Staff Schedules ----
    @RequireLogin @MethodValidation("GET") public void staffSchedules() {
        User u = getSessionAttr("userinfo");
        BigInteger sid = u.getLoginShopId();
        try {
            String keyword = getPara("keyword");
            String startDate = getPara("startDate");
            String endDate = getPara("endDate");
            Integer type = getParaToInt("type");

            StringBuilder select = new StringBuilder("SELECT ss.*, s.name AS staff_name");
            StringBuilder from = new StringBuilder(" FROM staff_schedules ss LEFT JOIN staff s ON ss.staff_id=s.id WHERE ss.shop_id=" + sid);

            if (keyword != null && !keyword.isEmpty()) {
                from.append(" AND s.name LIKE '%").append(keyword.replace("'", "''")).append("%'");
            }
            if (startDate != null && !startDate.isEmpty()) {
                from.append(" AND ss.schedule_date >= '").append(startDate).append("'");
            }
            if (endDate != null && !endDate.isEmpty()) {
                from.append(" AND ss.schedule_date <= '").append(endDate).append("'");
            }
            if (type != null) {
                from.append(" AND ss.type = ").append(type);
            }
            from.append(" ORDER BY ss.schedule_date DESC");

            Page<Record> p = Db.paginate(getParaToInt("page",1), getParaToInt("size",20), select.toString(), from.toString());
            renderPage(p);
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("查询失败").fail()); }
    }
    @RequireLogin @RequirePermission("btn:schedule:add") @MethodValidation("POST") public void staffSchedulesAdd() {
        renderBool(Db.save("staff_schedules", new Record().set("shop_id",shopId()).set("staff_id",getBigInteger("staffId"))
            .set("schedule_date",java.sql.Date.valueOf(getPara("scheduleDate")))
            .set("start_time",java.sql.Time.valueOf(getPara("startTime")+":00"))
            .set("end_time",java.sql.Time.valueOf(getPara("endTime")+":00"))
            .set("type",getParaToInt("type",1)).set("remark",getPara("remark")).set("created_at",new Date())));
    }
    @RequireLogin @RequirePermission("btn:schedule:edit") @MethodValidation("PUT") public void staffSchedulesUpdate() {
        try { User u = getSessionAttr("userinfo");
            Record ss = Db.findById("staff_schedules", getBigInteger("scheduleId")); if (ss==null) { renderBool(false); return; }
            if (!u.getLoginShopId().equals(ss.getBigInteger("shop_id"))) { renderBool(false); return; }
            if (getPara("startTime")!=null) ss.set("start_time",java.sql.Time.valueOf(getPara("startTime")+":00"));
            if (getPara("endTime")!=null) ss.set("end_time",java.sql.Time.valueOf(getPara("endTime")+":00"));
            if (getParaToInt("type")!=null) ss.set("type",getParaToInt("type"));
            if (getPara("remark")!=null) ss.set("remark",getPara("remark"));
            renderBool(Db.update("staff_schedules", ss));
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }
    @RequireLogin @RequirePermission("btn:schedule:delete") @MethodValidation("DELETE") public void staffSchedulesDelete() {
        try { User u = getSessionAttr("userinfo");
            Record ss = Db.findById("staff_schedules", getBigInteger("scheduleId")); if (ss==null) { renderBool(false); return; }
            if (!u.getLoginShopId().equals(ss.getBigInteger("shop_id"))) { renderBool(false); return; }
            ss.set("is_deleted",1).set("deleted_time",new Date()); renderBool(Db.update("staff_schedules", ss));
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }

    // ---- Notifications ----
    @RequireLogin @MethodValidation("GET") public void notifications() {
        User u = getSessionAttr("userinfo");
        if ("unreadCount".equals(getPara(0))) {
            long count = Db.queryLong("SELECT COUNT(*) FROM notification_logs WHERE shop_id=? AND recipient_id=? AND status=1", shopId(), u.getId());
            renderJson(new ApiReturn().addData("data",count).success());
            return;
        }
        try {
            Page<Record> p = Db.paginate(getParaToInt("page",1), getParaToInt("size",20),
                "SELECT *", "FROM notification_logs WHERE shop_id=? AND recipient_id=? ORDER BY created_at DESC", shopId(), u.getId());
            renderPage(p);
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("查询失败").fail()); }
    }
    @RequireLogin @MethodValidation("PUT") public void notificationsRead() {
        User u = getSessionAttr("userinfo");
        String ids = getPara("notificationIds");
        if (ids!=null && !ids.isEmpty()) {
            Db.update("UPDATE notification_logs SET status=2 WHERE FIND_IN_SET(id, ?) AND recipient_id=?", ids, u.getId());
        }
        renderJson(new ApiReturn().success());
    }
    @RequireLogin @MethodValidation("POST") public void notificationsSend() {
        User u = getSessionAttr("userinfo");
        try {
            String recipientStr = getPara("recipientIds");
            if (recipientStr==null || recipientStr.isEmpty()) { renderBool(false); return; }
            for (String id : recipientStr.split(",")) {
                Db.save("notification_logs", new Record().set("shop_id",shopId())
                    .set("recipient_type",getParaToInt("recipientType",2)).set("recipient_id",new BigInteger(id.trim()))
                    .set("channel",4).set("title",getPara("title")).set("content",getPara("content"))
                    .set("status",1).set("created_at",new Date()));
            }
            renderJson(new ApiReturn().success());
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }

    // ---- Dashboard ----
    @RequireLogin @MethodValidation("GET") public void dashboard() {
        User u = getSessionAttr("userinfo");
        BigInteger sid = u.getLoginShopId();
        try {
            Record data = new Record();
            if ("today".equals(getPara(0))) {
                if (sid == null) {
                    data = DashboardService.me.getPlatformDashboard();
                } else {
                    data.set("todaySales", Db.queryBigDecimal("SELECT COALESCE(SUM(paid_amount),0) FROM purchases WHERE shop_id=? AND DATE(created_at)=CURDATE() AND is_deleted=0", sid));
                    data.set("todayRevenue", Db.queryBigDecimal("SELECT COALESCE(SUM(amount),0) FROM revenue_records WHERE shop_id=? AND DATE(confirmed_at)=CURDATE()", sid));
                    data.set("todayOrders", Db.queryLong("SELECT COUNT(*) FROM purchases WHERE shop_id=? AND DATE(created_at)=CURDATE() AND is_deleted=0", sid));
                    data.set("todayNewCustomers", Db.queryLong("SELECT COUNT(*) FROM customers WHERE shop_id=? AND DATE(created_at)=CURDATE()", sid));
                    data.set("todayCheckins", Db.queryLong("SELECT COUNT(*) FROM game_sessions WHERE shop_id=? AND DATE(created_at)=CURDATE()", sid));
                    // 席位到期信息
                    Record seat = Db.findFirst(
                        "SELECT ss.end_date, DATEDIFF(ss.end_date, CURDATE()) AS remaining_days " +
                        "FROM seat_subscriptions ss " +
                        "INNER JOIN shops s ON s.owner_staff_id = ss.staff_id " +
                        "WHERE s.id = ? AND ss.status = 1 " +
                        "ORDER BY ss.end_date DESC LIMIT 1", sid);
                    if (seat != null) {
                        data.set("seatEndDate", seat.getDate("end_date"));
                        data.set("seatRemainingDays", seat.getInt("remaining_days"));
                    }
                }
            } else if ("shop".equals(getPara(0))) {
                if (sid == null) { renderJson(new ApiReturn().addMsg("请选择店铺").fail()); return; }
                data = buildShopDashboard(sid);
            } else if ("revenue".equals(getPara(0))) {
                if (sid == null) { renderJson(new ApiReturn().addMsg("请选择店铺").fail()); return; }
                String sd = getPara("startDate"), ed = getPara("endDate"), g = getPara("granularity","day");
                String dateFmt = "day".equals(g) ? "%Y-%m-%d" : "week".equals(g) ? "%Y-%u" : "%Y-%m";
                data.set("revenues", Db.find("SELECT DATE_FORMAT(confirmed_at,'"+dateFmt+"') AS period, SUM(amount) AS total FROM revenue_records WHERE shop_id=? AND confirmed_at>=? AND confirmed_at<=? GROUP BY period ORDER BY period", sid, sd, ed+" 23:59:59"));
                data.set("expenses", Db.find("SELECT DATE_FORMAT(expense_date,'"+dateFmt+"') AS period, SUM(amount) AS total FROM expenses WHERE shop_id=? AND expense_date>=? AND expense_date<=? GROUP BY period ORDER BY period", sid, sd, ed));
            } else if ("topPackages".equals(getPara(0))) {
                if (sid == null) { renderJson(new ApiReturn().addMsg("请选择店铺").fail()); return; }
                data.set("list", Db.find("SELECT pk.name, COUNT(*) AS count FROM purchases p INNER JOIN packages pk ON p.package_id=pk.id WHERE p.shop_id=? GROUP BY p.package_id ORDER BY count DESC LIMIT 10", sid));
            } else {
                renderJson(new ApiReturn().addMsg("未知查询类型").fail()); return;
            }
            renderJson(new ApiReturn().addData("data",data).success());
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("dashboard错误: "+e.getMessage()).fail()); }
    }

    // ---- Daily Snapshots ----
    @RequireLogin @MethodValidation("GET") public void dailySnapshots() {
        User u = getSessionAttr("userinfo");
        BigInteger sid = u.getLoginShopId();
        if (sid == null) { renderJson(new ApiReturn().addMsg("请选择店铺").fail()); return; }
        try {
            StringBuilder sb = new StringBuilder(" FROM daily_snapshots WHERE shop_id=").append(sid);
            String sd = getPara("startDate"), ed = getPara("endDate");
            if (sd != null && !sd.isEmpty()) sb.append(" AND snapshot_date>='").append(sd).append("'");
            if (ed != null && !ed.isEmpty()) sb.append(" AND snapshot_date<='").append(ed).append("'");
            sb.append(" ORDER BY snapshot_date DESC");
            Page<Record> p = Db.paginate(getParaToInt("page",1), getParaToInt("size",20), "SELECT *", sb.toString());
            renderPage(p);
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("查询失败").fail()); }
    }
    @RequireLogin @MethodValidation("GET") public void dailySnapshotsInfo() {
        User u = getSessionAttr("userinfo");
        BigInteger sid = u.getLoginShopId();
        if (sid == null) { renderJson(new ApiReturn().addMsg("请选择店铺").fail()); return; }
        try {
            Record s = Db.findFirst("SELECT * FROM daily_snapshots WHERE shop_id=? AND snapshot_date=?", sid, getPara("snapshotDate"));
            renderJson(s!=null ? new ApiReturn().addData("data",s).success() : new ApiReturn().addMsg("快照不存在").fail());
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("查询失败").fail()); }
    }

    private Record buildShopDashboard(BigInteger sid) {
        Record d = new Record();
        try {
            // ---- 今日核心 ----
            d.set("todaySales", Db.queryBigDecimal("SELECT COALESCE(SUM(paid_amount),0) FROM purchases WHERE shop_id=? AND DATE(created_at)=CURDATE() AND is_deleted=0", sid));
            d.set("todayRevenue", Db.queryBigDecimal("SELECT COALESCE(SUM(amount),0) FROM revenue_records WHERE shop_id=? AND DATE(confirmed_at)=CURDATE()", sid));
            d.set("todayOrders", Db.queryLong("SELECT COUNT(*) FROM purchases WHERE shop_id=? AND DATE(created_at)=CURDATE() AND is_deleted=0", sid));
            d.set("todayCheckins", Db.queryLong("SELECT COUNT(*) FROM game_sessions WHERE shop_id=? AND DATE(created_at)=CURDATE()", sid));
            d.set("todayNewCustomers", Db.queryLong("SELECT COUNT(*) FROM customers WHERE shop_id=? AND DATE(created_at)=CURDATE()", sid));
            d.set("todayExpense", Db.queryBigDecimal("SELECT COALESCE(SUM(amount),0) FROM expenses WHERE shop_id=? AND expense_date=CURDATE()", sid));
        } catch (Exception e) { d.set("err","today: "+e.getMessage()); }
        try {
            d.set("monthSales", Db.queryBigDecimal("SELECT COALESCE(SUM(paid_amount),0) FROM purchases WHERE shop_id=? AND DATE_FORMAT(created_at,'%Y-%m')=DATE_FORMAT(CURDATE(),'%Y-%m') AND status=1 AND is_deleted=0", sid));
            d.set("monthRevenue", Db.queryBigDecimal("SELECT COALESCE(SUM(amount),0) FROM revenue_records WHERE shop_id=? AND DATE_FORMAT(confirmed_at,'%Y-%m')=DATE_FORMAT(CURDATE(),'%Y-%m')", sid));
            d.set("monthExpense", Db.queryBigDecimal("SELECT COALESCE(SUM(amount),0) FROM expenses WHERE shop_id=? AND DATE_FORMAT(expense_date,'%Y-%m')=DATE_FORMAT(CURDATE(),'%Y-%m')", sid));
            d.set("monthCheckins", Db.queryLong("SELECT COUNT(*) FROM game_sessions WHERE shop_id=? AND DATE_FORMAT(created_at,'%Y-%m')=DATE_FORMAT(CURDATE(),'%Y-%m')", sid));
        } catch (Exception e) { d.set("err","month: "+e.getMessage()); }
        try {
            Record seat = Db.findFirst("SELECT ss.end_date, DATEDIFF(ss.end_date,CURDATE()) AS remaining_days FROM seat_subscriptions ss INNER JOIN shops s ON s.owner_staff_id=ss.staff_id WHERE s.id=? AND ss.status=1 ORDER BY ss.end_date DESC LIMIT 1", sid);
            if (seat != null) { d.set("seatEndDate", seat.getDate("end_date")); d.set("seatRemainingDays", seat.getInt("remaining_days")); }
        } catch (Exception e) { d.set("err","seat: "+e.getMessage()); }
        try {
            d.set("pendingRefunds", Db.queryLong("SELECT COUNT(*) FROM refund_records WHERE shop_id=? AND status=1 AND is_deleted=0", sid));
            d.set("pendingFeedbacks", Db.queryLong("SELECT COUNT(*) FROM feedbacks WHERE shop_id=? AND status=1", sid));
            d.set("activeSessions", Db.queryLong("SELECT COUNT(*) FROM game_sessions WHERE shop_id=? AND status=1", sid));
            d.set("todayQueue", Db.queryLong("SELECT COUNT(*) FROM queue_entries WHERE shop_id=? AND DATE(created_at)=CURDATE()", sid));
        } catch (Exception e) { d.set("err","pending: "+e.getMessage()); }
        try {
            List<Record> warns = Db.find("SELECT m.name AS material_name, i.quantity, m.min_stock FROM inventory i INNER JOIN materials m ON i.material_id=m.id WHERE i.shop_id=? AND i.quantity<=m.min_stock AND m.is_deleted=0 LIMIT 6", sid);
            d.set("warnings", warns);
        } catch (Exception e) { d.set("err","warnings: "+e.getMessage()); }
        try {
            d.set("totalCustomers", Db.queryLong("SELECT COUNT(*) FROM customers WHERE shop_id=?", sid));
            d.set("activeCustomers", Db.queryLong("SELECT COUNT(DISTINCT customer_id) FROM game_sessions WHERE shop_id=? AND created_at>=DATE_SUB(CURDATE(),INTERVAL 30 DAY)", sid));
            d.set("walletBalance", Db.queryBigDecimal("SELECT COALESCE(SUM(balance),0) FROM customer_wallets WHERE shop_id=? AND is_deleted=0", sid));
        } catch (Exception e) { d.set("err","customer: "+e.getMessage()); }
        try {
            d.set("channels", Db.find("SELECT COALESCE(channel,'other') AS channel, COUNT(*) AS cnt, COALESCE(SUM(total_amount),0) AS amount FROM purchases WHERE shop_id=? AND is_deleted=0 AND created_at>=DATE_SUB(CURDATE(),INTERVAL 30 DAY) GROUP BY channel ORDER BY cnt DESC", sid));
        } catch (Exception e) { d.set("err","channels: "+e.getMessage()); }
        try {
            d.set("topPackages", Db.find("SELECT pk.name, pk.type, COUNT(*) AS cnt FROM purchases p INNER JOIN packages pk ON p.package_id=pk.id WHERE p.shop_id=? AND p.is_deleted=0 AND p.created_at>=DATE_SUB(CURDATE(),INTERVAL 30 DAY) GROUP BY p.package_id ORDER BY cnt DESC LIMIT 5", sid));
        } catch (Exception e) { d.set("err","packages: "+e.getMessage()); }
        try {
            String end7 = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new Date());
            String start7 = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new Date(System.currentTimeMillis()-6*86400000L));
            d.set("trendRevenues", Db.find("SELECT DATE_FORMAT(confirmed_at,'%m-%d') AS period, SUM(amount) AS total FROM revenue_records WHERE shop_id=? AND confirmed_at>=? AND confirmed_at<=? GROUP BY period ORDER BY period", sid, start7, end7+" 23:59:59"));
            d.set("trendExpenses", Db.find("SELECT DATE_FORMAT(expense_date,'%m-%d') AS period, SUM(amount) AS total FROM expenses WHERE shop_id=? AND expense_date>=? AND expense_date<=? GROUP BY period ORDER BY period", sid, start7, end7));
        } catch (Exception e) { d.set("err","trend: "+e.getMessage()); }
        try {
            d.set("staffCheckins", Db.find("SELECT s.name, COUNT(*) AS cnt FROM game_sessions gs INNER JOIN staff s ON gs.staff_id=s.id WHERE gs.shop_id=? AND DATE(gs.created_at)=CURDATE() GROUP BY gs.staff_id ORDER BY cnt DESC LIMIT 5", sid));
            d.set("todayAttendCount", Db.queryLong("SELECT COUNT(*) FROM attendance_records WHERE shop_id=? AND date=CURDATE()", sid));
        } catch (Exception e) { d.set("err","staff: "+e.getMessage()); }
        try {
            long customerCnt = Db.queryLong("SELECT COUNT(DISTINCT customer_id) FROM purchases WHERE shop_id=? AND is_deleted=0 AND created_at>=DATE_SUB(CURDATE(),INTERVAL 30 DAY)", sid);
            BigDecimal rev30 = Db.queryBigDecimal("SELECT COALESCE(SUM(amount),0) FROM revenue_records WHERE shop_id=? AND confirmed_at>=DATE_SUB(CURDATE(),INTERVAL 30 DAY)", sid);
            d.set("avgCustomerPrice", customerCnt > 0 ? rev30.divide(BigDecimal.valueOf(customerCnt), 2, BigDecimal.ROUND_HALF_UP) : BigDecimal.ZERO);
            BigDecimal refund30 = Db.queryBigDecimal("SELECT COALESCE(SUM(refund_amount),0) FROM refund_records WHERE shop_id=? AND status=2 AND created_at>=DATE_SUB(CURDATE(),INTERVAL 30 DAY)", sid);
            BigDecimal sales30 = Db.queryBigDecimal("SELECT COALESCE(SUM(total_amount),0) FROM purchases WHERE shop_id=? AND is_deleted=0 AND created_at>=DATE_SUB(CURDATE(),INTERVAL 30 DAY)", sid);
            d.set("refundRate", sales30.compareTo(BigDecimal.ZERO) > 0 ? refund30.divide(sales30, 4, BigDecimal.ROUND_HALF_UP) : BigDecimal.ZERO);
        } catch (Exception e) { d.set("err","kpi: "+e.getMessage()); }
        try {
            long totalCust = Db.queryLong("SELECT COUNT(DISTINCT customer_id) FROM game_sessions WHERE shop_id=? AND created_at>=DATE_SUB(CURDATE(),INTERVAL 30 DAY)", sid);
            long returnCust = Db.queryLong("SELECT COUNT(*) FROM (SELECT customer_id FROM game_sessions WHERE shop_id=? AND created_at>=DATE_SUB(CURDATE(),INTERVAL 30 DAY) GROUP BY customer_id HAVING COUNT(*)>=2) t", sid);
            d.set("returnRate", totalCust > 0 ? BigDecimal.valueOf(returnCust).divide(BigDecimal.valueOf(totalCust), 4, BigDecimal.ROUND_HALF_UP) : BigDecimal.ZERO);
        } catch (Exception e) { d.set("err","return: "+e.getMessage()); }
        return d;
    }

    private BigInteger shopId() { User u=getSessionAttr("userinfo"); return u!=null?u.getLoginShopId():null; }
    private BigInteger getBigInteger(String n) { String v=getPara(n); return v==null||v.isEmpty()?null:new BigInteger(v); }
    private void renderPage(Page<Record> p) { java.util.Map<String,Object> _m=new java.util.HashMap<>(); _m.put("list",p.getList()); _m.put("total",(int)p.getTotalRow()); renderJson(new ApiReturn().addData("data",_m).success()); }
    private void renderBool(boolean ok) { renderJson(ok ? new ApiReturn().success() : new ApiReturn().addMsg("操作失败").fail()); }
}
