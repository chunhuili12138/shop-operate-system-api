package com.shopoperate.mp;

import com.jfinal.core.Controller;
import com.jfinal.core.Path;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.shopoperate.common.annotation.MethodValidation;
import com.shopoperate.utils.ApiReturn;
import org.apache.log4j.Logger;
import java.math.BigInteger;
import java.util.*;

@Path(value = "/api/mp/articles")
public class MpArticlesController extends Controller {
    private static final Logger log = Logger.getLogger(MpArticlesController.class);
    @MethodValidation("GET")
    public void list() {
        BigInteger shopId = MpHelper.getShopId(this);
        if (shopId == null) { renderJson(new ApiReturn().addMsg("shopId不能为空").fail()); return; }
        int page = getParaToInt("page", 1); int size = getParaToInt("size", 20);
        BigInteger categoryId = MpHelper.parseBigInteger(getPara("categoryId"));
        try {
            StringBuilder w = new StringBuilder("WHERE a.shop_id = ? AND a.is_published = 1 AND a.is_deleted = 0");
            List<Object> ps = new ArrayList<>(); ps.add(shopId);
            if (categoryId != null) { w.append(" AND a.category_id = ?"); ps.add(categoryId); }
            Page<Record> pg = Db.paginate(page, size, "SELECT a.id, a.title, a.cover_image, a.content_type, a.published_at, ac.name AS category_name",
                "FROM articles a LEFT JOIN article_categories ac ON a.category_id = ac.id " + w + " ORDER BY a.published_at DESC", ps.toArray());
            List<Map<String, Object>> list = new ArrayList<>();
            for (Record r : pg.getList()) {
                Map<String, Object> m = new HashMap<>();
                m.put("id", r.getBigInteger("id")); m.put("title", r.getStr("title"));
                m.put("coverImage", r.getStr("cover_image")); m.put("contentType", r.getInt("content_type"));
                m.put("publishedAt", r.getDate("published_at")); m.put("categoryName", r.getStr("category_name"));
                list.add(m);
            }
            renderJson(new ApiReturn().addData("list", list).addData("total", pg.getTotalRow()).addData("page", page).addData("size", size).success());
        } catch (Exception e) { log.error("文章列表异常", e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }
    @MethodValidation("GET")
    public void categories() {
        BigInteger shopId = MpHelper.getShopId(this);
        if (shopId == null) { renderJson(new ApiReturn().addMsg("shopId不能为空").fail()); return; }
        try {
            List<Record> cats = Db.find("SELECT * FROM article_categories WHERE shop_id = ? ORDER BY sort ASC", shopId);
            List<Map<String, Object>> list = new ArrayList<>();
            for (Record r : cats) { Map<String, Object> m = new HashMap<>(); m.put("id", r.getBigInteger("id")); m.put("name", r.getStr("name")); m.put("sort", r.getInt("sort")); list.add(m); }
            renderJson(new ApiReturn().addData("list", list).success());
        } catch (Exception e) { log.error("文章分类异常", e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }
    @MethodValidation("GET")
    public void detail() {
        BigInteger id = MpHelper.parseBigInteger(getPara(0));
        if (id == null) { renderJson(new ApiReturn().addMsg("文章ID不能为空").fail()); return; }
        try {
            Record a = Db.findFirst("SELECT a.*, ac.name AS category_name FROM articles a LEFT JOIN article_categories ac ON a.category_id = ac.id WHERE a.id = ? AND a.is_deleted = 0", id);
            if (a == null) { renderJson(new ApiReturn().addMsg("文章不存在").fail()); return; }
            Map<String, Object> d = new HashMap<>();
            d.put("id", a.getBigInteger("id")); d.put("title", a.getStr("title"));
            d.put("contentType", a.getInt("content_type")); d.put("content", a.getStr("content"));
            d.put("coverImage", a.getStr("cover_image")); d.put("categoryName", a.getStr("category_name"));
            d.put("publishedAt", a.getDate("published_at"));
            d.put("imageUrls", a.getStr("image_urls")); d.put("videoUrl", a.getStr("video_url"));
            renderJson(new ApiReturn().addData("data", d).success());
        } catch (Exception e) { log.error("文章详情异常", e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }
}
