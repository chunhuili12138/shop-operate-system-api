package com.shopoperate.feedback;

import com.jfinal.core.Controller;
import com.jfinal.core.Path;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.shopoperate.common.annotation.*;
import com.shopoperate.common.vo.User;
import com.shopoperate.utils.ApiReturn;
import org.apache.log4j.Logger;
import java.math.BigInteger;
import java.util.Date;

@Path(value = "/api/feedbacks")
public class FeedbackController extends Controller {
    private static final Logger log = Logger.getLogger(FeedbackController.class);

    @RequireLogin @MethodValidation("GET") public void page() {
        User u = getSessionAttr("userinfo");
        try {
            Page<Record> p = Db.paginate(getParaToInt("page",1), getParaToInt("size",20),
                "SELECT f.*, c.nickname AS customer_name",
                "FROM feedbacks f LEFT JOIN customers c ON f.customer_id=c.id WHERE f.shop_id=? ORDER BY f.created_at DESC",
                u.getLoginShopId());
            java.util.Map<String,Object> _m=new java.util.HashMap<>(); _m.put("list",p.getList()); _m.put("total",(int)p.getTotalRow()); renderJson(new ApiReturn().addData("data",_m).success());
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("查询失败").fail()); }
    }

    @RequireLogin @MethodValidation("GET") public void info() {
        User u = getSessionAttr("userinfo");
        try {
            Record f = Db.findFirst("SELECT f.*, c.nickname AS customer_name, c.avatar_url AS customer_avatar " +
                "FROM feedbacks f LEFT JOIN customers c ON f.customer_id=c.id WHERE f.id=? AND f.shop_id=?", getBigInteger("feedbackId"), u.getLoginShopId());
            renderJson(f!=null ? new ApiReturn().addData("data",f).success() : new ApiReturn().addMsg("评价不存在").fail());
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("查询失败").fail()); }
    }

    @RequireLogin @MethodValidation("PUT") public void reply() {
        User u = getSessionAttr("userinfo");
        try {
            Record f = Db.findById("feedbacks", getBigInteger("feedbackId"));
            if (f == null) { renderJson(new ApiReturn().addMsg("评价不存在").fail()); return; }
            if (u.getLoginShopId() != null && !u.getLoginShopId().equals(f.getBigInteger("shop_id"))) { renderJson(new ApiReturn().addMsg("无权操作").fail()); return; }
            f.set("reply_content", getPara("replyContent")).set("replied_by", u.getId())
                .set("replied_at", new Date()).set("status", 2);
            renderBool(Db.update("feedbacks", f));
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }

    private BigInteger getBigInteger(String n) { String v=getPara(n); return v==null||v.isEmpty()?null:new BigInteger(v); }
    private void renderBool(boolean ok) { renderJson(ok ? new ApiReturn().success() : new ApiReturn().addMsg("操作失败").fail()); }
}
