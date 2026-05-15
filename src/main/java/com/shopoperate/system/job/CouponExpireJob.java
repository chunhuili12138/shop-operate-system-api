package com.shopoperate.system.job;

import com.jfinal.plugin.activerecord.Db;
import org.apache.log4j.Logger;
import org.quartz.Job;
import org.quartz.JobExecutionContext;

/**
 * 优惠券过期处理 — 每日 00:00
 * 将已过期但状态仍为"未使用"的优惠券记录改为"已过期"
 */
public class CouponExpireJob implements Job {
    private static final Logger log = Logger.getLogger(CouponExpireJob.class);

    @Override
    public void execute(JobExecutionContext context) {
        log.info("[CouponExpireJob] 开始执行...");
        try {
            int n = Db.update(
                "UPDATE coupon_usages SET status = 3 WHERE status = 1 AND is_deleted = 0 AND expires_at < NOW()");
            log.info("[CouponExpireJob] 过期处理: " + n + " 张优惠券");
        } catch (Exception e) {
            log.error("[CouponExpireJob] 执行异常", e);
        }
        log.info("[CouponExpireJob] 执行完毕");
    }
}
