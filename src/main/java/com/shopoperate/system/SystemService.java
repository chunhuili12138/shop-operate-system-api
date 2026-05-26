package com.shopoperate.system;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.jfinal.kit.Prop;
import com.jfinal.kit.PropKit;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.jfinal.plugin.redis.Redis;
import com.shopoperate.common.model.Staff;
import com.shopoperate.common.model.StaffAccounts;
import com.shopoperate.common.vo.User;
import com.shopoperate.utils.PasswordUtil;
import com.shopoperate.utils.Tool;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.math.BigInteger;
import java.util.*;
import java.util.stream.Collectors;

public class SystemService {

    public static final SystemService me = new SystemService();

    private static final String WX_LOGIN_URL = "https://api.weixin.qq.com/sns/jscode2session";

    private static final int REFRESH_TOKEN_EXPIRE_SECONDS = 30 * 86400; // refreshToken 30天

    /**
     * 账号密码登录
     */
    public Map<String, Object> login(String username, String password, String captchaId, String captchaValue) throws Exception {
        Prop p = PropKit.useFirstFound("start-config-prod.txt", "start-config-dev.txt");
        int tokenExpireSeconds = p.getInt("tokenExpireSeconds", 86400);

        // 1. 验证码校验（强制）
        if (captchaId == null || captchaId.isEmpty() || captchaValue == null || captchaValue.isEmpty()) {
            return new HashMap<String, Object>() {{
                put("success", false);
                put("code", 200);
                put("msg", "验证码不能为空");
            }};
        }
        Object captchaRecord = Redis.call(j -> j.get("captcha:" + captchaId));
        if (captchaRecord == null || !captchaValue.equalsIgnoreCase(captchaRecord.toString())) {
            return new HashMap<String, Object>() {{
                put("success", false);
                put("code", 200);
                put("msg", "验证码错误或已过期");
            }};
        }
        // 验证通过后立即删除验证码，防止重复使用
        Redis.call(j -> j.del("captcha:" + captchaId));

        // 2. 查询账号
        StaffAccounts account = new StaffAccounts().dao().findFirst(
            "SELECT * FROM staff_accounts WHERE username = ? AND is_deleted = 0",
            username
        );

        if (account == null) {
            return new HashMap<String, Object>() {{
                put("success", false);
                put("code", 200);
                put("msg", "用户名或密码错误");
            }};
        }

        // 3. 验证密码
        if (!PasswordUtil.checkPassword(password, account.getPasswordHash())) {
            return new HashMap<String, Object>() {{
                put("success", false);
                put("code", 200);
                put("msg", "用户名或密码错误");
            }};
        }

        // 4. 查询员工信息
        Staff staff = new Staff().dao().findById(account.getStaffId());
        if (staff == null) {
            return new HashMap<String, Object>() {{
                put("success", false);
                put("code", 200);
                put("msg", "账号不存在");
            }};
        }

        // 5. 检查账号状态
        if (staff.getIsDeleted() != null && staff.getIsDeleted() == 1) {
            return new HashMap<String, Object>() {{
                put("success", false);
                put("code", 200);
                put("msg", "账号已被删除");
            }};
        }

        if (staff.getStatus() != null && staff.getStatus() == 0) {
            return new HashMap<String, Object>() {{
                put("success", false);
                put("code", 200);
                put("msg", "账号已离职，无法登录");
            }};
        }

        if (staff.getIsBan() != null && staff.getIsBan() == 1) {
            return new HashMap<String, Object>() {{
                put("success", false);
                put("code", 200);
                put("msg", "账号已被封禁，请联系管理员");
            }};
        }

        // 6. 查询角色信息
        List<Record> roles = Db.find(
            "SELECT r.* FROM roles r " +
            "INNER JOIN staff_roles sr ON r.id = sr.role_id " +
            "WHERE sr.staff_id = ?",
            staff.getId()
        );

        boolean isSuperAdmin = roles.stream().anyMatch(r -> r.getInt("id") == 2);

        // 7. 构建用户对象
        User user = new User();
        user.setId(staff.getId());
        user.setUsername(account.getUsername());
        user.setName(staff.getName());
        user.setNickname(staff.getName());
        user.setPhone(staff.getPhone());
        user.setAvatar(staff.getAvatar());
        user.setStatus(staff.getStatus());
        user.setIsBan(staff.getIsBan());
        user.setBossStatus(staff.getBossStatus());
        user.setIsSuperAdmin(isSuperAdmin ? 1 : 0);
        user.setLoginTime(new Date());

        // 8. 生成 Token 和 RefreshToken
        String token = Tool.getUUId();
        String refreshToken = Tool.getUUId();
        user.setToken(token);
        user.setRefreshToken(refreshToken);

        long now = System.currentTimeMillis();
        long expires = now + (tokenExpireSeconds * 1000L);

        JsonObject userJson = new Gson().toJsonTree(user).getAsJsonObject();
        // 存 accessToken
        Redis.call(j -> j.setex("token:" + token, tokenExpireSeconds, userJson.toString()));
        // 存 refreshToken -> 关联到 accessToken
        Redis.call(j -> j.setex("refresh:" + refreshToken, REFRESH_TOKEN_EXPIRE_SECONDS, token));
        // 存 accessToken -> 关联到 refreshToken（便于失效）
        Redis.call(j -> j.setex("token_ref:" + token, tokenExpireSeconds, refreshToken));

        // 9. 更新最后登录时间
        account.setLastLoginAt(new Date());
        account.update();

        // 10. 查询关联店铺列表（员工绑定 + 商户自有）
        List<Record> shops = getUserShops(staff.getId());

        // 11. 角色名称数组
        List<String> roleNames = roles.stream()
            .map(r -> r.getStr("name"))
            .collect(Collectors.toList());

        // 12. 查询按钮权限
        List<String> buttons = getUserButtons(staff.getId());

        // 13. 返回结果
        Map<String, Object> data = new HashMap<>();
        // 前端 login 需要：token, refreshToken, expires, superAdmin
        data.put("token", token);
        data.put("refreshToken", refreshToken);
        data.put("expires", new Date(expires));
        data.put("superAdmin", isSuperAdmin);
        // 完整用户信息
        data.put("userInfo", user);
        data.put("roles", roles);
        data.put("roleNames", roleNames);
        data.put("shops", shops);
        data.put("buttons", buttons);
        data.put("isSuperAdmin", isSuperAdmin);

        return new HashMap<String, Object>() {{
            put("success", true);
            put("data", data);
        }};
    }

