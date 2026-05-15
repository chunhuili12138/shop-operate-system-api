package com.shopoperate.system;

import com.shopoperate.system.job.*;
import org.apache.log4j.Logger;
import org.quartz.*;
import org.quartz.impl.StdSchedulerFactory;

import static org.quartz.CronScheduleBuilder.cronSchedule;
import static org.quartz.JobBuilder.newJob;
import static org.quartz.TriggerBuilder.newTrigger;

/**
 * 定时任务管理器（基于 Quartz）
 * 管理 6 个定时任务：席位到期提醒/冻结、日报、库存预警、优惠券过期、session 过期
 */
public class ScheduleTaskManager {
    private static final Logger log = Logger.getLogger(ScheduleTaskManager.class);
    private static final ScheduleTaskManager me = new ScheduleTaskManager();
    private Scheduler scheduler;

    public static ScheduleTaskManager me() {
        return me;
    }

    public void start() {
        try {
            scheduler = StdSchedulerFactory.getDefaultScheduler();

            // 1. 席位到期提醒 — 每日 08:00
            scheduleJob("seatExpireRemind", SeatExpireRemindJob.class, "0 0 8 * * ?");

            // 2. 席位到期冻结 — 每日 00:00
            scheduleJob("seatExpireFreeze", SeatExpireFreezeJob.class, "0 0 0 * * ?");

            // 3. 日报生成 — 每日 23:59
            scheduleJob("dailySnapshot", DailySnapshotJob.class, "0 59 23 * * ?");

            // 4. 库存预警 — 每日 10:00
            scheduleJob("inventoryAlert", InventoryAlertJob.class, "0 0 8 * * ?");

            // 5. 优惠券过期 — 每日 00:00
            scheduleJob("couponExpire", CouponExpireJob.class, "0 0 0 * * ?");

            // 6. 顾客 session 过期 — 每日 00:00
            scheduleJob("sessionExpire", SessionExpireJob.class, "0 0 0 * * ?");

            // 7. 游玩超时监控 — 每 5 分钟（自动结束超时4h + 时长提醒）
            scheduleJob("gameSessionMonitor", GameSessionMonitorJob.class, "0 */5 * * * ?");

            scheduler.start();
            log.info("=========== 定时任务已启动（Quartz, 7 个 Job） ===========");
            System.out.println("=========== 定时任务已启动（Quartz, 7 个 Job） ===========");
        } catch (Exception e) {
            log.error("定时任务启动失败", e);
            System.err.println("定时任务启动失败: " + e.getMessage());
        }
    }

    public void stop() {
        try {
            if (scheduler != null && !scheduler.isShutdown()) {
                scheduler.shutdown();
                log.info("=========== 定时任务已停止 ===========");
                System.out.println("=========== 定时任务已停止 ===========");
            }
        } catch (Exception e) {
            log.error("定时任务停止异常", e);
        }
    }

    private void scheduleJob(String name, Class<? extends Job> jobClass, String cron) throws SchedulerException {
        JobDetail detail = newJob(jobClass)
            .withIdentity(name + "Job", "shopOperate")
            .build();
        Trigger trigger = newTrigger()
            .withIdentity(name + "Trigger", "shopOperate")
            .withSchedule(cronSchedule(cron))
            .build();
        scheduler.scheduleJob(detail, trigger);
        log.info("  注册任务: " + name + " (cron: " + cron + ")");
    }
}
