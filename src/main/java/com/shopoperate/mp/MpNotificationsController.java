package com.shopoperate.mp;

import com.jfinal.core.Controller;
import com.jfinal.core.Path;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.shopoperate.common.annotation.MethodValidation;
import com.shopoperate.common.annotation.RequireLogin;
import com.shopoperate.common.vo.User;
import com.shopoperate.utils.ApiReturn;
import org.apache.log4j.Logger;
import java.math.BigInteger;
import java.util.*;

@Path(value = "/api/mp/notifications")
public class MpNotificationsController extends Controller {
    private static final Logger log = Logger.getLogger(MpNotificationsController.class);
    @RequireLogin @MethodValidation("GET")
    public void list() {
        User u = getSessionAttr("userinfo");
        if (u == null) { renderJson(new ApiReturn().loginInvalid()); return; }
        int page = getParaToInt("page", 1); int size = getParaToInt("size", 20);
        try {
            Page<Record> pg = Db.paginate(page, size, "SELECT *",
                "FROM notification_logs WHERE recipient_id = ? AND is_deleted = 0 ORDER BY created_at DESC", u.getId());
            List<Map<String, Object>> list = new ArrayList<>();
            for (Record r : pg.getList()) {
                Map<String, Object> m = new HashMap<>();
                m.put("id", r.getBigInteger("id"));
                m.put("title", r.getStr("title"));
                m.put("content", r.getStr("content"));
                m.put("isRead", r.getInt("is_read"));
                m.put("recipientType", r.getInt("recipient_type"));
                m.put("createdAt", r.getDate("created_at"));
                list.add(m);
            }
            renderJson(new ApiReturn().addData("data", new HashMap<String,Object>() {{
                put("list", list);
                put("total", (int)pg.getTotalRow());
                put("page", page);
                put("size", size);
            }}).success());
        } catch (Exception e) { log.error("通知列表异常", e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }
    @RequireLogin @MethodValidation("PUT")
    public void read() {
        String ids = getPara("notificationIds");
        if (ids == null || ids.isEmpty()) { renderJson(new ApiReturn().addMsg("通知ID不能为空").fail()); return; }
        try {
            Db.update("UPDATE notification_logs SET is_read = 1 WHERE FIND_IN_SET(id, ?)", ids);
            renderJson(new ApiReturn().success());
        } catch (Exception e) { log.error("标记已读异常", e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }
}

@Path(value = "/api/mp/staff/schedules")
class MpSchedulesController extends Controller {
    private static final Logger log = Logger.getLogger(MpSchedulesController.class);
    @RequireLogin @MethodValidation("GET")
    public void list() {
        User u = getSessionAttr("userinfo");
        if (u == null || u.getIsStaff() == null || u.getIsStaff() != 1) { renderJson(new ApiReturn().addMsg("无权访问").fail()); return; }
        String startDate = getPara("startDate"); String endDate = getPara("endDate");
        try {
            Record staff = Db.findFirst("SELECT s.id FROM staff s INNER JOIN staff_shops ss ON s.id = ss.staff_id WHERE s.phone = (SELECT phone FROM customers WHERE id = ? LIMIT 1) AND ss.shop_id = ? AND s.is_deleted = 0 AND s.status = 1 LIMIT 1", u.getCustomerId(), u.getLoginShopId());
            if (staff == null) { renderJson(new ApiReturn().addData("data", Collections.singletonMap("list", Collections.emptyList())).success()); return; }
            BigInteger staffId = staff.getBigInteger("id");
            StringBuilder w = new StringBuilder("WHERE staff_id = ? AND is_deleted = 0");
            List<Object> ps = new ArrayList<>(); ps.add(staffId);
            if (startDate != null && !startDate.isEmpty()) { w.append(" AND schedule_date >= ?"); ps.add(startDate); }
            if (endDate != null && !endDate.isEmpty()) { w.append(" AND schedule_date <= ?"); ps.add(endDate); }
            List<Record> schedulesRaw = Db.find("SELECT * FROM staff_schedules " + w + " ORDER BY schedule_date ASC", ps.toArray());
            List<Map<String, Object>> schedules = new ArrayList<>();
            for (Record r : schedulesRaw) {
                Map<String, Object> m = new HashMap<>();
                m.put("id", r.getBigInteger("id"));
                m.put("scheduleDate", r.getDate("schedule_date"));
                m.put("startTime", r.getTime("start_time"));
                m.put("endTime", r.getTime("end_time"));
                m.put("type", r.getInt("type"));
                m.put("remark", r.getStr("remark"));
                schedules.add(m);
            }
            renderJson(new ApiReturn().addData("data", new HashMap<String,Object>() {{
                put("list", schedules);
                put("total", schedules.size());
            }}).success());
        } catch (Exception e) { log.error("排班查询异常", e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }
}
