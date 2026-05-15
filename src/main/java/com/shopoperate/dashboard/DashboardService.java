package com.shopoperate.dashboard;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;

import java.math.BigDecimal;
import java.util.List;

public class DashboardService {

    public static final DashboardService me = new DashboardService();

    /** 获取超管平台概览数据 */
    public Record getPlatformDashboard() {
        Record data = new Record();
        Record overview = buildOverview();
        data.set("overview", overview.getColumns());
        data.set("expiring", buildExpiringSeats());
        data.set("trends", buildTrends());
        data.set("distribution", buildDistribution());
        data.set("topTenants", buildTopTenants());
        return data;
    }

    /** 平台核心统计卡片 */
    private Record buildOverview() {
        Record r = new Record();
        // 商户
        r.set("totalTenants", Db.queryLong("SELECT COUNT(*) FROM staff WHERE boss_status=1 AND is_deleted=0"));
        r.set("activeTenants", Db.queryLong("SELECT COUNT(*) FROM staff WHERE boss_status=1 AND is_deleted=0 AND is_ban=0 AND status=1"));
        r.set("bannedTenants", Db.queryLong("SELECT COUNT(*) FROM staff WHERE boss_status=1 AND is_deleted=0 AND is_ban=1"));
        r.set("newTenantsThisMonth", Db.queryLong("SELECT COUNT(*) FROM staff WHERE boss_status=1 AND is_deleted=0 AND created_at >= DATE_FORMAT(CURDATE(),'%Y-%m-01')"));
        // 店铺
        r.set("totalShops", Db.queryLong("SELECT COUNT(*) FROM shops WHERE is_deleted=0"));
        r.set("activeShops", Db.queryLong("SELECT COUNT(*) FROM shops WHERE is_deleted=0 AND status=1"));
        r.set("newShopsThisMonth", Db.queryLong("SELECT COUNT(*) FROM shops WHERE is_deleted=0 AND created_at >= DATE_FORMAT(CURDATE(),'%Y-%m-01')"));
        // 席位
        r.set("activeSeats", Db.queryLong("SELECT COUNT(*) FROM seat_subscriptions WHERE status=1"));
        r.set("expiredSeats", Db.queryLong("SELECT COUNT(*) FROM seat_subscriptions WHERE status=2"));
        // 收入
        r.set("totalRevenue", Db.queryBigDecimal("SELECT COALESCE(SUM(amount),0) FROM seat_subscriptions_transactions WHERE status=1"));
        r.set("revenueThisMonth", Db.queryBigDecimal("SELECT COALESCE(SUM(amount),0) FROM seat_subscriptions_transactions WHERE status=1 AND created_at >= DATE_FORMAT(CURDATE(),'%Y-%m-01')"));
        r.set("revenueThisYear", Db.queryBigDecimal("SELECT COALESCE(SUM(amount),0) FROM seat_subscriptions_transactions WHERE status=1 AND YEAR(created_at)=YEAR(CURDATE())"));
        // 退款
        r.set("totalRefund", Db.queryBigDecimal("SELECT COALESCE(SUM(refund_amount),0) FROM seat_subscriptions_transactions WHERE status=2"));
        r.set("refundThisMonth", Db.queryBigDecimal("SELECT COALESCE(SUM(refund_amount),0) FROM seat_subscriptions_transactions WHERE status=2 AND created_at >= DATE_FORMAT(CURDATE(),'%Y-%m-01')"));
        // 席位使用率
        Long usedSeats = Db.queryLong("SELECT COALESCE(SUM(used_seats),0) FROM staff WHERE boss_status=1 AND is_deleted=0");
        Long maxSeats = Db.queryLong("SELECT COALESCE(SUM(max_seats),0) FROM staff WHERE boss_status=1 AND is_deleted=0");
        r.set("seatUtilization", maxSeats > 0 ? new BigDecimal(usedSeats).divide(new BigDecimal(maxSeats), 4, BigDecimal.ROUND_HALF_UP) : BigDecimal.ZERO);
        r.set("tenantsWithoutShops", Db.queryLong("SELECT COUNT(*) FROM staff WHERE boss_status=1 AND is_deleted=0 AND used_seats=0"));
        // 顾客
        r.set("totalCustomers", Db.queryLong("SELECT COUNT(*) FROM customers"));
        return r;
    }

