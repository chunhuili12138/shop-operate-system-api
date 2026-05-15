package com.shopoperate.marketing;

import com.jfinal.core.Controller;
import com.jfinal.core.Path;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.shopoperate.common.annotation.*;
import com.shopoperate.common.vo.User;
import com.shopoperate.utils.ApiReturn;
import org.apache.log4j.Logger;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Path(value = "/api")
public class MarketingController extends Controller {
    private static final Logger log = Logger.getLogger(MarketingController.class);

    // ========== Coupons ==========
    @RequireLogin @MethodValidation("GET") public void coupons() {
        try {
            StringBuilder sb = new StringBuilder("FROM coupons WHERE is_deleted=0 AND shop_id=?");
            java.util.List<Object> params = new java.util.ArrayList<>();
            params.add(shopId());
            Integer filterType = getParaToInt("type");
            if (filterType != null) { sb.append(" AND type = ?"); params.add(filterType); }
            Integer filterStatus = getParaToInt("status");
            if (filterStatus != null) { sb.append(" AND is_active = ?"); params.add(filterStatus); }
            String useScene = getPara("useScene");
            if (useScene != null && !useScene.isEmpty()) { sb.append(" AND use_scene = ?"); params.add(useScene.replace("'","''")); }
            String keyword = getPara("keyword");
            if (keyword != null && !keyword.isEmpty()) { sb.append(" AND name LIKE ?"); params.add("%" + keyword.replace("'","''") + "%"); }
            sb.append(" ORDER BY created_at DESC");
            Page<Record> p = Db.paginate(getParaToInt("page",1), getParaToInt("size",20),
                "SELECT *", sb.toString(), params.toArray());
            renderPage(p);
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("查询失败").fail()); }
    }
    @RequireLogin @RequirePermission("btn:coupon:add") @MethodValidation("POST") public void couponsAdd() {
        try {
            renderBool(Db.save("coupons", new Record().set("shop_id",shopId()).set("name",getPara("name"))
                .set("description",getPara("description"))
                .set("type",getParaToInt("type",1)).set("use_scene",getPara("useScene","purchase"))
                .set("value",new BigDecimal(getPara("value","0")))
                .set("min_order_amount",getPara("minOrderAmount")!=null?new BigDecimal(getPara("minOrderAmount")):BigDecimal.ZERO)
                .set("total_stock",getParaToInt("totalStock",0)).set("remain_stock",getParaToInt("totalStock",0))
                .set("per_user_limit",getParaToInt("perUserLimit",1))
                .set("valid_days",getParaToInt("validDays",30))
                .set("auto_grant_on_register",getParaToInt("autoGrantOnRegister",0))
                .set("is_active",1).set("created_at",new Date()).set("updated_at",new Date())));
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }
    @RequireLogin @RequirePermission("btn:coupon:edit") @MethodValidation("PUT") public void couponsUpdate() {
        try {
            Record c = Db.findById("coupons", getBigInteger("couponId")); if (c==null) { renderBool(false); return; }
            if (!c.getBigInteger("shop_id").equals(shopId())) { renderBool(false); return; }
            if (getPara("name")!=null) c.set("name",getPara("name"));
            if (getPara("description")!=null) c.set("description",getPara("description"));
            if (getParaToInt("type")!=null) c.set("type",getParaToInt("type"));
            if (getPara("useScene")!=null) c.set("use_scene",getPara("useScene"));
            if (getPara("value")!=null) c.set("value",new BigDecimal(getPara("value")));
            if (getPara("minOrderAmount")!=null) c.set("min_order_amount",new BigDecimal(getPara("minOrderAmount")));
            if (getParaToInt("totalStock")!=null) c.set("total_stock",getParaToInt("totalStock"));
            if (getParaToInt("perUserLimit")!=null) c.set("per_user_limit",getParaToInt("perUserLimit"));
            if (getParaToInt("validDays")!=null) c.set("valid_days",getParaToInt("validDays"));
            if (getParaToInt("autoGrantOnRegister")!=null) c.set("auto_grant_on_register",getParaToInt("autoGrantOnRegister"));
            renderBool(Db.update("coupons", c));
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }
    @RequireLogin @RequirePermission("btn:coupon:edit") @MethodValidation("PUT") public void couponsStatus() {
        try {
            Record c = Db.findById("coupons", getBigInteger("couponId")); if (c==null) { renderBool(false); return; }
            if (!c.getBigInteger("shop_id").equals(shopId())) { renderBool(false); return; }
            c.set("is_active", getParaToInt("isActive",0)); renderBool(Db.update("coupons", c));
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }
    @RequireLogin @MethodValidation("GET") public void couponUsages() {
        try {
            StringBuilder sb = new StringBuilder("FROM coupon_usages cu LEFT JOIN coupons c ON cu.coupon_id=c.id LEFT JOIN customers cst ON cu.customer_id=cst.id WHERE cu.shop_id=?");
            java.util.List<Object> params = new java.util.ArrayList<>();
            params.add(shopId());
            String couponId = getPara("couponId");
            if (couponId != null && !couponId.isEmpty()) { sb.append(" AND cu.coupon_id = ?"); params.add(couponId); }
            String customerKey = getPara("customerKeyword");
            if (customerKey != null && !customerKey.isEmpty()) { sb.append(" AND (cst.nickname LIKE ? OR cst.phone LIKE ?)"); params.add("%" + customerKey.replace("'","''") + "%"); params.add("%" + customerKey.replace("'","''") + "%"); }
            Integer status = getParaToInt("status");
            if (status != null) { sb.append(" AND cu.status = ?"); params.add(status); }
            String receivedStart = getPara("receivedStart");
            if (receivedStart != null && !receivedStart.isEmpty()) { sb.append(" AND cu.received_at >= ?"); params.add(receivedStart); }
            String receivedEnd = getPara("receivedEnd");
            if (receivedEnd != null && !receivedEnd.isEmpty()) { sb.append(" AND cu.received_at <= ?"); params.add(receivedEnd + " 23:59:59"); }
            String usedStart = getPara("usedStart");
            if (usedStart != null && !usedStart.isEmpty()) { sb.append(" AND cu.used_at >= ?"); params.add(usedStart); }
            String usedEnd = getPara("usedEnd");
            if (usedEnd != null && !usedEnd.isEmpty()) { sb.append(" AND cu.used_at <= ?"); params.add(usedEnd + " 23:59:59"); }
            sb.append(" ORDER BY cu.received_at DESC");
            Page<Record> p = Db.paginate(getParaToInt("page",1), getParaToInt("size",20),
                "SELECT cu.*, c.name AS coupon_name, cst.nickname AS customer_name", sb.toString(), params.toArray());
            renderPage(p);
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("查询失败").fail()); }
    }
    @RequireLogin @RequirePermission("btn:coupon:grant") @MethodValidation("POST") public void couponUsagesGrant() {
        try {
            String ids = getPara("customerIds"); if (ids==null||ids.isEmpty()) { renderBool(false); return; }
            Record coupon = Db.findById("coupons", getBigInteger("couponId")); if (coupon==null) { renderBool(false); return; }
            if (!coupon.getBigInteger("shop_id").equals(shopId())) { renderBool(false); return; }
            if (coupon.getInt("is_active") != 1) { renderJson(new ApiReturn().addMsg("该优惠券已禁用").fail()); return; }
            int validDays = coupon.getInt("valid_days");
            int perLimit = coupon.getInt("per_user_limit");
            BigInteger couponId = coupon.getBigInteger("id");
            List<BigInteger> customerIds = Arrays.stream(ids.split(",")).map(s->new BigInteger(s.trim())).collect(Collectors.toList());
            // 过滤 per_user_limit 超限者
            java.util.List<BigInteger> validIds = new java.util.ArrayList<>();
            for (BigInteger cid : customerIds) {
                if (perLimit > 0) {
                    long already = Db.queryLong("SELECT COUNT(*) FROM coupon_usages WHERE customer_id=? AND coupon_id=? AND is_deleted=0", cid, couponId);
                    if (already >= perLimit) continue;
                }
                validIds.add(cid);
            }
            int grantCount = validIds.size();
            if (grantCount == 0) { renderJson(new ApiReturn().addMsg("所有选定顾客已超过领取上限").fail()); return; }
            // 事务包裹：库存检查 + 插入记录 + 扣减库存
            boolean ok = Db.tx(() -> {
                Record locked = Db.findFirst("SELECT id, remain_stock FROM coupons WHERE id=? AND shop_id=? FOR UPDATE", couponId, shopId());
                if (locked == null || locked.getInt("remain_stock") < grantCount) return false;
                for (BigInteger cid : validIds) {
                    Db.save("coupon_usages", new Record().set("shop_id",shopId()).set("coupon_id",couponId)
                        .set("customer_id",cid).set("status",1).set("received_at",new Date())
                        .set("expires_at",new Date(System.currentTimeMillis()+validDays*86400000L)));
                }
                locked.set("remain_stock", locked.getInt("remain_stock") - grantCount);
                return Db.update("coupons", locked);
            });
            renderJson(ok ? new ApiReturn().success() : new ApiReturn().addMsg("库存不足或操作失败").fail());
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }

    /** 按条件批量发放：根据标签/来源匹配顾客，跳过 per_user_limit 超限者 */
    @RequireLogin @RequirePermission("btn:coupon:grant") @MethodValidation("POST") public void couponUsagesGrantBatch() {
        try {
            BigInteger spId = shopId();
            Record coupon = Db.findById("coupons", getBigInteger("couponId"));
            if (coupon == null) { renderBool(false); return; }
            if (!coupon.getBigInteger("shop_id").equals(spId)) { renderBool(false); return; }
            if (coupon.getInt("is_active") != 1) { renderJson(new ApiReturn().addMsg("该优惠券已禁用").fail()); return; }
            int perLimit = coupon.getInt("per_user_limit");
            int validDays = coupon.getInt("valid_days");
            BigInteger couponId = coupon.getBigInteger("id");
            String tags = getPara("tags");
            String source = getPara("source");
            String cids = getPara("customerIds");
            if ((tags == null || tags.isEmpty()) && (source == null || source.isEmpty()) && (cids == null || cids.isEmpty())) {
                renderJson(new ApiReturn().addMsg("请选择标签/来源或传入顾客ID").fail()); return;
            }
            // 查询匹配顾客
            StringBuilder csb = new StringBuilder("SELECT id FROM customers WHERE shop_id=? AND is_deleted=0");
            java.util.List<Object> cparams = new java.util.ArrayList<>();
            cparams.add(spId);
            if (tags != null && !tags.isEmpty()) {
                String[] tagArr = tags.split(",");
                csb.append(" AND (");
                for (int i = 0; i < tagArr.length; i++) {
                    if (i > 0) csb.append(" OR ");
                    csb.append("tags LIKE ?");
                    cparams.add("%" + tagArr[i].trim() + "%");
                }
                csb.append(")");
            }
            if (source != null && !source.isEmpty()) { csb.append(" AND source=?"); cparams.add(source.replace("'","''")); }
            if (cids != null && !cids.isEmpty()) {
                // 安全校验：仅允许数字/逗号/空格
                if (!cids.matches("[0-9,\\s]+")) { renderJson(new ApiReturn().addMsg("参数错误").fail()); return; }
                csb.append(" AND id IN ("); csb.append(cids.replaceAll("[\\s]+","")); csb.append(")");
            }
            List<Record> customers = Db.find(csb.toString(), cparams.toArray());
            if (customers.isEmpty()) { renderJson(new ApiReturn().addMsg("没有符合条件的顾客").fail()); return; }
            // 过滤 per_user_limit
            java.util.List<BigInteger> validIds = new java.util.ArrayList<>();
            int skipped = 0;
            for (Record c : customers) {
                BigInteger cid = c.getBigInteger("id");
                if (perLimit > 0) {
                    long already = Db.queryLong("SELECT COUNT(*) FROM coupon_usages WHERE customer_id=? AND coupon_id=? AND is_deleted=0", cid, couponId);
                    if (already >= perLimit) { skipped++; continue; }
                }
                validIds.add(cid);
            }
            if (validIds.isEmpty()) { renderJson(new ApiReturn().addMsg("所有匹配顾客已超过领取上限").fail()); return; }
            // 事务批量发放
            int total = customers.size();
            int[] granted = {0};
            boolean ok = Db.tx(() -> {
                Record locked = Db.findFirst("SELECT id, remain_stock FROM coupons WHERE id=? AND shop_id=? FOR UPDATE", couponId, spId);
                if (locked == null) return false;
                int stock = locked.getInt("remain_stock");
                Date now = new Date();
                for (BigInteger cid : validIds) {
                    if (stock <= 0) break;
                    Db.save("coupon_usages", new Record().set("shop_id", spId).set("coupon_id", couponId)
                        .set("customer_id", cid).set("status", 1)
                        .set("received_at", now)
                        .set("expires_at", new Date(now.getTime() + validDays * 86400000L)));
                    stock--;
                    granted[0]++;
                }
                locked.set("remain_stock", stock);
                return Db.update("coupons", locked);
            });
            if (ok) {
                Map<String, Object> result = new HashMap<>();
                result.put("total", total);
                result.put("granted", granted[0]);
                result.put("skipped", skipped + (validIds.size() - granted[0]));
                renderJson(new ApiReturn().addData("data", result).success());
            } else {
                renderJson(new ApiReturn().addMsg("库存不足或操作失败").fail());
            }
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }

    /** 按条件预览可发放顾客（不实际发放） */
    @RequireLogin @RequirePermission("btn:coupon:grant") @MethodValidation("GET") public void couponsGrantPreview() {
        try {
            BigInteger spId = shopId();
            BigInteger couponId = getBigInteger("couponId");
            Record coupon = Db.findById("coupons", couponId);
            if (coupon == null || !coupon.getBigInteger("shop_id").equals(spId)) {
                renderJson(new ApiReturn().addData("data", java.util.Collections.emptyList()).success()); return;
            }
            int perLimit = coupon.getInt("per_user_limit");
            String tags = getPara("tags");
            String source = getPara("source");
            if ((tags == null || tags.isEmpty()) && (source == null || source.isEmpty())) {
                renderJson(new ApiReturn().addMsg("请选择标签或来源").fail()); return;
            }
            StringBuilder csb = new StringBuilder(
                "SELECT c.id, c.nickname, c.phone, c.tags, COALESCE(u.cnt,0) AS alreadyCount " +
                "FROM customers c LEFT JOIN (" +
                "  SELECT customer_id, COUNT(*) AS cnt FROM coupon_usages WHERE coupon_id=? AND is_deleted=0 GROUP BY customer_id" +
                ") u ON c.id = u.customer_id " +
                "WHERE c.shop_id=? AND c.is_deleted=0");
            java.util.List<Object> cparams = new java.util.ArrayList<>();
            cparams.add(couponId);
            cparams.add(spId);
            if (tags != null && !tags.isEmpty()) {
                String[] tagArr = tags.split(",");
                csb.append(" AND (");
                for (int i = 0; i < tagArr.length; i++) {
                    if (i > 0) csb.append(" OR ");
                    csb.append("tags LIKE ?");
                    cparams.add("%" + tagArr[i].trim() + "%");
                }
                csb.append(")");
            }
            if (source != null && !source.isEmpty()) { csb.append(" AND source=?"); cparams.add(source.replace("'","''")); }
            csb.append(" ORDER BY c.id");
            List<Record> list = Db.find(csb.toString(), cparams.toArray());
            for (Record c : list) {
                long already = c.getLong("alreadyCount");
                c.set("canGrant", perLimit == 0 || already < perLimit);
            }
            renderJson(new ApiReturn().addData("data", list).success());
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("查询失败").fail()); }
    }

    @RequireLogin @RequirePermission("btn:coupon:delete") @MethodValidation("DELETE") public void couponsDelete() {
        try {
            Record c = Db.findById("coupons", getBigInteger("couponId")); if (c==null) { renderBool(false); return; }
            if (!c.getBigInteger("shop_id").equals(shopId())) { renderBool(false); return; }
            c.set("is_deleted",1).set("deleted_time",new Date()); renderBool(Db.update("coupons", c));
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }

    /** 查询顾客可用的优惠券列表（购买时选择使用） */
    @RequireLogin @MethodValidation("GET") public void couponsAvailable() {
        try {
            BigInteger customerId = getBigInteger("customerId");
            BigInteger packageId = getBigInteger("packageId");
            String scene = getPara("scene", "purchase");
            BigInteger spId = shopId();
            if (customerId == null) { renderJson(new ApiReturn().addData("data", java.util.Collections.emptyList()).success()); return; }
            // 最低消费门槛：购买场景用套餐价格，充值场景不过滤（实扣时再校验）
            BigDecimal pkgPrice = BigDecimal.ZERO;
            if (packageId != null) {
                Record pkg = Db.findById("packages", packageId);
                if (pkg != null) pkgPrice = pkg.getBigDecimal("price");
            } else if ("recharge".equals(scene)) {
                pkgPrice = new BigDecimal("99999999"); // 充值场景不过滤最低消费
            }
            String sql = "SELECT cu.id AS coupon_usage_id, cu.expires_at, cu.received_at, " +
                "c.id AS coupon_id, c.name, c.type, c.value, c.min_order_amount, c.valid_days " +
                "FROM coupon_usages cu JOIN coupons c ON cu.coupon_id = c.id " +
                "WHERE cu.customer_id = ? AND cu.status = 1 AND cu.is_deleted = 0 AND cu.expires_at > NOW() " +
                "AND cu.shop_id = ? AND c.is_active = 1 AND c.is_deleted = 0 " +
                "AND c.min_order_amount <= ? AND c.use_scene = ? ORDER BY cu.expires_at ASC";
            List<Record> list = Db.find(sql, customerId, spId, pkgPrice, scene);
            renderJson(new ApiReturn().addData("data", list).success());
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("查询失败").fail()); }
    }

    // ========== Articles ==========
    @RequireLogin @MethodValidation("GET") public void articles() {
        try {
            StringBuilder sb = new StringBuilder("FROM articles a LEFT JOIN article_categories ac ON a.category_id = ac.id WHERE a.is_deleted=0 AND a.shop_id=?");
            java.util.List<Object> params = new java.util.ArrayList<>();
            params.add(shopId());
            String keyword = getPara("keyword");
            if (keyword != null && !keyword.isEmpty()) {
                sb.append(" AND (a.title LIKE ? OR a.content LIKE ?)");
                params.add("%" + keyword.replace("'","''") + "%");
                params.add("%" + keyword.replace("'","''") + "%");
            }
            Integer isPublished = getParaToInt("isPublished");
            if (isPublished != null) { sb.append(" AND a.is_published = ?"); params.add(isPublished); }
            BigInteger categoryId = getBigInteger("categoryId");
            if (categoryId != null) { sb.append(" AND a.category_id = ?"); params.add(categoryId); }
            Integer contentType = getParaToInt("contentType");
            if (contentType != null) { sb.append(" AND a.content_type = ?"); params.add(contentType); }
            String startDate = getPara("startDate");
            if (startDate != null && !startDate.isEmpty()) { sb.append(" AND a.created_at >= ?"); params.add(startDate); }
            String endDate = getPara("endDate");
            if (endDate != null && !endDate.isEmpty()) { sb.append(" AND a.created_at <= ?"); params.add(endDate + " 23:59:59"); }
            sb.append(" ORDER BY a.created_at DESC");
            Page<Record> p = Db.paginate(getParaToInt("page",1), getParaToInt("size",20),
                "SELECT a.id, a.shop_id, a.category_id, ac.name AS category_name, a.title, a.content_type, a.cover_image, a.is_published, a.published_at, a.created_at, a.updated_at", sb.toString(), params.toArray());
            renderPage(p);
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("查询失败").fail()); }
    }
    @RequireLogin @MethodValidation("GET") public void articlesInfo() {
        try {
            Record a = Db.findFirst("SELECT a.*, ac.name AS category_name FROM articles a LEFT JOIN article_categories ac ON a.category_id = ac.id WHERE a.id = ? AND a.is_deleted=0", getBigInteger("articleId"));
            if (a == null) { renderJson(new ApiReturn().addMsg("文章不存在").fail()); return; }
            if (!shopId().equals(a.getBigInteger("shop_id"))) { renderJson(new ApiReturn().addMsg("无权访问").fail()); return; }
            // 将 JSON 数组字段转为逗号分隔字符串，方便前端使用
            a.set("image_urls", fromJsonArray(a.getStr("image_urls")));
            renderJson(new ApiReturn().addData("data", a).success());
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("查询失败").fail()); }
    }
    @RequireLogin @RequirePermission("btn:article:add") @MethodValidation("POST") public void articlesAdd() {
        try {
            Integer isPublished = getParaToInt("isPublished");
            boolean publish = isPublished == null || isPublished == 1;
            int contentType = getParaToInt("contentType", 3);
            Record r = new Record().set("shop_id",shopId()).set("category_id",getBigInteger("categoryId"))
                .set("title",getPara("title")).set("content_type", contentType)
                .set("cover_image",getPara("coverImage"))
                .set("is_published", publish ? 1 : 0)
                .set("published_at", publish ? new Date() : null)
                .set("is_deleted",0)
                .set("created_at",new Date()).set("updated_at",new Date());
            if (contentType == 1) { r.set("image_urls", toJsonArray(getPara("imageUrls"))); }
            else if (contentType == 2) { r.set("video_url", getPara("videoUrl")); }
            else { r.set("content", getPara("content")); }
            renderBool(Db.save("articles", r));
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }
    @RequireLogin @RequirePermission("btn:article:edit") @MethodValidation("PUT") public void articlesUpdate() {
        try {
            Record a = Db.findById("articles", getBigInteger("articleId")); if (a==null) { renderBool(false); return; }
            if (!a.getBigInteger("shop_id").equals(shopId())) { renderBool(false); return; }
            if (getPara("title")!=null) a.set("title",getPara("title"));
            if (getPara("coverImage")!=null) a.set("cover_image",getPara("coverImage"));
            if (getPara("categoryId")!=null) a.set("category_id",getBigInteger("categoryId"));
            Integer contentType = getParaToInt("contentType");
            if (contentType != null) { a.set("content_type", contentType); }
            int ct = (contentType != null ? contentType : a.getInt("content_type"));
            if (ct == 1 && getPara("imageUrls") != null) { a.set("image_urls", toJsonArray(getPara("imageUrls"))); }
            else if (ct == 2 && getPara("videoUrl") != null) { a.set("video_url", getPara("videoUrl")); }
            else if (ct == 3 && getPara("content") != null) { a.set("content", getPara("content")); }
            a.set("updated_at",new Date()); renderBool(Db.update("articles", a));
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }
    @RequireLogin @RequirePermission("btn:article:delete") @MethodValidation("DELETE") public void articlesDelete() {
        try { Record a = Db.findById("articles", getBigInteger("articleId")); if (a==null) { renderBool(false); return; }
            if (!a.getBigInteger("shop_id").equals(shopId())) { renderBool(false); return; }
            a.set("is_deleted",1).set("deleted_time",new Date()); renderBool(Db.update("articles", a));
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }
    @RequireLogin @RequirePermission("btn:article:publish") @MethodValidation("PUT") public void articlesPublish() {
        try { Record a = Db.findById("articles", getBigInteger("articleId")); if (a==null) { renderBool(false); return; }
            if (!a.getBigInteger("shop_id").equals(shopId())) { renderBool(false); return; }
            int isPublished = getParaToInt("isPublished",0);
            a.set("is_published", isPublished);
            a.set("published_at", isPublished == 1 ? new Date() : null);
            renderBool(Db.update("articles", a));
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }
    @RequireLogin @MethodValidation("GET") public void articleCategories() {
        try { List<Record> list = Db.find("SELECT * FROM article_categories WHERE is_deleted=0 AND (shop_id=0 OR shop_id=?) ORDER BY shop_id, sort", shopId());
            renderJson(new ApiReturn().addData("data",list).success());
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("查询失败").fail()); }
    }
    @RequireLogin @MethodValidation("POST") public void articleCategoriesAdd() {
        try {
            renderBool(Db.save("article_categories", new Record().set("shop_id",shopId()).set("name",getPara("name")).set("sort",getParaToInt("sort",0)).set("is_deleted",0).set("created_at",new Date())));
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }
    @RequireLogin @MethodValidation("PUT") public void articleCategoriesUpdate() {
        try { Record c = Db.findById("article_categories", getBigInteger("categoryId")); if (c==null) { renderBool(false); return; }
            boolean isSystem = BigInteger.ZERO.equals(c.getBigInteger("shop_id"));
            if (isSystem) { renderJson(new ApiReturn().addMsg("系统分类不可修改").fail()); return; }
            if (!c.getBigInteger("shop_id").equals(shopId())) { renderBool(false); return; }
            if (getPara("name")!=null) c.set("name",getPara("name"));
            if (getParaToInt("sort")!=null) c.set("sort",getParaToInt("sort"));
            renderBool(Db.update("article_categories", c));
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }
    @RequireLogin @MethodValidation("DELETE") public void articleCategoriesDelete() {
        try { Record c = Db.findById("article_categories", getBigInteger("categoryId")); if (c==null) { renderBool(false); return; }
            boolean isSystem = BigInteger.ZERO.equals(c.getBigInteger("shop_id"));
            if (isSystem) { renderJson(new ApiReturn().addMsg("系统分类不可删除").fail()); return; }
            if (!c.getBigInteger("shop_id").equals(shopId())) { renderBool(false); return; }
            BigInteger catId = c.getBigInteger("id");
            long articleCount = Db.queryLong("SELECT COUNT(*) FROM articles WHERE category_id=? AND is_deleted=0", catId);
            if (articleCount > 0) { renderJson(new ApiReturn().addMsg("该分类下有 " + articleCount + " 篇文章，请先清理后再删除").fail()); return; }
            c.set("is_deleted",1).set("deleted_time",new Date()); renderBool(Db.update("article_categories", c));
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }
    @RequireLogin @MethodValidation("POST") public void articleCategoriesSort() {
        try {
            String json = getPara("items");
            if (json == null || json.isEmpty()) { renderBool(false); return; }
            com.alibaba.fastjson.JSONArray arr = com.alibaba.fastjson.JSON.parseArray(json);
            if (arr.isEmpty()) { renderBool(false); return; }
            BigInteger spId = shopId();
            boolean ok = Db.tx(() -> {
                for (int i = 0; i < arr.size(); i++) {
                    com.alibaba.fastjson.JSONObject item = arr.getJSONObject(i);
                    BigInteger id = item.getBigInteger("id");
                    int sort = item.getInteger("sort");
                    Record c = Db.findById("article_categories", id);
                    if (c == null) return false;
                    if (!c.getBigInteger("shop_id").equals(spId)) return false;
                    c.set("sort", (long) sort);
                    if (!Db.update("article_categories", c)) return false;
                }
                return true;
            });
            renderBool(ok);
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }

    private BigInteger shopId() { User u=getSessionAttr("userinfo"); return u!=null?u.getLoginShopId():null; }
    private BigInteger getBigInteger(String n) { String v=getPara(n); return v==null||v.isEmpty()?null:new BigInteger(v); }
    private void renderPage(Page<Record> p) { java.util.Map<String,Object> _m=new java.util.HashMap<>(); _m.put("list",p.getList()); _m.put("total",(int)p.getTotalRow()); renderJson(new ApiReturn().addData("data",_m).success()); }
    private void renderBool(boolean ok) { renderJson(ok ? new ApiReturn().success() : new ApiReturn().addMsg("操作失败").fail()); }

    /** 逗号分隔字符串 → JSON 数组字符串 */
    private String toJsonArray(String csv) {
        if (csv == null || csv.isEmpty()) return "[]";
        String[] parts = csv.split(",");
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < parts.length; i++) {
            if (i > 0) sb.append(",");
            sb.append("\"").append(parts[i].trim()).append("\"");
        }
        sb.append("]");
        return sb.toString();
    }

    /** JSON 数组字符串 → 逗号分隔字符串 */
    private String fromJsonArray(String json) {
        if (json == null || json.isEmpty()) return "";
        try {
            com.alibaba.fastjson.JSONArray arr = com.alibaba.fastjson.JSON.parseArray(json);
            if (arr == null) return "";
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < arr.size(); i++) {
                if (i > 0) sb.append(",");
                sb.append(arr.getString(i));
            }
            return sb.toString();
        } catch (Exception e) { return json; }
    }
}
