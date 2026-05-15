package com.shopoperate.admin;

import com.jfinal.core.Controller;
import com.jfinal.core.Path;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.shopoperate.common.annotation.MethodValidation;
import com.shopoperate.common.annotation.ParameterValidation;
import com.shopoperate.common.annotation.RequireLogin;
import com.shopoperate.common.annotation.RequirePermission;
import com.shopoperate.utils.ApiReturn;
import com.shopoperate.utils.PasswordUtil;
import org.apache.log4j.Logger;

import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.List;

@Path(value = "/api/admin/tenants")
public class TenantController extends Controller {

    private static final Logger logger = Logger.getLogger(TenantController.class);
    private final TenantService tenantService = TenantService.me;

    // ========== 商户管理 ==========

    @RequireLogin
    @RequirePermission("tenant:list")
    @MethodValidation("GET")
    public void page() {
        int pageNum = getParaToInt("page", 1);
        int pageSize = getParaToInt("size", 20);
        String keyword = getPara("keyword");
        String phone = getPara("phone");
        Integer banStatus = getParaToInt("banStatus");

        try {
            Page<Record> p = tenantService.page(pageNum, pageSize, keyword, phone, banStatus);
            java.util.Map<String,Object> _m=new java.util.HashMap<>();
            _m.put("list",p.getList()); _m.put("total",(int)p.getTotalRow());
            _m.put("page",pageNum); _m.put("size",pageSize);
            renderJson(new ApiReturn().addData("data",_m).success());
        } catch (Exception e) {
            logger.error("查询商户列表异常", e);
            renderJson(new ApiReturn().addMsg("查询失败").fail());
        }
    }

    @RequireLogin
    @RequirePermission("tenant:list")
    @MethodValidation("GET")
    public void list() {
        String keyword = getPara("keyword");
        String phone = getPara("phone");
        Integer banStatus = getParaToInt("banStatus");

        try {
            List<Record> list = tenantService.list(keyword, phone, banStatus);
            renderJson(new ApiReturn().addData("data", list).success());
        } catch (Exception e) {
            logger.error("查询商户列表异常", e);
            renderJson(new ApiReturn().addMsg("查询失败").fail());
        }
    }

    @RequireLogin
    @RequirePermission("tenant:list")
    @MethodValidation("GET")
    @ParameterValidation({ "staffId" })
    public void info() {
        BigInteger staffId = getParaToBigInteger("staffId");
        try {
            Record info = tenantService.info(staffId);
            if (info != null) {
                renderJson(new ApiReturn().addData("data", info).success());
            } else {
                renderJson(new ApiReturn().addMsg("商户不存在").fail());
            }
        } catch (Exception e) {
            logger.error("查询商户详情异常", e);
            renderJson(new ApiReturn().addMsg("查询失败").fail());
        }
    }

    @RequireLogin
    @RequirePermission("btn:tenant:add")
    @MethodValidation("POST")
    @ParameterValidation({ "name", "username", "password" })
    public void add() {
        String name = getPara("name");
        String phone = getPara("phone");
        String username = getPara("username");
        String password = getPara("password");
        Long maxSeats = getParaToLong("maxSeats");
        String remark = getPara("remark");

        // 校验密码强度
        String pwdMsg = PasswordUtil.validatePassword(password);
        if (pwdMsg != null) {
            renderJson(new ApiReturn().addMsg(pwdMsg).fail());
            return;
        }

        try {
            boolean success = tenantService.add(name, phone, username, password, maxSeats, remark);
            if (success) {
                renderJson(new ApiReturn().success());
            } else {
                renderJson(new ApiReturn().addMsg("新增失败").fail());
            }
        } catch (RuntimeException e) {
            // 业务错误（如用户名冲突）：fail 返回 code=200，前端弹 warning
            renderJson(new ApiReturn().addMsg(e.getMessage()).fail());
        } catch (Exception e) {
            logger.error("新增商户异常", e);
            renderJson(new ApiReturn().addMsg("系统异常").serverErr());
        }
    }

