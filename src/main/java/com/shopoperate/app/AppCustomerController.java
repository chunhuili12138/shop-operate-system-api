package com.shopoperate.app;

import com.jfinal.core.Controller;
import com.jfinal.core.Path;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.shopoperate.common.annotation.MethodValidation;
import com.shopoperate.common.annotation.RequireLogin;
import com.shopoperate.common.annotation.RepeatSubmit;
import com.shopoperate.common.vo.User;
import com.shopoperate.utils.ApiReturn;
import com.shopoperate.utils.OperationLogUtil;
import com.shopoperate.utils.WechatApiUtil;
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
            BigInteger customerId = u.getCustomerId();

            // wechatOpenid 可选：若未传则从顾客记录中查找
            if ((wechatOpenid == null || wechatOpenid.isEmpty()) && customerId != null) {
                Record c = Db.findFirst("SELECT wechat_openid FROM customers WHERE id = ? AND is_deleted = 0", customerId);
                if (c != null) wechatOpenid = c.getStr("wechat_openid");
            }

            if (wechatOpenid == null || wechatOpenid.isEmpty()) {
                renderJson(new ApiReturn().addMsg("微信账号未找到").fail());
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
     * 微信一键获取手机号并绑定
     * POST /api/app/customer/getPhoneNumber
     */
    @RequireLogin @RepeatSubmit(lockTime = 3) @MethodValidation("POST")
    public void getPhoneNumber() {
        User u = getSessionAttr("userinfo");
        try {
            String code = getPara("code");
            if (code == null || code.isEmpty()) {
                renderJson(new ApiReturn().addMsg("code不能为空").fail());
                return;
            }

            // 调用微信 API 获取手机号
            String phone = WechatApiUtil.getPhoneNumber(code);
            if (phone == null || phone.isEmpty()) {
                renderJson(new ApiReturn().addMsg("获取手机号失败，请重试").fail());
                return;
            }

            BigInteger shopId = u.getLoginShopId();
            BigInteger customerId = u.getCustomerId();
            String wechatOpenid = null;

            // 查找 wechatOpenid
            if (customerId != null) {
                Record c = Db.findFirst("SELECT wechat_openid FROM customers WHERE id = ? AND is_deleted = 0", customerId);
                if (c != null) wechatOpenid = c.getStr("wechat_openid");
            }
            if (wechatOpenid == null || wechatOpenid.isEmpty()) {
                renderJson(new ApiReturn().addMsg("微信账号未找到").fail());
                return;
            }
            if (shopId == null) {
                renderJson(new ApiReturn().addMsg("请先选择店铺").fail());
                return;
            }

            boolean ok = s.bindPhoneAndMerge(wechatOpenid, phone, shopId);
            if (ok) {
                Record target = s.findByWechatOpenid(wechatOpenid, shopId);
                operationLog(u, "merge", target != null ? target.getBigInteger("id") : null);
                renderJson(new ApiReturn()
                    .addData("phone", phone)
                    .success());
            } else {
                renderJson(new ApiReturn().addMsg("绑定失败").fail());
            }
        } catch (Exception e) {
            log.error("获取手机号异常", e);
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
