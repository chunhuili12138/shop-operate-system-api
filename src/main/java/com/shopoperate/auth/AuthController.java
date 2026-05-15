package com.shopoperate.auth;

import com.jfinal.core.Controller;
import com.jfinal.core.Path;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.jfinal.plugin.redis.Redis;
import com.shopoperate.common.annotation.MethodValidation;
import com.shopoperate.common.annotation.ParameterValidation;
import com.shopoperate.common.annotation.RepeatSubmit;
import com.shopoperate.common.annotation.RequireLogin;
import com.shopoperate.common.vo.User;
import com.shopoperate.system.SystemService;
import com.shopoperate.utils.ApiReturn;
import com.shopoperate.utils.CaptchaUtil;
import com.shopoperate.utils.OperationLogUtil;
import com.shopoperate.utils.PasswordUtil;
import org.apache.log4j.Logger;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.jfinal.plugin.activerecord.Record;

/**
 * 认证控制器
 * 路径前缀：/api/auth
 */
@Path(value = "/api/auth")
public class AuthController extends Controller {

    private static final Logger logger = Logger.getLogger(AuthController.class);
    private final SystemService systemService = SystemService.me;

    /**
     * 账号密码登录
     * POST /api/auth/login
     */
    @RepeatSubmit()
    @MethodValidation("POST")
    @ParameterValidation({ "username", "password", "captchaId", "captchaValue" })
    public void login() {
        String username = getPara("username");
        String password = getPara("password");
        String captchaId = getPara("captchaId");
        String captchaValue = getPara("captchaValue");

        try {
            Map<String, Object> result = systemService.login(username, password, captchaId, captchaValue);

            if ((Boolean) result.get("success")) {
                Map<String, Object> data = (Map<String, Object>) result.get("data");
                User userInfo = (User) data.get("userInfo");
                java.math.BigInteger staffId = userInfo.getId();

                String ipAddress = getRealIp();
                OperationLogUtil.logLogin(staffId, ipAddress, true, "登录成功");

                renderJson(new ApiReturn()
                    .addData("data", data)
                    .success());
            } else {
                String ipAddress = getRealIp();
                OperationLogUtil.logLogin(java.math.BigInteger.ZERO, ipAddress, false, result.get("msg").toString());

                renderJson(new ApiReturn()
                    .addMsg(result.get("msg").toString())
                    .fail());
            }
        } catch (Exception e) {
            logger.error("登录异常", e);
            renderJson(new ApiReturn().addMsg("系统异常：" + e.getMessage()).serverErr());
        }
    }

    /**
     * 获取验证码
     * GET /api/auth/captcha
     */
    @MethodValidation("GET")
    public void captcha() {
        try {
            Map<String, String> captchaInfo = CaptchaUtil.getCaptchaQuestion();
            String captchaId = captchaInfo.get("captchaId");
            String result = captchaInfo.get("result");

            // 存入 Redis，5分钟过期
            Redis.call(j -> j.setex("captcha:" + captchaId, 300, result));

            byte[] imageBytes = CaptchaUtil.getCaptchaImage(captchaInfo.get("question"));

            Map<String, Object> data = new HashMap<>();
            data.put("captchaId", captchaId);
            data.put("captchaImage", imageBytes);

            // 返回 base64 编码的图片
            String base64 = java.util.Base64.getEncoder().encodeToString(imageBytes);
            data.put("captchaBase64", "data:image/png;base64," + base64);

            renderJson(new ApiReturn()
                .addData("data", data)
                .success());
        } catch (Exception e) {
            logger.error("生成验证码异常", e);
            renderJson(new ApiReturn().addMsg("生成验证码失败").serverErr());
        }
    }

    /**
     * 刷新 Token
     * POST /api/auth/refresh-token
     */
    @RepeatSubmit()
    @MethodValidation("POST")
    @ParameterValidation({ "refreshToken" })
    public void refreshToken() {
        String refreshToken = getPara("refreshToken");

        try {
            Map<String, Object> result = systemService.refreshToken(refreshToken);

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
            logger.error("刷新Token异常", e);
            renderJson(new ApiReturn().addMsg("系统异常：" + e.getMessage()).serverErr());
        }
    }

    /**
     * 微信授权登录（员工/顾客）
     * POST /api/auth/wechatLogin
     */
    @RepeatSubmit()
    @MethodValidation("POST")
    @ParameterValidation({ "code", "userType" })
    public void wechatLogin() {
        String code = getPara("code");
        String userType = getPara("userType");

        try {
            Map<String, Object> result = systemService.wxLogin(code);

            if ((Boolean) result.get("success")) {
                Map<String, Object> data = (Map<String, Object>) result.get("data");
                data.put("userType", userType);

                renderJson(new ApiReturn()
                    .addData("data", data)
                    .success());
            } else {
                renderJson(new ApiReturn()
                    .addMsg(result.get("msg").toString())
                    .fail());
            }
        } catch (Exception e) {
            logger.error("微信登录异常", e);
            renderJson(new ApiReturn().addMsg("系统异常：" + e.getMessage()).serverErr());
        }
    }

    /**
     * 退出登录
     * POST /api/auth/logout
     */
    @RequireLogin
    @MethodValidation("POST")
    public void logout() {
        String token = getSessionAttr("token");

        if (token != null) {
            // 删除 accessToken 和关联的 refreshToken
            String refreshToken = Redis.call(j -> j.get("token_ref:" + token));
            if (refreshToken != null) {
                Redis.call(j -> j.del("refresh:" + refreshToken));
            }
            Redis.call(j -> j.del("token:" + token));
            Redis.call(j -> j.del("token_ref:" + token));

            removeSessionAttr("userinfo");
            removeSessionAttr("token");
        }

        renderJson(new ApiReturn().success());
    }

