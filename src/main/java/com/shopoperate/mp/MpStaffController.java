package com.shopoperate.mp;

import com.jfinal.core.Controller;
import com.jfinal.core.Path;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.shopoperate.common.annotation.MethodValidation;
import com.shopoperate.common.annotation.RequireLogin;
import com.shopoperate.common.vo.User;
import com.shopoperate.utils.ApiReturn;
import org.apache.log4j.Logger;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.*;

@Path(value = "/api/mp/staff")
public class MpStaffController extends Controller {
    private static final Logger log = Logger.getLogger(MpStaffController.class);

    private BigInteger getStaffId() {
        User u = getSessionAttr("userinfo");
        if (u == null || u.getIsStaff() == null || u.getIsStaff() != 1) return null;
        try {
            Record staff = Db.findFirst(
                "SELECT s.id FROM staff s INNER JOIN staff_shops ss ON s.id = ss.staff_id " +
                "WHERE s.phone = (SELECT phone FROM customers WHERE id = ? LIMIT 1) " +
                "AND ss.shop_id = ? AND s.is_deleted = 0 AND s.status = 1 LIMIT 1",
                u.getCustomerId(), u.getLoginShopId());
            return staff != null ? staff.getBigInteger("id") : null;
        } catch (Exception e) { return null; }
    }

