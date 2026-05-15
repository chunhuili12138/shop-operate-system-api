package com.shopoperate.customer;

import com.jfinal.core.Controller;
import com.jfinal.core.Path;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.shopoperate.common.annotation.*;
import com.shopoperate.common.vo.User;
import com.shopoperate.utils.ApiReturn;
import com.shopoperate.utils.OperationLogUtil;
import org.apache.log4j.Logger;

import java.math.BigDecimal;
import java.math.BigInteger;

@Path(value = "/api/customers")
public class CustomerController extends Controller {

    private static final Logger log = Logger.getLogger(CustomerController.class);
    private final CustomerService s = CustomerService.me;

    @RequireLogin @MethodValidation("GET")
    public void page() {
        User u = getSessionAttr("userinfo");
        try {
            Page<Record> p = s.page(getParaToInt("page",1), getParaToInt("size",20),
                getPara("keyword"), getPara("phone"), getPara("source"), getPara("tag"), u.getLoginShopId());
            renderJson(new ApiReturn().addData("data",new java.util.HashMap<String,Object>(){{put("list",p.getList());put("total",(int)p.getTotalRow());}}).success());
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("查询失败").fail()); }
    }

    @RequireLogin @MethodValidation("GET")
    public void info() {
        User u = getSessionAttr("userinfo");
        try { Record r = s.info(getBigInteger("customersId"), u.getLoginShopId());
            if (r!=null) renderJson(new ApiReturn().addData("data",r).success());
            else renderJson(new ApiReturn().addMsg("顾客不存在").fail());
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("查询失败").fail()); }
    }

    @RequireLogin @RequirePermission("btn:customer:add") @MethodValidation("POST")
    public void add() {
        User u = getSessionAttr("userinfo");
        try {
            boolean ok = s.add(u.getLoginShopId(), getPara("nickname"), getPara("phone"),
                getParaToInt("gender"), getPara("birthday"), getPara("remark"), getPara("source", "offline"), getPara("avatarUrl"));
            if (ok) {
                operationLog(u, "add", null);
                renderJson(new ApiReturn().success());
            } else {
                renderJson(new ApiReturn().addMsg("手机号已存在").fail());
            }
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }

    @RequireLogin @RequirePermission("btn:customer:edit") @MethodValidation("PUT")
    public void update() {
        User u = getSessionAttr("userinfo");
        BigInteger customerId = getBigInteger("customersId");
        try {
            boolean ok = s.update(customerId, u.getLoginShopId(), getPara("nickname"), getPara("phone"),
                getParaToInt("gender"), getPara("birthday"), getPara("remark"), getPara("tags"), getPara("source"), getPara("avatarUrl"));
            if (ok) operationLog(u, "update", customerId);
            renderJson(ok ? new ApiReturn().success() : new ApiReturn().addMsg("编辑失败").fail());
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }

    @RequireLogin @MethodValidation("GET")
    public void purchases() {
        try {
            Page<Record> p = s.purchases(getBigInteger("customersId"), getPara("status"),
                getParaToInt("page",1), getParaToInt("size",20));
            renderJson(new ApiReturn().addData("data",new java.util.HashMap<String,Object>(){{put("list",p.getList());put("total",(int)p.getTotalRow());}}).success());
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("查询失败").fail()); }
    }

    @RequireLogin @MethodValidation("GET")
    public void wallet() {
        User u = getSessionAttr("userinfo");
        try {
            Record w = s.wallet(getBigInteger("customersId"), u.getLoginShopId());
            if (w == null) { renderJson(new ApiReturn().addMsg("钱包不存在").fail()); return; }
            w.set("transactions", s.walletTransactions(getBigInteger("customersId")));
            renderJson(new ApiReturn().addData("data",w).success());
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("查询失败").fail()); }
    }

    @RequireLogin @RequirePermission("btn:customer:wallet") @MethodValidation("POST")
    public void walletAdjust() {
        User u = getSessionAttr("userinfo");
        BigInteger customerId = getBigInteger("customersId");
        try {
            boolean ok = s.adjustWallet(customerId, u.getLoginShopId(),
                getParaToInt("type",1), new BigDecimal(getPara("amount")), getPara("remark"), u.getId());
            if (ok) operationLog(u, "wallet_adjust", customerId);
            renderJson(ok ? new ApiReturn().success() : new ApiReturn().addMsg("调整失败").fail());
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }

    @RequireLogin @MethodValidation("GET")
    public void points() {
        try {
            Page<Record> p = s.points(getBigInteger("customersId"), getParaToInt("page",1), getParaToInt("size",20));
            renderJson(new ApiReturn().addData("data",new java.util.HashMap<String,Object>(){{put("list",p.getList());put("total",(int)p.getTotalRow());}}).success());
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("查询失败").fail()); }
    }

    @RequireLogin @RequirePermission("btn:customer:points") @MethodValidation("PUT")
    public void pointsAdjust() {
        User u = getSessionAttr("userinfo");
        BigInteger customerId = getBigInteger("customersId");
        try {
            boolean ok = s.adjustPoints(customerId, u.getLoginShopId(), getParaToInt("points",0), getPara("remark"));
            if (ok) operationLog(u, "points_adjust", customerId);
            renderJson(ok ? new ApiReturn().success() : new ApiReturn().addMsg("调整失败").fail());
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }

    @RequireLogin @RequirePermission("btn:customer:delete") @MethodValidation("DELETE")
    public void delete() {
        User u = getSessionAttr("userinfo");
        BigInteger customerId = getBigInteger("customersId");
        try {
            boolean ok = s.delete(customerId, u.getLoginShopId());
            if (ok) operationLog(u, "delete", customerId);
            renderJson(ok ? new ApiReturn().success() : new ApiReturn().addMsg("删除失败").fail());
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }

    private void operationLog(User u, String action, BigInteger targetId) {
        try {
            OperationLogUtil.log(1, u.getId(), action, "customer", targetId, null, getRealIp());
        } catch (Exception e) { /* 日志失败不影响主流程 */ }
    }

    private String getRealIp() {
        String ip = getHeader("X-Forwarded-For");
        if (ip != null && !ip.isEmpty()) return ip.split(",")[0].trim();
        return getRequest().getRemoteAddr();
    }

    private BigInteger getBigInteger(String n) { String v = getPara(n); return v==null||v.isEmpty()?null:new BigInteger(v); }
}