    /**
     * 获取当前用户信息（含菜单树、按钮权限）
     * GET /api/auth/info
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
            Map<String, Object> data = systemService.getUserInfo(user.getId());

            if (data != null) {
                renderJson(new ApiReturn()
                    .addData("data", data)
                    .success());
            } else {
                renderJson(new ApiReturn()
                    .addMsg("用户信息不存在")
                    .fail());
            }
        } catch (Exception e) {
            logger.error("获取用户信息异常", e);
            renderJson(new ApiReturn().addMsg("系统异常：" + e.getMessage()).serverErr());
        }
    }

    /**
     * 更新个人中心信息（姓名、手机号）
     * PUT /api/auth/profile
     */
    @RequireLogin
    @MethodValidation("PUT")
    public void profile() {
        User user = getSessionAttr("userinfo");
        if (user == null) { renderJson(new ApiReturn().loginInvalid()); return; }
        try {
            Record staff = Db.findById("staff", user.getId());
            if (staff == null) { renderJson(new ApiReturn().addMsg("用户不存在").fail()); return; }
            String name = getPara("name");
            String phone = getPara("phone");
            String avatar = getPara("avatar");
            if (name != null && !name.isEmpty()) staff.set("name", name);
            if (phone != null) staff.set("phone", phone);
            if (avatar != null) staff.set("avatar", avatar);
            staff.set("updated_at", new java.util.Date());
            boolean ok = Db.update("staff", staff);
            renderJson(ok ? new ApiReturn().success() : new ApiReturn().addMsg("更新失败").fail());
        } catch (Exception e) {
            logger.error("更新个人信息异常", e);
            renderJson(new ApiReturn().addMsg("系统异常").serverErr());
        }
    }

    /**
     * 获取用户关联店铺列表（用于登录后店铺选择）
     * GET /api/auth/shops
     */
    @RequireLogin
    @MethodValidation("GET")
    public void shops() {
        User user = getSessionAttr("userinfo");

        if (user == null) {
            renderJson(new ApiReturn().loginInvalid());
            return;
        }

        try {
            List<Record> shops = systemService.getUserShops(user.getId());

            Map<String, Object> data = new HashMap<>();
            data.put("shops", shops);
            data.put("superAdmin", user.getIsSuperAdmin() != null && user.getIsSuperAdmin() == 1);

            renderJson(new ApiReturn().addData("data", data).success());
        } catch (Exception e) {
            logger.error("获取店铺列表异常", e);
            renderJson(new ApiReturn().addMsg("系统异常：" + e.getMessage()).serverErr());
        }
    }

    /**
     * 修改当前用户密码
     * PUT /api/auth/password
     */
    @RequireLogin
    @MethodValidation("PUT")
    @ParameterValidation({ "oldPassword", "newPassword" })
    public void password() {
        User user = getSessionAttr("userinfo");

        if (user == null) {
            renderJson(new ApiReturn().loginInvalid());
            return;
        }

        String oldPassword = getPara("oldPassword");
        String newPassword = getPara("newPassword");

        // 校验密码强度
        String pwdMsg = PasswordUtil.validatePassword(newPassword);
        if (pwdMsg != null) {
            renderJson(new ApiReturn().addMsg(pwdMsg).fail());
            return;
        }

        try {
            Map<String, Object> result = systemService.changePassword(user.getId(), oldPassword, newPassword);

            if ((Boolean) result.get("success")) {
                renderJson(new ApiReturn().success());
            } else {
                renderJson(new ApiReturn()
                    .addMsg(result.get("msg").toString())
                    .fail());
            }
        } catch (Exception e) {
            logger.error("修改密码异常", e);
            renderJson(new ApiReturn().addMsg("系统异常：" + e.getMessage()).serverErr());
        }
    }

    /**
     * 微信端账号注销
     * POST /api/auth/wechatAccountDeletion
     */
    @RequireLogin
    @MethodValidation("POST")
    public void wechatAccountDeletion() {
        User user = getSessionAttr("userinfo");

        if (user == null) {
            renderJson(new ApiReturn().loginInvalid());
            return;
        }

        try {
            Map<String, Object> result = systemService.deleteAccount(user.getId());

            if ((Boolean) result.get("success")) {
                String token = getSessionAttr("token");
                if (token != null) {
                    String refreshToken = Redis.call(j -> j.get("token_ref:" + token));
                    if (refreshToken != null) {
                        Redis.call(j -> j.del("refresh:" + refreshToken));
                    }
                    Redis.call(j -> j.del("token:" + token));
                    Redis.call(j -> j.del("token_ref:" + token));
                }
                removeSessionAttr("userinfo");
                removeSessionAttr("token");

                renderJson(new ApiReturn().success());
            } else {
                renderJson(new ApiReturn()
                    .addMsg(result.get("msg").toString())
                    .fail());
            }
        } catch (Exception e) {
            logger.error("账号注销异常", e);
            renderJson(new ApiReturn().addMsg("系统异常：" + e.getMessage()).serverErr());
        }
    }

    /**
     * 获取真实IP地址
     */
    private String getRealIp() {
        String ip = getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = getHeader("X-Real-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = getRequest().getRemoteAddr();
        }
        if (ip != null && ip.indexOf(",") > 0) {
            ip = ip.substring(0, ip.indexOf(","));
        }
        return ip;
    }
}
