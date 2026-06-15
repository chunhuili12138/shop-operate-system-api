package com.shopoperate.common;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.shopoperate.utils.PasswordUtil;

import java.math.BigInteger;
import java.util.Date;
import java.util.List;

/**
 * 系统数据初始化器
 * 在项目启动时检查数据库基础数据是否完整，缺少则自动插入。
 * 包括：默认超管账号、角色、权限、角色-权限关联、数据字典。
 */
public class DataInitializer {

    public static void initialize() {
        System.out.println("========== DataInitializer: 检查基础数据... ==========");

        try {
            initRoles();
            initPermissions();
            initRolePermissions();
            initDicts();
            initAdminAccount();
            initArticleCategories();
            ensureNewPermissions();
            ensureRolePermissionsV2();

            System.out.println("========== DataInitializer: 基础数据检查完毕 ==========");
        } catch (Exception e) {
            System.err.println("DataInitializer 初始化异常: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // ==================== 角色 ====================

    private static void initRoles() {
        long count = Db.queryLong("SELECT COUNT(*) FROM roles");
        if (count > 0) {
            System.out.println("  [角色] 已存在 " + count + " 条，跳过");
            return;
        }

        System.out.println("  [角色] 未发现数据，开始插入 5 个预设角色...");
        Db.tx(() -> {
            insertRole(2, "超级管理员", "超级管理员（处理商户、席位订阅、全局字典等功能）");
            insertRole(3, "店长", "店长");
            insertRole(4, "导玩员", "导玩员");
            insertRole(5, "仓管", "仓管");
            insertRole(6, "财务", "财务");
            return true;
        });
        System.out.println("  [角色] 插入完成");
    }

    private static void insertRole(int id, String name, String desc) {
        Record r = new Record().set("id", id).set("shop_id", 0).set("name", name)
                .set("description", desc).set("created_at", new Date());
        Db.save("roles", r);
    }

    // ==================== 权限 ====================

    private static void initPermissions() {
        long count = Db.queryLong("SELECT COUNT(*) FROM permissions");
        if (count > 0) {
            System.out.println("  [权限] 已存在 " + count + " 条，跳过");
            ensureSuperAdminVisible();
            return;
        }

        System.out.println("  [权限] 未发现数据，开始插入权限...");
        Db.tx(() -> {
            // ---- 目录 (type=1) ----
            insertPerm(1, 0, "系统管理", "system", "/system", null, "ep/setting", 1, 1);
            insertPerm(2, 0, "商户管理", "tenant", "/tenant", null, "ep/shop", 2, 1);
            insertPerm(3, 0, "店铺管理", "shop", "/shop", null, "ep/home-filled", 3, 1);
            insertPerm(4, 0, "顾客管理", "customer", "/customer", null, "ep/user", 4, 1);
            insertPerm(5, 0, "套餐管理", "package", "/package", null, "ep/goods", 5, 1);
            insertPerm(6, 0, "交易管理", "trade", "/trade", null, "ep/chat-dot-square", 6, 1);
            insertPerm(7, 0, "库存管理", "inventory", "/inventory", null, "ep/box", 7, 1);
            insertPerm(8, 0, "营销管理", "marketing", "/marketing", null, "ep/present", 8, 1);
            insertPerm(9, 0, "财务管理", "finance", "/finance", null, "ep/coin", 9, 1);
            insertPerm(33, 0, "经营快照", "dashboard:snapshot", "/dashboard/snapshot", "/src/views/dashboard/snapshot/index.vue", "ep/data-analysis", 11, 2);

            // ---- 菜单 (type=2) ----
            insertPerm(11, 1, "员工管理", "system:staff", "/system/staff", "/src/views/system/staff/index.vue", null, 1, 2);
            insertPerm(12, 1, "角色管理", "system:role", "/system/role", "/src/views/system/role/index.vue", null, 2, 2);
            insertPerm(13, 1, "权限管理", "system:permission", "/system/permission", "/src/views/system/permission/index.vue", null, 3, 2);
            insertPerm(14, 1, "字典管理", "system:dict", "/system/dict", "/src/views/system/dict/index.vue", null, 4, 2);
            insertPerm(15, 2, "商户列表", "tenant:list", "/tenant/list", "/src/views/tenant/list/index.vue", null, 1, 2);
            insertPerm(16, 2, "席位管理", "tenant:seat", "/tenant/seat", "/src/views/tenant/seat/index.vue", null, 2, 2);
            insertPerm(17, 3, "店铺列表", "shop:list", "/shop/list", "/src/views/shop/list/index.vue", null, 1, 2);
            insertPerm(18, 4, "顾客列表", "customer:list", "/customer/list", "/src/views/customer/list/index.vue", null, 1, 2);
            insertPerm(19, 5, "套餐列表", "package:list", "/package/list", "/src/views/package/list/index.vue", null, 1, 2);
            insertPerm(20, 6, "购买记录", "trade:purchase", "/trade/purchase", "/src/views/trade/purchase/index.vue", null, 1, 2);
            insertPerm(21, 6, "核销管理", "trade:checkin", "/trade/checkin", "/src/views/trade/checkin/index.vue", null, 2, 2);
            insertPerm(22, 6, "退款管理", "trade:refund", "/trade/refund", "/src/views/trade/refund/index.vue", null, 3, 2);
            insertPerm(23, 7, "物料管理", "inventory:material", "/inventory/material", "/src/views/inventory/material/index.vue", null, 1, 2);
            insertPerm(24, 7, "库存查询", "inventory:list", "/inventory/list", "/src/views/inventory/list/index.vue", null, 2, 2);
            insertPerm(25, 7, "采购管理", "inventory:purchase", "/inventory/purchase", "/src/views/inventory/purchase/index.vue", null, 3, 2);
            insertPerm(26, 8, "优惠券管理", "marketing:coupon", "/marketing/coupon", "/src/views/marketing/coupon/index.vue", null, 1, 2);
            insertPerm(27, 8, "文章管理", "marketing:article", "/marketing/article", "/src/views/marketing/article/index.vue", null, 2, 2);
            insertPerm(28, 9, "收入管理", "finance:revenue", "/finance/revenue", "/src/views/finance/revenue/index.vue", null, 1, 2);
            insertPerm(29, 9, "支出管理", "finance:expense", "/finance/expense", "/src/views/finance/expense/index.vue", null, 2, 2);
            insertPerm(30, 9, "提成管理", "finance:commission", "/finance/commission", "/src/views/finance/commission/index.vue", null, 3, 2);
            insertPerm(31, 9, "发票管理", "finance:invoice", "/finance/invoice", "/src/views/finance/invoice/index.vue", null, 4, 2);
            insertPerm(34, 9, "通知管理", "finance:notification", "/finance/notification", "/src/views/finance/notification/index.vue", null, 5, 2);
            insertPerm(36, 3, "店铺信息", "shop:my", "/shop/my", "/src/views/shop/my/index.vue", "ep/home-filled", 2, 2);

            // ---- 按钮 (type=3) ----
            insertPerm(101, 11, "新增员工", "btn:staff:add", null, null, null, 1, 3);
            insertPerm(102, 11, "编辑员工", "btn:staff:edit", null, null, null, 2, 3);
            insertPerm(103, 11, "删除员工", "btn:staff:delete", null, null, null, 3, 3);
            insertPerm(104, 11, "重置密码", "btn:staff:password", null, null, null, 4, 3);
            insertPerm(105, 12, "新增角色", "btn:role:add", null, null, null, 1, 3);
            insertPerm(106, 12, "编辑角色", "btn:role:edit", null, null, null, 2, 3);
            insertPerm(107, 12, "设置权限", "btn:role:perms", null, null, null, 3, 3);
            insertPerm(108, 14, "新增字典", "btn:dict:add", null, null, null, 1, 3);
            insertPerm(109, 14, "编辑字典", "btn:dict:edit", null, null, null, 2, 3);
            insertPerm(110, 15, "新增商户", "btn:tenant:add", null, null, null, 1, 3);
            insertPerm(111, 15, "编辑商户", "btn:tenant:edit", null, null, null, 2, 3);
            insertPerm(112, 15, "封禁商户", "btn:tenant:ban", null, null, null, 3, 3);
            insertPerm(113, 15, "删除商户", "btn:tenant:delete", null, null, null, 4, 3);
            insertPerm(167, 15, "重置密码", "btn:tenant:password", null, null, null, 5, 3);
            insertPerm(114, 16, "新增席位", "btn:seat:add", null, null, null, 1, 3);
            insertPerm(115, 16, "续订席位", "btn:seat:renew", null, null, null, 2, 3);
            insertPerm(116, 16, "删除席位", "btn:seat:delete", null, null, null, 3, 3);
            insertPerm(117, 17, "新增店铺", "btn:shop:add", null, null, null, 1, 3);
            insertPerm(118, 17, "编辑店铺", "btn:shop:edit", null, null, null, 2, 3);
            insertPerm(119, 17, "删除店铺", "btn:shop:delete", null, null, null, 3, 3);
            insertPerm(120, 17, "营业切换", "btn:shop:status", null, null, null, 4, 3);
            insertPerm(121, 18, "新增顾客", "btn:customer:add", null, null, null, 1, 3);
            insertPerm(122, 18, "编辑顾客", "btn:customer:edit", null, null, null, 2, 3);
            insertPerm(123, 18, "钱包调整", "btn:customer:wallet", null, null, null, 3, 3);
            insertPerm(124, 18, "积分调整", "btn:customer:points", null, null, null, 4, 3);
            insertPerm(158, 18, "标签管理", "btn:customer:tag", null, null, null, 5, 3);
            insertPerm(125, 19, "新增套餐", "btn:package:add", null, null, null, 1, 3);
            insertPerm(126, 19, "编辑套餐", "btn:package:edit", null, null, null, 2, 3);
            insertPerm(127, 19, "上下架", "btn:package:status", null, null, null, 3, 3);
            insertPerm(128, 20, "新增购买", "btn:purchase:add", null, null, null, 1, 3);
            insertPerm(129, 20, "退款申请", "btn:purchase:refund", null, null, null, 2, 3);
            insertPerm(130, 21, "核销入座", "btn:checkin:add", null, null, null, 1, 3);
            insertPerm(131, 21, "结束游玩", "btn:checkin:finish", null, null, null, 2, 3);
            insertPerm(132, 22, "确认退款", "btn:refund:approve", null, null, null, 1, 3);
            insertPerm(133, 22, "拒绝退款", "btn:refund:reject", null, null, null, 2, 3);
            insertPerm(134, 23, "新增物料", "btn:material:add", null, null, null, 1, 3);
            insertPerm(135, 23, "编辑物料", "btn:material:edit", null, null, null, 2, 3);
            insertPerm(136, 23, "删除物料", "btn:material:delete", null, null, null, 3, 3);
            insertPerm(137, 24, "入库", "btn:inventory:inbound", null, null, null, 1, 3);
            insertPerm(138, 24, "出库", "btn:inventory:outbound", null, null, null, 2, 3);
            insertPerm(139, 25, "新增采购单", "btn:purchaseOrder:add", null, null, null, 1, 3);
            insertPerm(140, 25, "编辑采购单", "btn:purchaseOrder:edit", null, null, null, 2, 3);
            insertPerm(141, 26, "新增优惠券", "btn:coupon:add", null, null, null, 1, 3);
            insertPerm(142, 26, "编辑优惠券", "btn:coupon:edit", null, null, null, 2, 3);
            insertPerm(143, 26, "手动发放", "btn:coupon:grant", null, null, null, 3, 3);
            insertPerm(144, 27, "新增文章", "btn:article:add", null, null, null, 1, 3);
            insertPerm(145, 27, "编辑文章", "btn:article:edit", null, null, null, 2, 3);
            insertPerm(146, 27, "发布/下架", "btn:article:publish", null, null, null, 3, 3);
            insertPerm(147, 29, "新增支出", "btn:expense:add", null, null, null, 1, 3);
            insertPerm(148, 29, "编辑支出", "btn:expense:edit", null, null, null, 2, 3);
            insertPerm(149, 29, "删除支出", "btn:expense:delete", null, null, null, 3, 3);
            insertPerm(150, 30, "生成结算", "btn:commission:generate", null, null, null, 1, 3);
            insertPerm(151, 30, "确认发放", "btn:commission:pay", null, null, null, 2, 3);
            insertPerm(152, 27, "删除文章", "btn:article:delete", null, null, null, 4, 3);
            insertPerm(153, 14, "删除字典", "btn:dict:delete", null, null, null, 3, 3);
            insertPerm(154, 34, "发送通知", "btn:notification:send", null, null, null, 1, 3);
            insertPerm(155, 34, "标记已读", "btn:notification:read", null, null, null, 2, 3);
            insertPerm(156, 36, "编辑店铺", "btn:shop:myEdit", null, null, null, 1, 3);
            insertPerm(157, 36, "营业切换", "btn:shop:myStatus", null, null, null, 2, 3);
            return true;
        });
        ensureSuperAdminVisible();
        System.out.println("  [权限] 插入完成");
    }

    /** 确保 super_admin_visible 字段值正确（同时供新建和已有数据调用） */
    private static void ensureSuperAdminVisible() {
        String menuCodes = "'system','system:dict'," +
            "'tenant','tenant:list'," +
            "'shop','shop:list'";
        try {
            Db.update("UPDATE permissions SET super_admin_visible = 0");
            Db.update("UPDATE permissions SET super_admin_visible = 1 WHERE menu_code IN (" + menuCodes + ")");
            System.out.println("  [权限] super_admin_visible 已更新");
        } catch (Exception e) {
            try {
                com.jfinal.plugin.activerecord.Db.update("ALTER TABLE `permissions` ADD COLUMN `super_admin_visible` tinyint UNSIGNED NOT NULL DEFAULT 0 COMMENT '超管菜单可见：0-否，1-是' AFTER `is_deleted`");
                Db.update("UPDATE permissions SET super_admin_visible = 1 WHERE menu_code IN (" + menuCodes + ")");
                System.out.println("  [权限] super_admin_visible 字段已添加并更新");
            } catch (Exception e2) {
                System.out.println("  [权限] 注意: super_admin_visible 字段操作失败: " + e2.getMessage());
            }
        }
    }

    private static void insertPerm(int id, int parentId, String name, String menuCode,
                                    String path, String component, String icon, int sort, int type) {
        Record p = new Record().set("id", id).set("parent_id", parentId).set("name", name)
                .set("menu_code", menuCode).set("path", path).set("component", component)
                .set("icon", icon).set("sort", sort).set("type", type)
                .set("is_active", 1).set("is_deleted", 0).set("super_admin_visible", 0)
                .set("created_at", new Date()).set("updated_at", new Date());
        Db.save("permissions", p);
    }

    /** 增量权限初始化：新增权限项（兼容已有数据库） */
    private static void ensureNewPermissions() {
        System.out.println("  [权限] 检查增量权限...");
        // 库存查询菜单已合并到物料管理，标记删除
        Db.update("UPDATE permissions SET is_deleted=1 WHERE id=24");
        // 经营概况已合并到首页，标记删除；数据报表目录移除；经营快照提升为一级菜单
        Db.update("UPDATE permissions SET is_deleted=1 WHERE id IN (32, 10)");
        Db.update("UPDATE permissions SET parent_id=0, sort=11 WHERE id=33");
        // {id, parent_id, name, menu_code, path, component, icon, sort, type}
        String[][] newPerms = {
            {"34",  "9",  "通知管理", "finance:notification", "/finance/notification", "/src/views/finance/notification/index.vue", null, "5", "2"},
            {"36",  "3",  "店铺信息", "shop:my", "/shop/my", "/src/views/shop/my/index.vue", "ep/home-filled", "2", "2"},
            {"152", "27", "删除文章", "btn:article:delete", null, null, null, "4", "3"},
            {"153", "14", "删除字典", "btn:dict:delete",   null, null, null, "3", "3"},
            {"154", "34", "发送通知", "btn:notification:send", null, null, null, "1", "3"},
            {"155", "34", "标记已读", "btn:notification:read", null, null, null, "2", "3"},
            {"156", "36", "编辑店铺", "btn:shop:myEdit", null, null, null, "1", "3"},
            {"157", "36", "营业切换", "btn:shop:myStatus", null, null, null, "2", "3"},
            {"159", "23", "分类管理", "btn:material:category", null, null, null, "4", "3"},
            {"160",  "7", "供应商管理", "inventory:supplier", "/inventory/supplier", "/src/views/inventory/supplier/index.vue", "ep/goods", "2", "2"},
            {"161", "160", "新增供应商", "btn:supplier:add", null, null, null, "1", "3"},
            {"162", "160", "编辑供应商", "btn:supplier:edit", null, null, null, "2", "3"},
            {"163", "160", "删除供应商", "btn:supplier:delete", null, null, null, "3", "3"},
            {"164",  "19", "删除套餐", "btn:package:delete", null, null, null, "4", "3"},
            {"166",  "26", "删除优惠券", "btn:coupon:delete", null, null, null, "4", "3"},
            {"37",   "9",  "收支明细", "finance:cashflow", "/finance/cashflow", "/src/views/finance/cashflow/index.vue", "ep/money", "6", "2"},
            {"38",   "0",  "评价反馈", "feedback:list", "/feedback", "/src/views/feedback/index.vue", "ep/comment", "12", "2"},
        };

        for (String[] p : newPerms) {
            long exists = Db.queryLong("SELECT COUNT(*) FROM permissions WHERE menu_code = ?", p[3]);
            if (exists == 0) {
                Record r = new Record()
                    .set("id", Integer.parseInt(p[0]))
                    .set("parent_id", Integer.parseInt(p[1]))
                    .set("name", p[2])
                    .set("menu_code", p[3])
                    .set("path", p[4])
                    .set("component", p[5])
                    .set("icon", p[6])
                    .set("sort", Integer.parseInt(p[7]))
                    .set("type", Integer.parseInt(p[8]))
                    .set("is_active", 1)
                    .set("is_deleted", 0)
                    .set("super_admin_visible", 0)
                    .set("created_at", new Date())
                    .set("updated_at", new Date());
                Db.save("permissions", r);
                int pid = r.getInt("id");
                Db.save("role_permissions", new Record().set("role_id", 2).set("permission_id", pid));
                // 按钮权限同步赋予店长(3)和仓管(5)
                if (pid == 159 || pid == 160 || pid == 161 || pid == 162 || pid == 163 || pid == 164) {
                    Db.save("role_permissions", new Record().set("role_id", 3).set("permission_id", pid));
                    Db.save("role_permissions", new Record().set("role_id", 5).set("permission_id", pid));
                }
                // 收支明细菜单赋予店长(3)和财务(6)
                if (pid == 37) {
                    Db.save("role_permissions", new Record().set("role_id", 3).set("permission_id", pid));
                    Db.save("role_permissions", new Record().set("role_id", 6).set("permission_id", pid));
                }
                // 评价反馈菜单赋予店长(3)和导玩员(4)
                if (pid == 38) {
                    Db.save("role_permissions", new Record().set("role_id", 3).set("permission_id", pid));
                    Db.save("role_permissions", new Record().set("role_id", 4).set("permission_id", pid));
                }
                // 删除优惠券按钮赋予店长(3)
                if (pid == 166) {
                    Db.save("role_permissions", new Record().set("role_id", 3).set("permission_id", pid));
                }
                System.out.println("    + 新增权限: " + p[2] + " (" + p[3] + ")");
            }
        }
    }

    /** 角色权限迁移：已有数据库的店长权限调整（删旧增新，幂等） */
    private static void ensureRolePermissionsV2() {
        System.out.println("  [角色-权限] 检查店长(role_id=3)权限是否需要迁移...");

        // 1. 删除店长不应有的旧权限（店铺列表 + 新增/删除按钮 + 旧按钮父ID不匹配）
        int[] removeIds = {17, 117, 118, 119, 120};
        for (int pid : removeIds) {
            long exists = Db.queryLong(
                "SELECT COUNT(*) FROM role_permissions WHERE role_id = 3 AND permission_id = ?", pid);
            if (exists > 0) {
                Db.update("DELETE FROM role_permissions WHERE role_id = 3 AND permission_id = ?", pid);
                System.out.println("    - 移除店长旧权限 permission_id=" + pid);
            }
        }

        // 2. 为店长添加新权限（店铺信息菜单 + 对应按钮）
        int[] addIds = {36, 156, 157};
        for (int pid : addIds) {
            long permExists = Db.queryLong("SELECT COUNT(*) FROM permissions WHERE id = ?", pid);
            if (permExists == 0) continue;
            long has = Db.queryLong(
                "SELECT COUNT(*) FROM role_permissions WHERE role_id = 3 AND permission_id = ?", pid);
            if (has == 0) {
                Record rp = new Record().set("role_id", 3).set("permission_id", pid);
                Db.save("role_permissions", rp);
                System.out.println("    + 为店长添加新权限 permission_id=" + pid);
            }
        }
        System.out.println("    店长权限迁移检查完毕");
    }

    // ==================== 角色-权限关联 ====================

    private static void initRolePermissions() {
        long superAdminCount = Db.queryLong("SELECT COUNT(*) FROM role_permissions WHERE role_id = 2");
        if (superAdminCount == 0) {
            System.out.println("  [角色-权限] 为超管(role_id=2)赋予全部权限...");
            Db.tx(() -> {
                List<Record> allPerms = Db.find("SELECT id FROM permissions WHERE is_deleted = 0");
                for (Record perm : allPerms) {
                    Record rp = new Record().set("role_id", 2).set("permission_id", perm.getInt("id"));
                    Db.save("role_permissions", rp);
                }
                return true;
            });
            System.out.println("  [角色-权限] 超管权限已赋予");
        } else {
            System.out.println("  [角色-权限] 超管已有 " + superAdminCount + " 条权限，跳过");
        }

        // 店长 (role_id=3): 全部店铺功能权限（不含超管专属的店铺列表/新增/删除）
        initRolePermsIfEmpty(3, "店长", new int[]{
            1, 3, 4, 5, 6, 7, 8, 9, 10,
            11,
            36,              // 店铺信息（替代店铺列表，仅查看/编辑当前店铺）
            18, 19,
            20, 21, 22,
            23, 24, 25,
            26, 27,
            28, 29, 30, 31,
            33, 37, 38,
            34,
            101,102,103,104, 156,157, 121,122,123,124,158,
            125,126,127, 128,129, 130,131, 132,133,
            134,135,136, 137,138, 139,140,
            141,142,143, 144,145,146,152,
            147,148,149, 150,151, 154,155, 108,109,153, 166,
        });

        initRolePermsIfEmpty(4, "导玩员", new int[]{
            4, 6, 8, 10, 38,
            18, 20, 21, 27,
            121,122,123,124, 128,129, 130,131,
            144,145,146,152,
        });

        initRolePermsIfEmpty(5, "仓管", new int[]{
            7, 10, 23, 24, 25,
            34, 154, 155,
            134,135,136, 137,138, 139,140,
        });

        initRolePermsIfEmpty(6, "财务", new int[]{
            6, 9, 10, 22, 28, 29, 30, 31, 33, 37,
            132,133, 147,148,149, 150,151,
        });
    }

    private static void initRolePermsIfEmpty(int roleId, String roleName, int[] permIds) {
        long count = Db.queryLong("SELECT COUNT(*) FROM role_permissions WHERE role_id = ?", roleId);
        if (count > 0) {
            System.out.println("  [角色-权限] " + roleName + "(role_id=" + roleId + ") 已有 " + count + " 条权限，跳过");
            return;
        }
        System.out.println("  [角色-权限] 为" + roleName + "(role_id=" + roleId + ")赋予 " + permIds.length + " 条权限...");
        Db.tx(() -> {
            for (int permId : permIds) {
                Record rp = new Record().set("role_id", roleId).set("permission_id", permId);
                Db.save("role_permissions", rp);
            }
            return true;
        });
    }

    // ==================== 数据字典 ====================

    private static void initDicts() {
        long count = Db.queryLong("SELECT COUNT(*) FROM sys_dicts");
        if (count > 0) {
            System.out.println("  [数据字典] 已存在 " + count + " 条，跳过");
            return;
        }

        System.out.println("  [数据字典] 未发现数据，开始插入字典...");
        Db.tx(() -> {
            insertDict("package_type", 1, "单次", "SINGLE", 1);
            insertDict("package_type", 2, "周卡", "WEEKLY", 2);
            insertDict("package_type", 3, "月卡", "MONTHLY", 3);
            insertDict("material_type", 1, "消耗品", "CONSUMABLE", 1);
            insertDict("material_type", 2, "工具", "TOOL", 2);
            insertDict("order_status", 1, "有效", "VALID", 1);
            insertDict("order_status", 2, "已退款", "REFUNDED", 2);
            insertDict("order_status", 3, "已过期", "EXPIRED", 3);
            insertDict("session_status", 1, "可用", "AVAILABLE", 1);
            insertDict("session_status", 2, "已核销", "USED", 2);
            insertDict("session_status", 3, "已过期", "EXPIRED", 3);
            insertDict("session_status", 4, "已退款", "REFUNDED", 4);
            insertDict("game_status", 1, "进行中", "ACTIVE", 1);
            insertDict("game_status", 2, "已完成", "COMPLETED", 2);
            insertDict("game_status", 3, "已取消", "CANCELLED", 3);
            insertDict("inv_trans_type", 1, "入库", "INBOUND", 1);
            insertDict("inv_trans_type", 2, "出库", "OUTBOUND", 2);
            insertDict("po_type", 1, "现结", "CASH", 1);
            insertDict("po_type", 2, "赊账", "CREDIT", 2);
            insertDict("po_status", 1, "进行中", "PENDING", 1);
            insertDict("po_status", 2, "已完成", "COMPLETED", 2);
            insertDict("po_status", 3, "已取消", "CANCELLED", 3);
            insertDict("staff_employment", 1, "全职", "FULL_TIME", 1);
            insertDict("staff_employment", 2, "兼职", "PART_TIME", 2);
            insertDict("attendance_status", 1, "正常", "NORMAL", 1);
            insertDict("attendance_status", 2, "迟到", "LATE", 2);
            insertDict("attendance_status", 3, "早退", "EARLY", 3);
            insertDict("attendance_status", 4, "加班", "OVERTIME", 4);
            insertDict("article_type", 1, "图片", "IMAGE", 1);
            insertDict("article_type", 2, "视频", "VIDEO", 2);
            insertDict("article_type", 3, "富文本", "RICHTEXT", 3);
            insertDict("log_operator_type", 1, "员工", "STAFF", 1);
            insertDict("log_operator_type", 2, "顾客", "CUSTOMER", 2);
            insertDict("coupon_verify_op", 1, "注册", "REGISTER", 1);
            insertDict("coupon_verify_op", 2, "核销", "CHECK", 2);
            insertDict("coupon_verify_op", 3, "同步", "SYNC", 3);
            insertDict("coupon_verify_result", 1, "成功", "SUCCESS", 1);
            insertDict("coupon_verify_result", 2, "失败", "FAIL", 2);
            insertDict("coupon_verify_result", 3, "无效码", "INVALID_CODE", 3);
            insertDict("coupon_verify_result", 4, "重复", "DUPLICATE", 4);
            insertDict("coupon_verify_result", 5, "已过期", "EXPIRED", 5);
            insertDict("refund_status", 1, "处理中", "PENDING", 1);
            insertDict("refund_status", 2, "已完成", "COMPLETED", 2);
            insertDict("refund_status", 3, "已拒绝", "REJECTED", 3);
            insertDict("wallet_tx_type", 1, "充值", "RECHARGE", 1);
            insertDict("wallet_tx_type", 2, "消费", "CONSUMPTION", 2);
            insertDict("wallet_tx_type", 3, "退款", "REFUND", 3);
            insertDict("wallet_tx_type", 4, "调整", "ADJUSTMENT", 4);
            insertDict("points_type", 1, "获取", "EARN", 1);
            insertDict("points_type", 2, "消耗", "REDEEM", 2);
            insertDict("points_type", 3, "过期", "EXPIRE", 3);
            insertDict("points_type", 4, "调整", "ADJUSTMENT", 4);
            insertDict("coupon_type", 1, "固定金额", "FIXED", 1);
            insertDict("coupon_type", 2, "百分比", "PERCENT", 2);
            insertDict("coupon_type", 3, "兑换券", "EXCHANGE", 3);
            insertDict("coupon_use_scene", 1, "购买套餐", "purchase", 1);
            insertDict("coupon_use_scene", 2, "充值", "recharge", 2);
            insertDict("coupon_usage_status", 1, "未使用", "UNUSED", 1);
            insertDict("coupon_usage_status", 2, "已使用", "USED", 2);
            insertDict("coupon_usage_status", 3, "已过期", "EXPIRED", 3);
            insertDict("queue_status", 1, "排队中", "WAITING", 1);
            insertDict("queue_status", 2, "已入座", "SEATED", 2);
            insertDict("queue_status", 3, "已取消", "CANCELLED", 3);
            insertDict("queue_status", 4, "已通知", "NOTIFIED", 4);
            insertDict("schedule_type", 1, "上班", "WORK", 1);
            insertDict("schedule_type", 2, "休息", "OFF", 2);
            insertDict("commission_rule_type", 1, "按次", "PER_SESSION", 1);
            insertDict("commission_rule_type", 2, "按流水比例", "REVENUE_PERCENT", 2);
            insertDict("commission_rule_type", 3, "固定金额", "FIXED", 3);
            insertDict("settlement_status", 1, "待结算", "PENDING", 1);
            insertDict("settlement_status", 2, "已发放", "PAID", 2);
            insertDict("notify_recipient_type", 1, "顾客", "CUSTOMER", 1);
            insertDict("notify_recipient_type", 2, "员工", "STAFF", 2);
            insertDict("notify_channel", 1, "微信模板消息", "WECHAT_TEMPLATE", 1);
            insertDict("notify_channel", 2, "短信", "SMS", 2);
            insertDict("notify_channel", 3, "站内信", "IN_APP", 3);
            insertDict("notify_status", 1, "待发送", "PENDING", 1);
            insertDict("notify_status", 2, "已发送", "SENT", 2);
            insertDict("notify_status", 3, "发送失败", "FAILED", 3);
            insertDict("merchant_status", 1, "正常", "NORMAL", 1);
            insertDict("merchant_status", 2, "已过期", "EXPIRED", 2);
            insertDict("merchant_status", 3, "已禁用", "DISABLED", 3);
            insertDict("subscription_type", 1, "月付", "MONTHLY", 1);
            insertDict("subscription_type", 2, "年付", "YEARLY", 2);
            insertDict("subscription_status", 1, "生效中", "ACTIVE", 1);
            insertDict("subscription_status", 2, "已过期", "EXPIRED", 2);
            insertDict("subscription_status", 3, "已退款", "REFUNDED", 3);
            insertDict("feedback_type", 1, "满意度", "SATISFACTION", 1);
            insertDict("feedback_type", 2, "建议", "SUGGESTION", 2);
            insertDict("feedback_type", 3, "投诉", "COMPLAINT", 3);
            insertDict("feedback_type", 4, "其他", "OTHER", 4);
            insertDict("feedback_status", 1, "待处理", "PENDING", 1);
            insertDict("feedback_status", 2, "已回复", "REPLIED", 2);
            insertDict("feedback_status", 3, "已关闭", "CLOSED", 3);
            insertDict("payment_method", 1, "微信支付", "wechat", 1);
            insertDict("payment_method", 2, "支付宝", "alipay", 2);
            insertDict("payment_method", 3, "银行转账", "bank", 3);
            insertDict("payment_method", 4, "现金", "cash", 4);
            insertDict("payment_method", 5, "其他", "other", 5);
            insertDict("payment_method", 6, "储值钱包", "wallet", 6);
            insertDict("customer_source", 1, "小程序", "miniapp", 1);
            insertDict("customer_source", 2, "美团", "meituan", 2);
            insertDict("customer_source", 3, "抖音", "douyin", 3);
            insertDict("customer_source", 4, "线下", "offline", 4);
            insertDict("customer_tag", 1, "VIP", "vip", 1);
            insertDict("customer_tag", 2, "常客", "regular", 2);
            insertDict("customer_tag", 3, "亲子", "family", 3);
            insertDict("customer_tag", 4, "新客", "new", 4);
            insertDict("customer_tag", 5, "大客户", "big", 5);
            insertDict("customer_tag", 6, "投诉", "complaint", 6);
            insertDict("material_category", 1, "手工材料", "handcraft", 1);
            insertDict("material_category", 2, "绘画用品", "painting", 2);
            insertDict("material_category", 3, "工具配件", "tool_part", 3);
            insertDict("material_category", 4, "包装材料", "packaging", 4);
            insertDict("material_category", 5, "清洁用品", "cleaning", 5);
            insertDict("material_category", 6, "其他", "other", 6);
            insertDict("purchase_channel", 1, "门店", "store", 1);
            insertDict("purchase_channel", 2, "美团", "meituan", 2);
            insertDict("purchase_channel", 3, "抖音", "douyin", 3);
            insertDict("purchase_channel", 4, "小程序", "miniapp", 4);
            insertDict("payment_type", 1, "直接付款", "direct", 1);
            insertDict("payment_type", 2, "储值钱包", "wallet", 2);
            insertDict("payment_type", 3, "第三方券码", "coupon", 3);
            // FAQ分类
            insertDict("faq_category", 1, "通用问题", "general", 1);
            insertDict("faq_category", 2, "价格套餐", "pricing", 2);
            insertDict("faq_category", 3, "退款政策", "refund", 3);
            insertDict("faq_category", 4, "店铺规则", "rules", 4);
            insertDict("faq_category", 5, "营业时间", "hours", 5);
            return true;
        });
        System.out.println("  [数据字典] 插入完成");
    }

    private static void insertDict(String dictCode, int key, String value, String label, int sort) {
        Record d = new Record().set("dict_code", dictCode).set("dict_key", key)
                .set("dict_value", value).set("dict_label", label)
                .set("sort", sort).set("is_active", 1).set("shop_id", 0)
                .set("created_at", new Date()).set("updated_at", new Date());
        Db.save("sys_dicts", d);
    }

    // ==================== 文章分类 ====================

    private static void initArticleCategories() {
        long count = Db.queryLong("SELECT COUNT(*) FROM article_categories WHERE shop_id=0 AND is_deleted=0");
        if (count > 0) {
            System.out.println("  [文章分类] 系统分类已存在 " + count + " 条，跳过");
            return;
        }

        System.out.println("  [文章分类] 未发现系统分类，开始插入...");
        String[][] categories = {
            {"活动通知", "1"},
            {"新品推荐", "2"},
            {"使用教程", "3"},
            {"优惠促销", "4"},
            {"门店动态", "5"},
            {"其他", "6"}
        };
        Date now = new Date();
        for (String[] cat : categories) {
            Record r = new Record().set("shop_id", BigInteger.ZERO).set("name", cat[0])
                    .set("sort", Long.parseLong(cat[1])).set("is_deleted", 0)
                    .set("created_at", now);
            Db.save("article_categories", r);
        }
        System.out.println("  [文章分类] 系统分类插入完成 (" + categories.length + " 条)");
    }

    // ==================== 超管账号 ====================

    private static void initAdminAccount() {
        long count = Db.queryLong("SELECT COUNT(*) FROM staff_accounts WHERE is_deleted = 0");
        if (count > 0) {
            System.out.println("  [超管账号] 已存在 " + count + " 个账号，跳过");
            return;
        }

        System.out.println("  [超管账号] 未发现账号，创建默认超管: admin / admin123...");
        Db.tx(() -> {
            Record staff = new Record()
                    .set("boss_status", 1)
                    .set("name", "系统管理员")
                    .set("phone", "13800000000")
                    .set("max_seats", 999)
                    .set("used_seats", 0)
                    .set("status", 1)
                    .set("is_ban", 0)
                    .set("is_deleted", 0)
                    .set("created_at", new Date())
                    .set("updated_at", new Date());
            Db.save("staff", staff);

            BigInteger staffId = staff.getBigInteger("id");

            Record account = new Record()
                    .set("staff_id", staffId)
                    .set("username", "admin")
                    .set("password_hash", PasswordUtil.hashPassword("admin123"))
                    .set("is_deleted", 0)
                    .set("created_at", new Date());
            Db.save("staff_accounts", account);

            Record sr = new Record().set("staff_id", staffId).set("role_id", 2);
            Db.save("staff_roles", sr);

            return true;
        });
        System.out.println("  [超管账号] 创建成功: admin / admin123");
    }
}
