package com.shopoperate.shop;

import com.jfinal.core.Controller;
import com.jfinal.core.Path;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.shopoperate.common.annotation.MethodValidation;
import com.shopoperate.common.annotation.ParameterValidation;
import com.shopoperate.common.annotation.RequireLogin;
import com.shopoperate.common.annotation.RequirePermission;
import com.shopoperate.common.vo.User;
import com.shopoperate.utils.ApiReturn;
import org.apache.log4j.Logger;

import java.math.BigInteger;
import java.util.HashMap;
import java.util.Map;

@Path(value = "/api/shops")
public class ShopController extends Controller {

    private static final Logger logger = Logger.getLogger(ShopController.class);
    private final ShopService shopService = ShopService.me;

    @RequireLogin
    @MethodValidation("GET")
    public void page() {
        int pageNum = getParaToInt("page", 1);
        int pageSize = getParaToInt("size", 20);
        String keyword = getPara("keyword");
        BigInteger ownerStaffId = getParaToBigInteger("ownerStaffId");
        Integer status = getParaToInt("status");

        User user = getSessionAttr("userinfo");
        BigInteger loginShopId = (user != null) ? user.getLoginShopId() : null;
        boolean isSuperAdmin = user != null && user.getIsSuperAdmin() != null && user.getIsSuperAdmin() == 1;

        try {
            Page<Record> p = shopService.page(pageNum, pageSize, keyword, ownerStaffId, status,
                loginShopId, isSuperAdmin);
            Map<String,Object> _m=new HashMap<>();
            _m.put("list",p.getList()); _m.put("total",(int)p.getTotalRow());
            _m.put("page",pageNum); _m.put("size",pageSize);
            renderJson(new ApiReturn().addData("data",_m).success());
        } catch (Exception e) {
            logger.error("查询店铺列表异常", e);
            renderJson(new ApiReturn().addMsg("查询失败").fail());
        }
    }

    @RequireLogin
    @MethodValidation("GET")
    @ParameterValidation({ "shopsId" })
    public void info() {
        BigInteger shopId = getParaToBigInteger("shopsId");

        try {
            Record shop = shopService.info(shopId);
            if (shop != null) {
                renderJson(new ApiReturn().addData("data", shop).success());
            } else {
                renderJson(new ApiReturn().addMsg("店铺不存在").fail());
            }
        } catch (Exception e) {
            logger.error("查询店铺详情异常", e);
            renderJson(new ApiReturn().addMsg("查询失败").fail());
        }
    }

    @RequireLogin
    @RequirePermission("btn:shop:add")
    @MethodValidation("POST")
    @ParameterValidation({ "name", "seatId" })
    public void add() {
        BigInteger seatId = getParaToBigInteger("seatId");
        String name = getPara("name");
        String address = getPara("address");
        String contactPhone = getPara("contactPhone");
        Integer maxCapacity = getParaToInt("maxCapacity");
        String description = getPara("description");

        try {
            boolean success = shopService.add(seatId, name, address, contactPhone,
                maxCapacity, description);
            if (success) {
                renderJson(new ApiReturn().success());
            } else {
                renderJson(new ApiReturn().addMsg("创建失败，请检查席位是否有效或是否已被占用").fail());
            }
        } catch (Exception e) {
            logger.error("创建店铺异常", e);
            renderJson(new ApiReturn().addMsg("系统异常：" + e.getMessage()).serverErr());
        }
    }

    @RequireLogin
    @RequirePermission("btn:shop:edit")
    @MethodValidation("PUT")
    @ParameterValidation({ "shopsId" })
    public void update() {
        BigInteger shopId = getParaToBigInteger("shopsId");
        String name = getPara("name");
        String address = getPara("address");
        String contactPhone = getPara("contactPhone");
        Integer maxCapacity = getParaToInt("maxCapacity");
        String description = getPara("description");
        String signPhoto = getPara("signPhoto");

        try {
            boolean success = shopService.update(shopId, name, address, contactPhone, maxCapacity, description, signPhoto);
            if (success) {
                renderJson(new ApiReturn().success());
            } else {
                renderJson(new ApiReturn().addMsg("店铺不存在").fail());
            }
        } catch (Exception e) {
            logger.error("编辑店铺异常", e);
            renderJson(new ApiReturn().addMsg("系统异常：" + e.getMessage()).serverErr());
        }
    }

    /**
     * 获取当前登录店铺信息（店长专属，自动取 loginShopId）
     */
    @RequireLogin
    @MethodValidation("GET")
    public void my() {
        User user = getSessionAttr("userinfo");
        if (user == null) {
            renderJson(new ApiReturn().loginInvalid());
            return;
        }
        BigInteger shopId = user.getLoginShopId();
        if (user.getIsSuperAdmin() != null && user.getIsSuperAdmin() == 1) {
            renderJson(new ApiReturn().addMsg("超管请使用店铺列表查看").fail());
            return;
        }
        if (shopId == null) {
            renderJson(new ApiReturn().addMsg("请选择店铺后再操作").fail());
            return;
        }
        try {
            Record shop = shopService.info(shopId);
            if (shop != null) {
                renderJson(new ApiReturn().addData("data", shop).success());
            } else {
                renderJson(new ApiReturn().addMsg("店铺不存在").fail());
            }
        } catch (Exception e) {
            logger.error("查询当前店铺异常", e);
            renderJson(new ApiReturn().addMsg("查询失败").fail());
        }
    }

