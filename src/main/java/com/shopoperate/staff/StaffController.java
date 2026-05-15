package com.shopoperate.staff;

import com.jfinal.core.Controller;
import com.jfinal.core.Path;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.jfinal.plugin.activerecord.Db;
import com.shopoperate.common.annotation.MethodValidation;
import com.shopoperate.common.annotation.ParameterValidation;
import com.shopoperate.common.annotation.RequireLogin;
import com.shopoperate.common.annotation.RequirePermission;
import com.shopoperate.common.vo.User;
import com.shopoperate.utils.ApiReturn;
import com.shopoperate.utils.PasswordUtil;
import org.apache.log4j.Logger;

import java.math.BigInteger;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@Path(value = "/api/staff")
public class StaffController extends Controller {

    private static final Logger logger = Logger.getLogger(StaffController.class);
    private final StaffService staffService = StaffService.me;

    /**
     * 员工分页列表
     * GET /api/staff/page
     */
    @RequireLogin
    @MethodValidation("GET")
    public void page() {
        int pageNum = getParaToInt("page", 1);
        int pageSize = getParaToInt("size", 20);
        String keyword = getPara("keyword");
        BigInteger roleId = getParaToBigInteger("roleId");
        Integer status = getParaToInt("status");

        User user = getSessionAttr("userinfo");
        BigInteger shopId = (user != null && user.getIsSuperAdmin() != 1) ? user.getLoginShopId() : null;

        try {
            Page<Record> p = staffService.page(pageNum, pageSize, keyword, roleId, status, shopId);
            java.util.Map<String,Object> _m=new java.util.HashMap<>();
            _m.put("list",p.getList()); _m.put("total",(int)p.getTotalRow());
            _m.put("page",pageNum); _m.put("size",pageSize);
            renderJson(new ApiReturn().addData("data",_m).success());
        } catch (Exception e) {
            logger.error("查询员工列表异常", e);
            renderJson(new ApiReturn().addMsg("查询失败").fail());
        }
    }

    /**
     * 员工详情
     * GET /api/staff/info
     */
    @RequireLogin
    @MethodValidation("GET")
    @ParameterValidation({ "staffId" })
    public void info() {
        BigInteger staffId = getParaToBigInteger("staffId");

        try {
            User user = getSessionAttr("userinfo");
            if (!checkStaffInShop(user, staffId)) {
                renderJson(new ApiReturn().addMsg("无权查看其他店铺的员工").fail());
                return;
            }
            Record staff = staffService.info(staffId);
            if (staff != null) {
                renderJson(new ApiReturn().addData("data", staff).success());
            } else {
                renderJson(new ApiReturn().addMsg("员工不存在").fail());
            }
        } catch (Exception e) {
            logger.error("查询员工详情异常", e);
            renderJson(new ApiReturn().addMsg("查询失败").fail());
        }
    }

    /**
     * 新增员工
     * POST /api/staff/add
     */
    @RequireLogin
    @RequirePermission("btn:staff:add")
    @MethodValidation("POST")
    @ParameterValidation({ "name", "username", "password" })
    public void add() {
        String name = getPara("name");
        String phone = getPara("phone");
        String username = getPara("username");
        String password = getPara("password");
        Integer employmentType = getParaToInt("employmentType");
        String remark = getPara("remark");
        String roleIdsStr = getPara("roleIds");

        // 校验密码强度
        String pwdMsg = PasswordUtil.validatePassword(password);
        if (pwdMsg != null) {
            renderJson(new ApiReturn().addMsg(pwdMsg).fail());
            return;
        }

        User user = getSessionAttr("userinfo");
        List<BigInteger> roleIds = parseIdList(roleIdsStr);

        // 非超管校验：shopId 强制为当前登录店铺
        BigInteger shopId;
        if (user != null && user.getIsSuperAdmin() != 1) {
            shopId = user.getLoginShopId();
            if (shopId == null) {
                renderJson(new ApiReturn().addMsg("请先选择店铺后再操作").fail());
                return;
            }
        } else {
            shopId = getParaToBigInteger("shopId");
        }

        // 非超管禁止分配超管(2)或店长(3)角色
        if (user != null && user.getIsSuperAdmin() != 1 && roleIds != null) {
            for (BigInteger rid : roleIds) {
                if (rid.equals(BigInteger.valueOf(2)) || rid.equals(BigInteger.valueOf(3))) {
                    renderJson(new ApiReturn().addMsg("不允许分配超级管理员或店长角色").fail());
                    return;
                }
            }
        }

        try {
            boolean success = staffService.add(name, phone, username, password, roleIds, shopId, employmentType, remark);
            if (success) {
                renderJson(new ApiReturn().success());
            } else {
                renderJson(new ApiReturn().addMsg("新增失败").fail());
            }
        } catch (RuntimeException e) {
            renderJson(new ApiReturn().addMsg(e.getMessage()).fail());
        } catch (Exception e) {
            logger.error("新增员工异常", e);
            renderJson(new ApiReturn().addMsg("系统异常").serverErr());
        }
    }

