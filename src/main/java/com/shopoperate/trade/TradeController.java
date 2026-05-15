package com.shopoperate.trade;

import com.jfinal.core.Controller;
import com.jfinal.core.Path;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.shopoperate.common.annotation.*;
import com.shopoperate.common.vo.User;
import com.shopoperate.utils.ApiReturn;
import org.apache.log4j.Logger;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.List;

@Path(value = "/api")
public class TradeController extends Controller {
    private static final Logger log = Logger.getLogger(TradeController.class);
    private final TradeService s = TradeService.me;

    // ---- Purchases ----
    @RequireLogin @MethodValidation("GET") public void purchases() {
        try { renderPage(s.purchasePage(getParaToInt("page",1), getParaToInt("size",20),
            getBigInteger("customersId"), getPara("keyword"), getPara("channel"), getPara("status"),
            getPara("startDate"), getPara("endDate"), shopId())); }
        catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("查询失败").fail()); }
    }

    @RequireLogin @RequirePermission("btn:purchase:add") @MethodValidation("POST") public void purchasesAdd() {
        User u = getSessionAttr("userinfo");
        try {
            String err = s.addPurchase(shopId(), getBigInteger("customersId"), getBigInteger("packageId"),
                getPara("channel"), getPara("paymentMethod"), new BigDecimal(getPara("totalAmount","0")),
                getPara("paidAmount")!=null?new BigDecimal(getPara("paidAmount")):null,
                getPara("thirdPartyCouponCode"), getBigInteger("couponUsageId"),
                getPara("remark"), u.getId(),
                getPara("paymentType"), getRequest().getRemoteAddr());
            renderJson(err == null ? new ApiReturn().success() : new ApiReturn().addMsg(err).fail());
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }

    // ---- Game Sessions ----
    @RequireLogin @MethodValidation("GET") public void gameSessions() {
        try {
            if ("available".equals(getPara(0))) {
                User u = getSessionAttr("userinfo");
                List<Record> list = s.availableSessions(getBigInteger("customersId"),
                    u != null && (u.getIsSuperAdmin() == null || u.getIsSuperAdmin() != 1) ? u.getLoginShopId() : null);
                renderJson(new ApiReturn().addData("data",list).success());
            } else if ("info".equals(getPara(0))) {
                User u = getSessionAttr("userinfo");
                Record r = s.gameSessionInfo(getBigInteger("gameSessionId"),
                    u != null && (u.getIsSuperAdmin() == null || u.getIsSuperAdmin() != 1) ? u.getLoginShopId() : null);
                renderJson(r!=null ? new ApiReturn().addData("data",r).success() : new ApiReturn().addMsg("记录不存在").fail());
            } else if ("sessions".equals(getPara(0))) {
                User u = getSessionAttr("userinfo");
                List<Record> list = s.purchaseSessionList(getBigInteger("purchaseId"),
                    u != null && (u.getIsSuperAdmin() == null || u.getIsSuperAdmin() != 1) ? u.getLoginShopId() : null);
                renderJson(new ApiReturn().addData("data",list).success());
            } else if ("list".equals(getPara(0)) || getPara(0)==null) {
                User u = getSessionAttr("userinfo");
                renderPage(s.gameSessionList(getBigInteger("customersId"), getPara("status"),
                    getPara("startDate"), getPara("endDate"), getPara("keyword"), getParaToInt("page",1), getParaToInt("size",20),
                    u != null && (u.getIsSuperAdmin() == null || u.getIsSuperAdmin() != 1) ? u.getLoginShopId() : null));
            }
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("查询失败").fail()); }
    }

    @RequireLogin @RequirePermission("btn:checkin:add") @MethodValidation("POST") public void gameSessionsCheckin() {
        User u = getSessionAttr("userinfo");
        try {
            boolean ok = s.checkin(getBigInteger("customersId"), getBigInteger("customerSessionId"), u.getId(),
                u.getIsSuperAdmin() == null || u.getIsSuperAdmin() != 1 ? shopId() : null);
            renderJson(ok ? new ApiReturn().success() : new ApiReturn().addMsg("核销失败").fail());
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }

    @RequireLogin @RequirePermission("btn:checkin:finish") @MethodValidation("PUT") public void gameSessionsFinish() {
        User u = getSessionAttr("userinfo");
        try {
            boolean ok = s.finish(getBigInteger("gameSessionId"),
                u.getIsSuperAdmin() == null || u.getIsSuperAdmin() != 1 ? shopId() : null);
            renderJson(ok ? new ApiReturn().success() : new ApiReturn().addMsg("结束失败").fail());
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }

    // ---- Refunds ----
    @RequireLogin @MethodValidation("GET") public void purchasesRefunds() {
        try { renderPage(s.refundPage(getParaToInt("page",1), getParaToInt("size",20),
            getPara("keyword"), getPara("status"),
            getPara("startDate"), getPara("endDate"), shopId())); }
        catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("查询失败").fail()); }
    }

    @RequireLogin @MethodValidation("GET") public void purchasesRefundsPreview() {
        User u = getSessionAttr("userinfo");
        try {
            Record r = s.refundPreview(getBigInteger("purchaseId"),
                u != null && (u.getIsSuperAdmin() == null || u.getIsSuperAdmin() != 1) ? u.getLoginShopId() : null);
            renderJson(r != null ? new ApiReturn().addData("data", r).success()
                : new ApiReturn().addMsg("购买记录不存在").fail());
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("查询失败").fail()); }
    }

    @RequireLogin @RequirePermission("btn:purchase:refund") @MethodValidation("POST") public void purchasesRefundsApply() {
        User u = getSessionAttr("userinfo");
        try {
            BigDecimal refundAmount = getPara("refundAmount") != null ? new BigDecimal(getPara("refundAmount")) : null;
            boolean ok = s.applyRefund(getBigInteger("purchaseId"), getPara("reason"), refundAmount,
                u != null && (u.getIsSuperAdmin() == null || u.getIsSuperAdmin() != 1) ? u.getLoginShopId() : null);
            renderJson(ok ? new ApiReturn().success() : new ApiReturn().addMsg("退款申请失败").fail());
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }

    @RequireLogin @RequirePermission("btn:refund:approve") @MethodValidation("PUT") public void purchasesRefundsApprove() {
        User u = getSessionAttr("userinfo");
        try {
            boolean ok = s.approveRefund(getBigInteger("refundId"), u.getId(), getRequest().getRemoteAddr(),
                u.getIsSuperAdmin() == null || u.getIsSuperAdmin() != 1 ? shopId() : null);
            renderJson(ok ? new ApiReturn().success() : new ApiReturn().addMsg("确认退款失败").fail());
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }

    @RequireLogin @RequirePermission("btn:refund:reject") @MethodValidation("PUT") public void purchasesRefundsReject() {
        User u = getSessionAttr("userinfo");
        try {
            boolean ok = s.rejectRefund(getBigInteger("refundId"), getPara("reason"),
                u.getIsSuperAdmin() == null || u.getIsSuperAdmin() != 1 ? shopId() : null);
            renderJson(ok ? new ApiReturn().success() : new ApiReturn().addMsg("拒绝退款失败").fail());
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }

    private void renderPage(Page<Record> p) {
        java.util.Map<String,Object> _m = new java.util.HashMap<>();
        _m.put("list", p.getList());
        _m.put("total", (int)p.getTotalRow());
        renderJson(new ApiReturn().addData("data", _m).success());
    }
    private BigInteger shopId() { User u=getSessionAttr("userinfo"); return u!=null?u.getLoginShopId():null; }
    private BigInteger getBigInteger(String n) { String v=getPara(n); return v==null||v.isEmpty()?null:new BigInteger(v); }
}
