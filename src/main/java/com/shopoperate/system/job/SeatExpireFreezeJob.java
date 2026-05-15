package com.shopoperate.system.job;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import org.apache.log4j.Logger;
import org.quartz.Job;
import org.quartz.JobExecutionContext;

import java.util.Date;
import java.util.List;

/**
 * 席位到期冻结 — 每日 00:00
 * 将已过期的席位状态改为"已过期"，并通知对应商户店铺
 */
public class SeatExpireFreezeJob implements Job {
    private static final Logger log = Logger.getLogger(SeatExpireFreezeJob.class);

    @Override
    public void execute(JobExecutionContext context) {
        log.info("[SeatExpireFreezeJob] 开始执行...");
        try {
            List<Record> expired = Db.find(
                "SELECT ss.*, s.name AS tenant_name FROM seat_subscriptions ss " +
                "INNER JOIN staff s ON ss.staff_id = s.id " +
                "WHERE ss.status = 1 AND ss.end_date < CURDATE()");
            if (expired.isEmpty()) {
                log.info("[SeatExpireFreezeJob] 无到期席位");
                return;
            }
            for (Record seat : expired) {
                seat.set("status", 2).set("updated_at", new Date());
                Db.update("seat_subscriptions", seat);

                String tenantName = seat.getStr("tenant_name");
                String content = "您的席位已于 " + seat.getStr("end_date") + " 到期，店铺功能受限。请续订以恢复正常。";

                List<Record> shops = Db.find(
                    "SELECT id FROM shops WHERE owner_staff_id = ? AND is_deleted = 0",
                    seat.getBigInteger("staff_id"));
                for (Record shop : shops) {
                    Record notif = new Record()
                        .set("shop_id", shop.getBigInteger("id"))
                        .set("recipient_type", 2)
                        .set("recipient_id", seat.getBigInteger("staff_id"))
                        .set("channel", 3)
                        .set("title", "席位已到期")
                        .set("content", content)
                        .set("status", 1)
                        .set("created_at", new Date());
                    Db.save("notification_logs", notif);
                }
            }
            log.info("[SeatExpireFreezeJob] 冻结席位: " + expired.size() + " 个");
        } catch (Exception e) {
            log.error("[SeatExpireFreezeJob] 执行异常", e);
        }
        log.info("[SeatExpireFreezeJob] 执行完毕");
    }
}