    /**
     * 编辑当前登录店铺（店长专属，忽略前端 shopsId，强制用 loginShopId）
     */
    @RequireLogin
    @RequirePermission("btn:shop:myEdit")
    @MethodValidation("PUT")
    public void myUpdate() {
        User user = getSessionAttr("userinfo");
        if (user == null) {
            renderJson(new ApiReturn().loginInvalid());
            return;
        }
        BigInteger shopId = user.getLoginShopId();
        if (user.getIsSuperAdmin() != null && user.getIsSuperAdmin() == 1) {
            renderJson(new ApiReturn().addMsg("超管请使用店铺列表编辑").fail());
            return;
        }
        if (shopId == null) {
            renderJson(new ApiReturn().addMsg("请选择店铺后再操作").fail());
            return;
        }

        String name = getPara("name");
        String address = getPara("address");
        String contactPhone = getPara("contactPhone");
        Integer maxCapacity = getParaToInt("maxCapacity");
        String description = getPara("description");
        String signPhoto = getPara("signPhoto");

        try {
            boolean success = shopService.update(shopId, name, address, contactPhone, maxCapacity, description, signPhoto);
            if (success) {
                renderJson(new ApiReturn().success());
            } else {
                renderJson(new ApiReturn().addMsg("店铺不存在").fail());
            }
        } catch (Exception e) {
            logger.error("编辑当前店铺异常", e);
            renderJson(new ApiReturn().addMsg("系统异常：" + e.getMessage()).serverErr());
        }
    }

    /**
     * 切换当前登录店铺营业状态（店长专属，忽略前端 shopsId，强制用 loginShopId）
     */
    @RequireLogin
    @RequirePermission("btn:shop:myStatus")
    @MethodValidation("PUT")
    public void myStatus() {
        User user = getSessionAttr("userinfo");
        if (user == null) {
            renderJson(new ApiReturn().loginInvalid());
            return;
        }
        BigInteger shopId = user.getLoginShopId();
        if (user.getIsSuperAdmin() != null && user.getIsSuperAdmin() == 1) {
            renderJson(new ApiReturn().addMsg("超管请使用店铺列表操作").fail());
            return;
        }
        if (shopId == null) {
            renderJson(new ApiReturn().addMsg("请选择店铺后再操作").fail());
            return;
        }

        Integer status = getParaToInt("status");

        try {
            boolean success = shopService.toggleStatus(shopId, status);
            if (success) {
                renderJson(new ApiReturn().success());
            } else {
                renderJson(new ApiReturn().addMsg("店铺不存在").fail());
            }
        } catch (Exception e) {
            logger.error("切换当前店铺营业状态异常", e);
            renderJson(new ApiReturn().addMsg("系统异常：" + e.getMessage()).serverErr());
        }
    }

    @RequireLogin
    @RequirePermission("btn:shop:delete")
    @MethodValidation("DELETE")
    @ParameterValidation({ "shopsId" })
    public void delete() {
        BigInteger shopId = getParaToBigInteger("shopsId");

        try {
            boolean success = shopService.delete(shopId);
            if (success) {
                renderJson(new ApiReturn().success());
            } else {
                renderJson(new ApiReturn().addMsg("店铺不存在").fail());
            }
        } catch (Exception e) {
            logger.error("删除店铺异常", e);
            renderJson(new ApiReturn().addMsg("系统异常：" + e.getMessage()).serverErr());
        }
    }

    @RequireLogin
    @RequirePermission("btn:shop:status")
    @MethodValidation("PUT")
    @ParameterValidation({ "shopsId", "status" })
    public void status() {
        BigInteger shopId = getParaToBigInteger("shopsId");
        Integer status = getParaToInt("status");

        try {
            boolean success = shopService.toggleStatus(shopId, status);
            if (success) {
                renderJson(new ApiReturn().success());
            } else {
                renderJson(new ApiReturn().addMsg("店铺不存在").fail());
            }
        } catch (Exception e) {
            logger.error("切换营业状态异常", e);
            renderJson(new ApiReturn().addMsg("系统异常：" + e.getMessage()).serverErr());
        }
    }

    @RequireLogin
    @MethodValidation("POST")
    public void qrcode() {
        BigInteger shopId = getParaToBigInteger("shopsId");
        if (shopId == null) {
            renderJson(new ApiReturn().addMsg("shopId不能为空").fail());
            return;
        }
        try {
            String path = shopService.generateMpQrcode(shopId);
            if (path != null) {
                renderJson(new ApiReturn().addData("path", path).addData("url", path != null ? "/file/image?name=" + path : "").success());
            } else {
                renderJson(new ApiReturn().addMsg("生成太阳码失败，请检查微信配置").fail());
            }
        } catch (Exception e) {
            logger.error("生成太阳码异常", e);
            renderJson(new ApiReturn().addMsg("系统异常：" + e.getMessage()).serverErr());
        }
    }

    private BigInteger getParaToBigInteger(String name) {
        String val = getPara(name);
        if (val == null || val.isEmpty()) return null;
        try { return new BigInteger(val); } catch (NumberFormatException e) { return null; }
    }
}
