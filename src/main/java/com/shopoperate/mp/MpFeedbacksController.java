package com.shopoperate.mp;

import com.jfinal.core.Controller;
import com.jfinal.core.Path;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.shopoperate.common.annotation.MethodValidation;
import com.shopoperate.common.annotation.RequireLogin;
import com.shopoperate.utils.ApiReturn;
import org.apache.log4j.Logger;
import java.math.BigInteger;
import java.util.*;

@Path(value = "/api/mp/feedbacks")
public class MpFeedbacksController extends Controller {
    private static final Logger log = Logger.getLogger(MpFeedbacksController.class);
    @RequireLogin @MethodValidation("POST")
    public void submit() {
        BigInteger shopId = MpHelper.getShopId(this); BigInteger customerId = MpHelper.getCustomerId(this);
        if (shopId == null || customerId == null) { renderJson(new ApiReturn().addMsg("请先选择店铺并登录").fail()); return; }
        try {
            Record r = new Record().set("shop_id", shopId).set("customer_id", customerId)
                .set("feedback_type", getPara("type", "4")).set("rating", getParaToInt("rating", 5))
                .set("content", getPara("content", "")).set("image_urls", getPara("imageUrls"))
                .set("status", 0).set("is_deleted", 0).set("created_at", new Date());
            BigInteger gameSessionId = MpHelper.parseBigInteger(getPara("gameSessionId"));
            if (gameSessionId != null) r.set("game_session_id", gameSessionId);
            Db.save("feedbacks", r);
            renderJson(new ApiReturn().success());
        } catch (Exception e) { log.error("提交评价异常", e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }
    @RequireLogin @MethodValidation("GET")
    public void my() {
        BigInteger customerId = MpHelper.getCustomerId(this);
        if (customerId == null) { renderJson(new ApiReturn().loginInvalid()); return; }
        int page = getParaToInt("page", 1); int size = getParaToInt("size", 20);
        try {
            Page<Record> pg = Db.paginate(page, size, "SELECT *", "FROM feedbacks WHERE customer_id = ? AND is_deleted = 0 ORDER BY created_at DESC", customerId);
            List<Map<String, Object>> list = new ArrayList<>();
            for (Record r : pg.getList()) {
                Map<String, Object> m = new HashMap<>();
                m.put("id", r.getBigInteger("id")); m.put("feedbackType", r.getStr("feedback_type"));
                m.put("rating", r.getInt("rating")); m.put("content", r.getStr("content"));
                m.put("replyContent", r.getStr("reply_content")); m.put("status", r.getInt("status"));
                m.put("createdAt", r.getDate("created_at")); list.add(m);
            }
            renderJson(new ApiReturn().addData("data", new HashMap<String,Object>() {{
                put("list", list);
                put("total", (int)pg.getTotalRow());
                put("page", page);
                put("size", size);
            }}).success());
        } catch (Exception e) { log.error("评价列表异常", e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }
}