    /**
     * 刷新 Token
     */
    public Map<String, Object> refreshToken(String refreshToken) {
        Prop p = PropKit.useFirstFound("start-config-prod.txt", "start-config-dev.txt");
        int tokenExpireSeconds = p.getInt("tokenExpireSeconds", 86400);

        // 1. 校验 refreshToken
        String oldToken = Redis.call(j -> j.get("refresh:" + refreshToken));
        if (oldToken == null) {
            return new HashMap<String, Object>() {{
                put("success", false);
                put("code", 401);
                put("msg", "refreshToken 已过期");
            }};
        }

        // 2. 获取用户信息
        String userInfoStr = Redis.call(j -> j.get("token:" + oldToken));
        if (userInfoStr == null) {
            Redis.call(j -> j.del("refresh:" + refreshToken));
            return new HashMap<String, Object>() {{
                put("success", false);
                put("code", 401);
                put("msg", "token 已过期，请重新登录");
            }};
        }

        User user = new Gson().fromJson(userInfoStr, User.class);

        // 3. 删除旧 token
        Redis.call(j -> j.del("token:" + oldToken));
        Redis.call(j -> j.del("token_ref:" + oldToken));

        // 4. 生成新 token
        String newToken = Tool.getUUId();
        String newRefreshToken = Tool.getUUId();
        user.setToken(newToken);
        user.setRefreshToken(newRefreshToken);

        long now = System.currentTimeMillis();
        long expires = now + (tokenExpireSeconds * 1000L);

        JsonObject userJson = new Gson().toJsonTree(user).getAsJsonObject();
        Redis.call(j -> j.setex("token:" + newToken, tokenExpireSeconds, userJson.toString()));
        Redis.call(j -> j.setex("refresh:" + newRefreshToken, REFRESH_TOKEN_EXPIRE_SECONDS, newToken));
        Redis.call(j -> j.setex("token_ref:" + newToken, tokenExpireSeconds, newRefreshToken));

        // 5. 删除旧 refreshToken
        Redis.call(j -> j.del("refresh:" + refreshToken));

        Map<String, Object> data = new HashMap<>();
        data.put("accessToken", newToken);
        data.put("token", newToken);
        data.put("refreshToken", newRefreshToken);
        data.put("expires", new Date(expires));

        return new HashMap<String, Object>() {{
            put("success", true);
            put("data", data);
        }};
    }

