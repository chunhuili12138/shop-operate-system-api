package com.shopoperate.mp;

import com.jfinal.core.Controller;
import com.jfinal.core.Path;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.shopoperate.common.annotation.MethodValidation;
import com.shopoperate.common.vo.User;
import com.shopoperate.utils.ApiReturn;
import org.apache.log4j.Logger;

import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.*;

/**
 * 小程序首页控制器
 * 路径前缀：/api/mp
 */
@Path(value = "/api/mp")
public class MpHomeController extends Controller {

    private static final Logger log = Logger.getLogger(MpHomeController.class);

    /**
     * 首页聚合数据（免登录可访问公开数据，登录后附加顾客信息）
     * GET /api/mp/home?shopId=
     */
    @MethodValidation("GET")
    public void home() {
        BigInteger shopId = MpHelper.getShopId(this);
        if (shopId == null) {
            renderJson(new ApiReturn().addMsg("shopId不能为空").fail());
            return;
        }

        User user = getSessionAttr("userinfo");
        boolean isLoggedIn = user != null && "customer".equals(user.getUserType());

        try {
            Map<String, Object> data = new HashMap<>();

            // 1. 店铺信息
            Record shop = Db.findById("shops", shopId);
            if (shop == null || shop.getInt("is_deleted") == 1) {
                renderJson(new ApiReturn().addMsg("店铺不存在").fail());
                return;
            }
            Map<String, Object> shopInfo = new HashMap<>();
            shopInfo.put("id", shop.getBigInteger("id"));
            shopInfo.put("name", shop.getStr("name"));
            shopInfo.put("status", shop.getInt("status"));
            shopInfo.put("address", shop.getStr("address"));
            shopInfo.put("signPhoto", shop.getStr("sign_photo"));
            data.put("shopInfo", shopInfo);

            // 2. 空闲位数（max_capacity - 进行中的 game_sessions 数）
            int maxCapacity = shop.getInt("max_capacity") != null ? shop.getInt("max_capacity") : 20;
            long activeCount = Db.queryLong(
                "SELECT COUNT(*) FROM game_sessions WHERE shop_id = ? AND status = 1 AND is_deleted = 0",
                shopId);
            int freeSlots = (int) Math.max(0, maxCapacity - activeCount);
            data.put("freeSlots", freeSlots);
            data.put("maxCapacity", maxCapacity);

            // 3. 热门套餐 TOP 3（按购买次数排序）
            List<Record> hotPackages = Db.find(
                "SELECT p.*, COUNT(pr.id) AS purchase_count " +
                "FROM packages p " +
                "LEFT JOIN purchases pr ON pr.package_id = p.id AND pr.is_deleted = 0 " +
                "WHERE p.shop_id = ? AND p.is_active = 1 AND p.is_deleted = 0 " +
                "GROUP BY p.id " +
                "ORDER BY purchase_count DESC " +
                "LIMIT 3", shopId);

            List<Map<String, Object>> packages = new ArrayList<>();
            for (Record p : hotPackages) {
                Map<String, Object> pkg = new HashMap<>();
                pkg.put("id", p.getBigInteger("id"));
                pkg.put("name", p.getStr("name"));
                pkg.put("type", p.getInt("type"));
                pkg.put("price", p.getBigDecimal("price"));
                pkg.put("originalPrice", p.getBigDecimal("original_price"));
                pkg.put("durationMinutes", p.getInt("duration_minutes"));
                pkg.put("description", p.getStr("description"));
                packages.add(pkg);
            }
            data.put("hotPackages", packages);

            // 4. 最新文章 5 条
            List<Record> articles = Db.find(
                "SELECT a.id, a.title, a.cover_image, a.content_type, a.published_at, " +
                "ac.name AS category_name " +
                "FROM articles a " +
                "LEFT JOIN article_categories ac ON a.category_id = ac.id " +
                "WHERE a.shop_id = ? AND a.is_published = 1 AND a.is_deleted = 0 " +
                "ORDER BY a.published_at DESC " +
                "LIMIT 5", shopId);

            List<Map<String, Object>> articleList = new ArrayList<>();
            for (Record a : articles) {
                Map<String, Object> art = new HashMap<>();
                art.put("id", a.getBigInteger("id"));
                art.put("title", a.getStr("title"));
                art.put("coverImage", a.getStr("cover_image"));
                art.put("contentType", a.getInt("content_type"));
                art.put("publishedAt", a.getDate("published_at"));
                art.put("categoryName", a.getStr("category_name"));
                articleList.add(art);
            }
            data.put("articles", articleList);

            // 5. 排队人数
            long queueCount = Db.queryLong(
                "SELECT COUNT(*) FROM queue_entries WHERE shop_id = ? AND status = 1 AND is_deleted = 0",
                shopId);
            data.put("queueCount", queueCount);

            // 6. 今日统计
            long todayOrders = Db.queryLong(
                "SELECT COUNT(*) FROM purchases WHERE shop_id = ? AND DATE(created_at) = CURDATE() AND is_deleted = 0",
                shopId);
            long todayCheckins = Db.queryLong(
                "SELECT COUNT(*) FROM game_sessions WHERE shop_id = ? AND DATE(start_time) = CURDATE() AND is_deleted = 0",
                shopId);
            data.put("todayOrderCount", todayOrders);
            data.put("todayCheckinCount", todayCheckins);

            // 7. 如果已登录，附加顾客信息
            if (isLoggedIn && user.getCustomerId() != null) {
                Map<String, Object> customerInfo = new HashMap<>();
                Record cust = Db.findById("customers", user.getCustomerId());
                if (cust != null && cust.getInt("is_deleted") == 0) {
                    customerInfo.put("nickname", cust.getStr("nickname"));
                    customerInfo.put("avatar", cust.getStr("avatar_url"));
                    customerInfo.put("phone", cust.getStr("phone"));
                    Record wallet = Db.findFirst("SELECT balance FROM customer_wallets WHERE customer_id = ? AND is_deleted = 0", user.getCustomerId());
                    customerInfo.put("walletBalance", wallet != null ? wallet.getBigDecimal("balance") : BigDecimal.ZERO);
                    data.put("customerInfo", customerInfo);
                }
            }

            renderJson(new ApiReturn().addData("data", data).success());
        } catch (Exception e) {
            log.error("获取首页数据异常", e);
            renderJson(new ApiReturn().addMsg("系统异常").serverErr());
        }
    }
}
