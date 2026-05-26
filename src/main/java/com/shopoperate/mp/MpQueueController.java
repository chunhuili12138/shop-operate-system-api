package com.shopoperate.mp;

import com.jfinal.core.Controller;
import com.jfinal.core.Path;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.shopoperate.common.annotation.MethodValidation;
import com.shopoperate.common.annotation.RequireLogin;
import com.shopoperate.utils.ApiReturn;
import org.apache.log4j.Logger;
import java.math.BigInteger;
import java.util.*;

@Path(value = "/api/mp/queue")
public class MpQueueController extends Controller {
    private static final Logger log = Logger.getLogger(MpQueueController.class);
    @RequireLogin @MethodValidation("POST")
    public void take() {
        BigInteger shopId = MpHelper.getShopId(this); BigInteger customerId = MpHelper.getCustomerId(this);
        if (shopId == null || customerId == null) { renderJson(new ApiReturn().addMsg("请先选择店铺并登录").fail()); return; }
        int partySize = getParaToInt("partySize", 1);
        try {
            Long maxNum = Db.queryLong("SELECT COALESCE(MAX(queue_number), 0) FROM queue_entries WHERE shop_id = ? AND DATE(requested_at) = CURDATE()", shopId);
            Record r = new Record().set("shop_id", shopId).set("customer_id", customerId)
                .set("queue_number", maxNum.intValue() + 1).set("party_size", partySize).set("status", 1)
                .set("requested_at", new Date()).set("is_deleted", 0);
            Db.save("queue_entries", r);
            Map<String, Object> d = new HashMap<>();
            d.put("id", r.getBigInteger("id")); d.put("queueNumber", r.getInt("queue_number"));
            d.put("partySize", partySize);
            renderJson(new ApiReturn().addData("data", d).success());
        } catch (Exception e) { log.error("取号异常", e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }
    @RequireLogin @MethodValidation("GET")
    public void status() {
        BigInteger shopId = MpHelper.getShopId(this); BigInteger customerId = MpHelper.getCustomerId(this);
        if (shopId == null || customerId == null) { renderJson(new ApiReturn().addMsg("请先选择店铺并登录").fail()); return; }
        try {
            Record mine = Db.findFirst("SELECT * FROM queue_entries WHERE shop_id = ? AND customer_id = ? AND status = 1 AND is_deleted = 0 ORDER BY requested_at DESC LIMIT 1", shopId, customerId);
            if (mine == null) { renderJson(new ApiReturn().addData("data", Collections.singletonMap("inQueue", false)).success()); return; }
            long waitingBefore = Db.queryLong("SELECT COUNT(*) FROM queue_entries WHERE shop_id = ? AND status = 1 AND is_deleted = 0 AND queue_number < ?", shopId, mine.getInt("queue_number"));
            Map<String, Object> d = new HashMap<>();
            d.put("inQueue", true); d.put("id", mine.getBigInteger("id"));
            d.put("queueNumber", mine.getInt("queue_number")); d.put("partySize", mine.getInt("party_size"));
            d.put("waitingBefore", waitingBefore); d.put("requestedAt", mine.getDate("requested_at"));
            renderJson(new ApiReturn().addData("data", d).success());
        } catch (Exception e) { log.error("排队状态异常", e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }
    @RequireLogin @MethodValidation("POST")
    public void cancel() {
        BigInteger customerId = MpHelper.getCustomerId(this);
        if (customerId == null) { renderJson(new ApiReturn().loginInvalid()); return; }
        try {
            Record mine = Db.findFirst("SELECT * FROM queue_entries WHERE customer_id = ? AND status = 1 AND is_deleted = 0 ORDER BY requested_at DESC LIMIT 1", customerId);
            if (mine == null) { renderJson(new ApiReturn().addMsg("无进行中的排队").fail()); return; }
            mine.set("status", 3); Db.update("queue_entries", mine);
            renderJson(new ApiReturn().success());
        } catch (Exception e) { log.error("取消排队异常", e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }
}