    /**
     * 获取用户信息（用于 /auth/info）
     */
    public Map<String, Object> getUserInfo(BigInteger staffId) {
        Staff staff = new Staff().dao().findById(staffId);
        if (staff == null) {
            return null;
        }

        StaffAccounts account = new StaffAccounts().dao().findFirst(
            "SELECT * FROM staff_accounts WHERE staff_id = ? AND is_deleted = 0",
            staffId
        );

        // 角色列表
        List<Record> roles = Db.find(
            "SELECT r.* FROM roles r " +
            "INNER JOIN staff_roles sr ON r.id = sr.role_id " +
            "WHERE sr.staff_id = ?",
            staffId
        );

        boolean isSuperAdmin = roles.stream().anyMatch(r -> r.getInt("id") == 2);
        List<String> roleNames = roles.stream()
            .map(r -> r.getStr("name"))
            .collect(Collectors.toList());

        // 按钮权限
        List<String> buttons = getUserButtons(staffId);

        // 菜单树（从 permissions 表构建）
        List<Map<String, Object>> menus = getUserMenus(isSuperAdmin ? null : staffId);

        // 关联店铺（员工绑定 + 商户自有）
        List<Record> shops = getUserShops(staffId);

        Map<String, Object> data = new HashMap<>();
        data.put("userId", staff.getId());
        data.put("username", account != null ? account.getUsername() : "");
        data.put("nickname", staff.getName());
        data.put("name", staff.getName());
        data.put("avatar", staff.getAvatar() != null ? staff.getAvatar() : "");
        data.put("phone", staff.getPhone());
        data.put("roles", roleNames);
        data.put("buttons", buttons);
        data.put("permissions", buttons);
        data.put("menus", menus);
        data.put("shops", shops);
        data.put("superAdmin", isSuperAdmin);
        data.put("isSuperAdmin", isSuperAdmin ? 1 : 0);

        return data;
    }

    /**
     * 查询用户关联的店铺列表（合并员工绑定 + 商户自有，去重）
     */
    public List<Record> getUserShops(BigInteger staffId) {
        // 查询员工绑定 + 商户自有，使用 UNION 去重
        return Db.find(
            "SELECT s.* FROM shops s INNER JOIN staff_shops ss ON s.id = ss.shop_id " +
            "WHERE ss.staff_id = ? AND s.is_deleted = 0 " +
            "UNION " +
            "SELECT s.* FROM shops s WHERE s.owner_staff_id = ? AND s.is_deleted = 0",
            staffId, staffId
        );
    }

    /**
     * 查询用户的按钮权限列表
     */
    public List<String> getUserButtons(BigInteger staffId) {
        List<Record> perms = Db.find(
            "SELECT DISTINCT p.menu_code FROM permissions p " +
            "INNER JOIN role_permissions rp ON p.id = rp.permission_id " +
            "INNER JOIN staff_roles sr ON rp.role_id = sr.role_id " +
            "WHERE sr.staff_id = ? AND p.type = 3 AND p.is_active = 1 AND p.is_deleted = 0",
            staffId
        );
        return perms.stream()
            .map(r -> r.getStr("menu_code"))
            .collect(Collectors.toList());
    }

