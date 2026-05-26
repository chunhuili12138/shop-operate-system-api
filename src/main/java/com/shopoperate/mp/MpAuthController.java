package com.shopoperate.mp;

import com.jfinal.core.Controller;
import com.jfinal.core.Path;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.shopoperate.common.annotation.MethodValidation;
import com.shopoperate.common.annotation.ParameterValidation;
import com.shopoperate.common.annotation.RepeatSubmit;
import com.shopoperate.common.annotation.RequireLogin;
import com.shopoperate.common.vo.User;
import com.shopoperate.system.SystemService;
import com.shopoperate.utils.ApiReturn;
import org.apache.log4j.Logger;

import java.math.BigInteger;
import java.util.HashMap;
import java.util.Map;

/**
 * 小程序认证控制器
 * 路径前缀：/api/mp/auth
 */
@Path(value = "/api/mp/auth")
public class MpAuthController extends Controller {

    private static final Logger log = Logger.getLogger(MpAuthController.class);
    private final SystemService systemService = SystemService.me;

    /**
     * 微信登录（小程序端统一入口）
     * POST /api/mp/auth/wechatLogin
     */
    @RepeatSubmit(lockTime = 3)
    @MethodValidation("POST")
    @ParameterValidation({"code"})
    public void wechatLogin() {
        String code = getPara("code");
        String userType = getPara("userType", "customer");
        BigInteger shopId = null;
        String shopIdStr = getPara("shopId");
        if (shopIdStr != null && !shopIdStr.isEmpty()) {
            try {
                shopId = new BigInteger(shopIdStr);
            } catch (NumberFormatException ignored) {}
        }

        try {
            Map<String, Object> result = systemService.mpWxLogin(code, userType, shopId);

            if ((Boolean) result.get("success")) {
                renderJson(new ApiReturn()
                    .addData("data", result.get("data"))
                    .success());
            } else {
                renderJson(new ApiReturn()
                    .addMsg(result.get("msg").toString())
                    .fail());
            }
        } catch (Exception e) {
            log.error("小程序微信登录异常", e);
            renderJson(new ApiReturn().addMsg("系统异常：" + e.getMessage()).serverErr());
        }
    }

    /**
     * 获取当前用户信息
     * GET /api/mp/auth/info
     */
    @RequireLogin
    @MethodValidation("GET")
    public void info() {
        User user = getSessionAttr("userinfo");

        if (user == null) {
            renderJson(new ApiReturn().loginInvalid());
            return;
        }

        try {
            Map<String, Object> data;

            if ("customer".equals(user.getUserType())) {
                data = buildCustomerInfo(user);
            } else {
                data = systemService.getUserInfo(user.getId());
                if (data != null) {
                    data.put("userType", user.getUserType());
                    data.put("isStaff", 1);
                }
            }

            if (data != null) {
                renderJson(new ApiReturn().addData("data", data).success());
            } else {
                renderJson(new ApiReturn().addMsg("用户信息不存在").fail());
            }
        } catch (Exception e) {
            log.error("获取用户信息异常", e);
            renderJson(new ApiReturn().addMsg("系统异常：" + e.getMessage()).serverErr());
        }
    }

    /**
     * 构建顾客端用户信息
     */
    private Map<String, Object> buildCustomerInfo(User user) {
        Map<String, Object> data = new HashMap<>();

        BigInteger customerId = user.getCustomerId();
        BigInteger shopId = user.getLoginShopId();

        // 顾客基本信息
        Record customer = Db.findFirst(
            "SELECT * FROM customers WHERE id = ? AND is_deleted = 0", customerId);
        if (customer == null) {
            return null;
        }

        Map<String, Object> customerInfo = new HashMap<>();
        customerInfo.put("id", customerId);
        customerInfo.put("nickname", customer.getStr("nickname"));
        customerInfo.put("avatar", customer.getStr("avatar_url"));
        customerInfo.put("phone", customer.getStr("phone"));
        customerInfo.put("gender", customer.getInt("gender"));
        customerInfo.put("birthday", customer.getStr("birthday"));

        // 钱包信息
        Record wallet = Db.findFirst(
            "SELECT * FROM customer_wallets WHERE customer_id = ? AND is_deleted = 0", customerId);
        if (wallet != null) {
            customerInfo.put("walletBalance", wallet.getBigDecimal("balance"));
            customerInfo.put("totalRecharged", wallet.getBigDecimal("total_recharged"));
            customerInfo.put("totalSpent", wallet.getBigDecimal("total_spent"));
        } else {
            customerInfo.put("walletBalance", 0);
            customerInfo.put("totalRecharged", 0);
            customerInfo.put("totalSpent", 0);
        }

        // 积分
        Record pointsLast = Db.findFirst(
            "SELECT balance_after FROM points_records WHERE customer_id = ? ORDER BY created_at DESC LIMIT 1", customerId);
        int points = pointsLast != null ? pointsLast.getInt("balance_after") : 0;
        customerInfo.put("points", points);

        // 优惠券数量
        long couponCount = Db.queryLong(
            "SELECT COUNT(*) FROM coupon_usages WHERE customer_id = ? AND status = 1 AND is_deleted = 0", customerId);
        customerInfo.put("couponCount", couponCount);

        // 店铺信息
        Record shop = Db.findById("shops", shopId);
        Map<String, Object> shopInfo = new HashMap<>();
        if (shop != null && shop.getInt("is_deleted") == 0) {
            shopInfo.put("id", shop.getBigInteger("id"));
            shopInfo.put("name", shop.getStr("name"));
            shopInfo.put("status", shop.getInt("status"));
            shopInfo.put("address", shop.getStr("address"));
            shopInfo.put("contactPhone", shop.getStr("contact_phone"));
            shopInfo.put("signPhoto", shop.getStr("sign_photo"));
            shopInfo.put("maxCapacity", shop.getInt("max_capacity"));
        }

        // 员工关联信息
        Map<String, Object> staffInfo = null;
        if (user.getIsStaff() != null && user.getIsStaff() == 1) {
            String phone = customer.getStr("phone");
            if (phone != null && !phone.isEmpty()) {
                Record staff = Db.findFirst(
                    "SELECT s.* FROM staff s " +
                    "INNER JOIN staff_shops ss ON s.id = ss.staff_id " +
                    "WHERE s.phone = ? AND ss.shop_id = ? AND s.is_deleted = 0 AND s.status = 1 LIMIT 1",
                    phone, shopId);
                if (staff != null) {
                    staffInfo = new HashMap<>();
                    staffInfo.put("id", staff.getBigInteger("id"));
                    staffInfo.put("name", staff.getStr("name"));
                    staffInfo.put("avatar", staff.getStr("avatar"));
                }
            }
        }

        data.put("userType", "customer");
        data.put("isStaff", user.getIsStaff() != null && user.getIsStaff() == 1);
        data.put("customerInfo", customerInfo);
        data.put("shopInfo", shopInfo);
        if (staffInfo != null) {
            data.put("staffInfo", staffInfo);
        }

        return data;
    }
}