    /**
     * 编辑员工
     * PUT /api/staff/update
     */
    @RequireLogin
    @RequirePermission("btn:staff:edit")
    @MethodValidation("PUT")
    @ParameterValidation({ "staffId" })
    public void update() {
        BigInteger staffId = getParaToBigInteger("staffId");
        String name = getPara("name");
        String phone = getPara("phone");
        Integer status = getParaToInt("status");
        Integer employmentType = getParaToInt("employmentType");
        String remark = getPara("remark");
        String roleIdsStr = getPara("roleIds");

        User user = getSessionAttr("userinfo");
        if (!checkStaffInShop(user, staffId)) {
            renderJson(new ApiReturn().addMsg("无权编辑其他店铺的员工").fail());
            return;
        }

        List<BigInteger> roleIds = parseIdList(roleIdsStr);

        // 非超管禁止分配超管(2)或店长(3)角色
        if (user != null && user.getIsSuperAdmin() != 1 && roleIds != null) {
            for (BigInteger rid : roleIds) {
                if (rid.equals(BigInteger.valueOf(2)) || rid.equals(BigInteger.valueOf(3))) {
                    renderJson(new ApiReturn().addMsg("不允许分配超级管理员或店长角色").fail());
                    return;
                }
            }
        }

        try {
            boolean success = staffService.update(staffId, name, phone, roleIds, status, employmentType, remark);
            if (success) {
                renderJson(new ApiReturn().success());
            } else {
                renderJson(new ApiReturn().addMsg("员工不存在").fail());
            }
        } catch (Exception e) {
            logger.error("编辑员工异常", e);
            renderJson(new ApiReturn().addMsg("系统异常").serverErr());
        }
    }

    /**
     * 切换在职/离职状态
     * PUT /api/staff/status
     */
    @RequireLogin
    @RequirePermission("btn:staff:edit")
    @MethodValidation("PUT")
    @ParameterValidation({ "staffId", "status" })
    public void status() {
        BigInteger staffId = getParaToBigInteger("staffId");
        Integer status = getParaToInt("status");

        User user = getSessionAttr("userinfo");
        if (!checkStaffInShop(user, staffId)) {
            renderJson(new ApiReturn().addMsg("无权操作其他店铺的员工").fail());
            return;
        }

        try {
            boolean success = staffService.updateStatus(staffId, status);
            if (success) {
                renderJson(new ApiReturn().success());
            } else {
                renderJson(new ApiReturn().addMsg("员工不存在").fail());
            }
        } catch (Exception e) {
            logger.error("切换员工状态异常", e);
            renderJson(new ApiReturn().addMsg("系统异常").serverErr());
        }
    }

    /**
     * 重置密码
     * PUT /api/staff/password
     */
    @RequireLogin
    @RequirePermission("btn:staff:password")
    @MethodValidation("PUT")
    @ParameterValidation({ "staffId", "newPassword" })
    public void password() {
        BigInteger staffId = getParaToBigInteger("staffId");
        String newPassword = getPara("newPassword");

        User user = getSessionAttr("userinfo");
        if (!checkStaffInShop(user, staffId)) {
            renderJson(new ApiReturn().addMsg("无权操作其他店铺的员工").fail());
            return;
        }

        // 校验密码强度
        String pwdMsg = PasswordUtil.validatePassword(newPassword);
        if (pwdMsg != null) {
            renderJson(new ApiReturn().addMsg(pwdMsg).fail());
            return;
        }

        try {
            boolean success = staffService.resetPassword(staffId, newPassword);
            if (success) {
                renderJson(new ApiReturn().success());
            } else {
                renderJson(new ApiReturn().addMsg("员工账号不存在").fail());
            }
        } catch (Exception e) {
            logger.error("重置密码异常", e);
            renderJson(new ApiReturn().addMsg("系统异常").serverErr());
        }
    }

    /**
     * 删除员工
     * DELETE /api/staff/delete
     */
    @RequireLogin
    @RequirePermission("btn:staff:delete")
    @MethodValidation("DELETE")
    @ParameterValidation({ "staffId" })
    public void delete() {
        BigInteger staffId = getParaToBigInteger("staffId");

        User user = getSessionAttr("userinfo");
        if (!checkStaffInShop(user, staffId)) {
            renderJson(new ApiReturn().addMsg("无权删除其他店铺的员工").fail());
            return;
        }

        try {
            boolean success = staffService.delete(staffId);
            if (success) {
                renderJson(new ApiReturn().success());
            } else {
                renderJson(new ApiReturn().addMsg("员工不存在").fail());
            }
        } catch (Exception e) {
            logger.error("删除员工异常", e);
            renderJson(new ApiReturn().addMsg("系统异常").serverErr());
        }
    }

    private List<BigInteger> parseIdList(String str) {
        if (str == null || str.isEmpty()) return null;
        // 处理JSON数组格式，移除方括号
        String cleanStr = str.trim();
        if (cleanStr.startsWith("[") && cleanStr.endsWith("]")) {
            cleanStr = cleanStr.substring(1, cleanStr.length() - 1);
        }
        if (cleanStr.isEmpty()) return null;
        
        return Arrays.stream(cleanStr.split(","))
            .map(String::trim)
            .filter(s -> !s.isEmpty())
            .map(BigInteger::new)
            .collect(Collectors.toList());
    }

    private BigInteger getParaToBigInteger(String name) {
        String val = getPara(name);
        if (val == null || val.isEmpty()) return null;
        try {
            return new BigInteger(val);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    /**
     * 校验员工是否属于当前登录店铺（超管跳过）
     * @return true=通过校验或超管，false=无权操作
     */
    private boolean checkStaffInShop(User user, BigInteger staffId) {
        if (staffId == null) return false;
        if (user != null && user.getIsSuperAdmin() == 1) return true;
        if (user == null || user.getLoginShopId() == null) return false;
        Record rec = Db.findFirst("SELECT shop_id FROM staff_shops WHERE staff_id = ?", staffId);
        return rec != null && user.getLoginShopId().equals(rec.getBigInteger("shop_id"));
    }
}