    /**
     * 构建菜单树
     * 超管（staffId=null）：查询 super_admin_visible=1 的权限（数据库配置）
     * 非超管（staffId!=null）：通过角色权限关联查询
     */
    public List<Map<String, Object>> getUserMenus(BigInteger staffId) {
        List<Record> allPerms;
        List<Record> btnPerms;

        if (staffId == null) {
            // 超管：从数据库中读取 super_admin_visible=1 的菜单
            allPerms = Db.find(
                "SELECT * FROM permissions WHERE super_admin_visible=1 AND type IN (1,2) AND is_active=1 AND is_deleted=0 ORDER BY parent_id, sort"
            );
            btnPerms = Db.find(
                "SELECT * FROM permissions WHERE type=3 AND is_active=1 AND is_deleted=0"
            );
        } else {
            allPerms = Db.find(
                "SELECT p.* FROM permissions p " +
                "INNER JOIN role_permissions rp ON p.id = rp.permission_id " +
                "INNER JOIN staff_roles sr ON rp.role_id = sr.role_id " +
                "WHERE sr.staff_id = ? AND p.type IN (1, 2) AND p.is_active = 1 AND p.is_deleted = 0 " +
                "ORDER BY p.parent_id, p.sort",
                staffId
            );
            btnPerms = Db.find(
                "SELECT DISTINCT p.* FROM permissions p " +
                "INNER JOIN role_permissions rp ON p.id = rp.permission_id " +
                "INNER JOIN staff_roles sr ON rp.role_id = sr.role_id " +
                "WHERE sr.staff_id = ? AND p.type = 3 AND p.is_active = 1 AND p.is_deleted = 0",
                staffId
            );
        }

        // parent_id -> children
        Map<Integer, List<Record>> parentMap = new HashMap<>();
        for (Record r : allPerms) {
            int parentId = r.getInt("parent_id");
            parentMap.computeIfAbsent(parentId, k -> new ArrayList<>()).add(r);
        }

        // parent_id -> button children
        Map<Integer, List<String>> btnMap = new HashMap<>();
        for (Record r : btnPerms) {
            int parentId = r.getInt("parent_id");
            btnMap.computeIfAbsent(parentId, k -> new ArrayList<>()).add(r.getStr("menu_code"));
        }

        // 递归构建
        List<Map<String, Object>> result = new ArrayList<>();
        List<Record> roots = parentMap.getOrDefault(0, new ArrayList<>());
        for (Record r : roots) {
            Map<String, Object> node = buildMenuNode(r, parentMap, btnMap);
            result.add(node);
        }

        return result;
    }

    private Map<String, Object> buildMenuNode(Record record, Map<Integer, List<Record>> parentMap,
                                                Map<Integer, List<String>> btnMap) {
        Map<String, Object> node = new HashMap<>();
        node.put("path", record.getStr("path"));
        node.put("name", record.getStr("menu_code"));
        node.put("component", record.getStr("component"));
        node.put("redirect", record.getStr("redirect"));

        Map<String, Object> meta = new HashMap<>();
        meta.put("title", record.getStr("name"));
        meta.put("icon", record.getStr("icon"));
        meta.put("rank", record.getInt("sort"));
        meta.put("showLink", true);

        // 附加当前节点的按钮权限
        int id = record.getInt("id");
        if (btnMap.containsKey(id)) {
            meta.put("auths", btnMap.get(id));
        }

        node.put("meta", meta);

        // 子菜单
        int recordId = record.getInt("id");
        List<Record> children = parentMap.getOrDefault(recordId, new ArrayList<>());
        if (!children.isEmpty()) {
            List<Map<String, Object>> childNodes = new ArrayList<>();
            for (Record child : children) {
                childNodes.add(buildMenuNode(child, parentMap, btnMap));
            }
            node.put("children", childNodes);
            // 父级 redirect 默认取第一个子 path
            if (node.get("redirect") == null) {
                node.put("redirect", children.get(0).getStr("path"));
            }
            // 父级 name 加 Parent 后缀避免冲突
            if (node.get("name") != null) {
                node.put("name", node.get("name") + "Parent");
            }
        }

        return node;
    }

    /**
     * 微信登录（管理平台员工端，保留原逻辑）
     */
    public Map<String, Object> wxLogin(String code) throws Exception {
        return wxLoginInternal(code, "staff", null);
    }

