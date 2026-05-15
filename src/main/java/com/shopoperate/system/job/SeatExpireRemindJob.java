package com.shopoperate.system.job;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import org.apache.log4j.Logger;
import org.quartz.Job;
import org.quartz.JobExecutionContext;

import java.math.BigInteger;
import java.util.Date;
import java.util.List;

/**
 * 席位到期提醒 — 每日 08:00
 * 到期前 30/7/3/1 天推送站内信通知商户
 */
public class SeatExpireRemindJob implements Job {
    private static final Logger log = Logger.getLogger(SeatExpireRemindJob.class);

    @Override
    public void execute(JobExecutionContext context) {
        log.info("[SeatExpireRemindJob] 开始执行...");
        try {
            int[] daysArr = {30, 7, 3, 1};
            for (int days : daysArr) {
                String sql = "SELECT ss.*, s.name AS tenant_name FROM seat_subscriptions ss " +
                    "INNER JOIN staff s ON ss.staff_id = s.id " +
                    "WHERE ss.status = 1 AND ss.end_date = DATE_ADD(CURDATE(), INTERVAL ? DAY)";
                List<Record> seats = Db.find(sql, days);
                for (Record seat : seats) {
                    BigInteger staffId = seat.getBigInteger("staff_id");
                    String tenantName = seat.getStr("tenant_name");
                    String endDate = seat.getStr("end_date");
                    String title = "席位即将到期";
                    String content = "您的席位将于 " + endDate + " 到期（剩余" + days + "天），请及时续订，以免影响店铺运营。";

                    List<Record> shops = Db.find(
                        "SELECT id FROM shops WHERE owner_staff_id = ? AND is_deleted = 0", staffId);
                    for (Record shop : shops) {
                        Record notif = new Record()
                            .set("shop_id", shop.getBigInteger("id"))
                            .set("recipient_type", 2)
                            .set("recipient_id", staffId)
                            .set("channel", 3)
                            .set("title", title)
                            .set("content", content)
                            .set("status", 1)
                            .set("created_at", new Date());
                        Db.save("notification_logs", notif);
                    }
                }
                if (!seats.isEmpty()) {
                    log.info("[SeatExpireRemindJob] 剩余" + days + "天到期: " + seats.size() + " 个席位");
                }
            }
        } catch (Exception e) {
            log.error("[SeatExpireRemindJob] 执行异常", e);
        }
        log.info("[SeatExpireRemindJob] 执行完毕");
    }
}
