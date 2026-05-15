package com.shopoperate.staff;

import com.jfinal.core.Controller;
import com.jfinal.core.Path;
import com.jfinal.plugin.activerecord.Record;
import com.shopoperate.common.annotation.MethodValidation;
import com.shopoperate.common.annotation.ParameterValidation;
import com.shopoperate.common.annotation.RequireLogin;
import com.shopoperate.common.annotation.RequirePermission;
import com.shopoperate.utils.ApiReturn;
import org.apache.log4j.Logger;

import java.math.BigInteger;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@Path(value = "/api/roles")
public class RolesController extends Controller {

    private static final Logger logger = Logger.getLogger(RolesController.class);
    private final RoleService roleService = RoleService.me;

    /**
     * 角色列表
     * GET /api/roles/list
     */
    @RequireLogin
    @MethodValidation("GET")
    public void list() {
        try {
            List<Record> list = roleService.list();
            renderJson(new ApiReturn().addData("data", list).success());
        } catch (Exception e) {
            logger.error("查询角色列表异常", e);
            renderJson(new ApiReturn().addMsg("查询失败").fail());
        }
    }

    /**
     * 新增角色
     * POST /api/roles/add
     */
    @RequireLogin
    @RequirePermission("btn:role:add")
    @MethodValidation("POST")
    @ParameterValidation({ "name" })
    public void add() {
        try {
            boolean success = roleService.add(getPara("name"), getPara("description"));
            renderJson(success ? new ApiReturn().success() : new ApiReturn().addMsg("新增失败").fail());
        } catch (Exception e) {
            logger.error("新增角色异常", e);
            renderJson(new ApiReturn().addMsg("系统异常：" + e.getMessage()).serverErr());
        }
    }

    /**
     * 编辑角色
     * PUT /api/roles/update
     */
    @RequireLogin
    @RequirePermission("btn:role:edit")
    @MethodValidation("PUT")
    @ParameterValidation({ "id" })
    public void update() {
        try {
            boolean success = roleService.update(getParaToInt("id"), getPara("name"), getPara("description"));
            renderJson(success ? new ApiReturn().success() : new ApiReturn().addMsg("角色不存在").fail());
        } catch (Exception e) {
            logger.error("编辑角色异常", e);
            renderJson(new ApiReturn().addMsg("系统异常：" + e.getMessage()).serverErr());
        }
    }

    /**
     * 设置角色权限
     * PUT /api/roles/permissions
     */
    @RequireLogin
    @RequirePermission("btn:role:perms")
    @MethodValidation("PUT")
    @ParameterValidation({ "roleId" })
    public void permissions() {
        BigInteger roleId = getParaToBigInteger("roleId");
        String permissionIdsStr = getPara("permissionIds");

        List<BigInteger> permissionIds = null;
        if (permissionIdsStr != null && !permissionIdsStr.isEmpty()) {
            permissionIds = Arrays.stream(permissionIdsStr.split(","))
                .map(String::trim)
                .filter(s -> !s.isEmpty())
                .map(BigInteger::new)
                .collect(Collectors.toList());
        }

        try {
            boolean success = roleService.setPermissions(roleId, permissionIds);
            if (success) {
                renderJson(new ApiReturn().success());
            } else {
                renderJson(new ApiReturn().addMsg("设置失败").fail());
            }
        } catch (Exception e) {
            logger.error("设置角色权限异常", e);
            renderJson(new ApiReturn().addMsg("系统异常：" + e.getMessage()).serverErr());
        }
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
}