    /**
     * 微信登录（小程序端统一入口）
     * @param code 微信授权 code
     * @param userType 用户类型 "customer" / "staff"
     * @param shopId 可选，店铺ID。为null时仅返回 openid + 店铺列表
     */
    public Map<String, Object> mpWxLogin(String code, String userType, BigInteger shopId) throws Exception {
        return wxLoginInternal(code, userType, shopId);
    }

    /**
     * 微信登录核心逻辑
     */
    private Map<String, Object> wxLoginInternal(String code, String userType, BigInteger shopId) throws Exception {
        Prop p = PropKit.useFirstFound("start-config-prod.txt", "start-config-dev.txt");
        String appId = p.get("appId");
        String appSecret = p.get("appSecret");
        int tokenExpireSeconds = p.getInt("tokenExpireSeconds", 86400);

        String wxUrl = WX_LOGIN_URL + "?appid=" + appId + "&secret=" + appSecret
                + "&js_code=" + code + "&grant_type=authorization_code";

        String response = httpGet(wxUrl);
        Gson gson = new Gson();
        JsonObject json = gson.fromJson(response, JsonObject.class);

        if (json.has("errcode")) {
            return new HashMap<String, Object>() {{
                put("success", false);
                put("code", 200);
                put("msg", "微信登录失败：" + json.get("errmsg").getAsString());
            }};
        }

        String openId = json.get("openid").getAsString();

        // ===== 小程序：无 shopId 时仅返回 openid + 店铺列表 =====
        if (shopId == null && "customer".equals(userType)) {
            List<Record> shops = getMpShopsByOpenid(openId);
            Map<String, Object> data = new HashMap<>();
            data.put("openid", openId);
            data.put("shops", shops);
            return new HashMap<String, Object>() {{
                put("success", true);
                put("data", data);
            }};
        }

        // ===== customer 登录流程 =====
        if ("customer".equals(userType) && shopId != null) {
            return customerWxLogin(openId, shopId, tokenExpireSeconds);
        }

        // ===== staff 登录流程（原有逻辑） =====
        return staffWxLogin(openId, tokenExpireSeconds);
    }

