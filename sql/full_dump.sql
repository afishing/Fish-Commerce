-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: localhost    Database: fish_user
-- ------------------------------------------------------
-- Server version	8.0.45

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `fish_user`
--

/*!40000 DROP DATABASE IF EXISTS `fish_user`*/;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `fish_user` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `fish_user`;

--
-- Table structure for table `address`
--

DROP TABLE IF EXISTS `address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `address` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '地址ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `receiver_name` varchar(50) NOT NULL COMMENT '收货人姓名',
  `receiver_phone` varchar(20) NOT NULL COMMENT '收货人电话',
  `province` varchar(50) NOT NULL COMMENT '省份',
  `city` varchar(50) NOT NULL COMMENT '城市',
  `district` varchar(50) NOT NULL COMMENT '区县',
  `detail` varchar(255) NOT NULL COMMENT '详细地址',
  `is_default` tinyint DEFAULT '0' COMMENT '是否默认 0-否 1-是',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint DEFAULT '0' COMMENT '逻辑删除 0-未删除 1-已删除',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='收货地址表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `address`
--

LOCK TABLES `address` WRITE;
/*!40000 ALTER TABLE `address` DISABLE KEYS */;
INSERT INTO `address` VALUES (1,2,'yang','13256966321','sdg','sdg','s','sffbsb',1,'2026-03-16 14:41:48','2026-03-16 14:42:16',0),(2,2,'sdg','16589632458','dgn','dn','dn','dnd',0,'2026-03-16 14:42:11','2026-03-16 14:42:16',0);
/*!40000 ALTER TABLE `address` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(50) NOT NULL COMMENT '用户名',
  `password` varchar(100) NOT NULL COMMENT '密码',
  `nickname` varchar(50) DEFAULT NULL COMMENT '昵称',
  `email` varchar(100) DEFAULT NULL COMMENT '邮箱',
  `phone` varchar(20) DEFAULT NULL COMMENT '手机号',
  `gender` tinyint DEFAULT '2' COMMENT '性别 0-男 1-女 2-保密',
  `avatar` varchar(255) DEFAULT NULL COMMENT '头像',
  `birthday` date DEFAULT NULL COMMENT '生日',
  `level` int DEFAULT '0' COMMENT '会员等级',
  `vip_expire_time` datetime DEFAULT NULL COMMENT '会员到期时间',
  `status` tinyint DEFAULT '0' COMMENT '状态 0-正常 1-禁用',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint DEFAULT '0' COMMENT '逻辑删除 0-未删除 1-已删除',
  `role` int DEFAULT '0' COMMENT '角色 0-普通用户 1-管理员',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'admin','123456','钓鱼达人','admin@afishing.com','13812345678',0,'/uploads/profiles/008c2236-151b-4baa-8885-d8c7f5945c86.jpg',NULL,3,NULL,0,'2026-03-16 14:40:04','2026-03-22 22:08:15',0,1),(2,'user1','123456','海鲜爱好者','user1@example.com','13912345678',1,'/uploads/3a6b96cd-c5bd-4409-b4b4-a3959fe9333b.jpg','2026-02-28',3,'2030-07-30 16:03:59',0,'2026-03-16 14:40:04','2026-03-22 22:08:15',0,0),(3,'user2','123456','美食家','user2@example.com','13712345678',0,'/uploads/profiles/1784ff87-595c-428f-93c0-9dc0a4a4aa5c.jpg',NULL,2,NULL,0,'2026-03-16 14:40:04','2026-03-22 22:08:15',0,0),(4,'user3','123456','吃货小王','user3@example.com','13612345678',0,'/uploads/profiles/1c8682a2-d2fc-4c74-92bf-89beb03c7554.jpg',NULL,0,NULL,1,'2026-03-16 14:40:04','2026-03-22 22:08:15',0,0),(5,'user4','123456','厨房达人','user4@example.com','13512345678',1,'/uploads/profiles/31d285dd-695f-437a-af96-e699c7735198.jpg',NULL,1,NULL,0,'2026-03-16 14:40:04','2026-03-22 22:08:15',0,0),(6,'user5','123456','海鲜控','user5@example.com','13412345678',0,'/uploads/profiles/356cb00e-273b-4857-bb60-e80f05e70d5f.jpg',NULL,2,NULL,1,'2026-03-16 14:40:04','2026-03-22 22:08:15',0,0),(7,'user6','123456','美食探店','user6@example.com','13312345678',1,'/uploads/profiles/424f7ba1-1cf1-4e41-b16d-fd9f278b4332.jpg',NULL,0,NULL,0,'2026-03-16 14:40:04','2026-03-22 22:08:15',0,0),(8,'user7','123456','鱼虾蟹爱好者','user7@example.com','13212345678',0,'/uploads/profiles/45f018ee-8310-4c3b-97de-3bedb4040dce.jpg',NULL,1,NULL,0,'2026-03-16 14:40:04','2026-03-22 22:08:15',0,0),(9,'user8','123456','海鲜批发商','user8@example.com','13112345678',0,'/uploads/profiles/47aa8834-b26e-4b66-8173-4d7b038bdddf.jpg',NULL,3,NULL,1,'2026-03-16 14:40:04','2026-03-22 22:08:15',0,0),(10,'user9','123456','家庭主妇','user9@example.com','13012345678',1,'/uploads/profiles/609b0739-ac85-4c08-8f0b-045721ecb494.jpg',NULL,1,NULL,1,'2026-03-16 14:40:04','2026-03-22 22:08:15',0,0),(11,'user10','123456','餐厅老板','user10@example.com','13811111111',0,'/uploads/profiles/67fc62f4-5c0c-4608-b2bb-7cedaec9d713.jpg',NULL,2,NULL,0,'2026-03-16 14:40:04','2026-03-22 22:08:15',0,0),(12,'user11','123456','美食博主','user11@example.com','13822222222',1,'/uploads/profiles/713f0959-d0b3-475d-ae2c-c69d84567843.jpg',NULL,2,NULL,0,'2026-03-16 14:40:04','2026-03-22 22:08:15',0,0),(13,'user12','123456','海鲜新手','user12@example.com','13833333333',0,'/uploads/profiles/71eebadb-ba67-462a-9157-413c0fd327d9.jpg',NULL,0,NULL,1,'2026-03-16 14:40:04','2026-03-22 22:08:15',0,0),(14,'user13','123456','资深吃货','user13@example.com','13844444444',0,'/uploads/profiles/79eb9d8e-1248-44bd-8213-fd584425781e.jpg',NULL,3,NULL,0,'2026-03-16 14:40:04','2026-03-22 22:08:15',0,0),(15,'user14','123456','海鲜达人','user14@example.com','13855555555',1,'/uploads/profiles/8e64f325-49e7-4cf0-bac2-6ca4cc67d031.jpg',NULL,1,NULL,1,'2026-03-16 14:40:04','2026-03-22 22:08:15',0,0),(16,'user15','123456','料理高手','user15@example.com','13866666666',0,'/uploads/profiles/9adae37b-0522-4050-b59e-a0dc5538f1a2.jpg',NULL,2,NULL,0,'2026-03-16 14:40:04','2026-03-22 22:08:15',0,0),(17,'user16','123456','海鲜批发','user16@example.com','13877777777',0,'/uploads/profiles/9c85492a-062f-4b2e-a72f-8c695e5f3854.jpg',NULL,3,NULL,1,'2026-03-16 14:40:04','2026-03-22 22:08:15',0,0),(18,'user17','123456','美食猎人','user17@example.com','13888888888',1,'/uploads/profiles/9eb28d8c-a311-4428-b1db-7d8d110d0bdb.jpg',NULL,1,NULL,0,'2026-03-16 14:40:04','2026-03-22 22:08:15',0,0),(19,'user18','123456','海味轩','user18@example.com','13899999999',0,'/uploads/profiles/008c2236-151b-4baa-8885-d8c7f5945c86.jpg',NULL,2,NULL,0,'2026-03-16 14:40:04','2026-03-22 22:08:15',0,0),(20,'user19','123456','渔港人家','user19@example.com','13800000000',0,'/uploads/profiles/0a959090-5383-480f-bd94-07ced92f5257.jpg',NULL,0,NULL,0,'2026-03-16 14:40:04','2026-03-22 22:08:15',0,0),(22,'afishing','wsp0222.','afishing','2796233097@qq.com','15528270575',2,'/uploads/profiles/4c343281-b7d8-4f6c-a637-09cfdbffe3e3.jpg','2026-03-09',2,'2026-06-30 16:05:13',0,'2026-03-24 15:00:02','2026-03-24 15:00:02',0,0),(23,'afishing2','wsp0222.','afishing2','2796233097@qq.com','15528270575',2,NULL,NULL,0,NULL,1,'2026-04-07 12:50:36','2026-04-07 12:50:36',0,0);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_coupon`
--