    /** 席位到期统计 */
    private Record buildExpiringSeats() {
        Record r = new Record();
        r.set("within7Days", Db.queryLong("SELECT COUNT(*) FROM seat_subscriptions WHERE status=1 AND end_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 7 DAY)"));
        r.set("within30Days", Db.queryLong("SELECT COUNT(*) FROM seat_subscriptions WHERE status=1 AND end_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 30 DAY)"));
        r.set("within60Days", Db.queryLong("SELECT COUNT(*) FROM seat_subscriptions WHERE status=1 AND end_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 60 DAY)"));
        r.set("list", Db.find(
            "SELECT ss.id, ss.end_date, DATEDIFF(ss.end_date, CURDATE()) AS remaining_days, " +
            "st.name AS tenant_name, st.id AS tenant_id " +
            "FROM seat_subscriptions ss INNER JOIN staff st ON ss.staff_id=st.id " +
            "WHERE ss.status=1 AND ss.end_date <= DATE_ADD(CURDATE(), INTERVAL 60 DAY) " +
            "ORDER BY ss.end_date"));
        return r;
    }

    /** 趋势数据（近12个月） */
    private Record buildTrends() {
        Record r = new Record();
        String dateFmt = "%Y-%m";
        r.set("revenue", Db.find(
            "SELECT DATE_FORMAT(created_at,'" + dateFmt + "') AS period, COALESCE(SUM(amount),0) AS total " +
            "FROM seat_subscriptions_transactions WHERE status=1 " +
            "AND created_at >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH) " +
            "GROUP BY period ORDER BY period"));
        r.set("tenants", Db.find(
            "SELECT DATE_FORMAT(created_at,'" + dateFmt + "') AS period, COUNT(*) AS count " +
            "FROM staff WHERE boss_status=1 AND is_deleted=0 " +
            "AND created_at >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH) " +
            "GROUP BY period ORDER BY period"));
        r.set("shops", Db.find(
            "SELECT DATE_FORMAT(created_at,'" + dateFmt + "') AS period, COUNT(*) AS count " +
            "FROM shops WHERE is_deleted=0 " +
            "AND created_at >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH) " +
            "GROUP BY period ORDER BY period"));
        return r;
    }

    /** 订阅类型分布 */
    private Record buildDistribution() {
        Record r = new Record();
        List<Record> list = Db.find(
            "SELECT subscription_type, COUNT(*) AS count, COALESCE(SUM(amount),0) AS revenue " +
            "FROM seat_subscriptions_transactions WHERE status=1 " +
            "GROUP BY subscription_type");
        long monthlyCount = 0, yearlyCount = 0;
        BigDecimal monthlyRevenue = BigDecimal.ZERO, yearlyRevenue = BigDecimal.ZERO;
        for (Record item : list) {
            int type = item.getInt("subscription_type");
            long cnt = item.getLong("count");
            BigDecimal rev = item.getBigDecimal("revenue");
            if (type == 1) { monthlyCount = cnt; monthlyRevenue = rev; }
            else if (type == 2) { yearlyCount = cnt; yearlyRevenue = rev; }
        }
        r.set("monthlyCount", monthlyCount);
        r.set("yearlyCount", yearlyCount);
        r.set("monthlyRevenue", monthlyRevenue);
        r.set("yearlyRevenue", yearlyRevenue);
        return r;
    }

    /** TOP5 商户（按订阅金额） */
    private List<Record> buildTopTenants() {
        return Db.find(
            "SELECT st.name, COALESCE(SUM(sst.amount),0) AS revenue, st.id AS tenant_id " +
            "FROM seat_subscriptions_transactions sst " +
            "INNER JOIN seat_subscriptions ss ON sst.seat_id = ss.id " +
            "INNER JOIN staff st ON ss.staff_id = st.id " +
            "WHERE sst.status = 1 AND st.boss_status = 1 " +
            "GROUP BY st.id ORDER BY revenue DESC LIMIT 5");
    }
}