    /**
     * 顾客微信登录
     */
    private Map<String, Object> customerWxLogin(String openId, BigInteger shopId, int tokenExpireSeconds) {
        // 0. 校验店铺是否存在
        Record shop = Db.findById("shops", shopId);
        if (shop == null || shop.getInt("is_deleted") == 1) {
            return new HashMap<String, Object>() {{
                put("success", false);
                put("code", 200);
                put("msg", "店铺不存在或已关闭");
            }};
        }

        // 1. 查找该 openid 在此店铺的顾客记录
        Record customer = Db.findFirst(
            "SELECT * FROM customers WHERE wechat_openid = ? AND shop_id = ? AND is_deleted = 0",
            openId, shopId);

        // 2. 未找到则自动注册
        if (customer == null) {
            com.shopoperate.app.AppCustomerService appSvc = com.shopoperate.app.AppCustomerService.me;
            customer = appSvc.registerByWechat(openId, "微信用户", null, shopId);
        }

        BigInteger customerId = customer.getBigInteger("id");
        String nickname = customer.getStr("nickname");
        String avatar = customer.getStr("avatar_url");
        String phone = customer.getStr("phone");

        // 3. 检测是否也是员工（同店铺 phone 匹配）
        int isStaff = 0;
        if (phone != null && !phone.isEmpty()) {
            long count = Db.queryLong(
                "SELECT COUNT(*) FROM staff s " +
                "INNER JOIN staff_shops ss ON s.id = ss.staff_id " +
                "WHERE s.phone = ? AND ss.shop_id = ? AND s.is_deleted = 0 AND s.status = 1",
                phone, shopId);
            if (count > 0) {
                isStaff = 1;
            }
        }

        // 4. 构建 User
        User user = new User();
        user.setId(customerId);
        user.setCustomerId(customerId);
        user.setUserType("customer");
        user.setIsStaff(isStaff);
        user.setUsername("");
        user.setName(nickname);
        user.setNickname(nickname);
        user.setPhone(phone);
        user.setAvatar(avatar);
        user.setStatus(1);
        user.setIsBan(0);
        user.setBossStatus(0);
        user.setIsSuperAdmin(0);
        user.setLoginShopId(shopId);
        user.setLoginTime(new Date());

        // 5. 生成 token
        String token = Tool.getUUId();
        String refreshToken = Tool.getUUId();
        user.setToken(token);
        user.setRefreshToken(refreshToken);

        long now = System.currentTimeMillis();
        long expires = now + (tokenExpireSeconds * 1000L);

        JsonObject userJson = new Gson().toJsonTree(user).getAsJsonObject();
        Redis.call(j -> j.setex("token:" + token, tokenExpireSeconds, userJson.toString()));
        Redis.call(j -> j.setex("refresh:" + refreshToken, REFRESH_TOKEN_EXPIRE_SECONDS, token));
        Redis.call(j -> j.setex("token_ref:" + token, tokenExpireSeconds, refreshToken));

        // 6. 构建返回
        Map<String, Object> customerInfo = new HashMap<>();
        customerInfo.put("id", customerId);
        customerInfo.put("nickname", nickname);
        customerInfo.put("avatar", avatar);
        customerInfo.put("phone", phone);

        Map<String, Object> shopInfo = new HashMap<>();
        if (shop != null && shop.getInt("is_deleted") == 0) {
            shopInfo.put("id", shop.getBigInteger("id"));
            shopInfo.put("name", shop.getStr("name"));
            shopInfo.put("status", shop.getInt("status"));
            shopInfo.put("address", shop.getStr("address"));
            shopInfo.put("contactPhone", shop.getStr("contact_phone"));
        }

        Map<String, Object> data = new HashMap<>();
        data.put("userInfo", user);
        data.put("token", token);
        data.put("refreshToken", refreshToken);
        data.put("expires", new Date(expires));
        data.put("userType", "customer");
        data.put("isStaff", isStaff);
        data.put("customerInfo", customerInfo);
        data.put("shopInfo", shopInfo);
        data.put("shops", Collections.singletonList(shopInfo));

        return new HashMap<String, Object>() {{
            put("success", true);
            put("data", data);
        }};
    }

    /**
     * 员工微信登录（原有逻辑）
     */
    private Map<String, Object> staffWxLogin(String openId, int tokenExpireSeconds) {
        StaffAccounts account = new StaffAccounts().dao().findFirst(
            "SELECT * FROM staff_accounts WHERE wechat_openid = ? AND is_deleted = 0",
            openId
        );

        if (account == null) {
            return new HashMap<String, Object>() {{
                put("success", false);
                put("code", 200);
                put("msg", "该微信未绑定账号，请先使用账号密码登录并绑定微信");
            }};
        }

        Staff staff = new Staff().dao().findById(account.getStaffId());
        if (staff == null || staff.getIsDeleted() == 1 || staff.getStatus() == 0 || staff.getIsBan() == 1) {
            return new HashMap<String, Object>() {{
                put("success", false);
                put("code", 200);
                put("msg", "账号状态异常");
            }};
        }

        List<Record> roles = Db.find(
            "SELECT r.* FROM roles r " +
            "INNER JOIN staff_roles sr ON r.id = sr.role_id " +
            "WHERE sr.staff_id = ?",
            staff.getId()
        );

        boolean isSuperAdmin = roles.stream().anyMatch(r -> r.getInt("id") == 2);

        User user = new User();
        user.setId(staff.getId());
        user.setUserType(isSuperAdmin ? "admin" : "staff");
        user.setIsStaff(1);
        user.setUsername(account.getUsername());
        user.setName(staff.getName());
        user.setNickname(staff.getName());
        user.setPhone(staff.getPhone());
        user.setAvatar(staff.getAvatar());
        user.setStatus(staff.getStatus());
        user.setIsBan(staff.getIsBan());
        user.setBossStatus(staff.getBossStatus());
        user.setIsSuperAdmin(isSuperAdmin ? 1 : 0);
        user.setLoginTime(new Date());

        String token = Tool.getUUId();
        String refreshToken = Tool.getUUId();
        user.setToken(token);
        user.setRefreshToken(refreshToken);

        long now = System.currentTimeMillis();
        long expires = now + (tokenExpireSeconds * 1000L);

        JsonObject userJson = new Gson().toJsonTree(user).getAsJsonObject();
        Redis.call(j -> j.setex("token:" + token, tokenExpireSeconds, userJson.toString()));
        Redis.call(j -> j.setex("refresh:" + refreshToken, REFRESH_TOKEN_EXPIRE_SECONDS, token));
        Redis.call(j -> j.setex("token_ref:" + token, tokenExpireSeconds, refreshToken));

        account.setLastLoginAt(new Date());
        account.update();

        List<Record> shops = getUserShops(staff.getId());

        Map<String, Object> data = new HashMap<>();
        data.put("userInfo", user);
        data.put("token", token);
        data.put("refreshToken", refreshToken);
        data.put("expires", new Date(expires));
        data.put("roles", roles);
        data.put("shops", shops);
        data.put("superAdmin", isSuperAdmin);

        return new HashMap<String, Object>() {{
            put("success", true);
            put("data", data);
        }};
    }

