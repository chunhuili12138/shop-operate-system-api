package com.shopoperate.system.job;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.shopoperate.trade.TradeService;
import org.apache.log4j.Logger;
import org.quartz.Job;
import org.quartz.JobExecutionContext;

import java.math.BigInteger;
import java.util.Date;
import java.util.List;

/**
 * 游玩场次监控 — 每 5 分钟执行
 * 1. 超时 4 小时自动结束
 * 2. 超过套餐时长发送提醒
 */
public class GameSessionMonitorJob implements Job {
    private static final Logger log = Logger.getLogger(GameSessionMonitorJob.class);

    @Override
    public void execute(JobExecutionContext context) {
        log.info("[GameSessionMonitorJob] 开始执行...");
        try {
            Date now = new Date();

            // 1. 超时 4 小时自动结束
            List<Record> timeoutSessions = Db.find(
                "SELECT gs.id, gs.shop_id, gs.staff_id FROM game_sessions gs " +
                "WHERE gs.status = 1 AND gs.start_time < DATE_SUB(NOW(), INTERVAL 4 HOUR)");
            int finished = 0;
            for (Record gs : timeoutSessions) {
                if (TradeService.me.finish(gs.getBigInteger("id"), null)) {
                    finished++;
                }
            }
            if (!timeoutSessions.isEmpty()) {
                log.info("[GameSessionMonitorJob] 超时自动结束: " + finished + "/" + timeoutSessions.size());
            }

            // 2. 超过套餐时长发送提醒
            List<Record> overdueSessions = Db.find(
                "SELECT gs.id, gs.shop_id, gs.staff_id, s.name AS staff_name, pk.name AS pkg_name, pk.duration_minutes, " +
                "TIMESTAMPDIFF(MINUTE, gs.start_time, NOW()) AS elapsed " +
                "FROM game_sessions gs " +
                "LEFT JOIN staff s ON gs.staff_id = s.id " +
                "LEFT JOIN customer_sessions cs ON gs.customer_session_id = cs.id " +
                "LEFT JOIN purchases p ON cs.purchase_id = p.id " +
                "LEFT JOIN packages pk ON p.package_id = pk.id " +
                "WHERE gs.status = 1 AND pk.duration_minutes IS NOT NULL " +
                "AND gs.start_time < DATE_SUB(NOW(), INTERVAL pk.duration_minutes MINUTE)");
            int reminded = 0;
            for (Record sess : overdueSessions) {
                Integer duration = sess.getInt("duration_minutes");
                Long elapsed = sess.getLong("elapsed");
                Db.save("notification_logs", new Record()
                    .set("shop_id", sess.get("shop_id"))
                    .set("recipient_type", 2)
                    .set("recipient_id", sess.getBigInteger("staff_id"))
                    .set("channel", 3)
                    .set("title", "游玩时长提醒")
                    .set("content", "套餐「" + sess.getStr("pkg_name") + "」已超过规定时长 " + duration + " 分钟（已持续 " + elapsed + " 分钟），请确认是否结束")
                    .set("status", 2)
                    .set("created_at", now));
                reminded++;
            }
            if (reminded > 0) {
                log.info("[GameSessionMonitorJob] 时长提醒已发送: " + reminded + " 条");
            }
            log.info("[GameSessionMonitorJob] 执行完毕");
        } catch (Exception e) {
            log.error("[GameSessionMonitorJob] 执行异常", e);
        }
    }
}
