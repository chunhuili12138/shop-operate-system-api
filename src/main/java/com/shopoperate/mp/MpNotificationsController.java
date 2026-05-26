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
            renderJson(new ApiReturn().addData("list", pg.getList()).addData("total", pg.getTotalRow()).addData("page", page).addData("size", size).success());
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
            if (staff == null) { renderJson(new ApiReturn().addData("list", Collections.emptyList()).success()); return; }
            BigInteger staffId = staff.getBigInteger("id");
            StringBuilder w = new StringBuilder("WHERE staff_id = ? AND is_deleted = 0");
            List<Object> ps = new ArrayList<>(); ps.add(staffId);
            if (startDate != null && !startDate.isEmpty()) { w.append(" AND schedule_date >= ?"); ps.add(startDate); }
            if (endDate != null && !endDate.isEmpty()) { w.append(" AND schedule_date <= ?"); ps.add(endDate); }
            List<Record> schedules = Db.find("SELECT * FROM staff_schedules " + w + " ORDER BY schedule_date ASC", ps.toArray());
            renderJson(new ApiReturn().addData("list", schedules).addData("total", schedules.size()).success());
        } catch (Exception e) { log.error("排班查询异常", e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }
}