    /**
     * 根据 openid 查询可访问的店铺列表（顾客 + 员工双来源）
     */
    private List<Record> getMpShopsByOpenid(String openId) {
        return Db.find(
            "SELECT s.*, " +
            "CASE WHEN s.seat_id IS NOT NULL AND ss.status = 1 AND ss.end_date >= CURDATE() THEN 1 ELSE 0 END AS seat_valid " +
            "FROM shops s " +
            "LEFT JOIN seat_subscriptions ss ON s.seat_id = ss.id " +
            "WHERE s.is_deleted = 0 " +
            "ORDER BY s.status DESC, seat_valid DESC, s.created_at DESC");
    }

    /**
     * HTTP GET 请求
     */
    private String httpGet(String urlStr) throws Exception {
        URL url = new URL(urlStr);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setConnectTimeout(5000);
        conn.setReadTimeout(5000);

        BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
        StringBuilder sb = new StringBuilder();
        String line;

        while ((line = reader.readLine()) != null) {
            sb.append(line);
        }

        reader.close();
        conn.disconnect();

        return sb.toString();
    }

    /**
     * 修改密码
     */
    public Map<String, Object> changePassword(BigInteger staffId, String oldPassword, String newPassword) {
        StaffAccounts account = new StaffAccounts().dao().findFirst(
            "SELECT * FROM staff_accounts WHERE staff_id = ? AND is_deleted = 0",
            staffId
        );

        if (account == null) {
            return new HashMap<String, Object>() {{
                put("success", false);
                put("code", 200);
                put("msg", "账号不存在");
            }};
        }

        if (!PasswordUtil.checkPassword(oldPassword, account.getPasswordHash())) {
            return new HashMap<String, Object>() {{
                put("success", false);
                put("code", 200);
                put("msg", "原密码错误");
            }};
        }

        String newPasswordHash = PasswordUtil.hashPassword(newPassword);
        account.setPasswordHash(newPasswordHash);
        account.update();

        // TODO: 此处应失效该用户所有已分发的 token
        // 理想方案：User 对象中存一个 token_version，改密码时自增，
        // TokenInterceptor 校验 token_version 是否匹配，不匹配则拒绝。
        // 当前简化处理：依赖前端在改密码后重定向到登录页重新登录。

        return new HashMap<String, Object>() {{
            put("success", true);
        }};
    }

    /**
     * 删除账号（逻辑删除）
     */
    public Map<String, Object> deleteAccount(BigInteger staffId) {
        Staff staff = new Staff().dao().findById(staffId);

        if (staff == null) {
            return new HashMap<String, Object>() {{
                put("success", false);
                put("code", 200);
                put("msg", "账号不存在");
            }};
        }

        staff.setIsDeleted(1);
        staff.update();

        StaffAccounts account = new StaffAccounts().dao().findFirst(
            "SELECT * FROM staff_accounts WHERE staff_id = ?",
            staffId
        );

        if (account != null) {
            account.setPasswordHash(null);
            account.setWechatOpenid(null);
            account.update();
        }

        return new HashMap<String, Object>() {{
            put("success", true);
        }};
    }
}
