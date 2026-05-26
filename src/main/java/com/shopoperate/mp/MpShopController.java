package com.shopoperate.mp;

import com.jfinal.core.Controller;
import com.jfinal.core.Path;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.shopoperate.common.annotation.MethodValidation;
import com.shopoperate.common.vo.User;
import com.shopoperate.utils.ApiReturn;
import org.apache.log4j.Logger;

import java.math.BigInteger;
import java.util.*;

/**
 * 小程序店铺控制器
 * 路径前缀：/api/mp/shop
 */
@Path(value = "/api/mp/shop")
public class MpShopController extends Controller {

    private static final Logger log = Logger.getLogger(MpShopController.class);

    /**
     * 获取用户可访问的店铺列表（未登录也可调用，传 openid）
     * GET /api/mp/shop/list?openid=
     */
    @MethodValidation("GET")
    public void list() {
        User user = getSessionAttr("userinfo");
        String openid = null;

        // 优先从当前登录用户获取 openid
        if (user != null && user.getCustomerId() != null) {
            Record cust = Db.findById("customers", user.getCustomerId());
            if (cust != null) openid = cust.getStr("wechat_openid");
        }

        // 未登录时从请求参数获取 openid
        if (openid == null || openid.isEmpty()) {
            openid = getPara("openid");
        }

        if (openid == null || openid.isEmpty()) {
            renderJson(new ApiReturn().addData("list", new ArrayList<>()).addData("total", 0).success());
            return;
        }

        try {
            Set<BigInteger> shopIds = new LinkedHashSet<>();
            List<Map<String, Object>> result = new ArrayList<>();

            // 来源1：customers 表中该 openid 关联的店铺
            List<Record> customerShops = Db.find(
                "SELECT s.id, s.name, s.address, s.status, s.sign_photo FROM shops s " +
                "INNER JOIN customers c ON s.id = c.shop_id " +
                "WHERE c.wechat_openid = ? AND c.is_deleted = 0 AND s.is_deleted = 0",
                openid);
            for (Record s : customerShops) {
                if (shopIds.add(s.getBigInteger("id"))) {
                    result.add(buildShopItem(s));
                }
            }

            // 来源2：staff_accounts → staff_shops → shops
            List<Record> staffShops = Db.find(
                "SELECT s.id, s.name, s.address, s.status, s.sign_photo FROM shops s " +
                "INNER JOIN staff_shops ss ON s.id = ss.shop_id " +
                "INNER JOIN staff_accounts sa ON sa.staff_id = ss.staff_id " +
                "WHERE sa.wechat_openid = ? AND sa.is_deleted = 0 AND s.is_deleted = 0",
                openid);
            for (Record s : staffShops) {
                if (shopIds.add(s.getBigInteger("id"))) {
                    result.add(buildShopItem(s));
                }
            }

            renderJson(new ApiReturn().addData("list", result).addData("total", result.size()).success());
        } catch (Exception e) {
            log.error("获取店铺列表异常", e);
            renderJson(new ApiReturn().addMsg("系统异常").serverErr());
        }
    }

    /**
     * 校验店铺有效性
     * GET /api/mp/shop/check?shopId=
     */
    @MethodValidation("GET")
    public void check() {
        BigInteger shopId = parseShopId();
        if (shopId == null) {
            renderJson(new ApiReturn().addMsg("shopId不能为空").fail());
            return;
        }

        try {
            Record shop = Db.findById("shops", shopId);
            if (shop == null || shop.getInt("is_deleted") == 1) {
                renderJson(new ApiReturn().addData("valid", false).addData("reason", "店铺不存在或已关闭").success());
                return;
            }

            // 检查席位到期（提醒但不阻止进入）
            java.util.Map<String, Object> seatWarn = null;
            if (shop.getBigInteger("seat_id") != null) {
                Record seat = Db.findFirst(
                    "SELECT * FROM seat_subscriptions WHERE id = ? AND status = 1 AND end_date >= CURDATE()",
                    shop.getBigInteger("seat_id"));
                if (seat == null) {
                    seatWarn = new HashMap<>();
                    seatWarn.put("type", "seat_expired");
                    seatWarn.put("message", "该店铺席位已到期，功能可能受限，请联系管理员续费");
                }
            }

            renderJson(new ApiReturn()
                .addData("valid", true)
                .addData("warning", seatWarn != null ? seatWarn.get("message") : null)
                .success());
        } catch (Exception e) {
            log.error("校验店铺异常", e);
            renderJson(new ApiReturn().addMsg("系统异常").serverErr());
        }
    }

    /**
     * 获取店铺基本信息（免登录）
     * GET /api/mp/shop/info?shopId=
     */
    @MethodValidation("GET")
    public void info() {
        BigInteger shopId = parseShopId();
        if (shopId == null) {
            renderJson(new ApiReturn().addMsg("shopId不能为空").fail());
            return;
        }

        try {
            Record shop = Db.findFirst(
                "SELECT * FROM shops WHERE id = ? AND is_deleted = 0", shopId);
            if (shop == null) {
                renderJson(new ApiReturn().addMsg("店铺不存在").fail());
                return;
            }

            Map<String, Object> data = new HashMap<>();
            data.put("id", shop.getBigInteger("id"));
            data.put("name", shop.getStr("name"));
            data.put("address", shop.getStr("address"));
            data.put("contactPhone", shop.getStr("contact_phone"));
            data.put("status", shop.getInt("status"));
            data.put("maxCapacity", shop.getInt("max_capacity"));
            data.put("description", shop.getStr("description"));
            data.put("signPhoto", shop.getStr("sign_photo"));

            renderJson(new ApiReturn().addData("data", data).success());
        } catch (Exception e) {
            log.error("获取店铺信息异常", e);
            renderJson(new ApiReturn().addMsg("系统异常").serverErr());
        }
    }

    private BigInteger parseShopId() {
        String s = getPara("shopId");
        if (s == null || s.isEmpty()) return null;
        try { return new BigInteger(s); } catch (NumberFormatException e) { return null; }
    }

    private Map<String, Object> buildShopItem(Record s) {
        Map<String, Object> item = new HashMap<>();
        item.put("id", s.getBigInteger("id"));
        item.put("name", s.getStr("name"));
        item.put("address", s.getStr("address"));
        item.put("status", s.getInt("status"));
        item.put("signPhoto", s.getStr("sign_photo"));
        return item;
    }
}
