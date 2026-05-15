package com.shopoperate.system.job;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.shopoperate.trade.TradeService;
import org.apache.log4j.Logger;
import org.quartz.Job;
import org.quartz.JobExecutionContext;

import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.Date;
import java.util.List;

/**
 * 日报生成 — 每日 23:59
 * 汇总当日各店铺经营数据写入 daily_snapshots
 */
public class DailySnapshotJob implements Job {
    private static final Logger log = Logger.getLogger(DailySnapshotJob.class);

    @Override
    public void execute(JobExecutionContext context) {
        log.info("[DailySnapshotJob] 开始执行...");
        try {
            List<Record> shops = Db.find("SELECT id FROM shops WHERE is_deleted = 0");
            for (Record shop : shops) {
                BigInteger sid = shop.getBigInteger("id");

                // 今日销售额
                BigDecimal salesTotal = Db.queryBigDecimal(
                    "SELECT COALESCE(SUM(paid_amount),0) FROM purchases WHERE shop_id=? AND DATE(created_at)=CURDATE() AND is_deleted=0", sid);
                // 今日确认收入
                BigDecimal revenueConfirmed = Db.queryBigDecimal(
                    "SELECT COALESCE(SUM(amount),0) FROM revenue_records WHERE shop_id=? AND DATE(confirmed_at)=CURDATE()", sid);
                // 今日支出
                BigDecimal expenseTotal = Db.queryBigDecimal(
                    "SELECT COALESCE(SUM(amount),0) FROM expenses WHERE shop_id=? AND expense_date=CURDATE()", sid);
                // 今日新顾客
                Long newCustomers = Db.queryLong(
                    "SELECT COUNT(*) FROM customers WHERE shop_id=? AND DATE(created_at)=CURDATE()", sid);
                // 今日活跃游玩
                Long activeSessions = Db.queryLong(
                    "SELECT COUNT(*) FROM game_sessions WHERE shop_id=? AND DATE(created_at)=CURDATE()", sid);
                // 平均游玩时长（分钟）
                Long avgDuration = Db.queryLong(
                    "SELECT COALESCE(ROUND(AVG(TIMESTAMPDIFF(MINUTE,start_time,end_time))),0) " +
                    "FROM game_sessions WHERE shop_id=? AND DATE(created_at)=CURDATE() AND end_time IS NOT NULL", sid);
                // 今日最热套餐
                Record topPkg = Db.findFirst(
                    "SELECT package_id FROM purchases WHERE shop_id=? AND DATE(created_at)=CURDATE() AND is_deleted=0 " +
                    "GROUP BY package_id ORDER BY COUNT(*) DESC LIMIT 1", sid);
                // 库存预警
                List<Record> warns = Db.find(
                    "SELECT m.name, m.sku, i.quantity, m.min_stock FROM inventory i " +
                    "INNER JOIN materials m ON i.material_id = m.id " +
                    "WHERE i.shop_id=? AND i.quantity <= m.min_stock AND m.is_deleted=0", sid);
                StringBuilder warnJson = new StringBuilder("[");
                for (int i = 0; i < warns.size(); i++) {
                    if (i > 0) warnJson.append(",");
                    warnJson.append("{\"name\":\"").append(warns.get(i).getStr("name"))
                        .append("\",\"sku\":\"").append(warns.get(i).getStr("sku"))
                        .append("\",\"quantity\":").append(warns.get(i).getBigDecimal("quantity"))
                        .append(",\"minStock\":").append(warns.get(i).getBigDecimal("min_stock"))
                        .append("}");
                }
                warnJson.append("]");

                Record snap = new Record()
                    .set("shop_id", sid)
                    .set("snapshot_date", new Date())
                    .set("sales_total", salesTotal)
                    .set("revenue_confirmed", revenueConfirmed)
                    .set("expense_total", expenseTotal)
                    .set("new_customers", newCustomers.intValue())
                    .set("active_sessions", activeSessions.intValue())
                    .set("average_duration", avgDuration.intValue())
                    .set("inventory_warns", warns.isEmpty() ? null : warnJson.toString())
                    .set("created_at", new Date());
                if (topPkg != null) snap.set("top_package_id", topPkg.getBigInteger("package_id"));
                Db.save("daily_snapshots", snap);
            }
            log.info("[DailySnapshotJob] 快照生成完毕: " + shops.size() + " 个店铺");

            // 打烊兜底：结束所有进行中的游玩场次
            List<Record> openSessions = Db.find("SELECT id FROM game_sessions WHERE status = 1");
            int closed = 0;
            for (Record gs : openSessions) {
                if (TradeService.me.finish(gs.getBigInteger("id"), null)) closed++;
            }
            if (closed > 0) log.info("[DailySnapshotJob] 打烊兜底结束: " + closed + "/" + openSessions.size());
        } catch (Exception e) {
            log.error("[DailySnapshotJob] 执行异常", e);
        }
        log.info("[DailySnapshotJob] 执行完毕");
    }
}