    @RequireLogin
    @RequirePermission("btn:tenant:edit")
    @MethodValidation("PUT")
    @ParameterValidation({ "staffId" })
    public void update() {
        BigInteger staffId = getParaToBigInteger("staffId");
        String name = getPara("name");
        String phone = getPara("phone");
        String remark = getPara("remark");

        try {
            boolean success = tenantService.update(staffId, name, phone, remark);
            if (success) {
                renderJson(new ApiReturn().success());
            } else {
                renderJson(new ApiReturn().addMsg("商户不存在").fail());
            }
        } catch (Exception e) {
            logger.error("修改商户异常", e);
            renderJson(new ApiReturn().addMsg("系统异常").serverErr());
        }
    }

    @RequireLogin
    @RequirePermission("btn:tenant:ban")
    @MethodValidation("PUT")
    @ParameterValidation({ "staffId", "banStatus" })
    public void ban() {
        BigInteger staffId = getParaToBigInteger("staffId");
        Integer banStatus = getParaToInt("banStatus");

        try {
            boolean success = tenantService.toggleBan(staffId, banStatus);
            if (success) {
                renderJson(new ApiReturn().success());
            } else {
                renderJson(new ApiReturn().addMsg("商户不存在").fail());
            }
        } catch (Exception e) {
            logger.error("封禁/解封商户异常", e);
            renderJson(new ApiReturn().addMsg("系统异常").serverErr());
        }
    }

    @RequireLogin
    @RequirePermission("btn:tenant:password")
    @MethodValidation("POST")
    @ParameterValidation({ "staffId", "newPassword" })
    public void password() {
        BigInteger staffId = getParaToBigInteger("staffId");
        String newPassword = getPara("newPassword");

        // 校验密码强度
        String pwdMsg = PasswordUtil.validatePassword(newPassword);
        if (pwdMsg != null) {
            renderJson(new ApiReturn().addMsg(pwdMsg).fail());
            return;
        }

        try {
            boolean success = tenantService.resetPassword(staffId, newPassword);
            if (success) {
                renderJson(new ApiReturn().success());
            } else {
                renderJson(new ApiReturn().addMsg("商户不存在").fail());
            }
        } catch (Exception e) {
            logger.error("重置密码异常", e);
            renderJson(new ApiReturn().addMsg("系统异常").serverErr());
        }
    }

    @RequireLogin
    @RequirePermission("btn:tenant:delete")
    @MethodValidation("DELETE")
    public void delete() {
        BigInteger staffId = getParaToBigInteger("staffId");
        try {
            boolean success = tenantService.delete(staffId);
            if (success) {
                renderJson(new ApiReturn().success());
            } else {
                renderJson(new ApiReturn().addMsg("商户不存在").fail());
            }
        } catch (Exception e) {
            logger.error("删除商户异常", e);
            renderJson(new ApiReturn().addMsg("系统异常").serverErr());
        }
    }

    // ========== 席位管理 ==========

    @RequireLogin
    @RequirePermission("btn:seat:add")
    @MethodValidation("POST")
    @ParameterValidation({ "staffId", "subscriptionType", "subscriptionNum", "amount" })
    public void seatAdd() {
        BigInteger staffId = getParaToBigInteger("staffId");
        Integer subscriptionType = getParaToInt("subscriptionType");
        Integer subscriptionNum = getParaToInt("subscriptionNum", 1);
        BigDecimal amount = new BigDecimal(getPara("amount"));
        String paymentMethod = getPara("paymentMethod");

        try {
            boolean success = tenantService.addSeat(staffId, subscriptionType, subscriptionNum, amount, paymentMethod);
            if (success) {
                renderJson(new ApiReturn().success());
            } else {
                renderJson(new ApiReturn().addMsg("新增席位失败").fail());
            }
        } catch (Exception e) {
            logger.error("新增席位异常", e);
            renderJson(new ApiReturn().addMsg("系统异常").serverErr());
        }
    }

