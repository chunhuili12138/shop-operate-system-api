/*
 Navicat MySQL Dump SQL

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 80406 (8.4.6)
 Source Host           : localhost:3306
 Source Schema         : shop_operate_system_db

 Target Server Type    : MySQL
 Target Server Version : 80406 (8.4.6)
 File Encoding         : 65001

 Date: 25/05/2026 15:28:28
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for article_categories
-- ----------------------------
DROP TABLE IF EXISTS `article_categories`;
CREATE TABLE `article_categories`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `shop_id` bigint UNSIGNED NOT NULL,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `sort` int UNSIGNED NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '0-正常，1-已删除',
  `deleted_time` datetime NULL DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '文章分类' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for articles
-- ----------------------------
DROP TABLE IF EXISTS `articles`;
CREATE TABLE `articles`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `shop_id` bigint UNSIGNED NOT NULL,
  `category_id` bigint UNSIGNED NULL DEFAULT NULL,
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content_type` tinyint UNSIGNED NOT NULL DEFAULT 3 COMMENT '内容类型: 1-图片, 2-视频, 3-富文本',
  `image_urls` json NULL,
  `video_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `cover_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `is_published` tinyint UNSIGNED NOT NULL DEFAULT 1,
  `published_at` datetime NULL DEFAULT NULL,
  `related_package_ids` json NULL,
  `related_material_ids` json NULL,
  `is_deleted` tinyint UNSIGNED NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_time` datetime NULL DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_category`(`category_id` ASC) USING BTREE,
  INDEX `idx_shop_id`(`shop_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '文章/内容表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for attendance_records
-- ----------------------------
DROP TABLE IF EXISTS `attendance_records`;
CREATE TABLE `attendance_records`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `shop_id` bigint UNSIGNED NOT NULL,
  `staff_id` bigint UNSIGNED NOT NULL,
  `check_in_time` datetime NOT NULL,
  `check_out_time` datetime NULL DEFAULT NULL,
  `date` date NOT NULL,
  `status` tinyint UNSIGNED NULL DEFAULT 1 COMMENT '状态: 1-正常, 2-迟到, 3-早退, 4-加班',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_staff_date`(`staff_id` ASC, `date` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '员工打卡记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for commission_rules
-- ----------------------------
DROP TABLE IF EXISTS `commission_rules`;
CREATE TABLE `commission_rules`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `shop_id` bigint UNSIGNED NOT NULL,
  `role_id` bigint UNSIGNED NULL DEFAULT NULL,
  `rule_type` tinyint UNSIGNED NOT NULL COMMENT '规则类型: 1-按次, 2-按流水比例, 3-固定金额',
  `value` decimal(10, 2) NOT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `is_active` tinyint UNSIGNED NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '0-正常，1-已删除',
  `deleted_time` datetime NULL DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '提成规则' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for commission_settlements
-- ----------------------------
DROP TABLE IF EXISTS `commission_settlements`;
CREATE TABLE `commission_settlements`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `shop_id` bigint UNSIGNED NOT NULL,
  `staff_id` bigint UNSIGNED NOT NULL,
  `settlement_period` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `total_sessions` int UNSIGNED NULL DEFAULT 0,
  `total_revenue` decimal(10, 2) NULL DEFAULT 0.00,
  `commission_amount` decimal(10, 2) NOT NULL,
  `status` tinyint UNSIGNED NOT NULL DEFAULT 1 COMMENT '状态: 1-待结算, 2-已发放',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `rule_snapshot` json NULL COMMENT '结算时使用的提成规则快照',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '0-正常，1-已删除',
  `deleted_time` datetime NULL DEFAULT NULL COMMENT '删除时间',
  `expense_id` bigint NULL DEFAULT NULL COMMENT '关联支出记录ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_staff_period`(`staff_id` ASC, `settlement_period` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '员工提成结算' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for coupon_usages
-- ----------------------------
DROP TABLE IF EXISTS `coupon_usages`;
CREATE TABLE `coupon_usages`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `shop_id` bigint UNSIGNED NOT NULL,
  `coupon_id` bigint UNSIGNED NOT NULL,
  `customer_id` bigint UNSIGNED NOT NULL,
  `status` tinyint UNSIGNED NOT NULL DEFAULT 1 COMMENT '状态: 1-未使用, 2-已使用, 3-已过期',
  `received_at` datetime NOT NULL,
  `used_at` datetime NULL DEFAULT NULL,
  `used_in_purchase_id` bigint UNSIGNED NULL DEFAULT NULL,
  `expires_at` datetime NOT NULL,
  `is_deleted` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '0-正常，1-已删除',
  `deleted_time` datetime NULL DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_customer`(`customer_id` ASC) USING BTREE,
  INDEX `idx_expired`(`status` ASC, `expires_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '优惠券领取与使用记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for coupon_verification_logs
-- ----------------------------
DROP TABLE IF EXISTS `coupon_verification_logs`;
CREATE TABLE `coupon_verification_logs`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `shop_id` bigint UNSIGNED NOT NULL,
  `purchase_id` bigint UNSIGNED NULL DEFAULT NULL,
  `third_party_coupon_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `channel` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `operation` tinyint UNSIGNED NOT NULL COMMENT '操作: 1-注册, 2-核销, 3-同步',
  `result` tinyint UNSIGNED NOT NULL COMMENT '结果: 1-成功, 2-失败, 3-无效码, 4-重复, 5-已过期',
  `error_message` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `operator_staff_id` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '0-正常，1-已删除',
  `deleted_time` datetime NULL DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_shop_code`(`shop_id` ASC, `third_party_coupon_code` ASC, `created_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '第三方券码核销日志' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for coupons
-- ----------------------------
DROP TABLE IF EXISTS `coupons`;
CREATE TABLE `coupons`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `shop_id` bigint UNSIGNED NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '描述',
  `type` tinyint UNSIGNED NOT NULL COMMENT '优惠类型: 1-固定金额, 2-百分比, 3-兑换券',
  `use_scene` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'purchase' COMMENT '使用场景: purchase-购买套餐, recharge-充值',
  `value` decimal(10, 2) NOT NULL,
  `min_order_amount` decimal(10, 2) NOT NULL DEFAULT 0.00,
  `total_stock` int UNSIGNED NOT NULL DEFAULT 0,
  `per_user_limit` int UNSIGNED NOT NULL DEFAULT 1 COMMENT '每顾客最多领取张数,0=不限',
  `remain_stock` int UNSIGNED NOT NULL DEFAULT 0,
  `valid_days` int UNSIGNED NOT NULL,
  `is_active` tinyint UNSIGNED NOT NULL DEFAULT 1,
  `auto_grant_on_register` tinyint UNSIGNED NOT NULL DEFAULT 0 COMMENT '顾客绑手机后自动发放: 0-否, 1-是',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '0-正常，1-已删除',
  `deleted_time` datetime NULL DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '优惠券定义' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for customer_sessions
-- ----------------------------
DROP TABLE IF EXISTS `customer_sessions`;
CREATE TABLE `customer_sessions`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `shop_id` bigint UNSIGNED NOT NULL,
  `customer_id` bigint UNSIGNED NOT NULL,
  `purchase_id` bigint UNSIGNED NOT NULL,
  `session_date` date NOT NULL,
  `status` tinyint UNSIGNED NOT NULL DEFAULT 1 COMMENT '状态: 1-可用, 2-已核销, 3-已过期, 4-已退款',
  `used_at` datetime NULL DEFAULT NULL,
  `game_session_id` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '0-正常，1-已删除',
  `deleted_time` datetime NULL DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_customer_date`(`customer_id` ASC, `session_date` ASC, `status` ASC) USING BTREE,
  INDEX `idx_purchase_id`(`purchase_id` ASC) USING BTREE,
  INDEX `idx_expired`(`status` ASC, `session_date` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '顾客按天次卡记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for customer_wallets
-- ----------------------------
DROP TABLE IF EXISTS `customer_wallets`;
CREATE TABLE `customer_wallets`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `shop_id` bigint UNSIGNED NOT NULL,
  `customer_id` bigint UNSIGNED NOT NULL,
  `balance` decimal(10, 2) NOT NULL DEFAULT 0.00,
  `total_recharged` decimal(10, 2) NOT NULL DEFAULT 0.00,
  `total_spent` decimal(10, 2) NOT NULL DEFAULT 0.00,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '0-正常，1-已删除',
  `deleted_time` datetime NULL DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_customer_shop`(`shop_id` ASC, `customer_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '顾客储值钱包' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for customers
-- ----------------------------
DROP TABLE IF EXISTS `customers`;
CREATE TABLE `customers`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `shop_id` bigint UNSIGNED NOT NULL COMMENT '店铺id',
  `nickname` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '昵称',
  `avatar_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '头像',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '手机号',
  `gender` tinyint UNSIGNED NULL DEFAULT NULL COMMENT '0-未知，1-男，2-女',
  `birthday` date NULL DEFAULT NULL COMMENT '生日',
  `wechat_openid` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `wechat_unionid` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `source` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '来源 store/meituan/douyin/other',
  `tags` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '标签，逗号分隔',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `is_deleted` tinyint UNSIGNED NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_time` datetime NULL DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_shop_id`(`shop_id` ASC) USING BTREE,
  INDEX `idx_wechat_openid`(`wechat_openid` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '顾客基本信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for daily_snapshots
-- ----------------------------
DROP TABLE IF EXISTS `daily_snapshots`;
CREATE TABLE `daily_snapshots`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `shop_id` bigint UNSIGNED NOT NULL,
  `snapshot_date` date NOT NULL,
  `sales_total` decimal(10, 2) NOT NULL DEFAULT 0.00,
  `revenue_confirmed` decimal(10, 2) NOT NULL DEFAULT 0.00,
  `new_customers` int UNSIGNED NOT NULL DEFAULT 0,
  `active_sessions` int UNSIGNED NOT NULL DEFAULT 0,
  `average_duration` int UNSIGNED NULL DEFAULT NULL COMMENT '平均游玩时长（单位：分钟）',
  `top_package_id` bigint UNSIGNED NULL DEFAULT NULL,
  `inventory_warns` json NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_shop_date`(`shop_id` ASC, `snapshot_date` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 116 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '每日经营快照' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for expense_categories
-- ----------------------------
DROP TABLE IF EXISTS `expense_categories`;
CREATE TABLE `expense_categories`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `shop_id` bigint UNSIGNED NOT NULL,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '0-正常，1-已删除',
  `deleted_time` datetime NULL DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_shop_id`(`shop_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 95 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '费用支出分类' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for expenses
-- ----------------------------
DROP TABLE IF EXISTS `expenses`;
CREATE TABLE `expenses`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `shop_id` bigint UNSIGNED NOT NULL,
  `category_id` bigint UNSIGNED NULL DEFAULT NULL,
  `amount` decimal(10, 2) NOT NULL,
  `payment_method` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `expense_date` date NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '0-正常，1-已删除',
  `deleted_time` datetime NULL DEFAULT NULL COMMENT '删除时间',
  `source_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'manual',
  `source_id` bigint NULL DEFAULT NULL,
  `operator_staff_id` bigint NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_shop_id`(`shop_id` ASC) USING BTREE,
  INDEX `idx_category`(`category_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '费用支出表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for feedbacks
-- ----------------------------
DROP TABLE IF EXISTS `feedbacks`;
CREATE TABLE `feedbacks`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `shop_id` bigint UNSIGNED NOT NULL COMMENT '店铺ID',
  `customer_id` bigint UNSIGNED NOT NULL COMMENT '顾客ID',
  `game_session_id` bigint UNSIGNED NULL DEFAULT NULL COMMENT '关联的游玩记录ID',
  `feedback_type` tinyint UNSIGNED NOT NULL DEFAULT 1 COMMENT '反馈类型: 1-满意度 2-建议 3-投诉 4-其他',
  `rating` tinyint UNSIGNED NULL DEFAULT NULL COMMENT '评分: 1-5星',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '反馈内容',
  `images` json NULL COMMENT '图片URL数组',
  `status` tinyint UNSIGNED NOT NULL DEFAULT 1 COMMENT '状态: 1-待处理 2-已回复 3-已关闭',
  `reply_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '管理员回复内容',
  `replied_by` bigint UNSIGNED NULL DEFAULT NULL COMMENT '回复人ID（staff表）',
  `replied_at` datetime NULL DEFAULT NULL COMMENT '回复时间',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '0-正常，1-已删除',
  `deleted_time` datetime NULL DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_shop`(`shop_id` ASC) USING BTREE,
  INDEX `idx_customer`(`customer_id` ASC) USING BTREE,
  INDEX `idx_session`(`game_session_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_created`(`created_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '顾客反馈表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for game_sessions
-- ----------------------------
DROP TABLE IF EXISTS `game_sessions`;
CREATE TABLE `game_sessions`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `shop_id` bigint UNSIGNED NOT NULL,
  `customer_id` bigint UNSIGNED NOT NULL,
  `customer_session_id` bigint UNSIGNED NOT NULL,
  `staff_id` bigint UNSIGNED NOT NULL,
  `start_time` datetime NOT NULL,
  `end_time` datetime NULL DEFAULT NULL,
  `status` tinyint UNSIGNED NOT NULL DEFAULT 1 COMMENT '状态: 1-进行中, 2-已完成, 3-已取消',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '0-正常，1-已删除',
  `deleted_time` datetime NULL DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_shop_status`(`shop_id` ASC, `status` ASC) USING BTREE,
  INDEX `idx_customer_id`(`customer_id` ASC) USING BTREE,
  INDEX `idx_staff`(`staff_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '游玩/核销记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for inventory
-- ----------------------------
DROP TABLE IF EXISTS `inventory`;
CREATE TABLE `inventory`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `shop_id` bigint UNSIGNED NOT NULL,
  `material_id` bigint UNSIGNED NOT NULL,
  `quantity` decimal(10, 2) NOT NULL DEFAULT 0.00,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '0-正常，1-已删除',
  `deleted_time` datetime NULL DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_shop_material`(`shop_id` ASC, `material_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '当前库存表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for inventory_transactions
-- ----------------------------
DROP TABLE IF EXISTS `inventory_transactions`;
CREATE TABLE `inventory_transactions`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `shop_id` bigint UNSIGNED NOT NULL,
  `material_id` bigint UNSIGNED NOT NULL,
  `transaction_type` tinyint UNSIGNED NOT NULL COMMENT '流水类型: 1-入库, 2-出库',
  `quantity` decimal(10, 2) NOT NULL,
  `balance_after` decimal(10, 2) NULL DEFAULT NULL,
  `reference_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `reference_id` bigint UNSIGNED NULL DEFAULT NULL,
  `operator_staff_id` bigint UNSIGNED NULL DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '0-正常，1-已删除',
  `deleted_time` datetime NULL DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_material`(`material_id` ASC) USING BTREE,
  INDEX `idx_reference`(`reference_type` ASC, `reference_id` ASC) USING BTREE,
  INDEX `idx_shop`(`shop_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 26 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '库存出入库流水' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for invoices
-- ----------------------------
DROP TABLE IF EXISTS `invoices`;
CREATE TABLE `invoices`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `shop_id` bigint UNSIGNED NOT NULL,
  `reference_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `reference_id` bigint UNSIGNED NOT NULL,
  `invoice_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `amount` decimal(10, 2) NOT NULL,
  `issued_at` date NULL DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '0-正常，1-已删除',
  `deleted_time` datetime NULL DEFAULT NULL COMMENT '删除时间',
  `image_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '发票图片路径',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联记录备注',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_reference`(`reference_type` ASC, `reference_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '发票记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for materials
-- ----------------------------
DROP TABLE IF EXISTS `materials`;
CREATE TABLE `materials`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `shop_id` bigint UNSIGNED NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `sku` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '店铺自定义物料分类',
  `unit` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '个' COMMENT '单位',
  `type` tinyint UNSIGNED NOT NULL DEFAULT 1 COMMENT '物料类型: 1-消耗品, 2-工具',
  `min_stock` decimal(10, 2) NULL DEFAULT 0.00,
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `is_deleted` tinyint UNSIGNED NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_time` datetime NULL DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_shop_id`(`shop_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '物料/货物基础信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for notification_logs
-- ----------------------------
DROP TABLE IF EXISTS `notification_logs`;
CREATE TABLE `notification_logs`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `shop_id` bigint UNSIGNED NOT NULL,
  `recipient_type` tinyint UNSIGNED NOT NULL COMMENT '接收人: 1-顾客, 2-员工',
  `recipient_id` bigint UNSIGNED NOT NULL,
  `channel` tinyint UNSIGNED NOT NULL DEFAULT 1 COMMENT '渠道: 1-微信模板消息, 2-短信, 3-站内信',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `status` tinyint UNSIGNED NOT NULL DEFAULT 1 COMMENT '状态: 1-待发送, 2-已发送, 3-发送失败',
  `error_message` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `sent_at` datetime NULL DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_recipient`(`recipient_type` ASC, `recipient_id` ASC) USING BTREE,
  INDEX `idx_shop_recipient`(`shop_id` ASC, `recipient_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 61 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '消息通知日志' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for operation_logs
-- ----------------------------
DROP TABLE IF EXISTS `operation_logs`;
CREATE TABLE `operation_logs`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `shop_id` bigint UNSIGNED NOT NULL,
  `operator_type` tinyint UNSIGNED NOT NULL COMMENT '操作人: 1-员工, 2-顾客',
  `operator_id` bigint UNSIGNED NOT NULL,
  `action` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `target_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `target_id` bigint UNSIGNED NULL DEFAULT NULL,
  `detail` json NULL,
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_shop_time`(`shop_id` ASC, `created_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '操作日志' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for package_bom
-- ----------------------------
DROP TABLE IF EXISTS `package_bom`;
CREATE TABLE `package_bom`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `package_id` bigint UNSIGNED NOT NULL,
  `material_id` bigint UNSIGNED NOT NULL,
  `quantity` decimal(10, 2) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '0-正常，1-已删除',
  `deleted_time` datetime NULL DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_package_material`(`package_id` ASC, `material_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '套餐物料清单' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for packages
-- ----------------------------
DROP TABLE IF EXISTS `packages`;
CREATE TABLE `packages`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `shop_id` bigint UNSIGNED NOT NULL COMMENT '店铺id',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '套餐名称',
  `type` tinyint UNSIGNED NOT NULL COMMENT '套餐类型: 1-单次, 2-周卡, 3-月卡',
  `duration_minutes` int UNSIGNED NULL DEFAULT NULL COMMENT '套餐时长',
  `price` decimal(10, 2) NOT NULL COMMENT '价格',
  `original_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '原价',
  `max_people_per_session` tinyint UNSIGNED NOT NULL DEFAULT 1 COMMENT '最大游玩人数',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '描述',
  `is_active` tinyint UNSIGNED NOT NULL DEFAULT 1 COMMENT '是否启用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '0-正常，1-已删除',
  `deleted_time` datetime NULL DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_shop_id`(`shop_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '服务套餐定义表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for permissions
-- ----------------------------
DROP TABLE IF EXISTS `permissions`;
CREATE TABLE `permissions`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `parent_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '父级ID（0=顶级）',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `menu_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '路由路径',
  `component` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '组件路径（如 /src/views/xxx/index.vue）',
  `redirect` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '重定向路径',
  `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '菜单图标',
  `sort` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '排序（rank）',
  `type` tinyint UNSIGNED NOT NULL DEFAULT 1 COMMENT '类型：1-目录 2-菜单 3-按钮',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `is_active` tinyint UNSIGNED NOT NULL DEFAULT 1 COMMENT '是否启用',
  `is_deleted` tinyint UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否删除',
  `super_admin_visible` tinyint UNSIGNED NOT NULL DEFAULT 0 COMMENT '超管菜单可见：0-否，1-是',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_menu_code`(`menu_code` ASC) USING BTREE,
  INDEX `idx_parent_id`(`parent_id` ASC) USING BTREE,
  INDEX `idx_type`(`type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 168 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '权限表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for points_records
-- ----------------------------
DROP TABLE IF EXISTS `points_records`;
CREATE TABLE `points_records`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `shop_id` bigint UNSIGNED NOT NULL,
  `customer_id` bigint UNSIGNED NOT NULL,
  `type` tinyint UNSIGNED NOT NULL COMMENT '类型: 1-获取, 2-消耗, 3-过期, 4-调整',
  `points` int NOT NULL,
  `balance_after` int NOT NULL,
  `source` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `reference_id` bigint UNSIGNED NULL DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '0-正常，1-已删除',
  `deleted_time` datetime NULL DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_customer`(`customer_id` ASC) USING BTREE,
  INDEX `idx_shop`(`shop_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '积分记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for prepayments
-- ----------------------------
DROP TABLE IF EXISTS `prepayments`;
CREATE TABLE `prepayments`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `shop_id` bigint UNSIGNED NOT NULL,
  `purchase_id` bigint UNSIGNED NOT NULL,
  `amount` decimal(10, 2) NOT NULL,
  `balance_before` decimal(10, 2) NULL DEFAULT NULL,
  `balance_after` decimal(10, 2) NULL DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '0-正常，1-已删除',
  `deleted_time` datetime NULL DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_purchase_id`(`purchase_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '预收款入账记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for purchase_order_items
-- ----------------------------
DROP TABLE IF EXISTS `purchase_order_items`;
CREATE TABLE `purchase_order_items`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `purchase_order_id` bigint UNSIGNED NOT NULL,
  `material_id` bigint UNSIGNED NOT NULL,
  `quantity` decimal(10, 2) NOT NULL,
  `unit_price` decimal(10, 2) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '0-正常，1-已删除',
  `deleted_time` datetime NULL DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_order`(`purchase_order_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '采购明细' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for purchase_orders
-- ----------------------------
DROP TABLE IF EXISTS `purchase_orders`;
CREATE TABLE `purchase_orders`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `shop_id` bigint UNSIGNED NOT NULL,
  `supplier_id` bigint UNSIGNED NULL DEFAULT NULL,
  `order_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `order_date` date NOT NULL,
  `type` tinyint UNSIGNED NOT NULL DEFAULT 1 COMMENT '结算方式: 1-现结, 2-赊账',
  `total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00,
  `paid_amount` decimal(10, 2) NOT NULL DEFAULT 0.00,
  `status` tinyint UNSIGNED NOT NULL DEFAULT 1 COMMENT '状态: 1-进行中, 2-已完成, 3-已取消',
  `operator_staff_id` bigint UNSIGNED NULL DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '0-正常，1-已删除',
  `deleted_time` datetime NULL DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_supplier`(`supplier_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '采购单' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for purchase_payments
-- ----------------------------
DROP TABLE IF EXISTS `purchase_payments`;
CREATE TABLE `purchase_payments`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `purchase_order_id` bigint UNSIGNED NOT NULL,
  `amount` decimal(10, 2) NOT NULL,
  `payment_method` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `paid_at` datetime NOT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '0-正常，1-已删除',
  `deleted_time` datetime NULL DEFAULT NULL COMMENT '删除时间',
  `expense_id` bigint NULL DEFAULT NULL COMMENT '关联支出记录ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_order_id`(`purchase_order_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '采购付款记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for purchases
-- ----------------------------
DROP TABLE IF EXISTS `purchases`;
CREATE TABLE `purchases`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `shop_id` bigint UNSIGNED NOT NULL,
  `customer_id` bigint UNSIGNED NOT NULL,
  `package_id` bigint UNSIGNED NULL DEFAULT NULL,
  `purchase_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'purchase' COMMENT 'purchase-购买套餐, recharge-充值',
  `channel` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'store' COMMENT '渠道标识: store/meituan/douyin/other',
  `third_party_coupon_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `coupon_usage_id` bigint UNSIGNED NULL DEFAULT NULL COMMENT '使用的优惠券记录ID',
  `start_date` date NOT NULL,
  `total_amount` decimal(10, 2) NOT NULL,
  `paid_amount` decimal(10, 2) NOT NULL DEFAULT 0.00,
  `coupon_discount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '优惠券抵扣金额',
  `payment_method` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `status` tinyint UNSIGNED NOT NULL DEFAULT 1 COMMENT '状态: 1-有效, 2-已退款, 3-已过期',
  `operator_staff_id` bigint UNSIGNED NULL DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `is_deleted` tinyint UNSIGNED NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_time` datetime NULL DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_coupon_code`(`shop_id` ASC, `third_party_coupon_code` ASC) USING BTREE,
  INDEX `idx_customer`(`customer_id` ASC) USING BTREE,
  INDEX `idx_shop_id`(`shop_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '顾客购买/充值记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for queue_entries
-- ----------------------------
DROP TABLE IF EXISTS `queue_entries`;
CREATE TABLE `queue_entries`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `shop_id` bigint UNSIGNED NOT NULL,
  `customer_id` bigint UNSIGNED NOT NULL,
  `queue_number` int UNSIGNED NOT NULL,
  `party_size` tinyint UNSIGNED NOT NULL DEFAULT 1,
  `status` tinyint UNSIGNED NOT NULL DEFAULT 1 COMMENT '状态: 1-排队中, 2-已入座, 3-已取消, 4-已通知',
  `requested_at` datetime NOT NULL,
  `seated_at` datetime NULL DEFAULT NULL,
  `notified_at` datetime NULL DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `is_deleted` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '0-正常，1-已删除',
  `deleted_time` datetime NULL DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_shop_status`(`shop_id` ASC, `status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '排队等位记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for refund_records
-- ----------------------------
DROP TABLE IF EXISTS `refund_records`;
CREATE TABLE `refund_records`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `shop_id` bigint UNSIGNED NOT NULL,
  `purchase_id` bigint UNSIGNED NOT NULL,
  `refund_amount` decimal(10, 2) NOT NULL,
  `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `deducted_amount` decimal(10, 2) NOT NULL DEFAULT 0.00,
  `refund_prepay_amount` decimal(10, 2) NOT NULL DEFAULT 0.00,
  `refund_wallet_amount` decimal(10, 2) NOT NULL DEFAULT 0.00,
  `refunded_sessions` int UNSIGNED NULL DEFAULT 0,
  `status` tinyint UNSIGNED NOT NULL DEFAULT 1 COMMENT '状态: 1-处理中, 2-已完成, 3-已拒绝',
  `operated_by` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '0-正常，1-已删除',
  `deleted_time` datetime NULL DEFAULT NULL COMMENT '删除时间',
  `revenue_id` bigint NULL DEFAULT NULL COMMENT '关联反向收入记录ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_purchase_id`(`purchase_id` ASC) USING BTREE,
  INDEX `idx_shop`(`shop_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '退款记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for revenue_records
-- ----------------------------
DROP TABLE IF EXISTS `revenue_records`;
CREATE TABLE `revenue_records`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `shop_id` bigint UNSIGNED NOT NULL,
  `game_session_id` bigint UNSIGNED NOT NULL,
  `purchase_id` bigint UNSIGNED NOT NULL,
  `amount` decimal(10, 2) NOT NULL,
  `confirmed_at` datetime NOT NULL,
  `confirmed_by` bigint UNSIGNED NULL DEFAULT NULL COMMENT '确认收入员工ID（staff.id）',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '0-正常，1-已删除',
  `deleted_time` datetime NULL DEFAULT NULL COMMENT '删除时间',
  `payment_method` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `customer_id` bigint NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_game_session`(`game_session_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '收入确认记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for role_permissions
-- ----------------------------
DROP TABLE IF EXISTS `role_permissions`;
CREATE TABLE `role_permissions`  (
  `role_id` bigint UNSIGNED NOT NULL,
  `permission_id` bigint UNSIGNED NOT NULL,
  PRIMARY KEY (`role_id`, `permission_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色权限关联' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for roles
-- ----------------------------
DROP TABLE IF EXISTS `roles`;
CREATE TABLE `roles`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `shop_id` bigint UNSIGNED NOT NULL DEFAULT 0,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for seat_subscriptions
-- ----------------------------
DROP TABLE IF EXISTS `seat_subscriptions`;
CREATE TABLE `seat_subscriptions`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `seat_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '席位号',
  `staff_id` bigint UNSIGNED NOT NULL COMMENT 'staff表的id',
  `start_date` date NOT NULL COMMENT '生效日期',
  `end_date` date NOT NULL COMMENT '到期日期',
  `status` tinyint UNSIGNED NOT NULL DEFAULT 1 COMMENT '状态: 1-生效中 2-已到期',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_end_date`(`end_date` ASC) USING BTREE,
  INDEX `idx_staff`(`staff_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 35 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '席位订阅记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for seat_subscriptions_transactions
-- ----------------------------
DROP TABLE IF EXISTS `seat_subscriptions_transactions`;
CREATE TABLE `seat_subscriptions_transactions`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `seat_id` bigint NOT NULL COMMENT 'seat_subscripitions表id',
  `amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '支付金额',
  `payment_method` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '支付方式: 微信：wechat/支付宝：alipay/银行转账：bank/现金：cash/其他：other',
  `payment_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '支付流水号',
  `subscription_type` tinyint UNSIGNED NOT NULL DEFAULT 1 COMMENT '订阅类型: 1-月付 2-年付',
  `subscription_num` int NULL DEFAULT 1 COMMENT '订阅次数',
  `status` tinyint NULL DEFAULT NULL COMMENT '状态: 1-支付 2-退款',
  `refund_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '退款金额',
  `refund_days` int NULL DEFAULT NULL COMMENT '退款扣除天数',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 28 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '席位订阅记录流水表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for shops
-- ----------------------------
DROP TABLE IF EXISTS `shops`;
CREATE TABLE `shops`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `owner_staff_id` bigint UNSIGNED NOT NULL COMMENT '所属商户staff_id',
  `seat_id` bigint UNSIGNED NULL DEFAULT NULL COMMENT '关联席位ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '店铺名称',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '地址',
  `contact_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系电话',
  `max_capacity` int UNSIGNED NOT NULL DEFAULT 20 COMMENT '店铺最大客容量',
  `status` tinyint UNSIGNED NOT NULL DEFAULT 1 COMMENT '1-营业中，0-休息',
  `description` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '店铺描述',
  `sign_photo` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '门头照片',
  `is_deleted` tinyint UNSIGNED NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_time` datetime NULL DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_owner_staff`(`owner_staff_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 28 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '店铺表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for staff
-- ----------------------------
DROP TABLE IF EXISTS `staff`;
CREATE TABLE `staff`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `boss_status` tinyint UNSIGNED NOT NULL COMMENT '是否商户主体（0：否，1：是）',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '名称',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系电话',
  `contact_email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '邮箱',
  `id_card` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '身份证',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '头像',
  `employment_type` tinyint UNSIGNED NOT NULL DEFAULT 1 COMMENT '用工类型: 1-全职, 2-兼职',
  `max_seats` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '最大席位数（购买数量）',
  `used_seats` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '已开通店铺数',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `status` tinyint UNSIGNED NOT NULL DEFAULT 1 COMMENT '1-在职，0-离职',
  `is_ban` tinyint NULL DEFAULT 0 COMMENT '是否封禁（0否，1是）',
  `is_deleted` tinyint UNSIGNED NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_time` datetime NULL DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_boss_status`(`boss_status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 48 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '员工基本信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for staff_accounts
-- ----------------------------
DROP TABLE IF EXISTS `staff_accounts`;
CREATE TABLE `staff_accounts`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `staff_id` bigint UNSIGNED NOT NULL,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `password_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `wechat_openid` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `last_login_at` datetime NULL DEFAULT NULL,
  `is_deleted` tinyint UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否删除（0-否，1-是）',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_time` datetime NULL DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_staff_id`(`staff_id` ASC) USING BTREE,
  INDEX `idx_is_deleted`(`is_deleted` ASC) USING BTREE,
  INDEX `idx_username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 47 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '员工登录账号表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for staff_roles
-- ----------------------------
DROP TABLE IF EXISTS `staff_roles`;
CREATE TABLE `staff_roles`  (
  `staff_id` bigint UNSIGNED NOT NULL,
  `role_id` bigint UNSIGNED NOT NULL,
  PRIMARY KEY (`staff_id`, `role_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '员工角色关联' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for staff_schedules
-- ----------------------------
DROP TABLE IF EXISTS `staff_schedules`;
CREATE TABLE `staff_schedules`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `shop_id` bigint UNSIGNED NOT NULL,
  `staff_id` bigint UNSIGNED NOT NULL,
  `schedule_date` date NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `type` tinyint UNSIGNED NOT NULL DEFAULT 1 COMMENT '班次: 1-上班, 2-休息',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_staff_date`(`staff_id` ASC, `schedule_date` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '员工排班表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for staff_shops
-- ----------------------------
DROP TABLE IF EXISTS `staff_shops`;
CREATE TABLE `staff_shops`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `staff_id` bigint UNSIGNED NOT NULL COMMENT '员工ID',
  `shop_id` bigint UNSIGNED NOT NULL COMMENT '店铺ID',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_staff`(`staff_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '员工店铺关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for suppliers
-- ----------------------------
DROP TABLE IF EXISTS `suppliers`;
CREATE TABLE `suppliers`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `shop_id` bigint UNSIGNED NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `contact_person` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `is_deleted` tinyint UNSIGNED NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_time` datetime NULL DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_shop_id`(`shop_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '供应商表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for sys_dicts
-- ----------------------------
DROP TABLE IF EXISTS `sys_dicts`;
CREATE TABLE `sys_dicts`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `dict_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '字典分组编码（如：order_status, package_type）',
  `dict_key` tinyint UNSIGNED NOT NULL COMMENT '业务表实际存储的整数值',
  `dict_value` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '前端展示值（如：有效、已退款）',
  `dict_label` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '代码常量标识（如：VALID, REFUNDED）',
  `sort` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '排序',
  `is_active` tinyint NOT NULL DEFAULT 1 COMMENT '1-启用，0-禁用',
  `shop_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '0=全局默认，>0=租户自定义覆盖',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_dict`(`dict_code` ASC, `dict_key` ASC, `shop_id` ASC) USING BTREE,
  UNIQUE INDEX `uk_dict_value`(`dict_code` ASC, `dict_value` ASC, `shop_id` ASC) USING BTREE,
  UNIQUE INDEX `uk_dict_label`(`dict_code` ASC, `dict_label` ASC, `shop_id` ASC) USING BTREE,
  INDEX `idx_dict_code`(`dict_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 128 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '业务字典表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for wallet_transactions
-- ----------------------------
DROP TABLE IF EXISTS `wallet_transactions`;
CREATE TABLE `wallet_transactions`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `wallet_id` bigint UNSIGNED NOT NULL,
  `shop_id` bigint UNSIGNED NOT NULL,
  `customer_id` bigint UNSIGNED NOT NULL,
  `type` tinyint UNSIGNED NOT NULL COMMENT '类型: 1-充值, 2-消费, 3-退款, 4-调整',
  `amount` decimal(10, 2) NOT NULL,
  `balance_after` decimal(10, 2) NOT NULL,
  `reference_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `reference_id` bigint UNSIGNED NULL DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '0-正常，1-已删除',
  `deleted_time` datetime NULL DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_customer`(`customer_id` ASC) USING BTREE,
  INDEX `idx_wallet_id`(`wallet_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '钱包交易流水' ROW_FORMAT = DYNAMIC;

SET FOREIGN_KEY_CHECKS = 1;
