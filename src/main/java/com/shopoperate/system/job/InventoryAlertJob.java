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
 * 库存预警 — 每日 8:00
 * 检查库存低于最低库存预警线的物料，推送站内信给店长/仓管
 */
public class InventoryAlertJob implements Job {
    private static final Logger log = Logger.getLogger(InventoryAlertJob.class);

    @Override
    public void execute(JobExecutionContext context) {
        log.info("[InventoryAlertJob] 开始执行...");
        try {
            List<Record> alerts = Db.find(
                "SELECT i.shop_id, m.name, m.sku, i.quantity, m.min_stock FROM inventory i " +
                "INNER JOIN materials m ON i.material_id = m.id " +
                "WHERE i.quantity <= m.min_stock AND m.is_deleted = 0");
            if (alerts.isEmpty()) {
                log.info("[InventoryAlertJob] 无库存预警");
                return;
            }
            for (Record a : alerts) {
                BigInteger sid = a.getBigInteger("shop_id");
                String title = "库存预警";
                String content = "物料【" + a.getStr("name") + "】（" + a.getStr("sku") +
                    "）库存不足，当前库存 " + a.getBigDecimal("quantity") +
                    "，最低预警线 " + a.getBigDecimal("min_stock") + "。请及时采购。";

                // 通知该店铺下拥有仓管(role_id=5)或店长(role_id=3)角色的员工
                List<Record> staffList = Db.find(
                    "SELECT DISTINCT s.id FROM staff s " +
                    "INNER JOIN staff_shops ss ON s.id = ss.staff_id " +
                    "INNER JOIN staff_roles sr ON s.id = sr.staff_id " +
                    "WHERE ss.shop_id = ? AND sr.role_id IN (3,5) AND s.status = 1 AND s.is_deleted = 0", sid);
                // 补充店铺老板
                Record owner = Db.findFirst(
                    "SELECT s.id FROM staff s INNER JOIN staff_roles sr ON s.id=sr.staff_id " +
                    "INNER JOIN shops sh ON sh.owner_staff_id=s.id " +
                    "WHERE sh.id=? AND sr.role_id IN (3,5) AND s.status=1 AND s.is_deleted=0", sid);
                if (owner != null) {
                    boolean found = false;
                    for (Record r : staffList) { if (r.getBigInteger("id").equals(owner.getBigInteger("id"))) { found = true; break; } }
                    if (!found) staffList.add(owner);
                }
                for (Record staff : staffList) {
                    Record notif = new Record()
                        .set("shop_id", sid)
                        .set("recipient_type", 2)
                        .set("recipient_id", staff.getBigInteger("id"))
                        .set("channel", 3)
                        .set("title", title)
                        .set("content", content)
                        .set("status", 1)
                        .set("created_at", new Date());
                    Db.save("notification_logs", notif);
                }
            }
            log.info("[InventoryAlertJob] 预警物料: " + alerts.size() + " 条");
        } catch (Exception e) {
            log.error("[InventoryAlertJob] 执行异常", e);
        }
        log.info("[InventoryAlertJob] 执行完毕");
    }
}
