package com.shopoperate.app;

import com.jfinal.core.Controller;
import com.jfinal.core.Path;
import com.jfinal.plugin.activerecord.Record;
import com.shopoperate.common.annotation.MethodValidation;
import com.shopoperate.common.annotation.RequireLogin;
import com.shopoperate.common.annotation.RepeatSubmit;
import com.shopoperate.common.vo.User;
import com.shopoperate.utils.ApiReturn;
import com.shopoperate.utils.OperationLogUtil;
import org.apache.log4j.Logger;

import java.math.BigInteger;

@Path(value = "/api/app/customer")
public class AppCustomerController extends Controller {

    private static final Logger log = Logger.getLogger(AppCustomerController.class);
    private final AppCustomerService s = AppCustomerService.me;

    /**
     * 绑定手机号并合并账号
     * POST /api/app/customer/bindPhone
     */
    @RequireLogin @RepeatSubmit(lockTime = 3) @MethodValidation("POST")
    public void bindPhone() {
        User u = getSessionAttr("userinfo");
        try {
            String wechatOpenid = getPara("wechatOpenid");
            String phone = getPara("phone");
            BigInteger shopId = u.getLoginShopId();

            if (wechatOpenid == null || wechatOpenid.isEmpty()) {
                renderJson(new ApiReturn().addMsg("wechatOpenid不能为空").fail());
                return;
            }
            if (phone == null || phone.isEmpty()) {
                renderJson(new ApiReturn().addMsg("手机号不能为空").fail());
                return;
            }
            if (shopId == null) {
                renderJson(new ApiReturn().addMsg("请先选择店铺").fail());
                return;
            }

            // 查找目标顾客是否存在
            Record target = s.findByWechatOpenid(wechatOpenid, shopId);
            if (target == null) {
                renderJson(new ApiReturn().addMsg("微信账号未找到，请先通过微信小程序登录创建账号").fail());
                return;
            }

            boolean ok = s.bindPhoneAndMerge(wechatOpenid, phone, shopId);
            if (ok) {
                operationLog(u, "merge", target.getBigInteger("id"));
                renderJson(new ApiReturn().success());
            } else {
                renderJson(new ApiReturn().addMsg("合并失败").fail());
            }
        } catch (Exception e) {
            log.error("绑定手机号异常", e);
            renderJson(new ApiReturn().addMsg("系统异常").serverErr());
        }
    }

    /**
     * 微信小程序端查询当前顾客信息
     * GET /api/app/customer/info
     */
    @RequireLogin @MethodValidation("GET")
    public void info() {
        User u = getSessionAttr("userinfo");
        try {
            String wechatOpenid = getPara("wechatOpenid");
            if (wechatOpenid == null || wechatOpenid.isEmpty()) {
                renderJson(new ApiReturn().addMsg("wechatOpenid不能为空").fail());
                return;
            }
            Record c = s.findByWechatOpenid(wechatOpenid, u.getLoginShopId());
            if (c != null) {
                renderJson(new ApiReturn().addData("data", c).success());
            } else {
                renderJson(new ApiReturn().addMsg("顾客不存在").fail());
            }
        } catch (Exception e) {
            log.error("查询顾客信息异常", e);
            renderJson(new ApiReturn().addMsg("系统异常").serverErr());
        }
    }

    private void operationLog(User u, String action, BigInteger targetId) {
        try {
            String ip = getHeader("X-Forwarded-For");
            if (ip != null && !ip.isEmpty()) ip = ip.split(",")[0].trim();
            else ip = getRequest().getRemoteAddr();
            OperationLogUtil.log(1, u.getId(), action, "customer", targetId, null, ip);
        } catch (Exception e) { /* 日志失败不影响主流程 */ }
    }
}