    @RequireLogin
    @RequirePermission("btn:seat:renew")
    @MethodValidation("POST")
    @ParameterValidation({ "seatId", "subscriptionType", "subscriptionNum", "amount" })
    public void seatRenew() {
        BigInteger seatId = getParaToBigInteger("seatId");
        Integer subscriptionType = getParaToInt("subscriptionType");
        Integer subscriptionNum = getParaToInt("subscriptionNum", 1);
        BigDecimal amount = new BigDecimal(getPara("amount"));
        String paymentMethod = getPara("paymentMethod");

        try {
            boolean success = tenantService.renewSeat(seatId, subscriptionType, subscriptionNum, amount, paymentMethod);
            if (success) {
                renderJson(new ApiReturn().success());
            } else {
                renderJson(new ApiReturn().addMsg("续订席位失败").fail());
            }
        } catch (Exception e) {
            logger.error("续订席位异常", e);
            renderJson(new ApiReturn().addMsg("系统异常").serverErr());
        }
    }

    @RequireLogin
    @MethodValidation("GET")
    public void unboundSeats() {
        BigInteger staffId = getParaToBigInteger("staffId");
        try {
            List<Record> list = tenantService.unboundSeats(staffId);
            renderJson(new ApiReturn().addData("data", list).success());
        } catch (Exception e) {
            logger.error("查询未绑定席位异常", e);
            renderJson(new ApiReturn().addMsg("查询失败").fail());
        }
    }

    @RequireLogin
    @RequirePermission("btn:seat:delete")
    @MethodValidation("DELETE")
    public void seatDelete() {
        BigInteger seatId = getParaToBigInteger("seatId");
        try {
            boolean success = tenantService.deleteSeat(seatId);
            if (success) {
                renderJson(new ApiReturn().success());
            } else {
                renderJson(new ApiReturn().addMsg("席位不存在或已被店铺占用，无法删除").fail());
            }
        } catch (Exception e) {
            logger.error("删除席位异常", e);
            renderJson(new ApiReturn().addMsg("系统异常").serverErr());
        }
    }

    @RequireLogin
    @RequirePermission("tenant:seat")
    @MethodValidation("GET")
    public void seatList() {
        BigInteger staffId = getParaToBigInteger("staffId");
        try {
            List<Record> list = tenantService.seatList(staffId);
            renderJson(new ApiReturn().addData("data", list).success());
        } catch (Exception e) {
            logger.error("查询席位列表异常", e);
            renderJson(new ApiReturn().addMsg("查询失败").fail());
        }
    }

    @RequireLogin
    @RequirePermission("tenant:seat")
    @MethodValidation("GET")
    public void subscriptionTransactionList() {
        BigInteger staffId = getParaToBigInteger("staffId");
        BigInteger seatId = getParaToBigInteger("seatId");
        try {
            List<Record> list = tenantService.subscriptionTransactionList(staffId, seatId);
            renderJson(new ApiReturn().addData("data", list).success());
        } catch (Exception e) {
            logger.error("查询席位流水异常", e);
            renderJson(new ApiReturn().addMsg("查询失败").fail());
        }
    }

    @RequireLogin
    @RequirePermission("tenant:seat")
    @MethodValidation("PUT")
    @ParameterValidation({ "transactionId", "refundAmount", "deductedDays" })
    public void subscriptionTransactionRefund() {
        BigInteger transactionId = getParaToBigInteger("transactionId");
        BigDecimal refundAmount = new BigDecimal(getPara("refundAmount"));
        Integer deductedDays = getParaToInt("deductedDays");

        try {
            boolean success = tenantService.refundTransaction(transactionId, refundAmount, deductedDays);
            if (success) {
                renderJson(new ApiReturn().success());
            } else {
                renderJson(new ApiReturn().addMsg("退款失败，请检查交易状态和退款参数").fail());
            }
        } catch (Exception e) {
            logger.error("退款异常", e);
            renderJson(new ApiReturn().addMsg("系统异常").serverErr());
        }
    }

    private BigInteger getParaToBigInteger(String name) {
        String val = getPara(name);
        if (val == null || val.isEmpty()) return null;
        try { return new BigInteger(val); } catch (NumberFormatException e) { return null; }
    }
}
