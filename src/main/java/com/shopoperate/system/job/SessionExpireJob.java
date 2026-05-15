package com.shopoperate.system.job;

import com.jfinal.plugin.activerecord.Db;
import org.apache.log4j.Logger;
import org.quartz.Job;
import org.quartz.JobExecutionContext;

/**
 * 顾客 session 过期 — 每日 00:00
 * 将 session_date < 今天 且状态为"可用"的 customer_sessions 改为"已过期"
 */
public class SessionExpireJob implements Job {
    private static final Logger log = Logger.getLogger(SessionExpireJob.class);

    @Override
    public void execute(JobExecutionContext context) {
        log.info("[SessionExpireJob] 开始执行...");
        try {
            int n = Db.update(
                "UPDATE customer_sessions SET status = 3 WHERE status = 1 AND session_date < CURDATE()");
            log.info("[SessionExpireJob] 过期处理: " + n + " 条场次");
        } catch (Exception e) {
            log.error("[SessionExpireJob] 执行异常", e);
        }
        log.info("[SessionExpireJob] 执行完毕");
    }
}
