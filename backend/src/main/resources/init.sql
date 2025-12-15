/*
 Navicat Premium Dump SQL

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 50744 (5.7.44)
 Source Host           : localhost:3306
 Source Schema         : wardrobe

 Target Server Type    : MySQL
 Target Server Version : 50744 (5.7.44)
 File Encoding         : 65001

 Date: 15/12/2025 23:57:49
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for activity_logs
-- ----------------------------
DROP TABLE IF EXISTS `activity_logs`;
CREATE TABLE `activity_logs`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `action` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` datetime NULL DEFAULT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `user_id` bigint(20) NULL DEFAULT NULL,
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of activity_logs
-- ----------------------------

-- ----------------------------
-- Table structure for clothing
-- ----------------------------
DROP TABLE IF EXISTS `clothing`;
CREATE TABLE `clothing`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `color` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `size` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `brand` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `price` decimal(10, 2) NULL DEFAULT NULL,
  `material` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `season` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `purchase_date` date NULL DEFAULT NULL,
  `wear_count` int(11) NULL DEFAULT 0,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '在用',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_category`(`category`) USING BTREE,
  INDEX `idx_season`(`season`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE,
  CONSTRAINT `clothing_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 56 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of clothing
-- ----------------------------
INSERT INTO `clothing` VALUES (1, 1, '白色T恤', '上衣', '白色', 'M', 'UNIQLO', 99.00, '棉', '夏', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2024-03-15', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:43:33');
INSERT INTO `clothing` VALUES (2, 1, '黑色牛仔裤', '裤装', '黑色', '28', 'Levis', 299.00, '牛仔布', '四季', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2024-02-20', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:46:39');
INSERT INTO `clothing` VALUES (3, 1, '粉色连衣裙', '裙装', '粉色', 'S', 'ZARA', 399.00, '雪纺', '春', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2024-04-01', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:46:39');
INSERT INTO `clothing` VALUES (4, 1, '蓝色牛仔外套', '外套', '蓝色', 'M', 'GAP', 459.00, '牛仔布', '春', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2024-03-10', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:46:39');
INSERT INTO `clothing` VALUES (5, 1, '白色运动鞋', '鞋履', '白色', '37', 'Nike', 599.00, '皮革+网布', '四季', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2024-01-15', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:46:39');
INSERT INTO `clothing` VALUES (6, 1, '黑色皮包', '配饰', '黑色', '均码', 'Coach', 1299.00, '皮革', '四季', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2024-02-14', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:46:39');
INSERT INTO `clothing` VALUES (7, 1, '条纹T恤', '上衣', '蓝白', 'M', 'H&M', 79.00, '棉', '夏', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2024-05-01', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:46:39');
INSERT INTO `clothing` VALUES (8, 1, '灰色运动裤', '裤装', '灰色', 'M', 'Adidas', 259.00, '涤纶', '四季', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2024-03-20', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:46:39');
INSERT INTO `clothing` VALUES (9, 1, '碎花半身裙', '裙装', '多色', 'S', 'ONLY', 199.00, '棉麻', '夏', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2024-06-01', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:46:39');
INSERT INTO `clothing` VALUES (10, 1, '黑色西装外套', '外套', '黑色', 'S', 'ZARA', 599.00, '涤纶', '四季', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2024-01-20', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:46:39');
INSERT INTO `clothing` VALUES (11, 1, '棕色马丁靴', '鞋履', '棕色', '37', 'Dr.Martens', 1299.00, '皮革', '秋', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2023-10-15', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:46:39');
INSERT INTO `clothing` VALUES (12, 1, '丝巾', '配饰', '红色', '均码', 'Hermes', 2999.00, '真丝', '四季', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2024-03-08', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:46:39');
INSERT INTO `clothing` VALUES (13, 1, '黄色针织衫', '上衣', '黄色', 'M', 'MUJI', 199.00, '羊毛', '秋', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2023-09-15', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:46:39');
INSERT INTO `clothing` VALUES (14, 1, '蓝色牛仔短裤', '裤装', '蓝色', '28', 'Levis', 199.00, '牛仔布', '夏', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2024-05-20', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:46:39');
INSERT INTO `clothing` VALUES (15, 1, '白色蕾丝裙', '裙装', '白色', 'S', 'MiuMiu', 899.00, '蕾丝', '夏', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2024-06-15', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:46:39');
INSERT INTO `clothing` VALUES (16, 1, '米色风衣', '外套', '米色', 'S', 'Burberry', 3999.00, '涤纶', '春', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2024-03-01', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:46:39');
INSERT INTO `clothing` VALUES (17, 1, '黑色高跟鞋', '鞋履', '黑色', '37', 'Jimmy Choo', 2599.00, '皮革', '四季', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2024-02-01', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:46:39');
INSERT INTO `clothing` VALUES (18, 1, '珍珠项链', '配饰', '白色', '均码', 'Mikimoto', 4999.00, '珍珠', '四季', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2024-04-20', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:46:39');
INSERT INTO `clothing` VALUES (19, 1, '粉色毛衣', '上衣', '粉色', 'M', 'UNIQLO', 159.00, '羊毛', '冬', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2023-11-15', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:46:39');
INSERT INTO `clothing` VALUES (20, 1, '黑色阔腿裤', '裤装', '黑色', 'M', 'ZARA', 299.00, '涤纶', '四季', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2024-04-10', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:46:39');
INSERT INTO `clothing` VALUES (21, 1, '红色连衣裙', '裙装', '红色', 'S', 'Dior', 5999.00, '真丝', '春', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2024-05-01', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:46:39');
INSERT INTO `clothing` VALUES (22, 1, '黑色羽绒服', '外套', '黑色', 'S', 'Canada Goose', 7999.00, '羽绒', '冬', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2023-11-01', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:46:39');
INSERT INTO `clothing` VALUES (23, 1, '灰色帆布鞋', '鞋履', '灰色', '37', 'Converse', 399.00, '帆布', '四季', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2024-03-25', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:46:39');
INSERT INTO `clothing` VALUES (24, 1, '太阳镜', '配饰', '黑色', '均码', 'Ray-Ban', 999.00, '金属+塑料', '夏', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2024-06-01', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:46:39');
INSERT INTO `clothing` VALUES (25, 1, '白色衬衫', '上衣', '白色', 'M', 'COS', 399.00, '棉', '四季', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2024-02-15', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:46:39');
INSERT INTO `clothing` VALUES (26, 1, '蓝色休闲裤', '裤装', '蓝色', 'M', 'MUJI', 199.00, '棉', '春', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2024-03-30', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:46:39');
INSERT INTO `clothing` VALUES (27, 1, '紫色百褶裙', '裙装', '紫色', 'S', 'ONLY', 259.00, '雪纺', '春', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2024-04-15', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:46:39');
INSERT INTO `clothing` VALUES (28, 1, '驼色大衣', '外套', '驼色', 'S', 'MaxMara', 9999.00, '羊毛', '冬', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2023-12-01', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:46:39');
INSERT INTO `clothing` VALUES (29, 1, '小白鞋', '鞋履', '白色', '37', 'Adidas', 549.00, '皮革', '四季', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2024-04-01', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:46:39');
INSERT INTO `clothing` VALUES (30, 1, '手表', '配饰', '银色', '均码', 'Cartier', 29999.00, '不锈钢', '四季', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2024-01-01', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:46:39');
INSERT INTO `clothing` VALUES (31, 2, '黑色T恤', '上衣', '黑色', 'L', 'UNIQLO', 89.00, '棉', '夏', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2024-04-01', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:46:39');
INSERT INTO `clothing` VALUES (32, 2, '蓝色牛仔裤', '裤装', '蓝色', '30', 'Levis', 329.00, '牛仔布', '四季', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2024-03-15', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:46:39');
INSERT INTO `clothing` VALUES (33, 2, '格子衬衫', '上衣', '蓝白', 'L', 'MUJI', 159.00, '棉', '秋', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2023-09-20', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:46:39');
INSERT INTO `clothing` VALUES (34, 2, '灰色卫衣', '上衣', '灰色', 'L', 'Nike', 299.00, '棉', '春', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2024-03-01', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:46:39');
INSERT INTO `clothing` VALUES (35, 2, '黑色运动裤', '裤装', '黑色', 'L', 'Adidas', 229.00, '涤纶', '四季', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2024-02-20', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:46:39');
INSERT INTO `clothing` VALUES (36, 2, '蓝色羽绒服', '外套', '蓝色', 'L', 'The North Face', 1299.00, '羽绒', '冬', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2023-11-15', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:46:39');
INSERT INTO `clothing` VALUES (37, 2, '黑色皮鞋', '鞋履', '黑色', '42', 'Clarks', 799.00, '皮革', '四季', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2024-01-10', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:46:39');
INSERT INTO `clothing` VALUES (38, 2, '棒球帽', '配饰', '黑色', '均码', 'New Era', 199.00, '棉', '夏', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2024-05-01', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:46:39');
INSERT INTO `clothing` VALUES (39, 2, '白色Polo衫', '上衣', '白色', 'L', 'Lacoste', 599.00, '棉', '夏', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2024-06-01', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:46:39');
INSERT INTO `clothing` VALUES (40, 2, '卡其色休闲裤', '裤装', '卡其色', 'L', 'MUJI', 199.00, '棉', '春', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2024-04-10', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:46:39');
INSERT INTO `clothing` VALUES (41, 2, '黑色夹克', '外套', '黑色', 'L', 'ZARA', 499.00, '皮革', '春', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2024-03-20', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:46:39');
INSERT INTO `clothing` VALUES (42, 2, '白色运动鞋', '鞋履', '白色', '42', 'New Balance', 699.00, '网布', '四季', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2024-04-15', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:46:39');
INSERT INTO `clothing` VALUES (43, 2, '腰带', '配饰', '黑色', '均码', 'Hugo Boss', 599.00, '皮革', '四季', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2024-02-14', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:46:39');
INSERT INTO `clothing` VALUES (44, 2, '灰色毛衣', '上衣', '灰色', 'L', 'UNIQLO', 199.00, '羊毛', '冬', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2023-11-20', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:46:39');
INSERT INTO `clothing` VALUES (45, 2, '深蓝色牛仔外套', '外套', '深蓝', 'L', 'Levis', 599.00, '牛仔布', '春', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2024-03-25', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:46:39');
INSERT INTO `clothing` VALUES (46, 3, '粉色卫衣', '上衣', '粉色', 'M', 'H&M', 159.00, '棉', '春', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2024-03-15', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:46:39');
INSERT INTO `clothing` VALUES (47, 3, '白色短裤', '裤装', '白色', 'S', 'ZARA', 149.00, '棉', '夏', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2024-05-20', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:46:39');
INSERT INTO `clothing` VALUES (48, 3, '碎花连衣裙', '裙装', '多色', 'M', 'ONLY', 299.00, '雪纺', '夏', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2024-06-10', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:46:39');
INSERT INTO `clothing` VALUES (49, 3, '牛仔外套', '外套', '蓝色', 'M', 'GAP', 399.00, '牛仔布', '春', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2024-04-01', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:46:39');
INSERT INTO `clothing` VALUES (50, 3, '白色板鞋', '鞋履', '白色', '37', 'Vans', 399.00, '帆布', '四季', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2024-03-20', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:46:39');
INSERT INTO `clothing` VALUES (51, 3, '草帽', '配饰', '米色', '均码', 'MUJI', 99.00, '草编', '夏', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2024-06-01', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:46:39');
INSERT INTO `clothing` VALUES (52, 3, '黄色T恤', '上衣', '黄色', 'M', 'UNIQLO', 79.00, '棉', '夏', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2024-05-15', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:46:39');
INSERT INTO `clothing` VALUES (53, 3, '蓝色牛仔裤', '裤装', '蓝色', '27', 'H&M', 199.00, '牛仔布', '四季', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2024-04-10', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:46:39');
INSERT INTO `clothing` VALUES (54, 3, '红色风衣', '外套', '红色', 'M', 'ZARA', 699.00, '涤纶', '春', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2024-03-01', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:46:39');
INSERT INTO `clothing` VALUES (55, 3, '运动鞋', '鞋履', '粉色', '37', 'Puma', 459.00, '网布', '四季', '/api/uploads/f4edb66d-602f-4489-9a85-4319a9e41e6e.jpg', '2024-04-20', 0, '在用', '2025-12-15 20:31:22', '2025-12-15 23:46:39');

-- ----------------------------
-- Table structure for clothing_tags
-- ----------------------------
DROP TABLE IF EXISTS `clothing_tags`;
CREATE TABLE `clothing_tags`  (
  `clothing_id` bigint(20) NOT NULL,
  `tag` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`clothing_id`, `tag`) USING BTREE,
  CONSTRAINT `clothing_tags_ibfk_1` FOREIGN KEY (`clothing_id`) REFERENCES `clothing` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of clothing_tags
-- ----------------------------

-- ----------------------------
-- Table structure for outfit_clothing
-- ----------------------------
DROP TABLE IF EXISTS `outfit_clothing`;
CREATE TABLE `outfit_clothing`  (
  `outfit_id` bigint(20) NOT NULL,
  `clothing_id` bigint(20) NOT NULL,
  PRIMARY KEY (`outfit_id`, `clothing_id`) USING BTREE,
  INDEX `clothing_id`(`clothing_id`) USING BTREE,
  CONSTRAINT `outfit_clothing_ibfk_1` FOREIGN KEY (`outfit_id`) REFERENCES `outfits` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `outfit_clothing_ibfk_2` FOREIGN KEY (`clothing_id`) REFERENCES `clothing` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of outfit_clothing
-- ----------------------------
INSERT INTO `outfit_clothing` VALUES (4, 1);
INSERT INTO `outfit_clothing` VALUES (3, 2);
INSERT INTO `outfit_clothing` VALUES (1, 3);
INSERT INTO `outfit_clothing` VALUES (1, 4);
INSERT INTO `outfit_clothing` VALUES (1, 5);
INSERT INTO `outfit_clothing` VALUES (3, 5);
INSERT INTO `outfit_clothing` VALUES (6, 5);
INSERT INTO `outfit_clothing` VALUES (3, 7);
INSERT INTO `outfit_clothing` VALUES (6, 8);
INSERT INTO `outfit_clothing` VALUES (6, 13);
INSERT INTO `outfit_clothing` VALUES (4, 14);
INSERT INTO `outfit_clothing` VALUES (2, 17);
INSERT INTO `outfit_clothing` VALUES (5, 17);
INSERT INTO `outfit_clothing` VALUES (5, 18);
INSERT INTO `outfit_clothing` VALUES (2, 20);
INSERT INTO `outfit_clothing` VALUES (5, 21);
INSERT INTO `outfit_clothing` VALUES (4, 23);
INSERT INTO `outfit_clothing` VALUES (2, 25);
INSERT INTO `outfit_clothing` VALUES (9, 31);
INSERT INTO `outfit_clothing` VALUES (9, 32);
INSERT INTO `outfit_clothing` VALUES (12, 32);
INSERT INTO `outfit_clothing` VALUES (12, 33);
INSERT INTO `outfit_clothing` VALUES (10, 34);
INSERT INTO `outfit_clothing` VALUES (10, 35);
INSERT INTO `outfit_clothing` VALUES (11, 37);
INSERT INTO `outfit_clothing` VALUES (12, 37);
INSERT INTO `outfit_clothing` VALUES (11, 39);
INSERT INTO `outfit_clothing` VALUES (11, 40);
INSERT INTO `outfit_clothing` VALUES (9, 42);
INSERT INTO `outfit_clothing` VALUES (10, 42);
INSERT INTO `outfit_clothing` VALUES (13, 46);
INSERT INTO `outfit_clothing` VALUES (13, 47);
INSERT INTO `outfit_clothing` VALUES (14, 48);
INSERT INTO `outfit_clothing` VALUES (13, 50);
INSERT INTO `outfit_clothing` VALUES (14, 50);
INSERT INTO `outfit_clothing` VALUES (14, 51);
INSERT INTO `outfit_clothing` VALUES (15, 52);
INSERT INTO `outfit_clothing` VALUES (15, 53);
INSERT INTO `outfit_clothing` VALUES (15, 55);

-- ----------------------------
-- Table structure for outfits
-- ----------------------------
DROP TABLE IF EXISTS `outfits`;
CREATE TABLE `outfits`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `occasion` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_occasion`(`occasion`) USING BTREE,
  CONSTRAINT `outfits_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of outfits
-- ----------------------------
INSERT INTO `outfits` VALUES (1, 1, '春日约会', '约会', '温柔淑女风，适合春天户外约会', '2025-12-15 20:31:22', '2025-12-15 20:31:22');
INSERT INTO `outfits` VALUES (2, 1, '职场通勤', '工作', '简约大方，适合日常办公', '2025-12-15 20:31:22', '2025-12-15 20:31:22');
INSERT INTO `outfits` VALUES (3, 1, '周末休闲', '休闲', '舒适自在，适合周末逛街', '2025-12-15 20:31:22', '2025-12-15 20:31:22');
INSERT INTO `outfits` VALUES (4, 1, '夏日清新', '日常', '清爽透气，适合夏天日常穿搭', '2025-12-15 20:31:22', '2025-12-15 20:31:22');
INSERT INTO `outfits` VALUES (5, 1, '正式晚宴', '正式', '优雅大气，适合正式场合', '2025-12-15 20:31:22', '2025-12-15 20:31:22');
INSERT INTO `outfits` VALUES (6, 1, '运动健身', '运动', '舒适透气，适合健身房', '2025-12-15 20:31:22', '2025-12-15 20:31:22');
INSERT INTO `outfits` VALUES (9, 2, '休闲周末', '休闲', '简约舒适，适合周末放松', '2025-12-15 20:31:22', '2025-12-15 20:31:22');
INSERT INTO `outfits` VALUES (10, 2, '运动风', '运动', '活力十足，适合户外运动', '2025-12-15 20:31:22', '2025-12-15 20:31:22');
INSERT INTO `outfits` VALUES (11, 2, '商务出行', '工作', '稳重大方，适合商务场合', '2025-12-15 20:31:22', '2025-12-15 20:31:22');
INSERT INTO `outfits` VALUES (12, 2, '日常通勤', '日常', '简单实用，适合每天上班', '2025-12-15 20:31:22', '2025-12-15 20:31:22');
INSERT INTO `outfits` VALUES (13, 3, '少女风', '日常', '可爱甜美，适合日常穿搭', '2025-12-15 20:31:22', '2025-12-15 20:31:22');
INSERT INTO `outfits` VALUES (14, 3, '度假风', '休闲', '清新自然，适合海边度假', '2025-12-15 20:31:22', '2025-12-15 20:31:22');
INSERT INTO `outfits` VALUES (15, 3, '街头潮流', '休闲', '时尚个性，适合街拍', '2025-12-15 20:31:22', '2025-12-15 20:31:22');

-- ----------------------------
-- Table structure for travel_clothing
-- ----------------------------
DROP TABLE IF EXISTS `travel_clothing`;
CREATE TABLE `travel_clothing`  (
  `travel_plan_id` bigint(20) NOT NULL,
  `clothing_id` bigint(20) NOT NULL,
  PRIMARY KEY (`travel_plan_id`, `clothing_id`) USING BTREE,
  INDEX `clothing_id`(`clothing_id`) USING BTREE,
  CONSTRAINT `travel_clothing_ibfk_1` FOREIGN KEY (`travel_plan_id`) REFERENCES `travel_plans` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `travel_clothing_ibfk_2` FOREIGN KEY (`clothing_id`) REFERENCES `clothing` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of travel_clothing
-- ----------------------------
INSERT INTO `travel_clothing` VALUES (1, 1);
INSERT INTO `travel_clothing` VALUES (3, 2);
INSERT INTO `travel_clothing` VALUES (4, 2);
INSERT INTO `travel_clothing` VALUES (1, 3);
INSERT INTO `travel_clothing` VALUES (1, 5);
INSERT INTO `travel_clothing` VALUES (4, 5);
INSERT INTO `travel_clothing` VALUES (2, 6);
INSERT INTO `travel_clothing` VALUES (4, 6);
INSERT INTO `travel_clothing` VALUES (1, 7);
INSERT INTO `travel_clothing` VALUES (2, 10);
INSERT INTO `travel_clothing` VALUES (5, 10);
INSERT INTO `travel_clothing` VALUES (3, 11);
INSERT INTO `travel_clothing` VALUES (4, 13);
INSERT INTO `travel_clothing` VALUES (1, 14);
INSERT INTO `travel_clothing` VALUES (1, 15);
INSERT INTO `travel_clothing` VALUES (4, 16);
INSERT INTO `travel_clothing` VALUES (2, 17);
INSERT INTO `travel_clothing` VALUES (5, 17);
INSERT INTO `travel_clothing` VALUES (3, 19);
INSERT INTO `travel_clothing` VALUES (2, 20);
INSERT INTO `travel_clothing` VALUES (5, 20);
INSERT INTO `travel_clothing` VALUES (3, 22);
INSERT INTO `travel_clothing` VALUES (1, 23);
INSERT INTO `travel_clothing` VALUES (1, 24);
INSERT INTO `travel_clothing` VALUES (2, 25);
INSERT INTO `travel_clothing` VALUES (5, 25);
INSERT INTO `travel_clothing` VALUES (5, 28);
INSERT INTO `travel_clothing` VALUES (3, 29);
INSERT INTO `travel_clothing` VALUES (6, 31);
INSERT INTO `travel_clothing` VALUES (6, 32);
INSERT INTO `travel_clothing` VALUES (6, 34);
INSERT INTO `travel_clothing` VALUES (8, 34);
INSERT INTO `travel_clothing` VALUES (8, 35);
INSERT INTO `travel_clothing` VALUES (8, 36);
INSERT INTO `travel_clothing` VALUES (7, 37);
INSERT INTO `travel_clothing` VALUES (6, 38);
INSERT INTO `travel_clothing` VALUES (8, 38);
INSERT INTO `travel_clothing` VALUES (7, 39);
INSERT INTO `travel_clothing` VALUES (7, 40);
INSERT INTO `travel_clothing` VALUES (7, 41);
INSERT INTO `travel_clothing` VALUES (6, 42);
INSERT INTO `travel_clothing` VALUES (8, 42);
INSERT INTO `travel_clothing` VALUES (7, 43);
INSERT INTO `travel_clothing` VALUES (9, 46);
INSERT INTO `travel_clothing` VALUES (9, 47);
INSERT INTO `travel_clothing` VALUES (9, 48);
INSERT INTO `travel_clothing` VALUES (10, 48);
INSERT INTO `travel_clothing` VALUES (10, 49);
INSERT INTO `travel_clothing` VALUES (9, 50);
INSERT INTO `travel_clothing` VALUES (10, 50);
INSERT INTO `travel_clothing` VALUES (9, 51);
INSERT INTO `travel_clothing` VALUES (10, 51);
INSERT INTO `travel_clothing` VALUES (10, 53);

-- ----------------------------
-- Table structure for travel_plans
-- ----------------------------
DROP TABLE IF EXISTS `travel_plans`;
CREATE TABLE `travel_plans`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `destination` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `start_date` date NULL DEFAULT NULL,
  `end_date` date NULL DEFAULT NULL,
  `travel_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_start_date`(`start_date`) USING BTREE,
  CONSTRAINT `travel_plans_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of travel_plans
-- ----------------------------
INSERT INTO `travel_plans` VALUES (1, 1, '三亚海滨度假', '三亚', '2024-07-01', '2024-07-07', '度假休闲', '海滨度假，需要泳装和防晒用品', '2025-12-15 20:31:22', '2025-12-15 20:31:22');
INSERT INTO `travel_plans` VALUES (2, 1, '上海商务出差', '上海', '2024-08-15', '2024-08-18', '商务出差', '参加行业展会，需要正装', '2025-12-15 20:31:22', '2025-12-15 20:31:22');
INSERT INTO `travel_plans` VALUES (3, 1, '西藏徒步之旅', '西藏', '2024-09-10', '2024-09-20', '探险运动', '高原徒步，需要保暖衣物和登山鞋', '2025-12-15 20:31:22', '2025-12-15 20:31:22');
INSERT INTO `travel_plans` VALUES (4, 1, '东京赏枫之旅', '日本东京', '2024-10-01', '2024-10-07', '度假休闲', '秋季赏枫，需要舒适的步行鞋', '2025-12-15 20:31:22', '2025-12-15 20:31:22');
INSERT INTO `travel_plans` VALUES (5, 1, '北京客户拜访', '北京', '2024-11-10', '2024-11-13', '商务出差', '客户拜访，需要商务装', '2025-12-15 20:31:22', '2025-12-15 20:31:22');
INSERT INTO `travel_plans` VALUES (6, 2, '成都美食之旅', '成都', '2024-07-15', '2024-07-20', '度假休闲', '美食之旅，休闲装为主', '2025-12-15 20:31:22', '2025-12-15 20:31:22');
INSERT INTO `travel_plans` VALUES (7, 2, '深圳技术交流', '深圳', '2024-08-05', '2024-08-08', '商务出差', '技术交流会，商务休闲装', '2025-12-15 20:31:22', '2025-12-15 20:31:22');
INSERT INTO `travel_plans` VALUES (8, 2, '黄山登山', '黄山', '2024-09-15', '2024-09-18', '探险运动', '登山旅行，需要运动装备', '2025-12-15 20:31:22', '2025-12-15 20:31:22');
INSERT INTO `travel_plans` VALUES (9, 3, '厦门海岛游', '厦门', '2024-07-20', '2024-07-25', '度假休闲', '海岛游玩，需要夏装和泳衣', '2025-12-15 20:31:22', '2025-12-15 20:31:22');
INSERT INTO `travel_plans` VALUES (10, 3, '丽江古城游', '丽江', '2024-08-10', '2024-08-15', '度假休闲', '古城游览，文艺风服装', '2025-12-15 20:31:22', '2025-12-15 20:31:22');

-- ----------------------------
-- Table structure for user_roles
-- ----------------------------
DROP TABLE IF EXISTS `user_roles`;
CREATE TABLE `user_roles`  (
  `user_id` bigint(20) NOT NULL,
  `role` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`user_id`, `role`) USING BTREE,
  CONSTRAINT `user_roles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_roles
-- ----------------------------
INSERT INTO `user_roles` VALUES (1, 'ROLE_ADMIN');
INSERT INTO `user_roles` VALUES (1, 'ROLE_USER');
INSERT INTO `user_roles` VALUES (2, 'ROLE_USER');
INSERT INTO `user_roles` VALUES (3, 'ROLE_USER');

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `avatar_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username`) USING BTREE,
  UNIQUE INDEX `email`(`email`) USING BTREE,
  INDEX `idx_username`(`username`) USING BTREE,
  INDEX `idx_email`(`email`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (1, 'admin', 'admin@wardrobe.com', '$2a$10$yV6AlKJ0nlswjl.KaRmsoOTR2f3DFYDj1.1Sja0UTtPthXe.KOfUC', NULL, '2025-12-15 20:31:22', '2025-12-15 23:55:54');
INSERT INTO `users` VALUES (2, 'zhangsan', 'zhangsan@example.com', '$2a$10$Un3VidCDB6cUYQ7n4GNeRutFzGIi/1Ikh3zDpUatdc30u7sk3DjcC', NULL, '2025-12-15 20:31:22', '2025-12-15 20:31:22');
INSERT INTO `users` VALUES (3, 'lisi', 'lisi@example.com', '$2a$10$Un3VidCDB6cUYQ7n4GNeRutFzGIi/1Ikh3zDpUatdc30u7sk3DjcC', NULL, '2025-12-15 20:31:22', '2025-12-15 20:31:22');

SET FOREIGN_KEY_CHECKS = 1;