    @RequireLogin @MethodValidation("GET")
    public void workbench() {
        BigInteger shopId = MpHelper.getShopId(this);
        if (shopId == null) { renderJson(new ApiReturn().addMsg("请先选择店铺").fail()); return; }
        try {
            Map<String, Object> d = new HashMap<>();
            d.put("todayCheckins", Db.queryLong("SELECT COUNT(*) FROM game_sessions WHERE shop_id = ? AND DATE(start_time) = CURDATE() AND is_deleted = 0", shopId));
            d.put("queueCount", Db.queryLong("SELECT COUNT(*) FROM queue_entries WHERE shop_id = ? AND status = 1 AND is_deleted = 0", shopId));
            d.put("pendingFeedbacks", Db.queryLong("SELECT COUNT(*) FROM feedbacks WHERE shop_id = ? AND status = 0 AND is_deleted = 0", shopId));
            List<Record> active = Db.find("SELECT gs.*, c.nickname, pkg.name AS package_name FROM game_sessions gs LEFT JOIN customers c ON gs.customer_id = c.id LEFT JOIN customer_sessions cs ON gs.customer_session_id = cs.id LEFT JOIN purchases pr ON cs.purchase_id = pr.id LEFT JOIN packages pkg ON pr.package_id = pkg.id WHERE gs.shop_id = ? AND gs.status = 1 AND gs.is_deleted = 0 ORDER BY gs.start_time DESC", shopId);
            List<Map<String, Object>> al = new ArrayList<>();
            for (Record r : active) { Map<String, Object> m = new HashMap<>(); m.put("id", r.getBigInteger("id")); m.put("customerId", r.getBigInteger("customer_id")); m.put("customerName", r.getStr("nickname")); m.put("packageName", r.getStr("package_name")); m.put("startTime", r.getDate("start_time")); al.add(m); }
            d.put("activeSessions", al);
            renderJson(new ApiReturn().addData("data", d).success());
        } catch (Exception e) { log.error("工作台异常", e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }

    @RequireLogin @MethodValidation("GET")
    public void shopManage() {
        BigInteger shopId = MpHelper.getShopId(this);
        if (shopId == null) { renderJson(new ApiReturn().addMsg("请先选择店铺").fail()); return; }
        try {
            Map<String, Object> d = new HashMap<>();
            d.put("todaySales", Db.queryBigDecimal("SELECT COALESCE(SUM(paid_amount), 0) FROM purchases WHERE shop_id = ? AND DATE(created_at) = CURDATE() AND is_deleted = 0", shopId));
            d.put("todayOrders", Db.queryLong("SELECT COUNT(*) FROM purchases WHERE shop_id = ? AND DATE(created_at) = CURDATE() AND is_deleted = 0", shopId));
            d.put("todayCheckins", Db.queryLong("SELECT COUNT(*) FROM game_sessions WHERE shop_id = ? AND DATE(start_time) = CURDATE() AND is_deleted = 0", shopId));
            List<Map<String, Object>> trend = new ArrayList<>();
            for (int i = 6; i >= 0; i--) {
                Map<String, Object> p = new HashMap<>();
                BigDecimal amt = Db.queryBigDecimal("SELECT COALESCE(SUM(paid_amount), 0) FROM purchases WHERE shop_id = ? AND DATE(created_at) = DATE_SUB(CURDATE(), INTERVAL ? DAY) AND is_deleted = 0", shopId, i);
                p.put("amount", amt != null ? amt : BigDecimal.ZERO); trend.add(p);
            }
            d.put("revenueTrend", trend);
            renderJson(new ApiReturn().addData("data", d).success());
        } catch (Exception e) { log.error("店铺管理异常", e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }

    @RequireLogin @MethodValidation("GET")
    public void customers() {
        BigInteger shopId = MpHelper.getShopId(this);
        if (shopId == null) { renderJson(new ApiReturn().addMsg("请先选择店铺").fail()); return; }
        String keyword = getPara("keyword");
        int page = getParaToInt("page", 1); int size = getParaToInt("size", 20);
        try {
            if (keyword != null && !keyword.isEmpty()) {
                Page<Record> pg = Db.paginate(page, size, "SELECT *",
                    "FROM customers WHERE shop_id = ? AND is_deleted = 0 AND (nickname LIKE ? OR phone LIKE ?) ORDER BY created_at DESC",
                    shopId, "%" + keyword + "%", "%" + keyword + "%");
                renderJson(new ApiReturn().addData("list", pg.getList()).addData("total", pg.getTotalRow()).addData("page", page).addData("size", size).success());
            } else {
                renderJson(new ApiReturn().addMsg("请输入搜索关键词").fail());
            }
        } catch (Exception e) { log.error("顾客搜索异常", e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }

    @RequireLogin @MethodValidation("GET")
    public void customerDetail() {
        BigInteger shopId = MpHelper.getShopId(this);
        BigInteger customerId = MpHelper.parseBigInteger(getPara("customerId"));
        if (shopId == null || customerId == null) { renderJson(new ApiReturn().addMsg("参数不完整").fail()); return; }
        try {
            Record c = Db.findFirst("SELECT * FROM customers WHERE id = ? AND shop_id = ? AND is_deleted = 0", customerId, shopId);
            if (c == null) { renderJson(new ApiReturn().addMsg("顾客不存在").fail()); return; }
            Map<String, Object> d = new HashMap<>();
            d.put("id", c.getBigInteger("id")); d.put("nickname", c.getStr("nickname"));
            d.put("phone", c.getStr("phone")); d.put("avatar", c.getStr("avatar_url"));
            Record wallet = Db.findFirst("SELECT * FROM customer_wallets WHERE customer_id = ? AND is_deleted = 0", customerId);
            d.put("walletBalance", wallet != null ? wallet.getBigDecimal("balance") : BigDecimal.ZERO);
            Record lp = Db.findFirst("SELECT balance_after FROM points_records WHERE customer_id = ? ORDER BY created_at DESC LIMIT 1", customerId);
            d.put("points", lp != null ? lp.getInt("balance_after") : 0);
            d.put("availableSessions", Db.queryLong("SELECT COUNT(*) FROM customer_sessions WHERE customer_id = ? AND status = 1 AND is_deleted = 0", customerId));
            List<Record> purchases = Db.find("SELECT pr.*, pkg.name AS package_name FROM purchases pr LEFT JOIN packages pkg ON pr.package_id = pkg.id WHERE pr.customer_id = ? AND pr.is_deleted = 0 ORDER BY pr.created_at DESC LIMIT 10", customerId);
            d.put("purchases", purchases);
            List<Record> gameSessions = Db.find("SELECT gs.*, pkg.name AS package_name FROM game_sessions gs LEFT JOIN customer_sessions cs ON gs.customer_session_id = cs.id LEFT JOIN purchases pr ON cs.purchase_id = pr.id LEFT JOIN packages pkg ON pr.package_id = pkg.id WHERE gs.customer_id = ? AND gs.is_deleted = 0 ORDER BY gs.start_time DESC LIMIT 10", customerId);
            d.put("gameSessions", gameSessions);
            renderJson(new ApiReturn().addData("data", d).success());
        } catch (Exception e) { log.error("顾客详情异常", e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }

    @RequireLogin @MethodValidation("GET")
    public void customerSessions() {
        BigInteger shopId = MpHelper.getShopId(this);
        BigInteger customerId = MpHelper.parseBigInteger(getPara("customerId"));
        if (shopId == null || customerId == null) { renderJson(new ApiReturn().addMsg("参数不完整").fail()); return; }
        try {
            List<Record> sessions = Db.find(
                "SELECT cs.*, pr.package_id, pkg.name AS package_name, pkg.type AS package_type " +
                "FROM customer_sessions cs LEFT JOIN purchases pr ON cs.purchase_id = pr.id " +
                "LEFT JOIN packages pkg ON pr.package_id = pkg.id " +
                "WHERE cs.customer_id = ? AND cs.shop_id = ? AND cs.status = 1 AND cs.is_deleted = 0 " +
                "ORDER BY cs.session_date ASC", customerId, shopId);
            renderJson(new ApiReturn().addData("list", sessions).success());
        } catch (Exception e) { log.error("查询顾客次卡异常", e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }

    @RequireLogin @MethodValidation("GET")
    public void activeGameSessions() {
        BigInteger shopId = MpHelper.getShopId(this);
        if (shopId == null) { renderJson(new ApiReturn().addMsg("请先选择店铺").fail()); return; }
        try {
            List<Record> active = Db.find("SELECT gs.*, c.nickname, pkg.name AS package_name FROM game_sessions gs LEFT JOIN customers c ON gs.customer_id = c.id LEFT JOIN customer_sessions cs ON gs.customer_session_id = cs.id LEFT JOIN purchases pr ON cs.purchase_id = pr.id LEFT JOIN packages pkg ON pr.package_id = pkg.id WHERE gs.shop_id = ? AND gs.status = 1 AND gs.is_deleted = 0 ORDER BY gs.start_time DESC", shopId);
            List<Map<String, Object>> list = new ArrayList<>();
            for (Record r : active) { Map<String, Object> m = new HashMap<>(); m.put("id", r.getBigInteger("id")); m.put("customerId", r.getBigInteger("customer_id")); m.put("customerName", r.getStr("nickname")); m.put("packageName", r.getStr("package_name")); m.put("startTime", r.getDate("start_time")); list.add(m); }
            renderJson(new ApiReturn().addData("list", list).success());
        } catch (Exception e) { log.error("场次查询异常", e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }

    @RequireLogin @MethodValidation("POST")
    public void checkin() {
        BigInteger shopId = MpHelper.getShopId(this);
        BigInteger staffId = getStaffId();
        if (shopId == null || staffId == null) { renderJson(new ApiReturn().addMsg("请先选择店铺并确保是店铺员工").fail()); return; }
        BigInteger customerSessionId = MpHelper.parseBigInteger(getPara("customerSessionId"));
        BigInteger customersId = MpHelper.parseBigInteger(getPara("customersId"));
        if (customerSessionId == null || customersId == null) { renderJson(new ApiReturn().addMsg("参数不完整").fail()); return; }
        try {
            boolean ok = Db.tx(() -> {
                Record cs = Db.findFirst("SELECT * FROM customer_sessions WHERE id = ? AND customer_id = ? AND shop_id = ? AND status = 1 AND is_deleted = 0", customerSessionId, customersId, shopId);
                if (cs == null) return false;
                Date now = new Date();
                Record gs = new Record().set("shop_id", shopId).set("customer_id", customersId)
                    .set("customer_session_id", customerSessionId).set("staff_id", staffId)
                    .set("start_time", now).set("status", 1).set("is_deleted", 0).set("created_at", now);
                Db.save("game_sessions", gs);
                cs.set("status", 2).set("used_at", now).set("game_session_id", gs.getBigInteger("id"));
                Db.update("customer_sessions", cs);
                setAttr("_checkinGsId", gs.getBigInteger("id"));
                return true;
            });
            if (ok) {
                renderJson(new ApiReturn().addData("data", Collections.singletonMap("id", getAttr("_checkinGsId"))).success());
            } else {
                renderJson(new ApiReturn().addMsg("该次卡不可用或不存在").fail());
            }
        } catch (Exception e) { log.error("核销异常", e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }

    @RequireLogin @MethodValidation("PUT")
    public void finish() {
        BigInteger shopId = MpHelper.getShopId(this);
        BigInteger staffId = getStaffId();
        if (shopId == null || staffId == null) { renderJson(new ApiReturn().addMsg("请先选择店铺并确保是店铺员工").fail()); return; }
        BigInteger gameSessionId = MpHelper.parseBigInteger(getPara("gameSessionId"));
        if (gameSessionId == null) { renderJson(new ApiReturn().addMsg("场次ID不能为空").fail()); return; }
        try {
            boolean ok = Db.tx(() -> {
                Record gs = Db.findById("game_sessions", gameSessionId);
                if (gs == null || gs.getInt("status") != 1) return false;
                if (!shopId.equals(gs.getBigInteger("shop_id"))) return false;
                gs.set("end_time", new Date()).set("status", 2);
                Db.update("game_sessions", gs);
                // BOM 物料扣库存
                Record cs = Db.findById("customer_sessions", gs.getBigInteger("customer_session_id"));
                if (cs != null) {
                    Record purchase = Db.findById("purchases", cs.getBigInteger("purchase_id"));
                    if (purchase != null && purchase.getBigInteger("package_id") != null) {
                        List<Record> bom = Db.find("SELECT * FROM package_bom WHERE package_id = ?", purchase.getBigInteger("package_id"));
                        for (Record b : bom) {
                            Db.update("UPDATE inventory SET quantity = quantity - ? WHERE material_id = ? AND shop_id = ? AND quantity >= ?",
                                b.getBigDecimal("quantity"), b.getBigInteger("material_id"), shopId, b.getBigDecimal("quantity"));
                        }
                    }
                }
                return true;
            });
            if (ok) {
                renderJson(new ApiReturn().success());
            } else {
                renderJson(new ApiReturn().addMsg("场次不存在、已结束或不属于该店铺").fail());
            }
        } catch (Exception e) { log.error("结束游玩异常", e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }

    @RequireLogin @MethodValidation("GET")
    public void pendingFeedbacks() {
        BigInteger shopId = MpHelper.getShopId(this);
        if (shopId == null) { renderJson(new ApiReturn().addMsg("请先选择店铺").fail()); return; }
        int page = getParaToInt("page", 1); int size = getParaToInt("size", 20);
        try {
            Page<Record> pg = Db.paginate(page, size, "SELECT f.*, c.nickname, c.avatar_url",
                "FROM feedbacks f LEFT JOIN customers c ON f.customer_id = c.id WHERE f.shop_id = ? AND f.status = 0 AND f.is_deleted = 0 ORDER BY f.created_at DESC", shopId);
            renderJson(new ApiReturn().addData("list", pg.getList()).addData("total", pg.getTotalRow()).addData("page", page).addData("size", size).success());
        } catch (Exception e) { log.error("待处理评价异常", e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }

    @RequireLogin @MethodValidation("PUT")
    public void replyFeedback() {
        BigInteger feedbackId = MpHelper.parseBigInteger(getPara("feedbackId"));
        String replyContent = getPara("replyContent");
        if (feedbackId == null || replyContent == null || replyContent.isEmpty()) { renderJson(new ApiReturn().addMsg("参数不完整").fail()); return; }
        try {
            Record f = Db.findById("feedbacks", feedbackId);
            if (f == null) { renderJson(new ApiReturn().addMsg("评价不存在").fail()); return; }
            f.set("reply_content", replyContent).set("status", 1);
            Db.update("feedbacks", f);
            renderJson(new ApiReturn().success());
        } catch (Exception e) { log.error("回复评价异常", e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }
}
