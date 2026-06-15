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

 Date: 15/06/2026 16:55:53
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
-- Records of article_categories
-- ----------------------------
INSERT INTO `article_categories` VALUES (1, 0, '活动通知', 1, '2026-05-25 09:20:09', 0, NULL);
INSERT INTO `article_categories` VALUES (2, 0, '新品推荐', 2, '2026-05-25 09:20:09', 0, NULL);
INSERT INTO `article_categories` VALUES (3, 0, '使用教程', 3, '2026-05-25 09:20:09', 0, NULL);
INSERT INTO `article_categories` VALUES (4, 0, '优惠促销', 4, '2026-05-25 09:20:09', 0, NULL);
INSERT INTO `article_categories` VALUES (5, 0, '门店动态', 5, '2026-05-25 09:20:09', 0, NULL);
INSERT INTO `article_categories` VALUES (6, 0, '其他', 6, '2026-05-25 09:20:09', 0, NULL);
INSERT INTO `article_categories` VALUES (7, 5, '拼豆图案参考', 0, '2026-05-25 09:20:58', 0, NULL);

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
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '文章/内容表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of articles
-- ----------------------------
INSERT INTO `articles` VALUES (1, 5, 4, '新店开业-限时福利', 3, NULL, NULL, '<p>今天是快乐的一天，我们的DIY手工店终于开始试营业啦！</p><p>凡是到店的顾客，可以享受<span style=\"color: rgb(225, 60, 57); font-size: 16px;\"><u><strong>单次卡9.9元</strong></u></span>的特价优惠。</p><p>活动时间从<strong>6月1日 - 6月30日。</strong></p>', NULL, 0, NULL, NULL, NULL, 1, '2026-05-25 09:25:42', '2026-05-25 11:34:22', '2026-05-25 09:42:01');
INSERT INTO `articles` VALUES (2, 5, 5, '新店开业大酬宾', 3, NULL, NULL, '<p style=\"text-align: start;\">今天是快乐的一天，我们的DIY手工店终于开始试营业啦！</p><p style=\"text-align: start;\">凡是到店的顾客，可以享受单次卡9.9元的特价优惠。</p><p style=\"text-align: start;\">活动时间从6月1日 - 6月30日。</p>', '5/article-cover/20260525131241162_1119194698.png', 0, NULL, NULL, NULL, 0, '2026-05-25 09:42:27', '2026-05-25 13:12:41', NULL);
INSERT INTO `articles` VALUES (3, 5, 7, '拼豆图案参考-hellokitty', 3, NULL, NULL, '<p>阿伟大碗大碗大碗大碗大碗打，就阿巴斯饭卡</p><p>暗色，进度把开始吧案件八十九</p><p><br></p><div data-w-e-type=\"video\" data-w-e-is-void>\n<video poster=\"\" controls=\"true\" width=\"auto\" height=\"auto\"><source src=\"/api/file/image?name=5%2Farticle-video%2F20260525131021269_2020347338.mp4\" type=\"video/mp4\"/></video>\n</div><p>按时缴纳案例和法律你发看完<img src=\"/api/file/image?name=5%2Farticle-image%2F20260525094330669_988798188.jpg\" alt=\"\" data-href=\"\" style=\"\"/></p><p>打完了就巴萨的理解和奥兰多的还是拉风爱丽丝爱</p><p><img src=\"/api/file/image?name=5%2Farticle-image%2F20260525131006353_899742814.png\" alt=\"\" data-href=\"\" style=\"\"/></p><p>丽丝拉萨吧阿拉伯爱丽丝部分啊垃圾八路军阿拉伯法拉利八零三八阿拉斯加吧爱丽丝</p>', '5/article-cover/20260525131028839_316119992.jpg', 1, '2026-05-25 09:51:33', NULL, NULL, 0, '2026-05-25 09:51:33', '2026-05-25 13:10:29', NULL);
INSERT INTO `articles` VALUES (4, 5, 5, '一图流介绍店内套餐', 1, '[\"5/article-image/20260525130940697_2088441278.jpg\", \"5/article-image/20260525130940794_1455824410.jpg\"]', NULL, NULL, '5/article-cover/20260525130940434_1748027761.jpeg', 1, '2026-05-25 09:55:19', NULL, NULL, 0, '2026-05-25 09:55:19', '2026-05-25 13:09:41', NULL);
INSERT INTO `articles` VALUES (5, 5, 7, '拼豆入门教程：从零开始的创作之旅', 3, NULL, NULL, '拼豆是一种简单又有趣的DIY手工活动。本教程将带你了解拼豆的基本工具、操作步骤和配色技巧。首先准备好拼豆板、镊子、熨斗和彩色拼豆，按照图纸摆放好图案后，用熨斗均匀加热使豆子融合在一起即可完成作品。', NULL, 1, '2026-05-28 10:45:52', NULL, NULL, 0, '2026-05-28 10:45:52', '2026-05-28 10:45:52', NULL);
INSERT INTO `articles` VALUES (6, 5, 5, '亲子DIY攻略：10个适合全家的手工项目', 3, NULL, NULL, '周末不知道带孩子去哪玩？来乔乔DIY手工店体验亲子手工吧！推荐项目：1. 拼豆卡通挂件 2. 石膏彩绘 3. 奶油胶手机壳 4. 手工皂制作 5. 黏土人偶 6. 钥匙扣DIY 7. 团扇绘画 8. 马克杯涂鸦 9. 风铃制作 10. 相框装饰。', NULL, 1, '2026-05-28 10:45:52', NULL, NULL, 0, '2026-05-28 10:45:52', '2026-05-28 10:45:52', NULL);
INSERT INTO `articles` VALUES (7, 5, 4, '会员月重磅福利！全场套餐8折起', 3, NULL, NULL, '尊敬的会员们，本月特别推出会员日福利活动！凡持有月卡会员的顾客，本月内购买任意单次套餐享受8折优惠。新顾客首次到店消费满50元立减10元。活动时间：2026年6月1日-6月30日。', NULL, 1, '2026-05-28 10:45:52', NULL, NULL, 0, '2026-05-28 10:45:52', '2026-05-28 10:45:52', NULL);
INSERT INTO `articles` VALUES (8, 5, 7, '端午节特惠活动：亲子手工DIY粽子', 3, NULL, NULL, '端午节来临，乔乔DIY手工店推出亲子手工DIY粽子活动！用拼豆制作可爱的粽子挂件，感受传统节日氛围。活动期间全场8折优惠！', NULL, 1, '2026-05-28 10:00:00', NULL, NULL, 0, '2026-05-28 10:00:00', '2026-06-09 22:29:47', NULL);
INSERT INTO `articles` VALUES (9, 5, 4, '儿童节快乐！带孩子来乔乔DIY创造美好回忆', 3, NULL, NULL, '六一儿童节，给孩子最好的礼物是陪伴！来乔乔DIY手工店，一起拼豆、涂石膏、做手工，创造独一无二的作品。儿童节当天全场7折！', NULL, 1, '2026-06-01 09:00:00', NULL, NULL, 0, '2026-06-01 09:00:00', '2026-06-09 22:29:47', NULL);
INSERT INTO `articles` VALUES (10, 5, 5, '新品上架：512色豪华拼豆套装', 3, NULL, NULL, '应广大顾客要求，我们引进了512色豪华拼豆套装！颜色更丰富，创作更自由。快来体验吧！', NULL, 1, '2026-06-05 14:00:00', NULL, NULL, 0, '2026-06-05 14:00:00', '2026-06-09 22:29:47', NULL);
INSERT INTO `articles` VALUES (11, 5, 6, '拼豆技巧分享：如何制作渐变效果', 3, NULL, NULL, '很多顾客问如何让拼豆作品更有层次感，今天分享一个小技巧：使用渐变色排列！从深到浅，自然过渡，效果超赞。', NULL, 1, '2026-06-08 10:00:00', NULL, NULL, 0, '2026-06-08 10:00:00', '2026-06-09 22:29:47', NULL);
INSERT INTO `articles` VALUES (12, 5, 7, '周末亲子活动预告：石膏涂色大赛', 3, NULL, NULL, '本周末举办石膏涂色大赛！参与者有机会获得精美奖品。名额有限，先到先得！', NULL, 1, '2026-06-09 09:00:00', NULL, NULL, 0, '2026-06-09 09:00:00', '2026-06-09 22:29:47', NULL);

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
) ENGINE = InnoDB AUTO_INCREMENT = 157 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '员工打卡记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of attendance_records
-- ----------------------------
INSERT INTO `attendance_records` VALUES (1, 5, 43, '2026-05-22 08:55:00', '2026-05-22 18:05:00', '2026-05-22', 1, '2026-05-28 11:05:05');
INSERT INTO `attendance_records` VALUES (2, 5, 44, '2026-05-22 09:15:00', '2026-05-22 18:00:00', '2026-05-22', 2, '2026-05-28 11:05:05');
INSERT INTO `attendance_records` VALUES (3, 5, 45, '2026-05-22 08:50:00', '2026-05-22 18:10:00', '2026-05-22', 1, '2026-05-28 11:05:05');
INSERT INTO `attendance_records` VALUES (4, 5, 46, '2026-05-22 08:58:00', '2026-05-22 18:02:00', '2026-05-22', 1, '2026-05-28 11:05:05');
INSERT INTO `attendance_records` VALUES (5, 5, 43, '2026-05-23 08:52:00', '2026-05-23 18:08:00', '2026-05-23', 1, '2026-05-28 11:05:05');
INSERT INTO `attendance_records` VALUES (6, 5, 44, '2026-05-23 09:00:00', '2026-05-23 18:05:00', '2026-05-23', 1, '2026-05-28 11:05:05');
INSERT INTO `attendance_records` VALUES (7, 5, 45, '2026-05-23 08:55:00', '2026-05-23 18:15:00', '2026-05-23', 4, '2026-05-28 11:05:05');
INSERT INTO `attendance_records` VALUES (8, 5, 46, '2026-05-23 09:02:00', '2026-05-23 17:30:00', '2026-05-23', 3, '2026-05-28 11:05:05');
INSERT INTO `attendance_records` VALUES (9, 5, 43, '2026-05-24 08:48:00', '2026-05-24 18:12:00', '2026-05-24', 4, '2026-05-28 11:05:05');
INSERT INTO `attendance_records` VALUES (10, 5, 44, '2026-05-24 09:05:00', '2026-05-24 18:00:00', '2026-05-24', 2, '2026-05-28 11:05:05');
INSERT INTO `attendance_records` VALUES (11, 5, 45, '2026-05-24 08:50:00', '2026-05-24 18:20:00', '2026-05-24', 4, '2026-05-28 11:05:05');
INSERT INTO `attendance_records` VALUES (12, 5, 46, '2026-05-24 08:55:00', '2026-05-24 18:05:00', '2026-05-24', 1, '2026-05-28 11:05:05');
INSERT INTO `attendance_records` VALUES (13, 5, 43, '2026-05-25 09:10:00', '2026-05-25 18:00:00', '2026-05-25', 2, '2026-05-28 11:05:05');
INSERT INTO `attendance_records` VALUES (14, 5, 44, '2026-05-25 08:58:00', '2026-05-25 18:30:00', '2026-05-25', 4, '2026-05-28 11:05:05');
INSERT INTO `attendance_records` VALUES (15, 5, 45, '2026-05-25 08:52:00', '2026-05-25 18:10:00', '2026-05-25', 1, '2026-05-28 11:05:05');
INSERT INTO `attendance_records` VALUES (16, 5, 46, '2026-05-25 09:00:00', '2026-05-25 18:00:00', '2026-05-25', 1, '2026-05-28 11:05:05');
INSERT INTO `attendance_records` VALUES (17, 5, 43, '2026-05-26 08:45:00', '2026-05-26 18:15:00', '2026-05-26', 4, '2026-05-28 11:05:05');
INSERT INTO `attendance_records` VALUES (18, 5, 44, '2026-05-26 09:00:00', '2026-05-26 18:05:00', '2026-05-26', 1, '2026-05-28 11:05:05');
INSERT INTO `attendance_records` VALUES (19, 5, 45, '2026-05-26 08:55:00', '2026-05-26 18:08:00', '2026-05-26', 1, '2026-05-28 11:05:05');
INSERT INTO `attendance_records` VALUES (20, 5, 46, '2026-05-26 09:12:00', '2026-05-26 18:00:00', '2026-05-26', 2, '2026-05-28 11:05:05');
INSERT INTO `attendance_records` VALUES (21, 5, 43, '2026-05-27 08:50:00', '2026-05-27 18:10:00', '2026-05-27', 1, '2026-05-28 11:05:05');
INSERT INTO `attendance_records` VALUES (22, 5, 44, '2026-05-27 08:55:00', '2026-05-27 18:00:00', '2026-05-27', 1, '2026-05-28 11:05:05');
INSERT INTO `attendance_records` VALUES (23, 5, 45, '2026-05-27 09:00:00', '2026-05-27 18:05:00', '2026-05-27', 1, '2026-05-28 11:05:05');
INSERT INTO `attendance_records` VALUES (24, 5, 46, '2026-05-27 08:58:00', '2026-05-27 18:12:00', '2026-05-27', 1, '2026-05-28 11:05:05');
INSERT INTO `attendance_records` VALUES (25, 5, 43, '2026-05-28 08:48:00', '2026-05-28 18:20:00', '2026-05-28', 4, '2026-05-28 11:05:05');
INSERT INTO `attendance_records` VALUES (26, 5, 44, '2026-05-28 09:02:00', '2026-05-28 18:00:00', '2026-05-28', 2, '2026-05-28 11:05:05');
INSERT INTO `attendance_records` VALUES (27, 5, 45, '2026-05-28 08:52:00', '2026-05-28 18:08:00', '2026-05-28', 1, '2026-05-28 11:05:05');
INSERT INTO `attendance_records` VALUES (28, 5, 46, '2026-05-28 08:55:00', '2026-05-28 18:05:00', '2026-05-28', 1, '2026-05-28 11:05:05');
INSERT INTO `attendance_records` VALUES (29, 5, 43, '2026-05-09 08:55:00', '2026-05-09 18:05:00', '2026-05-09', 1, '2026-05-09 08:55:00');
INSERT INTO `attendance_records` VALUES (30, 5, 44, '2026-05-09 09:10:00', '2026-05-09 18:00:00', '2026-05-09', 2, '2026-05-09 09:10:00');
INSERT INTO `attendance_records` VALUES (31, 5, 45, '2026-05-09 08:50:00', '2026-05-09 18:10:00', '2026-05-09', 1, '2026-05-09 08:50:00');
INSERT INTO `attendance_records` VALUES (32, 5, 46, '2026-05-09 08:58:00', '2026-05-09 18:02:00', '2026-05-09', 1, '2026-05-09 08:58:00');
INSERT INTO `attendance_records` VALUES (33, 5, 43, '2026-05-10 08:52:00', '2026-05-10 18:08:00', '2026-05-10', 1, '2026-05-10 08:52:00');
INSERT INTO `attendance_records` VALUES (34, 5, 44, '2026-05-10 09:00:00', '2026-05-10 18:05:00', '2026-05-10', 1, '2026-05-10 09:00:00');
INSERT INTO `attendance_records` VALUES (35, 5, 45, '2026-05-10 08:55:00', '2026-05-10 18:15:00', '2026-05-10', 4, '2026-05-10 08:55:00');
INSERT INTO `attendance_records` VALUES (36, 5, 46, '2026-05-10 09:02:00', '2026-05-10 17:30:00', '2026-05-10', 3, '2026-05-10 09:02:00');
INSERT INTO `attendance_records` VALUES (37, 5, 43, '2026-05-11 08:48:00', '2026-05-11 18:12:00', '2026-05-11', 4, '2026-05-11 08:48:00');
INSERT INTO `attendance_records` VALUES (38, 5, 44, '2026-05-11 09:05:00', '2026-05-11 18:00:00', '2026-05-11', 2, '2026-05-11 09:05:00');
INSERT INTO `attendance_records` VALUES (39, 5, 45, '2026-05-11 08:50:00', '2026-05-11 18:20:00', '2026-05-11', 4, '2026-05-11 08:50:00');
INSERT INTO `attendance_records` VALUES (40, 5, 46, '2026-05-11 08:55:00', '2026-05-11 18:05:00', '2026-05-11', 1, '2026-05-11 08:55:00');
INSERT INTO `attendance_records` VALUES (41, 5, 43, '2026-05-12 09:10:00', '2026-05-12 18:00:00', '2026-05-12', 2, '2026-05-12 09:10:00');
INSERT INTO `attendance_records` VALUES (42, 5, 44, '2026-05-12 08:58:00', '2026-05-12 18:30:00', '2026-05-12', 4, '2026-05-12 08:58:00');
INSERT INTO `attendance_records` VALUES (43, 5, 45, '2026-05-12 08:52:00', '2026-05-12 18:10:00', '2026-05-12', 1, '2026-05-12 08:52:00');
INSERT INTO `attendance_records` VALUES (44, 5, 46, '2026-05-12 09:00:00', '2026-05-12 18:00:00', '2026-05-12', 1, '2026-05-12 09:00:00');
INSERT INTO `attendance_records` VALUES (45, 5, 43, '2026-05-13 08:45:00', '2026-05-13 18:15:00', '2026-05-13', 4, '2026-05-13 08:45:00');
INSERT INTO `attendance_records` VALUES (46, 5, 44, '2026-05-13 09:00:00', '2026-05-13 18:05:00', '2026-05-13', 1, '2026-05-13 09:00:00');
INSERT INTO `attendance_records` VALUES (47, 5, 45, '2026-05-13 08:55:00', '2026-05-13 18:08:00', '2026-05-13', 1, '2026-05-13 08:55:00');
INSERT INTO `attendance_records` VALUES (48, 5, 46, '2026-05-13 09:12:00', '2026-05-13 18:00:00', '2026-05-13', 2, '2026-05-13 09:12:00');
INSERT INTO `attendance_records` VALUES (49, 5, 43, '2026-05-14 08:50:00', '2026-05-14 18:10:00', '2026-05-14', 1, '2026-05-14 08:50:00');
INSERT INTO `attendance_records` VALUES (50, 5, 44, '2026-05-14 08:55:00', '2026-05-14 18:00:00', '2026-05-14', 1, '2026-05-14 08:55:00');
INSERT INTO `attendance_records` VALUES (51, 5, 45, '2026-05-14 09:00:00', '2026-05-14 18:05:00', '2026-05-14', 1, '2026-05-14 09:00:00');
INSERT INTO `attendance_records` VALUES (52, 5, 46, '2026-05-14 08:58:00', '2026-05-14 18:12:00', '2026-05-14', 1, '2026-05-14 08:58:00');
INSERT INTO `attendance_records` VALUES (53, 5, 43, '2026-05-15 08:48:00', '2026-05-15 18:20:00', '2026-05-15', 4, '2026-05-15 08:48:00');
INSERT INTO `attendance_records` VALUES (54, 5, 44, '2026-05-15 09:02:00', '2026-05-15 18:00:00', '2026-05-15', 2, '2026-05-15 09:02:00');
INSERT INTO `attendance_records` VALUES (55, 5, 45, '2026-05-15 08:52:00', '2026-05-15 18:08:00', '2026-05-15', 1, '2026-05-15 08:52:00');
INSERT INTO `attendance_records` VALUES (56, 5, 46, '2026-05-15 08:55:00', '2026-05-15 18:05:00', '2026-05-15', 1, '2026-05-15 08:55:00');
INSERT INTO `attendance_records` VALUES (57, 5, 43, '2026-05-16 08:55:00', '2026-05-16 18:05:00', '2026-05-16', 1, '2026-05-16 08:55:00');
INSERT INTO `attendance_records` VALUES (58, 5, 44, '2026-05-16 09:10:00', '2026-05-16 18:00:00', '2026-05-16', 2, '2026-05-16 09:10:00');
INSERT INTO `attendance_records` VALUES (59, 5, 45, '2026-05-16 08:50:00', '2026-05-16 18:10:00', '2026-05-16', 1, '2026-05-16 08:50:00');
INSERT INTO `attendance_records` VALUES (60, 5, 46, '2026-05-16 08:58:00', '2026-05-16 18:02:00', '2026-05-16', 1, '2026-05-16 08:58:00');
INSERT INTO `attendance_records` VALUES (61, 5, 43, '2026-05-17 08:52:00', '2026-05-17 18:08:00', '2026-05-17', 1, '2026-05-17 08:52:00');
INSERT INTO `attendance_records` VALUES (62, 5, 44, '2026-05-17 09:00:00', '2026-05-17 18:05:00', '2026-05-17', 1, '2026-05-17 09:00:00');
INSERT INTO `attendance_records` VALUES (63, 5, 45, '2026-05-17 08:55:00', '2026-05-17 18:15:00', '2026-05-17', 4, '2026-05-17 08:55:00');
INSERT INTO `attendance_records` VALUES (64, 5, 46, '2026-05-17 09:02:00', '2026-05-17 17:30:00', '2026-05-17', 3, '2026-05-17 09:02:00');
INSERT INTO `attendance_records` VALUES (65, 5, 43, '2026-05-18 08:48:00', '2026-05-18 18:12:00', '2026-05-18', 4, '2026-05-18 08:48:00');
INSERT INTO `attendance_records` VALUES (66, 5, 44, '2026-05-18 09:05:00', '2026-05-18 18:00:00', '2026-05-18', 2, '2026-05-18 09:05:00');
INSERT INTO `attendance_records` VALUES (67, 5, 45, '2026-05-18 08:50:00', '2026-05-18 18:20:00', '2026-05-18', 4, '2026-05-18 08:50:00');
INSERT INTO `attendance_records` VALUES (68, 5, 46, '2026-05-18 08:55:00', '2026-05-18 18:05:00', '2026-05-18', 1, '2026-05-18 08:55:00');
INSERT INTO `attendance_records` VALUES (69, 5, 43, '2026-05-19 09:10:00', '2026-05-19 18:00:00', '2026-05-19', 2, '2026-05-19 09:10:00');
INSERT INTO `attendance_records` VALUES (70, 5, 44, '2026-05-19 08:58:00', '2026-05-19 18:30:00', '2026-05-19', 4, '2026-05-19 08:58:00');
INSERT INTO `attendance_records` VALUES (71, 5, 45, '2026-05-19 08:52:00', '2026-05-19 18:10:00', '2026-05-19', 1, '2026-05-19 08:52:00');
INSERT INTO `attendance_records` VALUES (72, 5, 46, '2026-05-19 09:00:00', '2026-05-19 18:00:00', '2026-05-19', 1, '2026-05-19 09:00:00');
INSERT INTO `attendance_records` VALUES (73, 5, 43, '2026-05-20 08:45:00', '2026-05-20 18:15:00', '2026-05-20', 4, '2026-05-20 08:45:00');
INSERT INTO `attendance_records` VALUES (74, 5, 44, '2026-05-20 09:00:00', '2026-05-20 18:05:00', '2026-05-20', 1, '2026-05-20 09:00:00');
INSERT INTO `attendance_records` VALUES (75, 5, 45, '2026-05-20 08:55:00', '2026-05-20 18:08:00', '2026-05-20', 1, '2026-05-20 08:55:00');
INSERT INTO `attendance_records` VALUES (76, 5, 46, '2026-05-20 09:12:00', '2026-05-20 18:00:00', '2026-05-20', 2, '2026-05-20 09:12:00');
INSERT INTO `attendance_records` VALUES (77, 5, 43, '2026-05-21 08:50:00', '2026-05-21 18:10:00', '2026-05-21', 1, '2026-05-21 08:50:00');
INSERT INTO `attendance_records` VALUES (78, 5, 44, '2026-05-21 08:55:00', '2026-05-21 18:00:00', '2026-05-21', 1, '2026-05-21 08:55:00');
INSERT INTO `attendance_records` VALUES (79, 5, 45, '2026-05-21 09:00:00', '2026-05-21 18:05:00', '2026-05-21', 1, '2026-05-21 09:00:00');
INSERT INTO `attendance_records` VALUES (80, 5, 46, '2026-05-21 08:58:00', '2026-05-21 18:12:00', '2026-05-21', 1, '2026-05-21 08:58:00');
INSERT INTO `attendance_records` VALUES (81, 5, 43, '2026-05-22 08:48:00', '2026-05-22 18:20:00', '2026-05-22', 4, '2026-05-22 08:48:00');
INSERT INTO `attendance_records` VALUES (82, 5, 44, '2026-05-22 09:02:00', '2026-05-22 18:00:00', '2026-05-22', 2, '2026-05-22 09:02:00');
INSERT INTO `attendance_records` VALUES (83, 5, 45, '2026-05-22 08:52:00', '2026-05-22 18:08:00', '2026-05-22', 1, '2026-05-22 08:52:00');
INSERT INTO `attendance_records` VALUES (84, 5, 46, '2026-05-22 08:55:00', '2026-05-22 18:05:00', '2026-05-22', 1, '2026-05-22 08:55:00');
INSERT INTO `attendance_records` VALUES (85, 5, 43, '2026-05-23 08:55:00', '2026-05-23 18:05:00', '2026-05-23', 1, '2026-05-23 08:55:00');
INSERT INTO `attendance_records` VALUES (86, 5, 44, '2026-05-23 09:08:00', '2026-05-23 18:00:00', '2026-05-23', 2, '2026-05-23 09:08:00');
INSERT INTO `attendance_records` VALUES (87, 5, 45, '2026-05-23 08:50:00', '2026-05-23 18:10:00', '2026-05-23', 1, '2026-05-23 08:50:00');
INSERT INTO `attendance_records` VALUES (88, 5, 46, '2026-05-23 08:58:00', '2026-05-23 18:02:00', '2026-05-23', 1, '2026-05-23 08:58:00');
INSERT INTO `attendance_records` VALUES (89, 5, 43, '2026-05-24 08:52:00', '2026-05-24 18:08:00', '2026-05-24', 1, '2026-05-24 08:52:00');
INSERT INTO `attendance_records` VALUES (90, 5, 44, '2026-05-24 09:00:00', '2026-05-24 18:05:00', '2026-05-24', 1, '2026-05-24 09:00:00');
INSERT INTO `attendance_records` VALUES (91, 5, 45, '2026-05-24 08:55:00', '2026-05-24 18:15:00', '2026-05-24', 4, '2026-05-24 08:55:00');
INSERT INTO `attendance_records` VALUES (92, 5, 46, '2026-05-24 09:02:00', '2026-05-24 17:30:00', '2026-05-24', 3, '2026-05-24 09:02:00');
INSERT INTO `attendance_records` VALUES (93, 5, 43, '2026-05-25 08:48:00', '2026-05-25 18:12:00', '2026-05-25', 4, '2026-05-25 08:48:00');
INSERT INTO `attendance_records` VALUES (94, 5, 44, '2026-05-25 09:05:00', '2026-05-25 18:00:00', '2026-05-25', 2, '2026-05-25 09:05:00');
INSERT INTO `attendance_records` VALUES (95, 5, 45, '2026-05-25 08:50:00', '2026-05-25 18:20:00', '2026-05-25', 4, '2026-05-25 08:50:00');
INSERT INTO `attendance_records` VALUES (96, 5, 46, '2026-05-25 08:55:00', '2026-05-25 18:05:00', '2026-05-25', 1, '2026-05-25 08:55:00');
INSERT INTO `attendance_records` VALUES (97, 5, 43, '2026-05-26 09:10:00', '2026-05-26 18:00:00', '2026-05-26', 2, '2026-05-26 09:10:00');
INSERT INTO `attendance_records` VALUES (98, 5, 44, '2026-05-26 08:58:00', '2026-05-26 18:30:00', '2026-05-26', 4, '2026-05-26 08:58:00');
INSERT INTO `attendance_records` VALUES (99, 5, 45, '2026-05-26 08:52:00', '2026-05-26 18:10:00', '2026-05-26', 1, '2026-05-26 08:52:00');
INSERT INTO `attendance_records` VALUES (100, 5, 46, '2026-05-26 09:00:00', '2026-05-26 18:00:00', '2026-05-26', 1, '2026-05-26 09:00:00');
INSERT INTO `attendance_records` VALUES (101, 5, 43, '2026-05-27 08:45:00', '2026-05-27 18:15:00', '2026-05-27', 4, '2026-05-27 08:45:00');
INSERT INTO `attendance_records` VALUES (102, 5, 44, '2026-05-27 09:00:00', '2026-05-27 18:05:00', '2026-05-27', 1, '2026-05-27 09:00:00');
INSERT INTO `attendance_records` VALUES (103, 5, 45, '2026-05-27 08:55:00', '2026-05-27 18:08:00', '2026-05-27', 1, '2026-05-27 08:55:00');
INSERT INTO `attendance_records` VALUES (104, 5, 46, '2026-05-27 09:12:00', '2026-05-27 18:00:00', '2026-05-27', 2, '2026-05-27 09:12:00');
INSERT INTO `attendance_records` VALUES (105, 5, 43, '2026-05-28 08:50:00', '2026-05-28 18:10:00', '2026-05-28', 1, '2026-05-28 08:50:00');
INSERT INTO `attendance_records` VALUES (106, 5, 44, '2026-05-28 08:55:00', '2026-05-28 18:00:00', '2026-05-28', 1, '2026-05-28 08:55:00');
INSERT INTO `attendance_records` VALUES (107, 5, 45, '2026-05-28 09:00:00', '2026-05-28 18:05:00', '2026-05-28', 1, '2026-05-28 09:00:00');
INSERT INTO `attendance_records` VALUES (108, 5, 46, '2026-05-28 08:58:00', '2026-05-28 18:12:00', '2026-05-28', 1, '2026-05-28 08:58:00');
INSERT INTO `attendance_records` VALUES (109, 5, 43, '2026-05-29 08:48:00', '2026-05-29 18:20:00', '2026-05-29', 4, '2026-05-29 08:48:00');
INSERT INTO `attendance_records` VALUES (110, 5, 44, '2026-05-29 09:02:00', '2026-05-29 18:00:00', '2026-05-29', 2, '2026-05-29 09:02:00');
INSERT INTO `attendance_records` VALUES (111, 5, 45, '2026-05-29 08:52:00', '2026-05-29 18:08:00', '2026-05-29', 1, '2026-05-29 08:52:00');
INSERT INTO `attendance_records` VALUES (112, 5, 46, '2026-05-29 08:55:00', '2026-05-29 18:05:00', '2026-05-29', 1, '2026-05-29 08:55:00');
INSERT INTO `attendance_records` VALUES (113, 5, 43, '2026-05-30 08:55:00', '2026-05-30 18:05:00', '2026-05-30', 1, '2026-05-30 08:55:00');
INSERT INTO `attendance_records` VALUES (114, 5, 44, '2026-05-30 09:10:00', '2026-05-30 18:00:00', '2026-05-30', 2, '2026-05-30 09:10:00');
INSERT INTO `attendance_records` VALUES (115, 5, 45, '2026-05-30 08:50:00', '2026-05-30 18:10:00', '2026-05-30', 1, '2026-05-30 08:50:00');
INSERT INTO `attendance_records` VALUES (116, 5, 46, '2026-05-30 08:58:00', '2026-05-30 18:02:00', '2026-05-30', 1, '2026-05-30 08:58:00');
INSERT INTO `attendance_records` VALUES (117, 5, 43, '2026-05-31 08:52:00', '2026-05-31 18:08:00', '2026-05-31', 1, '2026-05-31 08:52:00');
INSERT INTO `attendance_records` VALUES (118, 5, 44, '2026-05-31 09:00:00', '2026-05-31 18:05:00', '2026-05-31', 1, '2026-05-31 09:00:00');
INSERT INTO `attendance_records` VALUES (119, 5, 45, '2026-05-31 08:55:00', '2026-05-31 18:15:00', '2026-05-31', 4, '2026-05-31 08:55:00');
INSERT INTO `attendance_records` VALUES (120, 5, 46, '2026-05-31 09:02:00', '2026-05-31 17:30:00', '2026-05-31', 3, '2026-05-31 09:02:00');
INSERT INTO `attendance_records` VALUES (121, 5, 43, '2026-06-01 08:48:00', '2026-06-01 18:12:00', '2026-06-01', 4, '2026-06-01 08:48:00');
INSERT INTO `attendance_records` VALUES (122, 5, 44, '2026-06-01 09:05:00', '2026-06-01 18:00:00', '2026-06-01', 2, '2026-06-01 09:05:00');
INSERT INTO `attendance_records` VALUES (123, 5, 45, '2026-06-01 08:50:00', '2026-06-01 18:20:00', '2026-06-01', 4, '2026-06-01 08:50:00');
INSERT INTO `attendance_records` VALUES (124, 5, 46, '2026-06-01 08:55:00', '2026-06-01 18:05:00', '2026-06-01', 1, '2026-06-01 08:55:00');
INSERT INTO `attendance_records` VALUES (125, 5, 43, '2026-06-02 09:10:00', '2026-06-02 18:00:00', '2026-06-02', 2, '2026-06-02 09:10:00');
INSERT INTO `attendance_records` VALUES (126, 5, 44, '2026-06-02 08:58:00', '2026-06-02 18:30:00', '2026-06-02', 4, '2026-06-02 08:58:00');
INSERT INTO `attendance_records` VALUES (127, 5, 45, '2026-06-02 08:52:00', '2026-06-02 18:10:00', '2026-06-02', 1, '2026-06-02 08:52:00');
INSERT INTO `attendance_records` VALUES (128, 5, 46, '2026-06-02 09:00:00', '2026-06-02 18:00:00', '2026-06-02', 1, '2026-06-02 09:00:00');
INSERT INTO `attendance_records` VALUES (129, 5, 43, '2026-06-03 08:45:00', '2026-06-03 18:15:00', '2026-06-03', 4, '2026-06-03 08:45:00');
INSERT INTO `attendance_records` VALUES (130, 5, 44, '2026-06-03 09:00:00', '2026-06-03 18:05:00', '2026-06-03', 1, '2026-06-03 09:00:00');
INSERT INTO `attendance_records` VALUES (131, 5, 45, '2026-06-03 08:55:00', '2026-06-03 18:08:00', '2026-06-03', 1, '2026-06-03 08:55:00');
INSERT INTO `attendance_records` VALUES (132, 5, 46, '2026-06-03 09:12:00', '2026-06-03 18:00:00', '2026-06-03', 2, '2026-06-03 09:12:00');
INSERT INTO `attendance_records` VALUES (133, 5, 43, '2026-06-04 08:50:00', '2026-06-04 18:10:00', '2026-06-04', 1, '2026-06-04 08:50:00');
INSERT INTO `attendance_records` VALUES (134, 5, 44, '2026-06-04 08:55:00', '2026-06-04 18:00:00', '2026-06-04', 1, '2026-06-04 08:55:00');
INSERT INTO `attendance_records` VALUES (135, 5, 45, '2026-06-04 09:00:00', '2026-06-04 18:05:00', '2026-06-04', 1, '2026-06-04 09:00:00');
INSERT INTO `attendance_records` VALUES (136, 5, 46, '2026-06-04 08:58:00', '2026-06-04 18:12:00', '2026-06-04', 1, '2026-06-04 08:58:00');
INSERT INTO `attendance_records` VALUES (137, 5, 43, '2026-06-05 08:48:00', '2026-06-05 18:20:00', '2026-06-05', 4, '2026-06-05 08:48:00');
INSERT INTO `attendance_records` VALUES (138, 5, 44, '2026-06-05 09:02:00', '2026-06-05 18:00:00', '2026-06-05', 2, '2026-06-05 09:02:00');
INSERT INTO `attendance_records` VALUES (139, 5, 45, '2026-06-05 08:52:00', '2026-06-05 18:08:00', '2026-06-05', 1, '2026-06-05 08:52:00');
INSERT INTO `attendance_records` VALUES (140, 5, 46, '2026-06-05 08:55:00', '2026-06-05 18:05:00', '2026-06-05', 1, '2026-06-05 08:55:00');
INSERT INTO `attendance_records` VALUES (141, 5, 43, '2026-06-06 08:55:00', '2026-06-06 18:05:00', '2026-06-06', 1, '2026-06-06 08:55:00');
INSERT INTO `attendance_records` VALUES (142, 5, 44, '2026-06-06 09:10:00', '2026-06-06 18:00:00', '2026-06-06', 2, '2026-06-06 09:10:00');
INSERT INTO `attendance_records` VALUES (143, 5, 45, '2026-06-06 08:50:00', '2026-06-06 18:10:00', '2026-06-06', 1, '2026-06-06 08:50:00');
INSERT INTO `attendance_records` VALUES (144, 5, 46, '2026-06-06 08:58:00', '2026-06-06 18:02:00', '2026-06-06', 1, '2026-06-06 08:58:00');
INSERT INTO `attendance_records` VALUES (145, 5, 43, '2026-06-07 08:52:00', '2026-06-07 18:08:00', '2026-06-07', 1, '2026-06-07 08:52:00');
INSERT INTO `attendance_records` VALUES (146, 5, 44, '2026-06-07 09:00:00', '2026-06-07 18:05:00', '2026-06-07', 1, '2026-06-07 09:00:00');
INSERT INTO `attendance_records` VALUES (147, 5, 45, '2026-06-07 08:55:00', '2026-06-07 18:15:00', '2026-06-07', 4, '2026-06-07 08:55:00');
INSERT INTO `attendance_records` VALUES (148, 5, 46, '2026-06-07 09:02:00', '2026-06-07 17:30:00', '2026-06-07', 3, '2026-06-07 09:02:00');
INSERT INTO `attendance_records` VALUES (149, 5, 43, '2026-06-08 08:48:00', '2026-06-08 18:12:00', '2026-06-08', 4, '2026-06-08 08:48:00');
INSERT INTO `attendance_records` VALUES (150, 5, 44, '2026-06-08 09:05:00', '2026-06-08 18:00:00', '2026-06-08', 2, '2026-06-08 09:05:00');
INSERT INTO `attendance_records` VALUES (151, 5, 45, '2026-06-08 08:50:00', '2026-06-08 18:20:00', '2026-06-08', 4, '2026-06-08 08:50:00');
INSERT INTO `attendance_records` VALUES (152, 5, 46, '2026-06-08 08:55:00', '2026-06-08 18:05:00', '2026-06-08', 1, '2026-06-08 08:55:00');
INSERT INTO `attendance_records` VALUES (153, 5, 43, '2026-06-09 09:10:00', '2026-06-09 18:00:00', '2026-06-09', 2, '2026-06-09 09:10:00');
INSERT INTO `attendance_records` VALUES (154, 5, 44, '2026-06-09 08:58:00', '2026-06-09 18:30:00', '2026-06-09', 4, '2026-06-09 08:58:00');
INSERT INTO `attendance_records` VALUES (155, 5, 45, '2026-06-09 08:52:00', '2026-06-09 18:10:00', '2026-06-09', 1, '2026-06-09 08:52:00');
INSERT INTO `attendance_records` VALUES (156, 5, 46, '2026-06-09 09:00:00', '2026-06-09 18:00:00', '2026-06-09', 1, '2026-06-09 09:00:00');

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
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '提成规则' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of commission_rules
-- ----------------------------
INSERT INTO `commission_rules` VALUES (1, 5, 4, 1, 1.00, NULL, 1, '2026-05-22 13:27:12', 0, NULL);
INSERT INTO `commission_rules` VALUES (2, 5, 5, 3, 300.00, NULL, 1, '2026-05-22 14:46:10', 0, NULL);
INSERT INTO `commission_rules` VALUES (3, 5, 6, 3, 200.00, NULL, 1, '2026-05-22 14:46:44', 0, NULL);
INSERT INTO `commission_rules` VALUES (4, 5, 4, 1, 5.00, '导玩员按次提成5元/次', 1, '2026-05-28 11:03:28', 0, NULL);
INSERT INTO `commission_rules` VALUES (5, 5, 4, 2, 3.00, '导玩员按流水3%提成', 1, '2026-05-28 11:03:28', 0, NULL);

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
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '员工提成结算' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of commission_settlements
-- ----------------------------
INSERT INTO `commission_settlements` VALUES (1, 5, 9, '2026-05', 3, 53.44, 15.00, 2, NULL, '[]', '2026-05-22 13:35:27', 0, NULL, 4);
INSERT INTO `commission_settlements` VALUES (2, 5, 43, '2026-05', 4, 59.81, 20.00, 1, '5月第1-2周导玩提成', NULL, '2026-05-28 11:03:30', 0, NULL, NULL);
INSERT INTO `commission_settlements` VALUES (3, 5, 44, '2026-05', 3, 64.07, 15.00, 1, '5月第1-2周导玩提成', NULL, '2026-05-28 11:03:30', 0, NULL, NULL);
INSERT INTO `commission_settlements` VALUES (4, 5, 43, '2026-04', 0, 0.00, 0.00, 2, '4月导玩提成（无数据）', NULL, '2026-05-28 11:03:30', 0, NULL, NULL);
INSERT INTO `commission_settlements` VALUES (5, 5, 43, '2026-05', 12, 239.28, 60.00, 2, '5月导玩员提成（按次）', NULL, '2026-06-01 10:00:00', 0, NULL, NULL);
INSERT INTO `commission_settlements` VALUES (6, 5, 44, '2026-05', 11, 219.37, 55.00, 2, '5月导玩员提成（按次）', NULL, '2026-06-01 10:00:00', 0, NULL, NULL);
INSERT INTO `commission_settlements` VALUES (7, 5, 43, '2026-06-01', 3, 84.80, 15.00, 1, '6月第1周提成', NULL, '2026-06-08 10:00:00', 0, NULL, NULL);
INSERT INTO `commission_settlements` VALUES (8, 5, 44, '2026-06-01', 3, 79.80, 15.00, 1, '6月第1周提成', NULL, '2026-06-08 10:00:00', 0, NULL, NULL);
INSERT INTO `commission_settlements` VALUES (9, 5, 45, '2026-05', 0, 0.00, 0.00, 2, '5月仓管无提成', NULL, '2026-06-01 10:00:00', 0, NULL, NULL);
INSERT INTO `commission_settlements` VALUES (10, 5, 46, '2026-05', 0, 0.00, 0.00, 2, '5月财务无提成', NULL, '2026-06-01 10:00:00', 0, NULL, NULL);

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
) ENGINE = InnoDB AUTO_INCREMENT = 32 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '优惠券领取与使用记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of coupon_usages
-- ----------------------------
INSERT INTO `coupon_usages` VALUES (2, 5, 1, 17, 1, '2026-05-23 13:37:26', NULL, NULL, '2026-06-22 13:37:26', 0, NULL);
INSERT INTO `coupon_usages` VALUES (3, 5, 2, 3, 1, '2026-05-23 14:18:20', NULL, NULL, '2026-06-22 14:18:20', 0, NULL);
INSERT INTO `coupon_usages` VALUES (4, 5, 2, 14, 2, '2026-05-23 14:18:20', '2026-05-23 15:00:20', 5, '2026-06-22 14:18:20', 0, NULL);
INSERT INTO `coupon_usages` VALUES (5, 5, 1, 18, 1, '2026-05-27 14:06:05', NULL, NULL, '2026-06-26 14:06:05', 0, NULL);
INSERT INTO `coupon_usages` VALUES (6, 5, 3, 19, 1, '2026-05-01 10:00:00', NULL, NULL, '2026-06-30 23:59:59', 0, NULL);
INSERT INTO `coupon_usages` VALUES (7, 5, 3, 21, 1, '2026-05-03 09:15:00', NULL, NULL, '2026-06-30 23:59:59', 0, NULL);
INSERT INTO `coupon_usages` VALUES (8, 5, 4, 23, 1, '2026-05-05 11:30:00', NULL, NULL, '2026-07-31 23:59:59', 0, NULL);
INSERT INTO `coupon_usages` VALUES (9, 5, 3, 28, 1, '2026-05-12 11:30:00', NULL, NULL, '2026-06-30 23:59:59', 0, NULL);
INSERT INTO `coupon_usages` VALUES (10, 5, 4, 27, 1, '2026-05-10 09:45:00', NULL, NULL, '2026-07-31 23:59:59', 0, NULL);
INSERT INTO `coupon_usages` VALUES (11, 5, 5, 29, 1, '2026-05-15 10:00:00', NULL, NULL, '2026-06-30 23:59:59', 0, NULL);
INSERT INTO `coupon_usages` VALUES (12, 5, 6, 34, 3, '2026-05-25 10:30:00', NULL, NULL, '2026-06-01 23:59:59', 0, NULL);
INSERT INTO `coupon_usages` VALUES (13, 5, 6, 35, 2, '2026-05-25 11:00:00', NULL, NULL, '2026-06-01 23:59:59', 0, NULL);
INSERT INTO `coupon_usages` VALUES (14, 5, 6, 36, 3, '2026-05-25 14:00:00', NULL, NULL, '2026-06-01 23:59:59', 0, NULL);
INSERT INTO `coupon_usages` VALUES (15, 5, 6, 39, 3, '2026-05-26 09:00:00', NULL, NULL, '2026-06-02 23:59:59', 0, NULL);
INSERT INTO `coupon_usages` VALUES (16, 5, 6, 40, 2, '2026-05-26 10:00:00', NULL, NULL, '2026-06-02 23:59:59', 0, NULL);
INSERT INTO `coupon_usages` VALUES (17, 5, 6, 43, 3, '2026-05-27 11:00:00', NULL, NULL, '2026-06-03 23:59:59', 0, NULL);
INSERT INTO `coupon_usages` VALUES (18, 5, 6, 44, 3, '2026-05-27 14:00:00', NULL, NULL, '2026-06-03 23:59:59', 0, NULL);
INSERT INTO `coupon_usages` VALUES (19, 5, 7, 37, 3, '2026-05-28 10:30:00', NULL, NULL, '2026-06-12 23:59:59', 0, NULL);
INSERT INTO `coupon_usages` VALUES (20, 5, 7, 41, 3, '2026-05-28 11:00:00', NULL, NULL, '2026-06-12 23:59:59', 0, NULL);
INSERT INTO `coupon_usages` VALUES (21, 5, 7, 47, 3, '2026-05-29 09:00:00', NULL, NULL, '2026-06-13 23:59:59', 0, NULL);
INSERT INTO `coupon_usages` VALUES (22, 5, 8, 35, 2, '2026-06-01 10:00:00', NULL, NULL, '2026-07-01 23:59:59', 0, NULL);
INSERT INTO `coupon_usages` VALUES (23, 5, 8, 38, 1, '2026-06-01 10:30:00', NULL, NULL, '2026-07-01 23:59:59', 0, NULL);
INSERT INTO `coupon_usages` VALUES (24, 5, 8, 42, 1, '2026-06-01 11:00:00', NULL, NULL, '2026-07-01 23:59:59', 0, NULL);
INSERT INTO `coupon_usages` VALUES (25, 5, 8, 45, 1, '2026-06-01 14:00:00', NULL, NULL, '2026-07-01 23:59:59', 0, NULL);
INSERT INTO `coupon_usages` VALUES (26, 5, 8, 46, 1, '2026-06-02 09:00:00', NULL, NULL, '2026-07-02 23:59:59', 0, NULL);
INSERT INTO `coupon_usages` VALUES (27, 5, 8, 48, 1, '2026-06-02 10:00:00', NULL, NULL, '2026-07-02 23:59:59', 0, NULL);
INSERT INTO `coupon_usages` VALUES (28, 5, 1, 34, 1, '2026-06-03 10:00:00', NULL, NULL, '2026-07-03 23:59:59', 0, NULL);
INSERT INTO `coupon_usages` VALUES (29, 5, 1, 36, 1, '2026-06-03 11:00:00', NULL, NULL, '2026-07-03 23:59:59', 0, NULL);
INSERT INTO `coupon_usages` VALUES (30, 5, 5, 39, 1, '2026-06-05 09:00:00', NULL, NULL, '2026-07-05 23:59:59', 0, NULL);
INSERT INTO `coupon_usages` VALUES (31, 5, 5, 44, 1, '2026-06-05 10:00:00', NULL, NULL, '2026-07-05 23:59:59', 0, NULL);

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
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '第三方券码核销日志' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of coupon_verification_logs
-- ----------------------------
INSERT INTO `coupon_verification_logs` VALUES (1, 5, 2, '1234567890', 'douyin', 2, 1, NULL, 9, '2026-05-21 14:50:02', 0, NULL);
INSERT INTO `coupon_verification_logs` VALUES (2, 5, 7, 'MT202605020001', 'meituan', 1, 1, NULL, 43, '2026-05-28 11:07:26', 0, NULL);
INSERT INTO `coupon_verification_logs` VALUES (3, 5, 9, 'DY202605040001', 'douyin', 1, 4, NULL, 44, '2026-05-28 11:07:26', 0, NULL);

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
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '优惠券定义' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of coupons
-- ----------------------------
INSERT INTO `coupons` VALUES (1, 5, '5元优惠券（新人福利）', '5元无门槛优惠券', 1, 'purchase', 5.00, 0.00, 99999, 1, 99997, 30, 1, 1, '2026-05-23 13:21:15', '2026-05-27 14:06:04', 0, NULL);
INSERT INTO `coupons` VALUES (2, 5, '100 - 20充值优惠券', '充值100元可抵扣20元', 1, 'recharge', 20.00, 100.00, 9999, 100, 9997, 30, 1, 0, '2026-05-23 14:12:57', '2026-05-23 14:44:03', 0, NULL);
INSERT INTO `coupons` VALUES (3, 5, '8折优惠券（新客专享）', '新客首次购买可享8折优惠', 2, 'purchase', 20.00, 50.00, 500, 1, 497, 30, 1, 1, '2026-05-28 11:04:00', '2026-05-28 11:04:00', 0, NULL);
INSERT INTO `coupons` VALUES (4, 5, '兑换券（免费石膏涂色）', '凭此券可免费体验一次石膏涂色', 3, 'purchase', 24.90, 0.00, 200, 1, 195, 60, 1, 0, '2026-05-28 11:04:00', '2026-05-28 11:04:00', 0, NULL);
INSERT INTO `coupons` VALUES (5, 5, '满100减15优惠券', '消费满100元可用', 1, 'purchase', 15.00, 100.00, 300, 2, 295, 30, 1, 0, '2026-05-28 11:04:00', '2026-05-28 11:04:00', 0, NULL);
INSERT INTO `coupons` VALUES (6, 5, '儿童节专属优惠', '儿童节期间全场8折', 2, 'purchase', 20.00, 30.00, 200, 2, 180, 7, 1, 0, '2026-05-25 10:00:00', '2026-06-09 22:29:47', 0, NULL);
INSERT INTO `coupons` VALUES (7, 5, '端午节满减券', '满200减30', 1, 'purchase', 30.00, 200.00, 150, 1, 140, 15, 1, 0, '2026-05-28 10:00:00', '2026-06-09 22:29:47', 0, NULL);
INSERT INTO `coupons` VALUES (8, 5, '新客体验券', '新客首次免费体验', 3, 'purchase', 29.90, 0.00, 100, 1, 85, 30, 1, 1, '2026-06-01 10:00:00', '2026-06-09 22:29:47', 0, NULL);

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
) ENGINE = InnoDB AUTO_INCREMENT = 135 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '顾客按天次卡记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of customer_sessions
-- ----------------------------
INSERT INTO `customer_sessions` VALUES (1, 5, 15, 1, '2026-05-21', 3, NULL, NULL, '2026-05-21 14:47:52', 0, NULL);
INSERT INTO `customer_sessions` VALUES (2, 5, 14, 2, '2026-05-21', 4, NULL, NULL, '2026-05-21 14:50:02', 0, NULL);
INSERT INTO `customer_sessions` VALUES (3, 5, 14, 2, '2026-05-22', 4, NULL, NULL, '2026-05-21 14:50:02', 0, NULL);
INSERT INTO `customer_sessions` VALUES (4, 5, 14, 2, '2026-05-23', 4, NULL, NULL, '2026-05-21 14:50:02', 0, NULL);
INSERT INTO `customer_sessions` VALUES (5, 5, 14, 2, '2026-05-24', 4, NULL, NULL, '2026-05-21 14:50:02', 0, NULL);
INSERT INTO `customer_sessions` VALUES (6, 5, 14, 2, '2026-05-25', 4, NULL, NULL, '2026-05-21 14:50:02', 0, NULL);
INSERT INTO `customer_sessions` VALUES (7, 5, 14, 2, '2026-05-26', 4, NULL, NULL, '2026-05-21 14:50:02', 0, NULL);
INSERT INTO `customer_sessions` VALUES (8, 5, 14, 2, '2026-05-27', 4, NULL, NULL, '2026-05-21 14:50:02', 0, NULL);
INSERT INTO `customer_sessions` VALUES (9, 5, 3, 3, '2026-05-21', 2, '2026-05-21 15:24:32', 1, '2026-05-21 15:00:15', 0, NULL);
INSERT INTO `customer_sessions` VALUES (10, 5, 3, 3, '2026-05-22', 2, '2026-05-22 13:14:56', 2, '2026-05-21 15:00:15', 0, NULL);
INSERT INTO `customer_sessions` VALUES (11, 5, 3, 3, '2026-05-23', 2, '2026-05-23 08:35:27', 4, '2026-05-21 15:00:15', 0, NULL);
INSERT INTO `customer_sessions` VALUES (12, 5, 3, 3, '2026-05-24', 3, NULL, NULL, '2026-05-21 15:00:15', 0, NULL);
INSERT INTO `customer_sessions` VALUES (13, 5, 3, 3, '2026-05-25', 3, NULL, NULL, '2026-05-21 15:00:15', 0, NULL);
INSERT INTO `customer_sessions` VALUES (14, 5, 3, 3, '2026-05-26', 3, NULL, NULL, '2026-05-21 15:00:15', 0, NULL);
INSERT INTO `customer_sessions` VALUES (15, 5, 3, 3, '2026-05-27', 3, NULL, NULL, '2026-05-21 15:00:15', 0, NULL);
INSERT INTO `customer_sessions` VALUES (16, 5, 15, 4, '2026-05-22', 2, '2026-05-22 13:15:49', 3, '2026-05-22 13:15:40', 0, NULL);
INSERT INTO `customer_sessions` VALUES (17, 5, 19, 6, '2026-05-01', 2, NULL, NULL, '2026-05-01 10:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (18, 5, 20, 7, '2026-05-02', 2, NULL, NULL, '2026-05-02 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (19, 5, 20, 7, '2026-05-03', 2, '2026-05-02 11:05:00', 5, '2026-05-02 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (20, 5, 20, 7, '2026-05-04', 2, '2026-05-03 15:00:00', 6, '2026-05-02 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (21, 5, 20, 7, '2026-05-05', 3, NULL, NULL, '2026-05-02 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (22, 5, 20, 7, '2026-05-06', 3, NULL, NULL, '2026-05-02 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (23, 5, 20, 7, '2026-05-07', 3, NULL, NULL, '2026-05-02 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (24, 5, 20, 7, '2026-05-08', 3, NULL, NULL, '2026-05-02 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (25, 5, 20, 7, '2026-05-09', 3, NULL, NULL, '2026-05-02 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (26, 5, 20, 7, '2026-05-10', 3, NULL, NULL, '2026-05-02 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (27, 5, 20, 7, '2026-05-11', 3, NULL, NULL, '2026-05-02 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (28, 5, 20, 7, '2026-05-12', 3, NULL, NULL, '2026-05-02 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (29, 5, 20, 7, '2026-05-13', 3, NULL, NULL, '2026-05-02 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (30, 5, 20, 7, '2026-05-14', 3, NULL, NULL, '2026-05-02 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (31, 5, 20, 7, '2026-05-15', 3, NULL, NULL, '2026-05-02 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (32, 5, 20, 7, '2026-05-16', 3, NULL, NULL, '2026-05-02 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (33, 5, 20, 7, '2026-05-17', 3, NULL, NULL, '2026-05-02 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (34, 5, 20, 7, '2026-05-18', 3, NULL, NULL, '2026-05-02 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (35, 5, 20, 7, '2026-05-19', 3, NULL, NULL, '2026-05-02 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (36, 5, 20, 7, '2026-05-20', 3, NULL, NULL, '2026-05-02 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (37, 5, 20, 7, '2026-05-21', 3, NULL, NULL, '2026-05-02 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (38, 5, 20, 7, '2026-05-22', 3, NULL, NULL, '2026-05-02 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (39, 5, 20, 7, '2026-05-23', 3, NULL, NULL, '2026-05-02 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (40, 5, 20, 7, '2026-05-24', 3, NULL, NULL, '2026-05-02 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (41, 5, 20, 7, '2026-05-25', 3, NULL, NULL, '2026-05-02 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (42, 5, 20, 7, '2026-05-26', 3, NULL, NULL, '2026-05-02 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (43, 5, 20, 7, '2026-05-27', 3, NULL, NULL, '2026-05-02 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (44, 5, 20, 7, '2026-05-28', 3, NULL, NULL, '2026-05-02 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (45, 5, 20, 7, '2026-05-29', 3, NULL, NULL, '2026-05-02 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (46, 5, 20, 7, '2026-05-30', 3, NULL, NULL, '2026-05-02 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (47, 5, 20, 7, '2026-05-31', 3, NULL, NULL, '2026-05-02 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (48, 5, 21, 8, '2026-05-03', 2, NULL, NULL, '2026-05-03 09:15:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (49, 5, 22, 9, '2026-05-04', 2, '2026-05-04 11:30:00', 7, '2026-05-04 10:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (50, 5, 22, 9, '2026-05-05', 3, NULL, NULL, '2026-05-04 10:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (51, 5, 22, 9, '2026-05-06', 3, NULL, NULL, '2026-05-04 10:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (52, 5, 22, 9, '2026-05-07', 3, NULL, NULL, '2026-05-04 10:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (53, 5, 22, 9, '2026-05-08', 3, NULL, NULL, '2026-05-04 10:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (54, 5, 22, 9, '2026-05-09', 3, NULL, NULL, '2026-05-04 10:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (55, 5, 22, 9, '2026-05-10', 3, NULL, NULL, '2026-05-04 10:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (56, 5, 23, 10, '2026-05-05', 2, '2026-05-05 15:00:00', 8, '2026-05-05 11:30:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (57, 5, 24, 11, '2026-05-06', 2, '2026-05-06 10:55:00', 9, '2026-05-06 10:30:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (58, 5, 25, 12, '2026-05-07', 2, '2026-05-07 10:30:00', 10, '2026-05-07 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (59, 5, 25, 12, '2026-05-08', 3, NULL, NULL, '2026-05-07 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (60, 5, 25, 12, '2026-05-09', 3, NULL, NULL, '2026-05-07 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (61, 5, 25, 12, '2026-05-10', 3, NULL, NULL, '2026-05-07 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (62, 5, 25, 12, '2026-05-11', 3, NULL, NULL, '2026-05-07 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (63, 5, 25, 12, '2026-05-12', 3, NULL, NULL, '2026-05-07 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (64, 5, 25, 12, '2026-05-13', 3, NULL, NULL, '2026-05-07 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (65, 5, 25, 12, '2026-05-14', 3, NULL, NULL, '2026-05-07 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (66, 5, 25, 12, '2026-05-15', 3, NULL, NULL, '2026-05-07 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (67, 5, 25, 12, '2026-05-16', 3, NULL, NULL, '2026-05-07 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (68, 5, 25, 12, '2026-05-17', 3, NULL, NULL, '2026-05-07 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (69, 5, 25, 12, '2026-05-18', 3, NULL, NULL, '2026-05-07 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (70, 5, 25, 12, '2026-05-19', 3, NULL, NULL, '2026-05-07 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (71, 5, 25, 12, '2026-05-20', 3, NULL, NULL, '2026-05-07 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (72, 5, 25, 12, '2026-05-21', 3, NULL, NULL, '2026-05-07 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (73, 5, 25, 12, '2026-05-22', 3, NULL, NULL, '2026-05-07 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (74, 5, 25, 12, '2026-05-23', 3, NULL, NULL, '2026-05-07 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (75, 5, 25, 12, '2026-05-24', 3, NULL, NULL, '2026-05-07 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (76, 5, 25, 12, '2026-05-25', 3, NULL, NULL, '2026-05-07 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (77, 5, 25, 12, '2026-05-26', 3, NULL, NULL, '2026-05-07 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (78, 5, 25, 12, '2026-05-27', 3, NULL, NULL, '2026-05-07 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (79, 5, 25, 12, '2026-05-28', 3, NULL, NULL, '2026-05-07 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (80, 5, 25, 12, '2026-05-29', 3, NULL, NULL, '2026-05-07 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (81, 5, 25, 12, '2026-05-30', 3, NULL, NULL, '2026-05-07 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (82, 5, 25, 12, '2026-05-31', 3, NULL, NULL, '2026-05-07 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (83, 5, 25, 12, '2026-06-01', 3, NULL, NULL, '2026-05-07 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (84, 5, 25, 12, '2026-06-02', 3, NULL, NULL, '2026-05-07 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (85, 5, 25, 12, '2026-06-03', 3, NULL, NULL, '2026-05-07 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (86, 5, 25, 12, '2026-06-04', 3, NULL, NULL, '2026-05-07 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (87, 5, 25, 12, '2026-06-05', 3, NULL, NULL, '2026-05-07 09:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (88, 5, 26, 13, '2026-05-08', 2, '2026-05-08 15:30:00', 11, '2026-05-08 13:45:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (89, 5, 26, 13, '2026-05-09', 3, NULL, NULL, '2026-05-08 13:45:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (90, 5, 26, 13, '2026-05-10', 3, NULL, NULL, '2026-05-08 13:45:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (91, 5, 26, 13, '2026-05-11', 3, NULL, NULL, '2026-05-08 13:45:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (92, 5, 26, 13, '2026-05-12', 3, NULL, NULL, '2026-05-08 13:45:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (93, 5, 26, 13, '2026-05-13', 3, NULL, NULL, '2026-05-08 13:45:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (94, 5, 26, 13, '2026-05-14', 3, NULL, NULL, '2026-05-08 13:45:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (95, 5, 27, 14, '2026-05-10', 2, NULL, NULL, '2026-05-10 09:45:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (96, 5, 28, 15, '2026-05-12', 3, NULL, NULL, '2026-05-12 11:30:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (97, 5, 29, 16, '2026-05-15', 2, NULL, 12, '2026-05-15 10:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (98, 5, 29, 16, '2026-05-16', 3, NULL, NULL, '2026-05-15 10:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (99, 5, 29, 16, '2026-05-17', 3, NULL, NULL, '2026-05-15 10:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (100, 5, 29, 16, '2026-05-18', 3, NULL, NULL, '2026-05-15 10:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (101, 5, 29, 16, '2026-05-19', 3, NULL, NULL, '2026-05-15 10:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (102, 5, 29, 16, '2026-05-20', 3, NULL, NULL, '2026-05-15 10:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (103, 5, 29, 16, '2026-05-21', 3, NULL, NULL, '2026-05-15 10:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (104, 5, 29, 16, '2026-05-22', 3, NULL, NULL, '2026-05-15 10:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (105, 5, 29, 16, '2026-05-23', 3, NULL, NULL, '2026-05-15 10:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (106, 5, 29, 16, '2026-05-24', 3, NULL, NULL, '2026-05-15 10:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (107, 5, 29, 16, '2026-05-25', 3, NULL, NULL, '2026-05-15 10:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (108, 5, 29, 16, '2026-05-26', 3, NULL, NULL, '2026-05-15 10:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (109, 5, 29, 16, '2026-05-27', 3, NULL, NULL, '2026-05-15 10:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (110, 5, 29, 16, '2026-05-28', 3, NULL, NULL, '2026-05-15 10:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (111, 5, 29, 16, '2026-05-29', 3, NULL, NULL, '2026-05-15 10:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (112, 5, 29, 16, '2026-05-30', 3, NULL, NULL, '2026-05-15 10:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (113, 5, 29, 16, '2026-05-31', 3, NULL, NULL, '2026-05-15 10:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (114, 5, 29, 16, '2026-06-01', 3, NULL, NULL, '2026-05-15 10:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (115, 5, 29, 16, '2026-06-02', 3, NULL, NULL, '2026-05-15 10:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (116, 5, 29, 16, '2026-06-03', 3, NULL, NULL, '2026-05-15 10:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (117, 5, 29, 16, '2026-06-04', 3, NULL, NULL, '2026-05-15 10:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (118, 5, 29, 16, '2026-06-05', 3, NULL, NULL, '2026-05-15 10:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (119, 5, 29, 16, '2026-06-06', 3, NULL, NULL, '2026-05-15 10:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (120, 5, 29, 16, '2026-06-07', 3, NULL, NULL, '2026-05-15 10:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (121, 5, 29, 16, '2026-06-08', 3, NULL, NULL, '2026-05-15 10:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (122, 5, 29, 16, '2026-06-09', 3, NULL, NULL, '2026-05-15 10:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (123, 5, 29, 16, '2026-06-10', 3, NULL, NULL, '2026-05-15 10:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (124, 5, 29, 16, '2026-06-11', 3, NULL, NULL, '2026-05-15 10:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (125, 5, 29, 16, '2026-06-12', 3, NULL, NULL, '2026-05-15 10:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (126, 5, 29, 16, '2026-06-13', 3, NULL, NULL, '2026-05-15 10:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (127, 5, 29, 16, '2026-06-14', 2, NULL, 13, '2026-05-15 10:00:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (128, 5, 30, 17, '2026-05-18', 2, NULL, NULL, '2026-05-18 13:15:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (129, 5, 30, 17, '2026-05-19', 3, NULL, NULL, '2026-05-18 13:15:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (130, 5, 30, 17, '2026-05-20', 3, NULL, NULL, '2026-05-18 13:15:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (131, 5, 30, 17, '2026-05-21', 3, NULL, NULL, '2026-05-18 13:15:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (132, 5, 30, 17, '2026-05-22', 3, NULL, NULL, '2026-05-18 13:15:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (133, 5, 30, 17, '2026-05-23', 3, NULL, NULL, '2026-05-18 13:15:00', 0, NULL);
INSERT INTO `customer_sessions` VALUES (134, 5, 30, 17, '2026-05-24', 3, NULL, NULL, '2026-05-18 13:15:00', 0, NULL);

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
) ENGINE = InnoDB AUTO_INCREMENT = 51 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '顾客储值钱包' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of customer_wallets
-- ----------------------------
INSERT INTO `customer_wallets` VALUES (1, 5, 14, 200.00, 200.00, 0.00, '2026-05-23 15:00:20', 0, NULL);
INSERT INTO `customer_wallets` VALUES (2, 5, 2, 200.00, 200.00, 0.00, '2026-05-20 14:06:05', 0, NULL);
INSERT INTO `customer_wallets` VALUES (3, 5, 3, 0.10, 100.00, 99.90, '2026-05-21 15:00:15', 0, NULL);
INSERT INTO `customer_wallets` VALUES (4, 7, 4, 0.00, 0.00, 0.00, '2026-05-20 13:58:42', 0, NULL);
INSERT INTO `customer_wallets` VALUES (5, 7, 5, 0.00, 0.00, 0.00, '2026-05-20 13:58:42', 0, NULL);
INSERT INTO `customer_wallets` VALUES (6, 8, 6, 0.00, 0.00, 0.00, '2026-05-20 13:58:42', 0, NULL);
INSERT INTO `customer_wallets` VALUES (7, 9, 7, 0.00, 0.00, 0.00, '2026-05-20 13:58:42', 0, NULL);
INSERT INTO `customer_wallets` VALUES (8, 10, 8, 0.00, 0.00, 0.00, '2026-05-20 13:58:42', 0, NULL);
INSERT INTO `customer_wallets` VALUES (9, 11, 9, 0.00, 0.00, 0.00, '2026-05-20 13:58:42', 0, NULL);
INSERT INTO `customer_wallets` VALUES (10, 12, 10, 0.00, 0.00, 0.00, '2026-05-20 13:58:42', 0, NULL);
INSERT INTO `customer_wallets` VALUES (11, 13, 11, 0.00, 0.00, 0.00, '2026-05-20 13:58:42', 0, NULL);
INSERT INTO `customer_wallets` VALUES (12, 14, 12, 0.00, 0.00, 0.00, '2026-05-20 13:58:42', 0, NULL);
INSERT INTO `customer_wallets` VALUES (13, 15, 13, 0.00, 0.00, 0.00, '2026-05-20 13:58:42', 0, NULL);
INSERT INTO `customer_wallets` VALUES (17, 5, 15, 0.00, 0.00, 0.00, '2026-05-20 15:08:31', 0, NULL);
INSERT INTO `customer_wallets` VALUES (18, 5, 16, 0.00, 0.00, 0.00, '2026-05-23 13:36:46', 1, '2026-05-23 13:36:46');
INSERT INTO `customer_wallets` VALUES (19, 5, 17, 0.00, 0.00, 0.00, '2026-05-23 13:37:26', 0, NULL);
INSERT INTO `customer_wallets` VALUES (20, 5, 18, 0.00, 0.00, 0.00, '2026-05-26 15:34:28', 0, NULL);
INSERT INTO `customer_wallets` VALUES (21, 5, 19, 300.00, 300.00, 0.00, '2026-05-28 10:54:54', 0, NULL);
INSERT INTO `customer_wallets` VALUES (22, 5, 20, 100.00, 100.00, 0.00, '2026-05-28 10:54:54', 0, NULL);
INSERT INTO `customer_wallets` VALUES (23, 5, 21, 500.00, 500.00, 0.00, '2026-05-28 10:54:54', 0, NULL);
INSERT INTO `customer_wallets` VALUES (24, 5, 22, 200.00, 200.00, 0.00, '2026-05-28 10:54:54', 0, NULL);
INSERT INTO `customer_wallets` VALUES (25, 5, 23, 0.00, 0.00, 0.00, '2026-05-28 10:54:54', 0, NULL);
INSERT INTO `customer_wallets` VALUES (26, 5, 24, 150.00, 150.00, 0.00, '2026-05-28 10:54:54', 0, NULL);
INSERT INTO `customer_wallets` VALUES (27, 5, 25, 101.00, 400.00, 299.00, '2026-05-28 10:58:39', 0, NULL);
INSERT INTO `customer_wallets` VALUES (28, 5, 26, 0.00, 0.00, 0.00, '2026-05-28 10:54:54', 0, NULL);
INSERT INTO `customer_wallets` VALUES (29, 5, 27, 250.00, 250.00, 0.00, '2026-05-28 10:54:54', 0, NULL);
INSERT INTO `customer_wallets` VALUES (30, 5, 28, 0.00, 0.00, 0.00, '2026-05-28 10:54:54', 0, NULL);
INSERT INTO `customer_wallets` VALUES (31, 5, 29, 350.00, 350.00, 0.00, '2026-05-28 10:54:54', 0, NULL);
INSERT INTO `customer_wallets` VALUES (32, 5, 30, 100.00, 100.00, 0.00, '2026-05-28 10:54:54', 0, NULL);
INSERT INTO `customer_wallets` VALUES (33, 5, 31, 0.00, 0.00, 0.00, '2026-05-28 10:54:54', 0, NULL);
INSERT INTO `customer_wallets` VALUES (34, 5, 32, 200.00, 200.00, 0.00, '2026-05-28 10:54:54', 0, NULL);
INSERT INTO `customer_wallets` VALUES (35, 5, 33, 0.00, 0.00, 0.00, '2026-05-28 10:54:54', 0, NULL);
INSERT INTO `customer_wallets` VALUES (36, 5, 34, 500.00, 500.00, 0.00, '2026-06-09 22:28:51', 0, NULL);
INSERT INTO `customer_wallets` VALUES (37, 5, 35, 0.00, 0.00, 0.00, '2026-06-09 22:28:51', 0, NULL);
INSERT INTO `customer_wallets` VALUES (38, 5, 36, 200.00, 200.00, 0.00, '2026-06-09 22:28:51', 0, NULL);
INSERT INTO `customer_wallets` VALUES (39, 5, 37, 1000.00, 1000.00, 0.00, '2026-06-09 22:28:51', 0, NULL);
INSERT INTO `customer_wallets` VALUES (40, 5, 38, 0.00, 0.00, 0.00, '2026-06-09 22:28:51', 0, NULL);
INSERT INTO `customer_wallets` VALUES (41, 5, 39, 300.00, 300.00, 0.00, '2026-06-09 22:28:51', 0, NULL);
INSERT INTO `customer_wallets` VALUES (42, 5, 40, 800.00, 800.00, 0.00, '2026-06-09 22:28:51', 0, NULL);
INSERT INTO `customer_wallets` VALUES (43, 5, 41, 150.00, 150.00, 0.00, '2026-06-09 22:28:51', 0, NULL);
INSERT INTO `customer_wallets` VALUES (44, 5, 42, 0.00, 0.00, 0.00, '2026-06-09 22:28:51', 0, NULL);
INSERT INTO `customer_wallets` VALUES (45, 5, 43, 250.00, 250.00, 0.00, '2026-06-09 22:28:51', 0, NULL);
INSERT INTO `customer_wallets` VALUES (46, 5, 44, 400.00, 400.00, 0.00, '2026-06-09 22:28:51', 0, NULL);
INSERT INTO `customer_wallets` VALUES (47, 5, 45, 0.00, 0.00, 0.00, '2026-06-09 22:28:51', 0, NULL);
INSERT INTO `customer_wallets` VALUES (48, 5, 46, 100.00, 100.00, 0.00, '2026-06-09 22:28:51', 0, NULL);
INSERT INTO `customer_wallets` VALUES (49, 5, 47, 600.00, 600.00, 0.00, '2026-06-09 22:28:51', 0, NULL);
INSERT INTO `customer_wallets` VALUES (50, 5, 48, 0.00, 0.00, 0.00, '2026-06-09 22:28:51', 0, NULL);

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
) ENGINE = InnoDB AUTO_INCREMENT = 49 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '顾客基本信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of customers
-- ----------------------------
INSERT INTO `customers` VALUES (2, 5, '小王妈妈', NULL, '13900010001', 2, NULL, NULL, NULL, 'offline', NULL, NULL, 0, '2025-06-10 14:00:00', '2026-05-20 11:06:33', NULL);
INSERT INTO `customers` VALUES (3, 5, '小李爸爸', NULL, '13900010002', 1, NULL, NULL, NULL, 'offline', '投诉,新客', NULL, 0, '2025-07-15 14:00:00', '2026-05-20 13:54:05', NULL);
INSERT INTO `customers` VALUES (4, 7, '张先生', NULL, '13900010003', 0, NULL, NULL, NULL, 'offline', NULL, NULL, 0, '2025-08-20 14:00:00', '2026-05-20 11:02:14', NULL);
INSERT INTO `customers` VALUES (5, 7, '赵女士', NULL, '13900010004', 1, NULL, NULL, NULL, 'offline', NULL, NULL, 0, '2025-09-10 14:00:00', '2026-05-20 11:02:14', NULL);
INSERT INTO `customers` VALUES (6, 8, '陈妈妈', NULL, '13900010005', 1, NULL, NULL, NULL, 'offline', NULL, NULL, 0, '2025-10-05 14:00:00', '2026-05-20 11:02:14', NULL);
INSERT INTO `customers` VALUES (7, 9, '刘爸爸', NULL, '13900010006', 0, NULL, NULL, NULL, 'offline', NULL, NULL, 0, '2025-11-15 14:00:00', '2026-05-20 11:02:14', NULL);
INSERT INTO `customers` VALUES (8, 10, '周女士', NULL, '13900010007', 1, NULL, NULL, NULL, 'offline', NULL, NULL, 0, '2025-12-20 14:00:00', '2026-05-20 11:02:14', NULL);
INSERT INTO `customers` VALUES (9, 11, '吴先生', NULL, '13900010008', 0, NULL, NULL, NULL, 'offline', NULL, NULL, 0, '2026-01-10 14:00:00', '2026-05-20 11:02:14', NULL);
INSERT INTO `customers` VALUES (10, 12, '郑妈妈', NULL, '13900010009', 1, NULL, NULL, NULL, 'offline', NULL, NULL, 0, '2026-02-15 14:00:00', '2026-05-20 11:02:14', NULL);
INSERT INTO `customers` VALUES (11, 13, '冯爸爸', NULL, '13900010010', 0, NULL, NULL, NULL, 'offline', NULL, NULL, 0, '2026-03-05 14:00:00', '2026-05-20 11:02:14', NULL);
INSERT INTO `customers` VALUES (12, 14, '黄女士', NULL, '13900010011', 1, NULL, NULL, NULL, 'offline', NULL, NULL, 0, '2026-04-20 14:00:00', '2026-05-20 11:02:14', NULL);
INSERT INTO `customers` VALUES (13, 15, '孙先生', NULL, '13900010012', 0, NULL, NULL, NULL, 'offline', NULL, NULL, 0, '2026-05-10 14:00:00', '2026-05-20 11:02:14', NULL);
INSERT INTO `customers` VALUES (14, 5, '王利发', NULL, '18878965412', 1, '1995-06-29', NULL, NULL, 'offline', 'VIP重要客户,建议定期回访,氪金大佬,♥', '123', 0, '2026-05-20 10:16:33', '2026-05-20 13:54:18', NULL);
INSERT INTO `customers` VALUES (15, 5, '张雪飞', NULL, '18874521025', 1, '2026-05-21', NULL, NULL, 'meituan', NULL, NULL, 0, '2026-05-20 15:08:31', '2026-05-20 15:08:31', NULL);
INSERT INTO `customers` VALUES (16, 5, '徐霞', NULL, '13978965412', 2, '2000-01-03', NULL, NULL, 'offline', NULL, NULL, 1, '2026-05-23 13:33:09', '2026-05-23 13:36:45', '2026-05-23 13:36:45');
INSERT INTO `customers` VALUES (17, 5, 'TEST_顾客01改', '5/avatar/20260525130903263_1292360021.png', '13978965412', 2, '2000-01-03', NULL, NULL, 'offline', 'VIP', NULL, 0, '2026-05-23 13:37:26', '2026-05-25 14:33:51', NULL);
INSERT INTO `customers` VALUES (18, 5, '小灰灰', 'public/wx-avatar/20260527152930062_680173665.jpeg', '18895358789', 1, '1995-11-26', 'ol0wUww9zHmgOzgm4zu6jIfR89LE', NULL, 'miniapp', NULL, NULL, 0, '2026-05-26 15:34:28', '2026-05-27 15:29:58', NULL);
INSERT INTO `customers` VALUES (19, 5, '李小花', NULL, '13812345601', 2, '2015-03-12', NULL, NULL, 'offline', '会员,亲子', '常带女儿来', 0, '2026-04-01 10:00:00', '2026-05-28 10:53:17', NULL);
INSERT INTO `customers` VALUES (20, 5, '王建国', NULL, '13812345602', 1, '1988-07-22', NULL, NULL, 'meituan', '新客', '美团首次到店', 0, '2026-04-05 14:30:00', '2026-05-28 10:53:17', NULL);
INSERT INTO `customers` VALUES (21, 5, '赵丽颖', NULL, '13812345603', 2, '1992-11-08', NULL, NULL, 'douyin', '会员,网红', '抖音博主推荐来的', 0, '2026-04-10 09:15:00', '2026-05-28 10:53:17', NULL);
INSERT INTO `customers` VALUES (22, 5, '刘强东', NULL, '13812345604', 1, '1985-01-30', NULL, NULL, 'offline', '亲子', '带两个孩子', 0, '2026-04-12 11:00:00', '2026-05-28 10:53:17', NULL);
INSERT INTO `customers` VALUES (23, 5, '陈小红', NULL, '13812345605', 2, '2018-06-15', NULL, NULL, 'miniapp', '新客', '小程序预约', 0, '2026-04-15 16:20:00', '2026-05-28 10:53:17', NULL);
INSERT INTO `customers` VALUES (24, 5, '张伟', NULL, '13812345606', 1, '1990-09-05', NULL, NULL, 'offline', '常客', '每周都来', 0, '2026-04-18 10:30:00', '2026-05-28 10:53:17', NULL);
INSERT INTO `customers` VALUES (25, 5, '林志玲', NULL, '13812345607', 2, '1995-04-20', NULL, NULL, 'meituan', '会员', '办了月卡', 0, '2026-04-20 13:45:00', '2026-05-28 10:53:17', NULL);
INSERT INTO `customers` VALUES (26, 5, '黄晓明', NULL, '13812345608', 1, '1987-12-01', NULL, NULL, 'douyin', '新客', '看到抖音团购来的', 0, '2026-04-22 15:00:00', '2026-05-28 10:53:17', NULL);
INSERT INTO `customers` VALUES (27, 5, '周杰伦', NULL, '13812345609', 1, '2020-02-14', NULL, NULL, 'offline', '亲子', '爸爸带娃', 0, '2026-04-25 09:30:00', '2026-05-28 10:53:17', NULL);
INSERT INTO `customers` VALUES (28, 5, '杨超越', NULL, '13812345610', 2, '1998-08-18', NULL, NULL, 'miniapp', '会员,活跃', '朋友圈分享来的', 0, '2026-05-01 10:00:00', '2026-05-28 10:53:17', NULL);
INSERT INTO `customers` VALUES (29, 5, '吴亦凡', NULL, '13812345611', 1, '2016-05-25', NULL, NULL, 'offline', '亲子', '奶奶带孙子', 0, '2026-05-03 14:00:00', '2026-05-28 10:53:17', NULL);
INSERT INTO `customers` VALUES (30, 5, '郑爽', NULL, '13812345612', 2, '1991-02-08', NULL, NULL, 'meituan', '新客', '美团秒杀', 0, '2026-05-05 11:30:00', '2026-05-28 10:53:17', NULL);
INSERT INTO `customers` VALUES (31, 5, '冯绍峰', NULL, '13812345613', 1, '1993-07-17', NULL, NULL, 'offline', '常客', '单位团建', 0, '2026-05-08 16:00:00', '2026-05-28 10:53:17', NULL);
INSERT INTO `customers` VALUES (32, 5, '赵丽华', NULL, '13812345614', 2, '2017-10-30', NULL, NULL, 'douyin', '亲子', '妈妈和女儿', 0, '2026-05-10 09:45:00', '2026-05-28 10:53:17', NULL);
INSERT INTO `customers` VALUES (33, 5, '马超', NULL, '13812345615', 1, '1989-03-22', NULL, NULL, 'miniapp', '会员', '小程序老用户', 0, '2026-05-12 13:15:00', '2026-05-28 10:53:17', NULL);
INSERT INTO `customers` VALUES (34, 5, '孙悟空', NULL, '13900001001', 1, '1990-08-15', NULL, NULL, 'offline', '常客,会员', '喜欢拼豆创作', 0, '2026-05-09 10:00:00', '2026-06-09 22:28:51', NULL);
INSERT INTO `customers` VALUES (35, 5, '猪八戒', NULL, '13900001002', 1, '1985-12-25', NULL, NULL, 'meituan', '新客', '美团团购来的', 0, '2026-05-10 14:30:00', '2026-06-09 22:28:51', NULL);
INSERT INTO `customers` VALUES (36, 5, '沙和尚', NULL, '13900001003', 1, '1988-06-18', NULL, NULL, 'douyin', '亲子', '带孩子来玩', 0, '2026-05-11 09:15:00', '2026-06-09 22:28:51', NULL);
INSERT INTO `customers` VALUES (37, 5, '唐僧', NULL, '13900001004', 1, '1975-03-10', NULL, NULL, 'offline', '会员,VIP', '月卡会员', 0, '2026-05-12 11:00:00', '2026-06-09 22:28:51', NULL);
INSERT INTO `customers` VALUES (38, 5, '白骨精', NULL, '13900001005', 2, '1992-09-20', NULL, NULL, 'miniapp', '新客', '小程序预约', 0, '2026-05-13 16:20:00', '2026-06-09 22:28:51', NULL);
INSERT INTO `customers` VALUES (39, 5, '蜘蛛精', NULL, '13900001006', 2, '1995-07-07', NULL, NULL, 'meituan', '常客', '每周来2-3次', 0, '2026-05-14 10:30:00', '2026-06-09 22:28:51', NULL);
INSERT INTO `customers` VALUES (40, 5, '牛魔王', NULL, '13900001007', 1, '1980-11-11', NULL, NULL, 'offline', '亲子,会员', '带三个孩子', 0, '2026-05-15 13:45:00', '2026-06-09 22:28:51', NULL);
INSERT INTO `customers` VALUES (41, 5, '铁扇公主', NULL, '13900001008', 2, '1983-04-28', NULL, NULL, 'douyin', '会员', '抖音关注来的', 0, '2026-05-16 15:00:00', '2026-06-09 22:28:51', NULL);
INSERT INTO `customers` VALUES (42, 5, '红孩儿', NULL, '13900001009', 1, '2018-01-15', NULL, NULL, 'offline', '亲子', '爸爸带来的', 0, '2026-05-17 09:30:00', '2026-06-09 22:28:51', NULL);
INSERT INTO `customers` VALUES (43, 5, '哪吒', NULL, '13900001010', 1, '2016-08-08', NULL, NULL, 'miniapp', '活跃', '小程序老用户', 0, '2026-05-18 10:00:00', '2026-06-09 22:28:51', NULL);
INSERT INTO `customers` VALUES (44, 5, '杨戬', NULL, '13900001011', 1, '1993-02-14', NULL, NULL, 'offline', '常客', '周末固定来', 0, '2026-05-19 14:00:00', '2026-06-09 22:28:51', NULL);
INSERT INTO `customers` VALUES (45, 5, '妲己', NULL, '13900001012', 2, '1998-10-30', NULL, NULL, 'meituan', '新客,网红', '小红书博主', 0, '2026-05-20 11:30:00', '2026-06-09 22:28:51', NULL);
INSERT INTO `customers` VALUES (46, 5, '姜子牙', NULL, '13900001013', 1, '1970-05-20', NULL, NULL, 'offline', '亲子', '带孙子来', 0, '2026-05-21 16:00:00', '2026-06-09 22:28:51', NULL);
INSERT INTO `customers` VALUES (47, 5, '苏妲己', NULL, '13900001014', 2, '1996-12-25', NULL, NULL, 'douyin', '会员', '月卡续费', 0, '2026-05-22 09:45:00', '2026-06-09 22:28:51', NULL);
INSERT INTO `customers` VALUES (48, 5, '雷震子', NULL, '13900001015', 1, '1987-07-04', NULL, NULL, 'miniapp', '新客', '朋友推荐', 0, '2026-05-23 13:15:00', '2026-06-09 22:28:51', NULL);

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
) ENGINE = InnoDB AUTO_INCREMENT = 141 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '每日经营快照' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of daily_snapshots
-- ----------------------------
INSERT INTO `daily_snapshots` VALUES (1, 5, '2026-05-19', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-19 03:54:18');
INSERT INTO `daily_snapshots` VALUES (2, 6, '2026-05-19', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-19 03:54:18');
INSERT INTO `daily_snapshots` VALUES (3, 7, '2026-05-19', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-19 03:54:18');
INSERT INTO `daily_snapshots` VALUES (4, 8, '2026-05-19', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-19 03:54:18');
INSERT INTO `daily_snapshots` VALUES (5, 9, '2026-05-19', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-19 03:54:18');
INSERT INTO `daily_snapshots` VALUES (6, 10, '2026-05-19', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-19 03:54:18');
INSERT INTO `daily_snapshots` VALUES (7, 11, '2026-05-19', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-19 03:54:18');
INSERT INTO `daily_snapshots` VALUES (8, 12, '2026-05-19', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-19 03:54:18');
INSERT INTO `daily_snapshots` VALUES (9, 13, '2026-05-19', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-19 03:54:18');
INSERT INTO `daily_snapshots` VALUES (10, 14, '2026-05-19', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-19 03:54:18');
INSERT INTO `daily_snapshots` VALUES (11, 15, '2026-05-19', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-19 03:54:18');
INSERT INTO `daily_snapshots` VALUES (12, 16, '2026-05-19', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-19 03:54:18');
INSERT INTO `daily_snapshots` VALUES (13, 17, '2026-05-19', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-19 03:54:18');
INSERT INTO `daily_snapshots` VALUES (14, 18, '2026-05-19', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-19 03:54:18');
INSERT INTO `daily_snapshots` VALUES (15, 19, '2026-05-19', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-19 03:54:18');
INSERT INTO `daily_snapshots` VALUES (16, 20, '2026-05-19', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-19 03:54:18');
INSERT INTO `daily_snapshots` VALUES (17, 21, '2026-05-19', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-19 03:54:18');
INSERT INTO `daily_snapshots` VALUES (18, 22, '2026-05-19', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-19 03:54:18');
INSERT INTO `daily_snapshots` VALUES (19, 23, '2026-05-19', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-19 03:54:18');
INSERT INTO `daily_snapshots` VALUES (20, 24, '2026-05-19', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-19 03:54:18');
INSERT INTO `daily_snapshots` VALUES (21, 25, '2026-05-19', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-19 03:54:18');
INSERT INTO `daily_snapshots` VALUES (22, 26, '2026-05-19', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-19 03:54:18');
INSERT INTO `daily_snapshots` VALUES (23, 27, '2026-05-19', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-19 03:54:18');
INSERT INTO `daily_snapshots` VALUES (24, 5, '2026-05-20', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-20 07:40:23');
INSERT INTO `daily_snapshots` VALUES (25, 6, '2026-05-20', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-20 07:40:23');
INSERT INTO `daily_snapshots` VALUES (26, 7, '2026-05-20', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-20 07:40:23');
INSERT INTO `daily_snapshots` VALUES (27, 8, '2026-05-20', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-20 07:40:23');
INSERT INTO `daily_snapshots` VALUES (28, 9, '2026-05-20', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-20 07:40:23');
INSERT INTO `daily_snapshots` VALUES (29, 10, '2026-05-20', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-20 07:40:23');
INSERT INTO `daily_snapshots` VALUES (30, 11, '2026-05-20', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-20 07:40:23');
INSERT INTO `daily_snapshots` VALUES (31, 12, '2026-05-20', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-20 07:40:23');
INSERT INTO `daily_snapshots` VALUES (32, 13, '2026-05-20', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-20 07:40:23');
INSERT INTO `daily_snapshots` VALUES (33, 14, '2026-05-20', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-20 07:40:23');
INSERT INTO `daily_snapshots` VALUES (34, 15, '2026-05-20', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-20 07:40:23');
INSERT INTO `daily_snapshots` VALUES (35, 16, '2026-05-20', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-20 07:40:23');
INSERT INTO `daily_snapshots` VALUES (36, 17, '2026-05-20', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-20 07:40:23');
INSERT INTO `daily_snapshots` VALUES (37, 18, '2026-05-20', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-20 07:40:23');
INSERT INTO `daily_snapshots` VALUES (38, 19, '2026-05-20', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-20 07:40:23');
INSERT INTO `daily_snapshots` VALUES (39, 20, '2026-05-20', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-20 07:40:23');
INSERT INTO `daily_snapshots` VALUES (40, 21, '2026-05-20', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-20 07:40:23');
INSERT INTO `daily_snapshots` VALUES (41, 22, '2026-05-20', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-20 07:40:23');
INSERT INTO `daily_snapshots` VALUES (42, 23, '2026-05-20', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-20 07:40:23');
INSERT INTO `daily_snapshots` VALUES (43, 24, '2026-05-20', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-20 07:40:23');
INSERT INTO `daily_snapshots` VALUES (44, 25, '2026-05-20', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-20 07:40:23');
INSERT INTO `daily_snapshots` VALUES (45, 26, '2026-05-20', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-20 07:40:23');
INSERT INTO `daily_snapshots` VALUES (46, 27, '2026-05-20', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-20 07:40:23');
INSERT INTO `daily_snapshots` VALUES (47, 5, '2026-05-21', 0.00, 0.00, 0, 0, 0, NULL, '[{\"sku\": \"tb\", \"name\": \"拖把\", \"minStock\": 1.0, \"quantity\": 1.0}]', '2026-05-21 07:46:02');
INSERT INTO `daily_snapshots` VALUES (48, 6, '2026-05-21', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-21 07:46:02');
INSERT INTO `daily_snapshots` VALUES (49, 7, '2026-05-21', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-21 07:46:02');
INSERT INTO `daily_snapshots` VALUES (50, 8, '2026-05-21', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-21 07:46:02');
INSERT INTO `daily_snapshots` VALUES (51, 9, '2026-05-21', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-21 07:46:02');
INSERT INTO `daily_snapshots` VALUES (52, 10, '2026-05-21', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-21 07:46:02');
INSERT INTO `daily_snapshots` VALUES (53, 11, '2026-05-21', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-21 07:46:02');
INSERT INTO `daily_snapshots` VALUES (54, 12, '2026-05-21', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-21 07:46:02');
INSERT INTO `daily_snapshots` VALUES (55, 13, '2026-05-21', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-21 07:46:02');
INSERT INTO `daily_snapshots` VALUES (56, 14, '2026-05-21', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-21 07:46:02');
INSERT INTO `daily_snapshots` VALUES (57, 15, '2026-05-21', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-21 07:46:02');
INSERT INTO `daily_snapshots` VALUES (58, 16, '2026-05-21', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-21 07:46:02');
INSERT INTO `daily_snapshots` VALUES (59, 17, '2026-05-21', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-21 07:46:02');
INSERT INTO `daily_snapshots` VALUES (60, 18, '2026-05-21', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-21 07:46:02');
INSERT INTO `daily_snapshots` VALUES (61, 19, '2026-05-21', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-21 07:46:02');
INSERT INTO `daily_snapshots` VALUES (62, 20, '2026-05-21', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-21 07:46:02');
INSERT INTO `daily_snapshots` VALUES (63, 21, '2026-05-21', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-21 07:46:02');
INSERT INTO `daily_snapshots` VALUES (64, 22, '2026-05-21', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-21 07:46:02');
INSERT INTO `daily_snapshots` VALUES (65, 23, '2026-05-21', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-21 07:46:02');
INSERT INTO `daily_snapshots` VALUES (66, 24, '2026-05-21', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-21 07:46:02');
INSERT INTO `daily_snapshots` VALUES (67, 25, '2026-05-21', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-21 07:46:02');
INSERT INTO `daily_snapshots` VALUES (68, 26, '2026-05-21', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-21 07:46:02');
INSERT INTO `daily_snapshots` VALUES (69, 27, '2026-05-21', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-21 07:46:02');
INSERT INTO `daily_snapshots` VALUES (70, 5, '2026-05-22', 0.00, 0.00, 0, 0, 0, NULL, '[{\"sku\": \"tb\", \"name\": \"拖把\", \"minStock\": 1.0, \"quantity\": 1.0}]', '2026-05-22 07:40:11');
INSERT INTO `daily_snapshots` VALUES (71, 6, '2026-05-22', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-22 07:40:11');
INSERT INTO `daily_snapshots` VALUES (72, 7, '2026-05-22', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-22 07:40:11');
INSERT INTO `daily_snapshots` VALUES (73, 8, '2026-05-22', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-22 07:40:11');
INSERT INTO `daily_snapshots` VALUES (74, 9, '2026-05-22', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-22 07:40:11');
INSERT INTO `daily_snapshots` VALUES (75, 10, '2026-05-22', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-22 07:40:11');
INSERT INTO `daily_snapshots` VALUES (76, 11, '2026-05-22', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-22 07:40:11');
INSERT INTO `daily_snapshots` VALUES (77, 12, '2026-05-22', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-22 07:40:11');
INSERT INTO `daily_snapshots` VALUES (78, 13, '2026-05-22', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-22 07:40:11');
INSERT INTO `daily_snapshots` VALUES (79, 14, '2026-05-22', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-22 07:40:11');
INSERT INTO `daily_snapshots` VALUES (80, 15, '2026-05-22', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-22 07:40:11');
INSERT INTO `daily_snapshots` VALUES (81, 16, '2026-05-22', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-22 07:40:11');
INSERT INTO `daily_snapshots` VALUES (82, 17, '2026-05-22', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-22 07:40:11');
INSERT INTO `daily_snapshots` VALUES (83, 18, '2026-05-22', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-22 07:40:11');
INSERT INTO `daily_snapshots` VALUES (84, 19, '2026-05-22', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-22 07:40:11');
INSERT INTO `daily_snapshots` VALUES (85, 20, '2026-05-22', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-22 07:40:11');
INSERT INTO `daily_snapshots` VALUES (86, 21, '2026-05-22', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-22 07:40:11');
INSERT INTO `daily_snapshots` VALUES (87, 22, '2026-05-22', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-22 07:40:11');
INSERT INTO `daily_snapshots` VALUES (88, 23, '2026-05-22', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-22 07:40:11');
INSERT INTO `daily_snapshots` VALUES (89, 24, '2026-05-22', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-22 07:40:11');
INSERT INTO `daily_snapshots` VALUES (90, 25, '2026-05-22', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-22 07:40:11');
INSERT INTO `daily_snapshots` VALUES (91, 26, '2026-05-22', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-22 07:40:11');
INSERT INTO `daily_snapshots` VALUES (92, 27, '2026-05-22', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-22 07:40:11');
INSERT INTO `daily_snapshots` VALUES (93, 5, '2026-05-23', 0.00, 0.00, 0, 0, 0, NULL, '[{\"sku\": \"ytj01\", \"name\": \"印烫机\", \"minStock\": 3.0, \"quantity\": 2.0}]', '2026-05-23 03:10:08');
INSERT INTO `daily_snapshots` VALUES (94, 6, '2026-05-23', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-23 03:10:08');
INSERT INTO `daily_snapshots` VALUES (95, 7, '2026-05-23', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-23 03:10:08');
INSERT INTO `daily_snapshots` VALUES (96, 8, '2026-05-23', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-23 03:10:08');
INSERT INTO `daily_snapshots` VALUES (97, 9, '2026-05-23', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-23 03:10:08');
INSERT INTO `daily_snapshots` VALUES (98, 10, '2026-05-23', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-23 03:10:08');
INSERT INTO `daily_snapshots` VALUES (99, 11, '2026-05-23', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-23 03:10:08');
INSERT INTO `daily_snapshots` VALUES (100, 12, '2026-05-23', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-23 03:10:08');
INSERT INTO `daily_snapshots` VALUES (101, 13, '2026-05-23', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-23 03:10:08');
INSERT INTO `daily_snapshots` VALUES (102, 14, '2026-05-23', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-23 03:10:08');
INSERT INTO `daily_snapshots` VALUES (103, 15, '2026-05-23', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-23 03:10:08');
INSERT INTO `daily_snapshots` VALUES (104, 16, '2026-05-23', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-23 03:10:08');
INSERT INTO `daily_snapshots` VALUES (105, 17, '2026-05-23', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-23 03:10:08');
INSERT INTO `daily_snapshots` VALUES (106, 18, '2026-05-23', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-23 03:10:08');
INSERT INTO `daily_snapshots` VALUES (107, 19, '2026-05-23', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-23 03:10:08');
INSERT INTO `daily_snapshots` VALUES (108, 20, '2026-05-23', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-23 03:10:08');
INSERT INTO `daily_snapshots` VALUES (109, 21, '2026-05-23', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-23 03:10:08');
INSERT INTO `daily_snapshots` VALUES (110, 22, '2026-05-23', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-23 03:10:08');
INSERT INTO `daily_snapshots` VALUES (111, 23, '2026-05-23', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-23 03:10:08');
INSERT INTO `daily_snapshots` VALUES (112, 24, '2026-05-23', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-23 03:10:08');
INSERT INTO `daily_snapshots` VALUES (113, 25, '2026-05-23', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-23 03:10:08');
INSERT INTO `daily_snapshots` VALUES (114, 26, '2026-05-23', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-23 03:10:08');
INSERT INTO `daily_snapshots` VALUES (115, 27, '2026-05-23', 0.00, 0.00, 0, 0, 0, NULL, NULL, '2026-05-23 03:10:08');
INSERT INTO `daily_snapshots` VALUES (116, 5, '2026-05-14', 150.00, 59.81, 2, 3, 58, 4, NULL, '2026-05-28 11:06:56');
INSERT INTO `daily_snapshots` VALUES (117, 5, '2026-05-15', 329.90, 39.87, 1, 4, 62, 5, NULL, '2026-05-28 11:06:56');
INSERT INTO `daily_snapshots` VALUES (118, 5, '2026-05-16', 99.90, 14.27, 0, 2, 55, 7, NULL, '2026-05-28 11:06:56');
INSERT INTO `daily_snapshots` VALUES (119, 5, '2026-05-17', 0.00, 0.00, 0, 0, NULL, NULL, NULL, '2026-05-28 11:06:56');
INSERT INTO `daily_snapshots` VALUES (120, 5, '2026-05-18', 224.80, 24.24, 1, 3, 60, 10, NULL, '2026-05-28 11:06:56');
INSERT INTO `daily_snapshots` VALUES (121, 5, '2026-05-24', 29.90, 29.90, 0, 1, 50, 4, NULL, '2026-05-28 11:06:56');
INSERT INTO `daily_snapshots` VALUES (122, 5, '2026-05-25', 299.00, 9.97, 0, 1, 60, 9, NULL, '2026-05-28 11:06:56');
INSERT INTO `daily_snapshots` VALUES (123, 5, '2026-05-26', 0.00, 0.00, 0, 0, NULL, NULL, NULL, '2026-05-28 11:06:56');
INSERT INTO `daily_snapshots` VALUES (124, 5, '2026-05-27', 99.90, 14.27, 0, 1, 55, 7, NULL, '2026-05-28 11:06:56');
INSERT INTO `daily_snapshots` VALUES (125, 5, '2026-05-28', 24.90, 24.90, 0, 1, 45, 6, NULL, '2026-05-28 11:06:56');
INSERT INTO `daily_snapshots` VALUES (126, 5, '2026-05-10', 29.90, 29.90, 1, 1, 60, 4, NULL, '2026-05-10 23:59:00');
INSERT INTO `daily_snapshots` VALUES (127, 5, '2026-05-11', 99.90, 14.27, 1, 1, 60, 7, NULL, '2026-05-11 23:59:00');
INSERT INTO `daily_snapshots` VALUES (128, 5, '2026-05-12', 328.90, 9.97, 1, 2, 60, 9, NULL, '2026-05-12 23:59:00');
INSERT INTO `daily_snapshots` VALUES (129, 5, '2026-05-13', 24.90, 24.90, 1, 1, 60, 6, NULL, '2026-05-13 23:59:00');
INSERT INTO `daily_snapshots` VALUES (130, 5, '2026-05-29', 29.90, 29.90, 0, 1, 60, 4, NULL, '2026-05-29 23:59:00');
INSERT INTO `daily_snapshots` VALUES (131, 5, '2026-05-30', 54.80, 29.90, 0, 2, 60, 4, NULL, '2026-05-30 23:59:00');
INSERT INTO `daily_snapshots` VALUES (132, 5, '2026-05-31', 24.90, 24.90, 0, 1, 60, 6, NULL, '2026-05-31 23:59:00');
INSERT INTO `daily_snapshots` VALUES (133, 5, '2026-06-01', 84.70, 79.80, 0, 3, 60, 4, NULL, '2026-06-01 23:59:00');
INSERT INTO `daily_snapshots` VALUES (134, 5, '2026-06-02', 129.80, 14.27, 0, 2, 60, 7, NULL, '2026-06-02 23:59:00');
INSERT INTO `daily_snapshots` VALUES (135, 5, '2026-06-03', 29.90, 29.90, 0, 1, 60, 4, NULL, '2026-06-03 23:59:00');
INSERT INTO `daily_snapshots` VALUES (136, 5, '2026-06-04', 323.90, 9.97, 1, 2, 60, 5, NULL, '2026-06-04 23:59:00');
INSERT INTO `daily_snapshots` VALUES (137, 5, '2026-06-05', 29.90, 29.90, 0, 1, 60, 4, NULL, '2026-06-05 23:59:00');
INSERT INTO `daily_snapshots` VALUES (138, 5, '2026-06-06', 24.90, 0.00, 0, 1, 60, 6, NULL, '2026-06-06 23:59:00');
INSERT INTO `daily_snapshots` VALUES (139, 5, '2026-06-07', 29.90, 0.00, 0, 1, 60, 4, NULL, '2026-06-07 23:59:00');
INSERT INTO `daily_snapshots` VALUES (140, 5, '2026-06-08', 54.80, 0.00, 1, 2, 60, 8, NULL, '2026-06-08 23:59:00');

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
) ENGINE = InnoDB AUTO_INCREMENT = 104 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '费用支出分类' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of expense_categories
-- ----------------------------
INSERT INTO `expense_categories` VALUES (1, 5, '采购支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (2, 6, '采购支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (3, 7, '采购支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (4, 15, '采购支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (5, 23, '采购支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (6, 8, '采购支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (7, 16, '采购支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (8, 24, '采购支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (9, 9, '采购支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (10, 17, '采购支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (11, 25, '采购支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (12, 10, '采购支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (13, 18, '采购支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (14, 26, '采购支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (15, 11, '采购支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (16, 19, '采购支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (17, 27, '采购支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (18, 12, '采购支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (19, 20, '采购支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (20, 13, '采购支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (21, 21, '采购支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (22, 14, '采购支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (23, 22, '采购支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (32, 5, '提成支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (33, 6, '提成支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (34, 7, '提成支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (35, 15, '提成支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (36, 23, '提成支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (37, 8, '提成支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (38, 16, '提成支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (39, 24, '提成支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (40, 9, '提成支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (41, 17, '提成支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (42, 25, '提成支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (43, 10, '提成支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (44, 18, '提成支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (45, 26, '提成支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (46, 11, '提成支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (47, 19, '提成支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (48, 27, '提成支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (49, 12, '提成支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (50, 20, '提成支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (51, 13, '提成支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (52, 21, '提成支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (53, 14, '提成支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (54, 22, '提成支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (63, 5, '退款支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (64, 6, '退款支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (65, 7, '退款支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (66, 15, '退款支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (67, 23, '退款支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (68, 8, '退款支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (69, 16, '退款支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (70, 24, '退款支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (71, 9, '退款支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (72, 17, '退款支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (73, 25, '退款支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (74, 10, '退款支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (75, 18, '退款支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (76, 26, '退款支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (77, 11, '退款支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (78, 19, '退款支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (79, 27, '退款支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (80, 12, '退款支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (81, 20, '退款支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (82, 13, '退款支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (83, 21, '退款支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (84, 14, '退款支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (85, 22, '退款支出', '2026-05-21 16:59:15', 0, NULL);
INSERT INTO `expense_categories` VALUES (94, 5, '薪资支出', '2026-05-22 13:25:31', 0, NULL);
INSERT INTO `expense_categories` VALUES (95, 5, '房租', '2026-05-28 10:46:03', 0, NULL);
INSERT INTO `expense_categories` VALUES (96, 5, '水电费', '2026-05-28 10:46:03', 0, NULL);
INSERT INTO `expense_categories` VALUES (97, 5, '人工成本', '2026-05-28 10:46:03', 0, NULL);
INSERT INTO `expense_categories` VALUES (98, 5, '营销推广', '2026-05-28 10:46:03', 0, NULL);
INSERT INTO `expense_categories` VALUES (99, 5, '设备维护', '2026-05-28 10:46:03', 0, NULL);
INSERT INTO `expense_categories` VALUES (100, 5, '清洁用品', '2026-05-28 10:46:03', 0, NULL);
INSERT INTO `expense_categories` VALUES (101, 5, '物料采购', '2026-06-09 22:28:51', 0, NULL);
INSERT INTO `expense_categories` VALUES (102, 5, '平台佣金', '2026-06-09 22:28:51', 0, NULL);
INSERT INTO `expense_categories` VALUES (103, 5, '活动费用', '2026-06-09 22:28:51', 0, NULL);

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
) ENGINE = InnoDB AUTO_INCREMENT = 39 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '费用支出表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of expenses
-- ----------------------------
INSERT INTO `expenses` VALUES (1, 5, 1, 4000.00, 'cash', '采购-虾丸手工物料批发', '2026-05-22', '2026-05-22 13:18:57', 0, NULL, 'purchase_order', 5, 9);
INSERT INTO `expenses` VALUES (2, 5, 1, 80.00, 'cash', '采购-杂货铺', '2026-05-22', '2026-05-22 13:19:10', 0, NULL, 'purchase_order', 4, 9);
INSERT INTO `expenses` VALUES (3, 5, 94, 3500.00, 'bank', '给员工发的工资', '2026-05-22', '2026-05-22 13:26:23', 0, NULL, 'manual', NULL, 9);
INSERT INTO `expenses` VALUES (4, 5, 32, 15.00, 'cash', '提成发放-张三1-2026-05', '2026-05-22', '2026-05-22 13:35:37', 0, NULL, 'commission', 1, 9);
INSERT INTO `expenses` VALUES (5, 5, 1, 300.00, 'cash', '采购-虾丸手工物料批发', '2026-05-22', '2026-05-22 15:56:51', 0, NULL, 'purchase_order', 6, 9);
INSERT INTO `expenses` VALUES (6, 5, 1, 100.00, 'cash', '采购-虾丸手工物料批发', '2026-05-22', '2026-05-22 16:34:54', 0, NULL, 'purchase_order', 7, 9);
INSERT INTO `expenses` VALUES (7, 5, 1, 200.00, 'cash', '采购-虾丸手工物料批发', '2026-05-22', '2026-05-22 16:35:38', 0, NULL, 'purchase_order', 8, 9);
INSERT INTO `expenses` VALUES (8, 5, 1, 200.00, 'cash', '采购-虾丸手工物料批发', '2026-05-25', '2026-05-25 09:07:38', 0, NULL, 'purchase_order', 9, 9);
INSERT INTO `expenses` VALUES (9, 5, 95, 5000.00, 'bank_transfer', '5月份店面租金', '2026-05-01', '2026-05-28 11:03:00', 0, NULL, 'manual', NULL, 43);
INSERT INTO `expenses` VALUES (10, 5, 96, 800.00, 'wechat', '5月份水电费', '2026-05-05', '2026-05-28 11:03:00', 0, NULL, 'manual', NULL, 43);
INSERT INTO `expenses` VALUES (11, 5, 97, 12000.00, 'bank_transfer', '5月份员工工资（4人）', '2026-05-10', '2026-05-28 11:03:00', 0, NULL, 'manual', NULL, 43);
INSERT INTO `expenses` VALUES (12, 5, 98, 1500.00, 'alipay', '抖音DOU+推广费用', '2026-05-12', '2026-05-28 11:03:00', 0, NULL, 'manual', NULL, 43);
INSERT INTO `expenses` VALUES (13, 5, 99, 350.00, 'cash', '印烫机维修保养', '2026-05-15', '2026-05-28 11:03:00', 0, NULL, 'manual', NULL, 43);
INSERT INTO `expenses` VALUES (14, 5, 100, 200.00, 'cash', '清洁用品采购', '2026-05-18', '2026-05-28 11:03:00', 0, NULL, 'manual', NULL, 43);
INSERT INTO `expenses` VALUES (15, 5, 1, 3500.00, 'bank_transfer', '拼豆物料补货', '2026-05-20', '2026-05-28 11:03:00', 0, NULL, 'manual', NULL, 43);
INSERT INTO `expenses` VALUES (16, 5, 1, 1200.00, 'wechat', '白模石膏玩偶补货', '2026-05-22', '2026-05-28 11:03:00', 0, NULL, 'manual', NULL, 43);
INSERT INTO `expenses` VALUES (17, 5, 94, 2000.00, 'bank_transfer', '兼职导玩员薪资', '2026-05-25', '2026-05-28 11:03:00', 0, NULL, 'manual', NULL, 43);
INSERT INTO `expenses` VALUES (18, 5, 98, 800.00, 'alipay', '美团推广费用', '2026-05-28', '2026-05-28 11:03:00', 0, NULL, 'manual', NULL, 43);
INSERT INTO `expenses` VALUES (19, 5, 95, 5000.00, 'bank_transfer', '5月份房租', '2026-05-10', '2026-05-10 09:00:00', 0, NULL, 'manual', NULL, 43);
INSERT INTO `expenses` VALUES (20, 5, 96, 850.00, 'wechat', '5月份水电费', '2026-05-12', '2026-05-12 10:00:00', 0, NULL, 'manual', NULL, 43);
INSERT INTO `expenses` VALUES (21, 5, 97, 12000.00, 'bank_transfer', '5月份员工工资', '2026-05-15', '2026-05-15 09:00:00', 0, NULL, 'manual', NULL, 43);
INSERT INTO `expenses` VALUES (22, 5, 98, 2000.00, 'alipay', '抖音DOU+推广', '2026-05-18', '2026-05-18 14:00:00', 0, NULL, 'manual', NULL, 43);
INSERT INTO `expenses` VALUES (23, 5, 99, 500.00, 'cash', '印烫机保养', '2026-05-20', '2026-05-20 16:00:00', 0, NULL, 'manual', NULL, 44);
INSERT INTO `expenses` VALUES (24, 5, 100, 150.00, 'cash', '清洁用品', '2026-05-22', '2026-05-22 11:00:00', 0, NULL, 'manual', NULL, 44);
INSERT INTO `expenses` VALUES (25, 5, 1, 3500.00, 'bank_transfer', '拼豆物料补货', '2026-05-25', '2026-05-25 10:00:00', 0, NULL, 'manual', NULL, 43);
INSERT INTO `expenses` VALUES (26, 5, 1, 1200.00, 'wechat', '配件采购', '2026-05-28', '2026-05-28 14:00:00', 0, NULL, 'manual', NULL, 43);
INSERT INTO `expenses` VALUES (27, 5, 94, 2000.00, 'bank_transfer', '兼职薪资', '2026-05-30', '2026-05-30 09:00:00', 0, NULL, 'manual', NULL, 43);
INSERT INTO `expenses` VALUES (28, 5, 98, 1500.00, 'alipay', '美团推广费', '2026-06-01', '2026-06-01 10:00:00', 0, NULL, 'manual', NULL, 43);
INSERT INTO `expenses` VALUES (29, 5, 1, 800.00, 'wechat', '颜料采购', '2026-06-02', '2026-06-02 15:00:00', 0, NULL, 'manual', NULL, 44);
INSERT INTO `expenses` VALUES (30, 5, 96, 900.00, 'wechat', '6月份水电费', '2026-06-05', '2026-06-05 10:00:00', 0, NULL, 'manual', NULL, 43);
INSERT INTO `expenses` VALUES (31, 5, 95, 5000.00, 'bank_transfer', '6月份房租', '2026-06-05', '2026-06-05 09:00:00', 0, NULL, 'manual', NULL, 43);
INSERT INTO `expenses` VALUES (32, 5, 1, 1500.00, 'bank_transfer', '豪华装采购', '2026-06-06', '2026-06-06 11:00:00', 0, NULL, 'manual', NULL, 44);
INSERT INTO `expenses` VALUES (33, 5, 97, 12000.00, 'bank_transfer', '6月份员工工资', '2026-06-08', '2026-06-08 09:00:00', 0, NULL, 'manual', NULL, 43);
INSERT INTO `expenses` VALUES (34, 5, 98, 800.00, 'alipay', '小红书推广', '2026-06-08', '2026-06-08 14:00:00', 0, NULL, 'manual', NULL, 43);
INSERT INTO `expenses` VALUES (35, 5, 99, 200.00, 'cash', '工具维修', '2026-06-09', '2026-06-09 10:00:00', 0, NULL, 'manual', NULL, 44);
INSERT INTO `expenses` VALUES (36, 5, 100, 100.00, 'cash', '清洁用品补充', '2026-06-09', '2026-06-09 11:00:00', 0, NULL, 'manual', NULL, 44);
INSERT INTO `expenses` VALUES (37, 5, 32, 500.00, 'bank_transfer', '5月提成发放', '2026-06-09', '2026-06-09 09:00:00', 0, NULL, 'manual', NULL, 43);
INSERT INTO `expenses` VALUES (38, 5, 63, 50.00, 'wechat', '退款支出', '2026-06-09', '2026-06-09 16:00:00', 0, NULL, 'manual', NULL, 43);

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
) ENGINE = InnoDB AUTO_INCREMENT = 34 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '顾客反馈表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of feedbacks
-- ----------------------------
INSERT INTO `feedbacks` VALUES (1, 5, 2, NULL, 1, 5, '带孩子来做手工拼豆，老师很有耐心，孩子玩得很开心！下次还来。', NULL, 2, '感谢您的认可！我们会继续努力，欢迎常来~', 45, '2026-05-20 15:00:00', '2026-05-20 14:30:00', '2026-05-23 10:12:39', 0, NULL);
INSERT INTO `feedbacks` VALUES (2, 5, 3, NULL, 2, 4, '建议增加更多亲子互动的套餐，比如家长和孩子一起完成的作品。另外停车位不太好找。', NULL, 1, NULL, NULL, NULL, '2026-05-22 10:15:00', '2026-05-22 10:15:00', 0, NULL);
INSERT INTO `feedbacks` VALUES (3, 5, 14, NULL, 3, 2, '上次预约了石膏涂色，到了之后说材料不够了，等了半小时才准备好，体验很不好。', NULL, 1, NULL, NULL, NULL, '2026-05-22 16:40:00', '2026-05-22 16:40:00', 0, NULL);
INSERT INTO `feedbacks` VALUES (4, 5, 15, NULL, 1, 5, '环境很干净，工具也很齐全，店员态度特别好。已经办了月卡，每周都带娃来。', NULL, 2, '谢谢您的支持和信任！月卡用户我们还会有专属活动哦，敬请期待~', 45, '2026-05-19 14:20:00', '2026-05-19 11:00:00', '2026-05-23 10:12:41', 0, NULL);
INSERT INTO `feedbacks` VALUES (5, 5, 2, NULL, 4, 3, '希望可以延长周末营业到晚上8点，下午4点多就关门有点早。', NULL, 1, NULL, NULL, NULL, '2026-05-23 09:00:00', '2026-05-23 09:00:00', 0, NULL);
INSERT INTO `feedbacks` VALUES (6, 5, 20, 5, 1, 5, '月卡太划算了，孩子每天都想来玩！店员服务态度特别好。', NULL, 2, NULL, NULL, NULL, '2026-05-02 12:00:00', '2026-05-28 11:02:19', 0, NULL);
INSERT INTO `feedbacks` VALUES (7, 5, 20, 6, 2, 4, '建议增加更多石膏模型的款式，目前选择有点少。', NULL, 1, NULL, NULL, NULL, '2026-05-03 16:00:00', '2026-05-28 11:02:19', 0, NULL);
INSERT INTO `feedbacks` VALUES (8, 5, 22, 7, 1, 5, '周卡性价比很高，拼豆图案很丰富，老师教得很仔细！', NULL, 2, NULL, NULL, NULL, '2026-05-04 12:30:00', '2026-05-28 11:02:19', 0, NULL);
INSERT INTO `feedbacks` VALUES (9, 5, 23, 8, 3, 2, '石膏涂色的颜料有几个干了不能用，希望店家注意一下耗材保养。', NULL, 1, NULL, NULL, NULL, '2026-05-05 16:00:00', '2026-05-28 11:02:19', 0, NULL);
INSERT INTO `feedbacks` VALUES (10, 5, 24, 9, 1, 5, '环境很棒，工具齐全，拼豆颜色选择多，孩子玩得不肯走。', NULL, 2, NULL, NULL, NULL, '2026-05-06 11:30:00', '2026-05-28 11:02:19', 0, NULL);
INSERT INTO `feedbacks` VALUES (11, 5, 25, 10, 1, 4, '创意月卡不错，每次来都有新项目可以体验。', NULL, 2, NULL, NULL, NULL, '2026-05-07 11:00:00', '2026-05-28 11:02:19', 0, NULL);
INSERT INTO `feedbacks` VALUES (12, 5, 26, 11, 4, 3, '周末人比较多，希望能提前预约座位。', NULL, 1, NULL, NULL, NULL, '2026-05-08 16:30:00', '2026-05-28 11:02:19', 0, NULL);
INSERT INTO `feedbacks` VALUES (13, 5, 20, NULL, 2, 4, '希望可以增加晚间营业时间，工作日白天没空来。', NULL, 1, NULL, NULL, NULL, '2026-05-20 20:00:00', '2026-05-28 11:02:19', 0, NULL);
INSERT INTO `feedbacks` VALUES (14, 5, 34, 15, 1, 5, '月卡太划算了，拼豆颜色很多，孩子玩得很开心！', NULL, 2, '感谢您的好评！欢迎下次再来～', 43, '2026-05-10 10:00:00', '2026-05-09 12:00:00', '2026-06-09 22:29:58', 0, NULL);
INSERT INTO `feedbacks` VALUES (15, 5, 35, 16, 2, 4, '美团团购的价格很实惠，但周末人有点多，等了一会儿。', NULL, 2, '感谢建议！周末建议提前预约哦～', 44, '2026-05-11 09:00:00', '2026-05-10 17:00:00', '2026-06-09 22:29:58', 0, NULL);
INSERT INTO `feedbacks` VALUES (16, 5, 36, 17, 1, 5, '周卡很适合亲子，孩子每天都要来！环境干净整洁。', NULL, 2, '谢谢支持！期待您和孩子再次光临～', 43, '2026-05-12 10:00:00', '2026-05-11 11:00:00', '2026-06-09 22:29:58', 0, NULL);
INSERT INTO `feedbacks` VALUES (17, 5, 37, 18, 1, 5, 'VIP月卡服务很好，工作人员很耐心指导。', NULL, 2, '感谢认可！我们会继续提供优质服务～', 44, '2026-05-13 09:00:00', '2026-05-12 13:00:00', '2026-06-09 22:29:58', 0, NULL);
INSERT INTO `feedbacks` VALUES (18, 5, 38, 19, 3, 2, '小程序预约的，但到了发现要等位，体验不太好。', NULL, 2, '非常抱歉给您带来不便！我们已优化预约系统，下次会更好！', 43, '2026-05-14 10:00:00', '2026-05-13 18:00:00', '2026-06-09 22:29:58', 0, NULL);
INSERT INTO `feedbacks` VALUES (19, 5, 39, 20, 1, 4, '月卡常客，每次都来拼豆，很满意。', NULL, 1, NULL, NULL, NULL, '2026-05-14 12:00:00', '2026-06-09 22:29:58', 0, NULL);
INSERT INTO `feedbacks` VALUES (20, 5, 40, 21, 1, 5, '亲子周卡太棒了，三个孩子都玩得很开心！', NULL, 2, '谢谢！孩子们开心就是我们最大的动力～', 43, '2026-05-16 10:00:00', '2026-05-15 16:00:00', '2026-06-09 22:29:58', 0, NULL);
INSERT INTO `feedbacks` VALUES (21, 5, 41, 22, 2, 4, '抖音团购来的，性价比高，但希望多些图案选择。', NULL, 2, '感谢建议！我们会更新更多图案模板～', 44, '2026-05-17 09:00:00', '2026-05-16 17:00:00', '2026-06-09 22:29:58', 0, NULL);
INSERT INTO `feedbacks` VALUES (22, 5, 42, 23, 1, 5, '孩子第一次涂石膏，玩得不亦乐乎！', NULL, 1, NULL, NULL, NULL, '2026-05-17 11:00:00', '2026-06-09 22:29:58', 0, NULL);
INSERT INTO `feedbacks` VALUES (23, 5, 43, 24, 1, 5, '小程序月卡很方便，随时来随时玩。', NULL, 2, '感谢支持！小程序预约更便捷哦～', 43, '2026-05-19 10:00:00', '2026-05-18 12:00:00', '2026-06-09 22:29:58', 0, NULL);
INSERT INTO `feedbacks` VALUES (24, 5, 44, 25, 4, 3, '周末人太多了，建议限流。', NULL, 2, '感谢反馈！我们已增加周末场次，欢迎预约～', 44, '2026-05-20 09:00:00', '2026-05-19 16:00:00', '2026-06-09 22:29:58', 0, NULL);
INSERT INTO `feedbacks` VALUES (25, 5, 45, 26, 1, 4, '美团团购涂色套餐，价格实惠。', NULL, 1, NULL, NULL, NULL, '2026-05-20 13:00:00', '2026-06-09 22:29:58', 0, NULL);
INSERT INTO `feedbacks` VALUES (26, 5, 46, 27, 1, 5, '带孙子来玩，老人家也能参与，很好！', NULL, 2, '谢谢！我们的项目适合全年龄段～', 43, '2026-05-22 10:00:00', '2026-05-21 18:00:00', '2026-06-09 22:29:58', 0, NULL);
INSERT INTO `feedbacks` VALUES (27, 5, 47, 28, 1, 5, '月卡续费了，太喜欢这里了！', NULL, 2, '感谢信任！我们会继续努力～', 44, '2026-05-23 09:00:00', '2026-05-22 12:00:00', '2026-06-09 22:29:58', 0, NULL);
INSERT INTO `feedbacks` VALUES (28, 5, 48, 29, 2, 4, '第一次来，环境不错，但停车有点难。', NULL, 2, '感谢建议！附近有停车场，下次可以咨询前台～', 43, '2026-05-24 10:00:00', '2026-05-23 15:00:00', '2026-06-09 22:29:58', 0, NULL);
INSERT INTO `feedbacks` VALUES (29, 5, 34, 30, 1, 5, '第二次来了，拼豆124色真的很多选择！', NULL, 1, NULL, NULL, NULL, '2026-05-24 12:00:00', '2026-06-09 22:29:58', 0, NULL);
INSERT INTO `feedbacks` VALUES (30, 5, 39, 33, 1, 5, '常客了，每次都满意而归。', NULL, 2, '感谢长期支持！～', 43, '2026-05-28 10:00:00', '2026-05-27 12:00:00', '2026-06-09 22:29:58', 0, NULL);
INSERT INTO `feedbacks` VALUES (31, 5, 43, 38, 1, 5, '儿童节活动很丰富，孩子玩疯了！', NULL, 2, '儿童节快乐！感谢参与活动～', 44, '2026-06-02 10:00:00', '2026-06-01 11:00:00', '2026-06-09 22:29:58', 0, NULL);
INSERT INTO `feedbacks` VALUES (32, 5, 34, 40, 1, 4, '石膏涂色很好玩，就是颜料干得有点快。', NULL, 2, '感谢提醒！我们会注意颜料保养～', 43, '2026-06-02 09:00:00', '2026-06-01 13:00:00', '2026-06-09 22:29:58', 0, NULL);
INSERT INTO `feedbacks` VALUES (33, 5, 45, 43, 1, 5, '美团月卡新用户，体验很好，会推荐朋友来！', NULL, 2, '感谢推荐！朋友来有优惠哦～', 44, '2026-06-05 10:00:00', '2026-06-04 13:00:00', '2026-06-09 22:29:58', 0, NULL);

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
) ENGINE = InnoDB AUTO_INCREMENT = 50 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '游玩/核销记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of game_sessions
-- ----------------------------
INSERT INTO `game_sessions` VALUES (1, 5, 3, 9, 9, '2026-05-21 15:24:32', '2026-05-21 15:56:35', 2, NULL, '2026-05-21 15:24:32', 0, NULL);
INSERT INTO `game_sessions` VALUES (2, 5, 3, 10, 9, '2026-05-22 13:14:56', '2026-05-22 13:15:59', 2, NULL, '2026-05-22 13:14:56', 0, NULL);
INSERT INTO `game_sessions` VALUES (3, 5, 15, 16, 9, '2026-05-22 13:15:49', '2026-05-22 13:19:42', 2, NULL, '2026-05-22 13:15:49', 0, NULL);
INSERT INTO `game_sessions` VALUES (4, 5, 3, 11, 9, '2026-05-23 08:35:27', '2026-05-23 12:40:00', 2, NULL, '2026-05-23 08:35:27', 0, NULL);
INSERT INTO `game_sessions` VALUES (5, 5, 20, 19, 43, '2026-05-02 10:00:00', '2026-05-02 11:05:00', 2, '拼豆创作', '2026-05-28 10:59:46', 0, NULL);
INSERT INTO `game_sessions` VALUES (6, 5, 20, 20, 43, '2026-05-03 14:00:00', '2026-05-03 15:00:00', 2, '石膏涂色', '2026-05-28 10:59:46', 0, NULL);
INSERT INTO `game_sessions` VALUES (7, 5, 22, 49, 44, '2026-05-04 10:30:00', '2026-05-04 11:30:00', 2, '拼豆卡通挂件', '2026-05-28 10:59:46', 0, NULL);
INSERT INTO `game_sessions` VALUES (8, 5, 23, 56, 43, '2026-05-05 14:00:00', '2026-05-05 15:00:00', 2, 'DIY石膏涂色', '2026-05-28 10:59:46', 0, NULL);
INSERT INTO `game_sessions` VALUES (9, 5, 24, 57, 44, '2026-05-06 10:00:00', '2026-05-06 10:55:00', 2, '拼豆124色', '2026-05-28 10:59:46', 0, NULL);
INSERT INTO `game_sessions` VALUES (10, 5, 25, 58, 43, '2026-05-07 09:30:00', '2026-05-07 10:30:00', 2, '创意月卡首次', '2026-05-28 10:59:46', 0, NULL);
INSERT INTO `game_sessions` VALUES (11, 5, 26, 88, 44, '2026-05-08 14:30:00', '2026-05-08 15:30:00', 2, '亲子周卡游玩', '2026-05-28 10:59:46', 0, NULL);
INSERT INTO `game_sessions` VALUES (12, 5, 29, 97, 43, '2026-05-15 10:00:00', '2026-05-28 11:00:00', 2, '月卡游玩进行中', '2026-05-28 10:59:46', 0, NULL);
INSERT INTO `game_sessions` VALUES (13, 5, 30, 127, 44, '2026-05-18 14:00:00', '2026-05-28 11:00:00', 2, '周卡游玩进行中', '2026-05-28 10:59:46', 0, NULL);
INSERT INTO `game_sessions` VALUES (14, 5, 29, 100, 43, '2026-05-18 10:00:00', '2026-05-18 10:15:00', 3, '顾客临时有事取消', '2026-05-28 10:59:46', 0, NULL);
INSERT INTO `game_sessions` VALUES (15, 5, 34, 135, 43, '2026-05-09 10:30:00', '2026-05-09 11:30:00', 2, '月卡首次拼豆', '2026-05-09 10:30:00', 0, NULL);
INSERT INTO `game_sessions` VALUES (16, 5, 35, 136, 44, '2026-05-10 15:00:00', '2026-05-10 16:00:00', 2, '美团单次体验', '2026-05-10 15:00:00', 0, NULL);
INSERT INTO `game_sessions` VALUES (17, 5, 36, 137, 43, '2026-05-11 09:30:00', '2026-05-11 10:30:00', 2, '周卡亲子拼豆', '2026-05-11 09:30:00', 0, NULL);
INSERT INTO `game_sessions` VALUES (18, 5, 37, 138, 44, '2026-05-12 11:15:00', '2026-05-12 12:15:00', 2, 'VIP创意月卡', '2026-05-12 11:15:00', 0, NULL);
INSERT INTO `game_sessions` VALUES (19, 5, 38, 139, 43, '2026-05-13 16:30:00', '2026-05-13 17:30:00', 2, '小程序涂色', '2026-05-13 16:30:00', 0, NULL);
INSERT INTO `game_sessions` VALUES (20, 5, 39, 140, 44, '2026-05-14 10:45:00', '2026-05-14 11:45:00', 2, '月卡常客', '2026-05-14 10:45:00', 0, NULL);
INSERT INTO `game_sessions` VALUES (21, 5, 40, 141, 43, '2026-05-15 14:00:00', '2026-05-15 15:00:00', 2, '亲子周卡', '2026-05-15 14:00:00', 0, NULL);
INSERT INTO `game_sessions` VALUES (22, 5, 41, 142, 44, '2026-05-16 15:15:00', '2026-05-16 16:15:00', 2, '抖音单次', '2026-05-16 15:15:00', 0, NULL);
INSERT INTO `game_sessions` VALUES (23, 5, 42, 143, 43, '2026-05-17 09:45:00', '2026-05-17 10:45:00', 2, '石膏涂色', '2026-05-17 09:45:00', 0, NULL);
INSERT INTO `game_sessions` VALUES (24, 5, 43, 144, 44, '2026-05-18 10:15:00', '2026-05-18 11:15:00', 2, '月卡首次', '2026-05-18 10:15:00', 0, NULL);
INSERT INTO `game_sessions` VALUES (25, 5, 44, 145, 43, '2026-05-19 14:15:00', '2026-05-19 15:15:00', 2, '周卡常客', '2026-05-19 14:15:00', 0, NULL);
INSERT INTO `game_sessions` VALUES (26, 5, 45, 146, 44, '2026-05-20 11:45:00', '2026-05-20 12:45:00', 2, '美团涂色', '2026-05-20 11:45:00', 0, NULL);
INSERT INTO `game_sessions` VALUES (27, 5, 46, 147, 43, '2026-05-21 16:15:00', '2026-05-21 17:15:00', 2, '现金单次', '2026-05-21 16:15:00', 0, NULL);
INSERT INTO `game_sessions` VALUES (28, 5, 47, 148, 44, '2026-05-22 10:00:00', '2026-05-22 11:00:00', 2, '月卡抖音', '2026-05-22 10:00:00', 0, NULL);
INSERT INTO `game_sessions` VALUES (29, 5, 48, 149, 43, '2026-05-23 13:30:00', '2026-05-23 14:30:00', 2, '新客石膏', '2026-05-23 13:30:00', 0, NULL);
INSERT INTO `game_sessions` VALUES (30, 5, 34, 150, 44, '2026-05-24 10:00:00', '2026-05-24 11:00:00', 2, '二次拼豆', '2026-05-24 10:00:00', 0, NULL);
INSERT INTO `game_sessions` VALUES (31, 5, 35, 151, 43, '2026-05-25 14:30:00', '2026-05-25 15:30:00', 2, '美团复购', '2026-05-25 14:30:00', 0, NULL);
INSERT INTO `game_sessions` VALUES (32, 5, 36, 152, 44, '2026-05-26 09:45:00', '2026-05-26 10:45:00', 2, '周卡期间', '2026-05-26 09:45:00', 0, NULL);
INSERT INTO `game_sessions` VALUES (33, 5, 39, 153, 43, '2026-05-27 10:30:00', '2026-05-27 11:30:00', 2, '常客拼豆', '2026-05-27 10:30:00', 0, NULL);
INSERT INTO `game_sessions` VALUES (34, 5, 40, 154, 44, '2026-05-28 11:00:00', '2026-05-28 12:00:00', 2, '亲子单次', '2026-05-28 11:00:00', 0, NULL);
INSERT INTO `game_sessions` VALUES (35, 5, 44, 155, 43, '2026-05-29 15:00:00', '2026-05-29 16:00:00', 2, '周末拼豆', '2026-05-29 15:00:00', 0, NULL);
INSERT INTO `game_sessions` VALUES (36, 5, 37, 156, 44, '2026-05-30 10:15:00', '2026-05-30 11:15:00', 2, 'VIP单次', '2026-05-30 10:15:00', 0, NULL);
INSERT INTO `game_sessions` VALUES (37, 5, 41, 157, 43, '2026-05-31 14:00:00', '2026-05-31 15:00:00', 2, '月末涂色', '2026-05-31 14:00:00', 0, NULL);
INSERT INTO `game_sessions` VALUES (38, 5, 43, 158, 44, '2026-06-01 09:30:00', '2026-06-01 10:30:00', 2, '儿童节拼豆', '2026-06-01 09:30:00', 0, NULL);
INSERT INTO `game_sessions` VALUES (39, 5, 44, 159, 43, '2026-06-01 10:00:00', '2026-06-01 11:00:00', 2, '儿童节涂色', '2026-06-01 10:00:00', 0, NULL);
INSERT INTO `game_sessions` VALUES (40, 5, 34, 160, 44, '2026-06-01 11:00:00', '2026-06-01 12:00:00', 2, '儿童节石膏', '2026-06-01 11:00:00', 0, NULL);
INSERT INTO `game_sessions` VALUES (41, 5, 39, 161, 43, '2026-06-02 10:30:00', '2026-06-02 11:30:00', 2, '周卡常客', '2026-06-02 10:30:00', 0, NULL);
INSERT INTO `game_sessions` VALUES (42, 5, 40, 162, 44, '2026-06-03 14:00:00', '2026-06-03 15:00:00', 2, '亲子消费', '2026-06-03 14:00:00', 0, NULL);
INSERT INTO `game_sessions` VALUES (43, 5, 45, 163, 43, '2026-06-04 11:30:00', '2026-06-04 12:30:00', 2, '美团月卡新', '2026-06-04 11:30:00', 0, NULL);
INSERT INTO `game_sessions` VALUES (44, 5, 47, 164, 44, '2026-06-05 10:00:00', '2026-06-09 22:30:00', 2, '月卡续费游玩中', '2026-06-05 10:00:00', 0, NULL);
INSERT INTO `game_sessions` VALUES (45, 5, 48, 165, 43, '2026-06-06 09:30:00', '2026-06-09 22:30:00', 2, '周末涂色进行中', '2026-06-06 09:30:00', 0, NULL);
INSERT INTO `game_sessions` VALUES (46, 5, 36, 166, 44, '2026-06-07 10:00:00', '2026-06-07 10:15:00', 3, '顾客临时有事取消', '2026-06-07 10:00:00', 0, NULL);
INSERT INTO `game_sessions` VALUES (47, 5, 42, 167, 43, '2026-06-08 14:30:00', '2026-06-08 14:45:00', 3, '材料不足取消', '2026-06-08 14:30:00', 0, NULL);
INSERT INTO `game_sessions` VALUES (48, 5, 44, 168, 44, '2026-06-09 09:45:00', '2026-06-09 22:30:00', 2, '今日拼豆进行中', '2026-06-09 09:45:00', 0, NULL);
INSERT INTO `game_sessions` VALUES (49, 5, 34, 169, 43, '2026-06-09 10:30:00', '2026-06-09 22:30:00', 2, '今日涂色进行中', '2026-06-09 10:30:00', 0, NULL);

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
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '当前库存表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of inventory
-- ----------------------------
INSERT INTO `inventory` VALUES (1, 5, 6, 3.00, '2026-05-22 13:19:13', 0, NULL);
INSERT INTO `inventory` VALUES (2, 5, 5, 50.00, '2026-05-20 16:24:59', 0, NULL);
INSERT INTO `inventory` VALUES (3, 5, 3, 218.00, '2026-05-28 11:00:00', 0, NULL);
INSERT INTO `inventory` VALUES (4, 5, 2, 47.00, '2026-05-23 12:40:00', 0, NULL);
INSERT INTO `inventory` VALUES (5, 5, 1, 148.00, '2026-05-28 11:00:00', 0, NULL);
INSERT INTO `inventory` VALUES (6, 5, 10, 100.00, '2026-05-22 13:19:02', 0, NULL);
INSERT INTO `inventory` VALUES (7, 5, 9, 100.00, '2026-05-22 13:19:02', 0, NULL);
INSERT INTO `inventory` VALUES (8, 5, 8, 49.00, '2026-05-22 13:19:42', 0, NULL);
INSERT INTO `inventory` VALUES (9, 5, 7, 99.00, '2026-05-23 12:40:00', 0, NULL);
INSERT INTO `inventory` VALUES (10, 5, 4, 4.00, '2026-05-25 09:07:41', 0, NULL);
INSERT INTO `inventory` VALUES (11, 5, 11, 30.00, '2026-06-09 22:28:51', 0, NULL);
INSERT INTO `inventory` VALUES (12, 5, 12, 50.00, '2026-06-09 22:28:51', 0, NULL);
INSERT INTO `inventory` VALUES (13, 5, 13, 200.00, '2026-06-09 22:28:51', 0, NULL);
INSERT INTO `inventory` VALUES (14, 5, 14, 25.00, '2026-06-09 22:28:51', 0, NULL);
INSERT INTO `inventory` VALUES (15, 5, 15, 300.00, '2026-06-09 22:28:51', 0, NULL);

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
) ENGINE = InnoDB AUTO_INCREMENT = 70 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '库存出入库流水' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of inventory_transactions
-- ----------------------------
INSERT INTO `inventory_transactions` VALUES (1, 5, 6, 1, 1.00, 1.00, NULL, NULL, 9, '超市购买', '2026-05-20 16:24:08', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (2, 5, 5, 1, 50.00, 50.00, NULL, NULL, 9, '超市购买', '2026-05-20 16:24:59', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (3, 5, 3, 1, 100.00, 100.00, 'purchase_order', 1, NULL, NULL, '2026-05-20 16:34:36', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (4, 5, 2, 1, 50.00, 50.00, 'purchase_order', 1, NULL, NULL, '2026-05-20 16:34:36', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (5, 5, 1, 1, 100.00, 100.00, 'purchase_order', 2, NULL, NULL, '2026-05-21 08:03:07', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (6, 5, 3, 1, 50.00, 150.00, 'purchase_order', 3, NULL, NULL, '2026-05-21 08:13:26', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (7, 5, 2, 2, 1.00, 49.00, 'game_session', 1, 9, '游玩核销消耗', '2026-05-21 15:56:35', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (8, 5, 2, 2, 1.00, 48.00, 'game_session', 2, 9, '游玩核销消耗', '2026-05-22 13:15:59', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (9, 5, 10, 1, 100.00, 100.00, 'purchase_order', 5, NULL, NULL, '2026-05-22 13:19:02', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (10, 5, 9, 1, 100.00, 100.00, 'purchase_order', 5, NULL, NULL, '2026-05-22 13:19:02', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (11, 5, 8, 1, 50.00, 50.00, 'purchase_order', 5, NULL, NULL, '2026-05-22 13:19:02', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (12, 5, 7, 1, 100.00, 100.00, 'purchase_order', 5, NULL, NULL, '2026-05-22 13:19:02', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (13, 5, 1, 1, 50.00, 150.00, 'purchase_order', 5, NULL, NULL, '2026-05-22 13:19:02', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (14, 5, 4, 1, 1.00, 1.00, 'purchase_order', 5, NULL, NULL, '2026-05-22 13:19:02', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (15, 5, 3, 1, 70.00, 220.00, 'purchase_order', 5, NULL, NULL, '2026-05-22 13:19:02', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (16, 5, 6, 1, 2.00, 3.00, 'purchase_order', 4, NULL, NULL, '2026-05-22 13:19:13', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (17, 5, 8, 2, 1.00, 49.00, 'game_session', 3, 9, '游玩核销消耗', '2026-05-22 13:19:42', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (18, 5, 4, 1, 3.00, 4.00, 'purchase_order', 6, NULL, NULL, '2026-05-22 15:56:54', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (19, 5, 4, 2, 3.00, 1.00, NULL, NULL, 9, '使用损坏', '2026-05-22 15:57:55', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (20, 5, 4, 1, 1.00, 2.00, 'purchase_order', 7, NULL, NULL, '2026-05-22 16:34:56', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (21, 5, 4, 1, 2.00, 4.00, 'purchase_order', 8, NULL, NULL, '2026-05-22 16:35:41', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (22, 5, 4, 2, 2.00, 2.00, NULL, NULL, 9, '损坏', '2026-05-22 16:35:56', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (23, 5, 2, 2, 1.00, 47.00, 'game_session', 4, 9, '游玩核销消耗', '2026-05-23 12:40:00', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (24, 5, 7, 2, 1.00, 99.00, 'game_session', 4, 9, '游玩核销消耗', '2026-05-23 12:40:00', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (25, 5, 4, 1, 2.00, 4.00, 'purchase_order', 9, NULL, NULL, '2026-05-25 09:07:41', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (26, 5, 1, 2, 1.00, 149.00, 'game_session', 12, 43, '游玩核销消耗', '2026-05-28 11:00:00', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (27, 5, 3, 2, 1.00, 219.00, 'game_session', 12, 43, '游玩核销消耗', '2026-05-28 11:00:00', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (28, 5, 1, 2, 1.00, 148.00, 'game_session', 13, 44, '游玩核销消耗', '2026-05-28 11:00:00', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (29, 5, 3, 2, 1.00, 218.00, 'game_session', 13, 44, '游玩核销消耗', '2026-05-28 11:00:00', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (30, 5, 3, 2, -20.00, 200.00, 'game_session', 5, 43, '拼豆124色出库（日常消耗）', '2026-05-28 11:04:23', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (31, 5, 1, 2, -10.00, 140.00, 'game_session', 6, 43, '拼豆板材30*30出库', '2026-05-28 11:04:23', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (32, 5, 8, 2, -5.00, 44.00, 'game_session', 8, 43, '白模石膏玩偶出库', '2026-05-28 11:04:23', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (33, 5, 3, 2, -15.00, 185.00, 'game_session', 7, 44, '拼豆124色出库', '2026-05-28 11:04:23', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (34, 5, 5, 2, -5.00, 45.00, 'game_session', 5, 43, '垃圾袋出库', '2026-05-28 11:04:23', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (35, 5, 3, 1, 50.00, 235.00, 'purchase_order', 9, 43, '拼豆124色补货入库', '2026-05-28 11:04:23', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (36, 5, 1, 1, 30.00, 170.00, 'purchase_order', 9, 43, '拼豆板材30*30补货', '2026-05-28 11:04:23', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (37, 5, 8, 1, 20.00, 64.00, 'purchase_order', 9, 43, '白模石膏玩偶补货', '2026-05-28 11:04:23', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (38, 5, 7, 2, -10.00, 89.00, 'game_session', 9, 44, '拼豆256色出库', '2026-05-28 11:04:23', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (39, 5, 9, 2, -8.00, 92.00, 'game_session', 10, 43, '钥匙扣组装件出库', '2026-05-28 11:04:23', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (40, 5, 3, 1, 100.00, 335.00, 'purchase_order', 10, 43, '拼豆124色补货', '2026-05-10 11:00:00', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (41, 5, 1, 1, 50.00, 220.00, 'purchase_order', 10, 43, '拼豆板材补货', '2026-05-10 11:00:00', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (42, 5, 7, 1, 30.00, 119.00, 'purchase_order', 10, 43, '拼豆256色补货', '2026-05-10 11:00:00', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (43, 5, 9, 1, 100.00, 192.00, 'purchase_order', 11, 43, '钥匙扣入库', '2026-05-15 15:00:00', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (44, 5, 14, 1, 20.00, 45.00, 'purchase_order', 12, 44, '颜料入库', '2026-05-20 12:00:00', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (45, 5, 13, 1, 100.00, 300.00, 'purchase_order', 12, 44, '热熔胶入库', '2026-05-20 12:00:00', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (46, 5, 8, 1, 50.00, 114.00, 'purchase_order', 13, 43, '石膏补货', '2026-05-25 10:00:00', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (47, 5, 15, 1, 500.00, 800.00, 'purchase_order', 14, 44, '包装袋入库', '2026-05-30 11:00:00', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (48, 5, 12, 1, 30.00, 80.00, 'purchase_order', 15, 43, '相框入库', '2026-06-02 15:00:00', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (49, 5, 11, 1, 20.00, 50.00, 'purchase_order', 16, 44, '豪华装入库', '2026-06-05 12:00:00', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (50, 5, 3, 2, -15.00, 320.00, 'game_session', 15, 43, '拼豆124色消耗', '2026-05-09 11:30:00', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (51, 5, 1, 2, -5.00, 215.00, 'game_session', 15, 43, '板材消耗', '2026-05-09 11:30:00', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (52, 5, 3, 2, -10.00, 310.00, 'game_session', 17, 44, '周卡拼豆消耗', '2026-05-11 10:30:00', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (53, 5, 8, 2, -3.00, 111.00, 'game_session', 19, 43, '石膏消耗', '2026-05-13 17:30:00', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (54, 5, 3, 2, -12.00, 298.00, 'game_session', 20, 44, '月卡拼豆消耗', '2026-05-14 11:45:00', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (55, 5, 9, 2, -8.00, 184.00, 'game_session', 21, 43, '钥匙扣消耗', '2026-05-15 15:00:00', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (56, 5, 3, 2, -20.00, 278.00, 'game_session', 24, 44, '月卡大单消耗', '2026-05-18 11:15:00', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (57, 5, 14, 2, -5.00, 40.00, 'game_session', 26, 43, '颜料消耗', '2026-05-20 12:45:00', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (58, 5, 3, 2, -18.00, 260.00, 'game_session', 28, 44, '周卡消耗', '2026-05-22 11:00:00', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (59, 5, 8, 2, -5.00, 106.00, 'game_session', 29, 43, '石膏消耗', '2026-05-23 14:30:00', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (60, 5, 3, 2, -15.00, 245.00, 'game_session', 33, 44, '常客消耗', '2026-05-27 11:30:00', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (61, 5, 1, 2, -8.00, 207.00, 'game_session', 35, 43, '板材消耗', '2026-05-29 16:00:00', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (62, 5, 3, 2, -10.00, 235.00, 'game_session', 38, 44, '儿童节消耗', '2026-06-01 10:30:00', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (63, 5, 8, 2, -4.00, 102.00, 'game_session', 40, 43, '儿童节石膏', '2026-06-01 12:00:00', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (64, 5, 3, 2, -12.00, 223.00, 'game_session', 41, 44, '周卡消耗', '2026-06-02 11:30:00', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (65, 5, 14, 2, -8.00, 32.00, 'game_session', 42, 43, '颜料消耗', '2026-06-03 15:00:00', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (66, 5, 3, 2, -10.00, 213.00, 'game_session', 43, 44, '月卡消耗', '2026-06-04 12:30:00', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (67, 5, 5, 2, -20.00, 780.00, 'game_session', 30, 43, '垃圾袋消耗', '2026-05-24 11:00:00', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (68, 5, 15, 2, -30.00, 770.00, 'game_session', 36, 44, '包装袋消耗', '2026-05-30 11:15:00', 0, NULL);
INSERT INTO `inventory_transactions` VALUES (69, 5, 13, 2, -15.00, 285.00, 'game_session', 39, 43, '热熔胶消耗', '2026-06-01 11:00:00', 0, NULL);

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
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '发票记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of invoices
-- ----------------------------
INSERT INTO `invoices` VALUES (1, 5, 'purchase_order', 5, '112233', 4400.00, '2026-05-22', '2026-05-22 15:27:10', 0, NULL, NULL, NULL);
INSERT INTO `invoices` VALUES (2, 5, 'purchase_order', 4, '001144', 80.00, '2026-05-22', '2026-05-22 15:42:45', 0, NULL, NULL, '杂货铺 - ¥80');
INSERT INTO `invoices` VALUES (3, 5, 'purchase_order', 2, '1111111111', 500.00, '2026-05-22', '2026-05-22 15:53:39', 0, NULL, NULL, 'PO1779321726536 - AAA拼豆批发商 - ¥500');
INSERT INTO `invoices` VALUES (4, 5, 'purchase_order', 9, '123123123123', 200.00, '2026-05-25', '2026-05-25 11:07:50', 0, NULL, NULL, 'PO1779671244273-4800 - 虾丸手工物料批发 - ¥200');
INSERT INTO `invoices` VALUES (5, 5, 'purchase_order', 8, '123123123', 200.00, '2026-05-25', '2026-05-25 13:13:19', 0, NULL, '5/invoice/20260525131319091_600816601.png', 'PO1779438931293 - 虾丸手工物料批发 - ¥200');
INSERT INTO `invoices` VALUES (6, 5, 'expense', 9, 'INV2026051001', 12000.00, '2026-05-10', '2026-05-28 11:03:01', 0, NULL, NULL, NULL);
INSERT INTO `invoices` VALUES (7, 5, 'purchase_order', 5, 'INV2026052001', 4400.00, '2026-05-20', '2026-05-28 11:03:01', 0, NULL, NULL, NULL);
INSERT INTO `invoices` VALUES (8, 5, 'expense', 3, 'INV2026052201', 3500.00, '2026-05-22', '2026-05-28 11:03:01', 0, NULL, NULL, NULL);
INSERT INTO `invoices` VALUES (9, 5, 'expense', 21, 'INV2026051501', 12000.00, '2026-05-15', '2026-05-15 09:00:00', 0, NULL, NULL, NULL);
INSERT INTO `invoices` VALUES (10, 5, 'purchase_order', 10, 'INV2026051001', 3500.00, '2026-05-10', '2026-05-10 11:00:00', 0, NULL, NULL, NULL);
INSERT INTO `invoices` VALUES (11, 5, 'expense', 19, 'INV2026051002', 5000.00, '2026-05-10', '2026-05-10 09:00:00', 0, NULL, NULL, NULL);
INSERT INTO `invoices` VALUES (12, 5, 'purchase_order', 11, 'INV2026051502', 1200.00, '2026-05-15', '2026-05-15 15:00:00', 0, NULL, NULL, NULL);
INSERT INTO `invoices` VALUES (13, 5, 'purchase_order', 12, 'INV2026052001', 800.00, '2026-05-20', '2026-05-20 12:00:00', 0, NULL, NULL, NULL);
INSERT INTO `invoices` VALUES (14, 5, 'expense', 33, 'INV2026060801', 12000.00, '2026-06-08', '2026-06-08 09:00:00', 0, NULL, NULL, NULL);
INSERT INTO `invoices` VALUES (15, 5, 'expense', 31, 'INV2026060501', 5000.00, '2026-06-05', '2026-06-05 09:00:00', 0, NULL, NULL, NULL);
INSERT INTO `invoices` VALUES (16, 5, 'purchase_order', 16, 'INV2026060502', 1500.00, '2026-06-05', '2026-06-05 12:00:00', 0, NULL, NULL, NULL);

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
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '物料/货物基础信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of materials
-- ----------------------------
INSERT INTO `materials` VALUES (1, 5, '拼豆板材（30*30）', 'pdbc-001', '手工材料', '个', 1, 20.00, NULL, NULL, 0, '2026-05-20 15:01:25', '2026-05-20 15:01:25', NULL);
INSERT INTO `materials` VALUES (2, 5, '拼豆板材（50*50）', 'pdbc-002', '手工材料', '个', 1, 20.00, NULL, NULL, 0, '2026-05-20 15:04:12', '2026-05-20 15:04:12', NULL);
INSERT INTO `materials` VALUES (3, 5, '拼豆（124色）', 'pd-001', '手工材料', '套', 1, 20.00, NULL, NULL, 0, '2026-05-20 15:04:48', '2026-05-20 15:04:48', NULL);
INSERT INTO `materials` VALUES (4, 5, '印烫机', 'ytj01', '工具配件', '台', 2, 3.00, NULL, NULL, 0, '2026-05-20 15:05:56', '2026-05-22 15:56:16', NULL);
INSERT INTO `materials` VALUES (5, 5, '垃圾袋', 'ljd', '清洁用品', '卷', 1, 10.00, NULL, NULL, 0, '2026-05-20 15:10:02', '2026-05-20 15:10:02', NULL);
INSERT INTO `materials` VALUES (6, 5, '拖把', 'tb', '清洁用品', '个', 2, 1.00, NULL, NULL, 0, '2026-05-20 15:10:39', '2026-05-20 15:10:39', NULL);
INSERT INTO `materials` VALUES (7, 5, '拼豆（256色）', 'pd-002', '手工材料', '套', 1, 20.00, NULL, NULL, 0, '2026-05-21 08:35:37', '2026-05-21 08:35:37', NULL);
INSERT INTO `materials` VALUES (8, 5, '白模石膏玩偶', 'sg1', '手工材料', '个', 1, 20.00, NULL, NULL, 0, '2026-05-21 08:36:37', '2026-05-21 08:36:37', NULL);
INSERT INTO `materials` VALUES (9, 5, '钥匙扣组装件', 'zzj01', '工具配件', '个', 1, 20.00, NULL, NULL, 0, '2026-05-21 08:37:07', '2026-05-21 08:37:07', NULL);
INSERT INTO `materials` VALUES (10, 5, '手工垫（50*120）', 'sgd01', '工具配件', '个', 2, 10.00, NULL, NULL, 0, '2026-05-21 08:38:41', '2026-05-21 08:38:41', NULL);
INSERT INTO `materials` VALUES (11, 5, '拼豆（512色豪华装）', 'BEAD-512', '手工材料', '盒', 1, 10.00, NULL, '高端拼豆套装', 0, '2026-06-09 22:28:51', '2026-06-09 22:28:51', NULL);
INSERT INTO `materials` VALUES (12, 5, '亚克力相框（A4）', 'FRAME-A4', '工具配件', '个', 2, 20.00, NULL, '成品展示用', 0, '2026-06-09 22:28:51', '2026-06-09 22:28:51', NULL);
INSERT INTO `materials` VALUES (13, 5, '热熔胶棒', 'GLUE-STICK', '辅助材料', '根', 1, 50.00, NULL, '粘合用', 0, '2026-06-09 22:28:51', '2026-06-09 22:28:51', NULL);
INSERT INTO `materials` VALUES (14, 5, '丙烯颜料套装', 'PAINT-SET', '手工材料', '套', 1, 15.00, NULL, '石膏涂色用', 0, '2026-06-09 22:28:51', '2026-06-09 22:28:51', NULL);
INSERT INTO `materials` VALUES (15, 5, '包装袋（中号）', 'BAG-M', '包装材料', '个', 1, 100.00, NULL, '成品包装', 0, '2026-06-09 22:28:51', '2026-06-09 22:28:51', NULL);

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
) ENGINE = InnoDB AUTO_INCREMENT = 111 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '消息通知日志' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of notification_logs
-- ----------------------------
INSERT INTO `notification_logs` VALUES (1, 13, 2, 16, 3, '席位即将到期', '您的席位将于 2026-05-22 到期（剩余3天），请及时续订，以免影响店铺运营。', 1, NULL, NULL, '2026-05-19 08:00:00');
INSERT INTO `notification_logs` VALUES (2, 21, 2, 16, 3, '席位即将到期', '您的席位将于 2026-05-22 到期（剩余3天），请及时续订，以免影响店铺运营。', 1, NULL, NULL, '2026-05-19 08:00:00');
INSERT INTO `notification_logs` VALUES (3, 12, 2, 15, 3, '席位即将到期', '您的席位将于 2026-05-20 到期（剩余1天），请及时续订，以免影响店铺运营。', 1, NULL, NULL, '2026-05-19 08:00:00');
INSERT INTO `notification_logs` VALUES (4, 20, 2, 15, 3, '席位即将到期', '您的席位将于 2026-05-20 到期（剩余1天），请及时续订，以免影响店铺运营。', 1, NULL, NULL, '2026-05-19 08:00:00');
INSERT INTO `notification_logs` VALUES (5, 12, 2, 15, 3, '席位已到期', '您的席位已于 2026-05-20 到期，店铺功能受限。请续订以恢复正常。', 1, NULL, NULL, '2026-05-21 07:46:02');
INSERT INTO `notification_logs` VALUES (6, 20, 2, 15, 3, '席位已到期', '您的席位已于 2026-05-20 到期，店铺功能受限。请续订以恢复正常。', 1, NULL, NULL, '2026-05-21 07:46:02');
INSERT INTO `notification_logs` VALUES (7, 7, 2, 10, 3, '席位即将到期', '您的席位将于 2026-06-20 到期（剩余30天），请及时续订，以免影响店铺运营。', 1, NULL, NULL, '2026-05-21 08:00:00');
INSERT INTO `notification_logs` VALUES (8, 15, 2, 10, 3, '席位即将到期', '您的席位将于 2026-06-20 到期（剩余30天），请及时续订，以免影响店铺运营。', 1, NULL, NULL, '2026-05-21 08:00:00');
INSERT INTO `notification_logs` VALUES (9, 23, 2, 10, 3, '席位即将到期', '您的席位将于 2026-06-20 到期（剩余30天），请及时续订，以免影响店铺运营。', 1, NULL, NULL, '2026-05-21 08:00:00');
INSERT INTO `notification_logs` VALUES (10, 13, 2, 16, 3, '席位即将到期', '您的席位将于 2026-05-22 到期（剩余1天），请及时续订，以免影响店铺运营。', 1, NULL, NULL, '2026-05-21 08:00:00');
INSERT INTO `notification_logs` VALUES (11, 21, 2, 16, 3, '席位即将到期', '您的席位将于 2026-05-22 到期（剩余1天），请及时续订，以免影响店铺运营。', 1, NULL, NULL, '2026-05-21 08:00:00');
INSERT INTO `notification_logs` VALUES (12, 5, 2, 45, 3, '库存预警', '物料【拖把】（tb）库存不足，当前库存 1.00，最低预警线 1.00。请及时采购。', 1, NULL, NULL, '2026-05-21 10:00:00');
INSERT INTO `notification_logs` VALUES (13, 5, 2, 45, 3, '库存预警', '物料【拖把】（tb）库存不足，当前库存 1.00，最低预警线 1.00。请及时采购。', 1, NULL, NULL, '2026-05-22 10:00:00');
INSERT INTO `notification_logs` VALUES (14, 5, 2, 45, 3, '库存预警', '物料【印烫机】（ytj01）库存不足，当前库存 1.00，最低预警线 3.00。请及时采购。', 2, NULL, NULL, '2026-05-22 15:57:55');
INSERT INTO `notification_logs` VALUES (15, 5, 2, 45, 3, '库存预警', '物料【印烫机】（ytj01）库存不足，当前库存 2.00，最低预警线 3.00。请及时采购。', 2, NULL, NULL, '2026-05-22 16:35:56');
INSERT INTO `notification_logs` VALUES (16, 13, 2, 16, 3, '席位已到期', '您的席位已于 2026-05-22 到期，店铺功能受限。请续订以恢复正常。', 1, NULL, NULL, '2026-05-23 03:10:08');
INSERT INTO `notification_logs` VALUES (17, 21, 2, 16, 3, '席位已到期', '您的席位已于 2026-05-22 到期，店铺功能受限。请续订以恢复正常。', 1, NULL, NULL, '2026-05-23 03:10:08');
INSERT INTO `notification_logs` VALUES (18, 5, 2, 45, 3, '库存预警', '物料【印烫机】（ytj01）库存不足，当前库存 2.00，最低预警线 3.00。请及时采购。', 2, NULL, NULL, '2026-05-23 08:00:00');
INSERT INTO `notification_logs` VALUES (19, 5, 2, 9, 3, '库存预警', '物料【印烫机】（ytj01）库存不足，当前库存 2.00，最低预警线 3.00。请及时采购。', 2, NULL, NULL, '2026-05-23 08:00:00');
INSERT INTO `notification_logs` VALUES (20, 5, 2, 45, 4, '高温补贴通知', '每人一杯奶茶', 1, NULL, NULL, '2026-05-23 08:09:24');
INSERT INTO `notification_logs` VALUES (21, 5, 2, 9, 3, '游玩时长提醒', '套餐「拼豆周卡（7天畅玩）」已超过规定时长 60 分钟（已持续 64 分钟），请确认是否结束', 2, NULL, NULL, '2026-05-23 09:40:00');
INSERT INTO `notification_logs` VALUES (22, 5, 2, 9, 3, '游玩时长提醒', '套餐「拼豆周卡（7天畅玩）」已超过规定时长 60 分钟（已持续 69 分钟），请确认是否结束', 2, NULL, NULL, '2026-05-23 09:45:00');
INSERT INTO `notification_logs` VALUES (23, 5, 2, 9, 3, '游玩时长提醒', '套餐「拼豆周卡（7天畅玩）」已超过规定时长 60 分钟（已持续 74 分钟），请确认是否结束', 2, NULL, NULL, '2026-05-23 09:50:00');
INSERT INTO `notification_logs` VALUES (24, 5, 2, 9, 3, '游玩时长提醒', '套餐「拼豆周卡（7天畅玩）」已超过规定时长 60 分钟（已持续 79 分钟），请确认是否结束', 2, NULL, NULL, '2026-05-23 09:55:00');
INSERT INTO `notification_logs` VALUES (25, 5, 2, 9, 3, '游玩时长提醒', '套餐「拼豆周卡（7天畅玩）」已超过规定时长 60 分钟（已持续 84 分钟），请确认是否结束', 2, NULL, NULL, '2026-05-23 10:00:00');
INSERT INTO `notification_logs` VALUES (26, 5, 2, 9, 3, '游玩时长提醒', '套餐「拼豆周卡（7天畅玩）」已超过规定时长 60 分钟（已持续 89 分钟），请确认是否结束', 2, NULL, NULL, '2026-05-23 10:05:00');
INSERT INTO `notification_logs` VALUES (27, 5, 2, 9, 3, '游玩时长提醒', '套餐「拼豆周卡（7天畅玩）」已超过规定时长 60 分钟（已持续 94 分钟），请确认是否结束', 2, NULL, NULL, '2026-05-23 10:10:00');
INSERT INTO `notification_logs` VALUES (28, 5, 2, 9, 3, '游玩时长提醒', '套餐「拼豆周卡（7天畅玩）」已超过规定时长 60 分钟（已持续 99 分钟），请确认是否结束', 2, NULL, NULL, '2026-05-23 10:15:00');
INSERT INTO `notification_logs` VALUES (29, 5, 2, 9, 3, '游玩时长提醒', '套餐「拼豆周卡（7天畅玩）」已超过规定时长 60 分钟（已持续 104 分钟），请确认是否结束', 2, NULL, NULL, '2026-05-23 10:20:00');
INSERT INTO `notification_logs` VALUES (30, 5, 2, 9, 3, '游玩时长提醒', '套餐「拼豆周卡（7天畅玩）」已超过规定时长 60 分钟（已持续 109 分钟），请确认是否结束', 2, NULL, NULL, '2026-05-23 10:25:00');
INSERT INTO `notification_logs` VALUES (31, 5, 2, 9, 3, '游玩时长提醒', '套餐「拼豆周卡（7天畅玩）」已超过规定时长 60 分钟（已持续 114 分钟），请确认是否结束', 2, NULL, NULL, '2026-05-23 10:30:00');
INSERT INTO `notification_logs` VALUES (32, 5, 2, 9, 3, '游玩时长提醒', '套餐「拼豆周卡（7天畅玩）」已超过规定时长 60 分钟（已持续 119 分钟），请确认是否结束', 2, NULL, NULL, '2026-05-23 10:35:00');
INSERT INTO `notification_logs` VALUES (33, 5, 2, 9, 3, '游玩时长提醒', '套餐「拼豆周卡（7天畅玩）」已超过规定时长 60 分钟（已持续 124 分钟），请确认是否结束', 2, NULL, NULL, '2026-05-23 10:40:00');
INSERT INTO `notification_logs` VALUES (34, 5, 2, 9, 3, '游玩时长提醒', '套餐「拼豆周卡（7天畅玩）」已超过规定时长 60 分钟（已持续 129 分钟），请确认是否结束', 2, NULL, NULL, '2026-05-23 10:45:00');
INSERT INTO `notification_logs` VALUES (35, 5, 2, 9, 3, '游玩时长提醒', '套餐「拼豆周卡（7天畅玩）」已超过规定时长 60 分钟（已持续 134 分钟），请确认是否结束', 2, NULL, NULL, '2026-05-23 10:50:00');
INSERT INTO `notification_logs` VALUES (36, 5, 2, 9, 3, '游玩时长提醒', '套餐「拼豆周卡（7天畅玩）」已超过规定时长 60 分钟（已持续 139 分钟），请确认是否结束', 2, NULL, NULL, '2026-05-23 10:55:00');
INSERT INTO `notification_logs` VALUES (37, 5, 2, 9, 3, '游玩时长提醒', '套餐「拼豆周卡（7天畅玩）」已超过规定时长 60 分钟（已持续 144 分钟），请确认是否结束', 2, NULL, NULL, '2026-05-23 11:00:00');
INSERT INTO `notification_logs` VALUES (38, 5, 2, 9, 3, '游玩时长提醒', '套餐「拼豆周卡（7天畅玩）」已超过规定时长 60 分钟（已持续 149 分钟），请确认是否结束', 2, NULL, NULL, '2026-05-23 11:05:00');
INSERT INTO `notification_logs` VALUES (39, 5, 2, 9, 3, '游玩时长提醒', '套餐「拼豆周卡（7天畅玩）」已超过规定时长 60 分钟（已持续 154 分钟），请确认是否结束', 2, NULL, NULL, '2026-05-23 11:10:00');
INSERT INTO `notification_logs` VALUES (40, 5, 2, 9, 3, '游玩时长提醒', '套餐「拼豆周卡（7天畅玩）」已超过规定时长 60 分钟（已持续 159 分钟），请确认是否结束', 2, NULL, NULL, '2026-05-23 11:15:00');
INSERT INTO `notification_logs` VALUES (41, 5, 2, 9, 3, '游玩时长提醒', '套餐「拼豆周卡（7天畅玩）」已超过规定时长 60 分钟（已持续 164 分钟），请确认是否结束', 2, NULL, NULL, '2026-05-23 11:20:00');
INSERT INTO `notification_logs` VALUES (42, 5, 2, 9, 3, '游玩时长提醒', '套餐「拼豆周卡（7天畅玩）」已超过规定时长 60 分钟（已持续 169 分钟），请确认是否结束', 2, NULL, NULL, '2026-05-23 11:25:00');
INSERT INTO `notification_logs` VALUES (43, 5, 2, 9, 3, '游玩时长提醒', '套餐「拼豆周卡（7天畅玩）」已超过规定时长 60 分钟（已持续 174 分钟），请确认是否结束', 2, NULL, NULL, '2026-05-23 11:30:00');
INSERT INTO `notification_logs` VALUES (44, 5, 2, 9, 3, '游玩时长提醒', '套餐「拼豆周卡（7天畅玩）」已超过规定时长 60 分钟（已持续 179 分钟），请确认是否结束', 2, NULL, NULL, '2026-05-23 11:35:00');
INSERT INTO `notification_logs` VALUES (45, 5, 2, 9, 3, '游玩时长提醒', '套餐「拼豆周卡（7天畅玩）」已超过规定时长 60 分钟（已持续 184 分钟），请确认是否结束', 2, NULL, NULL, '2026-05-23 11:40:00');
INSERT INTO `notification_logs` VALUES (46, 5, 2, 9, 3, '游玩时长提醒', '套餐「拼豆周卡（7天畅玩）」已超过规定时长 60 分钟（已持续 189 分钟），请确认是否结束', 2, NULL, NULL, '2026-05-23 11:45:00');
INSERT INTO `notification_logs` VALUES (47, 5, 2, 9, 3, '游玩时长提醒', '套餐「拼豆周卡（7天畅玩）」已超过规定时长 60 分钟（已持续 194 分钟），请确认是否结束', 2, NULL, NULL, '2026-05-23 11:50:00');
INSERT INTO `notification_logs` VALUES (48, 5, 2, 9, 3, '游玩时长提醒', '套餐「拼豆周卡（7天畅玩）」已超过规定时长 60 分钟（已持续 199 分钟），请确认是否结束', 2, NULL, NULL, '2026-05-23 11:55:00');
INSERT INTO `notification_logs` VALUES (49, 5, 2, 9, 3, '游玩时长提醒', '套餐「拼豆周卡（7天畅玩）」已超过规定时长 60 分钟（已持续 204 分钟），请确认是否结束', 2, NULL, NULL, '2026-05-23 12:00:00');
INSERT INTO `notification_logs` VALUES (50, 5, 2, 9, 3, '游玩时长提醒', '套餐「拼豆周卡（7天畅玩）」已超过规定时长 60 分钟（已持续 209 分钟），请确认是否结束', 2, NULL, NULL, '2026-05-23 12:05:00');
INSERT INTO `notification_logs` VALUES (51, 5, 2, 9, 3, '游玩时长提醒', '套餐「拼豆周卡（7天畅玩）」已超过规定时长 60 分钟（已持续 214 分钟），请确认是否结束', 2, NULL, NULL, '2026-05-23 12:10:00');
INSERT INTO `notification_logs` VALUES (52, 5, 2, 9, 3, '游玩时长提醒', '套餐「拼豆周卡（7天畅玩）」已超过规定时长 60 分钟（已持续 219 分钟），请确认是否结束', 2, NULL, NULL, '2026-05-23 12:15:00');
INSERT INTO `notification_logs` VALUES (53, 5, 2, 9, 3, '游玩时长提醒', '套餐「拼豆周卡（7天畅玩）」已超过规定时长 60 分钟（已持续 224 分钟），请确认是否结束', 2, NULL, NULL, '2026-05-23 12:20:00');
INSERT INTO `notification_logs` VALUES (54, 5, 2, 9, 3, '游玩时长提醒', '套餐「拼豆周卡（7天畅玩）」已超过规定时长 60 分钟（已持续 229 分钟），请确认是否结束', 2, NULL, NULL, '2026-05-23 12:25:00');
INSERT INTO `notification_logs` VALUES (55, 5, 2, 9, 3, '游玩时长提醒', '套餐「拼豆周卡（7天畅玩）」已超过规定时长 60 分钟（已持续 234 分钟），请确认是否结束', 2, NULL, NULL, '2026-05-23 12:30:00');
INSERT INTO `notification_logs` VALUES (56, 5, 2, 9, 3, '游玩时长提醒', '套餐「拼豆周卡（7天畅玩）」已超过规定时长 60 分钟（已持续 239 分钟），请确认是否结束', 2, NULL, NULL, '2026-05-23 12:35:00');
INSERT INTO `notification_logs` VALUES (57, 5, 2, 45, 3, '库存预警', '物料【印烫机】（ytj01）库存不足，当前库存 2.00，最低预警线 3.00。请及时采购。', 1, NULL, NULL, '2026-05-24 14:11:14');
INSERT INTO `notification_logs` VALUES (58, 5, 2, 9, 3, '库存预警', '物料【印烫机】（ytj01）库存不足，当前库存 2.00，最低预警线 3.00。请及时采购。', 2, NULL, NULL, '2026-05-24 14:11:14');
INSERT INTO `notification_logs` VALUES (59, 5, 2, 45, 3, '库存预警', '物料【印烫机】（ytj01）库存不足，当前库存 2.00，最低预警线 3.00。请及时采购。', 1, NULL, NULL, '2026-05-25 08:00:00');
INSERT INTO `notification_logs` VALUES (60, 5, 2, 9, 3, '库存预警', '物料【印烫机】（ytj01）库存不足，当前库存 2.00，最低预警线 3.00。请及时采购。', 2, NULL, NULL, '2026-05-25 08:00:00');
INSERT INTO `notification_logs` VALUES (61, 5, 2, 43, 3, '库存预警通知', '拼豆板材（30*30）库存低于预警线，请及时补货。', 2, NULL, '2026-05-25 10:00:00', '2026-05-28 11:07:11');
INSERT INTO `notification_logs` VALUES (62, 5, 1, 19, 3, '会员到期提醒', '您的月卡将于7天后到期，续费可享9折优惠。', 2, NULL, '2026-05-24 09:00:00', '2026-05-28 11:07:11');
INSERT INTO `notification_logs` VALUES (63, 5, 2, 44, 3, '排班提醒', '您明天（5月28日）有排班，请准时到岗。', 2, NULL, '2026-05-27 18:00:00', '2026-05-28 11:07:11');
INSERT INTO `notification_logs` VALUES (64, 8, 2, 11, 3, '席位即将到期', '您的席位将于 2026-06-15 到期（剩余7天），请及时续订，以免影响店铺运营。', 1, NULL, NULL, '2026-06-08 08:00:00');
INSERT INTO `notification_logs` VALUES (65, 16, 2, 11, 3, '席位即将到期', '您的席位将于 2026-06-15 到期（剩余7天），请及时续订，以免影响店铺运营。', 1, NULL, NULL, '2026-06-08 08:00:00');
INSERT INTO `notification_logs` VALUES (66, 24, 2, 11, 3, '席位即将到期', '您的席位将于 2026-06-15 到期（剩余7天），请及时续订，以免影响店铺运营。', 1, NULL, NULL, '2026-06-08 08:00:00');
INSERT INTO `notification_logs` VALUES (67, 10, 2, 13, 3, '席位即将到期', '您的席位将于 2026-06-15 到期（剩余7天），请及时续订，以免影响店铺运营。', 1, NULL, NULL, '2026-06-08 08:00:00');
INSERT INTO `notification_logs` VALUES (68, 18, 2, 13, 3, '席位即将到期', '您的席位将于 2026-06-15 到期（剩余7天），请及时续订，以免影响店铺运营。', 1, NULL, NULL, '2026-06-08 08:00:00');
INSERT INTO `notification_logs` VALUES (69, 26, 2, 13, 3, '席位即将到期', '您的席位将于 2026-06-15 到期（剩余7天），请及时续订，以免影响店铺运营。', 1, NULL, NULL, '2026-06-08 08:00:00');
INSERT INTO `notification_logs` VALUES (70, 12, 2, 15, 3, '席位即将到期', '您的席位将于 2026-06-10 到期（剩余1天），请及时续订，以免影响店铺运营。', 1, NULL, NULL, '2026-06-09 08:00:00');
INSERT INTO `notification_logs` VALUES (71, 20, 2, 15, 3, '席位即将到期', '您的席位将于 2026-06-10 到期（剩余1天），请及时续订，以免影响店铺运营。', 1, NULL, NULL, '2026-06-09 08:00:00');
INSERT INTO `notification_logs` VALUES (72, 14, 2, 17, 3, '席位即将到期', '您的席位将于 2026-06-10 到期（剩余1天），请及时续订，以免影响店铺运营。', 1, NULL, NULL, '2026-06-09 08:00:00');
INSERT INTO `notification_logs` VALUES (73, 22, 2, 17, 3, '席位即将到期', '您的席位将于 2026-06-10 到期（剩余1天），请及时续订，以免影响店铺运营。', 1, NULL, NULL, '2026-06-09 08:00:00');
INSERT INTO `notification_logs` VALUES (74, 12, 2, 15, 3, '席位即将到期', '您的席位将于 2026-07-10 到期（剩余30天），请及时续订，以免影响店铺运营。', 1, NULL, NULL, '2026-06-10 08:00:00');
INSERT INTO `notification_logs` VALUES (75, 20, 2, 15, 3, '席位即将到期', '您的席位将于 2026-07-10 到期（剩余30天），请及时续订，以免影响店铺运营。', 1, NULL, NULL, '2026-06-10 08:00:00');
INSERT INTO `notification_logs` VALUES (76, 5, 1, 34, 3, '会员到期提醒', '您的月卡将于3天后到期，续费享9折优惠。', 2, NULL, '2026-05-25 10:00:00', '2026-05-25 10:00:00');
INSERT INTO `notification_logs` VALUES (77, 5, 1, 37, 3, '会员到期提醒', '您的创意月卡将于5天后到期。', 2, NULL, '2026-05-27 09:00:00', '2026-05-27 09:00:00');
INSERT INTO `notification_logs` VALUES (78, 5, 2, 44, 3, '排班提醒', '您明天（5月28日）有排班，请准时到岗。', 2, NULL, '2026-05-27 18:00:00', '2026-05-27 18:00:00');
INSERT INTO `notification_logs` VALUES (79, 5, 2, 45, 3, '排班提醒', '您明天有排班，请准时到岗。', 2, NULL, '2026-05-27 18:00:00', '2026-05-27 18:00:00');
INSERT INTO `notification_logs` VALUES (80, 5, 2, 46, 3, '排班提醒', '您明天有排班，请准时到岗。', 2, NULL, '2026-05-27 18:00:00', '2026-05-27 18:00:00');
INSERT INTO `notification_logs` VALUES (81, 5, 2, 43, 3, '采购订单提醒', '采购订单PO20260525001已部分付款，请跟进。', 2, NULL, '2026-05-26 10:00:00', '2026-05-26 10:00:00');
INSERT INTO `notification_logs` VALUES (82, 5, 1, 39, 3, '优惠券到账', '您获得一张儿童节专属优惠券，有效期7天。', 2, NULL, '2026-05-26 09:00:00', '2026-05-26 09:00:00');
INSERT INTO `notification_logs` VALUES (83, 5, 1, 40, 3, '优惠券到账', '您获得一张儿童节专属优惠券，有效期7天。', 2, NULL, '2026-05-26 10:00:00', '2026-05-26 10:00:00');
INSERT INTO `notification_logs` VALUES (84, 5, 2, 43, 3, '儿童节活动提醒', '明天是儿童节，预计客流量较大，请做好准备。', 2, NULL, '2026-05-31 17:00:00', '2026-05-31 17:00:00');
INSERT INTO `notification_logs` VALUES (85, 5, 2, 44, 3, '儿童节活动提醒', '明天是儿童节，预计客流量较大，请做好准备。', 2, NULL, '2026-05-31 17:00:00', '2026-05-31 17:00:00');
INSERT INTO `notification_logs` VALUES (86, 5, 1, 37, 3, '会员续费成功', '您的创意月卡已成功续费，有效期至2026-07-09。', 2, NULL, '2026-06-01 11:00:00', '2026-06-01 11:00:00');
INSERT INTO `notification_logs` VALUES (87, 5, 2, 43, 3, '退款审批提醒', '有一笔退款申请待审批，请及时处理。', 2, NULL, '2026-06-02 10:00:00', '2026-06-02 10:00:00');
INSERT INTO `notification_logs` VALUES (88, 5, 2, 43, 3, '端午节活动提醒', '端午节活动即将开始，请检查物料库存。', 2, NULL, '2026-06-05 09:00:00', '2026-06-05 09:00:00');
INSERT INTO `notification_logs` VALUES (89, 12, 2, 15, 3, '席位已到期', '您的席位已于 2026-06-10 到期，店铺功能受限。请续订以恢复正常。', 1, NULL, NULL, '2026-06-11 05:38:00');
INSERT INTO `notification_logs` VALUES (90, 20, 2, 15, 3, '席位已到期', '您的席位已于 2026-06-10 到期，店铺功能受限。请续订以恢复正常。', 1, NULL, NULL, '2026-06-11 05:38:00');
INSERT INTO `notification_logs` VALUES (91, 14, 2, 17, 3, '席位已到期', '您的席位已于 2026-06-10 到期，店铺功能受限。请续订以恢复正常。', 1, NULL, NULL, '2026-06-11 05:38:00');
INSERT INTO `notification_logs` VALUES (92, 22, 2, 17, 3, '席位已到期', '您的席位已于 2026-06-10 到期，店铺功能受限。请续订以恢复正常。', 1, NULL, NULL, '2026-06-11 05:38:00');
INSERT INTO `notification_logs` VALUES (93, 8, 2, 11, 3, '席位即将到期', '您的席位将于 2026-06-15 到期（剩余3天），请及时续订，以免影响店铺运营。', 1, NULL, NULL, '2026-06-12 08:00:00');
INSERT INTO `notification_logs` VALUES (94, 16, 2, 11, 3, '席位即将到期', '您的席位将于 2026-06-15 到期（剩余3天），请及时续订，以免影响店铺运营。', 1, NULL, NULL, '2026-06-12 08:00:00');
INSERT INTO `notification_logs` VALUES (95, 24, 2, 11, 3, '席位即将到期', '您的席位将于 2026-06-15 到期（剩余3天），请及时续订，以免影响店铺运营。', 1, NULL, NULL, '2026-06-12 08:00:00');
INSERT INTO `notification_logs` VALUES (96, 10, 2, 13, 3, '席位即将到期', '您的席位将于 2026-06-15 到期（剩余3天），请及时续订，以免影响店铺运营。', 1, NULL, NULL, '2026-06-12 08:00:00');
INSERT INTO `notification_logs` VALUES (97, 18, 2, 13, 3, '席位即将到期', '您的席位将于 2026-06-15 到期（剩余3天），请及时续订，以免影响店铺运营。', 1, NULL, NULL, '2026-06-12 08:00:00');
INSERT INTO `notification_logs` VALUES (98, 26, 2, 13, 3, '席位即将到期', '您的席位将于 2026-06-15 到期（剩余3天），请及时续订，以免影响店铺运营。', 1, NULL, NULL, '2026-06-12 08:00:00');
INSERT INTO `notification_logs` VALUES (99, 7, 2, 10, 3, '席位即将到期', '您的席位将于 2026-06-20 到期（剩余7天），请及时续订，以免影响店铺运营。', 1, NULL, NULL, '2026-06-13 08:25:40');
INSERT INTO `notification_logs` VALUES (100, 15, 2, 10, 3, '席位即将到期', '您的席位将于 2026-06-20 到期（剩余7天），请及时续订，以免影响店铺运营。', 1, NULL, NULL, '2026-06-13 08:25:40');
INSERT INTO `notification_logs` VALUES (101, 23, 2, 10, 3, '席位即将到期', '您的席位将于 2026-06-20 到期（剩余7天），请及时续订，以免影响店铺运营。', 1, NULL, NULL, '2026-06-13 08:25:40');
INSERT INTO `notification_logs` VALUES (102, 8, 2, 11, 3, '席位即将到期', '您的席位将于 2026-06-15 到期（剩余1天），请及时续订，以免影响店铺运营。', 1, NULL, NULL, '2026-06-14 09:52:23');
INSERT INTO `notification_logs` VALUES (103, 16, 2, 11, 3, '席位即将到期', '您的席位将于 2026-06-15 到期（剩余1天），请及时续订，以免影响店铺运营。', 1, NULL, NULL, '2026-06-14 09:52:23');
INSERT INTO `notification_logs` VALUES (104, 24, 2, 11, 3, '席位即将到期', '您的席位将于 2026-06-15 到期（剩余1天），请及时续订，以免影响店铺运营。', 1, NULL, NULL, '2026-06-14 09:52:23');
INSERT INTO `notification_logs` VALUES (105, 10, 2, 13, 3, '席位即将到期', '您的席位将于 2026-06-15 到期（剩余1天），请及时续订，以免影响店铺运营。', 1, NULL, NULL, '2026-06-14 09:52:23');
INSERT INTO `notification_logs` VALUES (106, 18, 2, 13, 3, '席位即将到期', '您的席位将于 2026-06-15 到期（剩余1天），请及时续订，以免影响店铺运营。', 1, NULL, NULL, '2026-06-14 09:52:23');
INSERT INTO `notification_logs` VALUES (107, 26, 2, 13, 3, '席位即将到期', '您的席位将于 2026-06-15 到期（剩余1天），请及时续订，以免影响店铺运营。', 1, NULL, NULL, '2026-06-14 09:52:23');
INSERT INTO `notification_logs` VALUES (108, 11, 2, 14, 3, '席位即将到期', '您的席位将于 2026-07-15 到期（剩余30天），请及时续订，以免影响店铺运营。', 1, NULL, NULL, '2026-06-15 08:00:00');
INSERT INTO `notification_logs` VALUES (109, 19, 2, 14, 3, '席位即将到期', '您的席位将于 2026-07-15 到期（剩余30天），请及时续订，以免影响店铺运营。', 1, NULL, NULL, '2026-06-15 08:00:00');
INSERT INTO `notification_logs` VALUES (110, 27, 2, 14, 3, '席位即将到期', '您的席位将于 2026-07-15 到期（剩余30天），请及时续订，以免影响店铺运营。', 1, NULL, NULL, '2026-06-15 08:00:00');

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
) ENGINE = InnoDB AUTO_INCREMENT = 37 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '操作日志' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of operation_logs
-- ----------------------------
INSERT INTO `operation_logs` VALUES (1, 5, 1, 9, '直接付款购买', 'purchase', 1, '{\"amount\": 24.9, \"packageId\": 6}', '0:0:0:0:0:0:0:1', '2026-05-21 14:47:52');
INSERT INTO `operation_logs` VALUES (2, 5, 1, 9, '第三方券码购买', 'purchase', 2, '{\"amount\": 99.9, \"packageId\": 7}', '0:0:0:0:0:0:0:1', '2026-05-21 14:50:02');
INSERT INTO `operation_logs` VALUES (3, 5, 1, 9, '储值钱包购买', 'purchase', 3, '{\"amount\": 99.9, \"packageId\": 7}', '0:0:0:0:0:0:0:1', '2026-05-21 15:00:15');
INSERT INTO `operation_logs` VALUES (4, 5, 1, 9, '确认退款', 'refund', 1, '{\"amount\": 0.0, \"purchaseId\": 2}', '0:0:0:0:0:0:0:1', '2026-05-21 15:56:44');
INSERT INTO `operation_logs` VALUES (5, 5, 1, 9, '直接付款购买', 'purchase', 4, '{\"amount\": 24.9, \"packageId\": 6}', '0:0:0:0:0:0:0:1', '2026-05-22 13:15:40');
INSERT INTO `operation_logs` VALUES (6, 5, 1, 9, '钱包充值', 'recharge', 5, '{\"paid\": 180.0, \"recharge\": 200, \"couponDiscount\": 20.0}', NULL, '2026-05-23 15:00:20');
INSERT INTO `operation_logs` VALUES (7, 5, 1, 43, 'customer_add', 'customer', 19, '{\"phone\": \"13812345601\", \"nickname\": \"李小花\"}', '192.168.1.100', '2026-05-28 11:07:08');
INSERT INTO `operation_logs` VALUES (8, 5, 1, 43, 'purchase_add', 'purchase', 6, '{\"amount\": 29.9, \"channel\": \"store\", \"package\": \"拼豆单次\"}', '192.168.1.100', '2026-05-28 11:07:08');
INSERT INTO `operation_logs` VALUES (9, 5, 1, 43, 'game_checkin', 'game_session', 5, '{\"package\": \"拼豆月卡\", \"customer\": \"王建国\"}', '192.168.1.100', '2026-05-28 11:07:08');
INSERT INTO `operation_logs` VALUES (10, 5, 1, 44, 'game_finish', 'game_session', 5, '{\"revenue\": 9.97, \"duration\": \"65分钟\"}', '192.168.1.101', '2026-05-28 11:07:08');
INSERT INTO `operation_logs` VALUES (11, 5, 1, 43, 'expense_add', 'expense', 9, '{\"amount\": 5000.0, \"category\": \"房租\"}', '192.168.1.100', '2026-05-28 11:07:08');
INSERT INTO `operation_logs` VALUES (12, 5, 1, 43, 'customer_add', 'customer', 34, '{\"phone\": \"13900001001\", \"nickname\": \"孙悟空\"}', '192.168.1.100', '2026-05-09 10:00:00');
INSERT INTO `operation_logs` VALUES (13, 5, 1, 43, 'purchase_add', 'purchase', 18, '{\"amount\": 299.0, \"channel\": \"store\", \"package\": \"拼豆月卡\"}', '192.168.1.100', '2026-05-09 10:30:00');
INSERT INTO `operation_logs` VALUES (14, 5, 1, 43, 'game_checkin', 'game_session', 15, '{\"package\": \"拼豆月卡\", \"customer\": \"孙悟空\"}', '192.168.1.100', '2026-05-09 10:30:00');
INSERT INTO `operation_logs` VALUES (15, 5, 1, 43, 'game_finish', 'game_session', 15, '{\"revenue\": 9.97, \"duration\": \"60分钟\"}', '192.168.1.100', '2026-05-09 11:30:00');
INSERT INTO `operation_logs` VALUES (16, 5, 1, 44, 'customer_add', 'customer', 35, '{\"phone\": \"13900001002\", \"nickname\": \"猪八戒\"}', '192.168.1.101', '2026-05-10 14:30:00');
INSERT INTO `operation_logs` VALUES (17, 5, 1, 44, 'purchase_add', 'purchase', 19, '{\"amount\": 29.9, \"channel\": \"meituan\", \"package\": \"拼豆单次\"}', '192.168.1.101', '2026-05-10 14:45:00');
INSERT INTO `operation_logs` VALUES (18, 5, 1, 43, 'expense_add', 'expense', 19, '{\"amount\": 5000.0, \"category\": \"房租\"}', '192.168.1.100', '2026-05-10 09:00:00');
INSERT INTO `operation_logs` VALUES (19, 5, 1, 43, 'purchase_order_add', 'purchase_order', 10, '{\"amount\": 3500.0, \"supplier\": \"义乌小商品批发城\"}', '192.168.1.100', '2026-05-10 10:00:00');
INSERT INTO `operation_logs` VALUES (20, 5, 1, 43, 'inventory_inbound', 'inventory_transaction', 40, '{\"material\": \"拼豆124色\", \"quantity\": 100}', '192.168.1.100', '2026-05-10 11:00:00');
INSERT INTO `operation_logs` VALUES (21, 5, 1, 43, 'coupon_grant', 'coupon_usage', 12, '{\"coupon\": \"儿童节专属优惠\", \"customer\": \"孙悟空\"}', '192.168.1.100', '2026-05-25 10:30:00');
INSERT INTO `operation_logs` VALUES (22, 5, 1, 43, 'refund_approve', 'refund_record', 4, '{\"amount\": 24.9, \"purchase_id\": 19}', '192.168.1.100', '2026-05-12 16:00:00');
INSERT INTO `operation_logs` VALUES (23, 5, 1, 44, 'feedback_reply', 'feedback', 15, '{\"content\": \"感谢建议！周末建议提前预约哦～\"}', '192.168.1.101', '2026-05-11 09:00:00');
INSERT INTO `operation_logs` VALUES (24, 5, 1, 43, 'commission_settle', 'commission_settlement', 5, '{\"staff\": \"李大宝\", \"amount\": 60.0, \"period\": \"2026-05\"}', '192.168.1.100', '2026-06-01 10:00:00');
INSERT INTO `operation_logs` VALUES (25, 5, 1, 43, 'article_publish', 'article', 8, '{\"title\": \"端午节特惠活动\"}', '192.168.1.100', '2026-05-28 10:00:00');
INSERT INTO `operation_logs` VALUES (26, 5, 1, 43, 'article_publish', 'article', 9, '{\"title\": \"儿童节快乐\"}', '192.168.1.100', '2026-06-01 09:00:00');
INSERT INTO `operation_logs` VALUES (27, 5, 1, 44, 'game_checkin', 'game_session', 38, '{\"package\": \"拼豆单次\", \"customer\": \"蜘蛛精\"}', '192.168.1.101', '2026-06-01 09:30:00');
INSERT INTO `operation_logs` VALUES (28, 5, 1, 43, 'expense_add', 'expense', 33, '{\"amount\": 12000.0, \"category\": \"员工工资\"}', '192.168.1.100', '2026-06-08 09:00:00');
INSERT INTO `operation_logs` VALUES (29, 5, 1, 43, 'customer_add', 'customer', 48, '{\"phone\": \"13900001015\", \"nickname\": \"雷震子\"}', '192.168.1.100', '2026-05-23 13:15:00');
INSERT INTO `operation_logs` VALUES (30, 5, 1, 44, 'purchase_add', 'purchase', 57, '{\"amount\": 99.9, \"channel\": \"douyin\", \"package\": \"拼豆周卡\"}', '192.168.1.101', '2026-06-09 16:30:00');
INSERT INTO `operation_logs` VALUES (31, 5, 1, 43, 'refund_reject', 'refund_record', 7, '{\"reason\": \"团购券已过期，无法退款\"}', '192.168.1.100', '2026-06-02 10:00:00');
INSERT INTO `operation_logs` VALUES (32, 5, 1, 43, 'attendance_checkin', 'attendance_record', 153, '{\"time\": \"09:10\", \"staff\": \"李大宝\", \"status\": \"late\"}', '192.168.1.100', '2026-06-09 09:10:00');
INSERT INTO `operation_logs` VALUES (33, 5, 1, 44, 'attendance_checkin', 'attendance_record', 154, '{\"time\": \"08:58\", \"staff\": \"李二宝\", \"status\": \"overtime\"}', '192.168.1.101', '2026-06-09 08:58:00');
INSERT INTO `operation_logs` VALUES (34, 5, 1, 43, 'inventory_outbound', 'inventory_transaction', 67, '{\"material\": \"垃圾袋\", \"quantity\": 20}', '192.168.1.100', '2026-05-24 11:00:00');
INSERT INTO `operation_logs` VALUES (35, 5, 1, 44, 'queue_seated', 'queue_entry', 1, '{\"customer\": \"孙悟空\", \"queue_number\": 1}', '192.168.1.101', '2026-05-09 10:15:00');
INSERT INTO `operation_logs` VALUES (36, 5, 1, 43, 'notification_send', 'notification_log', 80, '{\"title\": \"儿童节活动提醒\", \"recipients\": \"全员\"}', '192.168.1.100', '2026-05-31 17:00:00');

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
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '套餐物料清单' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of package_bom
-- ----------------------------
INSERT INTO `package_bom` VALUES (8, 7, 2, 1.00, '2026-05-26 16:11:09', 0, NULL);
INSERT INTO `package_bom` VALUES (9, 7, 7, 1.00, '2026-05-26 16:11:09', 0, NULL);
INSERT INTO `package_bom` VALUES (10, 6, 8, 1.00, '2026-05-26 16:11:15', 0, NULL);
INSERT INTO `package_bom` VALUES (11, 5, 1, 1.00, '2026-05-26 16:42:36', 0, NULL);
INSERT INTO `package_bom` VALUES (12, 5, 3, 1.00, '2026-05-26 16:42:36', 0, NULL);
INSERT INTO `package_bom` VALUES (13, 4, 2, 1.00, '2026-05-26 16:42:42', 0, NULL);
INSERT INTO `package_bom` VALUES (14, 4, 3, 1.00, '2026-05-26 16:42:42', 0, NULL);
INSERT INTO `package_bom` VALUES (15, 8, 8, 1.00, '2026-05-27 08:41:06', 0, NULL);

-- ----------------------------
-- Table structure for packages
-- ----------------------------
DROP TABLE IF EXISTS `packages`;
CREATE TABLE `packages`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `shop_id` bigint UNSIGNED NOT NULL COMMENT '店铺id',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '套餐名称',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '套餐类型: SINGLE-单次, WEEKLY-周卡, MONTHLY-月卡',
  `duration_minutes` int UNSIGNED NULL DEFAULT NULL COMMENT '套餐时长',
  `price` decimal(10, 2) NOT NULL COMMENT '价格',
  `original_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '原价',
  `max_people_per_session` tinyint UNSIGNED NOT NULL DEFAULT 1 COMMENT '最大游玩人数',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '描述',
  `image` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '套餐封面图',
  `is_active` tinyint UNSIGNED NOT NULL DEFAULT 1 COMMENT '是否启用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '0-正常，1-已删除',
  `deleted_time` datetime NULL DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_shop_id`(`shop_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '服务套餐定义表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of packages
-- ----------------------------
INSERT INTO `packages` VALUES (4, 5, '拼豆单次（1小时）124色豆', 'SINGLE', 60, 29.90, NULL, 1, '支持帮烫豆服务', 'public/files/20260526164241264_1047130748.jpeg', 1, '2026-05-21 09:12:37', '2026-05-27 08:32:41', 0, NULL);
INSERT INTO `packages` VALUES (5, 5, '拼豆月卡（30天畅玩）', 'MONTHLY', 60, 299.00, 897.00, 1, '附赠帮烫豆服务', 'public/files/20260526164235199_590967779.jpeg', 1, '2026-05-21 09:38:27', '2026-05-27 08:32:42', 0, NULL);
INSERT INTO `packages` VALUES (6, 5, '白模玩偶涂色（单次）', 'SINGLE', 60, 24.90, 29.90, 1, '玩偶可以带回家', 'public/files/20260526161115214_1716075536.jpeg', 1, '2026-05-21 09:40:27', '2026-05-27 08:32:41', 0, NULL);
INSERT INTO `packages` VALUES (7, 5, '拼豆周卡（7天畅玩）', 'WEEKLY', 60, 99.90, 209.00, 1, '提供帮烫服务', 'public/files/20260526161108666_1387057019.jpeg', 1, '2026-05-21 14:49:37', '2026-05-27 08:32:42', 0, NULL);
INSERT INTO `packages` VALUES (8, 5, 'DIY石膏涂色', 'SINGLE', 60, 29.90, NULL, 1, 'DIY石膏涂色', 'public/files/20260527084105747_1419814096.jpeg', 1, '2026-05-27 08:41:06', '2026-05-27 08:41:06', 0, NULL);
INSERT INTO `packages` VALUES (9, 5, '创意月卡会员', 'MONTHLY', 60, 299.00, 900.00, 1, '畅玩店内所有项目', 'public/files/20260527084206593_589654265.jpeg', 1, '2026-05-27 08:42:07', '2026-05-27 08:42:07', 0, NULL);
INSERT INTO `packages` VALUES (10, 5, '亲子手工周卡', 'WEEKLY', 60, 199.00, 499.00, 2, '亲子手工周卡', 'public/files/20260527084258401_1807319994.jpeg', 1, '2026-05-27 08:42:59', '2026-05-27 08:42:59', 0, NULL);

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
-- Records of permissions
-- ----------------------------
INSERT INTO `permissions` VALUES (1, 0, '系统管理', 'system', '/system', NULL, NULL, 'ep/setting', 1, 1, '系统管理目录', 1, 0, 1, '2026-05-12 10:19:20', '2026-06-15 16:42:12');
INSERT INTO `permissions` VALUES (2, 0, '商户管理', 'tenant', '/tenant', NULL, NULL, 'ri/store-2-line', 2, 1, '商户管理目录', 1, 0, 1, '2026-05-12 10:19:20', '2026-06-15 16:42:12');
INSERT INTO `permissions` VALUES (3, 0, '店铺管理', 'shop', '/shop', NULL, NULL, 'ep/home-filled', 3, 1, '店铺管理目录', 1, 0, 1, '2026-05-12 10:19:20', '2026-06-15 16:42:12');
INSERT INTO `permissions` VALUES (4, 0, '顾客管理', 'customer', '/customer', NULL, NULL, 'ep/user', 4, 1, '顾客管理目录', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (5, 0, '套餐管理', 'package', '/package', NULL, NULL, 'ep/goods', 5, 1, '套餐管理目录', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (6, 0, '交易管理', 'trade', '/trade', NULL, NULL, 'ri/exchange-dollar-line', 6, 1, '交易管理目录', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-14 16:45:48');
INSERT INTO `permissions` VALUES (7, 0, '库存管理', 'inventory', '/inventory', NULL, NULL, 'ep/box', 7, 1, '库存管理目录', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (8, 0, '营销管理', 'marketing', '/marketing', NULL, NULL, 'ep/present', 8, 1, '营销管理目录', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (9, 0, '财务管理', 'finance', '/finance', NULL, NULL, 'ep/money', 9, 1, '财务管理目录', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-14 16:46:10');
INSERT INTO `permissions` VALUES (10, 0, '数据报表', 'dashboard', '/dashboard', NULL, NULL, 'ep/data-analysis', 10, 1, '数据报表目录', 1, 1, 0, '2026-05-12 10:19:20', '2026-05-23 09:06:32');
INSERT INTO `permissions` VALUES (11, 1, '员工管理', 'system:staff', '/system/staff', '/src/views/system/staff/index.vue', NULL, 'ep/setting', 1, 2, '员工列表', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-14 16:46:30');
INSERT INTO `permissions` VALUES (12, 1, '角色管理', 'system:role', '/system/role', '/src/views/system/role/index.vue', NULL, 'ri/admin-line', 2, 2, '角色列表', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-14 16:46:32');
INSERT INTO `permissions` VALUES (13, 1, '权限管理', 'system:permission', '/system/permission', '/src/views/system/permission/index.vue', NULL, 'ri/shield-check-line', 3, 2, '权限列表', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-14 16:46:33');
INSERT INTO `permissions` VALUES (14, 1, '字典管理', 'system:dict', '/system/dict', '/src/views/system/dict/index.vue', NULL, 'ri/book-open-line', 4, 2, '字典管理', 1, 0, 1, '2026-05-12 10:19:20', '2026-06-15 16:42:12');
INSERT INTO `permissions` VALUES (15, 2, '商户列表', 'tenant:list', '/tenant/list', '/src/views/tenant/list/index.vue', NULL, 'ep/list', 1, 2, '商户列表', 1, 0, 1, '2026-05-12 10:19:20', '2026-06-15 16:42:12');
INSERT INTO `permissions` VALUES (16, 2, '席位管理', 'tenant:seat', '/tenant/seat', '/src/views/tenant/seat/index.vue', NULL, 'ri/vip-crown-line', 2, 2, '席位管理', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-14 16:45:35');
INSERT INTO `permissions` VALUES (17, 3, '店铺列表', 'shop:list', '/shop/list', '/src/views/shop/list/index.vue', NULL, 'ep/list', 1, 2, '店铺列表', 1, 0, 1, '2026-05-12 10:19:20', '2026-06-15 16:42:12');
INSERT INTO `permissions` VALUES (18, 4, '顾客列表', 'customer:list', '/customer/list', '/src/views/customer/list/index.vue', NULL, 'ep/list', 1, 2, '顾客列表', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-14 16:45:44');
INSERT INTO `permissions` VALUES (19, 5, '套餐列表', 'package:list', '/package/list', '/src/views/package/list/index.vue', NULL, 'ep/list', 1, 2, '套餐列表', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-14 16:45:46');
INSERT INTO `permissions` VALUES (20, 6, '购买记录', 'trade:purchase', '/trade/purchase', '/src/views/trade/purchase/index.vue', NULL, 'ri/shopping-cart-2-line', 1, 2, '购买记录', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-14 16:45:53');
INSERT INTO `permissions` VALUES (21, 6, '核销管理', 'trade:checkin', '/trade/checkin', '/src/views/trade/checkin/index.vue', NULL, 'ri/checkbox-circle-line', 2, 2, '核销管理', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-14 16:45:54');
INSERT INTO `permissions` VALUES (22, 6, '退款管理', 'trade:refund', '/trade/refund', '/src/views/trade/refund/index.vue', NULL, 'ri/refund-2-line', 3, 2, '退款管理', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-14 16:45:56');
INSERT INTO `permissions` VALUES (23, 7, '物料管理', 'inventory:material', '/inventory/material', '/src/views/inventory/material/index.vue', NULL, 'ri/flask-line', 1, 2, '物料管理', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-14 16:45:59');
INSERT INTO `permissions` VALUES (24, 7, '库存查询', 'inventory:list', '/inventory/list', '/src/views/inventory/list/index.vue', NULL, 'ep/list', 2, 2, '库存查询', 1, 1, 0, '2026-05-12 10:19:20', '2026-05-20 15:38:07');
INSERT INTO `permissions` VALUES (25, 7, '采购管理', 'inventory:purchase', '/inventory/purchase', '/src/views/inventory/purchase/index.vue', NULL, 'ri/shopping-bag-line', 3, 2, '采购管理', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-14 16:46:05');
INSERT INTO `permissions` VALUES (26, 8, '优惠券管理', 'marketing:coupon', '/marketing/coupon', '/src/views/marketing/coupon/index.vue', NULL, 'ri/coupon-2-line', 1, 2, '优惠券管理', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-14 16:46:08');
INSERT INTO `permissions` VALUES (27, 8, '文章管理', 'marketing:article', '/marketing/article', '/src/views/marketing/article/index.vue', NULL, 'ri/article-line', 2, 2, '文章管理', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-14 16:46:09');
INSERT INTO `permissions` VALUES (28, 9, '收入管理', 'finance:revenue', '/finance/revenue', '/src/views/finance/revenue/index.vue', NULL, 'ri/money-dollar-circle-line', 1, 2, '收入管理', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-14 16:46:12');
INSERT INTO `permissions` VALUES (29, 9, '支出管理', 'finance:expense', '/finance/expense', '/src/views/finance/expense/index.vue', NULL, 'ri/money-cny-circle-line', 2, 2, '支出管理', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-14 16:46:17');
INSERT INTO `permissions` VALUES (30, 9, '提成管理', 'finance:commission', '/finance/commission', '/src/views/finance/commission/index.vue', NULL, 'ri/percent-line', 3, 2, '提成管理', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-14 16:46:18');
INSERT INTO `permissions` VALUES (31, 9, '发票管理', 'finance:invoice', '/finance/invoice', '/src/views/finance/invoice/index.vue', NULL, 'ri/bill-line', 4, 2, '发票管理', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-14 16:46:20');
INSERT INTO `permissions` VALUES (32, 10, '经营概况', 'dashboard:overview', '/dashboard/overview', '/src/views/dashboard/overview/index.vue', NULL, 'ep/trend-charts', 1, 2, '经营概况', 1, 1, 0, '2026-05-12 10:19:20', '2026-05-23 09:06:32');
INSERT INTO `permissions` VALUES (33, 0, '经营快照', 'dashboard:snapshot', '/dashboard/snapshot', '/src/views/dashboard/snapshot/index.vue', NULL, 'ri/file-chart-line', 11, 2, '经营快照', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-23 09:06:37');
INSERT INTO `permissions` VALUES (34, 9, '通知管理', 'finance:notification', '/finance/notification', '/src/views/finance/notification/index.vue', NULL, 'ri/notification-3-line', 5, 2, NULL, 1, 0, 0, '2026-05-14 14:38:40', '2026-05-14 16:46:21');
INSERT INTO `permissions` VALUES (36, 3, '店铺信息', 'shop:my', '/shop/my', '/src/views/shop/my/index.vue', NULL, 'ep/home-filled', 2, 2, NULL, 1, 0, 0, '2026-05-19 15:10:46', '2026-05-19 15:10:46');
INSERT INTO `permissions` VALUES (37, 9, '收支明细', 'finance:cashflow', '/finance/cashflow', '/src/views/finance/cashflow/index.vue', NULL, 'ep/money', 6, 2, NULL, 1, 0, 0, '2026-05-21 16:55:11', '2026-05-22 14:21:58');
INSERT INTO `permissions` VALUES (101, 11, '新增员工', 'btn:staff:add', NULL, NULL, NULL, NULL, 1, 3, '新增员工按钮', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (102, 11, '编辑员工', 'btn:staff:edit', NULL, NULL, NULL, NULL, 2, 3, '编辑员工按钮', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (103, 11, '删除员工', 'btn:staff:delete', NULL, NULL, NULL, NULL, 3, 3, '删除员工按钮', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (104, 11, '重置密码', 'btn:staff:password', NULL, NULL, NULL, NULL, 4, 3, '重置密码按钮', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (105, 12, '新增角色', 'btn:role:add', NULL, NULL, NULL, NULL, 1, 3, '新增角色按钮', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (106, 12, '编辑角色', 'btn:role:edit', NULL, NULL, NULL, NULL, 2, 3, '编辑角色按钮', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (107, 12, '设置权限', 'btn:role:perms', NULL, NULL, NULL, NULL, 3, 3, '设置权限按钮', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (108, 14, '新增字典', 'btn:dict:add', NULL, NULL, NULL, NULL, 1, 3, '新增字典项按钮', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (109, 14, '编辑字典', 'btn:dict:edit', NULL, NULL, NULL, NULL, 2, 3, '编辑字典项按钮', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (110, 15, '新增商户', 'btn:tenant:add', NULL, NULL, NULL, NULL, 1, 3, '新增商户按钮', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (111, 15, '编辑商户', 'btn:tenant:edit', NULL, NULL, NULL, NULL, 2, 3, '编辑商户按钮', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (112, 15, '封禁商户', 'btn:tenant:ban', NULL, NULL, NULL, NULL, 3, 3, '封禁/解封商户按钮', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (113, 15, '删除商户', 'btn:tenant:delete', NULL, NULL, NULL, NULL, 4, 3, '删除商户按钮', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (114, 16, '新增席位', 'btn:seat:add', NULL, NULL, NULL, NULL, 1, 3, '新增席位按钮', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (115, 16, '续订席位', 'btn:seat:renew', NULL, NULL, NULL, NULL, 2, 3, '续订席位按钮', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (116, 16, '删除席位', 'btn:seat:delete', NULL, NULL, NULL, NULL, 3, 3, '删除席位按钮', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (117, 17, '新增店铺', 'btn:shop:add', NULL, NULL, NULL, NULL, 1, 3, '新增店铺按钮', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (118, 17, '编辑店铺', 'btn:shop:edit', NULL, NULL, NULL, NULL, 2, 3, '编辑店铺按钮', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (119, 17, '删除店铺', 'btn:shop:delete', NULL, NULL, NULL, NULL, 3, 3, '删除店铺按钮', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (120, 17, '营业切换', 'btn:shop:status', NULL, NULL, NULL, NULL, 4, 3, '营业状态切换按钮', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (121, 18, '新增顾客', 'btn:customer:add', NULL, NULL, NULL, NULL, 1, 3, '新增顾客按钮', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (122, 18, '编辑顾客', 'btn:customer:edit', NULL, NULL, NULL, NULL, 2, 3, '编辑顾客按钮', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (123, 18, '钱包调整', 'btn:customer:wallet', NULL, NULL, NULL, NULL, 3, 3, '钱包调整按钮', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (124, 18, '积分调整', 'btn:customer:points', NULL, NULL, NULL, NULL, 4, 3, '积分调整按钮', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (125, 19, '新增套餐', 'btn:package:add', NULL, NULL, NULL, NULL, 1, 3, '新增套餐按钮', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (126, 19, '编辑套餐', 'btn:package:edit', NULL, NULL, NULL, NULL, 2, 3, '编辑套餐按钮', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (127, 19, '上下架', 'btn:package:status', NULL, NULL, NULL, NULL, 3, 3, '套餐上下架按钮', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (128, 20, '新增购买', 'btn:purchase:add', NULL, NULL, NULL, NULL, 1, 3, '新增购买记录按钮', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (129, 20, '退款申请', 'btn:purchase:refund', NULL, NULL, NULL, NULL, 2, 3, '申请退款按钮', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (130, 21, '核销入座', 'btn:checkin:add', NULL, NULL, NULL, NULL, 1, 3, '核销入座按钮', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (131, 21, '结束游玩', 'btn:checkin:finish', NULL, NULL, NULL, NULL, 2, 3, '结束游玩按钮', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (132, 22, '确认退款', 'btn:refund:approve', NULL, NULL, NULL, NULL, 1, 3, '确认退款按钮', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (133, 22, '拒绝退款', 'btn:refund:reject', NULL, NULL, NULL, NULL, 2, 3, '拒绝退款按钮', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (134, 23, '新增物料', 'btn:material:add', NULL, NULL, NULL, NULL, 1, 3, '新增物料按钮', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (135, 23, '编辑物料', 'btn:material:edit', NULL, NULL, NULL, NULL, 2, 3, '编辑物料按钮', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (136, 23, '删除物料', 'btn:material:delete', NULL, NULL, NULL, NULL, 3, 3, '删除物料按钮', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (137, 24, '入库', 'btn:inventory:inbound', NULL, NULL, NULL, NULL, 1, 3, '入库按钮', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (138, 24, '出库', 'btn:inventory:outbound', NULL, NULL, NULL, NULL, 2, 3, '出库按钮', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (139, 25, '新增采购单', 'btn:purchaseOrder:add', NULL, NULL, NULL, NULL, 1, 3, '新增采购单按钮', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (140, 25, '编辑采购单', 'btn:purchaseOrder:edit', NULL, NULL, NULL, NULL, 2, 3, '编辑采购单按钮', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (141, 26, '新增优惠券', 'btn:coupon:add', NULL, NULL, NULL, NULL, 1, 3, '新增优惠券按钮', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (142, 26, '编辑优惠券', 'btn:coupon:edit', NULL, NULL, NULL, NULL, 2, 3, '编辑优惠券按钮', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (143, 26, '手动发放', 'btn:coupon:grant', NULL, NULL, NULL, NULL, 3, 3, '手动发放优惠券按钮', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (144, 27, '新增文章', 'btn:article:add', NULL, NULL, NULL, NULL, 1, 3, '新增文章按钮', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (145, 27, '编辑文章', 'btn:article:edit', NULL, NULL, NULL, NULL, 2, 3, '编辑文章按钮', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (146, 27, '发布/下架', 'btn:article:publish', NULL, NULL, NULL, NULL, 3, 3, '发布/下架按钮', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (147, 29, '新增支出', 'btn:expense:add', NULL, NULL, NULL, NULL, 1, 3, '新增支出按钮', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (148, 29, '编辑支出', 'btn:expense:edit', NULL, NULL, NULL, NULL, 2, 3, '编辑支出按钮', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (149, 29, '删除支出', 'btn:expense:delete', NULL, NULL, NULL, NULL, 3, 3, '删除支出按钮', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (150, 30, '生成结算', 'btn:commission:generate', NULL, NULL, NULL, NULL, 1, 3, '生成结算按钮', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (151, 30, '确认发放', 'btn:commission:pay', NULL, NULL, NULL, NULL, 2, 3, '确认发放按钮', 1, 0, 0, '2026-05-12 10:19:20', '2026-05-12 10:19:20');
INSERT INTO `permissions` VALUES (152, 27, '删除文章', 'btn:article:delete', NULL, NULL, NULL, NULL, 4, 3, NULL, 1, 0, 0, '2026-05-14 14:38:40', '2026-05-14 14:38:40');
INSERT INTO `permissions` VALUES (153, 14, '删除字典', 'btn:dict:delete', NULL, NULL, NULL, NULL, 3, 3, NULL, 1, 0, 0, '2026-05-14 14:38:40', '2026-05-14 14:38:40');
INSERT INTO `permissions` VALUES (154, 34, '发送通知', 'btn:notification:send', NULL, NULL, NULL, NULL, 1, 3, NULL, 1, 0, 0, '2026-05-14 14:38:40', '2026-05-14 14:38:40');
INSERT INTO `permissions` VALUES (155, 34, '标记已读', 'btn:notification:read', NULL, NULL, NULL, NULL, 2, 3, NULL, 1, 0, 0, '2026-05-14 14:38:40', '2026-05-14 14:38:40');
INSERT INTO `permissions` VALUES (156, 36, '编辑店铺', 'btn:shop:myEdit', NULL, NULL, NULL, NULL, 1, 3, NULL, 1, 0, 0, '2026-05-19 16:22:48', '2026-05-19 16:22:48');
INSERT INTO `permissions` VALUES (157, 36, '营业切换', 'btn:shop:myStatus', NULL, NULL, NULL, NULL, 2, 3, NULL, 1, 0, 0, '2026-05-19 16:22:48', '2026-05-19 16:22:48');
INSERT INTO `permissions` VALUES (158, 18, '标签管理', 'btn:customer:tag', NULL, NULL, NULL, NULL, 5, 3, NULL, 1, 0, 0, '2026-05-20 13:30:33', '2026-05-20 13:30:33');
INSERT INTO `permissions` VALUES (159, 23, '分类管理', 'btn:material:category', NULL, NULL, NULL, NULL, 4, 3, '物料分类管理按钮', 1, 0, 0, '2026-05-20 14:42:04', '2026-05-20 14:42:04');
INSERT INTO `permissions` VALUES (160, 7, '供应商管理', 'inventory:supplier', '/inventory/supplier', '/src/views/inventory/supplier/index.vue', NULL, 'ep/goods', 2, 2, '供应商管理', 1, 0, 0, '2026-05-20 15:59:34', '2026-05-20 16:15:39');
INSERT INTO `permissions` VALUES (161, 160, '新增供应商', 'btn:supplier:add', NULL, NULL, NULL, NULL, 1, 3, '新增供应商按钮', 1, 0, 0, '2026-05-20 15:59:34', '2026-05-20 15:59:34');
INSERT INTO `permissions` VALUES (162, 160, '编辑供应商', 'btn:supplier:edit', NULL, NULL, NULL, NULL, 2, 3, '编辑供应商按钮', 1, 0, 0, '2026-05-20 15:59:34', '2026-05-20 15:59:34');
INSERT INTO `permissions` VALUES (163, 160, '删除供应商', 'btn:supplier:delete', NULL, NULL, NULL, NULL, 3, 3, '删除供应商按钮', 1, 0, 0, '2026-05-20 15:59:34', '2026-05-20 15:59:34');
INSERT INTO `permissions` VALUES (164, 19, '删除套餐', 'btn:package:delete', NULL, NULL, NULL, NULL, 4, 3, '删除套餐按钮', 1, 0, 0, '2026-05-21 08:51:48', '2026-05-21 08:51:48');
INSERT INTO `permissions` VALUES (165, 0, '评价反馈', 'feedback:list', '/feedback', '/src/views/feedback/index.vue', NULL, 'ep/comment', 12, 2, NULL, 1, 0, 0, '2026-05-23 10:02:05', '2026-05-23 10:17:49');
INSERT INTO `permissions` VALUES (166, 26, '删除优惠券', 'btn:coupon:delete', NULL, NULL, NULL, NULL, 4, 3, '删除优惠券按钮', 1, 0, 0, '2026-05-23 10:42:16', '2026-05-23 10:42:16');
INSERT INTO `permissions` VALUES (167, 15, '重置密码', 'btn:tenant:password', NULL, NULL, NULL, NULL, 5, 3, NULL, 1, 0, 0, '2026-05-23 15:57:00', '2026-05-23 15:57:00');

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
) ENGINE = InnoDB AUTO_INCREMENT = 34 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '积分记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of points_records
-- ----------------------------
INSERT INTO `points_records` VALUES (1, 5, 19, 1, 300, 300, 'recharge', NULL, '充值赠送积分', '2026-05-28 10:53:44', 0, NULL);
INSERT INTO `points_records` VALUES (2, 5, 20, 1, 100, 100, 'recharge', NULL, '充值赠送积分', '2026-05-28 10:53:44', 0, NULL);
INSERT INTO `points_records` VALUES (3, 5, 21, 1, 500, 500, 'recharge', NULL, '充值赠送积分', '2026-05-28 10:53:44', 0, NULL);
INSERT INTO `points_records` VALUES (4, 5, 22, 1, 200, 200, 'recharge', NULL, '充值赠送积分', '2026-05-28 10:53:44', 0, NULL);
INSERT INTO `points_records` VALUES (5, 5, 24, 1, 150, 150, 'recharge', NULL, '充值赠送积分', '2026-05-28 10:53:44', 0, NULL);
INSERT INTO `points_records` VALUES (6, 5, 25, 1, 400, 400, 'recharge', NULL, '充值赠送积分', '2026-05-28 10:53:44', 0, NULL);
INSERT INTO `points_records` VALUES (7, 5, 27, 1, 250, 250, 'recharge', NULL, '充值赠送积分', '2026-05-28 10:53:44', 0, NULL);
INSERT INTO `points_records` VALUES (8, 5, 29, 1, 350, 350, 'recharge', NULL, '充值赠送积分', '2026-05-28 10:53:44', 0, NULL);
INSERT INTO `points_records` VALUES (9, 5, 30, 1, 100, 100, 'recharge', NULL, '充值赠送积分', '2026-05-28 10:53:44', 0, NULL);
INSERT INTO `points_records` VALUES (10, 5, 32, 1, 200, 200, 'recharge', NULL, '充值赠送积分', '2026-05-28 10:53:44', 0, NULL);
INSERT INTO `points_records` VALUES (11, 5, 19, 2, -30, 270, 'consume', NULL, '消费扣减积分', '2026-05-28 10:53:44', 0, NULL);
INSERT INTO `points_records` VALUES (12, 5, 21, 2, -50, 450, 'consume', NULL, '消费扣减积分', '2026-05-28 10:53:44', 0, NULL);
INSERT INTO `points_records` VALUES (13, 5, 25, 2, -100, 300, 'consume', NULL, '消费扣减积分', '2026-05-28 10:53:44', 0, NULL);
INSERT INTO `points_records` VALUES (14, 5, 34, 1, 500, 500, 'recharge', NULL, '充值赠送', '2026-05-09 10:00:00', 0, NULL);
INSERT INTO `points_records` VALUES (15, 5, 36, 1, 200, 200, 'recharge', NULL, '充值赠送', '2026-05-11 09:00:00', 0, NULL);
INSERT INTO `points_records` VALUES (16, 5, 37, 1, 1000, 1000, 'recharge', NULL, '充值赠送', '2026-05-12 11:00:00', 0, NULL);
INSERT INTO `points_records` VALUES (17, 5, 39, 1, 300, 300, 'recharge', NULL, '充值赠送', '2026-05-14 10:00:00', 0, NULL);
INSERT INTO `points_records` VALUES (18, 5, 40, 1, 800, 800, 'recharge', NULL, '充值赠送', '2026-05-15 14:00:00', 0, NULL);
INSERT INTO `points_records` VALUES (19, 5, 41, 1, 150, 150, 'recharge', NULL, '充值赠送', '2026-05-16 15:00:00', 0, NULL);
INSERT INTO `points_records` VALUES (20, 5, 43, 1, 250, 250, 'recharge', NULL, '充值赠送', '2026-05-18 10:00:00', 0, NULL);
INSERT INTO `points_records` VALUES (21, 5, 44, 1, 400, 400, 'recharge', NULL, '充值赠送', '2026-05-19 14:00:00', 0, NULL);
INSERT INTO `points_records` VALUES (22, 5, 46, 1, 100, 100, 'recharge', NULL, '充值赠送', '2026-05-21 16:00:00', 0, NULL);
INSERT INTO `points_records` VALUES (23, 5, 47, 1, 600, 600, 'recharge', NULL, '充值赠送', '2026-05-22 10:00:00', 0, NULL);
INSERT INTO `points_records` VALUES (24, 5, 34, 2, -50, 450, 'consume', 18, '消费扣积分', '2026-05-09 11:30:00', 0, NULL);
INSERT INTO `points_records` VALUES (25, 5, 37, 2, -100, 900, 'consume', 21, '消费扣积分', '2026-05-12 12:15:00', 0, NULL);
INSERT INTO `points_records` VALUES (26, 5, 39, 2, -30, 270, 'consume', 23, '消费扣积分', '2026-05-14 11:45:00', 0, NULL);
INSERT INTO `points_records` VALUES (27, 5, 40, 2, -80, 720, 'consume', 24, '消费扣积分', '2026-05-15 15:00:00', 0, NULL);
INSERT INTO `points_records` VALUES (28, 5, 43, 2, -25, 225, 'consume', 27, '消费扣积分', '2026-05-18 11:15:00', 0, NULL);
INSERT INTO `points_records` VALUES (29, 5, 44, 2, -40, 360, 'consume', 28, '消费扣积分', '2026-05-19 15:15:00', 0, NULL);
INSERT INTO `points_records` VALUES (30, 5, 34, 1, 30, 480, 'purchase', 33, '消费赠送积分', '2026-05-24 11:00:00', 0, NULL);
INSERT INTO `points_records` VALUES (31, 5, 37, 1, 30, 930, 'purchase', 39, '消费赠送积分', '2026-05-30 11:15:00', 0, NULL);
INSERT INTO `points_records` VALUES (32, 5, 43, 1, 30, 255, 'purchase', 41, '消费赠送积分', '2026-06-01 10:30:00', 0, NULL);
INSERT INTO `points_records` VALUES (33, 5, 44, 1, 25, 385, 'purchase', 42, '消费赠送积分', '2026-06-01 11:00:00', 0, NULL);

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
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '预收款入账记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of prepayments
-- ----------------------------
INSERT INTO `prepayments` VALUES (1, 5, 1, 24.90, 0.00, 24.90, '2026-05-21 14:47:52', 0, NULL);
INSERT INTO `prepayments` VALUES (2, 5, 2, 99.90, 0.00, 0.00, '2026-05-21 14:50:02', 1, NULL);
INSERT INTO `prepayments` VALUES (3, 5, 3, 99.90, 100.00, 0.10, '2026-05-21 15:00:15', 0, NULL);
INSERT INTO `prepayments` VALUES (4, 5, 4, 24.90, 0.00, 24.90, '2026-05-22 13:15:40', 0, NULL);
INSERT INTO `prepayments` VALUES (5, 5, 12, 299.00, 699.00, 400.00, '2026-05-28 10:58:39', 0, NULL);
INSERT INTO `prepayments` VALUES (6, 5, 21, 299.00, 1000.00, 701.00, '2026-05-12 11:15:00', 0, NULL);
INSERT INTO `prepayments` VALUES (7, 5, 39, 29.90, 701.00, 671.10, '2026-05-30 10:15:00', 0, NULL);
INSERT INTO `prepayments` VALUES (8, 5, 53, 29.90, 671.10, 641.20, '2026-06-09 11:00:00', 0, NULL);

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
) ENGINE = InnoDB AUTO_INCREMENT = 32 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '采购明细' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of purchase_order_items
-- ----------------------------
INSERT INTO `purchase_order_items` VALUES (1, 1, 3, 100.00, 1000.00, '2026-05-20 16:33:59', 0, NULL);
INSERT INTO `purchase_order_items` VALUES (2, 1, 2, 50.00, 500.00, '2026-05-20 16:33:59', 0, NULL);
INSERT INTO `purchase_order_items` VALUES (3, 2, 1, 100.00, 5.00, '2026-05-21 08:02:07', 0, NULL);
INSERT INTO `purchase_order_items` VALUES (4, 3, 3, 50.00, 10.00, '2026-05-21 08:05:58', 0, NULL);
INSERT INTO `purchase_order_items` VALUES (5, 4, 6, 2.00, 40.00, '2026-05-22 13:16:38', 0, NULL);
INSERT INTO `purchase_order_items` VALUES (6, 5, 10, 100.00, 12.00, '2026-05-22 13:18:45', 0, NULL);
INSERT INTO `purchase_order_items` VALUES (7, 5, 9, 100.00, 3.00, '2026-05-22 13:18:45', 0, NULL);
INSERT INTO `purchase_order_items` VALUES (8, 5, 8, 50.00, 15.00, '2026-05-22 13:18:45', 0, NULL);
INSERT INTO `purchase_order_items` VALUES (9, 5, 7, 100.00, 10.00, '2026-05-22 13:18:45', 0, NULL);
INSERT INTO `purchase_order_items` VALUES (10, 5, 1, 50.00, 5.00, '2026-05-22 13:18:45', 0, NULL);
INSERT INTO `purchase_order_items` VALUES (11, 5, 4, 1.00, 200.00, '2026-05-22 13:18:45', 0, NULL);
INSERT INTO `purchase_order_items` VALUES (12, 5, 3, 70.00, 10.00, '2026-05-22 13:18:45', 0, NULL);
INSERT INTO `purchase_order_items` VALUES (13, 6, 4, 3.00, 100.00, '2026-05-22 15:56:45', 0, NULL);
INSERT INTO `purchase_order_items` VALUES (14, 7, 4, 1.00, 100.00, '2026-05-22 16:34:47', 0, NULL);
INSERT INTO `purchase_order_items` VALUES (15, 8, 4, 2.00, 100.00, '2026-05-22 16:35:31', 0, NULL);
INSERT INTO `purchase_order_items` VALUES (16, 9, 4, 2.00, 100.00, '2026-05-25 09:07:24', 0, NULL);
INSERT INTO `purchase_order_items` VALUES (17, 10, 3, 100.00, 15.00, '2026-05-10 10:00:00', 0, NULL);
INSERT INTO `purchase_order_items` VALUES (18, 10, 1, 50.00, 20.00, '2026-05-10 10:00:00', 0, NULL);
INSERT INTO `purchase_order_items` VALUES (19, 10, 7, 30.00, 30.00, '2026-05-10 10:00:00', 0, NULL);
INSERT INTO `purchase_order_items` VALUES (20, 11, 9, 100.00, 12.00, '2026-05-15 14:00:00', 0, NULL);
INSERT INTO `purchase_order_items` VALUES (21, 12, 14, 20.00, 35.00, '2026-05-20 11:00:00', 0, NULL);
INSERT INTO `purchase_order_items` VALUES (22, 12, 13, 100.00, 1.00, '2026-05-20 11:00:00', 0, NULL);
INSERT INTO `purchase_order_items` VALUES (23, 13, 8, 50.00, 25.00, '2026-05-25 09:00:00', 0, NULL);
INSERT INTO `purchase_order_items` VALUES (24, 13, 14, 20.00, 37.50, '2026-05-25 09:00:00', 0, NULL);
INSERT INTO `purchase_order_items` VALUES (25, 14, 15, 500.00, 1.20, '2026-05-30 10:00:00', 0, NULL);
INSERT INTO `purchase_order_items` VALUES (26, 15, 12, 30.00, 16.67, '2026-06-02 14:00:00', 0, NULL);
INSERT INTO `purchase_order_items` VALUES (27, 16, 11, 20.00, 75.00, '2026-06-05 11:00:00', 0, NULL);
INSERT INTO `purchase_order_items` VALUES (28, 17, 3, 50.00, 10.00, '2026-06-08 16:00:00', 0, NULL);
INSERT INTO `purchase_order_items` VALUES (29, 17, 1, 20.00, 15.00, '2026-06-08 16:00:00', 0, NULL);
INSERT INTO `purchase_order_items` VALUES (30, 17, 8, 10.00, 20.00, '2026-06-08 16:00:00', 0, NULL);
INSERT INTO `purchase_order_items` VALUES (31, 17, 5, 100.00, 1.00, '2026-06-08 16:00:00', 0, NULL);

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
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '采购单' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of purchase_orders
-- ----------------------------
INSERT INTO `purchase_orders` VALUES (1, 5, 1, 'PO1779266039044', '2026-05-20', 1, 125000.00, 0.00, 2, 9, NULL, '2026-05-20 16:33:59', '2026-05-20 16:34:36', 0, NULL);
INSERT INTO `purchase_orders` VALUES (2, 5, 1, 'PO1779321726536', '2026-05-21', 1, 500.00, 500.00, 2, 9, NULL, '2026-05-21 08:02:07', '2026-05-21 08:03:07', 0, NULL);
INSERT INTO `purchase_orders` VALUES (3, 5, 1, 'PO1779321958020', '2026-05-21', 1, 500.00, 500.00, 2, 9, NULL, '2026-05-21 08:05:58', '2026-05-21 08:13:26', 0, NULL);
INSERT INTO `purchase_orders` VALUES (4, 5, 2, 'PO1779426997668', '2026-05-22', 1, 80.00, 80.00, 2, 9, NULL, '2026-05-22 13:16:38', '2026-05-22 13:19:13', 0, NULL);
INSERT INTO `purchase_orders` VALUES (5, 5, 4, 'PO1779427124922', '2026-05-22', 1, 4400.00, 4000.00, 2, 9, NULL, '2026-05-22 13:18:45', '2026-05-22 13:19:02', 0, NULL);
INSERT INTO `purchase_orders` VALUES (6, 5, 4, 'PO1779436605023', '2026-05-22', 1, 300.00, 300.00, 2, 9, NULL, '2026-05-22 15:56:45', '2026-05-22 15:56:54', 0, NULL);
INSERT INTO `purchase_orders` VALUES (7, 5, 4, 'PO1779438886743', '2026-05-22', 1, 100.00, 100.00, 2, 9, NULL, '2026-05-22 16:34:47', '2026-05-22 16:34:56', 0, NULL);
INSERT INTO `purchase_orders` VALUES (8, 5, 4, 'PO1779438931293', '2026-05-22', 1, 200.00, 200.00, 2, 9, NULL, '2026-05-22 16:35:31', '2026-05-22 16:35:41', 0, NULL);
INSERT INTO `purchase_orders` VALUES (9, 5, 4, 'PO1779671244273-4800', '2026-05-25', 1, 200.00, 200.00, 2, 9, NULL, '2026-05-25 09:07:24', '2026-05-25 09:07:41', 0, NULL);
INSERT INTO `purchase_orders` VALUES (10, 5, 5, 'PO20260510001', '2026-05-10', 1, 3500.00, 3500.00, 2, 43, '拼豆补货', '2026-05-10 10:00:00', '2026-06-09 22:29:34', 0, NULL);
INSERT INTO `purchase_orders` VALUES (11, 5, 5, 'PO20260515001', '2026-05-15', 1, 1200.00, 1200.00, 2, 43, '钥匙扣配件', '2026-05-15 14:00:00', '2026-06-09 22:29:34', 0, NULL);
INSERT INTO `purchase_orders` VALUES (12, 5, 6, 'PO20260520001', '2026-05-20', 1, 800.00, 800.00, 2, 44, '颜料采购', '2026-05-20 11:00:00', '2026-06-09 22:29:34', 0, NULL);
INSERT INTO `purchase_orders` VALUES (13, 5, 5, 'PO20260525001', '2026-05-25', 2, 2000.00, 1000.00, 1, 43, '石膏补货（赊账）', '2026-05-25 09:00:00', '2026-06-09 22:29:34', 0, NULL);
INSERT INTO `purchase_orders` VALUES (14, 5, 5, 'PO20260530001', '2026-05-30', 1, 600.00, 600.00, 2, 44, '包装材料', '2026-05-30 10:00:00', '2026-06-09 22:29:34', 0, NULL);
INSERT INTO `purchase_orders` VALUES (15, 5, 6, 'PO20260602001', '2026-06-02', 1, 500.00, 500.00, 2, 43, '画笔采购', '2026-06-02 14:00:00', '2026-06-09 22:29:34', 0, NULL);
INSERT INTO `purchase_orders` VALUES (16, 5, 5, 'PO20260605001', '2026-06-05', 1, 1500.00, 1500.00, 2, 44, '拼豆豪华装', '2026-06-05 11:00:00', '2026-06-09 22:29:34', 0, NULL);
INSERT INTO `purchase_orders` VALUES (17, 5, 5, 'PO20260608001', '2026-06-08', 1, 800.00, 0.00, 1, 43, '待付款采购', '2026-06-08 16:00:00', '2026-06-09 22:29:34', 0, NULL);

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
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '采购付款记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of purchase_payments
-- ----------------------------
INSERT INTO `purchase_payments` VALUES (1, 2, 200.00, 'cash', '2026-05-21 00:00:00', NULL, '2026-05-21 08:02:22', 0, NULL, NULL);
INSERT INTO `purchase_payments` VALUES (2, 2, 300.00, 'cash', '2026-05-21 00:00:00', NULL, '2026-05-21 08:02:53', 0, NULL, NULL);
INSERT INTO `purchase_payments` VALUES (3, 3, 100.00, 'cash', '2026-05-21 00:00:00', NULL, '2026-05-21 08:12:25', 0, NULL, NULL);
INSERT INTO `purchase_payments` VALUES (4, 3, 400.00, 'cash', '2026-05-21 00:00:00', NULL, '2026-05-21 08:12:45', 0, NULL, NULL);
INSERT INTO `purchase_payments` VALUES (5, 5, 4000.00, 'cash', '2026-05-22 00:00:00', NULL, '2026-05-22 13:18:57', 0, NULL, 1);
INSERT INTO `purchase_payments` VALUES (6, 4, 80.00, 'cash', '2026-05-22 00:00:00', NULL, '2026-05-22 13:19:10', 0, NULL, 2);
INSERT INTO `purchase_payments` VALUES (7, 6, 300.00, 'cash', '2026-05-22 00:00:00', NULL, '2026-05-22 15:56:51', 0, NULL, 5);
INSERT INTO `purchase_payments` VALUES (8, 7, 100.00, 'cash', '2026-05-22 00:00:00', NULL, '2026-05-22 16:34:54', 0, NULL, 6);
INSERT INTO `purchase_payments` VALUES (9, 8, 200.00, 'cash', '2026-05-22 00:00:00', NULL, '2026-05-22 16:35:38', 0, NULL, 7);
INSERT INTO `purchase_payments` VALUES (10, 9, 200.00, 'cash', '2026-05-25 00:00:00', NULL, '2026-05-25 09:07:38', 0, NULL, 8);
INSERT INTO `purchase_payments` VALUES (11, 5, 4400.00, 'bank_transfer', '2026-05-20 10:00:00', '采购订单全额付款', '2026-05-28 11:04:25', 0, NULL, NULL);
INSERT INTO `purchase_payments` VALUES (12, 6, 300.00, 'wechat', '2026-05-22 14:00:00', '物料采购付款', '2026-05-28 11:04:25', 0, NULL, NULL);
INSERT INTO `purchase_payments` VALUES (13, 7, 100.00, 'cash', '2026-05-22 15:00:00', '物料采购付款', '2026-05-28 11:04:25', 0, NULL, NULL);
INSERT INTO `purchase_payments` VALUES (14, 10, 3500.00, 'bank_transfer', '2026-05-10 11:00:00', '拼豆补货全款', '2026-05-10 11:00:00', 0, NULL, NULL);
INSERT INTO `purchase_payments` VALUES (15, 11, 1200.00, 'wechat', '2026-05-15 15:00:00', '配件全款', '2026-05-15 15:00:00', 0, NULL, NULL);
INSERT INTO `purchase_payments` VALUES (16, 12, 800.00, 'alipay', '2026-05-20 12:00:00', '颜料全款', '2026-05-20 12:00:00', 0, NULL, NULL);
INSERT INTO `purchase_payments` VALUES (17, 13, 1000.00, 'bank_transfer', '2026-05-25 10:00:00', '石膏首付', '2026-05-25 10:00:00', 0, NULL, NULL);
INSERT INTO `purchase_payments` VALUES (18, 14, 600.00, 'cash', '2026-05-30 11:00:00', '包装材料全款', '2026-05-30 11:00:00', 0, NULL, NULL);
INSERT INTO `purchase_payments` VALUES (19, 15, 500.00, 'wechat', '2026-06-02 15:00:00', '画笔全款', '2026-06-02 15:00:00', 0, NULL, NULL);
INSERT INTO `purchase_payments` VALUES (20, 16, 1500.00, 'bank_transfer', '2026-06-05 12:00:00', '豪华装全款', '2026-06-05 12:00:00', 0, NULL, NULL);

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
) ENGINE = InnoDB AUTO_INCREMENT = 58 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '顾客购买/充值记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of purchases
-- ----------------------------
INSERT INTO `purchases` VALUES (1, 5, 15, 6, 'purchase', 'store', NULL, NULL, '2026-05-21', 24.90, 24.90, 0.00, 'wechat', 1, 9, NULL, 0, '2026-05-21 14:47:52', '2026-05-21 14:47:52', NULL);
INSERT INTO `purchases` VALUES (2, 5, 14, 7, 'purchase', 'douyin', '1234567890', NULL, '2026-05-21', 99.90, 0.00, 0.00, NULL, 2, 9, NULL, 0, '2026-05-21 14:50:02', '2026-05-21 14:59:55', NULL);
INSERT INTO `purchases` VALUES (3, 5, 3, 7, 'purchase', 'store', NULL, NULL, '2026-05-21', 99.90, 99.90, 0.00, 'wallet', 1, 9, NULL, 0, '2026-05-21 15:00:15', '2026-05-21 15:00:15', NULL);
INSERT INTO `purchases` VALUES (4, 5, 15, 6, 'purchase', 'store', NULL, NULL, '2026-05-22', 24.90, 24.90, 0.00, 'wechat', 1, 9, NULL, 0, '2026-05-22 13:15:40', '2026-05-22 13:15:40', NULL);
INSERT INTO `purchases` VALUES (5, 5, 14, NULL, 'recharge', 'store', NULL, 4, '2026-05-23', 200.00, 180.00, 20.00, 'other', 1, 9, '充值¥200（优惠抵扣¥20）', 0, '2026-05-23 15:00:20', '2026-05-23 15:00:20', NULL);
INSERT INTO `purchases` VALUES (6, 5, 19, 4, 'purchase', 'store', NULL, NULL, '2026-05-01', 29.90, 29.90, 0.00, 'wechat', 1, 43, '首次到店购买', 0, '2026-05-28 10:55:49', '2026-05-28 10:55:49', NULL);
INSERT INTO `purchases` VALUES (7, 5, 20, 5, 'purchase', 'meituan', NULL, NULL, '2026-05-02', 299.00, 299.00, 0.00, 'alipay', 1, 43, '美团团购月卡', 0, '2026-05-28 10:55:49', '2026-05-28 10:55:49', NULL);
INSERT INTO `purchases` VALUES (8, 5, 21, 6, 'purchase', 'douyin', NULL, NULL, '2026-05-03', 24.90, 24.90, 0.00, 'wechat', 1, 44, '抖音团购石膏涂色', 0, '2026-05-28 10:55:49', '2026-05-28 10:55:49', NULL);
INSERT INTO `purchases` VALUES (9, 5, 22, 7, 'purchase', 'miniapp', NULL, NULL, '2026-05-04', 99.90, 99.90, 0.00, 'wechat', 1, 43, '小程序购买周卡', 0, '2026-05-28 10:55:49', '2026-05-28 10:55:49', NULL);
INSERT INTO `purchases` VALUES (10, 5, 23, 8, 'purchase', 'store', NULL, NULL, '2026-05-05', 29.90, 29.90, 0.00, 'cash', 1, 44, '现金购买石膏涂色', 0, '2026-05-28 10:55:49', '2026-05-28 10:55:49', NULL);
INSERT INTO `purchases` VALUES (11, 5, 24, 4, 'purchase', 'store', NULL, NULL, '2026-05-06', 29.90, 29.90, 0.00, 'wechat', 1, 43, '微信支付拼豆单次', 0, '2026-05-28 10:55:49', '2026-05-28 10:55:49', NULL);
INSERT INTO `purchases` VALUES (12, 5, 25, 9, 'purchase', 'store', NULL, NULL, '2026-05-07', 299.00, 299.00, 0.00, 'wallet', 1, 43, '储值卡支付创意月卡', 0, '2026-05-28 10:55:49', '2026-05-28 10:55:49', NULL);
INSERT INTO `purchases` VALUES (13, 5, 26, 10, 'purchase', 'meituan', NULL, NULL, '2026-05-08', 199.00, 199.00, 0.00, 'alipay', 1, 44, '美团购买亲子周卡', 0, '2026-05-28 10:55:49', '2026-05-28 10:55:49', NULL);
INSERT INTO `purchases` VALUES (14, 5, 27, 6, 'purchase', 'store', NULL, NULL, '2026-05-10', 24.90, 24.90, 0.00, 'wechat', 1, 43, '微信支付石膏涂色', 0, '2026-05-28 10:55:49', '2026-05-28 10:55:49', NULL);
INSERT INTO `purchases` VALUES (15, 5, 28, 4, 'purchase', 'store', NULL, NULL, '2026-05-12', 29.90, 29.90, 0.00, 'cash', 3, 44, '已过期未使用', 0, '2026-05-28 10:55:49', '2026-05-28 10:55:49', NULL);
INSERT INTO `purchases` VALUES (16, 5, 29, 5, 'purchase', 'douyin', NULL, NULL, '2026-05-15', 299.00, 299.00, 0.00, 'wechat', 1, 43, '抖音团购月卡', 0, '2026-05-28 10:55:49', '2026-05-28 10:55:49', NULL);
INSERT INTO `purchases` VALUES (17, 5, 30, 7, 'purchase', 'miniapp', NULL, NULL, '2026-05-18', 99.90, 99.90, 0.00, 'wechat', 1, 44, '小程序购买周卡', 0, '2026-05-28 10:55:49', '2026-05-28 10:55:49', NULL);
INSERT INTO `purchases` VALUES (18, 5, 34, 5, 'purchase', 'store', NULL, NULL, '2026-05-09', 299.00, 299.00, 0.00, 'wechat', 1, 43, '月卡新客', 0, '2026-05-09 10:30:00', '2026-06-09 22:29:13', NULL);
INSERT INTO `purchases` VALUES (19, 5, 35, 4, 'purchase', 'meituan', NULL, NULL, '2026-05-10', 29.90, 29.90, 0.00, 'alipay', 1, 44, '美团单次', 0, '2026-05-10 14:45:00', '2026-06-09 22:29:13', NULL);
INSERT INTO `purchases` VALUES (20, 5, 36, 7, 'purchase', 'store', NULL, NULL, '2026-05-11', 99.90, 99.90, 0.00, 'wechat', 1, 43, '周卡亲子', 0, '2026-05-11 09:30:00', '2026-06-09 22:29:13', NULL);
INSERT INTO `purchases` VALUES (21, 5, 37, 9, 'purchase', 'store', NULL, NULL, '2026-05-12', 299.00, 299.00, 0.00, 'wallet', 1, 43, '创意月卡VIP', 0, '2026-05-12 11:15:00', '2026-06-09 22:29:13', NULL);
INSERT INTO `purchases` VALUES (22, 5, 38, 6, 'purchase', 'miniapp', NULL, NULL, '2026-05-13', 24.90, 24.90, 0.00, 'wechat', 1, 44, '小程序涂色', 0, '2026-05-13 16:30:00', '2026-06-09 22:29:13', NULL);
INSERT INTO `purchases` VALUES (23, 5, 39, 5, 'purchase', 'meituan', NULL, NULL, '2026-05-14', 299.00, 299.00, 0.00, 'alipay', 1, 43, '美团月卡', 0, '2026-05-14 10:45:00', '2026-06-09 22:29:13', NULL);
INSERT INTO `purchases` VALUES (24, 5, 40, 10, 'purchase', 'store', NULL, NULL, '2026-05-15', 199.00, 199.00, 0.00, 'wechat', 1, 44, '亲子周卡', 0, '2026-05-15 14:00:00', '2026-06-09 22:29:13', NULL);
INSERT INTO `purchases` VALUES (25, 5, 41, 4, 'purchase', 'douyin', NULL, NULL, '2026-05-16', 29.90, 29.90, 0.00, 'wechat', 1, 43, '抖音团购', 0, '2026-05-16 15:15:00', '2026-06-09 22:29:13', NULL);
INSERT INTO `purchases` VALUES (26, 5, 42, 8, 'purchase', 'store', NULL, NULL, '2026-05-17', 29.90, 29.90, 0.00, 'cash', 1, 44, '现金石膏', 0, '2026-05-17 09:45:00', '2026-06-09 22:29:13', NULL);
INSERT INTO `purchases` VALUES (27, 5, 43, 5, 'purchase', 'miniapp', NULL, NULL, '2026-05-18', 299.00, 299.00, 0.00, 'wechat', 1, 43, '小程序月卡', 0, '2026-05-18 10:15:00', '2026-06-09 22:29:13', NULL);
INSERT INTO `purchases` VALUES (28, 5, 44, 7, 'purchase', 'store', NULL, NULL, '2026-05-19', 99.90, 99.90, 0.00, 'wechat', 1, 44, '周卡常客', 0, '2026-05-19 14:15:00', '2026-06-09 22:29:13', NULL);
INSERT INTO `purchases` VALUES (29, 5, 45, 6, 'purchase', 'meituan', NULL, NULL, '2026-05-20', 24.90, 24.90, 0.00, 'alipay', 1, 43, '美团涂色', 0, '2026-05-20 11:45:00', '2026-06-09 22:29:13', NULL);
INSERT INTO `purchases` VALUES (30, 5, 46, 4, 'purchase', 'store', NULL, NULL, '2026-05-21', 29.90, 29.90, 0.00, 'cash', 1, 44, '现金单次', 0, '2026-05-21 16:15:00', '2026-06-09 22:29:13', NULL);
INSERT INTO `purchases` VALUES (31, 5, 47, 9, 'purchase', 'douyin', NULL, NULL, '2026-05-22', 299.00, 299.00, 0.00, 'wechat', 1, 43, '抖音月卡', 0, '2026-05-22 10:00:00', '2026-06-09 22:29:13', NULL);
INSERT INTO `purchases` VALUES (32, 5, 48, 8, 'purchase', 'store', NULL, NULL, '2026-05-23', 29.90, 29.90, 0.00, 'wechat', 1, 44, '新客石膏', 0, '2026-05-23 13:30:00', '2026-06-09 22:29:13', NULL);
INSERT INTO `purchases` VALUES (33, 5, 34, 4, 'purchase', 'store', NULL, NULL, '2026-05-24', 29.90, 29.90, 0.00, 'wechat', 1, 43, '二次消费', 0, '2026-05-24 10:00:00', '2026-06-09 22:29:13', NULL);
INSERT INTO `purchases` VALUES (34, 5, 35, 6, 'purchase', 'meituan', NULL, NULL, '2026-05-25', 24.90, 24.90, 0.00, 'alipay', 1, 44, '美团复购', 0, '2026-05-25 14:30:00', '2026-06-09 22:29:13', NULL);
INSERT INTO `purchases` VALUES (35, 5, 36, 4, 'purchase', 'store', NULL, NULL, '2026-05-26', 29.90, 29.90, 0.00, 'wechat', 1, 43, '周卡期间', 0, '2026-05-26 09:45:00', '2026-06-09 22:29:13', NULL);
INSERT INTO `purchases` VALUES (36, 5, 39, 4, 'purchase', 'store', NULL, NULL, '2026-05-27', 29.90, 29.90, 0.00, 'wechat', 1, 44, '常客单次', 0, '2026-05-27 10:30:00', '2026-06-09 22:29:13', NULL);
INSERT INTO `purchases` VALUES (37, 5, 40, 4, 'purchase', 'store', NULL, NULL, '2026-05-28', 29.90, 29.90, 0.00, 'wechat', 1, 43, '亲子单次', 0, '2026-05-28 11:00:00', '2026-06-09 22:29:13', NULL);
INSERT INTO `purchases` VALUES (38, 5, 44, 4, 'purchase', 'store', NULL, NULL, '2026-05-29', 29.90, 29.90, 0.00, 'wechat', 1, 44, '周末消费', 0, '2026-05-29 15:00:00', '2026-06-09 22:29:13', NULL);
INSERT INTO `purchases` VALUES (39, 5, 37, 4, 'purchase', 'store', NULL, NULL, '2026-05-30', 29.90, 29.90, 0.00, 'wallet', 1, 43, 'VIP单次', 0, '2026-05-30 10:15:00', '2026-06-09 22:29:13', NULL);
INSERT INTO `purchases` VALUES (40, 5, 41, 6, 'purchase', 'douyin', NULL, NULL, '2026-05-31', 24.90, 24.90, 0.00, 'wechat', 1, 44, '月末涂色', 0, '2026-05-31 14:00:00', '2026-06-09 22:29:13', NULL);
INSERT INTO `purchases` VALUES (41, 5, 43, 4, 'purchase', 'store', NULL, NULL, '2026-06-01', 29.90, 29.90, 0.00, 'wechat', 1, 43, '儿童节活动', 0, '2026-06-01 09:30:00', '2026-06-09 22:29:13', NULL);
INSERT INTO `purchases` VALUES (42, 5, 44, 6, 'purchase', 'store', NULL, NULL, '2026-06-01', 24.90, 24.90, 0.00, 'wechat', 1, 44, '儿童节涂色', 0, '2026-06-01 10:00:00', '2026-06-09 22:29:13', NULL);
INSERT INTO `purchases` VALUES (43, 5, 34, 8, 'purchase', 'store', NULL, NULL, '2026-06-01', 29.90, 29.90, 0.00, 'wechat', 1, 43, '儿童节石膏', 0, '2026-06-01 11:00:00', '2026-06-09 22:29:13', NULL);
INSERT INTO `purchases` VALUES (44, 5, 39, 7, 'purchase', 'store', NULL, NULL, '2026-06-02', 99.90, 99.90, 0.00, 'wechat', 1, 44, '常客周卡', 0, '2026-06-02 10:30:00', '2026-06-09 22:29:13', NULL);
INSERT INTO `purchases` VALUES (45, 5, 40, 4, 'purchase', 'store', NULL, NULL, '2026-06-03', 29.90, 29.90, 0.00, 'wechat', 1, 43, '亲子消费', 0, '2026-06-03 14:00:00', '2026-06-09 22:29:13', NULL);
INSERT INTO `purchases` VALUES (46, 5, 45, 5, 'purchase', 'meituan', NULL, NULL, '2026-06-04', 299.00, 299.00, 0.00, 'alipay', 1, 44, '美团月卡新', 0, '2026-06-04 11:30:00', '2026-06-09 22:29:13', NULL);
INSERT INTO `purchases` VALUES (47, 5, 47, 4, 'purchase', 'store', NULL, NULL, '2026-06-05', 29.90, 29.90, 0.00, 'wechat', 1, 43, '月卡续费', 0, '2026-06-05 10:00:00', '2026-06-09 22:29:13', NULL);
INSERT INTO `purchases` VALUES (48, 5, 48, 6, 'purchase', 'store', NULL, NULL, '2026-06-06', 24.90, 24.90, 0.00, 'wechat', 1, 44, '周末涂色', 0, '2026-06-06 09:30:00', '2026-06-09 22:29:13', NULL);
INSERT INTO `purchases` VALUES (49, 5, 36, 4, 'purchase', 'store', NULL, NULL, '2026-06-07', 29.90, 29.90, 0.00, 'wechat', 1, 43, '周日消费', 0, '2026-06-07 10:00:00', '2026-06-09 22:29:13', NULL);
INSERT INTO `purchases` VALUES (50, 5, 42, 8, 'purchase', 'store', NULL, NULL, '2026-06-08', 29.90, 29.90, 0.00, 'cash', 1, 44, '现金石膏', 0, '2026-06-08 14:30:00', '2026-06-09 22:29:13', NULL);
INSERT INTO `purchases` VALUES (51, 5, 44, 4, 'purchase', 'store', NULL, NULL, '2026-06-09', 29.90, 29.90, 0.00, 'wechat', 1, 43, '今日消费', 0, '2026-06-09 09:45:00', '2026-06-09 22:29:13', NULL);
INSERT INTO `purchases` VALUES (52, 5, 34, 6, 'purchase', 'store', NULL, NULL, '2026-06-09', 24.90, 24.90, 0.00, 'wechat', 1, 44, '今日涂色', 0, '2026-06-09 10:30:00', '2026-06-09 22:29:13', NULL);
INSERT INTO `purchases` VALUES (53, 5, 37, 4, 'purchase', 'store', NULL, NULL, '2026-06-09', 29.90, 29.90, 0.00, 'wallet', 1, 43, 'VIP今日', 0, '2026-06-09 11:00:00', '2026-06-09 22:29:13', NULL);
INSERT INTO `purchases` VALUES (54, 5, 39, 8, 'purchase', 'store', NULL, NULL, '2026-06-09', 29.90, 29.90, 0.00, 'wechat', 1, 44, '常客石膏', 0, '2026-06-09 14:00:00', '2026-06-09 22:29:13', NULL);
INSERT INTO `purchases` VALUES (55, 5, 43, 6, 'purchase', 'miniapp', NULL, NULL, '2026-06-09', 24.90, 24.90, 0.00, 'wechat', 1, 43, '小程序涂色', 0, '2026-06-09 15:00:00', '2026-06-09 22:29:13', NULL);
INSERT INTO `purchases` VALUES (56, 5, 40, 4, 'purchase', 'store', NULL, NULL, '2026-06-09', 29.90, 29.90, 0.00, 'wechat', 1, 44, '亲子今日', 0, '2026-06-09 16:00:00', '2026-06-09 22:29:13', NULL);
INSERT INTO `purchases` VALUES (57, 5, 47, 7, 'purchase', 'douyin', NULL, NULL, '2026-06-09', 99.90, 99.90, 0.00, 'wechat', 1, 43, '抖音周卡', 0, '2026-06-09 16:30:00', '2026-06-09 22:29:13', NULL);

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
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '排队等位记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of queue_entries
-- ----------------------------
INSERT INTO `queue_entries` VALUES (1, 5, 34, 1, 2, 2, '2026-05-09 10:00:00', '2026-05-09 10:15:00', NULL, '母子二人', 0, NULL);
INSERT INTO `queue_entries` VALUES (2, 5, 35, 2, 1, 2, '2026-05-10 14:30:00', '2026-05-10 14:45:00', NULL, '单人', 0, NULL);
INSERT INTO `queue_entries` VALUES (3, 5, 36, 3, 3, 2, '2026-05-11 09:15:00', '2026-05-11 09:30:00', NULL, '父子三人', 0, NULL);
INSERT INTO `queue_entries` VALUES (4, 5, 39, 4, 1, 2, '2026-05-14 10:30:00', '2026-05-14 10:45:00', NULL, '常客', 0, NULL);
INSERT INTO `queue_entries` VALUES (5, 5, 40, 5, 4, 2, '2026-05-15 13:45:00', '2026-05-15 14:00:00', NULL, '一家四口', 0, NULL);
INSERT INTO `queue_entries` VALUES (6, 5, 42, 6, 2, 2, '2026-05-17 09:30:00', '2026-05-17 09:45:00', NULL, '父女', 0, NULL);
INSERT INTO `queue_entries` VALUES (7, 5, 43, 7, 1, 2, '2026-05-18 10:00:00', '2026-05-18 10:15:00', NULL, '小程序预约', 0, NULL);
INSERT INTO `queue_entries` VALUES (8, 5, 44, 8, 2, 2, '2026-05-19 14:00:00', '2026-05-19 14:15:00', NULL, '周末常客', 0, NULL);
INSERT INTO `queue_entries` VALUES (9, 5, 34, 9, 2, 2, '2026-05-24 09:45:00', '2026-05-24 10:00:00', NULL, '二次到店', 0, NULL);
INSERT INTO `queue_entries` VALUES (10, 5, 39, 10, 1, 2, '2026-05-27 10:15:00', '2026-05-27 10:30:00', NULL, '常客', 0, NULL);
INSERT INTO `queue_entries` VALUES (11, 5, 43, 11, 2, 2, '2026-06-01 09:15:00', '2026-06-01 09:30:00', NULL, '儿童节', 0, NULL);
INSERT INTO `queue_entries` VALUES (12, 5, 44, 12, 1, 2, '2026-06-01 09:45:00', '2026-06-01 10:00:00', NULL, '儿童节', 0, NULL);
INSERT INTO `queue_entries` VALUES (13, 5, 34, 13, 2, 2, '2026-06-01 10:45:00', '2026-06-01 11:00:00', NULL, '儿童节石膏', 0, NULL);
INSERT INTO `queue_entries` VALUES (14, 5, 47, 14, 1, 1, '2026-06-09 09:30:00', NULL, NULL, '等待中', 0, NULL);
INSERT INTO `queue_entries` VALUES (15, 5, 48, 15, 2, 1, '2026-06-09 10:00:00', NULL, NULL, '等待中', 0, NULL);

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
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '退款记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of refund_records
-- ----------------------------
INSERT INTO `refund_records` VALUES (1, 5, 2, 0.00, '错误输入', 0.00, 99.90, 0.00, 7, 2, 9, '2026-05-21 14:59:55', '2026-05-21 15:56:44', 0, NULL, NULL);
INSERT INTO `refund_records` VALUES (2, 5, 1, 0.00, '商品质量问题退款', 0.00, 0.00, 0.00, 1, 2, 43, '2026-05-28 11:07:26', '2026-05-28 11:07:26', 0, NULL, NULL);
INSERT INTO `refund_records` VALUES (3, 5, 14, 24.90, '材料不足无法体验', 0.00, 0.00, 0.00, 0, 1, 43, '2026-05-28 11:07:26', '2026-05-28 11:07:26', 0, NULL, NULL);
INSERT INTO `refund_records` VALUES (4, 5, 19, 24.90, '顾客不满意要求退款', 5.00, 0.00, 0.00, 0, 2, 43, '2026-05-12 16:00:00', '2026-06-09 22:29:23', 0, NULL, NULL);
INSERT INTO `refund_records` VALUES (5, 5, 25, 29.90, '临时有事无法到店', 0.00, 0.00, 0.00, 0, 2, 44, '2026-05-18 09:00:00', '2026-06-09 22:29:23', 0, NULL, NULL);
INSERT INTO `refund_records` VALUES (6, 5, 34, 24.90, '团购券过期退款', 0.00, 0.00, 0.00, 0, 1, 43, '2026-05-28 14:00:00', '2026-06-09 22:29:23', 0, NULL, NULL);
INSERT INTO `refund_records` VALUES (7, 5, 40, 24.90, '涂色材料不足', 0.00, 0.00, 0.00, 0, 3, 44, '2026-06-02 10:00:00', '2026-06-09 22:29:23', 0, NULL, NULL);
INSERT INTO `refund_records` VALUES (8, 5, 42, 24.90, '儿童节活动退款', 0.00, 0.00, 24.90, 0, 2, 43, '2026-06-03 16:00:00', '2026-06-09 22:29:23', 0, NULL, NULL);

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
) ENGINE = InnoDB AUTO_INCREMENT = 43 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '收入确认记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of revenue_records
-- ----------------------------
INSERT INTO `revenue_records` VALUES (1, 5, 1, 3, 14.27, '2026-05-21 15:56:35', 9, '2026-05-21 15:56:35', 0, NULL, NULL, NULL);
INSERT INTO `revenue_records` VALUES (2, 5, 2, 3, 14.27, '2026-05-22 13:15:59', 9, '2026-05-22 13:15:59', 0, NULL, 'wallet', 3);
INSERT INTO `revenue_records` VALUES (3, 5, 3, 4, 24.90, '2026-05-22 13:19:42', 9, '2026-05-22 13:19:42', 0, NULL, 'wechat', 15);
INSERT INTO `revenue_records` VALUES (4, 5, 4, 3, 14.27, '2026-05-23 12:40:00', 9, '2026-05-23 12:40:00', 0, NULL, 'wallet', 3);
INSERT INTO `revenue_records` VALUES (5, 5, 12, 16, 9.65, '2026-05-28 11:00:00', 43, '2026-05-28 11:00:00', 0, NULL, 'wechat', 29);
INSERT INTO `revenue_records` VALUES (6, 5, 13, 16, 9.65, '2026-05-28 11:00:00', 44, '2026-05-28 11:00:00', 0, NULL, 'wechat', 29);
INSERT INTO `revenue_records` VALUES (7, 5, 5, 7, 9.97, '2026-05-02 11:05:00', 43, '2026-05-28 11:02:14', 0, NULL, 'alipay', 20);
INSERT INTO `revenue_records` VALUES (8, 5, 6, 7, 9.97, '2026-05-03 15:00:00', 43, '2026-05-28 11:02:14', 0, NULL, 'alipay', 20);
INSERT INTO `revenue_records` VALUES (9, 5, 7, 9, 14.27, '2026-05-04 11:30:00', 44, '2026-05-28 11:02:14', 0, NULL, 'wechat', 22);
INSERT INTO `revenue_records` VALUES (10, 5, 8, 10, 29.90, '2026-05-05 15:00:00', 43, '2026-05-28 11:02:14', 0, NULL, 'cash', 23);
INSERT INTO `revenue_records` VALUES (11, 5, 9, 11, 29.90, '2026-05-06 10:55:00', 44, '2026-05-28 11:02:14', 0, NULL, 'wechat', 24);
INSERT INTO `revenue_records` VALUES (12, 5, 10, 12, 9.97, '2026-05-07 10:30:00', 43, '2026-05-28 11:02:14', 0, NULL, 'wallet', 25);
INSERT INTO `revenue_records` VALUES (13, 5, 11, 13, 14.27, '2026-05-08 15:30:00', 44, '2026-05-28 11:02:14', 0, NULL, 'alipay', 26);
INSERT INTO `revenue_records` VALUES (14, 5, 15, 18, 9.97, '2026-05-09 11:30:00', 43, '2026-05-09 11:30:00', 0, NULL, 'wechat', 34);
INSERT INTO `revenue_records` VALUES (15, 5, 16, 19, 29.90, '2026-05-10 16:00:00', 44, '2026-05-10 16:00:00', 0, NULL, 'alipay', 35);
INSERT INTO `revenue_records` VALUES (16, 5, 17, 20, 14.27, '2026-05-11 10:30:00', 43, '2026-05-11 10:30:00', 0, NULL, 'wechat', 36);
INSERT INTO `revenue_records` VALUES (17, 5, 18, 21, 9.97, '2026-05-12 12:15:00', 44, '2026-05-12 12:15:00', 0, NULL, 'wallet', 37);
INSERT INTO `revenue_records` VALUES (18, 5, 19, 22, 24.90, '2026-05-13 17:30:00', 43, '2026-05-13 17:30:00', 0, NULL, 'wechat', 38);
INSERT INTO `revenue_records` VALUES (19, 5, 20, 23, 9.97, '2026-05-14 11:45:00', 44, '2026-05-14 11:45:00', 0, NULL, 'alipay', 39);
INSERT INTO `revenue_records` VALUES (20, 5, 21, 24, 28.50, '2026-05-15 15:00:00', 43, '2026-05-15 15:00:00', 0, NULL, 'wechat', 40);
INSERT INTO `revenue_records` VALUES (21, 5, 22, 25, 29.90, '2026-05-16 16:15:00', 44, '2026-05-16 16:15:00', 0, NULL, 'wechat', 41);
INSERT INTO `revenue_records` VALUES (22, 5, 23, 26, 29.90, '2026-05-17 10:45:00', 43, '2026-05-17 10:45:00', 0, NULL, 'cash', 42);
INSERT INTO `revenue_records` VALUES (23, 5, 24, 27, 9.97, '2026-05-18 11:15:00', 44, '2026-05-18 11:15:00', 0, NULL, 'wechat', 43);
INSERT INTO `revenue_records` VALUES (24, 5, 25, 28, 14.27, '2026-05-19 15:15:00', 43, '2026-05-19 15:15:00', 0, NULL, 'wechat', 44);
INSERT INTO `revenue_records` VALUES (25, 5, 26, 29, 24.90, '2026-05-20 12:45:00', 44, '2026-05-20 12:45:00', 0, NULL, 'alipay', 45);
INSERT INTO `revenue_records` VALUES (26, 5, 27, 30, 29.90, '2026-05-21 17:15:00', 43, '2026-05-21 17:15:00', 0, NULL, 'cash', 46);
INSERT INTO `revenue_records` VALUES (27, 5, 28, 31, 9.97, '2026-05-22 11:00:00', 44, '2026-05-22 11:00:00', 0, NULL, 'wechat', 47);
INSERT INTO `revenue_records` VALUES (28, 5, 29, 32, 29.90, '2026-05-23 14:30:00', 43, '2026-05-23 14:30:00', 0, NULL, 'wechat', 48);
INSERT INTO `revenue_records` VALUES (29, 5, 30, 33, 29.90, '2026-05-24 11:00:00', 44, '2026-05-24 11:00:00', 0, NULL, 'wechat', 34);
INSERT INTO `revenue_records` VALUES (30, 5, 31, 34, 24.90, '2026-05-25 15:30:00', 43, '2026-05-25 15:30:00', 0, NULL, 'alipay', 35);
INSERT INTO `revenue_records` VALUES (31, 5, 32, 35, 29.90, '2026-05-26 10:45:00', 44, '2026-05-26 10:45:00', 0, NULL, 'wechat', 36);
INSERT INTO `revenue_records` VALUES (32, 5, 33, 36, 29.90, '2026-05-27 11:30:00', 43, '2026-05-27 11:30:00', 0, NULL, 'wechat', 39);
INSERT INTO `revenue_records` VALUES (33, 5, 34, 37, 29.90, '2026-05-28 12:00:00', 44, '2026-05-28 12:00:00', 0, NULL, 'wechat', 40);
INSERT INTO `revenue_records` VALUES (34, 5, 35, 38, 29.90, '2026-05-29 16:00:00', 43, '2026-05-29 16:00:00', 0, NULL, 'wechat', 44);
INSERT INTO `revenue_records` VALUES (35, 5, 36, 39, 29.90, '2026-05-30 11:15:00', 44, '2026-05-30 11:15:00', 0, NULL, 'wallet', 37);
INSERT INTO `revenue_records` VALUES (36, 5, 37, 40, 24.90, '2026-05-31 15:00:00', 43, '2026-05-31 15:00:00', 0, NULL, 'wechat', 41);
INSERT INTO `revenue_records` VALUES (37, 5, 38, 41, 29.90, '2026-06-01 10:30:00', 44, '2026-06-01 10:30:00', 0, NULL, 'wechat', 43);
INSERT INTO `revenue_records` VALUES (38, 5, 39, 42, 24.90, '2026-06-01 11:00:00', 43, '2026-06-01 11:00:00', 0, NULL, 'wechat', 44);
INSERT INTO `revenue_records` VALUES (39, 5, 40, 43, 29.90, '2026-06-01 12:00:00', 44, '2026-06-01 12:00:00', 0, NULL, 'wechat', 34);
INSERT INTO `revenue_records` VALUES (40, 5, 41, 44, 14.27, '2026-06-02 11:30:00', 43, '2026-06-02 11:30:00', 0, NULL, 'wechat', 39);
INSERT INTO `revenue_records` VALUES (41, 5, 42, 45, 29.90, '2026-06-03 15:00:00', 44, '2026-06-03 15:00:00', 0, NULL, 'wechat', 40);
INSERT INTO `revenue_records` VALUES (42, 5, 43, 46, 9.97, '2026-06-04 12:30:00', 43, '2026-06-04 12:30:00', 0, NULL, 'alipay', 45);

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
-- Records of role_permissions
-- ----------------------------
INSERT INTO `role_permissions` VALUES (2, 0);
INSERT INTO `role_permissions` VALUES (2, 1);
INSERT INTO `role_permissions` VALUES (2, 2);
INSERT INTO `role_permissions` VALUES (2, 3);
INSERT INTO `role_permissions` VALUES (2, 4);
INSERT INTO `role_permissions` VALUES (2, 5);
INSERT INTO `role_permissions` VALUES (2, 6);
INSERT INTO `role_permissions` VALUES (2, 7);
INSERT INTO `role_permissions` VALUES (2, 8);
INSERT INTO `role_permissions` VALUES (2, 9);
INSERT INTO `role_permissions` VALUES (2, 10);
INSERT INTO `role_permissions` VALUES (2, 11);
INSERT INTO `role_permissions` VALUES (2, 12);
INSERT INTO `role_permissions` VALUES (2, 13);
INSERT INTO `role_permissions` VALUES (2, 14);
INSERT INTO `role_permissions` VALUES (2, 15);
INSERT INTO `role_permissions` VALUES (2, 16);
INSERT INTO `role_permissions` VALUES (2, 17);
INSERT INTO `role_permissions` VALUES (2, 18);
INSERT INTO `role_permissions` VALUES (2, 19);
INSERT INTO `role_permissions` VALUES (2, 20);
INSERT INTO `role_permissions` VALUES (2, 21);
INSERT INTO `role_permissions` VALUES (2, 22);
INSERT INTO `role_permissions` VALUES (2, 23);
INSERT INTO `role_permissions` VALUES (2, 24);
INSERT INTO `role_permissions` VALUES (2, 25);
INSERT INTO `role_permissions` VALUES (2, 26);
INSERT INTO `role_permissions` VALUES (2, 27);
INSERT INTO `role_permissions` VALUES (2, 28);
INSERT INTO `role_permissions` VALUES (2, 29);
INSERT INTO `role_permissions` VALUES (2, 30);
INSERT INTO `role_permissions` VALUES (2, 31);
INSERT INTO `role_permissions` VALUES (2, 33);
INSERT INTO `role_permissions` VALUES (2, 34);
INSERT INTO `role_permissions` VALUES (2, 36);
INSERT INTO `role_permissions` VALUES (2, 37);
INSERT INTO `role_permissions` VALUES (2, 101);
INSERT INTO `role_permissions` VALUES (2, 102);
INSERT INTO `role_permissions` VALUES (2, 103);
INSERT INTO `role_permissions` VALUES (2, 104);
INSERT INTO `role_permissions` VALUES (2, 105);
INSERT INTO `role_permissions` VALUES (2, 106);
INSERT INTO `role_permissions` VALUES (2, 107);
INSERT INTO `role_permissions` VALUES (2, 108);
INSERT INTO `role_permissions` VALUES (2, 109);
INSERT INTO `role_permissions` VALUES (2, 110);
INSERT INTO `role_permissions` VALUES (2, 111);
INSERT INTO `role_permissions` VALUES (2, 112);
INSERT INTO `role_permissions` VALUES (2, 113);
INSERT INTO `role_permissions` VALUES (2, 114);
INSERT INTO `role_permissions` VALUES (2, 115);
INSERT INTO `role_permissions` VALUES (2, 116);
INSERT INTO `role_permissions` VALUES (2, 117);
INSERT INTO `role_permissions` VALUES (2, 118);
INSERT INTO `role_permissions` VALUES (2, 119);
INSERT INTO `role_permissions` VALUES (2, 120);
INSERT INTO `role_permissions` VALUES (2, 121);
INSERT INTO `role_permissions` VALUES (2, 122);
INSERT INTO `role_permissions` VALUES (2, 123);
INSERT INTO `role_permissions` VALUES (2, 124);
INSERT INTO `role_permissions` VALUES (2, 125);
INSERT INTO `role_permissions` VALUES (2, 126);
INSERT INTO `role_permissions` VALUES (2, 127);
INSERT INTO `role_permissions` VALUES (2, 128);
INSERT INTO `role_permissions` VALUES (2, 129);
INSERT INTO `role_permissions` VALUES (2, 130);
INSERT INTO `role_permissions` VALUES (2, 131);
INSERT INTO `role_permissions` VALUES (2, 132);
INSERT INTO `role_permissions` VALUES (2, 133);
INSERT INTO `role_permissions` VALUES (2, 134);
INSERT INTO `role_permissions` VALUES (2, 135);
INSERT INTO `role_permissions` VALUES (2, 136);
INSERT INTO `role_permissions` VALUES (2, 137);
INSERT INTO `role_permissions` VALUES (2, 138);
INSERT INTO `role_permissions` VALUES (2, 139);
INSERT INTO `role_permissions` VALUES (2, 140);
INSERT INTO `role_permissions` VALUES (2, 141);
INSERT INTO `role_permissions` VALUES (2, 142);
INSERT INTO `role_permissions` VALUES (2, 143);
INSERT INTO `role_permissions` VALUES (2, 144);
INSERT INTO `role_permissions` VALUES (2, 145);
INSERT INTO `role_permissions` VALUES (2, 146);
INSERT INTO `role_permissions` VALUES (2, 147);
INSERT INTO `role_permissions` VALUES (2, 148);
INSERT INTO `role_permissions` VALUES (2, 149);
INSERT INTO `role_permissions` VALUES (2, 150);
INSERT INTO `role_permissions` VALUES (2, 151);
INSERT INTO `role_permissions` VALUES (2, 152);
INSERT INTO `role_permissions` VALUES (2, 153);
INSERT INTO `role_permissions` VALUES (2, 154);
INSERT INTO `role_permissions` VALUES (2, 155);
INSERT INTO `role_permissions` VALUES (2, 156);
INSERT INTO `role_permissions` VALUES (2, 157);
INSERT INTO `role_permissions` VALUES (2, 158);
INSERT INTO `role_permissions` VALUES (2, 159);
INSERT INTO `role_permissions` VALUES (2, 160);
INSERT INTO `role_permissions` VALUES (2, 161);
INSERT INTO `role_permissions` VALUES (2, 162);
INSERT INTO `role_permissions` VALUES (2, 163);
INSERT INTO `role_permissions` VALUES (2, 164);
INSERT INTO `role_permissions` VALUES (2, 165);
INSERT INTO `role_permissions` VALUES (2, 166);
INSERT INTO `role_permissions` VALUES (2, 167);
INSERT INTO `role_permissions` VALUES (3, 0);
INSERT INTO `role_permissions` VALUES (3, 1);
INSERT INTO `role_permissions` VALUES (3, 3);
INSERT INTO `role_permissions` VALUES (3, 4);
INSERT INTO `role_permissions` VALUES (3, 5);
INSERT INTO `role_permissions` VALUES (3, 6);
INSERT INTO `role_permissions` VALUES (3, 7);
INSERT INTO `role_permissions` VALUES (3, 8);
INSERT INTO `role_permissions` VALUES (3, 9);
INSERT INTO `role_permissions` VALUES (3, 10);
INSERT INTO `role_permissions` VALUES (3, 11);
INSERT INTO `role_permissions` VALUES (3, 18);
INSERT INTO `role_permissions` VALUES (3, 19);
INSERT INTO `role_permissions` VALUES (3, 20);
INSERT INTO `role_permissions` VALUES (3, 21);
INSERT INTO `role_permissions` VALUES (3, 22);
INSERT INTO `role_permissions` VALUES (3, 23);
INSERT INTO `role_permissions` VALUES (3, 24);
INSERT INTO `role_permissions` VALUES (3, 25);
INSERT INTO `role_permissions` VALUES (3, 26);
INSERT INTO `role_permissions` VALUES (3, 27);
INSERT INTO `role_permissions` VALUES (3, 28);
INSERT INTO `role_permissions` VALUES (3, 29);
INSERT INTO `role_permissions` VALUES (3, 30);
INSERT INTO `role_permissions` VALUES (3, 31);
INSERT INTO `role_permissions` VALUES (3, 33);
INSERT INTO `role_permissions` VALUES (3, 34);
INSERT INTO `role_permissions` VALUES (3, 36);
INSERT INTO `role_permissions` VALUES (3, 37);
INSERT INTO `role_permissions` VALUES (3, 101);
INSERT INTO `role_permissions` VALUES (3, 102);
INSERT INTO `role_permissions` VALUES (3, 103);
INSERT INTO `role_permissions` VALUES (3, 104);
INSERT INTO `role_permissions` VALUES (3, 108);
INSERT INTO `role_permissions` VALUES (3, 109);
INSERT INTO `role_permissions` VALUES (3, 121);
INSERT INTO `role_permissions` VALUES (3, 122);
INSERT INTO `role_permissions` VALUES (3, 123);
INSERT INTO `role_permissions` VALUES (3, 124);
INSERT INTO `role_permissions` VALUES (3, 125);
INSERT INTO `role_permissions` VALUES (3, 126);
INSERT INTO `role_permissions` VALUES (3, 127);
INSERT INTO `role_permissions` VALUES (3, 128);
INSERT INTO `role_permissions` VALUES (3, 129);
INSERT INTO `role_permissions` VALUES (3, 130);
INSERT INTO `role_permissions` VALUES (3, 131);
INSERT INTO `role_permissions` VALUES (3, 132);
INSERT INTO `role_permissions` VALUES (3, 133);
INSERT INTO `role_permissions` VALUES (3, 134);
INSERT INTO `role_permissions` VALUES (3, 135);
INSERT INTO `role_permissions` VALUES (3, 136);
INSERT INTO `role_permissions` VALUES (3, 137);
INSERT INTO `role_permissions` VALUES (3, 138);
INSERT INTO `role_permissions` VALUES (3, 139);
INSERT INTO `role_permissions` VALUES (3, 140);
INSERT INTO `role_permissions` VALUES (3, 141);
INSERT INTO `role_permissions` VALUES (3, 142);
INSERT INTO `role_permissions` VALUES (3, 143);
INSERT INTO `role_permissions` VALUES (3, 144);
INSERT INTO `role_permissions` VALUES (3, 145);
INSERT INTO `role_permissions` VALUES (3, 146);
INSERT INTO `role_permissions` VALUES (3, 147);
INSERT INTO `role_permissions` VALUES (3, 148);
INSERT INTO `role_permissions` VALUES (3, 149);
INSERT INTO `role_permissions` VALUES (3, 150);
INSERT INTO `role_permissions` VALUES (3, 151);
INSERT INTO `role_permissions` VALUES (3, 152);
INSERT INTO `role_permissions` VALUES (3, 153);
INSERT INTO `role_permissions` VALUES (3, 154);
INSERT INTO `role_permissions` VALUES (3, 155);
INSERT INTO `role_permissions` VALUES (3, 156);
INSERT INTO `role_permissions` VALUES (3, 157);
INSERT INTO `role_permissions` VALUES (3, 158);
INSERT INTO `role_permissions` VALUES (3, 159);
INSERT INTO `role_permissions` VALUES (3, 160);
INSERT INTO `role_permissions` VALUES (3, 161);
INSERT INTO `role_permissions` VALUES (3, 162);
INSERT INTO `role_permissions` VALUES (3, 163);
INSERT INTO `role_permissions` VALUES (3, 164);
INSERT INTO `role_permissions` VALUES (3, 165);
INSERT INTO `role_permissions` VALUES (3, 166);
INSERT INTO `role_permissions` VALUES (4, 0);
INSERT INTO `role_permissions` VALUES (4, 4);
INSERT INTO `role_permissions` VALUES (4, 6);
INSERT INTO `role_permissions` VALUES (4, 8);
INSERT INTO `role_permissions` VALUES (4, 10);
INSERT INTO `role_permissions` VALUES (4, 18);
INSERT INTO `role_permissions` VALUES (4, 20);
INSERT INTO `role_permissions` VALUES (4, 21);
INSERT INTO `role_permissions` VALUES (4, 27);
INSERT INTO `role_permissions` VALUES (4, 121);
INSERT INTO `role_permissions` VALUES (4, 122);
INSERT INTO `role_permissions` VALUES (4, 123);
INSERT INTO `role_permissions` VALUES (4, 124);
INSERT INTO `role_permissions` VALUES (4, 128);
INSERT INTO `role_permissions` VALUES (4, 129);
INSERT INTO `role_permissions` VALUES (4, 130);
INSERT INTO `role_permissions` VALUES (4, 131);
INSERT INTO `role_permissions` VALUES (4, 144);
INSERT INTO `role_permissions` VALUES (4, 145);
INSERT INTO `role_permissions` VALUES (4, 146);
INSERT INTO `role_permissions` VALUES (4, 152);
INSERT INTO `role_permissions` VALUES (4, 165);
INSERT INTO `role_permissions` VALUES (5, 0);
INSERT INTO `role_permissions` VALUES (5, 7);
INSERT INTO `role_permissions` VALUES (5, 10);
INSERT INTO `role_permissions` VALUES (5, 23);
INSERT INTO `role_permissions` VALUES (5, 24);
INSERT INTO `role_permissions` VALUES (5, 25);
INSERT INTO `role_permissions` VALUES (5, 34);
INSERT INTO `role_permissions` VALUES (5, 134);
INSERT INTO `role_permissions` VALUES (5, 135);
INSERT INTO `role_permissions` VALUES (5, 136);
INSERT INTO `role_permissions` VALUES (5, 137);
INSERT INTO `role_permissions` VALUES (5, 138);
INSERT INTO `role_permissions` VALUES (5, 139);
INSERT INTO `role_permissions` VALUES (5, 140);
INSERT INTO `role_permissions` VALUES (5, 154);
INSERT INTO `role_permissions` VALUES (5, 155);
INSERT INTO `role_permissions` VALUES (5, 159);
INSERT INTO `role_permissions` VALUES (5, 160);
INSERT INTO `role_permissions` VALUES (5, 161);
INSERT INTO `role_permissions` VALUES (5, 162);
INSERT INTO `role_permissions` VALUES (5, 163);
INSERT INTO `role_permissions` VALUES (6, 0);
INSERT INTO `role_permissions` VALUES (6, 6);
INSERT INTO `role_permissions` VALUES (6, 9);
INSERT INTO `role_permissions` VALUES (6, 10);
INSERT INTO `role_permissions` VALUES (6, 22);
INSERT INTO `role_permissions` VALUES (6, 28);
INSERT INTO `role_permissions` VALUES (6, 29);
INSERT INTO `role_permissions` VALUES (6, 30);
INSERT INTO `role_permissions` VALUES (6, 31);
INSERT INTO `role_permissions` VALUES (6, 33);
INSERT INTO `role_permissions` VALUES (6, 37);
INSERT INTO `role_permissions` VALUES (6, 132);
INSERT INTO `role_permissions` VALUES (6, 133);
INSERT INTO `role_permissions` VALUES (6, 147);
INSERT INTO `role_permissions` VALUES (6, 148);
INSERT INTO `role_permissions` VALUES (6, 149);
INSERT INTO `role_permissions` VALUES (6, 150);
INSERT INTO `role_permissions` VALUES (6, 151);

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
-- Records of roles
-- ----------------------------
INSERT INTO `roles` VALUES (2, 0, '超级管理员', '超级管理员（处理商户、席位订阅、全局字典等功能）', '2026-05-08 14:09:47');
INSERT INTO `roles` VALUES (3, 0, '店长', '店长', '2026-05-08 16:52:14');
INSERT INTO `roles` VALUES (4, 0, '导玩员', '导玩员', '2026-05-08 16:52:14');
INSERT INTO `roles` VALUES (5, 0, '仓管', '仓管', '2026-05-08 16:52:14');
INSERT INTO `roles` VALUES (6, 0, '财务', '财务', '2026-05-08 16:52:14');

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
-- Records of seat_subscriptions
-- ----------------------------
INSERT INTO `seat_subscriptions` VALUES (4, 'SEAT-000004', 9, '2026-05-15', '2028-06-08', 1, NULL, '2026-05-15 13:47:30', '2026-05-15 15:42:22');
INSERT INTO `seat_subscriptions` VALUES (5, 'SEAT-000005', 9, '2026-05-15', '2026-10-27', 1, NULL, '2026-05-15 14:31:49', '2026-05-15 15:27:08');
INSERT INTO `seat_subscriptions` VALUES (6, 'SEAT-000010', 10, '2025-06-01', '2027-06-01', 1, NULL, '2025-06-01 10:00:00', '2026-05-15 16:55:49');
INSERT INTO `seat_subscriptions` VALUES (7, 'SEAT-000011', 11, '2025-06-15', '2026-06-15', 1, NULL, '2025-06-15 10:00:00', '2026-05-15 16:55:49');
INSERT INTO `seat_subscriptions` VALUES (8, 'SEAT-000012', 12, '2025-07-01', '2026-07-01', 1, NULL, '2025-07-01 10:00:00', '2026-05-15 16:55:49');
INSERT INTO `seat_subscriptions` VALUES (9, 'SEAT-000013', 13, '2025-08-01', '2027-08-01', 1, NULL, '2025-08-01 10:00:00', '2026-05-15 16:55:49');
INSERT INTO `seat_subscriptions` VALUES (10, 'SEAT-000014', 14, '2025-08-10', '2026-08-10', 1, NULL, '2025-08-10 10:00:00', '2026-05-15 16:55:49');
INSERT INTO `seat_subscriptions` VALUES (11, 'SEAT-000015', 15, '2025-08-20', '2026-05-20', 2, NULL, '2025-08-20 10:00:00', '2026-05-15 16:55:49');
INSERT INTO `seat_subscriptions` VALUES (12, 'SEAT-000016', 16, '2025-09-01', '2026-09-01', 1, NULL, '2025-09-01 10:00:00', '2026-05-15 16:55:49');
INSERT INTO `seat_subscriptions` VALUES (13, 'SEAT-000017', 17, '2025-09-15', '2027-09-15', 1, NULL, '2025-09-15 10:00:00', '2026-05-15 16:55:49');
INSERT INTO `seat_subscriptions` VALUES (14, 'SEAT-000018', 10, '2025-10-01', '2026-10-01', 1, NULL, '2025-10-01 10:00:00', '2026-05-15 16:55:49');
INSERT INTO `seat_subscriptions` VALUES (15, 'SEAT-000019', 11, '2025-11-01', '2026-11-01', 1, NULL, '2025-11-01 10:00:00', '2026-05-15 16:55:49');
INSERT INTO `seat_subscriptions` VALUES (16, 'SEAT-000020', 12, '2025-11-15', '2026-11-15', 1, NULL, '2025-11-15 10:00:00', '2026-05-15 16:55:49');
INSERT INTO `seat_subscriptions` VALUES (17, 'SEAT-000021', 13, '2025-12-01', '2027-12-01', 1, NULL, '2025-12-01 10:00:00', '2026-05-15 16:55:49');
INSERT INTO `seat_subscriptions` VALUES (18, 'SEAT-000022', 14, '2026-01-01', '2027-01-01', 1, NULL, '2026-01-01 10:00:00', '2026-05-15 16:55:49');
INSERT INTO `seat_subscriptions` VALUES (19, 'SEAT-000023', 15, '2026-01-10', '2026-07-10', 1, NULL, '2026-01-10 10:00:00', '2026-05-15 16:55:49');
INSERT INTO `seat_subscriptions` VALUES (20, 'SEAT-000024', 16, '2026-01-20', '2026-07-20', 1, NULL, '2026-01-20 10:00:00', '2026-05-15 16:55:49');
INSERT INTO `seat_subscriptions` VALUES (21, 'SEAT-000025', 17, '2026-02-01', '2028-02-01', 1, NULL, '2026-02-01 10:00:00', '2026-05-15 16:55:49');
INSERT INTO `seat_subscriptions` VALUES (22, 'SEAT-000026', 10, '2026-02-15', '2027-02-15', 1, NULL, '2026-02-15 10:00:00', '2026-05-15 16:55:49');
INSERT INTO `seat_subscriptions` VALUES (23, 'SEAT-000027', 11, '2026-03-01', '2026-09-01', 1, NULL, '2026-03-01 10:00:00', '2026-05-15 16:55:49');
INSERT INTO `seat_subscriptions` VALUES (24, 'SEAT-000028', 12, '2026-04-01', '2027-04-01', 1, NULL, '2026-04-01 10:00:00', '2026-05-15 16:55:49');
INSERT INTO `seat_subscriptions` VALUES (25, 'SEAT-000029', 13, '2026-04-15', '2026-06-15', 1, NULL, '2026-04-15 10:00:00', '2026-05-15 16:55:49');
INSERT INTO `seat_subscriptions` VALUES (26, 'SEAT-000030', 14, '2026-05-01', '2028-05-01', 1, NULL, '2026-05-01 10:00:00', '2026-05-15 16:55:49');
INSERT INTO `seat_subscriptions` VALUES (27, 'SEAT-000031', 15, '2026-05-10', '2026-06-10', 2, NULL, '2026-05-10 10:00:00', '2026-06-11 05:38:00');
INSERT INTO `seat_subscriptions` VALUES (28, 'SEAT-000032', 10, '2026-05-15', '2026-06-20', 1, NULL, '2026-05-15 10:00:00', '2026-05-15 16:55:49');
INSERT INTO `seat_subscriptions` VALUES (29, 'SEAT-000033', 15, '2026-01-01', '2026-05-20', 2, NULL, '2026-01-01 10:00:00', '2026-05-21 07:46:02');
INSERT INTO `seat_subscriptions` VALUES (30, 'SEAT-000034', 16, '2026-02-01', '2026-05-22', 2, NULL, '2026-02-01 10:00:00', '2026-05-23 03:10:08');
INSERT INTO `seat_subscriptions` VALUES (31, 'SEAT-000035', 17, '2026-01-15', '2026-06-10', 2, NULL, '2026-01-15 10:00:00', '2026-06-11 05:38:00');
INSERT INTO `seat_subscriptions` VALUES (32, 'SEAT-000036', 12, '2025-10-01', '2026-06-30', 1, NULL, '2025-10-01 10:00:00', '2026-05-15 16:58:41');
INSERT INTO `seat_subscriptions` VALUES (33, 'SEAT-000037', 14, '2025-11-01', '2026-07-15', 1, NULL, '2025-11-01 10:00:00', '2026-05-15 16:58:41');
INSERT INTO `seat_subscriptions` VALUES (34, 'SEAT-000038', 10, '2025-09-01', '2026-06-25', 1, NULL, '2025-09-01 10:00:00', '2026-05-15 16:58:41');

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
-- Records of seat_subscriptions_transactions
-- ----------------------------
INSERT INTO `seat_subscriptions_transactions` VALUES (1, 4, 1200.00, 'wechat', NULL, 2, 1, 1, NULL, NULL, '2026-05-15 13:47:30');
INSERT INTO `seat_subscriptions_transactions` VALUES (2, 5, 1000.00, 'wechat', NULL, 2, 1, 2, 500.00, 200, '2026-05-15 14:31:49');
INSERT INTO `seat_subscriptions_transactions` VALUES (3, 4, 100.00, 'cash', NULL, 1, 1, 1, NULL, NULL, '2026-05-15 14:53:22');
INSERT INTO `seat_subscriptions_transactions` VALUES (4, 4, 1200.00, 'bank', NULL, 1, 12, 1, NULL, NULL, '2026-05-15 15:42:22');
INSERT INTO `seat_subscriptions_transactions` VALUES (5, 6, 2400.00, 'wechat', NULL, 2, 1, 1, NULL, NULL, '2025-06-01 10:30:00');
INSERT INTO `seat_subscriptions_transactions` VALUES (6, 7, 300.00, 'alipay', NULL, 1, 1, 1, NULL, NULL, '2025-06-15 11:00:00');
INSERT INTO `seat_subscriptions_transactions` VALUES (7, 8, 280.00, 'bank', NULL, 1, 1, 1, NULL, NULL, '2025-07-01 10:00:00');
INSERT INTO `seat_subscriptions_transactions` VALUES (8, 9, 3600.00, 'wechat', NULL, 2, 1, 1, NULL, NULL, '2025-08-01 09:00:00');
INSERT INTO `seat_subscriptions_transactions` VALUES (9, 10, 350.00, 'cash', NULL, 1, 1, 1, NULL, NULL, '2025-08-10 14:00:00');
INSERT INTO `seat_subscriptions_transactions` VALUES (10, 11, 200.00, 'wechat', NULL, 1, 1, 2, 150.00, NULL, '2025-08-20 16:00:00');
INSERT INTO `seat_subscriptions_transactions` VALUES (11, 12, 320.00, 'alipay', NULL, 1, 1, 1, NULL, NULL, '2025-09-01 10:00:00');
INSERT INTO `seat_subscriptions_transactions` VALUES (12, 13, 4800.00, 'bank', NULL, 2, 1, 1, NULL, NULL, '2025-09-15 09:00:00');
INSERT INTO `seat_subscriptions_transactions` VALUES (13, 14, 260.00, 'wechat', NULL, 1, 1, 1, NULL, NULL, '2025-10-01 11:00:00');
INSERT INTO `seat_subscriptions_transactions` VALUES (14, 15, 400.00, 'alipay', NULL, 1, 1, 1, NULL, NULL, '2025-11-01 10:00:00');
INSERT INTO `seat_subscriptions_transactions` VALUES (15, 16, 500.00, 'wechat', NULL, 1, 2, 1, NULL, NULL, '2025-11-15 14:00:00');
INSERT INTO `seat_subscriptions_transactions` VALUES (16, 17, 3000.00, 'bank', NULL, 2, 1, 1, NULL, NULL, '2025-12-01 10:00:00');
INSERT INTO `seat_subscriptions_transactions` VALUES (17, 18, 2200.00, 'wechat', NULL, 2, 1, 1, NULL, NULL, '2026-01-01 09:30:00');
INSERT INTO `seat_subscriptions_transactions` VALUES (18, 19, 450.00, 'cash', NULL, 1, 1, 1, NULL, NULL, '2026-01-10 15:00:00');
INSERT INTO `seat_subscriptions_transactions` VALUES (19, 20, 420.00, 'alipay', NULL, 1, 1, 2, 300.00, NULL, '2026-01-20 13:00:00');
INSERT INTO `seat_subscriptions_transactions` VALUES (20, 21, 5200.00, 'wechat', NULL, 2, 1, 1, NULL, NULL, '2026-02-01 10:00:00');
INSERT INTO `seat_subscriptions_transactions` VALUES (21, 22, 1800.00, 'bank', NULL, 2, 1, 1, NULL, NULL, '2026-02-15 11:00:00');
INSERT INTO `seat_subscriptions_transactions` VALUES (22, 23, 380.00, 'wechat', NULL, 1, 1, 1, NULL, NULL, '2026-03-01 10:00:00');
INSERT INTO `seat_subscriptions_transactions` VALUES (23, 24, 2500.00, 'alipay', NULL, 2, 1, 1, NULL, NULL, '2026-04-01 09:00:00');
INSERT INTO `seat_subscriptions_transactions` VALUES (24, 25, 150.00, 'cash', NULL, 1, 1, 1, NULL, NULL, '2026-04-15 14:00:00');
INSERT INTO `seat_subscriptions_transactions` VALUES (25, 26, 3600.00, 'wechat', NULL, 2, 1, 1, NULL, NULL, '2026-05-01 08:00:00');
INSERT INTO `seat_subscriptions_transactions` VALUES (26, 27, 200.00, 'alipay', NULL, 1, 1, 1, NULL, NULL, '2026-05-10 12:00:00');
INSERT INTO `seat_subscriptions_transactions` VALUES (27, 28, 120.00, 'wechat', NULL, 1, 1, 2, 100.00, NULL, '2026-05-15 10:00:00');

-- ----------------------------
-- Table structure for shop_faqs
-- ----------------------------
DROP TABLE IF EXISTS `shop_faqs`;
CREATE TABLE `shop_faqs`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `shop_id` bigint UNSIGNED NOT NULL COMMENT '店铺ID',
  `question` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '问题',
  `answer` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '回答',
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'general' COMMENT '分类(general/pricing/refund/rules)',
  `sort_order` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '排序',
  `is_active` tinyint UNSIGNED NOT NULL DEFAULT 1 COMMENT '是否启用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_shop_id`(`shop_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '店铺常见问题表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of shop_faqs
-- ----------------------------
INSERT INTO `shop_faqs` VALUES (1, 5, '你们的营业时间是什么？', '我们周一至周日营业，时间为9:00-21:00。', 'general', 0, 1, '2026-05-29 10:00:57', '2026-05-29 10:00:57');
INSERT INTO `shop_faqs` VALUES (2, 5, '可以退款吗？', '购买后7天内未使用可申请全额退款。', 'refund', 0, 1, '2026-05-29 10:00:57', '2026-05-29 10:00:57');
INSERT INTO `shop_faqs` VALUES (3, 5, '儿童有年龄限制吗？', '适合3-12岁儿童，需家长陪同。', 'rules', 0, 1, '2026-05-29 10:00:57', '2026-05-29 10:00:57');
INSERT INTO `shop_faqs` VALUES (4, 5, '周卡多少钱？', '周卡价格为298元，有效期7天，不限次数。', 'pricing', 0, 1, '2026-05-29 10:00:57', '2026-05-29 10:00:57');
INSERT INTO `shop_faqs` VALUES (5, 5, '月卡包含什么？', '月卡价格698元，有效期30天，不限次数，生日当天免费。', 'pricing', 0, 1, '2026-05-29 10:00:57', '2026-05-29 10:00:57');

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
  `open_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '09:00' COMMENT '营业开始时间',
  `close_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '21:00' COMMENT '营业结束时间',
  `business_days` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '1,2,3,4,5,6,7' COMMENT '营业日(1-7对应周一到周日)',
  `sign_photo` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '门头照片',
  `logo` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '店铺Logo路径',
  `mp_qrcode_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '小程序太阳码路径',
  `is_deleted` tinyint UNSIGNED NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_time` datetime NULL DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_owner_staff`(`owner_staff_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 28 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '店铺表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of shops
-- ----------------------------
INSERT INTO `shops` VALUES (5, 9, 5, '乔乔DIY手工店', '嘉善县万联城3楼', '17857093301', 20, 1, NULL, '09:00', '21:00', '1,2,3,4,5,6,7', '5/shop/20260525130822219_1247216622.jpeg', '5/shop/20260526145255957_505462149.png', '5/qrcode.png', 0, '2026-05-15 14:34:30', '2026-05-26 14:52:59', NULL);
INSERT INTO `shops` VALUES (6, 9, 4, '翔达手工', '银泰3楼', '0573-8712345', 20, 0, '翔达手工', '09:00', '21:00', '1,2,3,4,5,6,7', NULL, NULL, NULL, 0, '2026-05-15 14:38:51', '2026-05-15 14:41:46', NULL);
INSERT INTO `shops` VALUES (7, 10, 6, '阳光手工坊', '杭州市西湖区文三路100号', '13800010001', 30, 1, NULL, '09:00', '21:00', '1,2,3,4,5,6,7', NULL, NULL, NULL, 0, '2025-06-05 10:00:00', '2026-05-15 16:57:00', NULL);
INSERT INTO `shops` VALUES (8, 11, 7, '创意DIY工作室', '上海市浦东新区世纪大道200号', '13800010002', 25, 1, NULL, '09:00', '21:00', '1,2,3,4,5,6,7', NULL, NULL, NULL, 0, '2025-06-20 10:00:00', '2026-05-15 16:57:00', NULL);
INSERT INTO `shops` VALUES (9, 12, 8, '快乐童年游乐馆', '北京市朝阳区三里屯路50号', '13800010003', 40, 1, NULL, '09:00', '21:00', '1,2,3,4,5,6,7', NULL, NULL, NULL, 0, '2025-07-05 10:00:00', '2026-05-15 16:57:00', NULL);
INSERT INTO `shops` VALUES (10, 13, 9, '梦想手工体验馆', '深圳市南山区科技园路88号', '13800010004', 35, 1, NULL, '09:00', '21:00', '1,2,3,4,5,6,7', NULL, NULL, NULL, 0, '2025-08-05 10:00:00', '2026-05-15 16:57:00', NULL);
INSERT INTO `shops` VALUES (11, 14, 10, '亲子时光乐园', '广州市天河区体育西路120号', '13800010005', 50, 1, NULL, '09:00', '21:00', '1,2,3,4,5,6,7', NULL, NULL, NULL, 0, '2025-08-15 10:00:00', '2026-05-15 16:57:00', NULL);
INSERT INTO `shops` VALUES (12, 15, 14, '匠心手工社', '成都市武侯区人民南路60号', '13800010006', 20, 0, NULL, '09:00', '21:00', '1,2,3,4,5,6,7', NULL, NULL, NULL, 0, '2025-10-05 10:00:00', '2026-05-15 16:57:00', NULL);
INSERT INTO `shops` VALUES (13, 16, 12, '陶艺小站', '武汉市洪山区珞喻路150号', '13800010007', 15, 1, NULL, '09:00', '21:00', '1,2,3,4,5,6,7', NULL, NULL, NULL, 0, '2025-09-10 10:00:00', '2026-05-15 16:57:00', NULL);
INSERT INTO `shops` VALUES (14, 17, 13, '手工皂坊', '南京市鼓楼区中山北路80号', '13800010008', 22, 1, NULL, '09:00', '21:00', '1,2,3,4,5,6,7', NULL, NULL, NULL, 0, '2025-09-20 10:00:00', '2026-05-15 16:57:00', NULL);
INSERT INTO `shops` VALUES (15, 10, 18, '织梦编织屋', '杭州市拱墅区湖墅南路30号', '13800010009', 18, 1, NULL, '09:00', '21:00', '1,2,3,4,5,6,7', NULL, NULL, NULL, 0, '2025-10-10 10:00:00', '2026-05-15 16:57:00', NULL);
INSERT INTO `shops` VALUES (16, 11, 19, '七彩画室', '上海市徐汇区衡山路40号', '13800010010', 28, 1, NULL, '09:00', '21:00', '1,2,3,4,5,6,7', NULL, NULL, NULL, 0, '2025-11-05 10:00:00', '2026-05-15 16:57:00', NULL);
INSERT INTO `shops` VALUES (17, 12, 20, '小小木工坊', '北京市海淀区中关村大街15号', '13800010011', 20, 1, NULL, '09:00', '21:00', '1,2,3,4,5,6,7', NULL, NULL, NULL, 0, '2025-11-20 10:00:00', '2026-05-15 16:57:00', NULL);
INSERT INTO `shops` VALUES (18, 13, 21, '插花艺术馆', '深圳市福田区华强北路22号', '13800010012', 25, 1, NULL, '09:00', '21:00', '1,2,3,4,5,6,7', NULL, NULL, NULL, 0, '2025-12-10 10:00:00', '2026-05-15 16:57:00', NULL);
INSERT INTO `shops` VALUES (19, 14, 22, '烘焙体验中心', '广州市越秀区北京路66号', '13800010013', 32, 1, NULL, '09:00', '21:00', '1,2,3,4,5,6,7', NULL, NULL, NULL, 0, '2026-01-10 10:00:00', '2026-05-15 16:57:00', NULL);
INSERT INTO `shops` VALUES (20, 15, 23, '毛绒玩具DIY', '成都市锦江区春熙路88号', '13800010014', 20, 1, NULL, '09:00', '21:00', '1,2,3,4,5,6,7', NULL, NULL, NULL, 0, '2026-01-15 10:00:00', '2026-05-15 16:57:00', NULL);
INSERT INTO `shops` VALUES (21, 16, 24, '拼豆乐园', '武汉市武昌区中南路20号', '13800010015', 18, 1, NULL, '09:00', '21:00', '1,2,3,4,5,6,7', NULL, NULL, NULL, 0, '2026-01-25 10:00:00', '2026-05-15 16:57:00', NULL);
INSERT INTO `shops` VALUES (22, 17, 25, '乐高创意中心', '南京市秦淮区夫子庙路10号', '13800010016', 40, 1, NULL, '09:00', '21:00', '1,2,3,4,5,6,7', NULL, NULL, NULL, 0, '2026-02-05 10:00:00', '2026-05-15 16:57:00', NULL);
INSERT INTO `shops` VALUES (23, 10, 26, '奶油胶工坊', '杭州市滨江区江南大道55号', '13800010017', 16, 1, NULL, '09:00', '21:00', '1,2,3,4,5,6,7', NULL, NULL, NULL, 0, '2026-02-20 10:00:00', '2026-05-15 16:57:00', NULL);
INSERT INTO `shops` VALUES (24, 11, 27, '水彩体验馆', '上海市静安区南京西路18号', '13800010018', 22, 1, NULL, '09:00', '21:00', '1,2,3,4,5,6,7', NULL, NULL, NULL, 0, '2026-03-05 10:00:00', '2026-05-15 16:57:00', NULL);
INSERT INTO `shops` VALUES (25, 12, 28, '掐丝珐琅坊', '北京市东城区王府井大街30号', '13800010019', 20, 1, NULL, '09:00', '21:00', '1,2,3,4,5,6,7', NULL, NULL, NULL, 0, '2026-04-10 10:00:00', '2026-05-15 16:57:00', NULL);
INSERT INTO `shops` VALUES (26, 13, 29, '掐丝珐琅坊分店', '深圳市宝安区新安路15号', '13800010020', 18, 1, NULL, '09:00', '21:00', '1,2,3,4,5,6,7', NULL, NULL, NULL, 0, '2026-04-20 10:00:00', '2026-05-15 16:57:00', NULL);
INSERT INTO `shops` VALUES (27, 14, 30, '皮具体验馆', '广州市荔湾区上下九路12号', '13800010021', 28, 1, NULL, '09:00', '21:00', '1,2,3,4,5,6,7', NULL, NULL, NULL, 0, '2026-05-05 10:00:00', '2026-05-15 16:57:00', NULL);

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
-- Records of staff
-- ----------------------------
INSERT INTO `staff` VALUES (5, 1, '管理员Test', '13800138000', NULL, NULL, NULL, 1, 999, 0, NULL, 1, 0, 0, '2026-05-12 10:59:02', '2026-05-25 14:33:50', NULL);
INSERT INTO `staff` VALUES (6, 1, '张三', '17857093301', NULL, NULL, NULL, 1, 1, 0, NULL, 1, 0, 1, '2026-05-14 16:27:54', '2026-05-14 16:50:14', NULL);
INSERT INTO `staff` VALUES (9, 1, '张三', '17857093303', NULL, NULL, '5/avatar/20260525130839041_129390012.png', 1, 14, 2, 'zhangsan；zhangsan123', 1, 0, 0, '2026-05-15 08:56:53', '2026-06-13 08:41:58', NULL);
INSERT INTO `staff` VALUES (10, 1, '寮犱笁', '13800010001', NULL, NULL, NULL, 1, 5, 3, NULL, 1, 0, 0, '2025-06-05 10:00:00', '2026-05-15 16:58:06', NULL);
INSERT INTO `staff` VALUES (11, 1, '鏉庡洓', '13800010002', NULL, NULL, NULL, 1, 5, 3, NULL, 1, 0, 0, '2025-06-05 10:00:00', '2026-05-15 16:58:06', NULL);
INSERT INTO `staff` VALUES (12, 1, '鐜嬩簲', '13800010003', NULL, NULL, NULL, 1, 4, 3, NULL, 1, 0, 0, '2025-06-05 10:00:00', '2026-05-15 16:58:06', NULL);
INSERT INTO `staff` VALUES (13, 1, '璧靛叚', '13800010004', NULL, NULL, NULL, 1, 6, 4, NULL, 1, 0, 0, '2025-07-10 10:00:00', '2026-05-15 16:58:07', NULL);
INSERT INTO `staff` VALUES (14, 1, '閽变竷', '13800010005', NULL, NULL, NULL, 1, 5, 4, NULL, 1, 0, 0, '2025-07-10 10:00:00', '2026-05-15 16:58:07', NULL);
INSERT INTO `staff` VALUES (15, 1, '瀛欏叓', '13800010006', NULL, NULL, NULL, 1, 3, 2, NULL, 1, 0, 0, '2025-08-15 10:00:00', '2026-05-15 16:58:09', NULL);
INSERT INTO `staff` VALUES (16, 1, '鍛ㄤ節', '13800010007', NULL, NULL, NULL, 1, 2, 2, NULL, 1, 0, 0, '2025-08-15 10:00:00', '2026-05-15 16:58:09', NULL);
INSERT INTO `staff` VALUES (17, 1, '鍚村崄', '13800010008', NULL, NULL, NULL, 1, 3, 1, NULL, 1, 0, 0, '2025-08-15 10:00:00', '2026-05-15 16:58:09', NULL);
INSERT INTO `staff` VALUES (18, 1, '张三', '13800010001', NULL, NULL, NULL, 1, 5, 2, NULL, 1, 0, 0, '2025-09-05 10:00:00', '2026-05-15 16:58:11', NULL);
INSERT INTO `staff` VALUES (19, 1, '李四', '13800010002', NULL, NULL, NULL, 1, 3, 1, NULL, 1, 0, 0, '2025-09-05 10:00:00', '2026-05-15 16:58:11', NULL);
INSERT INTO `staff` VALUES (20, 1, '王五', '13800010003', NULL, NULL, NULL, 1, 2, 0, NULL, 1, 0, 0, '2025-10-10 10:00:00', '2026-05-15 16:58:15', NULL);
INSERT INTO `staff` VALUES (21, 1, '赵六', '13800010004', NULL, NULL, NULL, 1, 4, 0, NULL, 1, 0, 0, '2025-10-10 10:00:00', '2026-05-15 16:58:15', NULL);
INSERT INTO `staff` VALUES (22, 1, '钱七', '13800010005', NULL, NULL, NULL, 1, 6, 3, NULL, 1, 0, 0, '2025-10-10 10:00:00', '2026-05-15 16:58:15', NULL);
INSERT INTO `staff` VALUES (23, 1, '孙八', '13800010006', NULL, NULL, NULL, 1, 1, 1, NULL, 1, 0, 0, '2025-11-12 10:00:00', '2026-05-15 16:58:16', NULL);
INSERT INTO `staff` VALUES (24, 1, '周九', '13800010007', NULL, NULL, NULL, 1, 3, 0, NULL, 1, 0, 0, '2025-11-12 10:00:00', '2026-05-15 16:58:16', NULL);
INSERT INTO `staff` VALUES (25, 1, '吴十', '13800010008', NULL, NULL, NULL, 1, 2, 2, NULL, 1, 0, 0, '2025-12-08 10:00:00', '2026-05-15 16:58:18', NULL);
INSERT INTO `staff` VALUES (26, 1, '郑十一', '13800010009', NULL, NULL, NULL, 1, 1, 0, NULL, 1, 0, 0, '2025-12-08 10:00:00', '2026-05-15 16:58:18', NULL);
INSERT INTO `staff` VALUES (27, 1, '陈十二', '13800010010', NULL, NULL, NULL, 1, 8, 4, NULL, 1, 0, 0, '2025-12-08 10:00:00', '2026-05-15 16:58:18', NULL);
INSERT INTO `staff` VALUES (28, 1, '刘十三', '13800010011', NULL, NULL, NULL, 1, 2, 1, NULL, 1, 0, 0, '2026-01-15 10:00:00', '2026-05-15 16:58:19', NULL);
INSERT INTO `staff` VALUES (29, 1, '黄十四', '13800010012', NULL, NULL, NULL, 1, 3, 0, NULL, 1, 0, 0, '2026-01-15 10:00:00', '2026-05-15 16:58:19', NULL);
INSERT INTO `staff` VALUES (30, 1, '林十五', '13800010013', NULL, NULL, NULL, 1, 1, 1, NULL, 1, 0, 0, '2026-02-10 10:00:00', '2026-05-15 16:58:24', NULL);
INSERT INTO `staff` VALUES (31, 1, '杨十六', '13800010014', NULL, NULL, NULL, 1, 5, 0, NULL, 1, 1, 0, '2026-02-10 10:00:00', '2026-05-15 16:58:24', NULL);
INSERT INTO `staff` VALUES (32, 1, '何十七', '13800010015', NULL, NULL, NULL, 1, 2, 0, NULL, 0, 0, 0, '2026-03-15 10:00:00', '2026-05-15 16:58:25', NULL);
INSERT INTO `staff` VALUES (33, 1, '马十八', '13800010016', NULL, NULL, NULL, 1, 4, 2, NULL, 1, 0, 0, '2026-03-15 10:00:00', '2026-05-15 16:58:25', NULL);
INSERT INTO `staff` VALUES (34, 1, '高十九', '13800010017', NULL, NULL, NULL, 1, 1, 0, NULL, 1, 0, 0, '2026-03-15 10:00:00', '2026-05-15 16:58:25', NULL);
INSERT INTO `staff` VALUES (35, 1, '罗二十', '13800010018', NULL, NULL, NULL, 1, 6, 0, NULL, 1, 0, 0, '2026-04-10 10:00:00', '2026-05-15 16:58:27', NULL);
INSERT INTO `staff` VALUES (36, 1, '梁廿一', '13800010019', NULL, NULL, NULL, 1, 3, 3, NULL, 1, 0, 0, '2026-04-10 10:00:00', '2026-05-15 16:58:27', NULL);
INSERT INTO `staff` VALUES (37, 1, '宋廿二', '13800010020', NULL, NULL, NULL, 1, 2, 0, NULL, 1, 0, 0, '2026-04-10 10:00:00', '2026-05-15 16:58:27', NULL);
INSERT INTO `staff` VALUES (38, 1, '唐廿三', '13800010021', NULL, NULL, NULL, 1, 1, 1, NULL, 1, 0, 0, '2026-05-01 10:00:00', '2026-05-15 16:58:29', NULL);
INSERT INTO `staff` VALUES (39, 1, '许廿四', '13800010022', NULL, NULL, NULL, 1, 4, 1, NULL, 1, 0, 0, '2026-05-01 10:00:00', '2026-05-15 16:58:29', NULL);
INSERT INTO `staff` VALUES (40, 1, '韩廿五', '13800010023', NULL, NULL, NULL, 1, 3, 0, NULL, 1, 0, 0, '2026-05-01 10:00:00', '2026-05-15 16:58:29', NULL);
INSERT INTO `staff` VALUES (41, 1, '冯廿六', '13800010024', NULL, NULL, NULL, 1, 2, 2, NULL, 1, 0, 0, '2026-05-15 09:13:02', '2026-05-15 09:13:02', NULL);
INSERT INTO `staff` VALUES (42, 1, '朱廿七', '13800010025', NULL, NULL, NULL, 1, 5, 0, NULL, 1, 0, 0, '2026-05-15 09:13:12', '2026-05-15 09:13:12', NULL);
INSERT INTO `staff` VALUES (43, 0, '李大宝', '13654123658', NULL, NULL, NULL, 1, 0, 0, 'ldb123', 0, 0, 0, '2026-05-18 15:21:24', '2026-05-18 16:59:19', NULL);
INSERT INTO `staff` VALUES (44, 0, '李二宝', '18874563214', NULL, NULL, NULL, 2, 0, 0, NULL, 1, 0, 0, '2026-05-18 16:42:19', '2026-05-18 16:42:19', NULL);
INSERT INTO `staff` VALUES (45, 0, '李三宝', '17895632587', NULL, NULL, NULL, 2, 0, 0, NULL, 1, 0, 0, '2026-05-18 16:42:54', '2026-05-18 16:42:54', NULL);
INSERT INTO `staff` VALUES (46, 0, '李四宝', '18896587456', NULL, NULL, NULL, 1, 0, 0, NULL, 1, 0, 0, '2026-05-18 16:43:23', '2026-05-18 16:43:23', NULL);
INSERT INTO `staff` VALUES (47, 1, 'TEST_商户', '13900001111', NULL, NULL, NULL, 1, 0, 0, NULL, 1, 0, 0, '2026-05-25 14:26:20', '2026-05-25 14:26:20', NULL);

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
-- Records of staff_accounts
-- ----------------------------
INSERT INTO `staff_accounts` VALUES (4, 5, 'admin', '$2a$12$XSfQBW68GFhFD/Wv8fQrC.ojahLf7/jgOTcPdjXAINtm0xyKkTHZW', NULL, '2026-05-25 14:33:52', 0, '2026-05-12 10:59:03', NULL);
INSERT INTO `staff_accounts` VALUES (5, 6, 'zhangsan', '$2a$12$siz./tf/sCXjdaALJ1JoVukyZZLxoRPId0QRxU5i5..7YNCXvhbfi', NULL, NULL, 1, '2026-05-14 16:27:55', NULL);
INSERT INTO `staff_accounts` VALUES (8, 9, 'zhangsan', '$2a$12$f8u1d4kJsk4YeYnS9Gt7wuzPV0eNFW9vcEynrOTf.bqtIFPqDU4yO', NULL, '2026-06-15 16:52:15', 0, '2026-05-15 08:56:53', NULL);
INSERT INTO `staff_accounts` VALUES (9, 10, 'zhangsan', '$2a$12$LJ3m4ys3Lk0TSwHlvDGBEuXsYQBq9XnHXeCvHRqEr7nTzCOGjLmCa', NULL, NULL, 0, '2026-05-15 09:10:42', NULL);
INSERT INTO `staff_accounts` VALUES (10, 11, 'lisi', '$2a$12$LJ3m4ys3Lk0TSwHlvDGBEuXsYQBq9XnHXeCvHRqEr7nTzCOGjLmCa', NULL, NULL, 0, '2026-05-15 09:10:42', NULL);
INSERT INTO `staff_accounts` VALUES (11, 12, 'wangwu', '$2a$12$LJ3m4ys3Lk0TSwHlvDGBEuXsYQBq9XnHXeCvHRqEr7nTzCOGjLmCa', NULL, NULL, 0, '2026-05-15 09:10:42', NULL);
INSERT INTO `staff_accounts` VALUES (12, 13, 'zhaoliu', '$2a$12$LJ3m4ys3Lk0TSwHlvDGBEuXsYQBq9XnHXeCvHRqEr7nTzCOGjLmCa', NULL, NULL, 0, '2026-05-15 09:10:42', NULL);
INSERT INTO `staff_accounts` VALUES (13, 14, 'qianqi', '$2a$12$LJ3m4ys3Lk0TSwHlvDGBEuXsYQBq9XnHXeCvHRqEr7nTzCOGjLmCa', NULL, NULL, 0, '2026-05-15 09:10:42', NULL);
INSERT INTO `staff_accounts` VALUES (14, 15, 'sunba', '$2a$12$LJ3m4ys3Lk0TSwHlvDGBEuXsYQBq9XnHXeCvHRqEr7nTzCOGjLmCa', NULL, NULL, 0, '2026-05-15 09:10:42', NULL);
INSERT INTO `staff_accounts` VALUES (15, 16, 'zhoujiu', '$2a$12$LJ3m4ys3Lk0TSwHlvDGBEuXsYQBq9XnHXeCvHRqEr7nTzCOGjLmCa', NULL, NULL, 0, '2026-05-15 09:10:42', NULL);
INSERT INTO `staff_accounts` VALUES (16, 17, 'wushi', '$2a$12$LJ3m4ys3Lk0TSwHlvDGBEuXsYQBq9XnHXeCvHRqEr7nTzCOGjLmCa', NULL, NULL, 0, '2026-05-15 09:10:42', NULL);
INSERT INTO `staff_accounts` VALUES (17, 18, 'zhangsan', '$2a$12$LJ3m4ys3Lk0TSwHlvDGBEuXsYQBq9XnHXeCvHRqEr7nTzCOGjLmCa', NULL, NULL, 0, '2026-05-15 09:13:47', NULL);
INSERT INTO `staff_accounts` VALUES (18, 19, 'lisi', '$2a$12$LJ3m4ys3Lk0TSwHlvDGBEuXsYQBq9XnHXeCvHRqEr7nTzCOGjLmCa', NULL, NULL, 0, '2026-05-15 09:13:47', NULL);
INSERT INTO `staff_accounts` VALUES (19, 20, 'wangwu', '$2a$12$LJ3m4ys3Lk0TSwHlvDGBEuXsYQBq9XnHXeCvHRqEr7nTzCOGjLmCa', NULL, NULL, 0, '2026-05-15 09:13:47', NULL);
INSERT INTO `staff_accounts` VALUES (20, 21, 'zhaoliu', '$2a$12$LJ3m4ys3Lk0TSwHlvDGBEuXsYQBq9XnHXeCvHRqEr7nTzCOGjLmCa', NULL, NULL, 0, '2026-05-15 09:13:47', NULL);
INSERT INTO `staff_accounts` VALUES (21, 22, 'qianqi', '$2a$12$LJ3m4ys3Lk0TSwHlvDGBEuXsYQBq9XnHXeCvHRqEr7nTzCOGjLmCa', NULL, NULL, 0, '2026-05-15 09:13:47', NULL);
INSERT INTO `staff_accounts` VALUES (22, 23, 'sunba', '$2a$12$LJ3m4ys3Lk0TSwHlvDGBEuXsYQBq9XnHXeCvHRqEr7nTzCOGjLmCa', NULL, NULL, 0, '2026-05-15 09:13:47', NULL);
INSERT INTO `staff_accounts` VALUES (23, 24, 'zhoujiu', '$2a$12$LJ3m4ys3Lk0TSwHlvDGBEuXsYQBq9XnHXeCvHRqEr7nTzCOGjLmCa', NULL, NULL, 0, '2026-05-15 09:13:47', NULL);
INSERT INTO `staff_accounts` VALUES (24, 25, 'wushi', '$2a$12$LJ3m4ys3Lk0TSwHlvDGBEuXsYQBq9XnHXeCvHRqEr7nTzCOGjLmCa', NULL, NULL, 0, '2026-05-15 09:13:47', NULL);
INSERT INTO `staff_accounts` VALUES (25, 26, 'zheng11', '$2a$12$LJ3m4ys3Lk0TSwHlvDGBEuXsYQBq9XnHXeCvHRqEr7nTzCOGjLmCa', NULL, NULL, 0, '2026-05-15 09:13:47', NULL);
INSERT INTO `staff_accounts` VALUES (26, 27, 'chen12', '$2a$12$LJ3m4ys3Lk0TSwHlvDGBEuXsYQBq9XnHXeCvHRqEr7nTzCOGjLmCa', NULL, NULL, 0, '2026-05-15 09:13:47', NULL);
INSERT INTO `staff_accounts` VALUES (27, 28, 'liu13', '$2a$12$LJ3m4ys3Lk0TSwHlvDGBEuXsYQBq9XnHXeCvHRqEr7nTzCOGjLmCa', NULL, NULL, 0, '2026-05-15 09:13:47', NULL);
INSERT INTO `staff_accounts` VALUES (28, 29, 'huang14', '$2a$12$LJ3m4ys3Lk0TSwHlvDGBEuXsYQBq9XnHXeCvHRqEr7nTzCOGjLmCa', NULL, NULL, 0, '2026-05-15 09:13:47', NULL);
INSERT INTO `staff_accounts` VALUES (29, 30, 'lin15', '$2a$12$LJ3m4ys3Lk0TSwHlvDGBEuXsYQBq9XnHXeCvHRqEr7nTzCOGjLmCa', NULL, NULL, 0, '2026-05-15 09:13:47', NULL);
INSERT INTO `staff_accounts` VALUES (30, 31, 'yang16', '$2a$12$LJ3m4ys3Lk0TSwHlvDGBEuXsYQBq9XnHXeCvHRqEr7nTzCOGjLmCa', NULL, NULL, 0, '2026-05-15 09:14:12', NULL);
INSERT INTO `staff_accounts` VALUES (31, 32, 'he17', '$2a$12$LJ3m4ys3Lk0TSwHlvDGBEuXsYQBq9XnHXeCvHRqEr7nTzCOGjLmCa', NULL, NULL, 0, '2026-05-15 09:14:12', NULL);
INSERT INTO `staff_accounts` VALUES (32, 33, 'ma18', '$2a$12$LJ3m4ys3Lk0TSwHlvDGBEuXsYQBq9XnHXeCvHRqEr7nTzCOGjLmCa', NULL, NULL, 0, '2026-05-15 09:14:12', NULL);
INSERT INTO `staff_accounts` VALUES (33, 34, 'gao19', '$2a$12$LJ3m4ys3Lk0TSwHlvDGBEuXsYQBq9XnHXeCvHRqEr7nTzCOGjLmCa', NULL, NULL, 0, '2026-05-15 09:14:12', NULL);
INSERT INTO `staff_accounts` VALUES (34, 35, 'luo20', '$2a$12$LJ3m4ys3Lk0TSwHlvDGBEuXsYQBq9XnHXeCvHRqEr7nTzCOGjLmCa', NULL, NULL, 0, '2026-05-15 09:14:12', NULL);
INSERT INTO `staff_accounts` VALUES (35, 36, 'liang21', '$2a$12$LJ3m4ys3Lk0TSwHlvDGBEuXsYQBq9XnHXeCvHRqEr7nTzCOGjLmCa', NULL, NULL, 0, '2026-05-15 09:14:12', NULL);
INSERT INTO `staff_accounts` VALUES (36, 37, 'song22', '$2a$12$LJ3m4ys3Lk0TSwHlvDGBEuXsYQBq9XnHXeCvHRqEr7nTzCOGjLmCa', NULL, NULL, 0, '2026-05-15 09:14:12', NULL);
INSERT INTO `staff_accounts` VALUES (37, 38, 'tang23', '$2a$12$LJ3m4ys3Lk0TSwHlvDGBEuXsYQBq9XnHXeCvHRqEr7nTzCOGjLmCa', NULL, NULL, 0, '2026-05-15 09:14:12', NULL);
INSERT INTO `staff_accounts` VALUES (38, 39, 'xu24', '$2a$12$LJ3m4ys3Lk0TSwHlvDGBEuXsYQBq9XnHXeCvHRqEr7nTzCOGjLmCa', NULL, NULL, 0, '2026-05-15 09:14:12', NULL);
INSERT INTO `staff_accounts` VALUES (39, 40, 'han25', '$2a$12$LJ3m4ys3Lk0TSwHlvDGBEuXsYQBq9XnHXeCvHRqEr7nTzCOGjLmCa', NULL, NULL, 0, '2026-05-15 09:14:12', NULL);
INSERT INTO `staff_accounts` VALUES (40, 41, 'feng26', '$2a$12$LJ3m4ys3Lk0TSwHlvDGBEuXsYQBq9XnHXeCvHRqEr7nTzCOGjLmCa', NULL, NULL, 0, '2026-05-15 09:14:12', NULL);
INSERT INTO `staff_accounts` VALUES (41, 42, 'zhu27', '$2a$12$LJ3m4ys3Lk0TSwHlvDGBEuXsYQBq9XnHXeCvHRqEr7nTzCOGjLmCa', NULL, NULL, 0, '2026-05-15 09:14:12', NULL);
INSERT INTO `staff_accounts` VALUES (42, 43, 'lidabao', '$2a$12$Ro.0DKEev4X0oDXSFe7ujeCIubPW8RHOA.mky3gsSOUKSuTLkx43y', NULL, NULL, 0, '2026-05-18 15:21:24', NULL);
INSERT INTO `staff_accounts` VALUES (43, 44, 'lierbao', '$2a$12$XKChiCpvymIw6BqiMIvpAedYQ6UyPTxKwFHP2jcLnFqmVEUbSf.w6', NULL, NULL, 0, '2026-05-18 16:42:19', NULL);
INSERT INTO `staff_accounts` VALUES (44, 45, 'lisanbao', '$2a$12$AH9DrDkeo4t9jrMdv.w0dewHsgaeNEU6DgtZc5dneYwjDv8cf4htS', NULL, '2026-05-23 08:09:41', 0, '2026-05-18 16:42:54', NULL);
INSERT INTO `staff_accounts` VALUES (45, 46, 'lisibao', '$2a$12$0fQhICFOQ6unmnBTXiwyzOTD3ggFcvIOzX8RCiWdKtsiL7iwO.0ty', NULL, NULL, 0, '2026-05-18 16:43:23', NULL);
INSERT INTO `staff_accounts` VALUES (46, 47, 'TEST_merchant', '$2a$12$odTaCDguafAyGuJvpBbVOO9f8SLe86t/Ow3tlIOfLaEO9m.HjN3QC', NULL, NULL, 0, '2026-05-25 14:26:21', NULL);

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
-- Records of staff_roles
-- ----------------------------
INSERT INTO `staff_roles` VALUES (5, 2);
INSERT INTO `staff_roles` VALUES (9, 3);
INSERT INTO `staff_roles` VALUES (10, 3);
INSERT INTO `staff_roles` VALUES (11, 3);
INSERT INTO `staff_roles` VALUES (12, 3);
INSERT INTO `staff_roles` VALUES (13, 3);
INSERT INTO `staff_roles` VALUES (14, 3);
INSERT INTO `staff_roles` VALUES (15, 3);
INSERT INTO `staff_roles` VALUES (16, 3);
INSERT INTO `staff_roles` VALUES (17, 3);
INSERT INTO `staff_roles` VALUES (18, 3);
INSERT INTO `staff_roles` VALUES (19, 3);
INSERT INTO `staff_roles` VALUES (20, 3);
INSERT INTO `staff_roles` VALUES (21, 3);
INSERT INTO `staff_roles` VALUES (22, 3);
INSERT INTO `staff_roles` VALUES (23, 3);
INSERT INTO `staff_roles` VALUES (24, 3);
INSERT INTO `staff_roles` VALUES (25, 3);
INSERT INTO `staff_roles` VALUES (26, 3);
INSERT INTO `staff_roles` VALUES (27, 3);
INSERT INTO `staff_roles` VALUES (28, 3);
INSERT INTO `staff_roles` VALUES (29, 3);
INSERT INTO `staff_roles` VALUES (30, 3);
INSERT INTO `staff_roles` VALUES (31, 3);
INSERT INTO `staff_roles` VALUES (32, 3);
INSERT INTO `staff_roles` VALUES (33, 3);
INSERT INTO `staff_roles` VALUES (34, 3);
INSERT INTO `staff_roles` VALUES (35, 3);
INSERT INTO `staff_roles` VALUES (36, 3);
INSERT INTO `staff_roles` VALUES (37, 3);
INSERT INTO `staff_roles` VALUES (38, 3);
INSERT INTO `staff_roles` VALUES (39, 3);
INSERT INTO `staff_roles` VALUES (40, 3);
INSERT INTO `staff_roles` VALUES (41, 3);
INSERT INTO `staff_roles` VALUES (42, 3);
INSERT INTO `staff_roles` VALUES (43, 4);
INSERT INTO `staff_roles` VALUES (43, 5);
INSERT INTO `staff_roles` VALUES (43, 6);
INSERT INTO `staff_roles` VALUES (44, 4);
INSERT INTO `staff_roles` VALUES (45, 5);
INSERT INTO `staff_roles` VALUES (46, 6);
INSERT INTO `staff_roles` VALUES (47, 3);

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
) ENGINE = InnoDB AUTO_INCREMENT = 157 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '员工排班表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of staff_schedules
-- ----------------------------
INSERT INTO `staff_schedules` VALUES (1, 5, 43, '2026-05-22', '09:00:00', '18:00:00', 1, NULL, '2026-05-28 11:05:23');
INSERT INTO `staff_schedules` VALUES (2, 5, 44, '2026-05-22', '09:00:00', '18:00:00', 1, NULL, '2026-05-28 11:05:23');
INSERT INTO `staff_schedules` VALUES (3, 5, 45, '2026-05-22', '09:00:00', '18:00:00', 1, NULL, '2026-05-28 11:05:23');
INSERT INTO `staff_schedules` VALUES (4, 5, 46, '2026-05-22', '09:00:00', '18:00:00', 1, NULL, '2026-05-28 11:05:23');
INSERT INTO `staff_schedules` VALUES (5, 5, 43, '2026-05-23', '09:00:00', '18:00:00', 1, NULL, '2026-05-28 11:05:23');
INSERT INTO `staff_schedules` VALUES (6, 5, 44, '2026-05-23', '09:00:00', '18:00:00', 1, NULL, '2026-05-28 11:05:23');
INSERT INTO `staff_schedules` VALUES (7, 5, 45, '2026-05-23', '09:00:00', '18:00:00', 1, NULL, '2026-05-28 11:05:23');
INSERT INTO `staff_schedules` VALUES (8, 5, 46, '2026-05-23', '09:00:00', '18:00:00', 1, NULL, '2026-05-28 11:05:23');
INSERT INTO `staff_schedules` VALUES (9, 5, 43, '2026-05-24', '09:00:00', '18:00:00', 1, NULL, '2026-05-28 11:05:23');
INSERT INTO `staff_schedules` VALUES (10, 5, 44, '2026-05-24', '09:00:00', '18:00:00', 1, NULL, '2026-05-28 11:05:23');
INSERT INTO `staff_schedules` VALUES (11, 5, 45, '2026-05-24', '09:00:00', '18:00:00', 1, NULL, '2026-05-28 11:05:23');
INSERT INTO `staff_schedules` VALUES (12, 5, 46, '2026-05-24', '09:00:00', '18:00:00', 1, NULL, '2026-05-28 11:05:23');
INSERT INTO `staff_schedules` VALUES (13, 5, 43, '2026-05-25', '09:00:00', '18:00:00', 1, NULL, '2026-05-28 11:05:23');
INSERT INTO `staff_schedules` VALUES (14, 5, 44, '2026-05-25', '09:00:00', '18:00:00', 1, NULL, '2026-05-28 11:05:23');
INSERT INTO `staff_schedules` VALUES (15, 5, 45, '2026-05-25', '09:00:00', '18:00:00', 1, NULL, '2026-05-28 11:05:23');
INSERT INTO `staff_schedules` VALUES (16, 5, 46, '2026-05-25', '09:00:00', '18:00:00', 1, NULL, '2026-05-28 11:05:23');
INSERT INTO `staff_schedules` VALUES (17, 5, 43, '2026-05-26', '09:00:00', '18:00:00', 1, NULL, '2026-05-28 11:05:23');
INSERT INTO `staff_schedules` VALUES (18, 5, 44, '2026-05-26', '09:00:00', '18:00:00', 1, NULL, '2026-05-28 11:05:23');
INSERT INTO `staff_schedules` VALUES (19, 5, 45, '2026-05-26', '09:00:00', '18:00:00', 1, NULL, '2026-05-28 11:05:23');
INSERT INTO `staff_schedules` VALUES (20, 5, 46, '2026-05-26', '09:00:00', '18:00:00', 1, NULL, '2026-05-28 11:05:23');
INSERT INTO `staff_schedules` VALUES (21, 5, 43, '2026-05-27', '09:00:00', '18:00:00', 1, NULL, '2026-05-28 11:05:23');
INSERT INTO `staff_schedules` VALUES (22, 5, 44, '2026-05-27', '09:00:00', '18:00:00', 1, NULL, '2026-05-28 11:05:23');
INSERT INTO `staff_schedules` VALUES (23, 5, 45, '2026-05-27', '09:00:00', '18:00:00', 1, NULL, '2026-05-28 11:05:23');
INSERT INTO `staff_schedules` VALUES (24, 5, 46, '2026-05-27', '09:00:00', '18:00:00', 1, NULL, '2026-05-28 11:05:23');
INSERT INTO `staff_schedules` VALUES (25, 5, 43, '2026-05-28', '09:00:00', '18:00:00', 1, NULL, '2026-05-28 11:05:23');
INSERT INTO `staff_schedules` VALUES (26, 5, 44, '2026-05-28', '09:00:00', '18:00:00', 1, NULL, '2026-05-28 11:05:23');
INSERT INTO `staff_schedules` VALUES (27, 5, 45, '2026-05-28', '09:00:00', '18:00:00', 1, NULL, '2026-05-28 11:05:23');
INSERT INTO `staff_schedules` VALUES (28, 5, 46, '2026-05-28', '09:00:00', '18:00:00', 1, NULL, '2026-05-28 11:05:23');
INSERT INTO `staff_schedules` VALUES (29, 5, 43, '2026-05-09', '09:00:00', '18:00:00', 1, NULL, '2026-05-09 08:00:00');
INSERT INTO `staff_schedules` VALUES (30, 5, 44, '2026-05-09', '09:00:00', '18:00:00', 1, NULL, '2026-05-09 08:00:00');
INSERT INTO `staff_schedules` VALUES (31, 5, 45, '2026-05-09', '09:00:00', '18:00:00', 1, NULL, '2026-05-09 08:00:00');
INSERT INTO `staff_schedules` VALUES (32, 5, 46, '2026-05-09', '09:00:00', '18:00:00', 1, NULL, '2026-05-09 08:00:00');
INSERT INTO `staff_schedules` VALUES (33, 5, 43, '2026-05-10', '09:00:00', '18:00:00', 1, NULL, '2026-05-10 08:00:00');
INSERT INTO `staff_schedules` VALUES (34, 5, 44, '2026-05-10', '09:00:00', '18:00:00', 1, NULL, '2026-05-10 08:00:00');
INSERT INTO `staff_schedules` VALUES (35, 5, 45, '2026-05-10', '09:00:00', '18:00:00', 1, NULL, '2026-05-10 08:00:00');
INSERT INTO `staff_schedules` VALUES (36, 5, 46, '2026-05-10', '09:00:00', '18:00:00', 1, NULL, '2026-05-10 08:00:00');
INSERT INTO `staff_schedules` VALUES (37, 5, 43, '2026-05-11', '09:00:00', '18:00:00', 1, NULL, '2026-05-11 08:00:00');
INSERT INTO `staff_schedules` VALUES (38, 5, 44, '2026-05-11', '09:00:00', '18:00:00', 1, NULL, '2026-05-11 08:00:00');
INSERT INTO `staff_schedules` VALUES (39, 5, 45, '2026-05-11', '09:00:00', '18:00:00', 1, NULL, '2026-05-11 08:00:00');
INSERT INTO `staff_schedules` VALUES (40, 5, 46, '2026-05-11', '09:00:00', '18:00:00', 1, NULL, '2026-05-11 08:00:00');
INSERT INTO `staff_schedules` VALUES (41, 5, 43, '2026-05-12', '09:00:00', '18:00:00', 1, NULL, '2026-05-12 08:00:00');
INSERT INTO `staff_schedules` VALUES (42, 5, 44, '2026-05-12', '09:00:00', '18:00:00', 1, NULL, '2026-05-12 08:00:00');
INSERT INTO `staff_schedules` VALUES (43, 5, 45, '2026-05-12', '09:00:00', '18:00:00', 1, NULL, '2026-05-12 08:00:00');
INSERT INTO `staff_schedules` VALUES (44, 5, 46, '2026-05-12', '09:00:00', '18:00:00', 1, NULL, '2026-05-12 08:00:00');
INSERT INTO `staff_schedules` VALUES (45, 5, 43, '2026-05-13', '09:00:00', '18:00:00', 1, NULL, '2026-05-13 08:00:00');
INSERT INTO `staff_schedules` VALUES (46, 5, 44, '2026-05-13', '09:00:00', '18:00:00', 1, NULL, '2026-05-13 08:00:00');
INSERT INTO `staff_schedules` VALUES (47, 5, 45, '2026-05-13', '09:00:00', '18:00:00', 1, NULL, '2026-05-13 08:00:00');
INSERT INTO `staff_schedules` VALUES (48, 5, 46, '2026-05-13', '09:00:00', '18:00:00', 1, NULL, '2026-05-13 08:00:00');
INSERT INTO `staff_schedules` VALUES (49, 5, 43, '2026-05-14', '09:00:00', '18:00:00', 1, NULL, '2026-05-14 08:00:00');
INSERT INTO `staff_schedules` VALUES (50, 5, 44, '2026-05-14', '09:00:00', '18:00:00', 1, NULL, '2026-05-14 08:00:00');
INSERT INTO `staff_schedules` VALUES (51, 5, 45, '2026-05-14', '09:00:00', '18:00:00', 1, NULL, '2026-05-14 08:00:00');
INSERT INTO `staff_schedules` VALUES (52, 5, 46, '2026-05-14', '09:00:00', '18:00:00', 1, NULL, '2026-05-14 08:00:00');
INSERT INTO `staff_schedules` VALUES (53, 5, 43, '2026-05-15', '09:00:00', '18:00:00', 1, NULL, '2026-05-15 08:00:00');
INSERT INTO `staff_schedules` VALUES (54, 5, 44, '2026-05-15', '09:00:00', '18:00:00', 1, NULL, '2026-05-15 08:00:00');
INSERT INTO `staff_schedules` VALUES (55, 5, 45, '2026-05-15', '09:00:00', '18:00:00', 1, NULL, '2026-05-15 08:00:00');
INSERT INTO `staff_schedules` VALUES (56, 5, 46, '2026-05-15', '09:00:00', '18:00:00', 1, NULL, '2026-05-15 08:00:00');
INSERT INTO `staff_schedules` VALUES (57, 5, 43, '2026-05-16', '09:00:00', '18:00:00', 1, NULL, '2026-05-16 08:00:00');
INSERT INTO `staff_schedules` VALUES (58, 5, 44, '2026-05-16', '09:00:00', '18:00:00', 1, NULL, '2026-05-16 08:00:00');
INSERT INTO `staff_schedules` VALUES (59, 5, 45, '2026-05-16', '09:00:00', '18:00:00', 1, NULL, '2026-05-16 08:00:00');
INSERT INTO `staff_schedules` VALUES (60, 5, 46, '2026-05-16', '09:00:00', '18:00:00', 1, NULL, '2026-05-16 08:00:00');
INSERT INTO `staff_schedules` VALUES (61, 5, 43, '2026-05-17', '09:00:00', '18:00:00', 1, NULL, '2026-05-17 08:00:00');
INSERT INTO `staff_schedules` VALUES (62, 5, 44, '2026-05-17', '09:00:00', '18:00:00', 1, NULL, '2026-05-17 08:00:00');
INSERT INTO `staff_schedules` VALUES (63, 5, 45, '2026-05-17', '09:00:00', '18:00:00', 1, NULL, '2026-05-17 08:00:00');
INSERT INTO `staff_schedules` VALUES (64, 5, 46, '2026-05-17', '09:00:00', '18:00:00', 1, NULL, '2026-05-17 08:00:00');
INSERT INTO `staff_schedules` VALUES (65, 5, 43, '2026-05-18', '09:00:00', '18:00:00', 1, NULL, '2026-05-18 08:00:00');
INSERT INTO `staff_schedules` VALUES (66, 5, 44, '2026-05-18', '09:00:00', '18:00:00', 1, NULL, '2026-05-18 08:00:00');
INSERT INTO `staff_schedules` VALUES (67, 5, 45, '2026-05-18', '09:00:00', '18:00:00', 1, NULL, '2026-05-18 08:00:00');
INSERT INTO `staff_schedules` VALUES (68, 5, 46, '2026-05-18', '09:00:00', '18:00:00', 1, NULL, '2026-05-18 08:00:00');
INSERT INTO `staff_schedules` VALUES (69, 5, 43, '2026-05-19', '09:00:00', '18:00:00', 1, NULL, '2026-05-19 08:00:00');
INSERT INTO `staff_schedules` VALUES (70, 5, 44, '2026-05-19', '09:00:00', '18:00:00', 1, NULL, '2026-05-19 08:00:00');
INSERT INTO `staff_schedules` VALUES (71, 5, 45, '2026-05-19', '09:00:00', '18:00:00', 1, NULL, '2026-05-19 08:00:00');
INSERT INTO `staff_schedules` VALUES (72, 5, 46, '2026-05-19', '09:00:00', '18:00:00', 1, NULL, '2026-05-19 08:00:00');
INSERT INTO `staff_schedules` VALUES (73, 5, 43, '2026-05-20', '09:00:00', '18:00:00', 1, NULL, '2026-05-20 08:00:00');
INSERT INTO `staff_schedules` VALUES (74, 5, 44, '2026-05-20', '09:00:00', '18:00:00', 1, NULL, '2026-05-20 08:00:00');
INSERT INTO `staff_schedules` VALUES (75, 5, 45, '2026-05-20', '09:00:00', '18:00:00', 1, NULL, '2026-05-20 08:00:00');
INSERT INTO `staff_schedules` VALUES (76, 5, 46, '2026-05-20', '09:00:00', '18:00:00', 1, NULL, '2026-05-20 08:00:00');
INSERT INTO `staff_schedules` VALUES (77, 5, 43, '2026-05-21', '09:00:00', '18:00:00', 1, NULL, '2026-05-21 08:00:00');
INSERT INTO `staff_schedules` VALUES (78, 5, 44, '2026-05-21', '09:00:00', '18:00:00', 1, NULL, '2026-05-21 08:00:00');
INSERT INTO `staff_schedules` VALUES (79, 5, 45, '2026-05-21', '09:00:00', '18:00:00', 1, NULL, '2026-05-21 08:00:00');
INSERT INTO `staff_schedules` VALUES (80, 5, 46, '2026-05-21', '09:00:00', '18:00:00', 1, NULL, '2026-05-21 08:00:00');
INSERT INTO `staff_schedules` VALUES (81, 5, 43, '2026-05-22', '09:00:00', '18:00:00', 1, NULL, '2026-05-22 08:00:00');
INSERT INTO `staff_schedules` VALUES (82, 5, 44, '2026-05-22', '09:00:00', '18:00:00', 1, NULL, '2026-05-22 08:00:00');
INSERT INTO `staff_schedules` VALUES (83, 5, 45, '2026-05-22', '09:00:00', '18:00:00', 1, NULL, '2026-05-22 08:00:00');
INSERT INTO `staff_schedules` VALUES (84, 5, 46, '2026-05-22', '09:00:00', '18:00:00', 1, NULL, '2026-05-22 08:00:00');
INSERT INTO `staff_schedules` VALUES (85, 5, 43, '2026-05-23', '09:00:00', '18:00:00', 1, NULL, '2026-05-23 08:00:00');
INSERT INTO `staff_schedules` VALUES (86, 5, 44, '2026-05-23', '09:00:00', '18:00:00', 1, NULL, '2026-05-23 08:00:00');
INSERT INTO `staff_schedules` VALUES (87, 5, 45, '2026-05-23', '09:00:00', '18:00:00', 1, NULL, '2026-05-23 08:00:00');
INSERT INTO `staff_schedules` VALUES (88, 5, 46, '2026-05-23', '09:00:00', '18:00:00', 1, NULL, '2026-05-23 08:00:00');
INSERT INTO `staff_schedules` VALUES (89, 5, 43, '2026-05-24', '09:00:00', '18:00:00', 1, NULL, '2026-05-24 08:00:00');
INSERT INTO `staff_schedules` VALUES (90, 5, 44, '2026-05-24', '09:00:00', '18:00:00', 1, NULL, '2026-05-24 08:00:00');
INSERT INTO `staff_schedules` VALUES (91, 5, 45, '2026-05-24', '09:00:00', '18:00:00', 1, NULL, '2026-05-24 08:00:00');
INSERT INTO `staff_schedules` VALUES (92, 5, 46, '2026-05-24', '09:00:00', '18:00:00', 1, NULL, '2026-05-24 08:00:00');
INSERT INTO `staff_schedules` VALUES (93, 5, 43, '2026-05-25', '09:00:00', '18:00:00', 1, NULL, '2026-05-25 08:00:00');
INSERT INTO `staff_schedules` VALUES (94, 5, 44, '2026-05-25', '09:00:00', '18:00:00', 1, NULL, '2026-05-25 08:00:00');
INSERT INTO `staff_schedules` VALUES (95, 5, 45, '2026-05-25', '09:00:00', '18:00:00', 1, NULL, '2026-05-25 08:00:00');
INSERT INTO `staff_schedules` VALUES (96, 5, 46, '2026-05-25', '09:00:00', '18:00:00', 1, NULL, '2026-05-25 08:00:00');
INSERT INTO `staff_schedules` VALUES (97, 5, 43, '2026-05-26', '09:00:00', '18:00:00', 1, NULL, '2026-05-26 08:00:00');
INSERT INTO `staff_schedules` VALUES (98, 5, 44, '2026-05-26', '09:00:00', '18:00:00', 1, NULL, '2026-05-26 08:00:00');
INSERT INTO `staff_schedules` VALUES (99, 5, 45, '2026-05-26', '09:00:00', '18:00:00', 1, NULL, '2026-05-26 08:00:00');
INSERT INTO `staff_schedules` VALUES (100, 5, 46, '2026-05-26', '09:00:00', '18:00:00', 1, NULL, '2026-05-26 08:00:00');
INSERT INTO `staff_schedules` VALUES (101, 5, 43, '2026-05-27', '09:00:00', '18:00:00', 1, NULL, '2026-05-27 08:00:00');
INSERT INTO `staff_schedules` VALUES (102, 5, 44, '2026-05-27', '09:00:00', '18:00:00', 1, NULL, '2026-05-27 08:00:00');
INSERT INTO `staff_schedules` VALUES (103, 5, 45, '2026-05-27', '09:00:00', '18:00:00', 1, NULL, '2026-05-27 08:00:00');
INSERT INTO `staff_schedules` VALUES (104, 5, 46, '2026-05-27', '09:00:00', '18:00:00', 1, NULL, '2026-05-27 08:00:00');
INSERT INTO `staff_schedules` VALUES (105, 5, 43, '2026-05-28', '09:00:00', '18:00:00', 1, NULL, '2026-05-28 08:00:00');
INSERT INTO `staff_schedules` VALUES (106, 5, 44, '2026-05-28', '09:00:00', '18:00:00', 1, NULL, '2026-05-28 08:00:00');
INSERT INTO `staff_schedules` VALUES (107, 5, 45, '2026-05-28', '09:00:00', '18:00:00', 1, NULL, '2026-05-28 08:00:00');
INSERT INTO `staff_schedules` VALUES (108, 5, 46, '2026-05-28', '09:00:00', '18:00:00', 1, NULL, '2026-05-28 08:00:00');
INSERT INTO `staff_schedules` VALUES (109, 5, 43, '2026-05-29', '09:00:00', '18:00:00', 1, NULL, '2026-05-29 08:00:00');
INSERT INTO `staff_schedules` VALUES (110, 5, 44, '2026-05-29', '09:00:00', '18:00:00', 1, NULL, '2026-05-29 08:00:00');
INSERT INTO `staff_schedules` VALUES (111, 5, 45, '2026-05-29', '09:00:00', '18:00:00', 1, NULL, '2026-05-29 08:00:00');
INSERT INTO `staff_schedules` VALUES (112, 5, 46, '2026-05-29', '09:00:00', '18:00:00', 1, NULL, '2026-05-29 08:00:00');
INSERT INTO `staff_schedules` VALUES (113, 5, 43, '2026-05-30', '09:00:00', '18:00:00', 1, NULL, '2026-05-30 08:00:00');
INSERT INTO `staff_schedules` VALUES (114, 5, 44, '2026-05-30', '09:00:00', '18:00:00', 1, NULL, '2026-05-30 08:00:00');
INSERT INTO `staff_schedules` VALUES (115, 5, 45, '2026-05-30', '09:00:00', '18:00:00', 1, NULL, '2026-05-30 08:00:00');
INSERT INTO `staff_schedules` VALUES (116, 5, 46, '2026-05-30', '09:00:00', '18:00:00', 1, NULL, '2026-05-30 08:00:00');
INSERT INTO `staff_schedules` VALUES (117, 5, 43, '2026-05-31', '09:00:00', '18:00:00', 1, NULL, '2026-05-31 08:00:00');
INSERT INTO `staff_schedules` VALUES (118, 5, 44, '2026-05-31', '09:00:00', '18:00:00', 1, NULL, '2026-05-31 08:00:00');
INSERT INTO `staff_schedules` VALUES (119, 5, 45, '2026-05-31', '09:00:00', '18:00:00', 1, NULL, '2026-05-31 08:00:00');
INSERT INTO `staff_schedules` VALUES (120, 5, 46, '2026-05-31', '09:00:00', '18:00:00', 1, NULL, '2026-05-31 08:00:00');
INSERT INTO `staff_schedules` VALUES (121, 5, 43, '2026-06-01', '09:00:00', '18:00:00', 1, '儿童节加班', '2026-06-01 08:00:00');
INSERT INTO `staff_schedules` VALUES (122, 5, 44, '2026-06-01', '09:00:00', '18:00:00', 1, '儿童节加班', '2026-06-01 08:00:00');
INSERT INTO `staff_schedules` VALUES (123, 5, 45, '2026-06-01', '09:00:00', '18:00:00', 1, '儿童节加班', '2026-06-01 08:00:00');
INSERT INTO `staff_schedules` VALUES (124, 5, 46, '2026-06-01', '09:00:00', '18:00:00', 1, '儿童节加班', '2026-06-01 08:00:00');
INSERT INTO `staff_schedules` VALUES (125, 5, 43, '2026-06-02', '09:00:00', '18:00:00', 1, NULL, '2026-06-02 08:00:00');
INSERT INTO `staff_schedules` VALUES (126, 5, 44, '2026-06-02', '09:00:00', '18:00:00', 1, NULL, '2026-06-02 08:00:00');
INSERT INTO `staff_schedules` VALUES (127, 5, 45, '2026-06-02', '09:00:00', '18:00:00', 1, NULL, '2026-06-02 08:00:00');
INSERT INTO `staff_schedules` VALUES (128, 5, 46, '2026-06-02', '09:00:00', '18:00:00', 1, NULL, '2026-06-02 08:00:00');
INSERT INTO `staff_schedules` VALUES (129, 5, 43, '2026-06-03', '09:00:00', '18:00:00', 1, NULL, '2026-06-03 08:00:00');
INSERT INTO `staff_schedules` VALUES (130, 5, 44, '2026-06-03', '09:00:00', '18:00:00', 1, NULL, '2026-06-03 08:00:00');
INSERT INTO `staff_schedules` VALUES (131, 5, 45, '2026-06-03', '09:00:00', '18:00:00', 1, NULL, '2026-06-03 08:00:00');
INSERT INTO `staff_schedules` VALUES (132, 5, 46, '2026-06-03', '09:00:00', '18:00:00', 1, NULL, '2026-06-03 08:00:00');
INSERT INTO `staff_schedules` VALUES (133, 5, 43, '2026-06-04', '09:00:00', '18:00:00', 1, NULL, '2026-06-04 08:00:00');
INSERT INTO `staff_schedules` VALUES (134, 5, 44, '2026-06-04', '09:00:00', '18:00:00', 1, NULL, '2026-06-04 08:00:00');
INSERT INTO `staff_schedules` VALUES (135, 5, 45, '2026-06-04', '09:00:00', '18:00:00', 1, NULL, '2026-06-04 08:00:00');
INSERT INTO `staff_schedules` VALUES (136, 5, 46, '2026-06-04', '09:00:00', '18:00:00', 1, NULL, '2026-06-04 08:00:00');
INSERT INTO `staff_schedules` VALUES (137, 5, 43, '2026-06-05', '09:00:00', '18:00:00', 1, NULL, '2026-06-05 08:00:00');
INSERT INTO `staff_schedules` VALUES (138, 5, 44, '2026-06-05', '09:00:00', '18:00:00', 1, NULL, '2026-06-05 08:00:00');
INSERT INTO `staff_schedules` VALUES (139, 5, 45, '2026-06-05', '09:00:00', '18:00:00', 1, NULL, '2026-06-05 08:00:00');
INSERT INTO `staff_schedules` VALUES (140, 5, 46, '2026-06-05', '09:00:00', '18:00:00', 1, NULL, '2026-06-05 08:00:00');
INSERT INTO `staff_schedules` VALUES (141, 5, 43, '2026-06-06', '09:00:00', '18:00:00', 1, NULL, '2026-06-06 08:00:00');
INSERT INTO `staff_schedules` VALUES (142, 5, 44, '2026-06-06', '09:00:00', '18:00:00', 1, NULL, '2026-06-06 08:00:00');
INSERT INTO `staff_schedules` VALUES (143, 5, 45, '2026-06-06', '09:00:00', '18:00:00', 1, NULL, '2026-06-06 08:00:00');
INSERT INTO `staff_schedules` VALUES (144, 5, 46, '2026-06-06', '09:00:00', '18:00:00', 1, NULL, '2026-06-06 08:00:00');
INSERT INTO `staff_schedules` VALUES (145, 5, 43, '2026-06-07', '09:00:00', '18:00:00', 1, NULL, '2026-06-07 08:00:00');
INSERT INTO `staff_schedules` VALUES (146, 5, 44, '2026-06-07', '09:00:00', '18:00:00', 1, NULL, '2026-06-07 08:00:00');
INSERT INTO `staff_schedules` VALUES (147, 5, 45, '2026-06-07', '09:00:00', '18:00:00', 1, NULL, '2026-06-07 08:00:00');
INSERT INTO `staff_schedules` VALUES (148, 5, 46, '2026-06-07', '09:00:00', '18:00:00', 1, NULL, '2026-06-07 08:00:00');
INSERT INTO `staff_schedules` VALUES (149, 5, 43, '2026-06-08', '09:00:00', '18:00:00', 1, NULL, '2026-06-08 08:00:00');
INSERT INTO `staff_schedules` VALUES (150, 5, 44, '2026-06-08', '09:00:00', '18:00:00', 1, NULL, '2026-06-08 08:00:00');
INSERT INTO `staff_schedules` VALUES (151, 5, 45, '2026-06-08', '09:00:00', '18:00:00', 1, NULL, '2026-06-08 08:00:00');
INSERT INTO `staff_schedules` VALUES (152, 5, 46, '2026-06-08', '09:00:00', '18:00:00', 1, NULL, '2026-06-08 08:00:00');
INSERT INTO `staff_schedules` VALUES (153, 5, 43, '2026-06-09', '09:00:00', '18:00:00', 1, NULL, '2026-06-09 08:00:00');
INSERT INTO `staff_schedules` VALUES (154, 5, 44, '2026-06-09', '09:00:00', '18:00:00', 1, NULL, '2026-06-09 08:00:00');
INSERT INTO `staff_schedules` VALUES (155, 5, 45, '2026-06-09', '09:00:00', '18:00:00', 1, NULL, '2026-06-09 08:00:00');
INSERT INTO `staff_schedules` VALUES (156, 5, 46, '2026-06-09', '09:00:00', '18:00:00', 1, NULL, '2026-06-09 08:00:00');

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
-- Records of staff_shops
-- ----------------------------
INSERT INTO `staff_shops` VALUES (5, 43, 5, '2026-05-18 15:21:24');
INSERT INTO `staff_shops` VALUES (6, 44, 5, '2026-05-18 16:42:19');
INSERT INTO `staff_shops` VALUES (7, 45, 5, '2026-05-18 16:42:54');
INSERT INTO `staff_shops` VALUES (8, 46, 5, '2026-05-18 16:43:23');

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
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '供应商表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of suppliers
-- ----------------------------
INSERT INTO `suppliers` VALUES (1, 5, 'AAA拼豆批发商', '李总', '17845632014', NULL, NULL, 0, '2026-05-20 16:26:44', NULL);
INSERT INTO `suppliers` VALUES (2, 5, '杂货铺', '小张', NULL, NULL, NULL, 0, '2026-05-21 08:39:09', NULL);
INSERT INTO `suppliers` VALUES (3, 5, '大润发超市', NULL, NULL, NULL, NULL, 0, '2026-05-21 08:39:23', NULL);
INSERT INTO `suppliers` VALUES (4, 5, '虾丸手工物料批发', '徐', NULL, NULL, NULL, 0, '2026-05-21 08:39:59', NULL);
INSERT INTO `suppliers` VALUES (5, 5, '义乌小商品批发城', '王老板', '13700001111', '义乌市国际商贸城A区', '拼豆、配件供应商', 0, '2026-06-09 22:28:51', NULL);
INSERT INTO `suppliers` VALUES (6, 5, '美术用品专营店', '李经理', '13700002222', '嘉善县文化艺术用品市场', '颜料、画笔供应商', 0, '2026-06-09 22:28:51', NULL);

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
-- Records of sys_dicts
-- ----------------------------
INSERT INTO `sys_dicts` VALUES (1, 'package_type', 1, '单次', 'SINGLE', 1, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (2, 'package_type', 2, '周卡', 'WEEKLY', 2, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (3, 'package_type', 3, '月卡', 'MONTHLY', 3, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (4, 'material_type', 1, '消耗品', 'CONSUMABLE', 1, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (5, 'material_type', 2, '工具', 'TOOL', 2, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (6, 'order_status', 1, '有效', 'VALID', 1, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (7, 'order_status', 2, '已退款', 'REFUNDED', 2, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (8, 'order_status', 3, '已过期', 'EXPIRED', 3, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (9, 'session_status', 1, '可用', 'AVAILABLE', 1, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (10, 'session_status', 2, '已核销', 'USED', 2, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (11, 'session_status', 3, '已过期', 'EXPIRED', 3, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (12, 'session_status', 4, '已退款', 'REFUNDED', 4, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (13, 'game_status', 1, '进行中', 'ACTIVE', 1, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (14, 'game_status', 2, '已完成', 'COMPLETED', 2, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (15, 'game_status', 3, '已取消', 'CANCELLED', 3, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (16, 'inv_trans_type', 1, '入库', 'INBOUND', 1, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (17, 'inv_trans_type', 2, '出库', 'OUTBOUND', 2, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (18, 'po_type', 1, '现结', 'CASH', 1, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (19, 'po_type', 2, '赊账', 'CREDIT', 2, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (20, 'po_status', 1, '进行中', 'PENDING', 1, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (21, 'po_status', 2, '已完成', 'COMPLETED', 2, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (22, 'po_status', 3, '已取消', 'CANCELLED', 3, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (23, 'staff_employment', 1, '全职', 'FULL_TIME', 1, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (24, 'staff_employment', 2, '兼职', 'PART_TIME', 2, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (25, 'attendance_status', 1, '正常', 'NORMAL', 1, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (26, 'attendance_status', 2, '迟到', 'LATE', 2, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (27, 'attendance_status', 3, '早退', 'EARLY', 3, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (28, 'attendance_status', 4, '加班', 'OVERTIME', 4, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (29, 'article_type', 1, '图片', 'IMAGE', 1, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (30, 'article_type', 2, '视频', 'VIDEO', 2, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (31, 'article_type', 3, '富文本', 'RICHTEXT', 3, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (32, 'log_operator_type', 1, '员工', 'STAFF', 1, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (33, 'log_operator_type', 2, '顾客', 'CUSTOMER', 2, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (34, 'coupon_verify_op', 1, '注册', 'REGISTER', 1, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (35, 'coupon_verify_op', 2, '核销', 'CHECK', 2, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (36, 'coupon_verify_op', 3, '同步', 'SYNC', 3, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (37, 'coupon_verify_result', 1, '成功', 'SUCCESS', 1, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (38, 'coupon_verify_result', 2, '失败', 'FAIL', 2, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (39, 'coupon_verify_result', 3, '无效码', 'INVALID_CODE', 3, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (40, 'coupon_verify_result', 4, '重复', 'DUPLICATE', 4, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (41, 'coupon_verify_result', 5, '已过期', 'EXPIRED', 5, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (42, 'refund_status', 1, '处理中', 'PENDING', 1, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (43, 'refund_status', 2, '已完成', 'COMPLETED', 2, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (44, 'refund_status', 3, '已拒绝', 'REJECTED', 3, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (45, 'wallet_tx_type', 1, '充值', 'RECHARGE', 1, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (46, 'wallet_tx_type', 2, '消费', 'CONSUMPTION', 2, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (47, 'wallet_tx_type', 3, '退款', 'REFUND', 3, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (48, 'wallet_tx_type', 4, '调整', 'ADJUSTMENT', 4, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (49, 'points_type', 1, '获取', 'EARN', 1, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (50, 'points_type', 2, '消耗', 'REDEEM', 2, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (51, 'points_type', 3, '过期', 'EXPIRE', 3, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (52, 'points_type', 4, '调整', 'ADJUSTMENT', 4, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (53, 'coupon_type', 1, '固定金额', 'FIXED', 1, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (54, 'coupon_type', 2, '百分比', 'PERCENT', 2, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (55, 'coupon_type', 3, '兑换券', 'EXCHANGE', 3, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (56, 'coupon_usage_status', 1, '未使用', 'UNUSED', 1, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (57, 'coupon_usage_status', 2, '已使用', 'USED', 2, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (58, 'coupon_usage_status', 3, '已过期', 'EXPIRED', 3, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (59, 'queue_status', 1, '排队中', 'WAITING', 1, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (60, 'queue_status', 2, '已入座', 'SEATED', 2, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (61, 'queue_status', 3, '已取消', 'CANCELLED', 3, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (62, 'queue_status', 4, '已通知', 'NOTIFIED', 4, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (63, 'schedule_type', 1, '上班', 'WORK', 1, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (64, 'schedule_type', 2, '休息', 'OFF', 2, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (65, 'commission_rule_type', 1, '按次', 'PER_SESSION', 1, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (66, 'commission_rule_type', 2, '按流水比例', 'REVENUE_PERCENT', 2, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (67, 'commission_rule_type', 3, '固定金额', 'FIXED', 3, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (68, 'settlement_status', 1, '待结算', 'PENDING', 1, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (69, 'settlement_status', 2, '已发放', 'PAID', 2, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (70, 'notify_recipient_type', 1, '顾客', 'CUSTOMER', 1, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (71, 'notify_recipient_type', 2, '员工', 'STAFF', 2, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (72, 'notify_channel', 1, '微信模板消息', 'WECHAT_TEMPLATE', 1, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (73, 'notify_channel', 2, '短信', 'SMS', 2, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (74, 'notify_channel', 3, '站内信', 'IN_APP', 3, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (75, 'notify_status', 1, '待发送', 'PENDING', 1, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (76, 'notify_status', 2, '已发送', 'SENT', 2, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (77, 'notify_status', 3, '发送失败', 'FAILED', 3, 1, 0, '2026-05-07 15:20:04', '2026-05-07 15:20:04');
INSERT INTO `sys_dicts` VALUES (78, 'merchant_status', 1, '正常', 'NORMAL', 1, 1, 0, '2026-05-08 10:28:43', '2026-05-08 15:47:20');
INSERT INTO `sys_dicts` VALUES (79, 'merchant_status', 2, '已过期', 'EXPIRED', 2, 1, 0, '2026-05-08 10:28:43', '2026-05-08 15:47:20');
INSERT INTO `sys_dicts` VALUES (80, 'merchant_status', 3, '已禁用', 'DISABLED', 3, 1, 0, '2026-05-08 10:28:43', '2026-05-08 15:47:20');
INSERT INTO `sys_dicts` VALUES (81, 'subscription_type', 1, '月付', 'MONTHLY', 1, 1, 0, '2026-05-08 10:28:43', '2026-05-08 10:28:43');
INSERT INTO `sys_dicts` VALUES (82, 'subscription_type', 2, '年付', 'YEARLY', 2, 1, 0, '2026-05-08 10:28:43', '2026-05-08 10:28:43');
INSERT INTO `sys_dicts` VALUES (83, 'subscription_status', 1, '生效中', 'ACTIVE', 1, 1, 0, '2026-05-08 10:28:43', '2026-05-08 10:28:43');
INSERT INTO `sys_dicts` VALUES (84, 'subscription_status', 2, '已过期', 'EXPIRED', 2, 1, 0, '2026-05-08 10:28:43', '2026-05-08 10:28:43');
INSERT INTO `sys_dicts` VALUES (85, 'subscription_status', 3, '已退款', 'REFUNDED', 3, 1, 0, '2026-05-08 10:28:43', '2026-05-08 10:28:43');
INSERT INTO `sys_dicts` VALUES (86, 'feedback_type', 1, '满意度', 'SATISFACTION', 1, 1, 0, '2026-05-08 10:28:43', '2026-05-08 10:28:43');
INSERT INTO `sys_dicts` VALUES (87, 'feedback_type', 2, '建议', 'SUGGESTION', 2, 1, 0, '2026-05-08 10:28:43', '2026-05-08 10:28:43');
INSERT INTO `sys_dicts` VALUES (88, 'feedback_type', 3, '投诉', 'COMPLAINT', 3, 1, 0, '2026-05-08 10:28:43', '2026-05-08 10:28:43');
INSERT INTO `sys_dicts` VALUES (89, 'feedback_type', 4, '其他', 'OTHER', 4, 1, 0, '2026-05-08 10:28:43', '2026-05-08 10:28:43');
INSERT INTO `sys_dicts` VALUES (90, 'feedback_status', 1, '待处理', 'PENDING', 1, 1, 0, '2026-05-08 10:28:43', '2026-05-08 10:28:43');
INSERT INTO `sys_dicts` VALUES (91, 'feedback_status', 2, '已回复', 'REPLIED', 2, 1, 0, '2026-05-08 10:28:43', '2026-05-08 10:28:43');
INSERT INTO `sys_dicts` VALUES (92, 'feedback_status', 3, '已关闭', 'CLOSED', 3, 1, 0, '2026-05-08 10:28:43', '2026-05-08 10:28:43');
INSERT INTO `sys_dicts` VALUES (93, 'article_type', 4, '纯文字', 'TEXT', 4, 1, 0, '2026-05-14 16:26:35', '2026-05-14 16:26:35');
INSERT INTO `sys_dicts` VALUES (94, 'payment_method', 1, '微信支付', 'wechat', 1, 1, 0, '2026-05-14 16:44:26', '2026-05-14 16:44:26');
INSERT INTO `sys_dicts` VALUES (95, 'payment_method', 2, '支付宝', 'alipay', 2, 1, 0, '2026-05-14 16:44:26', '2026-05-14 16:44:26');
INSERT INTO `sys_dicts` VALUES (96, 'payment_method', 3, '银行转账', 'bank', 3, 1, 0, '2026-05-14 16:44:26', '2026-05-14 16:44:26');
INSERT INTO `sys_dicts` VALUES (97, 'payment_method', 4, '现金', 'cash', 4, 1, 0, '2026-05-14 16:44:26', '2026-05-14 16:44:26');
INSERT INTO `sys_dicts` VALUES (98, 'payment_method', 5, '其他', 'other', 5, 1, 0, '2026-05-14 16:44:26', '2026-05-14 16:44:26');
INSERT INTO `sys_dicts` VALUES (99, 'customer_source', 1, '小程序', 'miniapp', 1, 1, 0, '2026-05-20 09:58:27', '2026-05-20 09:58:27');
INSERT INTO `sys_dicts` VALUES (100, 'customer_source', 2, '美团', 'meituan', 2, 1, 0, '2026-05-20 09:58:27', '2026-05-20 09:58:27');
INSERT INTO `sys_dicts` VALUES (101, 'customer_source', 3, '抖音', 'douyin', 3, 1, 0, '2026-05-20 09:58:27', '2026-05-20 09:58:27');
INSERT INTO `sys_dicts` VALUES (102, 'customer_source', 4, '线下', 'offline', 4, 1, 0, '2026-05-20 09:58:27', '2026-05-20 09:58:27');
INSERT INTO `sys_dicts` VALUES (103, 'customer_tag', 1, 'VIP', 'vip', 1, 1, 0, '2026-05-20 13:12:30', '2026-05-20 13:12:30');
INSERT INTO `sys_dicts` VALUES (104, 'customer_tag', 2, '常客', 'regular', 2, 1, 0, '2026-05-20 13:12:30', '2026-05-20 13:12:30');
INSERT INTO `sys_dicts` VALUES (105, 'customer_tag', 3, '亲子', 'family', 3, 1, 0, '2026-05-20 13:12:30', '2026-05-20 13:12:30');
INSERT INTO `sys_dicts` VALUES (106, 'customer_tag', 4, '新客', 'new', 4, 1, 0, '2026-05-20 13:12:30', '2026-05-20 13:12:30');
INSERT INTO `sys_dicts` VALUES (107, 'customer_tag', 5, '大客户', 'big', 5, 1, 0, '2026-05-20 13:12:30', '2026-05-20 13:12:30');
INSERT INTO `sys_dicts` VALUES (108, 'customer_tag', 6, '投诉', 'complaint', 6, 1, 0, '2026-05-20 13:12:30', '2026-05-20 13:12:30');
INSERT INTO `sys_dicts` VALUES (109, 'customer_tag', 7, 'Star', 'star', 7, 1, 5, '2026-05-20 13:43:12', '2026-05-20 13:43:12');
INSERT INTO `sys_dicts` VALUES (110, 'customer_tag', 8, '♥', 'xin', 8, 1, 5, '2026-05-20 13:48:28', '2026-05-20 13:48:28');
INSERT INTO `sys_dicts` VALUES (111, 'material_category', 1, '手工材料', 'handcraft', 1, 1, 0, '2026-05-20 14:42:00', '2026-05-20 14:42:00');
INSERT INTO `sys_dicts` VALUES (112, 'material_category', 2, '绘画用品', 'painting', 2, 1, 0, '2026-05-20 14:42:00', '2026-05-20 14:42:00');
INSERT INTO `sys_dicts` VALUES (113, 'material_category', 3, '工具配件', 'tool_part', 3, 1, 0, '2026-05-20 14:42:00', '2026-05-20 14:42:00');
INSERT INTO `sys_dicts` VALUES (114, 'material_category', 4, '包装材料', 'packaging', 4, 1, 0, '2026-05-20 14:42:00', '2026-05-20 14:42:00');
INSERT INTO `sys_dicts` VALUES (115, 'material_category', 5, '清洁用品', 'cleaning', 5, 1, 0, '2026-05-20 14:42:00', '2026-05-20 14:42:00');
INSERT INTO `sys_dicts` VALUES (116, 'material_category', 6, '其他', 'other', 6, 1, 0, '2026-05-20 14:42:00', '2026-05-20 14:42:00');
INSERT INTO `sys_dicts` VALUES (117, 'material_category', 7, '换新料', 'new', 7, 1, 5, '2026-05-20 14:49:19', '2026-05-20 14:49:19');
INSERT INTO `sys_dicts` VALUES (118, 'purchase_channel', 1, '门店', 'store', 1, 1, 0, '2026-05-21 14:39:00', '2026-05-21 14:39:00');
INSERT INTO `sys_dicts` VALUES (119, 'purchase_channel', 2, '美团', 'meituan', 2, 1, 0, '2026-05-21 14:39:00', '2026-05-21 14:39:00');
INSERT INTO `sys_dicts` VALUES (120, 'purchase_channel', 3, '抖音', 'douyin', 3, 1, 0, '2026-05-21 14:39:00', '2026-05-21 14:39:00');
INSERT INTO `sys_dicts` VALUES (121, 'purchase_channel', 4, '小程序', 'miniapp', 4, 1, 0, '2026-05-21 14:39:00', '2026-05-21 14:39:00');
INSERT INTO `sys_dicts` VALUES (122, 'payment_type', 1, '直接付款', 'direct', 1, 1, 0, '2026-05-21 14:39:14', '2026-05-21 14:39:14');
INSERT INTO `sys_dicts` VALUES (123, 'payment_type', 2, '储值钱包', 'wallet', 2, 1, 0, '2026-05-21 14:39:14', '2026-05-21 14:39:14');
INSERT INTO `sys_dicts` VALUES (124, 'payment_type', 3, '第三方券码', 'coupon', 3, 1, 0, '2026-05-21 14:39:14', '2026-05-21 14:39:14');
INSERT INTO `sys_dicts` VALUES (125, 'payment_method', 6, '储值钱包', 'wallet', 6, 1, 0, '2026-05-21 15:01:43', '2026-05-21 15:01:43');
INSERT INTO `sys_dicts` VALUES (126, 'coupon_use_scene', 1, '购买套餐', 'purchase', 1, 1, 0, '2026-05-23 14:22:23', '2026-05-23 14:22:23');
INSERT INTO `sys_dicts` VALUES (127, 'coupon_use_scene', 2, '充值', 'recharge', 2, 1, 0, '2026-05-23 14:22:24', '2026-05-23 14:22:24');

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
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '钱包交易流水' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of wallet_transactions
-- ----------------------------
INSERT INTO `wallet_transactions` VALUES (1, 3, 5, 3, 1, 100.00, 100.00, NULL, NULL, '手动充值', '2026-05-20 14:01:43', 0, NULL);
INSERT INTO `wallet_transactions` VALUES (2, 2, 5, 2, 1, 200.00, 200.00, NULL, NULL, '手动充值', '2026-05-20 14:06:05', 0, NULL);
INSERT INTO `wallet_transactions` VALUES (3, 3, 5, 3, 2, 99.90, 0.10, 'purchase', NULL, '购买套餐扣款', '2026-05-21 15:00:15', 0, NULL);
INSERT INTO `wallet_transactions` VALUES (4, 1, 5, 14, 1, 200.00, 200.00, NULL, NULL, '充值¥200（优惠抵扣¥20）', '2026-05-23 15:00:20', 0, NULL);
INSERT INTO `wallet_transactions` VALUES (5, 27, 5, 25, 2, -299.00, 101.00, 'purchase', 12, '创意月卡消费', '2026-05-28 10:58:39', 0, NULL);
INSERT INTO `wallet_transactions` VALUES (6, 39, 5, 37, 2, -299.00, 701.00, 'purchase', 21, '创意月卡消费', '2026-05-12 11:15:00', 0, NULL);
INSERT INTO `wallet_transactions` VALUES (7, 39, 5, 37, 2, -29.90, 671.10, 'purchase', 39, 'VIP单次消费', '2026-05-30 10:15:00', 0, NULL);
INSERT INTO `wallet_transactions` VALUES (8, 39, 5, 37, 2, -29.90, 641.20, 'purchase', 53, 'VIP今日消费', '2026-06-09 11:00:00', 0, NULL);

SET FOREIGN_KEY_CHECKS = 1;