DROP TABLE IF EXISTS `user_coupon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_coupon` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `coupon_id` bigint NOT NULL COMMENT '优惠券ID',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '状态 0-未使用 1-已使用 2-已过期',
  `receive_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '领取时间',
  `use_time` datetime DEFAULT NULL COMMENT '使用时间',
  `order_id` bigint DEFAULT NULL COMMENT '关联订单ID',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_coupon_id` (`coupon_id`),
  KEY `idx_status` (`status`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户优惠券关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_coupon`
--

LOCK TABLES `user_coupon` WRITE;
/*!40000 ALTER TABLE `user_coupon` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_coupon` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Current Database: `fish_product`
--

/*!40000 DROP DATABASE IF EXISTS `fish_product`*/;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `fish_product` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `fish_product`;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `name` varchar(50) NOT NULL COMMENT '分类名称',
  `icon` varchar(50) DEFAULT NULL COMMENT '分类图标(emoji)',
  `sort` int DEFAULT '0' COMMENT '排序(越小越靠前)',
  `status` tinyint DEFAULT '1' COMMENT '状态 0-禁用 1-启用',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品分类表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES (1,'饮料','🥤',1,1,'2026-03-23 23:33:35','2026-04-18 18:12:10',0),(2,'白酒','🍺',2,1,'2026-03-23 23:33:35','2026-04-18 18:13:42',0),(3,'零食','🍟',3,1,'2026-03-23 23:33:35','2026-04-18 18:14:31',0),(4,'肉类','🥩',4,1,'2026-03-23 23:33:35','2026-04-18 18:14:42',0),(5,'水果','🍎',5,1,'2026-03-23 23:33:35','2026-04-18 18:14:53',0),(6,'洗发水','🚿',6,1,'2026-03-24 20:16:15','2026-04-18 18:16:02',0),(7,'蔬菜','🥦',7,1,'2026-03-31 10:30:21','2026-04-18 18:16:53',0);
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `coupon`
--

DROP TABLE IF EXISTS `coupon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `coupon` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` varchar(100) NOT NULL COMMENT '优惠券名称',
  `type` tinyint NOT NULL DEFAULT '1' COMMENT '优惠券类型 1-满减券 2-折扣券 3-无门槛券',
  `value` decimal(10,2) NOT NULL COMMENT '优惠值',
  `min_amount` decimal(10,2) DEFAULT '0.00' COMMENT '最低消费金额',
  `total_count` int NOT NULL DEFAULT '100' COMMENT '发放总量',
  `received_count` int NOT NULL DEFAULT '0' COMMENT '已领取数量',
  `limit_per_user` int NOT NULL DEFAULT '1' COMMENT '每人限领数量',
  `start_time` datetime NOT NULL COMMENT '有效期开始时间',
  `end_time` datetime NOT NULL COMMENT '有效期结束时间',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态 0-禁用 1-启用',
  `product_ids` varchar(500) DEFAULT NULL COMMENT '适用商品ID列表',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `member_levels` varchar(100) DEFAULT NULL COMMENT '适用会员等级（逗号分隔，为空表示所有用户）',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='优惠券表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coupon`
--

LOCK TABLES `coupon` WRITE;
/*!40000 ALTER TABLE `coupon` DISABLE KEYS */;
/*!40000 ALTER TABLE `coupon` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gallery_image`
--

DROP TABLE IF EXISTS `gallery_image`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gallery_image` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `filename` varchar(255) NOT NULL COMMENT '存储文件名',
  `original_name` varchar(255) DEFAULT NULL COMMENT '原始文件名',
  `url` varchar(255) NOT NULL COMMENT '访问路径',
  `size` bigint DEFAULT '0' COMMENT '文件大小（字节）',
  `mime_type` varchar(100) DEFAULT NULL COMMENT '文件MIME类型',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注/描述',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '上传时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint DEFAULT '0' COMMENT '逻辑删除 0-正常 1-已删除',
  PRIMARY KEY (`id`),
  KEY `idx_create_time` (`create_time` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='图库图片表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gallery_image`
--

LOCK TABLES `gallery_image` WRITE;
/*!40000 ALTER TABLE `gallery_image` DISABLE KEYS */;
INSERT INTO `gallery_image` VALUES (1,'3a6b96cd-c5bd-4409-b4b4-a3959fe9333b.jpg','雨爱-封面.jpg','/uploads/3a6b96cd-c5bd-4409-b4b4-a3959fe9333b.jpg',43714,NULL,NULL,'2026-04-06 16:58:09','2026-04-06 16:58:09',0);
/*!40000 ALTER TABLE `gallery_image` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notice`
--

DROP TABLE IF EXISTS `notice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notice` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `title` varchar(200) NOT NULL COMMENT '公告标题',
  `content` text NOT NULL COMMENT '公告内容',
  `type` tinyint DEFAULT '1' COMMENT '公告类型：1-系统公告 2-活动公告 3-其他',
  `status` tinyint DEFAULT '1' COMMENT '状态：0-禁用 1-启用',
  `sort_order` int DEFAULT '0' COMMENT '排序',
  `start_time` datetime DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '结束时间',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint DEFAULT '0' COMMENT '逻辑删除 0-正常 1-已删除',
  PRIMARY KEY (`id`),
  KEY `idx_end_time` (`end_time`),
  KEY `idx_sort_order` (`sort_order`),
  KEY `idx_start_time` (`start_time`),
  KEY `idx_status` (`status`),
  KEY `idx_type` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='公告表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notice`
--

LOCK TABLES `notice` WRITE;
/*!40000 ALTER TABLE `notice` DISABLE KEYS */;
INSERT INTO `notice` VALUES (1,'1','1',1,1,1,NULL,NULL,'2026-04-03 21:00:37','2026-04-03 21:00:37',0);
/*!40000 ALTER TABLE `notice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '商品ID',
  `name` varchar(100) NOT NULL COMMENT '商品名称',
  `description` varchar(500) DEFAULT NULL COMMENT '商品描述',
  `category_id` bigint DEFAULT NULL COMMENT '分类ID',
  `price` decimal(10,2) NOT NULL COMMENT '价格',
  `original_price` decimal(10,2) DEFAULT NULL COMMENT '原价',
  `stock` int DEFAULT '0' COMMENT '库存',
  `sales` int DEFAULT '0' COMMENT '销量',
  `main_image` varchar(255) DEFAULT NULL COMMENT '主图',
  `specs` varchar(500) DEFAULT NULL COMMENT '规格JSON',
  `origin` varchar(50) DEFAULT NULL COMMENT '产地',
  `weight` varchar(50) DEFAULT NULL COMMENT '重量',
  `shelf_life` varchar(50) DEFAULT NULL COMMENT '保质期',
  `storage` varchar(100) DEFAULT NULL COMMENT '储存方式',
  `status` tinyint DEFAULT '1' COMMENT '状态 0-下架 1-上架',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint DEFAULT '0' COMMENT '逻辑删除',
  `detail_images` varchar(500) DEFAULT NULL COMMENT '商品详情图JSON',
  `detail` mediumtext COMMENT '商品详情（Markdown格式）',
  `is_banner` tinyint DEFAULT '0' COMMENT '是否为轮播图商品 0-否 1-是',
  `banner_sort` int DEFAULT '0' COMMENT '轮播图排序',
  PRIMARY KEY (`id`),
  KEY `idx_banner_sort` (`banner_sort`),
  KEY `idx_is_banner` (`is_banner`)
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES (1,'豆本豆','精选优质大豆，植物蛋白饮品，口感醇香丝滑，营养健康之选',1,68.00,88.00,500,1256,'/uploads/90610ecf-a5e6-4c45-98db-2a6231770025.jpg','[\"500g\",\"1kg\",\"2kg\"]','挪威','500g/份','冷冻保存30天','-18°C以下冷冻保存',1,'2026-03-16 14:40:04','2026-04-18 19:43:20',0,NULL,NULL,1,0),(2,'红牛','维生素功能饮料，提神醒脑，补充能量，运动健身必备',1,158.00,198.00,0,432,'/uploads/d08f45ca-0b2b-4c2e-8296-17fe1baf04a3.jpg','[\"6头\",\"8头\"]','大连','约80g/个','鲜活即食','冷藏保存',1,'2026-03-16 14:40:04','2026-04-18 19:43:20',0,NULL,'![商品图片](/uploads/31b88868-5e13-4f28-bbaa-720270940dab.jpg)',1,0),(3,'健力宝','经典国民碳酸饮料，含蜂蜜成分，清爽回甘，畅饮无负担',1,398.00,700.00,80,234,'/uploads/ccacbe07-1b50-4e77-87ca-ac58c2df10cb.jpg','[\"1只\",\"2只\"]','波士顿','约700g/只','鲜活即食','冷藏保存',1,'2026-03-16 14:40:04','2026-04-18 19:43:20',0,NULL,NULL,0,0),(4,'景田','天然矿泉水，源自深层地下岩层，富含矿物质，纯净甘甜',1,128.00,158.00,200,567,'/uploads/1bf04c54-32e5-4e35-8b35-0449902076aa.jpg','[\"300g\",\"500g\"]','深海','300g/份','冷冻保存20天','-18°C以下冷冻保存',1,'2026-03-16 14:40:04','2026-04-18 19:43:20',0,NULL,NULL,1,0),(5,'茉莉花茶','精选茉莉花窨制，茶香花香交融，口感清新回甘，解渴怡神',1,88.00,NULL,350,890,'/uploads/e476367a-0c6d-4ce3-a129-465a3191d024.jpg','[\"500g\",\"1kg\"]','东海','500g/份','冷藏保存3天','0-4°C冷藏',0,'2026-03-16 14:40:04','2026-04-18 19:43:20',0,NULL,NULL,1,0),(6,'可口可乐','经典碳酸饮料，畅爽怡神，冰镇更佳，聚会派对首选',1,35.00,NULL,599,1568,'/uploads/02a15c91-19a7-4073-874a-136d1de611b6.jpg','[\"500g\",\"1kg\"]','舟山','500g/份','冷冻保存60天','-18°C以下冷冻保存',1,'2026-03-16 14:40:04','2026-04-18 19:43:20',0,NULL,NULL,1,0),(7,'乐虎','强化型维生素功能饮料，快速补充体力，提振精神，活力满满',1,45.00,NULL,398,791,'/uploads/8d60cb42-796c-4e6a-af0f-8cde67514f24.jpg','[\"1条\",\"2条\"]','广东','约500g/条','鲜活即食','暂养池暂养',1,'2026-03-16 14:40:04','2026-04-18 19:43:20',0,NULL,NULL,0,0),(8,'美年达','百事旗下果味碳酸饮料，橙味浓郁，酸甜爽口，夏日冰饮',1,188.00,228.00,120,345,'/uploads/59c5bb2d-c5d0-404b-859e-d7dff208dca5.jpg','[\"1kg\",\"2kg\"]','南海','1kg/份','冷冻保存30天','-18°C以下冷冻保存',1,'2026-03-16 14:40:04','2026-04-18 19:43:20',0,NULL,NULL,0,0),(9,'鳕鱼','阿拉斯加深海鳕鱼，肉质雪白细嫩，高蛋白低脂肪，适合儿童辅食',1,78.00,NULL,450,1234,'/uploads/e865b87c-1011-4d7e-a3b3-0fa341b4f43c.jpg','[\"500g\",\"1kg\"]','阿拉斯加','500g/份','冷冻保存90天','-18°C以下冷冻保存',0,'2026-03-16 14:40:04','2026-04-18 19:43:20',0,NULL,NULL,0,0),(10,'龙利鱼','精选去刺龙利鱼柳，肉质细腻无腥味，老少皆宜，方便烹饪',1,52.00,NULL,380,876,'/uploads/f15a0c61-2d15-4d41-9609-6b4af9f596e8.jpg','[\"500g\"]','越南','500g/份','冷冻保存60天','-18°C以下冷冻保存',1,'2026-03-16 14:40:04','2026-04-18 19:43:20',0,NULL,NULL,0,0),(11,'衡水老白干','河北名酒，老白干香型，入口绵柔，回味悠长，地道北方风味',2,299.00,NULL,200,892,'/uploads/d474c9da-24e3-4c93-ba28-eb41171f7302.jpg','[\"4只装\",\"8只装\"]','阳澄湖','约500g/只','鲜活即食','冷藏保存',1,'2026-03-16 14:40:04','2026-04-18 19:43:20',0,NULL,NULL,0,0),(12,'江小白','年轻人的白酒，清香纯正，口感柔和，小聚小饮刚刚好',2,58.00,NULL,400,789,'/uploads/39d350dd-ec42-4fe2-9faa-08eba2e1ae69.jpg','[\"1kg\"]','山东','1kg/份','冷冻保存30天','-18°C以下冷冻保存',1,'2026-03-16 14:40:04','2026-04-18 19:43:20',0,NULL,NULL,0,0),(13,'劲酒','中国劲酒，草本精华配方，125ml经典小瓶装，健康饮酒新选择',2,48.00,NULL,500,1234,'/uploads/a6a20c66-adc5-4877-be89-96c5ce606f58.jpg','[\"2斤\",\"5斤\"]','乳山','约100g/个','鲜活即食','冷藏保存',1,'2026-03-16 14:40:04','2026-04-18 19:43:20',0,NULL,NULL,0,0),(14,'九江','江西九江传统酿造，米香型白酒，口感醇和，性价比之王',2,68.00,88.00,300,1567,'/uploads/385452b4-d86c-4b79-a18e-2a40a807dc83.jpg','[\"500g\",\"1kg\"]','广东','500g/份','鲜活即食','暂养池暂养',1,'2026-03-16 14:40:04','2026-04-18 19:43:20',0,NULL,NULL,0,0),(15,'口子窖','安徽名酒，兼香型白酒，窖香浓郁，绵甜净爽，宴请佳酿',2,688.00,NULL,50,123,'/uploads/537c53d1-ad33-4455-8541-700b05bda52e.jpg','[\"整只\",\"半只\"]','阿拉斯加','约3kg/只','冷冻保存30天','-18°C以下冷冻保存',1,'2026-03-16 14:40:04','2026-04-18 19:43:20',0,NULL,NULL,0,0),(16,'泸州老窖','浓香型经典，国窖工艺传承，醇厚甘美，中国白酒代表品牌',2,18.00,24.00,7994,2346,'/uploads/ec2d614f-35c5-4cff-a252-800ee495af50.jpg','[\"1kg\",\"2kg\"]','威海','1kg/份','鲜活即食','冷藏保存',1,'2026-03-16 14:40:04','2026-04-18 19:43:20',0,NULL,NULL,0,0),(17,'牛栏山','北京二锅头，清香型白酒，入口爽净，价格亲民，国民口粮酒',2,58.00,NULL,250,678,'/uploads/32c5aeca-bb6a-4509-93f8-0c4841737447.jpg','[\"500g\",\"1kg\"]','渤海','500g/份','鲜活即食','暂养池暂养',1,'2026-03-16 14:40:04','2026-04-18 19:43:20',0,NULL,NULL,0,0),(18,'话梅','酸甜可口话梅，精选上等青梅腌制，开胃解腻，休闲小零食',3,98.00,NULL,180,456,'/uploads/09b4e455-8afd-45f7-a035-1260e0195cee.jpg','[\"200g\",\"500g\"]','加拿大','200g/份','冷冻保存60天','-18°C以下冷冻保存',1,'2026-03-16 14:40:04','2026-04-18 19:43:20',0,NULL,NULL,0,0),(19,'舍得','四川沱牌舍得酒，浓香型，陈年老酒勾调，品质生活之选',2,38.00,NULL,400,987,'/uploads/133f4dc2-4b56-4158-ac55-49e2a208f27b.jpg','[\"500g\",\"1kg\"]','新西兰','500g/份','冷冻保存30天','-18°C以下冷冻保存',1,'2026-03-16 14:40:04','2026-04-18 19:43:20',0,NULL,NULL,0,0),(20,'五粮春','五粮液旗下品牌，浓香型白酒，延续经典工艺，口感绵柔醇和',2,55.00,NULL,500,1456,'/uploads/8fbad0d8-1103-478a-a6ca-8480a80e53c1.jpg','[\"500g\",\"1kg\"]','海南','500g/份','冷冻保存60天','-18°C以下冷冻保存',1,'2026-03-16 14:40:04','2026-04-18 19:43:20',0,NULL,NULL,0,0),(21,'习酒','贵州茅台镇酱香型白酒，酱香突出，回味悠长，品质传承',2,45.00,NULL,800,2341,'/uploads/5f37c307-1564-474f-8215-7a6b827427e1.jpg','[\"500g\",\"1kg\"]','深海','500g/份','冷冻保存60天','-18°C以下冷冻保存',1,'2026-03-16 14:40:04','2026-04-18 19:43:20',0,NULL,NULL,0,0),(22,'小郎酒','郎酒旗下小瓶装，兼香型白酒，方便携带，随时品鉴',2,38.00,NULL,300,567,'/uploads/5530d0a1-c801-496e-ba72-3772ae4d279e.jpg','[\"500g\"]','东海','500g/份','冷冻保存45天','-18°C以下冷冻保存',1,'2026-03-16 14:40:04','2026-04-18 19:43:20',0,NULL,NULL,0,0),(23,'咸味花生','香脆咸味花生，颗粒饱满，咸香酥脆，下酒追剧必备小零食',3,28.00,NULL,600,1890,'/uploads/07ac6cf4-104c-415b-a87e-f97f7c342793.jpg','[\"500g\",\"1kg\"]','潮汕','500g/份','冷冻保存90天','-18°C以下冷冻保存',1,'2026-03-16 14:40:04','2026-04-18 19:43:20',0,NULL,NULL,0,0),(24,'莲子','精选湘莲子，颗粒圆润，软糯香甜，煲汤甜品养生佳品',3,48.00,NULL,400,1234,'/uploads/3d3a6392-d1d7-449b-8943-e12b70624789.jpg','[\"200g\",\"500g\"]','广东','200g/份','冷冻保存90天','-18°C以下冷冻保存',1,'2026-03-16 14:40:04','2026-04-18 19:43:20',0,NULL,NULL,0,0),(25,'葡萄干','新疆吐鲁番葡萄干，天然晾晒，甜而不腻，营养丰富的健康零食',3,15.00,24.00,999,3457,'/uploads/602c1d86-b396-466f-bdbf-7b08003f196c.jpg','[\"200g\"]','日本','200g/份','冷冻保存180天','-18°C以下冷冻保存',1,'2026-03-16 14:40:04','2026-04-18 19:43:20',0,NULL,NULL,0,0),(26,'松子','东北红松子，颗粒饱满，松香浓郁，开口即食，坚果中的贵族',3,18.00,NULL,15,3672,'/uploads/c618fe04-c97f-4226-aee7-c1e53945431d.jpg','[\"300g\"]','台湾','300g/份','冷冻保存180天','-18°C以下冷冻保存',1,'2026-03-16 14:40:04','2026-04-18 19:43:20',0,NULL,'**好吃不贵的鱼豆腐**\n# 一级标题![图片](http://localhost:5000/uploads/8a550545-9304-4953-8482-c787e7518ba9.jpg)\n| Column | | | | | |\n| - | - | - | - | - | - |\n| | | | | | |\n| | | | | | |\n| | | | | | |\n',0,0),(27,'巴旦木','新疆薄壳巴旦木，奶香浓郁，酥脆可口，富含维生素E和蛋白质',3,68.00,NULL,200,456,'/uploads/762ddb01-950f-4908-b5d4-919ecec26a6a.jpg','[\"500g\",\"1kg\"]','深海','500g/份','冷冻保存60天','-18°C以下冷冻保存',1,'2026-03-16 14:40:04','2026-04-18 19:43:20',0,NULL,NULL,0,0),(28,'花生豆','多味花生豆，酥脆香浓，外层裹粉入味，休闲聚会必备',3,88.00,108.00,150,345,'/uploads/e4624cf6-b4d4-498d-b563-c3adf4f8c3c3.jpg','[\"300g\",\"500g\"]','福建','300g/份','冷冻保存90天','-18°C以下冷冻保存',1,'2026-03-16 14:40:04','2026-04-18 19:43:20',0,NULL,NULL,0,0),(29,'板栗','迁西甘栗仁，软糯香甜，即食免剥壳，天然板栗美味',3,128.00,NULL,200,567,'/uploads/da193af0-ef68-415b-9aaa-3de0ed144665.jpg','[\"100g\",\"250g\"]','大连','100g/份','常温保存12月','阴凉干燥处',1,'2026-03-16 14:40:04','2026-04-18 19:43:20',0,NULL,NULL,0,0),(30,'核桃','云南纸皮核桃，薄壳易剥，核桃仁饱满，补脑益智，每日坚果之选',3,298.00,NULL,100,234,'/uploads/38ffa5de-51ea-4162-9e5a-7f40b19c240a.jpg','[\"50g\",\"100g\"]','深海','50g/份','常温保存24月','阴凉干燥处',1,'2026-03-16 14:40:04','2026-04-18 19:43:20',0,NULL,NULL,0,0),(31,'开心果','美国进口开心果，自然开口，咸香酥脆，派对零食人气之王',3,388.00,NULL,80,123,'/uploads/85f33c6e-d885-4643-9205-48fcc7c0c4a2.jpg','[\"50g\",\"100g\"]','辽宁','50g/份','常温保存24月','阴凉干燥处',1,'2026-03-16 14:40:04','2026-04-18 19:43:20',0,NULL,NULL,0,0),(32,'辣条','经典麻辣辣条，香辣过瘾，嚼劲十足，童年回忆零食',3,68.00,NULL,300,890,'/uploads/b2e9f00c-9d61-44ba-9da2-0e67731c6376.jpg','[\"250g\",\"500g\"]','舟山','250g/份','常温保存12月','阴凉干燥处',1,'2026-03-16 14:40:04','2026-04-18 19:43:20',0,NULL,NULL,0,0),(33,'坚果','每日混合坚果，腰果核桃巴旦木搭配，营养均衡，一袋补充活力',3,45.00,NULL,500,1567,'/uploads/cd073c79-5dae-42a4-87f3-0f0bd248f32d.jpg','[\"100g\",\"250g\"]','福建','100g/份','常温保存12月','阴凉干燥处',1,'2026-03-16 14:40:04','2026-04-18 19:43:20',0,NULL,NULL,0,0),(34,'东鹏特饮','累了困了喝东鹏特饮，牛磺酸维生素配方，提神抗疲劳',1,4.00,8.00,8,25,'/uploads/bd5e065c-08e4-4696-8335-e4dcedac96de.jpg','','河南','400g','13月','冷藏',1,'2026-03-17 12:22:44','2026-04-18 19:43:20',0,'[\"/uploads/23c2bb50-98e0-40d2-9946-d7fcac983a96.jpg\",\"/uploads/fe9cb888-158d-45ad-9dab-75633faa8500.jpg\"]',NULL,1,0),(35,'百事可乐','百事可乐经典口味，清凉冰爽，年轻一代的选择',1,7.00,15.00,12,78,'/uploads/80d7e920-6411-4028-9e77-cab0ea26c97b.jpg','1kg/盒','河南','600g','12个月','冷村',1,'2026-03-24 15:04:03','2026-04-18 19:43:20',0,'[\"/uploads/05ff73b6-4571-4465-953f-df6e42fa0df7.jpg\",\"/uploads/66b33828-3ae7-4f4f-a56d-c8505921fc61.jpg\"]','后i还会发还是公司\n![商品图片](/uploads/96ce9530-4317-4278-997e-5be4530557d5.jpg)\n![商品图片](/uploads/99279333-4d8d-4f30-ac24-dc77dab21c5a.jpg)\n',0,0),(36,'西梅','新鲜西梅，果肉紧实酸甜，富含膳食纤维和维生素，美容养颜佳果',3,7.00,24.00,145,0,'/uploads/1811e951-0cc3-402a-b48a-a70bce63c86e.jpg','','','','','',1,'2026-04-18 18:32:24','2026-04-18 19:43:20',0,NULL,NULL,0,0),(37,'鸡肉','散养走地鸡，肉质紧实有嚼劲，鸡汤炖煮口感鲜美，家庭滋补好食材',4,23.00,9.90,73,0,'/uploads/5e9a447a-bd90-411e-bbf0-0b561641becd.jpg','','','','','',1,'2026-04-18 18:33:06','2026-04-18 19:43:20',0,NULL,NULL,0,0),(38,'牛排','澳洲进口原切牛排，肉质鲜嫩多汁，煎烤皆宜，家庭西餐首选',1,12.20,99.00,59,0,'/uploads/08ad0fdf-7e2d-4c8d-8e29-e3baf3aaef06.jpg','','','','','',1,'2026-04-18 18:33:37','2026-04-18 19:43:20',0,NULL,NULL,0,0),(39,'牛舌','精选牛舌切片，口感嫩滑细腻，日式烧烤必备，入口即化的美味',4,12.00,11.00,210,0,'/uploads/46e24c5d-1ebc-4c34-9968-78e1c750ba97.jpg','','','','','',1,'2026-04-18 18:35:55','2026-04-18 19:43:20',0,NULL,NULL,0,0),(40,'牛眼肉','澳洲谷饲牛眼肉，大理石花纹丰富，煎烤口感极佳，牛排爱好者首选',4,32.00,32.00,131,0,'/uploads/8b4988a7-65e4-4f42-ad46-fd874cf7a864.jpg','','','','','',1,'2026-04-18 18:36:20','2026-04-18 19:43:20',0,NULL,NULL,0,0),(41,'琵琶腿','新鲜冷冻琵琶腿，肉质鲜嫩多汁，红烧卤制皆可，家庭常备食材',4,42.00,32.00,21,0,'/uploads/28947c48-ecf2-4d2d-802e-0e42cd90a8a2.jpg','','','','','',1,'2026-04-18 18:36:36','2026-04-18 19:43:20',0,NULL,NULL,0,0),(42,'土鸡蛋','农家散养土鸡蛋，蛋黄饱满橙红，口感香浓，营养价值远超普通鸡蛋',4,3.00,2.00,412,0,'/uploads/f4c14e68-76a2-45a9-ad15-e6e8dd9f4de7.jpg','','','','','',1,'2026-04-18 18:37:06','2026-04-18 19:43:20',0,NULL,NULL,0,0),(43,'五花肉','精选猪五花肉，肥瘦相间，层次分明，红烧回锅肉的最佳选择',4,42.00,32.00,134,0,'/uploads/d08852f0-a6c8-4838-945f-9473a22d1b4b.jpg','','','','','',1,'2026-04-18 18:37:23','2026-04-18 19:43:20',0,NULL,NULL,0,0),(44,'小里脊','猪小里脊肉，瘦肉含量高，肉质细嫩，适合滑炒糖醋，宝宝辅食优选',4,240.00,424.00,3124,0,'/uploads/f5a5e6dd-678b-45d1-9917-1ba5084da948.jpg','','','','','',1,'2026-04-18 18:37:51','2026-04-18 19:43:20',0,NULL,NULL,0,0),(45,'羊肉卷','内蒙古羔羊肉卷，鲜嫩无膻味，涮火锅必备，薄切即涮即食',4,54.00,32.00,124,0,'/uploads/1534c3a6-3463-4532-b085-778d10a737e2.jpg','','','','','',1,'2026-04-18 18:38:10','2026-04-18 19:43:20',0,NULL,NULL,0,0),(46,'豆角','新鲜长豆角，翠绿脆嫩，干煸蒜蓉皆美味，家常菜百搭蔬菜',7,24.00,32.00,24,0,'/uploads/76680d76-37da-4f3a-b262-49e35ee1c2dd.jpg','','','','','',1,'2026-04-18 18:38:59','2026-04-18 19:43:20',0,NULL,NULL,0,0),(47,'西兰花','有机西兰花，翠绿紧实，富含维生素C和膳食纤维，健身轻食首选蔬菜',7,124.00,32.00,123,0,'/uploads/2f00cea6-1b23-4207-92fc-8e6dbd198c72.jpg','','','','','',1,'2026-04-18 18:39:23','2026-04-18 19:43:20',0,NULL,NULL,0,0),(48,'洋葱','精选紫皮洋葱，辛香开胃，炒菜配菜必备，富含槲皮素有益健康',7,24.00,54.00,24,0,'/uploads/3347b73d-5c9c-4219-8824-36d3f05933fd.jpg','','','','','',1,'2026-04-18 18:39:43','2026-04-18 19:43:20',0,NULL,NULL,0,0),(49,'车厘子','智利进口车厘子，果粒硕大饱满，甜度高口感脆，送礼自享皆宜',5,42.00,32.00,512,0,'/uploads/f654f798-9b2a-48cc-be5e-31de5f86ffa7.jpg','','','','','',1,'2026-04-18 18:40:34','2026-04-18 19:43:20',0,NULL,NULL,0,0),(50,'橙子','赣南脐橙，皮薄汁多，酸甜适中，富含维生素C，鲜榨橙汁首选',5,43.00,21.00,124,0,'/uploads/27bcba49-01f1-4a9d-b581-4d5b9010b97a.jpg','','','','','',1,'2026-04-18 18:40:54','2026-04-18 19:43:20',0,NULL,NULL,0,0),(51,'荔枝','岭南鲜荔枝，果肉晶莹剔透，清甜多汁，一口岭南夏天的味道',5,42.00,51.00,3,0,'/uploads/37a5e7bf-82c5-48a6-b9a9-b23cd15fddc1.jpg','','','','','',1,'2026-04-18 18:41:20','2026-04-18 19:43:20',0,NULL,NULL,0,0),(52,'油桃','新鲜油桃，果皮光滑红润，果肉脆甜爽口，夏季应季鲜果',5,25.00,5125.00,623,0,'/uploads/ce349f16-3404-44cf-8b35-ac4bc7bea403.jpg','','','','','',1,'2026-04-18 18:41:39','2026-04-18 19:43:20',0,NULL,NULL,0,0),(53,'蟠桃','新疆蟠桃，扁圆饱满，果肉细腻香甜，桃中珍品，口感独特',5,12.00,52.00,12,0,'/uploads/7d4524cb-7940-4075-b661-16709a2dcbac.jpg','','','','','',1,'2026-04-18 18:41:57','2026-04-18 19:43:20',0,NULL,NULL,0,0),(54,'西瓜','麒麟西瓜，皮薄瓤红，清甜多汁，夏日消暑解渴的不二之选',5,42.00,51.00,3,0,'/uploads/b8045ee6-0f25-4d28-81ee-c2884d68491d.jpg','','','','','',1,'2026-04-18 18:42:10','2026-04-18 19:43:20',0,NULL,NULL,0,0),(55,'香蕉','进口香蕉，果肉绵密香甜，富含钾元素，每日水果营养补给',5,25.00,42.00,124,0,'/uploads/95cd50b5-a0a5-4152-ad21-98b00cb34514.jpg','','','','','',1,'2026-04-18 18:42:25','2026-04-18 19:43:20',0,NULL,NULL,0,0),(56,'紫葡萄','新疆紫葡萄，果粒紧实，甜度爆表，花青素丰富，美味又健康',5,4.00,24.00,55,0,'/uploads/f73e3eca-1f58-472b-8415-3be49ea6064c.jpg','','','','','',1,'2026-04-18 18:42:40','2026-04-18 19:43:20',0,NULL,NULL,0,0),(57,'蒂花之秀护发精油 ','蒂花之秀护发精油，修护干枯受损发质，滋润顺滑不油腻，秀发闪亮',6,25.00,234.00,24,0,'/uploads/c8916fca-2180-4fa7-a64f-e7b0df451b08.jpg','','','','','',1,'2026-04-18 18:43:12','2026-04-18 19:43:20',0,NULL,NULL,0,0),(58,'多芬护发膜 ','多芬深层修护发膜，密集滋养受损秀发，改善毛躁分叉，柔顺如丝',6,42.00,51.00,24,0,'/uploads/11b83773-f2ae-4ab2-93ee-0edcf8e25278.jpg','','','','','',1,'2026-04-18 18:43:37','2026-04-18 19:43:20',0,NULL,NULL,0,0),(59,'蜂花洗发露 ','蜂花经典洗发露，天然植物配方，温和清洁头皮，国货老品牌值得信赖',6,42.00,42.00,23,0,'/uploads/4b58267c-e369-49cb-b4af-58ada7d5b68e.jpg','','','','','',1,'2026-04-18 18:44:02','2026-04-18 19:43:20',0,NULL,NULL,0,0),(60,'亮莊定型水 ','亮莊专业定型水，强力定型不僵硬，持久造型一整天，发型师推荐',6,43.00,23.00,2,0,'/uploads/9802a16d-9254-4fe9-8b19-cccc522c8ec5.jpg','','','','','',1,'2026-04-18 18:44:31','2026-04-18 19:43:20',0,NULL,NULL,0,0),(61,'满婷洗发水 (1)','满婷除螨洗发水，深层清洁头皮螨虫，控油去屑，头皮健康护理专家',6,24.00,24.00,42,0,'/uploads/634fb0b6-b16c-4739-a7ca-cfbd759f9d9c.jpg','','','','','',1,'2026-04-18 18:44:52','2026-04-18 19:43:20',0,NULL,NULL,0,0),(62,'飘柔洗发露 ','飘柔顺滑洗发露，一梳到底不打结，持久柔顺飘逸，经典国民品牌',6,25.00,25.00,25,0,'/uploads/2a9d1183-4803-43f6-a2e0-ab07d0843874.jpg','','','','','',1,'2026-04-18 18:45:19','2026-04-18 19:43:20',0,NULL,NULL,0,0),(63,'清扬洗发水 ','清扬男士去屑洗发水，深层去屑止痒，清爽控油，专为男士头皮研发',6,86.00,86.00,86,0,'/uploads/0ac07316-631d-4a96-851c-b73de0429c90.jpg','','','','','',1,'2026-04-18 18:45:40','2026-04-18 19:43:20',0,NULL,NULL,0,0);
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_tag`
--

DROP TABLE IF EXISTS `product_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_tag` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `product_id` bigint NOT NULL COMMENT '商品ID',
  `tag_id` bigint NOT NULL COMMENT '标签ID',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_product_tag` (`product_id`,`tag_id`),
  KEY `idx_tag_id` (`tag_id`)
) ENGINE=InnoDB AUTO_INCREMENT=97 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品标签关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_tag`
--

LOCK TABLES `product_tag` WRITE;
/*!40000 ALTER TABLE `product_tag` DISABLE KEYS */;
INSERT INTO `product_tag` VALUES (68,1,2),(69,1,4),(70,1,5),(71,1,6),(72,2,4),(73,2,6),(74,3,6),(75,3,7),(76,3,8),(77,4,1),(78,5,3),(79,5,4),(80,5,5),(81,5,6),(96,6,8),(83,7,2),(84,7,5),(85,7,6),(86,8,4),(87,8,5),(88,34,1),(89,34,2),(90,34,3),(91,34,4),(92,34,5),(93,34,6),(94,34,7),(95,34,8),(56,35,4),(57,35,5),(58,35,6),(59,35,7);
/*!40000 ALTER TABLE `product_tag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review`
--

DROP TABLE IF EXISTS `review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `review` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `product_id` bigint NOT NULL COMMENT '商品ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `username` varchar(50) NOT NULL COMMENT '用户名（冗余存储）',
  `rating` int NOT NULL DEFAULT '5' COMMENT '评分 1-5星',
  `content` varchar(500) DEFAULT NULL COMMENT '评价内容',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `deleted` int NOT NULL DEFAULT '0' COMMENT '逻辑删除 0-正常 1-已删除',
  PRIMARY KEY (`id`),
  KEY `idx_product_id` (`product_id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品评论表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review`
--

LOCK TABLES `review` WRITE;
/*!40000 ALTER TABLE `review` DISABLE KEYS */;
INSERT INTO `review` VALUES (1,26,22,'afishing',5,'体验感很好','2026-03-25 23:27:35','2026-03-25 23:27:35',0),(2,34,22,'afishing',5,'好吃不上火','2026-03-25 23:40:35','2026-03-25 23:40:35',0),(3,35,22,'afishing',5,'好吃不贵','2026-03-26 13:50:05','2026-03-26 13:50:05',0),(4,2,2,'user1',5,'asa','2026-03-30 12:54:03','2026-03-30 12:54:03',0),(5,25,2,'user1',5,'好吃不贵','2026-03-30 12:54:28','2026-03-30 12:54:28',0),(6,16,2,'user1',5,NULL,'2026-04-06 12:08:59','2026-04-06 12:08:59',0),(7,16,2,'user1',5,'22','2026-04-06 12:43:52','2026-04-06 12:43:52',0);
/*!40000 ALTER TABLE `review` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `spec_group`
--

DROP TABLE IF EXISTS `spec_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `spec_group` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` varchar(100) NOT NULL COMMENT '规格组名称',
  `sort_order` int DEFAULT '0' COMMENT '排序号',
  `status` tinyint DEFAULT '1' COMMENT '状态 0-禁用 1-启用',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint DEFAULT '0' COMMENT '逻辑删除 0-正常 1-已删除',
  PRIMARY KEY (`id`),
  KEY `idx_sort_order` (`sort_order`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='规格组表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `spec_group`
--

LOCK TABLES `spec_group` WRITE;
/*!40000 ALTER TABLE `spec_group` DISABLE KEYS */;
INSERT INTO `spec_group` VALUES (1,'重量',1,1,'2026-03-26 16:40:06','2026-03-26 16:40:06',0),(2,'包装',2,1,'2026-03-26 16:40:06','2026-03-26 16:40:06',0),(3,'尺寸',3,1,'2026-03-26 16:40:06','2026-03-26 16:40:06',0),(4,'重量',1,1,'2026-03-26 17:01:41','2026-03-26 17:01:41',0),(5,'包装',2,1,'2026-03-26 17:01:41','2026-03-26 17:01:41',0),(6,'尺寸',3,1,'2026-03-26 17:01:41','2026-03-26 17:01:41',0);
/*!40000 ALTER TABLE `spec_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `spec_value`
--

DROP TABLE IF EXISTS `spec_value`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `spec_value` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `group_id` bigint NOT NULL COMMENT '所属规格组ID',
  `value` varchar(100) NOT NULL COMMENT '规格值',
  `sort_order` int DEFAULT '0' COMMENT '排序号',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint DEFAULT '0' COMMENT '逻辑删除 0-正常 1-已删除',
  PRIMARY KEY (`id`),
  KEY `idx_group_id` (`group_id`),
  KEY `idx_sort_order` (`sort_order`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='规格值表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `spec_value`
--

LOCK TABLES `spec_value` WRITE;
/*!40000 ALTER TABLE `spec_value` DISABLE KEYS */;
INSERT INTO `spec_value` VALUES (1,1,'500g',1,'2026-03-26 16:40:06','2026-03-26 16:40:06',0),(2,1,'1kg',2,'2026-03-26 16:40:06','2026-03-26 16:40:06',0),(3,1,'2kg',3,'2026-03-26 16:40:06','2026-03-26 16:40:06',0),(4,1,'5kg',4,'2026-03-26 16:40:06','2026-03-26 16:40:06',0),(5,2,'单只装',1,'2026-03-26 16:40:06','2026-03-26 16:40:06',0),(6,2,'双只装',2,'2026-03-26 16:40:06','2026-03-26 16:40:06',0),(7,2,'家庭装',3,'2026-03-26 16:40:06','2026-03-26 16:40:06',0),(8,2,'礼盒装',4,'2026-03-26 16:40:06','2026-03-26 16:40:06',0),(9,3,'小号',1,'2026-03-26 16:40:06','2026-03-26 16:40:06',0),(10,3,'中号',2,'2026-03-26 16:40:06','2026-03-26 16:40:06',0),(11,3,'大号',3,'2026-03-26 16:40:06','2026-03-26 16:40:06',0),(12,1,'500g',1,'2026-03-26 17:01:42','2026-03-26 17:01:42',0),(13,1,'1kg',2,'2026-03-26 17:01:42','2026-03-26 17:01:42',0),(14,1,'2kg',3,'2026-03-26 17:01:42','2026-03-26 17:01:42',0),(15,1,'5kg',4,'2026-03-26 17:01:42','2026-03-26 17:01:42',0),(16,2,'单只装',1,'2026-03-26 17:01:42','2026-03-26 17:01:42',0),(17,2,'双只装',2,'2026-03-26 17:01:42','2026-03-26 17:01:42',0),(18,2,'家庭装',3,'2026-03-26 17:01:42','2026-03-26 17:01:42',0),(19,2,'礼盒装',4,'2026-03-26 17:01:42','2026-03-26 17:01:42',0),(20,3,'小号',1,'2026-03-26 17:01:42','2026-03-26 17:01:42',0),(21,3,'中号',2,'2026-03-26 17:01:42','2026-03-26 17:01:42',0),(22,3,'大号',3,'2026-03-26 17:01:42','2026-03-26 17:01:42',0);
/*!40000 ALTER TABLE `spec_value` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `specification`
--

DROP TABLE IF EXISTS `specification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `specification` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` varchar(100) NOT NULL COMMENT '规格名称',
  `value` varchar(100) NOT NULL COMMENT '规格值（用于显示）',
  `sort_order` int DEFAULT '0' COMMENT '排序号',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint DEFAULT '0' COMMENT '逻辑删除 0-正常 1-已删除',
  PRIMARY KEY (`id`),
  KEY `idx_deleted` (`deleted`),
  KEY `idx_sort_order` (`sort_order`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品规格表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `specification`
--

LOCK TABLES `specification` WRITE;
/*!40000 ALTER TABLE `specification` DISABLE KEYS */;
INSERT INTO `specification` VALUES (1,'500g/条','500g/条',1,'2026-03-26 15:58:17','2026-03-26 15:58:17',0),(2,'1kg/盒','1kg/盒',2,'2026-03-26 15:58:17','2026-03-26 15:58:17',0),(3,'2kg/箱','2kg/箱',3,'2026-03-26 15:58:17','2026-03-26 15:58:17',0),(4,'5kg/箱','5kg/箱',4,'2026-03-26 15:58:17','2026-03-26 15:58:17',0),(5,'10kg/箱','10kg/箱',5,'2026-03-26 15:58:17','2026-03-26 15:58:17',0),(6,'250g/袋','250g/袋',6,'2026-03-26 15:58:17','2026-03-26 15:58:17',0),(7,'单只装','单只装',7,'2026-03-26 15:58:17','2026-03-26 15:58:17',0),(8,'双只装','双只装',8,'2026-03-26 15:58:17','2026-03-26 15:58:17',0),(9,'家庭装','家庭装',9,'2026-03-26 15:58:17','2026-03-26 15:58:17',0),(10,'礼盒装','礼盒装',10,'2026-03-26 15:58:17','2026-03-26 15:58:17',0),(11,'500g/条','500g/条',1,'2026-03-26 16:17:49','2026-03-26 16:17:49',0),(12,'1kg/盒','1kg/盒',2,'2026-03-26 16:17:49','2026-03-26 16:17:49',0),(13,'2kg/箱','2kg/箱',3,'2026-03-26 16:17:49','2026-03-26 16:17:49',0),(14,'5kg/箱','5kg/箱',4,'2026-03-26 16:17:49','2026-03-26 16:17:49',0),(15,'10kg/箱','10kg/箱',5,'2026-03-26 16:17:49','2026-03-26 16:17:49',0),(16,'250g/袋','250g/袋',6,'2026-03-26 16:17:49','2026-03-26 16:17:49',0),(17,'单只装','单只装',7,'2026-03-26 16:17:49','2026-03-26 16:17:49',0),(18,'双只装','双只装',8,'2026-03-26 16:17:49','2026-03-26 16:17:49',0),(19,'家庭装','家庭装',9,'2026-03-26 16:17:49','2026-03-26 16:17:49',0),(20,'礼盒装','礼盒装',10,'2026-03-26 16:17:49','2026-03-26 16:17:49',0);
/*!40000 ALTER TABLE `specification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tag`
--

DROP TABLE IF EXISTS `tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tag` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '标签ID',
  `name` varchar(50) NOT NULL COMMENT '标签名称',
  `color` varchar(20) DEFAULT '#409EFF' COMMENT '标签颜色',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint DEFAULT '0' COMMENT '逻辑删除 0-未删除 1-已删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tag_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品标签表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tag`
--

LOCK TABLES `tag` WRITE;
/*!40000 ALTER TABLE `tag` DISABLE KEYS */;
INSERT INTO `tag` VALUES (1,'热卖爆款','#f56c6c','2026-03-26 10:44:44','2026-03-26 10:47:21',0),(2,'进口精品','#e6a23c','2026-03-26 10:44:44','2026-03-26 10:44:44',0),(3,'新鲜直达','#67c23a','2026-03-26 10:44:44','2026-03-26 10:44:44',0),(4,'火锅必备','#409eff','2026-03-26 10:44:44','2026-03-26 10:44:44',0),(5,'刺身首选','#9c27b0','2026-03-26 10:44:44','2026-03-26 10:44:44',0),(6,'滋补养生','#ff9800','2026-03-26 10:44:44','2026-03-26 10:44:44',0),(7,'儿童优选','#00bcd4','2026-03-26 10:44:44','2026-03-26 10:44:44',0),(8,'送礼佳品','#e91e63','2026-03-26 10:44:44','2026-03-26 10:44:44',0),(10,'清热解毒','#409EFF','2026-03-30 15:44:00','2026-03-30 15:44:00',0);
/*!40000 ALTER TABLE `tag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Current Database: `fish_order`
--

/*!40000 DROP DATABASE IF EXISTS `fish_order`*/;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `fish_order` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `fish_order`;

--
-- Table structure for table `order`
--

DROP TABLE IF EXISTS `order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `order_no` varchar(50) NOT NULL COMMENT '订单号',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `receiver_name` varchar(50) DEFAULT NULL COMMENT '收货人姓名',
  `receiver_phone` varchar(20) DEFAULT NULL COMMENT '收货人电话',
  `receiver_address` varchar(255) DEFAULT NULL COMMENT '收货地址',
  `total_amount` decimal(10,2) DEFAULT NULL COMMENT '商品总金额',
  `freight` decimal(10,2) DEFAULT '0.00' COMMENT '运费',
  `pay_amount` decimal(10,2) DEFAULT NULL COMMENT '实付金额',
  `pay_type` tinyint DEFAULT '0' COMMENT '支付方式 0-未支付 1-支付宝 2-微信 3-银行卡',
  `pay_time` datetime DEFAULT NULL COMMENT '支付时间',
  `status` tinyint DEFAULT '0' COMMENT '订单状态 0-待付款 1-待发货 2-待收货 3-已完成 4-已取消 5-已退款',
  `remark` varchar(255) DEFAULT NULL COMMENT '订单备注',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_order_no` (`order_no`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='订单表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order`
--

LOCK TABLES `order` WRITE;
/*!40000 ALTER TABLE `order` DISABLE KEYS */;
INSERT INTO `order` VALUES (1,'202401150001',1,'张三','13812345678','浙江省杭州市西湖区文三路xxx号',435.00,0.00,435.00,0,NULL,0,'','2026-03-16 14:40:04','2026-03-16 14:40:04',0),(2,'202401140002',1,'张三','13812345678','浙江省杭州市西湖区文三路xxx号',135.00,0.00,135.00,1,'2024-01-14 10:30:00',2,'','2026-03-16 14:40:04','2026-03-16 14:40:04',0),(3,'202401130003',1,'张三','13812345678','浙江省杭州市西湖区文三路xxx号',68.00,0.00,68.00,1,'2024-01-13 17:00:00',3,'','2026-03-16 14:40:04','2026-03-16 14:40:04',0),(4,'202401120001',2,'李四','13912345678','北京市朝阳区建国路xxx号',714.00,0.00,714.00,1,'2024-01-12 09:00:00',3,'送货前请电话联系','2026-03-16 14:40:04','2026-03-16 14:40:04',0),(5,'202401110002',2,'李四','13912345678','北京市朝阳区建国路xxx号',398.00,0.00,398.00,2,'2024-01-11 14:30:00',3,'','2026-03-16 14:40:04','2026-03-16 14:40:04',0),(6,'202401100001',3,'王五','13712345678','上海市浦东新区陆家嘴xxx号',876.00,0.00,876.00,1,'2024-01-10 16:00:00',2,'','2026-03-16 14:40:04','2026-03-16 14:40:04',0),(7,'202401090001',4,'赵六','13612345678','广州市天河区天河路xxx号',190.00,0.00,190.00,1,'2024-01-09 11:00:00',3,'','2026-03-16 14:40:04','2026-03-16 14:40:04',0),(8,'202401080001',5,'钱七','13512345678','深圳市南山区科技园xxx号',104.00,0.00,104.00,2,'2024-01-08 15:30:00',3,'','2026-03-16 14:40:04','2026-03-16 14:40:04',0),(9,'202401070001',6,'孙八','13412345678','成都市武侯区天府大道xxx号',176.00,0.00,176.00,1,'2024-01-07 10:00:00',2,'周末配送','2026-03-16 14:40:04','2026-03-16 14:40:04',0),(10,'202401060001',7,'周九','13312345678','杭州市滨江区江南大道xxx号',128.00,0.00,128.00,1,'2024-01-06 14:00:00',3,'','2026-03-16 14:40:04','2026-03-16 14:40:04',0),(11,'202401050001',8,'吴十','13212345678','南京市鼓楼区中山路xxx号',298.00,0.00,298.00,2,'2024-01-05 09:30:00',3,'','2026-03-16 14:40:04','2026-03-16 14:40:04',0),(12,'202401040001',9,'郑十一','13112345678','武汉市江汉区解放大道xxx号',776.00,0.00,776.00,1,'2024-01-04 16:30:00',3,'','2026-03-16 14:40:04','2026-03-16 14:40:04',0),(13,'202401030001',10,'陈十二','13012345678','西安市雁塔区高新路xxx号',398.00,0.00,398.00,1,'2024-01-03 11:30:00',2,'','2026-03-16 14:40:04','2026-03-16 14:40:04',0),(14,'202401020001',11,'林十三','13811111111','重庆市渝中区解放碑xxx号',158.00,0.00,158.00,1,'2024-01-02 14:00:00',3,'','2026-03-16 14:40:04','2026-03-16 14:40:04',0),(15,'202401010001',12,'黄十四','13822222222','天津市和平区南京路xxx号',68.00,0.00,68.00,2,'2024-01-01 10:00:00',3,'','2026-03-16 14:40:04','2026-03-16 14:40:04',0),(16,'202312310001',13,'许十五','13833333333','苏州市工业园区金鸡湖xxx号',456.00,0.00,456.00,1,'2023-12-31 15:00:00',3,'新年礼物','2026-03-16 14:40:04','2026-03-16 14:40:04',0),(17,'202312300001',14,'何十六','13844444444','青岛市市南区香港中路xxx号',234.00,0.00,234.00,1,'2023-12-30 09:00:00',3,'','2026-03-16 14:40:04','2026-03-16 14:40:04',0),(18,'202312290001',15,'张十七','13855555555','厦门市思明区鹭江道xxx号',188.00,0.00,188.00,2,'2023-12-29 14:30:00',3,'','2026-03-16 14:40:04','2026-03-16 14:40:04',0),(19,'202312280001',16,'孔十八','13866666666','长沙市岳麓区岳麓大道xxx号',566.00,0.00,566.00,1,'2023-12-28 11:00:00',3,'','2026-03-16 14:40:04','2026-03-16 14:40:04',0),(20,'202312270001',17,'曹十九','13877777777','郑州市金水区金水路xxx号',128.00,0.00,128.00,1,'2023-12-27 16:00:00',3,'','2026-03-16 14:40:04','2026-03-16 14:40:04',0),(21,'202312260001',18,'严二十','13888888888','济南市历下区泉城路xxx号',388.00,0.00,388.00,2,'2023-12-26 10:30:00',3,'','2026-03-16 14:40:04','2026-03-16 14:40:04',0),(22,'202312250001',19,'华二一','13899999999','合肥市蜀山区长江路xxx号',688.00,0.00,688.00,1,'2023-12-25 15:00:00',1,'圣诞礼物','2026-03-16 14:40:04','2026-03-16 14:40:04',0),(23,'202312240001',1,'张三','13812345678','浙江省杭州市西湖区文三路xxx号',256.00,0.00,256.00,1,'2023-12-24 09:30:00',3,'','2026-03-16 14:40:04','2026-03-16 14:40:04',0),(24,'202312230001',2,'李四','13912345678','北京市朝阳区建国路xxx号',456.00,0.00,456.00,1,'2023-12-23 14:00:00',3,'','2026-03-16 14:40:04','2026-03-16 14:40:04',0),(25,'202312220001',3,'王五','13712345678','上海市浦东新区陆家嘴xxx号',158.00,0.00,158.00,2,'2023-12-22 11:30:00',4,'','2026-03-16 14:40:04','2026-03-16 14:40:04',0),(26,'20260317105308069',2,NULL,NULL,NULL,316.00,0.00,316.00,2,'2026-03-17 10:53:12',3,NULL,'2026-03-17 10:53:08','2026-03-17 10:53:08',0),(27,'20260317132050282',2,NULL,NULL,NULL,398.00,0.00,398.00,1,'2026-03-17 13:21:13',3,NULL,'2026-03-17 13:20:50','2026-03-17 13:20:50',0),(28,'20260317133346147',2,NULL,NULL,NULL,398.00,0.00,398.00,1,'2026-03-17 13:35:17',3,NULL,'2026-03-17 13:33:46','2026-03-17 13:33:46',0),(29,'20260317145356687',2,NULL,NULL,NULL,45.00,0.00,45.00,0,NULL,4,NULL,'2026-03-17 14:53:57','2026-03-17 14:53:57',0),(30,'20260317145609875',2,NULL,NULL,NULL,45.00,0.00,45.00,0,NULL,4,NULL,'2026-03-17 14:56:10','2026-03-17 14:56:10',0),(31,'20260317145634291',2,NULL,NULL,NULL,18.00,0.00,18.00,0,NULL,4,NULL,'2026-03-17 14:56:34','2026-03-17 14:56:34',0),(32,'20260317151043480',2,NULL,NULL,NULL,18.00,0.00,18.00,1,'2026-03-17 15:10:46',3,NULL,'2026-03-17 15:10:43','2026-03-17 15:10:43',0),(33,'20260317152826052',2,'user1','13912345678','用户默认地址',45.00,0.00,45.00,1,'2026-03-17 15:28:29',3,NULL,'2026-03-17 15:28:26','2026-03-17 15:28:26',0),(34,'20260317152953951',2,'user1','13912345678','用户默认地址',4.00,0.00,4.00,2,'2026-03-17 15:29:57',3,NULL,'2026-03-17 15:29:54','2026-03-17 15:29:54',0),(35,'20260317154617925',2,'user1','13912345678','用户默认地址',35.00,0.00,35.00,0,NULL,4,NULL,'2026-03-17 15:46:18','2026-03-17 15:46:18',0),(36,'20260317154721627',2,'user1','13912345678','用户默认地址',18.00,0.00,18.00,1,'2026-03-17 15:47:50',3,NULL,'2026-03-17 15:47:22','2026-03-17 15:47:22',0),(37,'20260319182712437',2,'user1','13912345678','用户默认地址',18.00,0.00,18.00,0,NULL,4,NULL,'2026-03-19 18:27:12','2026-03-19 18:27:12',0),(38,'20260321145111652',2,'user1','13912345678','用户默认地址',68.00,0.00,68.00,0,NULL,4,NULL,'2026-03-21 14:51:12','2026-03-21 14:51:12',0),(39,'20260321145120795',2,'user1','13912345678','用户默认地址',68.00,0.00,68.00,2,'2026-03-21 14:53:30',3,NULL,'2026-03-21 14:51:21','2026-03-21 14:51:21',0),(40,'20260321150328867',2,'user1','13912345678','用户默认地址',18.00,0.00,18.00,0,NULL,4,NULL,'2026-03-21 15:03:29','2026-03-21 15:03:29',0),(41,'20260323105506481',2,'user1','13912345678','用户默认地址',4.00,0.00,4.00,2,'2026-03-23 10:55:10',3,NULL,'2026-03-23 10:55:06','2026-03-23 10:55:06',0),(42,'20260323105543598',2,'user1','13912345678','用户默认地址',18.00,0.00,18.00,1,'2026-03-23 10:55:46',2,NULL,'2026-03-23 10:55:44','2026-03-23 10:55:44',0),(43,'20260323111227493',2,'user1','13912345678','用户默认地址',18.00,0.00,18.00,1,'2026-03-23 11:12:47',2,NULL,'2026-03-23 11:12:27','2026-03-23 11:12:27',0),(44,'20260324150029414',22,'afishing','15528270575','用户默认地址',158.00,0.00,158.00,1,'2026-03-24 15:00:33',1,NULL,'2026-03-24 15:00:29','2026-03-24 15:00:29',0),(45,'20260324150707641',22,'afishing','15528270575','用户默认地址',7.00,0.00,7.00,1,'2026-03-24 15:07:12',3,NULL,'2026-03-24 15:07:08','2026-03-24 15:07:08',0),(46,'20260324151457322',22,'afishing','15528270575','用户默认地址',7.00,0.00,7.00,1,'2026-03-24 15:15:00',3,NULL,'2026-03-24 15:14:57','2026-03-24 15:14:57',0),(47,'20260324151828755',22,'afishing','15528270575','用户默认地址',7.00,0.00,7.00,1,'2026-03-24 15:18:32',3,NULL,'2026-03-24 15:18:29','2026-03-24 15:18:29',0),(48,'20260324153528208',22,'afishing','15528270575','用户默认地址',7.00,0.00,7.00,1,'2026-03-24 15:35:31',3,NULL,'2026-03-24 15:35:28','2026-03-24 15:35:28',0),(49,'20260324154956968',22,'afishing','15528270575','用户默认地址',4.00,0.00,4.00,1,'2026-03-24 15:50:00',3,NULL,'2026-03-24 15:49:57','2026-03-24 15:49:57',0),(50,'20260324155019339',22,'afishing','15528270575','用户默认地址',4.00,0.00,4.00,1,'2026-03-24 15:50:22',2,NULL,'2026-03-24 15:50:19','2026-03-24 15:50:19',0),(51,'20260324201630533',22,'afishing','15528270575','用户默认地址',7.00,0.00,7.00,1,'2026-03-24 20:16:35',3,NULL,'2026-03-24 20:16:31','2026-03-24 20:16:31',0),(52,'20260327131539207',2,'user1','13912345678','用户默认地址',18.00,0.00,18.00,1,'2026-03-27 13:15:52',1,NULL,'2026-03-27 13:15:39','2026-03-27 13:15:39',0),(53,'20260327131615158',2,'user1','13912345678','用户默认地址',68.00,0.00,68.00,0,NULL,4,NULL,'2026-03-27 13:16:15','2026-03-27 13:16:15',0),(54,'20260330153029542',2,'user1','13912345678','用户默认地址',45.00,0.00,45.00,1,'2026-03-30 15:30:35',2,NULL,'2026-03-30 15:30:30','2026-03-30 15:30:30',0),(55,'20260330154028182',2,'user1','13912345678','用户默认地址',90.00,0.00,90.00,1,'2026-03-30 15:40:31',2,NULL,'2026-03-30 15:40:28','2026-03-30 15:40:28',0),(56,'20260406170945987',2,'user1','13912345678','用户默认地址',35.00,0.00,35.00,1,'2026-04-06 17:09:49',2,NULL,'2026-04-06 17:09:46','2026-04-06 17:09:46',0),(57,'20260406171305171',2,'user1','13912345678','用户默认地址',90.00,0.00,90.00,2,'2026-04-06 17:13:11',2,NULL,'2026-04-06 17:13:05','2026-04-06 17:13:05',0),(58,'20260406171321907',2,'user1','13912345678','用户默认地址',18.00,0.00,18.00,0,NULL,4,NULL,'2026-04-06 17:13:22','2026-04-06 17:13:22',0),(59,'20260407122524643',2,'user1','13912345678','用户默认地址',18.00,0.00,18.00,0,NULL,4,NULL,'2026-04-07 12:25:25','2026-04-07 12:25:25',0),(60,'20260407122605408',2,'user1','13912345678','用户默认地址',18.00,0.00,18.00,0,NULL,4,NULL,'2026-04-07 12:26:05','2026-04-07 12:26:05',0),(61,'20260407122822308',2,'user1','13912345678','用户默认地址',18.00,0.00,18.00,0,NULL,4,NULL,'2026-04-07 12:28:22','2026-04-07 12:28:22',0),(62,'20260407124029582',2,'user1','13912345678','用户默认地址',18.00,0.00,18.00,0,NULL,4,NULL,'2026-04-07 12:40:30','2026-04-07 12:40:30',0),(63,'20260407125245767',2,'afishing2','15528270575','用户默认地址',19800.00,0.00,19800.00,1,'2026-04-07 12:52:49',1,NULL,'2026-04-07 12:52:46','2026-04-07 12:52:46',0),(64,'20260418193420893',23,'afishing2','15528270575','用户默认地址',15.00,0.00,15.00,1,'2026-04-18 19:34:25',1,NULL,'2026-04-18 19:34:21','2026-04-18 19:34:21',0);
/*!40000 ALTER TABLE `order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_item`
--

DROP TABLE IF EXISTS `order_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_item` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '订单项ID',
  `order_id` bigint NOT NULL COMMENT '订单ID',
  `product_id` bigint NOT NULL COMMENT '商品ID',
  `product_name` varchar(100) DEFAULT NULL COMMENT '商品名称',
  `product_image` varchar(255) DEFAULT NULL COMMENT '商品图片',
  `product_spec` varchar(50) DEFAULT NULL COMMENT '商品规格',
  `price` decimal(10,2) DEFAULT NULL COMMENT '商品单价',
  `quantity` int DEFAULT NULL COMMENT '数量',
  `total_amount` decimal(10,2) DEFAULT NULL COMMENT '小计金额',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  KEY `idx_order_id` (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=86 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='订单项表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_item`
--

LOCK TABLES `order_item` WRITE;
/*!40000 ALTER TABLE `order_item` DISABLE KEYS */;
INSERT INTO `order_item` VALUES (1,1,1,'新鲜三文鱼','/uploads/79eb9d8e-1248-44bd-8213-fd584425781e.jpg','500g',68.00,2,136.00,'2026-03-16 14:40:04','2026-03-18 13:09:02',0),(2,1,2,'大闸蟹礼盒','/uploads/79eb9d8e-1248-44bd-8213-fd584425781e.jpg','8只装',299.00,1,299.00,'2026-03-16 14:40:04','2026-03-18 13:09:02',0),(3,2,3,'冷冻虾仁','/uploads/9adae37b-0522-4050-b59e-a0dc5538f1a2.jpg','1kg',45.00,3,135.00,'2026-03-16 14:40:04','2026-03-18 13:09:02',0),(4,3,1,'新鲜三文鱼','/uploads/79eb9d8e-1248-44bd-8213-fd584425781e.jpg','500g',68.00,1,68.00,'2026-03-16 14:40:04','2026-03-18 13:09:02',0),(5,4,5,'鲍鱼','/uploads/9adae37b-0522-4050-b59e-a0dc5538f1a2.jpg','6头',158.00,2,316.00,'2026-03-16 14:40:04','2026-03-18 13:09:02',0),(6,4,6,'波士顿龙虾','/uploads/79eb9d8e-1248-44bd-8213-fd584425781e.jpg','1只',398.00,1,398.00,'2026-03-16 14:40:04','2026-03-18 13:09:02',0),(7,5,6,'波士顿龙虾','/uploads/9adae37b-0522-4050-b59e-a0dc5538f1a2.jpg','1只',398.00,1,398.00,'2026-03-16 14:40:04','2026-03-18 13:09:02',0),(8,6,10,'石斑鱼','/uploads/79eb9d8e-1248-44bd-8213-fd584425781e.jpg','1kg',188.00,1,188.00,'2026-03-16 14:40:04','2026-03-18 13:09:02',0),(9,6,15,'帝王蟹','/uploads/713f0959-d0b3-475d-ae2c-c69d84567843.jpg','半只',688.00,1,688.00,'2026-03-16 14:40:04','2026-03-18 13:09:02',0),(10,7,11,'基围虾','/uploads/79eb9d8e-1248-44bd-8213-fd584425781e.jpg','1kg',68.00,2,136.00,'2026-03-16 14:40:04','2026-03-18 13:09:02',0),(11,7,16,'花蛤','/uploads/713f0959-d0b3-475d-ae2c-c69d84567843.jpg','2kg',18.00,3,54.00,'2026-03-16 14:40:04','2026-03-18 13:09:02',0),(12,8,21,'鱼丸','/uploads/79eb9d8e-1248-44bd-8213-fd584425781e.jpg','1kg',28.00,2,56.00,'2026-03-16 14:40:04','2026-03-18 13:09:02',0),(13,8,22,'虾滑','/uploads/713f0959-d0b3-475d-ae2c-c69d84567843.jpg','500g',48.00,1,48.00,'2026-03-16 14:40:04','2026-03-18 13:09:02',0),(14,9,26,'鳗鱼段','/uploads/79eb9d8e-1248-44bd-8213-fd584425781e.jpg','500g',88.00,2,176.00,'2026-03-16 14:40:04','2026-03-18 13:09:02',0),(15,10,27,'干贝','/uploads/9adae37b-0522-4050-b59e-a0dc5538f1a2.jpg','250g',128.00,1,128.00,'2026-03-16 14:40:04','2026-03-18 13:09:02',0),(16,11,28,'花胶','/uploads/713f0959-d0b3-475d-ae2c-c69d84567843.jpg','100g',298.00,1,298.00,'2026-03-16 14:40:04','2026-03-18 13:09:02',0),(17,12,29,'海参','/uploads/79eb9d8e-1248-44bd-8213-fd584425781e.jpg','100g',388.00,2,776.00,'2026-03-16 14:40:04','2026-03-18 13:09:02',0),(18,13,6,'波士顿龙虾','/uploads/9adae37b-0522-4050-b59e-a0dc5538f1a2.jpg','1只',398.00,1,398.00,'2026-03-16 14:40:04','2026-03-18 13:09:02',0),(19,14,5,'鲍鱼','/uploads/9adae37b-0522-4050-b59e-a0dc5538f1a2.jpg','6头',158.00,1,158.00,'2026-03-16 14:40:04','2026-03-18 13:09:02',0),(20,15,1,'新鲜三文鱼','/uploads/713f0959-d0b3-475d-ae2c-c69d84567843.jpg','500g',68.00,1,68.00,'2026-03-16 14:40:04','2026-03-18 13:09:02',0),(21,16,10,'石斑鱼','/uploads/9adae37b-0522-4050-b59e-a0dc5538f1a2.jpg','1kg',188.00,1,188.00,'2026-03-16 14:40:04','2026-03-18 13:09:02',0),(22,16,11,'基围虾','/uploads/79eb9d8e-1248-44bd-8213-fd584425781e.jpg','1kg',68.00,2,136.00,'2026-03-16 14:40:04','2026-03-18 13:09:02',0),(23,16,16,'花蛤','/uploads/9adae37b-0522-4050-b59e-a0dc5538f1a2.jpg','2kg',18.00,2,36.00,'2026-03-16 14:40:04','2026-03-18 13:09:02',0),(24,16,21,'鱼丸','/uploads/49785376-dd52-4073-a3ef-823957a5ecf4.jpg','1kg',28.00,2,56.00,'2026-03-16 14:40:04','2026-03-18 13:09:02',0),(25,16,22,'虾滑','/uploads/79eb9d8e-1248-44bd-8213-fd584425781e.jpg','500g',48.00,2,96.00,'2026-03-16 14:40:04','2026-03-18 13:09:02',0),(26,17,11,'基围虾','/uploads/49785376-dd52-4073-a3ef-823957a5ecf4.jpg','1kg',68.00,2,136.00,'2026-03-16 14:40:04','2026-03-18 13:09:02',0),(27,17,16,'花蛤','/uploads/9adae37b-0522-4050-b59e-a0dc5538f1a2.jpg','2kg',18.00,2,36.00,'2026-03-16 14:40:04','2026-03-18 13:09:02',0),(28,17,21,'鱼丸','/uploads/79eb9d8e-1248-44bd-8213-fd584425781e.jpg','1kg',28.00,2,56.00,'2026-03-16 14:40:04','2026-03-18 13:09:02',0),(29,18,5,'鲍鱼','/uploads/49785376-dd52-4073-a3ef-823957a5ecf4.jpg','6头',158.00,1,158.00,'2026-03-16 14:40:04','2026-03-18 13:09:02',0),(30,18,10,'石斑鱼','/uploads/79eb9d8e-1248-44bd-8213-fd584425781e.jpg','1kg',188.00,1,188.00,'2026-03-16 14:40:04','2026-03-18 13:07:14',0),(31,18,26,'鳗鱼段','/uploads/79eb9d8e-1248-44bd-8213-fd584425781e.jpg','500g',88.00,1,88.00,'2026-03-16 14:40:04','2026-03-18 13:07:14',0),(32,18,27,'干贝','/uploads/79eb9d8e-1248-44bd-8213-fd584425781e.jpg','250g',128.00,1,128.00,'2026-03-16 14:40:04','2026-03-18 13:07:14',0),(33,19,27,'干贝','/uploads/79eb9d8e-1248-44bd-8213-fd584425781e.jpg','250g',128.00,1,128.00,'2026-03-16 14:40:04','2026-03-18 13:07:14',0),(34,20,28,'花胶','/uploads/79eb9d8e-1248-44bd-8213-fd584425781e.jpg','100g',298.00,1,298.00,'2026-03-16 14:40:04','2026-03-18 13:07:14',0),(35,20,29,'海参','/uploads/79eb9d8e-1248-44bd-8213-fd584425781e.jpg','100g',388.00,1,388.00,'2026-03-16 14:40:04','2026-03-18 13:07:14',0),(36,21,15,'帝王蟹','/uploads/79eb9d8e-1248-44bd-8213-fd584425781e.jpg','半只',688.00,1,688.00,'2026-03-16 14:40:04','2026-03-18 13:07:14',0),(37,22,1,'新鲜三文鱼','/uploads/79eb9d8e-1248-44bd-8213-fd584425781e.jpg','500g',68.00,2,136.00,'2026-03-16 14:40:04','2026-03-18 13:07:14',0),(38,22,3,'冷冻虾仁','/uploads/79eb9d8e-1248-44bd-8213-fd584425781e.jpg','1kg',45.00,2,90.00,'2026-03-16 14:40:04','2026-03-18 13:07:14',0),(39,22,21,'鱼丸','/uploads/79eb9d8e-1248-44bd-8213-fd584425781e.jpg','1kg',28.00,1,28.00,'2026-03-16 14:40:04','2026-03-18 13:07:14',0),(40,23,10,'石斑鱼','/uploads/79eb9d8e-1248-44bd-8213-fd584425781e.jpg','1kg',188.00,1,188.00,'2026-03-16 14:40:04','2026-03-18 13:07:14',0),(41,23,26,'鳗鱼段','/uploads/79eb9d8e-1248-44bd-8213-fd584425781e.jpg','500g',88.00,1,88.00,'2026-03-16 14:40:04','2026-03-18 13:07:14',0),(42,23,27,'干贝','/uploads/79eb9d8e-1248-44bd-8213-fd584425781e.jpg','250g',128.00,1,128.00,'2026-03-16 14:40:04','2026-03-18 13:07:14',0),(43,23,21,'鱼丸','/uploads/79eb9d8e-1248-44bd-8213-fd584425781e.jpg','1kg',28.00,2,56.00,'2026-03-16 14:40:04','2026-03-18 13:07:14',0),(44,24,5,'鲍鱼','/uploads/79eb9d8e-1248-44bd-8213-fd584425781e.jpg','6头',158.00,2,316.00,'2026-03-16 14:40:04','2026-03-18 13:07:14',0),(45,24,11,'基围虾','/uploads/79eb9d8e-1248-44bd-8213-fd584425781e.jpg','1kg',68.00,2,136.00,'2026-03-16 14:40:04','2026-03-18 13:07:14',0),(46,25,5,'鲍鱼','/uploads/79eb9d8e-1248-44bd-8213-fd584425781e.jpg','6头',158.00,1,158.00,'2026-03-16 14:40:04','2026-03-18 13:07:14',0),(47,26,5,'鲍鱼','/uploads/79eb9d8e-1248-44bd-8213-fd584425781e.jpg','6头',158.00,2,316.00,'2026-03-17 10:53:08','2026-03-18 13:07:14',0),(48,27,6,'波士顿龙虾','/uploads/79eb9d8e-1248-44bd-8213-fd584425781e.jpg','1只',398.00,1,398.00,'2026-03-17 13:20:50','2026-03-18 13:07:14',0),(49,28,6,'波士顿龙虾','/uploads/79eb9d8e-1248-44bd-8213-fd584425781e.jpg','1只',398.00,1,398.00,'2026-03-17 13:33:46','2026-03-18 13:07:14',0),(50,29,21,'冷冻虾仁','/uploads/9adae37b-0522-4050-b59e-a0dc5538f1a2.jpg','500g',45.00,1,45.00,'2026-03-17 14:53:57','2026-03-17 14:53:57',0),(51,30,21,'冷冻虾仁','/uploads/9adae37b-0522-4050-b59e-a0dc5538f1a2.jpg','500g',45.00,1,45.00,'2026-03-17 14:56:10','2026-03-17 14:56:10',0),(52,31,16,'花蛤','/uploads/79eb9d8e-1248-44bd-8213-fd584425781e.jpg','500g',18.00,1,18.00,'2026-03-17 14:56:34','2026-03-17 14:56:34',0),(53,32,16,'花蛤','/uploads/79eb9d8e-1248-44bd-8213-fd584425781e.jpg','500g',18.00,1,18.00,'2026-03-17 15:10:43','2026-03-17 15:10:43',0),(54,33,21,'冷冻虾仁','/uploads/9adae37b-0522-4050-b59e-a0dc5538f1a2.jpg','500g',45.00,1,45.00,'2026-03-17 15:28:26','2026-03-17 15:28:26',0),(55,34,34,'宫保鸡丁','/uploads/713f0959-d0b3-475d-ae2c-c69d84567843.jpg','500g',4.00,1,4.00,'2026-03-17 15:29:54','2026-03-17 15:29:54',0),(56,35,6,'带鱼','/uploads/49785376-dd52-4073-a3ef-823957a5ecf4.jpg','500g',35.00,1,35.00,'2026-03-17 15:46:18','2026-03-17 15:46:18',0),(57,36,26,'鱼豆腐','/uploads/d7a24706-1b65-4fca-9b97-41facccb7a69.jpg','500g',18.00,1,18.00,'2026-03-17 15:47:22','2026-03-17 15:47:22',0),(58,37,16,'花蛤','http://localhost:9000/uploads/79eb9d8e-1248-44bd-8213-fd584425781e.jpg','500g',18.00,1,18.00,'2026-03-19 18:27:12','2026-03-19 18:27:12',0),(59,38,14,'基围虾','http://localhost:9000/uploads/6964dd95-00f4-4cb2-9035-7f44990fe1af.jpg','500g',68.00,1,68.00,'2026-03-21 14:51:12','2026-03-21 14:51:12',0),(60,39,14,'基围虾','http://localhost:9000/uploads/6964dd95-00f4-4cb2-9035-7f44990fe1af.jpg','500g',68.00,1,68.00,'2026-03-21 14:51:21','2026-03-21 14:51:21',0),(61,40,16,'花蛤','http://localhost:9000/uploads/79eb9d8e-1248-44bd-8213-fd584425781e.jpg','500g',18.00,1,18.00,'2026-03-21 15:03:29','2026-03-21 15:03:29',0),(62,41,34,'宫保鸡丁','http://localhost:5000/uploads/713f0959-d0b3-475d-ae2c-c69d84567843.jpg','500g',4.00,1,4.00,'2026-03-23 10:55:07','2026-03-23 10:55:07',0),(63,42,16,'花蛤','http://localhost:5000/uploads/79eb9d8e-1248-44bd-8213-fd584425781e.jpg','500g',18.00,1,18.00,'2026-03-23 10:55:44','2026-03-23 10:55:44',0),(64,43,16,'花蛤','http://localhost:5000/uploads/79eb9d8e-1248-44bd-8213-fd584425781e.jpg','500g',18.00,1,18.00,'2026-03-23 11:12:27','2026-03-23 11:12:27',0),(65,44,2,'鲍鱼','http://localhost:5000/uploads/9eb28d8c-a311-4428-b1db-7d8d110d0bdb.jpg','500g',158.00,1,158.00,'2026-03-24 15:00:29','2026-03-24 15:00:29',0),(66,45,35,'鱼香肉丝','http://localhost:5000/uploads/42190d7a-f55d-46ea-b931-7a16574d7d82.png','500g',7.00,1,7.00,'2026-03-24 15:07:08','2026-03-24 15:07:08',0),(67,46,35,'鱼香肉丝','http://localhost:5000/uploads/42190d7a-f55d-46ea-b931-7a16574d7d82.png','500g',7.00,1,7.00,'2026-03-24 15:14:57','2026-03-24 15:14:57',0),(68,47,35,'鱼香肉丝','http://localhost:5000/uploads/42190d7a-f55d-46ea-b931-7a16574d7d82.png','500g',7.00,1,7.00,'2026-03-24 15:18:29','2026-03-24 15:18:29',0),(69,48,35,'鱼香肉丝','http://localhost:5000/uploads/42190d7a-f55d-46ea-b931-7a16574d7d82.png','500g',7.00,1,7.00,'2026-03-24 15:35:28','2026-03-24 15:35:28',0),(70,49,34,'宫保鸡丁','http://localhost:5000/uploads/713f0959-d0b3-475d-ae2c-c69d84567843.jpg','500g',4.00,1,4.00,'2026-03-24 15:49:57','2026-03-24 15:49:57',0),(71,50,34,'宫保鸡丁','http://localhost:5000/uploads/713f0959-d0b3-475d-ae2c-c69d84567843.jpg','500g',4.00,1,4.00,'2026-03-24 15:50:19','2026-03-24 15:50:19',0),(72,51,35,'鱼香肉丝','http://localhost:5000/uploads/42190d7a-f55d-46ea-b931-7a16574d7d82.png','500g',7.00,1,7.00,'2026-03-24 20:16:31','2026-03-24 20:16:31',0),(73,52,16,'花蛤','http://localhost:9000/uploads/79eb9d8e-1248-44bd-8213-fd584425781e.jpg','500g',18.00,1,18.00,'2026-03-27 13:15:39','2026-03-27 13:15:39',0),(74,53,14,'基围虾','http://localhost:5000/uploads/6964dd95-00f4-4cb2-9035-7f44990fe1af.jpg','500g',68.00,1,68.00,'2026-03-27 13:16:15','2026-03-27 13:16:15',0),(75,54,7,'鲈鱼','http://localhost:5000/uploads/47aa8834-b26e-4b66-8173-4d7b038bdddf.jpg','500g',45.00,1,45.00,'2026-03-30 15:30:30','2026-03-30 15:30:30',0),(76,55,7,'鲈鱼','http://localhost:5000/uploads/47aa8834-b26e-4b66-8173-4d7b038bdddf.jpg','500g',45.00,2,90.00,'2026-03-30 15:40:28','2026-03-30 15:40:28',0),(77,56,6,'带鱼','/uploads/49785376-dd52-4073-a3ef-823957a5ecf4.jpg','500g',35.00,1,35.00,'2026-04-06 17:09:46','2026-04-06 17:09:46',0),(78,57,26,'鱼豆腐','/uploads/d7a24706-1b65-4fca-9b97-41facccb7a69.jpg','500g',18.00,5,90.00,'2026-04-06 17:13:05','2026-04-06 17:13:05',0),(79,58,26,'鱼豆腐','http://localhost:5000/uploads/d7a24706-1b65-4fca-9b97-41facccb7a69.jpg','500g',18.00,1,18.00,'2026-04-06 17:13:22','2026-04-06 17:13:22',0),(80,59,26,'鱼豆腐','http://localhost:5000/uploads/d7a24706-1b65-4fca-9b97-41facccb7a69.jpg','500g',18.00,1,18.00,'2026-04-07 12:25:25','2026-04-07 12:25:25',0),(81,60,26,'鱼豆腐','http://localhost:5000/uploads/d7a24706-1b65-4fca-9b97-41facccb7a69.jpg','500g',18.00,1,18.00,'2026-04-07 12:26:05','2026-04-07 12:26:05',0),(82,61,26,'鱼豆腐','http://localhost:5000/uploads/d7a24706-1b65-4fca-9b97-41facccb7a69.jpg','500g',18.00,1,18.00,'2026-04-07 12:28:22','2026-04-07 12:28:22',0),(83,62,26,'鱼豆腐','http://localhost:5000/uploads/d7a24706-1b65-4fca-9b97-41facccb7a69.jpg','500g',18.00,1,18.00,'2026-04-07 12:40:30','2026-04-07 12:40:30',0),(84,63,26,'鱼豆腐','http://localhost:5000/uploads/d7a24706-1b65-4fca-9b97-41facccb7a69.jpg','500g',18.00,1100,19800.00,'2026-04-07 12:52:46','2026-04-07 12:52:46',0),(85,64,25,'葡萄干','http://localhost:5000/uploads/602c1d86-b396-466f-bdbf-7b08003f196c.jpg','500g',15.00,1,15.00,'2026-04-18 19:34:21','2026-04-18 19:34:21',0);
/*!40000 ALTER TABLE `order_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Current Database: `fish_cart`
--

/*!40000 DROP DATABASE IF EXISTS `fish_cart`*/;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `fish_cart` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `fish_cart`;

--
-- Table structure for table `cart`
--

DROP TABLE IF EXISTS `cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '购物车ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `product_id` bigint NOT NULL COMMENT '商品ID',
  `product_name` varchar(100) DEFAULT NULL COMMENT '商品名称',
  `product_image` varchar(255) DEFAULT NULL COMMENT '商品图片',
  `product_spec` varchar(50) DEFAULT NULL COMMENT '商品规格',
  `price` decimal(10,2) DEFAULT NULL COMMENT '商品单价',
  `quantity` int DEFAULT '1' COMMENT '数量',
  `selected` tinyint DEFAULT '1' COMMENT '是否选中 0-否 1-是',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='购物车表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart`
--

LOCK TABLES `cart` WRITE;
/*!40000 ALTER TABLE `cart` DISABLE KEYS */;
INSERT INTO `cart` VALUES (1,1,1,'新鲜三文鱼','/uploads/0a959090-5383-480f-bd94-07ced92f5257.jpg','500g',68.00,2,1,'2026-03-16 14:40:04','2026-03-25 12:53:22',0),(2,1,2,'大闸蟹礼盒','/uploads/008c2236-151b-4baa-8885-d8c7f5945c86.jpg','8只装',299.00,1,1,'2026-03-16 14:40:04','2026-03-25 12:53:22',0),(3,1,3,'冷冻虾仁','/uploads/8e64f325-49e7-4cf0-bac2-6ca4cc67d031.jpg','1kg',45.00,3,0,'2026-03-16 14:40:04','2026-03-25 12:53:22',0),(6,3,10,'石斑鱼','/uploads/45f018ee-8310-4c3b-97de-3bedb4040dce.jpg','1kg',188.00,1,1,'2026-03-16 14:40:04','2026-03-25 12:53:22',0),(7,3,15,'帝王蟹','/uploads/71eebadb-ba67-462a-9157-413c0fd327d9.jpg','半只',688.00,1,1,'2026-03-16 14:40:04','2026-03-25 12:53:22',0),(8,4,11,'基围虾','/uploads/713f0959-d0b3-475d-ae2c-c69d84567843.jpg','1kg',68.00,2,1,'2026-03-16 14:40:04','2026-03-25 12:53:22',0),(9,4,16,'花蛤','/uploads/6964dd95-00f4-4cb2-9035-7f44990fe1af.jpg','2kg',18.00,3,1,'2026-03-16 14:40:04','2026-03-25 12:53:22',0),(10,5,21,'鱼丸','/uploads/9666a62a-a37a-4bf7-a54c-b73c1ab70311.jpg','1kg',28.00,2,1,'2026-03-16 14:40:04','2026-03-25 12:53:22',0),(11,5,22,'虾滑','/uploads/515723ce-5ba1-4a02-846b-19a80b7cdd50.jpg','500g',48.00,1,1,'2026-03-16 14:40:04','2026-03-25 12:53:22',0),(12,6,26,'鳗鱼段','/uploads/49785376-dd52-4073-a3ef-823957a5ecf4.jpg','500g',88.00,2,1,'2026-03-16 14:40:04','2026-03-25 12:53:22',0),(13,7,27,'干贝','/uploads/a84e1636-1d3b-41a8-8dc5-5f27476e6a03.jpg','250g',128.00,1,1,'2026-03-16 14:40:04','2026-03-25 12:53:22',0),(14,8,28,'花胶','/uploads/e865b87c-1011-4d7e-a3b3-0fa341b4f43c.jpg','100g',298.00,1,1,'2026-03-16 14:40:04','2026-03-25 12:53:22',0),(15,9,29,'海参','/uploads/f15a0c61-2d15-4d41-9609-6b4af9f596e8.jpg','100g',388.00,2,1,'2026-03-16 14:40:04','2026-03-25 12:53:22',0),(24,22,35,'鱼香肉丝','http://localhost:5000/uploads/42190d7a-f55d-46ea-b931-7a16574d7d82.png','500g',7.00,1,1,'2026-03-24 15:35:26','2026-03-24 15:35:26',0);
/*!40000 ALTER TABLE `cart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Current Database: `fish_pay`
--

/*!40000 DROP DATABASE IF EXISTS `fish_pay`*/;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `fish_pay` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `fish_pay`;

--
-- Table structure for table `payment`
--

DROP TABLE IF EXISTS `payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '支付ID',
  `order_id` bigint NOT NULL COMMENT '订单ID',
  `order_no` varchar(50) DEFAULT NULL COMMENT '订单号',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `pay_amount` decimal(10,2) DEFAULT NULL COMMENT '支付金额',
  `pay_type` tinyint DEFAULT '0' COMMENT '支付方式 1-支付宝 2-微信',
  `status` tinyint DEFAULT '0' COMMENT '支付状态 0-待支付 1-支付成功 2-支付失败',
  `transaction_no` varchar(100) DEFAULT NULL COMMENT '交易流水号',
  `pay_time` datetime DEFAULT NULL COMMENT '支付时间',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  KEY `idx_order_id` (`order_id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='支付记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment`
--

LOCK TABLES `payment` WRITE;
/*!40000 ALTER TABLE `payment` DISABLE KEYS */;
INSERT INTO `payment` VALUES (1,26,'20260317105308069',2,316.00,2,1,'PAY2026031710531232381DEAA58','2026-03-17 10:53:12','2026-03-17 10:53:11','2026-03-17 10:53:11',0),(2,27,'20260317132050282',2,398.00,2,0,NULL,NULL,'2026-03-17 13:20:54','2026-03-17 13:20:54',0),(3,28,'20260317133346147',2,398.00,2,0,NULL,NULL,'2026-03-17 13:33:51','2026-03-17 13:33:51',0),(4,29,'20260317145356687',2,45.00,2,0,NULL,NULL,'2026-03-17 14:53:59','2026-03-17 14:53:59',0),(5,30,'20260317145609875',2,45.00,1,2,NULL,NULL,'2026-03-17 14:56:16','2026-03-17 14:56:16',0),(6,31,'20260317145634291',2,18.00,1,0,NULL,NULL,'2026-03-17 14:56:37','2026-03-17 14:56:37',0),(7,32,'20260317151043480',2,18.00,1,1,'PAY202603171510461329C42A36F','2026-03-17 15:10:46','2026-03-17 15:10:45','2026-03-17 15:10:45',0),(8,33,'20260317152826052',2,45.00,1,1,'PAY202603171528292805DE20F70','2026-03-17 15:28:29','2026-03-17 15:28:28','2026-03-17 15:28:28',0),(9,34,'20260317152953951',2,4.00,2,1,'PAY20260317152956779390FA063','2026-03-17 15:29:57','2026-03-17 15:29:56','2026-03-17 15:29:56',0),(10,35,'20260317154617925',2,35.00,1,0,NULL,NULL,'2026-03-17 15:46:24','2026-03-17 15:46:24',0),(11,36,'20260317154721627',2,18.00,1,0,NULL,NULL,'2026-03-17 15:47:23','2026-03-17 15:47:23',0),(12,37,'20260319182712437',2,18.00,2,2,NULL,NULL,'2026-03-19 18:27:17','2026-03-19 18:27:17',0),(13,39,'20260321145120795',2,68.00,2,1,'PAY20260321145329606B479D384','2026-03-21 14:53:30','2026-03-21 14:51:26','2026-03-21 14:51:26',0),(14,40,'20260321150328867',2,18.00,1,0,NULL,NULL,'2026-03-21 15:03:31','2026-03-21 15:03:31',0),(15,41,'20260323105506481',2,4.00,2,1,'PAY202603231055102564F7A0490','2026-03-23 10:55:10','2026-03-23 10:55:09','2026-03-23 10:55:09',0),(16,42,'20260323105543598',2,18.00,1,1,'PAY20260323105546205D12282AE','2026-03-23 10:55:46','2026-03-23 10:55:45','2026-03-23 10:55:45',0),(17,43,'20260323111227493',2,18.00,1,1,'PAY2026032311124665745C5764A','2026-03-23 11:12:47','2026-03-23 11:12:30','2026-03-23 11:12:30',0),(18,44,'20260324150029414',22,158.00,1,1,'PAY202603241500327764F99ED86','2026-03-24 15:00:33','2026-03-24 15:00:32','2026-03-24 15:00:32',0),(19,45,'20260324150707641',22,7.00,1,1,'PAY202603241507119803FECCBB1','2026-03-24 15:07:12','2026-03-24 15:07:11','2026-03-24 15:07:11',0),(20,46,'20260324151457322',22,7.00,1,1,'PAY2026032415150004589605B38','2026-03-24 15:15:00','2026-03-24 15:14:59','2026-03-24 15:14:59',0),(21,47,'20260324151828755',22,7.00,1,1,'PAY202603241518318584B802F92','2026-03-24 15:18:32','2026-03-24 15:18:31','2026-03-24 15:18:31',0),(22,48,'20260324153528208',22,7.00,1,1,'PAY202603241535306208BC468C4','2026-03-24 15:35:31','2026-03-24 15:35:30','2026-03-24 15:35:30',0),(23,49,'20260324154956968',22,4.00,1,1,'PAY202603241549596812D00EB19','2026-03-24 15:50:00','2026-03-24 15:49:59','2026-03-24 15:49:59',0),(24,50,'20260324155019339',22,4.00,1,1,'PAY20260324155021755E7FDE58A','2026-03-24 15:50:22','2026-03-24 15:50:21','2026-03-24 15:50:21',0),(25,51,'20260324201630533',22,7.00,1,1,'PAY202603242016344935D633AA5','2026-03-24 20:16:34','2026-03-24 20:16:33','2026-03-24 20:16:33',0),(26,52,'20260327131539207',2,18.00,1,1,'PAY202603271315515302F6985D2','2026-03-27 13:15:52','2026-03-27 13:15:47','2026-03-27 13:15:47',0),(27,53,'20260327131615158',2,68.00,2,0,NULL,NULL,'2026-03-27 13:16:17','2026-03-27 13:16:17',0),(28,54,'20260330153029542',2,45.00,1,1,'PAY20260330153035096EBA14208','2026-03-30 15:30:35','2026-03-30 15:30:34','2026-03-30 15:30:34',0),(29,55,'20260330154028182',2,90.00,1,1,'PAY20260330154031346E4EA9ABE','2026-03-30 15:40:31','2026-03-30 15:40:30','2026-03-30 15:40:30',0),(30,56,'20260406170945987',2,35.00,1,1,'PAY20260406170949007E392C0A3','2026-04-06 17:09:49','2026-04-06 17:09:48','2026-04-06 17:09:48',0),(31,57,'20260406171305171',2,90.00,2,1,'PAY20260406171310670DD997BCE','2026-04-06 17:13:11','2026-04-06 17:13:07','2026-04-06 17:13:07',0),(32,58,'20260406171321907',2,18.00,1,0,NULL,NULL,'2026-04-06 17:13:24','2026-04-06 17:13:24',0),(33,59,'20260407122524643',2,18.00,1,0,NULL,NULL,'2026-04-07 12:25:27','2026-04-07 12:25:27',0),(34,60,'20260407122605408',2,18.00,1,0,NULL,NULL,'2026-04-07 12:26:06','2026-04-07 12:26:06',0),(35,61,'20260407122822308',2,18.00,2,0,NULL,NULL,'2026-04-07 12:28:24','2026-04-07 12:28:24',0),(36,62,'20260407124029582',2,18.00,1,0,NULL,NULL,'2026-04-07 12:40:31','2026-04-07 12:40:31',0),(37,63,'20260407125245767',2,19800.00,1,1,'PAY2026040712524883178060121','2026-04-07 12:52:49','2026-04-07 12:52:47','2026-04-07 12:52:47',0),(38,64,'20260418193420893',23,15.00,1,1,'PAY2026041819342482837BFE0CD','2026-04-18 19:34:25','2026-04-18 19:34:23','2026-04-18 19:34:23',0);
/*!40000 ALTER TABLE `payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Current Database: `fish_content`
--

/*!40000 DROP DATABASE IF EXISTS `fish_content`*/;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `fish_content` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `fish_content`;

--
-- Table structure for table `gallery_image`
--

DROP TABLE IF EXISTS `gallery_image`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gallery_image` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `filename` varchar(255) NOT NULL COMMENT '存储文件名',
  `original_name` varchar(255) DEFAULT NULL COMMENT '原始文件名',
  `url` varchar(255) NOT NULL COMMENT '访问路径',
  `size` bigint DEFAULT '0' COMMENT '文件大小（字节）',
  `mime_type` varchar(100) DEFAULT NULL COMMENT '文件MIME类型',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注/描述',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '上传时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint DEFAULT '0' COMMENT '逻辑删除 0-正常 1-已删除',
  PRIMARY KEY (`id`),
  KEY `idx_create_time` (`create_time` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=258 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='图库图片表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gallery_image`
--

LOCK TABLES `gallery_image` WRITE;
/*!40000 ALTER TABLE `gallery_image` DISABLE KEYS */;
INSERT INTO `gallery_image` VALUES (2,'5e665cab-456f-4d4f-af6b-a6f85b7dd955.jpg','8e64f325-49e7-4cf0-bac2-6ca4cc67d031.jpg','/uploads/5e665cab-456f-4d4f-af6b-a6f85b7dd955.jpg',7543,'image/jpeg',NULL,'2026-03-26 13:35:15','2026-04-06 10:55:01',1),(3,'7af5a204-b58f-4da8-9f99-fcf2a7aef2dd.jpg','8e64f325-49e7-4cf0-bac2-6ca4cc67d031.jpg','/uploads/7af5a204-b58f-4da8-9f99-fcf2a7aef2dd.jpg',7543,'image/jpeg',NULL,'2026-03-26 13:37:29','2026-04-06 10:52:21',1),(4,'729b5e6f-6910-4c87-8620-f65a530c63dd.jpg','1c8682a2-d2fc-4c74-92bf-89beb03c7554.jpg','/uploads/729b5e6f-6910-4c87-8620-f65a530c63dd.jpg',6596,'image/jpeg',NULL,'2026-03-26 13:37:29','2026-04-06 10:52:21',1),(5,'b82eb4ad-7977-4f0d-a411-6011e91b709e.jpg','0a959090-5383-480f-bd94-07ced92f5257.jpg','/uploads/b82eb4ad-7977-4f0d-a411-6011e91b709e.jpg',6828,'image/jpeg',NULL,'2026-03-26 13:37:29','2026-04-06 10:52:21',1),(6,'e8d3e57d-5759-430e-bcc6-c86c1de068c4.jpg','5e665cab-456f-4d4f-af6b-a6f85b7dd955.jpg','/uploads/e8d3e57d-5759-430e-bcc6-c86c1de068c4.jpg',7543,'image/jpeg',NULL,'2026-03-26 13:37:29','2026-04-06 10:52:21',1),(7,'7f5f4f14-5181-420f-a593-8cfdd7d83c3d.jpg','008c2236-151b-4baa-8885-d8c7f5945c86.jpg','/uploads/7f5f4f14-5181-420f-a593-8cfdd7d83c3d.jpg',4898,'image/jpeg',NULL,'2026-03-26 13:37:29','2026-04-06 10:52:21',1),(9,'ff5de6ef-a654-4483-98bf-e1b3ab204ee4.jpg','9c85492a-062f-4b2e-a72f-8c695e5f3854.jpg','/uploads/ff5de6ef-a654-4483-98bf-e1b3ab204ee4.jpg',5539,'image/jpeg',NULL,'2026-03-26 13:37:29','2026-04-06 10:52:21',1),(10,'46eb6fed-ae24-449f-b633-2734cc32d219.jpg','9eb28d8c-a311-4428-b1db-7d8d110d0bdb.jpg','/uploads/46eb6fed-ae24-449f-b633-2734cc32d219.jpg',4243,'image/jpeg',NULL,'2026-03-26 13:37:29','2026-04-06 10:52:21',1),(11,'21d36ff7-dbb4-4c2c-b501-2183c5307fb7.jpg','9adae37b-0522-4050-b59e-a0dc5538f1a2.jpg','/uploads/21d36ff7-dbb4-4c2c-b501-2183c5307fb7.jpg',6697,'image/jpeg',NULL,'2026-03-26 13:37:29','2026-04-06 10:52:21',1),(12,'eb4e6e59-f7e0-4f9d-aac5-2692f9a0fb76.jpg','31d285dd-695f-437a-af96-e699c7735198.jpg','/uploads/eb4e6e59-f7e0-4f9d-aac5-2692f9a0fb76.jpg',3521,'image/jpeg',NULL,'2026-03-26 13:37:29','2026-04-06 10:52:21',1),(13,'8fe7a621-11fa-44a5-be6c-5c5e0d39e6b5.jpg','23c2bb50-98e0-40d2-9946-d7fcac983a96.jpg','/uploads/8fe7a621-11fa-44a5-be6c-5c5e0d39e6b5.jpg',4898,'image/jpeg',NULL,'2026-03-26 13:37:29','2026-04-06 10:52:21',1),(14,'3d353498-c8dc-460c-bfc3-aae8a5847cad.jpg','45f018ee-8310-4c3b-97de-3bedb4040dce.jpg','/uploads/3d353498-c8dc-460c-bfc3-aae8a5847cad.jpg',5669,'image/jpeg',NULL,'2026-03-26 13:37:29','2026-04-06 10:52:21',1),(15,'00894f9a-5722-4b1a-a406-fb33bd8ed616.jpg','47aa8834-b26e-4b66-8173-4d7b038bdddf.jpg','/uploads/00894f9a-5722-4b1a-a406-fb33bd8ed616.jpg',5981,'image/jpeg',NULL,'2026-03-26 13:37:29','2026-04-06 10:52:21',1),(16,'ba81e0f0-3b64-4a57-9041-1c84d84500fc.jpg','67fc62f4-5c0c-4608-b2bb-7cedaec9d713.jpg','/uploads/ba81e0f0-3b64-4a57-9041-1c84d84500fc.jpg',3793,'image/jpeg',NULL,'2026-03-26 13:37:29','2026-04-06 10:52:21',1),(18,'cad358f1-a108-4ad6-a41f-3fa2a746289e.jpg','424f7ba1-1cf1-4e41-b16d-fd9f278b4332.jpg','/uploads/cad358f1-a108-4ad6-a41f-3fa2a746289e.jpg',8402,'image/jpeg',NULL,'2026-03-26 13:37:29','2026-04-06 10:52:21',1),(19,'2925821e-1ccd-4d74-be1a-0361c7b514b2.jpg','356cb00e-273b-4857-bb60-e80f05e70d5f.jpg','/uploads/2925821e-1ccd-4d74-be1a-0361c7b514b2.jpg',9577,'image/jpeg',NULL,'2026-03-26 13:37:29','2026-04-06 10:52:21',1),(20,'9d5d4430-b511-46a6-8165-7a89bfdc3f28.jpg','79eb9d8e-1248-44bd-8213-fd584425781e.jpg','/uploads/9d5d4430-b511-46a6-8165-7a89bfdc3f28.jpg',7257,'image/jpeg',NULL,'2026-03-26 13:37:29','2026-04-06 10:52:21',1),(21,'a5431735-44f5-46c9-8a2f-ec80add66f0c.jpg','71eebadb-ba67-462a-9157-413c0fd327d9.jpg','/uploads/a5431735-44f5-46c9-8a2f-ec80add66f0c.jpg',5236,'image/jpeg',NULL,'2026-03-26 13:37:29','2026-04-06 10:54:44',1),(23,'bc41919f-1859-4042-9fba-e4d91d6c1d9d.jpg','609b0739-ac85-4c08-8f0b-045721ecb494.jpg','/uploads/bc41919f-1859-4042-9fba-e4d91d6c1d9d.jpg',6248,'image/jpeg',NULL,'2026-03-26 13:37:29','2026-04-06 10:54:44',1),(24,'89b70b1c-288c-4a0c-9f41-dbc3a77b8c04.jpg','1784ff87-595c-428f-93c0-9dc0a4a4aa5c.jpg','/uploads/89b70b1c-288c-4a0c-9f41-dbc3a77b8c04.jpg',4378,'image/jpeg',NULL,'2026-03-26 13:37:29','2026-04-06 10:54:44',1),(25,'02b21fba-912d-42ae-8e8d-fdcc46d598f4.jpg','9666a62a-a37a-4bf7-a54c-b73c1ab70311.jpg','/uploads/02b21fba-912d-42ae-8e8d-fdcc46d598f4.jpg',7315,'image/jpeg',NULL,'2026-03-26 13:37:29','2026-04-06 10:54:44',1),(27,'ba0b3d54-6f3b-4c51-bb62-eabd488b5e37.jpg','6964dd95-00f4-4cb2-9035-7f44990fe1af.jpg','/uploads/ba0b3d54-6f3b-4c51-bb62-eabd488b5e37.jpg',6966,'image/jpeg',NULL,'2026-03-26 13:37:29','2026-04-06 10:54:44',1),(29,'90725260-da7c-4bc7-834e-6d813498dbd9.jpg','515723ce-5ba1-4a02-846b-19a80b7cdd50.jpg','/uploads/90725260-da7c-4bc7-834e-6d813498dbd9.jpg',6570,'image/jpeg',NULL,'2026-03-26 13:37:29','2026-04-06 10:55:01',1),(30,'010226fd-b0da-4424-85c1-efb18219b60c.jpg','441355c8-b625-4b71-8005-ed93528292c9.jpg','/uploads/010226fd-b0da-4424-85c1-efb18219b60c.jpg',7848,'image/jpeg',NULL,'2026-03-26 13:37:29','2026-04-06 10:55:01',1),(31,'e2ba2acc-d8ca-4ff4-9d92-48f0b3fb2a91.jpg','49785376-dd52-4073-a3ef-823957a5ecf4.jpg','/uploads/e2ba2acc-d8ca-4ff4-9d92-48f0b3fb2a91.jpg',5860,'image/jpeg',NULL,'2026-03-26 13:37:29','2026-04-06 10:55:01',1),(32,'912dec02-b1d4-40c3-8c0a-6470ab92a744.jpg','82908820-48ff-43c5-8e98-c14621b03773.jpg','/uploads/912dec02-b1d4-40c3-8c0a-6470ab92a744.jpg',4898,'image/jpeg',NULL,'2026-03-26 13:37:29','2026-04-06 10:55:01',1),(33,'7ff552ff-32eb-401f-bf8f-36c79b5ec8f3.jpg','a84e1636-1d3b-41a8-8dc5-5f27476e6a03.jpg','/uploads/7ff552ff-32eb-401f-bf8f-36c79b5ec8f3.jpg',3179,'image/jpeg',NULL,'2026-03-26 13:37:29','2026-04-06 10:55:01',1),(34,'d091e5e4-4100-4830-895b-07e8b27bc9fd.jpg','a61a7a57-9cd3-40f6-9cb5-31d2c22ec394.jpg','/uploads/d091e5e4-4100-4830-895b-07e8b27bc9fd.jpg',5398,'image/jpeg',NULL,'2026-03-26 13:37:29','2026-04-06 10:55:01',1),(35,'182cf30c-6836-4755-84eb-4f48537b14ca.jpg','ceffaf9b-62b2-450f-9b20-ae4996e0017a.jpg','/uploads/182cf30c-6836-4755-84eb-4f48537b14ca.jpg',9845,'image/jpeg',NULL,'2026-03-26 13:37:29','2026-04-06 10:55:01',1),(36,'cc54c449-e24a-4f2a-aab6-4fe4ee6276b9.jpg','d7a24706-1b65-4fca-9b97-41facccb7a69.jpg','/uploads/cc54c449-e24a-4f2a-aab6-4fe4ee6276b9.jpg',5215,'image/jpeg',NULL,'2026-03-26 13:37:29','2026-04-06 10:55:01',1),(37,'b827122b-6eec-49fc-aff2-dc6a0e64c9b3.jpg','d6a574ed-b14a-4be5-a590-7a26a3a90603.jpg','/uploads/b827122b-6eec-49fc-aff2-dc6a0e64c9b3.jpg',3739,'image/jpeg',NULL,'2026-03-26 13:37:29','2026-04-06 10:55:01',1),(38,'ee01b590-67d0-4d60-b80d-9a4a3a07441f.jpg','e865b87c-1011-4d7e-a3b3-0fa341b4f43c.jpg','/uploads/ee01b590-67d0-4d60-b80d-9a4a3a07441f.jpg',6163,'image/jpeg',NULL,'2026-03-26 13:37:29','2026-04-06 10:55:01',1),(39,'966c3c90-121d-413b-a3e2-212fa8a1ab64.jpg','e903996b-396b-4e29-a9ed-889a7e61af4a.jpg','/uploads/966c3c90-121d-413b-a3e2-212fa8a1ab64.jpg',7663,'image/jpeg',NULL,'2026-03-26 13:37:29','2026-04-06 10:55:01',1),(40,'12748db6-c849-48c4-8003-7d8b0cbe074f.jpg','f0211364-c0d8-48a6-8e10-7cc2e9c34538.jpg','/uploads/12748db6-c849-48c4-8003-7d8b0cbe074f.jpg',8256,'image/jpeg',NULL,'2026-03-26 13:37:29','2026-04-06 10:55:01',1),(41,'2797bfa2-7804-419c-a064-7891710a9c18.jpg','f813895a-7773-478d-856a-ecc3fa40f5fe.jpg','/uploads/2797bfa2-7804-419c-a064-7891710a9c18.jpg',3852,'image/jpeg',NULL,'2026-03-26 13:37:29','2026-04-06 10:55:01',1),(42,'00f2f6ab-2908-4506-9c99-d8fd14567083.jpg','f15a0c61-2d15-4d41-9609-6b4af9f596e8.jpg','/uploads/00f2f6ab-2908-4506-9c99-d8fd14567083.jpg',5667,'image/jpeg',NULL,'2026-03-26 13:37:29','2026-04-06 10:55:01',1),(43,'a92f2ccc-6f6b-4b29-9439-9e0eb9e82c66.jpg','fe9cb888-158d-45ad-9dab-75633faa8500.jpg','/uploads/a92f2ccc-6f6b-4b29-9439-9e0eb9e82c66.jpg',5981,'image/jpeg',NULL,'2026-03-26 13:37:29','2026-04-06 10:55:01',1),(44,'26e86b06-682b-4370-9d29-ba0e3406bbee.jpg','ff31da80-6791-4037-ae35-ad3fe4d35993.jpg','/uploads/26e86b06-682b-4370-9d29-ba0e3406bbee.jpg',9852,'image/jpeg',NULL,'2026-03-26 13:37:29','2026-04-06 10:55:01',1),(45,'73674cd5-2522-4d01-afbe-aa8844a33c4e.jpg','0a959090-5383-480f-bd94-07ced92f5257.jpg','/uploads/73674cd5-2522-4d01-afbe-aa8844a33c4e.jpg',6828,'image/jpeg',NULL,'2026-03-26 13:39:42','2026-04-06 10:52:21',1),(46,'5a11ac84-28bf-4079-ac5e-6ac96f4dccb7.jpg','0a959090-5383-480f-bd94-07ced92f5257.jpg','/uploads/5a11ac84-28bf-4079-ac5e-6ac96f4dccb7.jpg',6828,'image/jpeg',NULL,'2026-03-26 13:43:21','2026-04-06 00:58:51',1),(47,'295c704c-bd08-4aa2-a6d7-f784d8d0292e.jpg','7f5f4f14-5181-420f-a593-8cfdd7d83c3d.jpg','/uploads/295c704c-bd08-4aa2-a6d7-f784d8d0292e.jpg',4898,'image/jpeg',NULL,'2026-03-26 13:49:12','2026-04-06 00:58:47',1),(48,'026a71f6-69ba-416f-9780-8541e1d0d2e4.jpg','34983588AB3E21EB0EB7B385CD33C034.jpg','/uploads/026a71f6-69ba-416f-9780-8541e1d0d2e4.jpg',93691,'image/jpeg',NULL,'2026-03-30 14:28:16','2026-04-06 10:52:21',1),(49,'884b3904-0379-47bc-a14c-19e6a2538079.png','下载.mp4_20260120_001201.208.png','/uploads/884b3904-0379-47bc-a14c-19e6a2538079.png',463288,NULL,NULL,'2026-04-06 00:55:08','2026-04-06 00:55:08',0),(50,'d596fb15-7b9c-49a2-9e2b-d19cb2b8c964.jpg','E77F2E48E8748FA015FF5BDA8B5F392A.jpg','/uploads/d596fb15-7b9c-49a2-9e2b-d19cb2b8c964.jpg',59331,NULL,NULL,'2026-04-06 00:59:01','2026-04-06 00:59:01',0),(51,'97d5f4f2-c1d6-4ea1-b34f-28c94eb44dbb.jpg','47aa8834-b26e-4b66-8173-4d7b038bdddf.jpg','/uploads/97d5f4f2-c1d6-4ea1-b34f-28c94eb44dbb.jpg',5981,NULL,NULL,'2026-04-06 10:59:07','2026-04-06 10:59:07',0),(52,'bf38529c-18bd-4ecf-8930-31fdfec4eb0d.jpg','9c85492a-062f-4b2e-a72f-8c695e5f3854.jpg','/uploads/bf38529c-18bd-4ecf-8930-31fdfec4eb0d.jpg',5539,NULL,NULL,'2026-04-06 10:59:12','2026-04-06 11:01:52',1),(53,'158f4a29-df24-4658-8699-d1d80b0328a1.jpg','8e64f325-49e7-4cf0-bac2-6ca4cc67d031.jpg','/uploads/158f4a29-df24-4658-8699-d1d80b0328a1.jpg',7543,NULL,NULL,'2026-04-06 10:59:12','2026-04-06 10:59:12',0),(54,'60dce9a1-1984-4c77-9286-b971a9f5705a.jpg','9adae37b-0522-4050-b59e-a0dc5538f1a2.jpg','/uploads/60dce9a1-1984-4c77-9286-b971a9f5705a.jpg',6697,NULL,NULL,'2026-04-06 10:59:12','2026-04-06 10:59:12',0),(55,'a643629e-129f-488d-acca-336a4ebc6bb8.jpg','008c2236-151b-4baa-8885-d8c7f5945c86.jpg','/uploads/a643629e-129f-488d-acca-336a4ebc6bb8.jpg',4898,NULL,NULL,'2026-04-06 10:59:12','2026-04-06 10:59:12',0),(56,'0cb35633-0983-4ecd-b29a-cae81f446824.jpg','1c8682a2-d2fc-4c74-92bf-89beb03c7554.jpg','/uploads/0cb35633-0983-4ecd-b29a-cae81f446824.jpg',6596,NULL,NULL,'2026-04-06 10:59:52','2026-04-06 10:59:52',0),(57,'4595410c-747c-491b-8e26-5647c450c777.jpg','0a959090-5383-480f-bd94-07ced92f5257.jpg','/uploads/4595410c-747c-491b-8e26-5647c450c777.jpg',6828,NULL,NULL,'2026-04-06 10:59:52','2026-04-06 10:59:52',0),(58,'a8358003-a18f-4e41-bf42-7fa813893650.jpg','9adae37b-0522-4050-b59e-a0dc5538f1a2.jpg','/uploads/a8358003-a18f-4e41-bf42-7fa813893650.jpg',6697,NULL,NULL,'2026-04-06 10:59:52','2026-04-06 11:01:51',1),(59,'c9c2e64a-7ffa-49d3-8e1f-af71aea9fd04.jpg','008c2236-151b-4baa-8885-d8c7f5945c86.jpg','/uploads/c9c2e64a-7ffa-49d3-8e1f-af71aea9fd04.jpg',4898,NULL,NULL,'2026-04-06 10:59:52','2026-04-06 11:01:52',1),(60,'a6c55add-657c-4f7d-8a1d-69603e542517.jpg','9c85492a-062f-4b2e-a72f-8c695e5f3854.jpg','/uploads/a6c55add-657c-4f7d-8a1d-69603e542517.jpg',5539,NULL,NULL,'2026-04-06 11:00:28','2026-04-06 11:00:28',0),(61,'bb3a2727-c3c1-468c-abfe-9312c3811e06.jpg','008c2236-151b-4baa-8885-d8c7f5945c86.jpg','/uploads/bb3a2727-c3c1-468c-abfe-9312c3811e06.jpg',4898,NULL,NULL,'2026-04-06 11:02:05','2026-04-06 11:02:05',0),(62,'be795874-e181-48aa-a725-fff4084b6bda.jpg','1c8682a2-d2fc-4c74-92bf-89beb03c7554.jpg','/uploads/be795874-e181-48aa-a725-fff4084b6bda.jpg',6596,NULL,NULL,'2026-04-06 11:02:05','2026-04-06 11:02:05',0),(63,'aa924597-7f25-4efc-ba18-87ce59852813.jpg','0a959090-5383-480f-bd94-07ced92f5257.jpg','/uploads/aa924597-7f25-4efc-ba18-87ce59852813.jpg',6828,NULL,NULL,'2026-04-06 11:02:05','2026-04-06 11:02:05',0),(64,'b7244fba-be22-4462-9750-4f9a628d63a4.jpg','0cb35633-0983-4ecd-b29a-cae81f446824.jpg','/uploads/b7244fba-be22-4462-9750-4f9a628d63a4.jpg',6596,NULL,NULL,'2026-04-06 11:02:05','2026-04-06 11:02:05',0),(65,'5b194a7e-843e-4dfc-a73a-a6bbf7b01e7c.jpg','9adae37b-0522-4050-b59e-a0dc5538f1a2.jpg','/uploads/5b194a7e-843e-4dfc-a73a-a6bbf7b01e7c.jpg',6697,NULL,NULL,'2026-04-06 11:02:05','2026-04-06 11:02:05',0),(66,'0ed4df8d-640a-426a-908e-3fa63094728a.jpg','8e64f325-49e7-4cf0-bac2-6ca4cc67d031.jpg','/uploads/0ed4df8d-640a-426a-908e-3fa63094728a.jpg',7543,NULL,NULL,'2026-04-06 11:02:05','2026-04-06 11:02:05',0),(67,'fd1ea89d-aa8f-4871-80d0-01a723c73a22.jpg','9c85492a-062f-4b2e-a72f-8c695e5f3854.jpg','/uploads/fd1ea89d-aa8f-4871-80d0-01a723c73a22.jpg',5539,NULL,NULL,'2026-04-06 11:02:05','2026-04-06 11:02:05',0),(68,'fd3ee18e-41b5-4175-bcdd-4e2c8ed8a2e0.jpg','9eb28d8c-a311-4428-b1db-7d8d110d0bdb.jpg','/uploads/fd3ee18e-41b5-4175-bcdd-4e2c8ed8a2e0.jpg',4243,NULL,NULL,'2026-04-06 11:02:05','2026-04-06 11:02:05',0),(69,'be0988c3-31e1-48ec-a22e-d54b473acb9d.jpg','31d285dd-695f-437a-af96-e699c7735198.jpg','/uploads/be0988c3-31e1-48ec-a22e-d54b473acb9d.jpg',3521,NULL,NULL,'2026-04-06 11:02:05','2026-04-06 11:02:05',0),(70,'9d663706-9a10-446b-b291-04ae3ef995de.jpg','45f018ee-8310-4c3b-97de-3bedb4040dce.jpg','/uploads/9d663706-9a10-446b-b291-04ae3ef995de.jpg',5669,NULL,NULL,'2026-04-06 11:02:05','2026-04-06 11:02:05',0),(71,'8fb58dc2-23a1-4be3-9a95-84b54fd706ab.jpg','47aa8834-b26e-4b66-8173-4d7b038bdddf.jpg','/uploads/8fb58dc2-23a1-4be3-9a95-84b54fd706ab.jpg',5981,NULL,NULL,'2026-04-06 11:02:05','2026-04-06 11:02:05',0),(72,'7cb2e918-707b-4a18-a531-f0f901e68ea8.jpg','67fc62f4-5c0c-4608-b2bb-7cedaec9d713.jpg','/uploads/7cb2e918-707b-4a18-a531-f0f901e68ea8.jpg',3793,NULL,NULL,'2026-04-06 11:02:05','2026-04-06 11:02:05',0),(73,'030508fe-cf10-46c7-a500-7c86e9aa619c.jpg','71eebadb-ba67-462a-9157-413c0fd327d9.jpg','/uploads/030508fe-cf10-46c7-a500-7c86e9aa619c.jpg',5236,NULL,NULL,'2026-04-06 11:02:05','2026-04-06 11:02:05',0),(74,'59549abe-bf4d-4b63-9f47-8665dc180103.jpg','79eb9d8e-1248-44bd-8213-fd584425781e.jpg','/uploads/59549abe-bf4d-4b63-9f47-8665dc180103.jpg',7257,NULL,NULL,'2026-04-06 11:02:05','2026-04-06 11:02:05',0),(75,'05aa09a4-ecfc-4e93-9896-dcbc46869fe0.jpg','60dce9a1-1984-4c77-9286-b971a9f5705a.jpg','/uploads/05aa09a4-ecfc-4e93-9896-dcbc46869fe0.jpg',6697,NULL,NULL,'2026-04-06 11:02:05','2026-04-06 11:02:05',0),(76,'f70bd135-4b26-4503-93f8-f4511e7ed710.jpg','97d5f4f2-c1d6-4ea1-b34f-28c94eb44dbb.jpg','/uploads/f70bd135-4b26-4503-93f8-f4511e7ed710.jpg',5981,NULL,NULL,'2026-04-06 11:02:05','2026-04-06 11:02:05',0),(77,'10efe11b-6680-480a-87c7-a427c5aa1946.jpg','158f4a29-df24-4658-8699-d1d80b0328a1.jpg','/uploads/10efe11b-6680-480a-87c7-a427c5aa1946.jpg',7543,NULL,NULL,'2026-04-06 11:02:05','2026-04-06 11:02:05',0),(78,'cb287cac-d1f2-4c82-b0d1-96e0a86d111c.jpg','356cb00e-273b-4857-bb60-e80f05e70d5f.jpg','/uploads/cb287cac-d1f2-4c82-b0d1-96e0a86d111c.jpg',9577,NULL,NULL,'2026-04-06 11:02:05','2026-04-06 11:02:05',0),(79,'60a6b0b5-3686-4e05-b272-4e15b6a1efce.jpg','609b0739-ac85-4c08-8f0b-045721ecb494.jpg','/uploads/60a6b0b5-3686-4e05-b272-4e15b6a1efce.jpg',6248,NULL,NULL,'2026-04-06 11:02:05','2026-04-06 11:02:05',0),(80,'2c5a9a1f-7eb2-4288-b2db-64da49ddea8a.jpg','713f0959-d0b3-475d-ae2c-c69d84567843.jpg','/uploads/2c5a9a1f-7eb2-4288-b2db-64da49ddea8a.jpg',82421,NULL,NULL,'2026-04-06 11:02:05','2026-04-06 11:02:05',0),(81,'dc67b9e5-df69-40fb-b3bc-3560734e53dd.jpg','424f7ba1-1cf1-4e41-b16d-fd9f278b4332.jpg','/uploads/dc67b9e5-df69-40fb-b3bc-3560734e53dd.jpg',8402,NULL,NULL,'2026-04-06 11:02:05','2026-04-06 11:02:05',0),(82,'516cf3d7-a6dc-45f3-86d9-e4f8c4c43655.jpg','1784ff87-595c-428f-93c0-9dc0a4a4aa5c.jpg','/uploads/516cf3d7-a6dc-45f3-86d9-e4f8c4c43655.jpg',4378,NULL,NULL,'2026-04-06 11:02:05','2026-04-06 11:02:05',0),(83,'4acbc6a6-101d-4353-ba54-fe54ece278a5.jpg','6964dd95-00f4-4cb2-9035-7f44990fe1af.jpg','/uploads/4acbc6a6-101d-4353-ba54-fe54ece278a5.jpg',6966,NULL,NULL,'2026-04-06 11:02:05','2026-04-06 11:02:05',0),(84,'9c0a7a99-dcd2-4a76-b00c-f3c135d454af.png','884b3904-0379-47bc-a14c-19e6a2538079.png','/uploads/9c0a7a99-dcd2-4a76-b00c-f3c135d454af.png',463288,NULL,NULL,'2026-04-06 11:02:05','2026-04-06 11:02:05',0),(85,'711c942d-511b-4ecf-b5f3-04656fead0ae.jpg','9666a62a-a37a-4bf7-a54c-b73c1ab70311.jpg','/uploads/711c942d-511b-4ecf-b5f3-04656fead0ae.jpg',7315,NULL,NULL,'2026-04-06 11:02:05','2026-04-06 11:02:05',0),(86,'7b937928-f1c2-4861-b45f-f2cc07949988.jpg','515723ce-5ba1-4a02-846b-19a80b7cdd50.jpg','/uploads/7b937928-f1c2-4861-b45f-f2cc07949988.jpg',6570,NULL,NULL,'2026-04-06 11:02:05','2026-04-06 11:02:05',0),(87,'23770a1c-a076-4620-bd3e-b60bad9c1fff.jpg','49785376-dd52-4073-a3ef-823957a5ecf4.jpg','/uploads/23770a1c-a076-4620-bd3e-b60bad9c1fff.jpg',5860,NULL,NULL,'2026-04-06 11:02:05','2026-04-06 11:02:05',0),(88,'fea1f91d-5877-495b-8cde-2dd3494e59e7.jpg','4595410c-747c-491b-8e26-5647c450c777.jpg','/uploads/fea1f91d-5877-495b-8cde-2dd3494e59e7.jpg',6828,NULL,NULL,'2026-04-06 11:02:05','2026-04-06 11:02:05',0),(89,'45d202f7-6a88-4572-88fd-d153715ed0aa.jpg','441355c8-b625-4b71-8005-ed93528292c9.jpg','/uploads/45d202f7-6a88-4572-88fd-d153715ed0aa.jpg',7848,NULL,NULL,'2026-04-06 11:02:05','2026-04-06 11:02:05',0),(90,'6efaa766-2a5e-47e1-a81e-6c1dd781068b.png','36697408-a4e3-4a81-9dba-9bb56f1f0dfb.png','/uploads/6efaa766-2a5e-47e1-a81e-6c1dd781068b.png',520992,NULL,NULL,'2026-04-06 11:02:05','2026-04-06 11:02:05',0),(91,'4657afc7-843e-411f-91aa-037997307cdc.jpg','94813564-141d-4ffd-b15d-cd17b54e91b4.jpg','/uploads/4657afc7-843e-411f-91aa-037997307cdc.jpg',128703,NULL,NULL,'2026-04-06 11:02:05','2026-04-06 11:02:05',0),(92,'e96e312c-ebb8-4290-a1d6-30a90d295a67.jpg','a61a7a57-9cd3-40f6-9cb5-31d2c22ec394.jpg','/uploads/e96e312c-ebb8-4290-a1d6-30a90d295a67.jpg',5398,NULL,NULL,'2026-04-06 11:02:05','2026-04-06 11:02:05',0),(93,'d03c24e9-bee5-451b-bb86-de3bd11b362f.jpg','a6c55add-657c-4f7d-8a1d-69603e542517.jpg','/uploads/d03c24e9-bee5-451b-bb86-de3bd11b362f.jpg',5539,NULL,NULL,'2026-04-06 11:02:05','2026-04-06 11:02:05',0),(94,'87122221-4a0c-4e3c-95bc-d1264ce94a2b.jpg','a84e1636-1d3b-41a8-8dc5-5f27476e6a03.jpg','/uploads/87122221-4a0c-4e3c-95bc-d1264ce94a2b.jpg',3179,NULL,NULL,'2026-04-06 11:02:05','2026-04-06 11:02:05',0),(95,'133b3c67-6972-4a00-90c7-d83636491dcc.jpg','a643629e-129f-488d-acca-336a4ebc6bb8.jpg','/uploads/133b3c67-6972-4a00-90c7-d83636491dcc.jpg',4898,NULL,NULL,'2026-04-06 11:02:05','2026-04-06 11:02:05',0),(96,'1e7fda81-0d16-40bc-b61a-284750c7bc97.jpg','ceffaf9b-62b2-450f-9b20-ae4996e0017a.jpg','/uploads/1e7fda81-0d16-40bc-b61a-284750c7bc97.jpg',9845,NULL,NULL,'2026-04-06 11:02:05','2026-04-06 11:02:05',0),(97,'ac8989a2-5a37-4c42-923f-79e1063953f7.jpg','d7a24706-1b65-4fca-9b97-41facccb7a69.jpg','/uploads/ac8989a2-5a37-4c42-923f-79e1063953f7.jpg',5215,NULL,NULL,'2026-04-06 11:02:05','2026-04-06 11:02:05',0),(98,'b0803173-910b-4d90-8cca-3a26cf46e89b.jpg','d6a574ed-b14a-4be5-a590-7a26a3a90603.jpg','/uploads/b0803173-910b-4d90-8cca-3a26cf46e89b.jpg',3739,NULL,NULL,'2026-04-06 11:02:05','2026-04-06 11:02:05',0),(99,'8b5d30ce-06d0-4655-8e9e-7784baaf8bf8.jpg','d596fb15-7b9c-49a2-9e2b-d19cb2b8c964.jpg','/uploads/8b5d30ce-06d0-4655-8e9e-7784baaf8bf8.jpg',59331,NULL,NULL,'2026-04-06 11:02:05','2026-04-06 11:02:05',0),(100,'0b7d75ba-9f9f-4bb8-beac-1015f4311531.jpg','f15a0c61-2d15-4d41-9609-6b4af9f596e8.jpg','/uploads/0b7d75ba-9f9f-4bb8-beac-1015f4311531.jpg',5667,NULL,NULL,'2026-04-06 11:02:05','2026-04-06 11:02:05',0),(101,'cc5cde33-5161-4c71-b136-05b9fa23d4ef.jpg','f0211364-c0d8-48a6-8e10-7cc2e9c34538.jpg','/uploads/cc5cde33-5161-4c71-b136-05b9fa23d4ef.jpg',8256,NULL,NULL,'2026-04-06 11:02:05','2026-04-06 11:02:05',0),(102,'c9e0a7b0-d3e4-4882-b279-25ba71d1d5e4.jpg','e903996b-396b-4e29-a9ed-889a7e61af4a.jpg','/uploads/c9e0a7b0-d3e4-4882-b279-25ba71d1d5e4.jpg',7663,NULL,NULL,'2026-04-06 11:02:05','2026-04-06 11:02:05',0),(103,'0db58b17-589b-4f0c-bd5e-6f12782e0649.png','b6dd5fc6-d0a9-471d-9ac5-1715d2d597d4.png','/uploads/0db58b17-589b-4f0c-bd5e-6f12782e0649.png',463288,NULL,NULL,'2026-04-06 11:02:05','2026-04-06 11:02:05',0),(104,'e5ac05ed-f884-4420-8e25-32f2c14a5669.jpg','f813895a-7773-478d-856a-ecc3fa40f5fe.jpg','/uploads/e5ac05ed-f884-4420-8e25-32f2c14a5669.jpg',3852,NULL,NULL,'2026-04-06 11:02:05','2026-04-06 11:02:05',0),(105,'ff9e8173-e1f3-47fa-9f7a-675b2fc28a38.jpg','ff31da80-6791-4037-ae35-ad3fe4d35993.jpg','/uploads/ff9e8173-e1f3-47fa-9f7a-675b2fc28a38.jpg',9852,NULL,NULL,'2026-04-06 11:02:05','2026-04-06 11:02:05',0),(106,'7cc82b33-3bdc-47d8-89be-ac85a3423c40.jpg','e865b87c-1011-4d7e-a3b3-0fa341b4f43c.jpg','/uploads/7cc82b33-3bdc-47d8-89be-ac85a3423c40.jpg',6163,NULL,NULL,'2026-04-06 11:02:05','2026-04-06 11:02:05',0),(107,'15ba33e5-9fac-424f-9e38-8ea53a307383.jpg','1e7fda81-0d16-40bc-b61a-284750c7bc97.jpg','/uploads/15ba33e5-9fac-424f-9e38-8ea53a307383.jpg',9845,NULL,NULL,'2026-04-06 11:06:31','2026-04-06 11:06:31',0),(108,'96ce9530-4317-4278-997e-5be4530557d5.jpg','2c5a9a1f-7eb2-4288-b2db-64da49ddea8a.jpg','/uploads/96ce9530-4317-4278-997e-5be4530557d5.jpg',82421,NULL,NULL,'2026-04-06 11:07:05','2026-04-06 11:07:05',0),(109,'ff4519ab-143c-4b56-92c3-5f7731a2a6c1.jpg','158f4a29-df24-4658-8699-d1d80b0328a1.jpg','/uploads/ff4519ab-143c-4b56-92c3-5f7731a2a6c1.jpg',7543,NULL,NULL,'2026-04-06 11:07:17','2026-04-06 11:07:17',0),(110,'99279333-4d8d-4f30-ac24-dc77dab21c5a.jpg','雨爱-封面.jpg','/uploads/99279333-4d8d-4f30-ac24-dc77dab21c5a.jpg',43714,NULL,NULL,'2026-04-06 17:03:52','2026-04-06 17:03:52',0),(111,'22cc1334-d815-40d2-94cb-3ddceec217c5.jpg','九江 (7).jpg','/uploads/22cc1334-d815-40d2-94cb-3ddceec217c5.jpg',64528,NULL,NULL,'2026-04-18 18:08:30','2026-04-18 18:08:30',0),(112,'bdc43728-c04a-4733-a25a-5d3f5c82352c.jpg','劲酒 (5).jpg','/uploads/bdc43728-c04a-4733-a25a-5d3f5c82352c.jpg',70614,NULL,NULL,'2026-04-18 18:08:30','2026-04-18 18:08:30',0),(113,'c933af56-a45f-4b9a-97b2-fb265309d2e5.jpg','衡水老白干 (4).jpg','/uploads/c933af56-a45f-4b9a-97b2-fb265309d2e5.jpg',63849,NULL,NULL,'2026-04-18 18:08:30','2026-04-18 18:08:30',0),(114,'db23af79-7e06-456b-9fa6-da346872929c.jpg','江小白 (37).jpg','/uploads/db23af79-7e06-456b-9fa6-da346872929c.jpg',136189,NULL,NULL,'2026-04-18 18:08:30','2026-04-18 18:08:30',0),(115,'a046e133-6eb3-4dee-a19e-a2a75df91057.jpg','口子窖 (5).jpg','/uploads/a046e133-6eb3-4dee-a19e-a2a75df91057.jpg',165692,NULL,NULL,'2026-04-18 18:08:30','2026-04-18 18:08:30',0),(116,'7e77b496-8ced-4b0a-8caf-b7b3ff53625b.jpg','口子窖 (2).jpg','/uploads/7e77b496-8ced-4b0a-8caf-b7b3ff53625b.jpg',321578,NULL,NULL,'2026-04-18 18:08:30','2026-04-18 18:08:30',0),(117,'0f9ebf9d-4de3-478b-ae18-95dd66a98c39.jpg','习酒 (9).jpg','/uploads/0f9ebf9d-4de3-478b-ae18-95dd66a98c39.jpg',66708,NULL,NULL,'2026-04-18 18:08:30','2026-04-18 18:08:30',0),(118,'00e5aca9-fd7b-4b24-b6fc-6936797fc576.jpg','五粮春 (1).jpg','/uploads/00e5aca9-fd7b-4b24-b6fc-6936797fc576.jpg',59722,NULL,NULL,'2026-04-18 18:08:30','2026-04-18 18:08:30',0),(119,'8852af46-3c23-44ed-a6c7-f2489b6b370a.jpg','牛栏山 (34).jpg','/uploads/8852af46-3c23-44ed-a6c7-f2489b6b370a.jpg',171955,NULL,NULL,'2026-04-18 18:08:30','2026-04-18 18:08:30',0),(120,'619bd677-84d9-4d9b-b306-8c7c370feb4a.jpg','舍得 (1).jpg','/uploads/619bd677-84d9-4d9b-b306-8c7c370feb4a.jpg',177681,NULL,NULL,'2026-04-18 18:08:30','2026-04-18 18:08:30',0),(121,'0099b1dc-91f1-49f5-ae64-f6f6e2593814.jpg','小朗酒 (2).jpg','/uploads/0099b1dc-91f1-49f5-ae64-f6f6e2593814.jpg',213189,NULL,NULL,'2026-04-18 18:08:30','2026-04-18 18:08:30',0),(122,'5e9c5c94-50d2-4197-bda4-6a8f2ee31125.jpg','22莲子.jpg','/uploads/5e9c5c94-50d2-4197-bda4-6a8f2ee31125.jpg',524677,NULL,NULL,'2026-04-18 18:08:41','2026-04-18 18:08:41',0),(123,'6af8ddc8-5b41-4795-bc71-62cb25b3b800.jpg','3咸味花生.jpg','/uploads/6af8ddc8-5b41-4795-bc71-62cb25b3b800.jpg',560246,NULL,NULL,'2026-04-18 18:08:41','2026-04-18 18:08:41',0),(124,'32a20665-1dfb-411a-a94d-7afaf3141a11.jpg','61巴旦木.jpg','/uploads/32a20665-1dfb-411a-a94d-7afaf3141a11.jpg',541848,NULL,NULL,'2026-04-18 18:08:41','2026-04-18 18:08:41',0),(125,'404cb02c-e6d3-42c2-83f3-d8647d43e626.jpg','31松子.jpg','/uploads/404cb02c-e6d3-42c2-83f3-d8647d43e626.jpg',554230,NULL,NULL,'2026-04-18 18:08:41','2026-04-18 18:08:41',0),(126,'d1bfeb9f-fd6d-4122-9a0f-9ca67a5ea2cc.jpg','21莲子 (1).jpg','/uploads/d1bfeb9f-fd6d-4122-9a0f-9ca67a5ea2cc.jpg',601463,NULL,NULL,'2026-04-18 18:08:41','2026-04-18 18:08:41',0),(127,'98a557f7-db0b-4c07-9232-d2135df13e88.jpg','23葡萄干 (7).jpg','/uploads/98a557f7-db0b-4c07-9232-d2135df13e88.jpg',779270,NULL,NULL,'2026-04-18 18:08:41','2026-04-18 18:08:41',0),(128,'b7a7f0c0-63c0-4b04-9e1e-0139c5a9b83f.jpg','78葡萄干.jpg','/uploads/b7a7f0c0-63c0-4b04-9e1e-0139c5a9b83f.jpg',416340,NULL,NULL,'2026-04-18 18:08:41','2026-04-18 18:08:41',0),(129,'be7f2f85-8cf2-4faa-96df-90e351b394c2.jpg','67开心果2.jpg','/uploads/be7f2f85-8cf2-4faa-96df-90e351b394c2.jpg',396767,NULL,NULL,'2026-04-18 18:08:41','2026-04-18 18:08:41',0),(130,'7013c190-43f9-4e30-aa6c-1ad292721a70.jpg','32花生豆.jpg','/uploads/7013c190-43f9-4e30-aa6c-1ad292721a70.jpg',545976,NULL,NULL,'2026-04-18 18:08:41','2026-04-18 18:08:41',0),(131,'717c6a19-72f6-4d3a-a19d-8101c8727906.jpg','63板栗.jpg','/uploads/717c6a19-72f6-4d3a-a19d-8101c8727906.jpg',362720,NULL,NULL,'2026-04-18 18:08:41','2026-04-18 18:08:41',0),(132,'5e0f0e1e-2683-46f7-bf07-25af49bacf9f.jpg','77辣条.jpg','/uploads/5e0f0e1e-2683-46f7-bf07-25af49bacf9f.jpg',223977,NULL,NULL,'2026-04-18 18:08:41','2026-04-18 18:08:41',0),(133,'d0f7caaa-0c9d-412d-9f2f-71a2fa7046f0.jpg','65核桃2.jpg','/uploads/d0f7caaa-0c9d-412d-9f2f-71a2fa7046f0.jpg',464176,NULL,NULL,'2026-04-18 18:08:41','2026-04-18 18:08:41',0),(134,'3b004cac-ad15-4e00-a1bc-7c84fa1bd476.jpg','红花生 (3).jpg','/uploads/3b004cac-ad15-4e00-a1bc-7c84fa1bd476.jpg',426184,NULL,NULL,'2026-04-18 18:08:42','2026-04-18 18:08:42',0),(135,'4752b00e-de61-4149-9424-558d902064eb.jpg','话梅.jpg','/uploads/4752b00e-de61-4149-9424-558d902064eb.jpg',527848,NULL,NULL,'2026-04-18 18:08:42','2026-04-18 18:08:42',0),(136,'d2c75d43-7aa6-4564-be81-3754e503281a.jpg','93混合坚果.jpg','/uploads/d2c75d43-7aa6-4564-be81-3754e503281a.jpg',577487,NULL,NULL,'2026-04-18 18:08:42','2026-04-18 18:08:42',0),(137,'5ca20000-9e87-4769-806a-dcffee691220.jpg','西梅.jpg','/uploads/5ca20000-9e87-4769-806a-dcffee691220.jpg',386513,NULL,NULL,'2026-04-18 18:08:42','2026-04-18 18:08:42',0),(138,'08252af0-cb4f-4ee9-ae59-463058bb3d17.jpg','苦荞鲜花饼.jpg','/uploads/08252af0-cb4f-4ee9-ae59-463058bb3d17.jpg',378223,NULL,NULL,'2026-04-18 18:08:42','2026-04-18 18:08:42',0),(139,'4ebea632-fd2f-4298-a777-13e2836fd07d.jpg','瓜子.jpg','/uploads/4ebea632-fd2f-4298-a777-13e2836fd07d.jpg',7861024,NULL,NULL,'2026-04-18 18:08:42','2026-04-18 18:08:42',0),(140,'2ebbe70c-995c-4dde-a010-007f835d752b.jpg','鸡.肉....jpg','/uploads/2ebbe70c-995c-4dde-a010-007f835d752b.jpg',241724,NULL,NULL,'2026-04-18 18:08:54','2026-04-18 18:08:54',0),(141,'6e98cd1c-d9a2-4766-9735-56c6edf07eda.jpg','牛.眼.肉. .(4).jpg','/uploads/6e98cd1c-d9a2-4766-9735-56c6edf07eda.jpg',360862,NULL,NULL,'2026-04-18 18:08:54','2026-04-18 18:08:54',0),(142,'3019f006-e7f0-476a-9bd3-84ba30d8af20.jpg','牛.排. .(.3).jpg','/uploads/3019f006-e7f0-476a-9bd3-84ba30d8af20.jpg',271568,NULL,NULL,'2026-04-18 18:08:54','2026-04-18 18:08:54',0),(143,'b3b0f360-d44b-4ef0-a7e9-819ada9b8c84.jpg','牛.舌. .(.1).jpg','/uploads/b3b0f360-d44b-4ef0-a7e9-819ada9b8c84.jpg',240936,NULL,NULL,'2026-04-18 18:08:54','2026-04-18 18:08:54',0),(144,'6529f4a5-cd64-4b54-8de3-9cf552d9bcda.jpg','琵.琶.腿...jpg','/uploads/6529f4a5-cd64-4b54-8de3-9cf552d9bcda.jpg',317349,NULL,NULL,'2026-04-18 18:08:54','2026-04-18 18:08:54',0),(145,'8d803b9d-e7d0-4701-87b4-95e21210edc8.jpg','土.鸡.蛋...jpg','/uploads/8d803b9d-e7d0-4701-87b4-95e21210edc8.jpg',440110,NULL,NULL,'2026-04-18 18:08:54','2026-04-18 18:08:54',0),(146,'fd3c4251-0f20-4afd-84ed-31e6214e719d.jpg','五.花.肉. .(1).jpg','/uploads/fd3c4251-0f20-4afd-84ed-31e6214e719d.jpg',138605,NULL,NULL,'2026-04-18 18:08:54','2026-04-18 18:08:54',0),(147,'c367090b-cd56-4c45-8410-bbb27696dabc.jpg','羊.肉.卷...jpg','/uploads/c367090b-cd56-4c45-8410-bbb27696dabc.jpg',317668,NULL,NULL,'2026-04-18 18:08:55','2026-04-18 18:08:55',0),(148,'da25fe92-7934-4479-924c-72022d6faf58.jpg','小.里.脊...jpg','/uploads/da25fe92-7934-4479-924c-72022d6faf58.jpg',238066,NULL,NULL,'2026-04-18 18:08:55','2026-04-18 18:08:55',0),(149,'27715c83-0b39-41e9-813a-40474c593c64.jpg','雪.花.牛.肉.片.jpg','/uploads/27715c83-0b39-41e9-813a-40474c593c64.jpg',534431,NULL,NULL,'2026-04-18 18:08:55','2026-04-18 18:08:55',0),(150,'bcbbdc02-cd3b-4cfe-a6ed-22b9d53b46b9.jpg','甜豆角 (6).jpg','/uploads/bcbbdc02-cd3b-4cfe-a6ed-22b9d53b46b9.jpg',1849904,NULL,NULL,'2026-04-18 18:09:04','2026-04-18 18:09:04',0),(151,'3b523548-a01e-4471-898d-14516fd6eac1.jpg','四季豆 (13).jpg','/uploads/3b523548-a01e-4471-898d-14516fd6eac1.jpg',2808418,NULL,NULL,'2026-04-18 18:09:04','2026-04-18 18:09:04',0),(152,'30cf51aa-754b-4a4a-a43c-b4e6ab754fcc.jpg','上海青 (7).jpg','/uploads/30cf51aa-754b-4a4a-a43c-b4e6ab754fcc.jpg',4287471,NULL,NULL,'2026-04-18 18:09:04','2026-04-18 18:09:04',0),(153,'0db120b1-3fcf-43cc-b6ef-26266280839d.jpg','土豆 (11).jpg','/uploads/0db120b1-3fcf-43cc-b6ef-26266280839d.jpg',3935540,NULL,NULL,'2026-04-18 18:09:04','2026-04-18 18:09:04',0),(154,'28a11624-6a6d-41bb-a94a-9261f0239ef9.jpg','蒜头.jpg','/uploads/28a11624-6a6d-41bb-a94a-9261f0239ef9.jpg',4271600,NULL,NULL,'2026-04-18 18:09:04','2026-04-18 18:09:04',0),(155,'94f994f3-1b90-4fdc-bcec-21ee146f485d.jpg','西兰花 (32).jpg','/uploads/94f994f3-1b90-4fdc-bcec-21ee146f485d.jpg',1685641,NULL,NULL,'2026-04-18 18:09:04','2026-04-18 18:09:04',0),(156,'541d5631-55cc-43ca-95a7-376ad433ebc1.jpg','生菜 (28).jpg','/uploads/541d5631-55cc-43ca-95a7-376ad433ebc1.jpg',5888211,NULL,NULL,'2026-04-18 18:09:04','2026-04-18 18:09:04',0),(157,'4085d6fb-0334-434e-b9cd-c4c21cff3216.jpg','香椿 (2).jpg','/uploads/4085d6fb-0334-434e-b9cd-c4c21cff3216.jpg',3931840,NULL,NULL,'2026-04-18 18:09:05','2026-04-18 18:09:05',0),(158,'920c1782-9f7e-4843-a158-3031b7b11d62.jpg','洋葱 (19).jpg','/uploads/920c1782-9f7e-4843-a158-3031b7b11d62.jpg',1871881,NULL,NULL,'2026-04-18 18:09:05','2026-04-18 18:09:05',0),(159,'77e5e93b-a495-4b38-be0d-62779fbae7ea.jpg','洋葱 (11).jpg','/uploads/77e5e93b-a495-4b38-be0d-62779fbae7ea.jpg',2891637,NULL,NULL,'2026-04-18 18:09:05','2026-04-18 18:09:05',0),(160,'2ce0b795-26e5-47c4-a910-100cf9ce865f.jpg','洋葱 (18).jpg','/uploads/2ce0b795-26e5-47c4-a910-100cf9ce865f.jpg',3621787,NULL,NULL,'2026-04-18 18:09:05','2026-04-18 18:09:05',0),(161,'0225d7e8-a955-401e-a1a4-d3ef5f943a78.jpg','芋头 (5).jpg','/uploads/0225d7e8-a955-401e-a1a4-d3ef5f943a78.jpg',3980965,NULL,NULL,'2026-04-18 18:09:05','2026-04-18 18:09:05',0),(162,'29978cc8-25f3-420a-96c7-bfbc3eae9215.jpg','玉米 (11).jpg','/uploads/29978cc8-25f3-420a-96c7-bfbc3eae9215.jpg',4513898,NULL,NULL,'2026-04-18 18:09:05','2026-04-18 18:09:05',0),(163,'58ea2f41-0c63-4822-a09e-2585d9d30906.jpg','橙子 (6).jpg','/uploads/58ea2f41-0c63-4822-a09e-2585d9d30906.jpg',415852,NULL,NULL,'2026-04-18 18:09:13','2026-04-18 18:09:13',0),(164,'eda94c76-04df-46da-b367-19d2a57381d4.jpg','车厘子6.jpg','/uploads/eda94c76-04df-46da-b367-19d2a57381d4.jpg',627621,NULL,NULL,'2026-04-18 18:09:13','2026-04-18 18:09:13',0),(165,'0ecd8338-50e1-4215-86b2-916509d1dc7c.jpg','整-蟠桃.jpg','/uploads/0ecd8338-50e1-4215-86b2-916509d1dc7c.jpg',894576,NULL,NULL,'2026-04-18 18:09:13','2026-04-18 18:09:13',0),(166,'2565fa9d-83f5-47d3-8e61-220ec8e33ef8.jpg','荔枝 (5).jpg','/uploads/2565fa9d-83f5-47d3-8e61-220ec8e33ef8.jpg',622183,NULL,NULL,'2026-04-18 18:09:13','2026-04-18 18:09:13',0),(167,'74883f9c-b131-4d56-85fd-da9892c52c41.jpg','油桃3.jpg','/uploads/74883f9c-b131-4d56-85fd-da9892c52c41.jpg',778818,NULL,NULL,'2026-04-18 18:09:13','2026-04-18 18:09:13',0),(168,'984ba590-a4d8-41d3-b456-73e93879fd40.jpg','整-西瓜.jpg','/uploads/984ba590-a4d8-41d3-b456-73e93879fd40.jpg',964925,NULL,NULL,'2026-04-18 18:09:13','2026-04-18 18:09:13',0),(169,'58548ecb-1365-44f8-9d7f-eb6e31f6908d.jpg','整-香蕉.jpg','/uploads/58548ecb-1365-44f8-9d7f-eb6e31f6908d.jpg',489902,NULL,NULL,'2026-04-18 18:09:13','2026-04-18 18:09:13',0),(170,'1008f156-bc00-462f-b05f-c13ea291f4cc.jpg','紫葡萄2.jpg','/uploads/1008f156-bc00-462f-b05f-c13ea291f4cc.jpg',694038,NULL,NULL,'2026-04-18 18:09:13','2026-04-18 18:09:13',0),(171,'a9fb7138-5fe2-4e40-9835-417b98ab45fe.jpg','蒂花之秀护发精油 (14).jpg','/uploads/a9fb7138-5fe2-4e40-9835-417b98ab45fe.jpg',95008,NULL,NULL,'2026-04-18 18:09:21','2026-04-18 18:09:21',0),(172,'feaa5890-1b59-4131-941f-d85e8d7f827d.jpg','多芬洗发水 (1).jpg','/uploads/feaa5890-1b59-4131-941f-d85e8d7f827d.jpg',68140,NULL,NULL,'2026-04-18 18:09:21','2026-04-18 18:09:21',0),(173,'9972a087-7270-4db6-a5ea-eca44faaa222.jpg','多芬护发膜 (1).jpg','/uploads/9972a087-7270-4db6-a5ea-eca44faaa222.jpg',176187,NULL,NULL,'2026-04-18 18:09:21','2026-04-18 18:09:21',0),(174,'1e9e80cb-ce90-4b7d-8cea-aa3725159cb9.jpg','多芬洗发露.jpg','/uploads/1e9e80cb-ce90-4b7d-8cea-aa3725159cb9.jpg',97877,NULL,NULL,'2026-04-18 18:09:21','2026-04-18 18:09:21',0),(175,'8dbfc831-9ba8-425c-831c-350299c87839.jpg','蜂花洗发露 (1).jpg','/uploads/8dbfc831-9ba8-425c-831c-350299c87839.jpg',109402,NULL,NULL,'2026-04-18 18:09:21','2026-04-18 18:09:21',0),(176,'6ec143ba-9fb5-4d3c-8f22-d6b00cd34069.jpg','海飞丝洗发水 (12).jpg','/uploads/6ec143ba-9fb5-4d3c-8f22-d6b00cd34069.jpg',360470,NULL,NULL,'2026-04-18 18:09:21','2026-04-18 18:09:21',0),(177,'90c20015-918e-4989-8754-88dae3bf53f9.jpg','亮莊定型水 (2).jpg','/uploads/90c20015-918e-4989-8754-88dae3bf53f9.jpg',47430,NULL,NULL,'2026-04-18 18:09:21','2026-04-18 18:09:21',0),(178,'b6487489-83d5-470e-93c4-244e24b2c962.jpg','亮莊沐浴洗发套装.jpg','/uploads/b6487489-83d5-470e-93c4-244e24b2c962.jpg',110730,NULL,NULL,'2026-04-18 18:09:21','2026-04-18 18:09:21',0),(179,'3f22134a-d158-4875-8ba3-8ce3aa1bb3ae.jpg','满婷洗发水 (1).jpg','/uploads/3f22134a-d158-4875-8ba3-8ce3aa1bb3ae.jpg',91536,NULL,NULL,'2026-04-18 18:09:21','2026-04-18 18:09:21',0),(180,'6bd281e1-83de-4f0a-b58d-b8e30c629921.jpg','清扬护发素 (1).jpg','/uploads/6bd281e1-83de-4f0a-b58d-b8e30c629921.jpg',135145,NULL,NULL,'2026-04-18 18:09:21','2026-04-18 18:09:21',0),(181,'6e2f7027-5a82-41e6-a398-74f3a7d4fe93.jpg','清扬护发素 (3).jpg','/uploads/6e2f7027-5a82-41e6-a398-74f3a7d4fe93.jpg',161308,NULL,NULL,'2026-04-18 18:09:21','2026-04-18 18:09:21',0),(182,'07761d02-1896-4716-803b-8c0fae1516f2.jpg','飘柔洗发露 (1).jpg','/uploads/07761d02-1896-4716-803b-8c0fae1516f2.jpg',277791,NULL,NULL,'2026-04-18 18:09:21','2026-04-18 18:09:21',0),(183,'d6d4b1b7-1451-4d6c-86d0-f14b30880de4.jpg','清扬洗发水 (5).jpg','/uploads/d6d4b1b7-1451-4d6c-86d0-f14b30880de4.jpg',27928,NULL,NULL,'2026-04-18 18:09:21','2026-04-18 18:09:21',0),(184,'4a091d5c-5049-4500-8d46-6259ed27e5fb.jpg','沙宣洗发水 (1).jpg','/uploads/4a091d5c-5049-4500-8d46-6259ed27e5fb.jpg',184994,NULL,NULL,'2026-04-18 18:09:21','2026-04-18 18:09:21',0),(185,'dc605020-65b1-4bef-805b-6e252fdad5a8.jpg','施华蔻染发 (15).jpg','/uploads/dc605020-65b1-4bef-805b-6e252fdad5a8.jpg',127571,NULL,NULL,'2026-04-18 18:09:21','2026-04-18 18:09:21',0),(186,'8254c9e5-8dd6-4e96-80be-cc74ef0b8114.jpg','施华蔻染发套装 (3).jpg','/uploads/8254c9e5-8dd6-4e96-80be-cc74ef0b8114.jpg',102852,NULL,NULL,'2026-04-18 18:09:21','2026-04-18 18:09:21',0),(187,'fdba3f1e-a6e3-4985-ac88-9ed59879cd0a.jpg','豆本豆-2.jpg','/uploads/fdba3f1e-a6e3-4985-ac88-9ed59879cd0a.jpg',154435,NULL,NULL,'2026-04-18 18:09:29','2026-04-18 18:09:29',0),(188,'01afb894-b03a-4090-97de-bdad268ae186.jpg','百事可乐4.jpg','/uploads/01afb894-b03a-4090-97de-bdad268ae186.jpg',290575,NULL,NULL,'2026-04-18 18:09:29','2026-04-18 18:09:29',0),(189,'8ea0a78a-0112-4b40-a014-f295e7fd5585.jpg','东鹏2.jpg','/uploads/8ea0a78a-0112-4b40-a014-f295e7fd5585.jpg',336022,NULL,NULL,'2026-04-18 18:09:29','2026-04-18 18:09:29',0),(190,'360e946d-5f5a-40a6-aa8a-b74af093fac9.jpg','红牛5.jpg','/uploads/360e946d-5f5a-40a6-aa8a-b74af093fac9.jpg',452011,NULL,NULL,'2026-04-18 18:09:29','2026-04-18 18:09:29',0),(191,'e3252f0b-3777-4cad-a03e-d18ef8189ab3.jpg','景田6.jpg','/uploads/e3252f0b-3777-4cad-a03e-d18ef8189ab3.jpg',253046,NULL,NULL,'2026-04-18 18:09:29','2026-04-18 18:09:29',0),(192,'ceeb5cb4-40ed-4d4c-b0ae-ee2e5669ee52.jpg','健力宝7.jpg','/uploads/ceeb5cb4-40ed-4d4c-b0ae-ee2e5669ee52.jpg',110376,NULL,NULL,'2026-04-18 18:09:29','2026-04-18 18:09:29',0),(193,'749ccfec-c68a-4fb0-ac3f-786cc1583d77.jpg','康师傅茉莉清茶1.jpg','/uploads/749ccfec-c68a-4fb0-ac3f-786cc1583d77.jpg',233288,NULL,NULL,'2026-04-18 18:09:29','2026-04-18 18:09:29',0),(194,'c68aa6b0-4c3e-4085-b13a-b9466acffb84.jpg','美年达2.jpg','/uploads/c68aa6b0-4c3e-4085-b13a-b9466acffb84.jpg',170062,NULL,NULL,'2026-04-18 18:09:29','2026-04-18 18:09:29',0),(195,'ad2a35fe-8f8b-4d28-a8ab-23086990e16b.jpg','可口可乐11.jpg','/uploads/ad2a35fe-8f8b-4d28-a8ab-23086990e16b.jpg',215510,NULL,NULL,'2026-04-18 18:09:29','2026-04-18 18:09:29',0),(196,'ff35739d-5aac-4197-bca9-1045b01101e3.jpg','乐虎5.jpg','/uploads/ff35739d-5aac-4197-bca9-1045b01101e3.jpg',1195227,NULL,NULL,'2026-04-18 18:09:29','2026-04-18 18:09:29',0),(197,'80d7e920-6411-4028-9e77-cab0ea26c97b.jpg','百事可乐4.jpg','/uploads/80d7e920-6411-4028-9e77-cab0ea26c97b.jpg',290575,NULL,NULL,'2026-04-18 18:10:27','2026-04-18 18:10:27',0),(198,'bd5e065c-08e4-4696-8335-e4dcedac96de.jpg','东鹏2.jpg','/uploads/bd5e065c-08e4-4696-8335-e4dcedac96de.jpg',336022,NULL,NULL,'2026-04-18 18:11:00','2026-04-18 18:11:00',0),(199,'90610ecf-a5e6-4c45-98db-2a6231770025.jpg','豆本豆-2.jpg','/uploads/90610ecf-a5e6-4c45-98db-2a6231770025.jpg',154435,NULL,NULL,'2026-04-18 18:11:24','2026-04-18 18:11:24',0),(200,'d08f45ca-0b2b-4c2e-8296-17fe1baf04a3.jpg','红牛5.jpg','/uploads/d08f45ca-0b2b-4c2e-8296-17fe1baf04a3.jpg',452011,NULL,NULL,'2026-04-18 18:17:25','2026-04-18 18:17:25',0),(201,'ccacbe07-1b50-4e77-87ca-ac58c2df10cb.jpg','健力宝7.jpg','/uploads/ccacbe07-1b50-4e77-87ca-ac58c2df10cb.jpg',110376,NULL,NULL,'2026-04-18 18:17:38','2026-04-18 18:17:38',0),(202,'1bf04c54-32e5-4e35-8b35-0449902076aa.jpg','景田6.jpg','/uploads/1bf04c54-32e5-4e35-8b35-0449902076aa.jpg',253046,NULL,NULL,'2026-04-18 18:17:54','2026-04-18 18:17:54',0),(203,'e476367a-0c6d-4ce3-a129-465a3191d024.jpg','康师傅茉莉清茶1.jpg','/uploads/e476367a-0c6d-4ce3-a129-465a3191d024.jpg',233288,NULL,NULL,'2026-04-18 18:18:06','2026-04-18 18:18:06',0),(204,'02a15c91-19a7-4073-874a-136d1de611b6.jpg','可口可乐11.jpg','/uploads/02a15c91-19a7-4073-874a-136d1de611b6.jpg',215510,NULL,NULL,'2026-04-18 18:18:29','2026-04-18 18:18:29',0),(205,'8d60cb42-796c-4e6a-af0f-8cde67514f24.jpg','乐虎5.jpg','/uploads/8d60cb42-796c-4e6a-af0f-8cde67514f24.jpg',1195227,NULL,NULL,'2026-04-18 18:18:41','2026-04-18 18:18:41',0),(206,'59c5bb2d-c5d0-404b-859e-d7dff208dca5.jpg','美年达2.jpg','/uploads/59c5bb2d-c5d0-404b-859e-d7dff208dca5.jpg',170062,NULL,NULL,'2026-04-18 18:18:51','2026-04-18 18:18:51',0),(207,'d474c9da-24e3-4c93-ba28-eb41171f7302.jpg','衡水老白干 (4).jpg','/uploads/d474c9da-24e3-4c93-ba28-eb41171f7302.jpg',63849,NULL,NULL,'2026-04-18 18:19:43','2026-04-18 18:19:43',0),(208,'39d350dd-ec42-4fe2-9faa-08eba2e1ae69.jpg','江小白 (37).jpg','/uploads/39d350dd-ec42-4fe2-9faa-08eba2e1ae69.jpg',136189,NULL,NULL,'2026-04-18 18:19:56','2026-04-18 18:19:56',0),(209,'a6a20c66-adc5-4877-be89-96c5ce606f58.jpg','劲酒 (5).jpg','/uploads/a6a20c66-adc5-4877-be89-96c5ce606f58.jpg',70614,NULL,NULL,'2026-04-18 18:20:06','2026-04-18 18:20:06',0),(210,'385452b4-d86c-4b79-a18e-2a40a807dc83.jpg','九江 (7).jpg','/uploads/385452b4-d86c-4b79-a18e-2a40a807dc83.jpg',64528,NULL,NULL,'2026-04-18 18:20:23','2026-04-18 18:20:23',0),(211,'537c53d1-ad33-4455-8541-700b05bda52e.jpg','口子窖 (2).jpg','/uploads/537c53d1-ad33-4455-8541-700b05bda52e.jpg',321578,NULL,NULL,'2026-04-18 18:20:41','2026-04-18 18:20:41',0),(212,'ec2d614f-35c5-4cff-a252-800ee495af50.jpg','泸州老窖 (3).jpg','/uploads/ec2d614f-35c5-4cff-a252-800ee495af50.jpg',329255,NULL,NULL,'2026-04-18 18:21:01','2026-04-18 18:21:01',0),(213,'32c5aeca-bb6a-4509-93f8-0c4841737447.jpg','牛栏山 (34).jpg','/uploads/32c5aeca-bb6a-4509-93f8-0c4841737447.jpg',171955,NULL,NULL,'2026-04-18 18:21:20','2026-04-18 18:21:20',0),(214,'133f4dc2-4b56-4158-ac55-49e2a208f27b.jpg','舍得 (1).jpg','/uploads/133f4dc2-4b56-4158-ac55-49e2a208f27b.jpg',177681,NULL,NULL,'2026-04-18 18:21:31','2026-04-18 18:21:31',0),(215,'8fbad0d8-1103-478a-a6ca-8480a80e53c1.jpg','五粮春 (1).jpg','/uploads/8fbad0d8-1103-478a-a6ca-8480a80e53c1.jpg',59722,NULL,NULL,'2026-04-18 18:21:42','2026-04-18 18:21:42',0),(216,'5f37c307-1564-474f-8215-7a6b827427e1.jpg','习酒 (9).jpg','/uploads/5f37c307-1564-474f-8215-7a6b827427e1.jpg',66708,NULL,NULL,'2026-04-18 18:22:01','2026-04-18 18:22:01',0),(217,'5530d0a1-c801-496e-ba72-3772ae4d279e.jpg','小朗酒 (2).jpg','/uploads/5530d0a1-c801-496e-ba72-3772ae4d279e.jpg',213189,NULL,NULL,'2026-04-18 18:22:15','2026-04-18 18:22:15',0),(218,'07ac6cf4-104c-415b-a87e-f97f7c342793.jpg','3咸味花生.jpg','/uploads/07ac6cf4-104c-415b-a87e-f97f7c342793.jpg',560246,NULL,NULL,'2026-04-18 18:27:21','2026-04-18 18:27:21',0),(219,'3d3a6392-d1d7-449b-8943-e12b70624789.jpg','21莲子 (1).jpg','/uploads/3d3a6392-d1d7-449b-8943-e12b70624789.jpg',601463,NULL,NULL,'2026-04-18 18:27:50','2026-04-18 18:27:50',0),(220,'602c1d86-b396-466f-bdbf-7b08003f196c.jpg','23葡萄干 (7).jpg','/uploads/602c1d86-b396-466f-bdbf-7b08003f196c.jpg',779270,NULL,NULL,'2026-04-18 18:28:05','2026-04-18 18:28:05',0),(221,'c618fe04-c97f-4226-aee7-c1e53945431d.jpg','31松子.jpg','/uploads/c618fe04-c97f-4226-aee7-c1e53945431d.jpg',554230,NULL,NULL,'2026-04-18 18:29:04','2026-04-18 18:29:04',0),(222,'762ddb01-950f-4908-b5d4-919ecec26a6a.jpg','61巴旦木.jpg','/uploads/762ddb01-950f-4908-b5d4-919ecec26a6a.jpg',541848,NULL,NULL,'2026-04-18 18:29:19','2026-04-18 18:29:19',0),(223,'e4624cf6-b4d4-498d-b563-c3adf4f8c3c3.jpg','32花生豆.jpg','/uploads/e4624cf6-b4d4-498d-b563-c3adf4f8c3c3.jpg',545976,NULL,NULL,'2026-04-18 18:29:40','2026-04-18 18:29:40',0),(224,'da193af0-ef68-415b-9aaa-3de0ed144665.jpg','63板栗.jpg','/uploads/da193af0-ef68-415b-9aaa-3de0ed144665.jpg',362720,NULL,NULL,'2026-04-18 18:29:59','2026-04-18 18:29:59',0),(225,'38ffa5de-51ea-4162-9e5a-7f40b19c240a.jpg','65核桃2.jpg','/uploads/38ffa5de-51ea-4162-9e5a-7f40b19c240a.jpg',464176,NULL,NULL,'2026-04-18 18:30:16','2026-04-18 18:30:16',0),(226,'85f33c6e-d885-4643-9205-48fcc7c0c4a2.jpg','67开心果2.jpg','/uploads/85f33c6e-d885-4643-9205-48fcc7c0c4a2.jpg',396767,NULL,NULL,'2026-04-18 18:30:40','2026-04-18 18:30:40',0),(227,'b2e9f00c-9d61-44ba-9da2-0e67731c6376.jpg','77辣条.jpg','/uploads/b2e9f00c-9d61-44ba-9da2-0e67731c6376.jpg',223977,NULL,NULL,'2026-04-18 18:30:57','2026-04-18 18:30:57',0),(228,'cd073c79-5dae-42a4-87f3-0f0bd248f32d.jpg','93混合坚果.jpg','/uploads/cd073c79-5dae-42a4-87f3-0f0bd248f32d.jpg',577487,NULL,NULL,'2026-04-18 18:31:17','2026-04-18 18:31:17',0),(229,'09b4e455-8afd-45f7-a035-1260e0195cee.jpg','话梅.jpg','/uploads/09b4e455-8afd-45f7-a035-1260e0195cee.jpg',527848,NULL,NULL,'2026-04-18 18:31:38','2026-04-18 18:31:38',0),(230,'1811e951-0cc3-402a-b48a-a70bce63c86e.jpg','西梅.jpg','/uploads/1811e951-0cc3-402a-b48a-a70bce63c86e.jpg',386513,NULL,NULL,'2026-04-18 18:32:02','2026-04-18 18:32:02',0),(231,'5e9a447a-bd90-411e-bbf0-0b561641becd.jpg','鸡.肉....jpg','/uploads/5e9a447a-bd90-411e-bbf0-0b561641becd.jpg',241724,NULL,NULL,'2026-04-18 18:32:44','2026-04-18 18:32:44',0),(232,'08ad0fdf-7e2d-4c8d-8e29-e3baf3aaef06.jpg','牛.排. .(.3).jpg','/uploads/08ad0fdf-7e2d-4c8d-8e29-e3baf3aaef06.jpg',271568,NULL,NULL,'2026-04-18 18:33:10','2026-04-18 18:33:10',0),(233,'46e24c5d-1ebc-4c34-9968-78e1c750ba97.jpg','牛.舌. .(.1).jpg','/uploads/46e24c5d-1ebc-4c34-9968-78e1c750ba97.jpg',240936,NULL,NULL,'2026-04-18 18:35:44','2026-04-18 18:35:44',0),(234,'8b4988a7-65e4-4f42-ad46-fd874cf7a864.jpg','牛.眼.肉. .(4).jpg','/uploads/8b4988a7-65e4-4f42-ad46-fd874cf7a864.jpg',360862,NULL,NULL,'2026-04-18 18:36:05','2026-04-18 18:36:05',0),(235,'28947c48-ecf2-4d2d-802e-0e42cd90a8a2.jpg','琵.琶.腿...jpg','/uploads/28947c48-ecf2-4d2d-802e-0e42cd90a8a2.jpg',317349,NULL,NULL,'2026-04-18 18:36:24','2026-04-18 18:36:24',0),(236,'f4c14e68-76a2-45a9-ad15-e6e8dd9f4de7.jpg','土.鸡.蛋...jpg','/uploads/f4c14e68-76a2-45a9-ad15-e6e8dd9f4de7.jpg',440110,NULL,NULL,'2026-04-18 18:36:57','2026-04-18 18:36:57',0),(237,'d08852f0-a6c8-4838-945f-9473a22d1b4b.jpg','五.花.肉. .(1).jpg','/uploads/d08852f0-a6c8-4838-945f-9473a22d1b4b.jpg',138605,NULL,NULL,'2026-04-18 18:37:12','2026-04-18 18:37:12',0),(238,'f5a5e6dd-678b-45d1-9917-1ba5084da948.jpg','小.里.脊...jpg','/uploads/f5a5e6dd-678b-45d1-9917-1ba5084da948.jpg',238066,NULL,NULL,'2026-04-18 18:37:42','2026-04-18 18:37:42',0),(239,'1534c3a6-3463-4532-b085-778d10a737e2.jpg','羊.肉.卷...jpg','/uploads/1534c3a6-3463-4532-b085-778d10a737e2.jpg',317668,NULL,NULL,'2026-04-18 18:37:57','2026-04-18 18:37:57',0),(240,'76680d76-37da-4f3a-b262-49e35ee1c2dd.jpg','甜豆角 (6).jpg','/uploads/76680d76-37da-4f3a-b262-49e35ee1c2dd.jpg',1849904,NULL,NULL,'2026-04-18 18:38:46','2026-04-18 18:38:46',0),(241,'2f00cea6-1b23-4207-92fc-8e6dbd198c72.jpg','西兰花 (32).jpg','/uploads/2f00cea6-1b23-4207-92fc-8e6dbd198c72.jpg',1685641,NULL,NULL,'2026-04-18 18:39:13','2026-04-18 18:39:13',0),(242,'3347b73d-5c9c-4219-8824-36d3f05933fd.jpg','洋葱 (19).jpg','/uploads/3347b73d-5c9c-4219-8824-36d3f05933fd.jpg',1871881,NULL,NULL,'2026-04-18 18:39:32','2026-04-18 18:39:32',0),(243,'f654f798-9b2a-48cc-be5e-31de5f86ffa7.jpg','车厘子6.jpg','/uploads/f654f798-9b2a-48cc-be5e-31de5f86ffa7.jpg',627621,NULL,NULL,'2026-04-18 18:40:24','2026-04-18 18:40:24',0),(244,'27bcba49-01f1-4a9d-b581-4d5b9010b97a.jpg','橙子 (6).jpg','/uploads/27bcba49-01f1-4a9d-b581-4d5b9010b97a.jpg',415852,NULL,NULL,'2026-04-18 18:40:44','2026-04-18 18:40:44',0),(245,'37a5e7bf-82c5-48a6-b9a9-b23cd15fddc1.jpg','荔枝 (5).jpg','/uploads/37a5e7bf-82c5-48a6-b9a9-b23cd15fddc1.jpg',622183,NULL,NULL,'2026-04-18 18:41:07','2026-04-18 18:41:07',0),(246,'ce349f16-3404-44cf-8b35-ac4bc7bea403.jpg','油桃3.jpg','/uploads/ce349f16-3404-44cf-8b35-ac4bc7bea403.jpg',778818,NULL,NULL,'2026-04-18 18:41:26','2026-04-18 18:41:26',0),(247,'7d4524cb-7940-4075-b661-16709a2dcbac.jpg','整-蟠桃.jpg','/uploads/7d4524cb-7940-4075-b661-16709a2dcbac.jpg',894576,NULL,NULL,'2026-04-18 18:41:46','2026-04-18 18:41:46',0),(248,'b8045ee6-0f25-4d28-81ee-c2884d68491d.jpg','整-西瓜.jpg','/uploads/b8045ee6-0f25-4d28-81ee-c2884d68491d.jpg',964925,NULL,NULL,'2026-04-18 18:42:03','2026-04-18 18:42:03',0),(249,'95cd50b5-a0a5-4152-ad21-98b00cb34514.jpg','整-香蕉.jpg','/uploads/95cd50b5-a0a5-4152-ad21-98b00cb34514.jpg',489902,NULL,NULL,'2026-04-18 18:42:16','2026-04-18 18:42:16',0),(250,'f73e3eca-1f58-472b-8415-3be49ea6064c.jpg','紫葡萄2.jpg','/uploads/f73e3eca-1f58-472b-8415-3be49ea6064c.jpg',694038,NULL,NULL,'2026-04-18 18:42:29','2026-04-18 18:42:29',0),(251,'c8916fca-2180-4fa7-a64f-e7b0df451b08.jpg','蒂花之秀护发精油 (14).jpg','/uploads/c8916fca-2180-4fa7-a64f-e7b0df451b08.jpg',95008,NULL,NULL,'2026-04-18 18:42:48','2026-04-18 18:42:48',0),(252,'11b83773-f2ae-4ab2-93ee-0edcf8e25278.jpg','多芬护发膜 (1).jpg','/uploads/11b83773-f2ae-4ab2-93ee-0edcf8e25278.jpg',176187,NULL,NULL,'2026-04-18 18:43:18','2026-04-18 18:43:18',0),(253,'4b58267c-e369-49cb-b4af-58ada7d5b68e.jpg','蜂花洗发露 (1).jpg','/uploads/4b58267c-e369-49cb-b4af-58ada7d5b68e.jpg',109402,NULL,NULL,'2026-04-18 18:43:45','2026-04-18 18:43:45',0),(254,'9802a16d-9254-4fe9-8b19-cccc522c8ec5.jpg','亮莊定型水 (2).jpg','/uploads/9802a16d-9254-4fe9-8b19-cccc522c8ec5.jpg',47430,NULL,NULL,'2026-04-18 18:44:13','2026-04-18 18:44:13',0),(255,'634fb0b6-b16c-4739-a7ca-cfbd759f9d9c.jpg','满婷洗发水 (1).jpg','/uploads/634fb0b6-b16c-4739-a7ca-cfbd759f9d9c.jpg',91536,NULL,NULL,'2026-04-18 18:44:46','2026-04-18 18:44:46',0),(256,'2a9d1183-4803-43f6-a2e0-ab07d0843874.jpg','飘柔洗发露 (1).jpg','/uploads/2a9d1183-4803-43f6-a2e0-ab07d0843874.jpg',277791,NULL,NULL,'2026-04-18 18:45:11','2026-04-18 18:45:11',0),(257,'0ac07316-631d-4a96-851c-b73de0429c90.jpg','清扬护发素 (3).jpg','/uploads/0ac07316-631d-4a96-851c-b73de0429c90.jpg',161308,NULL,NULL,'2026-04-18 18:45:39','2026-04-18 18:45:39',0);
/*!40000 ALTER TABLE `gallery_image` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notice`
--

DROP TABLE IF EXISTS `notice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notice` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `title` varchar(200) NOT NULL COMMENT '公告标题',
  `content` text NOT NULL COMMENT '公告内容',
  `type` tinyint DEFAULT '1' COMMENT '公告类型：1-系统公告 2-活动公告 3-其他',
  `status` tinyint DEFAULT '1' COMMENT '状态：0-禁用 1-启用',
  `sort_order` int DEFAULT '0' COMMENT '排序',
  `start_time` datetime DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '结束时间',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint DEFAULT '0' COMMENT '逻辑删除 0-正常 1-已删除',
  PRIMARY KEY (`id`),
  KEY `idx_end_time` (`end_time`),
  KEY `idx_sort_order` (`sort_order`),
  KEY `idx_start_time` (`start_time`),
  KEY `idx_status` (`status`),
  KEY `idx_type` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='公告表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notice`
--

LOCK TABLES `notice` WRITE;
/*!40000 ALTER TABLE `notice` DISABLE KEYS */;
INSERT INTO `notice` VALUES (1,'欢迎来到飞鱼商城','感谢您访问我们的海鲜电商平台，我们将为您提供最新鲜、最优质的海鲜产品。',1,1,1,NULL,NULL,'2026-03-27 10:37:56','2026-03-27 10:37:56',0),(2,'新品上市通知','挪威三文鱼新鲜到货，现正热销中，欢迎选购！',2,1,2,NULL,NULL,'2026-03-27 10:37:56','2026-03-27 10:37:56',0),(3,'系统维护提醒','为了提供更好的服务体验，系统将于今晚23:00-24:00进行例行维护。',1,1,3,NULL,NULL,'2026-03-27 10:37:56','2026-03-27 10:37:56',0),(4,'1','1',1,0,1,NULL,NULL,'2026-03-27 10:54:47','2026-03-27 10:54:47',0);
/*!40000 ALTER TABLE `notice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `video`
--

DROP TABLE IF EXISTS `video`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `video` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `title` varchar(255) DEFAULT NULL COMMENT '视频标题',
  `filename` varchar(255) NOT NULL COMMENT '存储文件名',
  `original_name` varchar(255) DEFAULT NULL COMMENT '原始文件名',
  `url` varchar(500) NOT NULL COMMENT '访问路径',
  `size` bigint DEFAULT '0' COMMENT '文件大小（字节）',
  `duration` int DEFAULT '0' COMMENT '时长（秒，预留）',
  `mime_type` varchar(100) DEFAULT NULL COMMENT '文件MIME类型',
  `description` varchar(500) DEFAULT NULL COMMENT '视频描述',
  `cover_url` varchar(500) DEFAULT NULL COMMENT '封面图URL（预留）',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '上传时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint DEFAULT '0' COMMENT '逻辑删除 0-正常 1-已删除',
  PRIMARY KEY (`id`),
  KEY `idx_create_time` (`create_time` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='视频管理表（广告模块）';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `video`
--

LOCK TABLES `video` WRITE;
/*!40000 ALTER TABLE `video` DISABLE KEYS */;
INSERT INTO `video` VALUES (1,'1月21日 (3)(2).mp4','3a554f49-4885-4d1f-9045-00771775b65d.mp4','1月21日 (3)(2).mp4','/uploads/videos/3a554f49-4885-4d1f-9045-00771775b65d.mp4',5478517,0,'video/mp4','',NULL,'2026-03-26 14:09:59','2026-04-06 11:07:59',1),(2,'2月3日 (1).mp4','b67de4dc-7614-4a1b-a7e9-606f76db602b.mp4','2月3日 (1).mp4','/uploads/videos/b67de4dc-7614-4a1b-a7e9-606f76db602b.mp4',7352482,0,'video/mp4','bgm2',NULL,'2026-04-06 11:10:02','2026-04-06 16:50:32',0),(3,'雨爱.mp4','b75c08e5-2cf7-47b1-ac20-b3115ff50ce2.mp4','雨爱.mp4','/uploads/videos/b75c08e5-2cf7-47b1-ac20-b3115ff50ce2.mp4',2855073,0,'video/mp4','bgm1',NULL,'2026-04-06 11:13:16','2026-04-06 16:50:24',0);
/*!40000 ALTER TABLE `video` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-18 23:19:37
