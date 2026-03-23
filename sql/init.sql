-- =============================================
-- Fish-Commerce 数据库初始化脚本
-- =============================================

-- 创建数据库
CREATE DATABASE IF NOT EXISTS fish_commerce DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE fish_commerce;

-- =============================================
-- 用户表
-- =============================================
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '用户 ID',
    `username` VARCHAR(50) NOT NULL COMMENT '用户名',
    `password` VARCHAR(100) NOT NULL COMMENT '密码',
    `nickname` VARCHAR(50) DEFAULT NULL COMMENT '昵称',
    `email` VARCHAR(100) DEFAULT NULL COMMENT '邮箱',
    `phone` VARCHAR(20) DEFAULT NULL COMMENT '手机号',
    `gender` TINYINT DEFAULT 2 COMMENT '性别 0-男 1-女 2-保密',
    `avatar` VARCHAR(255) DEFAULT NULL COMMENT '头像',
    `birthday` DATE DEFAULT NULL COMMENT '生日',
    `level` INT DEFAULT 0 COMMENT '会员等级',
    `status` TINYINT DEFAULT 0 COMMENT '状态 0-正常 1-禁用',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted` TINYINT DEFAULT 0 COMMENT '逻辑删除 0-未删除 1-已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- =============================================
-- 商品表
-- =============================================
DROP TABLE IF EXISTS `product`;
CREATE TABLE `product` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '商品ID',
    `name` VARCHAR(100) NOT NULL COMMENT '商品名称',
    `description` VARCHAR(500) DEFAULT NULL COMMENT '商品描述',
    `category_id` BIGINT DEFAULT NULL COMMENT '分类ID',
    `price` DECIMAL(10,2) NOT NULL COMMENT '价格',
    `original_price` DECIMAL(10,2) DEFAULT NULL COMMENT '原价',
    `stock` INT DEFAULT 0 COMMENT '库存',
    `sales` INT DEFAULT 0 COMMENT '销量',
    `main_image` VARCHAR(255) DEFAULT NULL COMMENT '主图',
    `specs` VARCHAR(500) DEFAULT NULL COMMENT '规格JSON',
    `origin` VARCHAR(50) DEFAULT NULL COMMENT '产地',
    `weight` VARCHAR(50) DEFAULT NULL COMMENT '重量',
    `shelf_life` VARCHAR(50) DEFAULT NULL COMMENT '保质期',
    `storage` VARCHAR(100) DEFAULT NULL COMMENT '储存方式',
    `status` TINYINT DEFAULT 1 COMMENT '状态 0-下架 1-上架',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted` TINYINT DEFAULT 0 COMMENT '逻辑删除',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品表';

-- =============================================
-- 购物车表
-- =============================================
DROP TABLE IF EXISTS `cart`;
CREATE TABLE `cart` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '购物车ID',
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `product_id` BIGINT NOT NULL COMMENT '商品ID',
    `product_name` VARCHAR(100) DEFAULT NULL COMMENT '商品名称',
    `product_image` VARCHAR(255) DEFAULT NULL COMMENT '商品图片',
    `product_spec` VARCHAR(50) DEFAULT NULL COMMENT '商品规格',
    `price` DECIMAL(10,2) DEFAULT NULL COMMENT '商品单价',
    `quantity` INT DEFAULT 1 COMMENT '数量',
    `selected` TINYINT DEFAULT 1 COMMENT '是否选中 0-否 1-是',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted` TINYINT DEFAULT 0 COMMENT '逻辑删除',
    PRIMARY KEY (`id`),
    KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='购物车表';

-- =============================================
-- 订单表
-- =============================================
DROP TABLE IF EXISTS `order`;
CREATE TABLE `order` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '订单ID',
    `order_no` VARCHAR(50) NOT NULL COMMENT '订单号',
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `receiver_name` VARCHAR(50) DEFAULT NULL COMMENT '收货人姓名',
    `receiver_phone` VARCHAR(20) DEFAULT NULL COMMENT '收货人电话',
    `receiver_address` VARCHAR(255) DEFAULT NULL COMMENT '收货地址',
    `total_amount` DECIMAL(10,2) DEFAULT NULL COMMENT '商品总金额',
    `freight` DECIMAL(10,2) DEFAULT 0.00 COMMENT '运费',
    `pay_amount` DECIMAL(10,2) DEFAULT NULL COMMENT '实付金额',
    `pay_type` TINYINT DEFAULT 0 COMMENT '支付方式 0-未支付 1-支付宝 2-微信 3-银行卡',
    `pay_time` DATETIME DEFAULT NULL COMMENT '支付时间',
    `status` TINYINT DEFAULT 0 COMMENT '订单状态 0-待付款 1-待发货 2-待收货 3-已完成 4-已取消 5-已退款',
    `remark` VARCHAR(255) DEFAULT NULL COMMENT '订单备注',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted` TINYINT DEFAULT 0 COMMENT '逻辑删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_order_no` (`order_no`),
    KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单表';

-- =============================================
-- 订单项表
-- =============================================
DROP TABLE IF EXISTS `order_item`;
CREATE TABLE `order_item` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '订单项ID',
    `order_id` BIGINT NOT NULL COMMENT '订单ID',
    `product_id` BIGINT NOT NULL COMMENT '商品ID',
    `product_name` VARCHAR(100) DEFAULT NULL COMMENT '商品名称',
    `product_image` VARCHAR(255) DEFAULT NULL COMMENT '商品图片',
    `product_spec` VARCHAR(50) DEFAULT NULL COMMENT '商品规格',
    `price` DECIMAL(10,2) DEFAULT NULL COMMENT '商品单价',
    `quantity` INT DEFAULT NULL COMMENT '数量',
    `total_amount` DECIMAL(10,2) DEFAULT NULL COMMENT '小计金额',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted` TINYINT DEFAULT 0 COMMENT '逻辑删除',
    PRIMARY KEY (`id`),
    KEY `idx_order_id` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单项表';

-- =============================================
-- 收货地址表
-- =============================================
DROP TABLE IF EXISTS `address`;
CREATE TABLE `address` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '地址ID',
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `receiver_name` VARCHAR(50) NOT NULL COMMENT '收货人姓名',
    `receiver_phone` VARCHAR(20) NOT NULL COMMENT '收货人电话',
    `province` VARCHAR(50) NOT NULL COMMENT '省份',
    `city` VARCHAR(50) NOT NULL COMMENT '城市',
    `district` VARCHAR(50) NOT NULL COMMENT '区县',
    `detail` VARCHAR(255) NOT NULL COMMENT '详细地址',
    `is_default` TINYINT DEFAULT 0 COMMENT '是否默认 0-否 1-是',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted` TINYINT DEFAULT 0 COMMENT '逻辑删除 0-未删除 1-已删除',
    PRIMARY KEY (`id`),
    KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='收货地址表';

-- =============================================
-- 支付记录表
-- =============================================
DROP TABLE IF EXISTS `payment`;
CREATE TABLE `payment` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '支付ID',
    `order_id` BIGINT NOT NULL COMMENT '订单ID',
    `order_no` VARCHAR(50) DEFAULT NULL COMMENT '订单号',
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `pay_amount` DECIMAL(10,2) DEFAULT NULL COMMENT '支付金额',
    `pay_type` TINYINT DEFAULT 0 COMMENT '支付方式 1-支付宝 2-微信',
    `status` TINYINT DEFAULT 0 COMMENT '支付状态 0-待支付 1-支付成功 2-支付失败',
    `transaction_no` VARCHAR(100) DEFAULT NULL COMMENT '交易流水号',
    `pay_time` DATETIME DEFAULT NULL COMMENT '支付时间',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted` TINYINT DEFAULT 0 COMMENT '逻辑删除',
    PRIMARY KEY (`id`),
    KEY `idx_order_id` (`order_id`),
    KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='支付记录表';

-- =============================================
-- 测试数据 - 用户 (20个用户)
-- =============================================
INSERT INTO `user` (`username`, `password`, `nickname`, `email`, `phone`, `gender`, `avatar`, `level`, `status`) VALUES
('admin', '123456', '钓鱼达人', 'admin@afishing.com', '13812345678', 0, '/uploads/profiles/008c2236-151b-4baa-8885-d8c7f5945c86.jpg', 3, 0),
('user1', '123456', '海鲜爱好者', 'user1@example.com', '13912345678', 1, '/uploads/profiles/0a959090-5383-480f-bd94-07ced92f5257.jpg', 1, 0),
('user2', '123456', '美食家', 'user2@example.com', '13712345678', 0, '/uploads/profiles/1784ff87-595c-428f-93c0-9dc0a4a4aa5c.jpg', 2, 0),
('user3', '123456', '吃货小王', 'user3@example.com', '13612345678', 0, '/uploads/profiles/1c8682a2-d2fc-4c74-92bf-89beb03c7554.jpg', 0, 0),
('user4', '123456', '厨房达人', 'user4@example.com', '13512345678', 1, '/uploads/profiles/31d285dd-695f-437a-af96-e699c7735198.jpg', 1, 0),
('user5', '123456', '海鲜控', 'user5@example.com', '13412345678', 0, '/uploads/profiles/356cb00e-273b-4857-bb60-e80f05e70d5f.jpg', 2, 0),
('user6', '123456', '美食探店', 'user6@example.com', '13312345678', 1, '/uploads/profiles/424f7ba1-1cf1-4e41-b16d-fd9f278b4332.jpg', 0, 0),
('user7', '123456', '鱼虾蟹爱好者', 'user7@example.com', '13212345678', 0, '/uploads/profiles/45f018ee-8310-4c3b-97de-3bedb4040dce.jpg', 1, 0),
('user8', '123456', '海鲜批发商', 'user8@example.com', '13112345678', 0, '/uploads/profiles/47aa8834-b26e-4b66-8173-4d7b038bdddf.jpg', 3, 0),
('user9', '123456', '家庭主妇', 'user9@example.com', '13012345678', 1, '/uploads/profiles/609b0739-ac85-4c08-8f0b-045721ecb494.jpg', 1, 0),
('user10', '123456', '餐厅老板', 'user10@example.com', '13811111111', 0, '/uploads/profiles/67fc62f4-5c0c-4608-b2bb-7cedaec9d713.jpg', 2, 0),
('user11', '123456', '美食博主', 'user11@example.com', '13822222222', 1, '/uploads/profiles/713f0959-d0b3-475d-ae2c-c69d84567843.jpg', 2, 0),
('user12', '123456', '海鲜新手', 'user12@example.com', '13833333333', 0, '/uploads/profiles/71eebadb-ba67-462a-9157-413c0fd327d9.jpg', 0, 0),
('user13', '123456', '资深吃货', 'user13@example.com', '13844444444', 0, '/uploads/profiles/79eb9d8e-1248-44bd-8213-fd584425781e.jpg', 3, 0),
('user14', '123456', '海鲜达人', 'user14@example.com', '13855555555', 1, '/uploads/profiles/8e64f325-49e7-4cf0-bac2-6ca4cc67d031.jpg', 1, 0),
('user15', '123456', '料理高手', 'user15@example.com', '13866666666', 0, '/uploads/profiles/9adae37b-0522-4050-b59e-a0dc5538f1a2.jpg', 2, 0),
('user16', '123456', '海鲜批发', 'user16@example.com', '13877777777', 0, '/uploads/profiles/9c85492a-062f-4b2e-a72f-8c695e5f3854.jpg', 3, 0),
('user17', '123456', '美食猎人', 'user17@example.com', '13888888888', 1, '/uploads/profiles/9eb28d8c-a311-4428-b1db-7d8d110d0bdb.jpg', 1, 0),
('user18', '123456', '海味轩', 'user18@example.com', '13899999999', 0, '/uploads/profiles/008c2236-151b-4baa-8885-d8c7f5945c86.jpg', 2, 0),
('user19', '123456', '渔港人家', 'user19@example.com', '13800000000', 0, '/uploads/profiles/0a959090-5383-480f-bd94-07ced92f5257.jpg', 0, 0);

-- =============================================
-- 测试数据 - 商品 (30个商品)
-- =============================================
INSERT INTO `product` (`name`, `description`, `category_id`, `price`, `original_price`, `stock`, `sales`, `main_image`, `specs`, `origin`, `weight`, `shelf_life`, `storage`, `status`) VALUES
-- 海鲜鱼类
('新鲜三文鱼', '挪威进口，肉质鲜美，富含Omega-3脂肪酸', 1, 68.00, 88.00, 500, 1256, 'https://picsum.photos/200/150?random=1', '["500g","1kg","2kg"]', '挪威', '500g/份', '冷冻保存30天', '-18°C以下冷冻保存', 1),
('鲍鱼', '大连野生，肉质肥厚，营养丰富', 1, 158.00, 198.00, 150, 432, 'https://picsum.photos/200/150?random=5', '["6头","8头"]', '大连', '约80g/个', '鲜活即食', '冷藏保存', 1),
('波士顿龙虾', '鲜活空运，肉质鲜美，高端食材', 1, 398.00, NULL, 80, 234, 'https://picsum.photos/200/150?random=6', '["1只","2只"]', '波士顿', '约700g/只', '鲜活即食', '冷藏保存', 1),
('金枪鱼', '深海野生，肉质鲜红，刺身首选', 1, 128.00, 158.00, 200, 567, 'https://picsum.photos/200/150?random=101', '["300g","500g"]', '深海', '300g/份', '冷冻保存20天', '-18°C以下冷冻保存', 1),
('黄花鱼', '东海野生，肉质细嫩，清蒸最佳', 1, 88.00, NULL, 350, 890, 'https://picsum.photos/200/150?random=102', '["500g","1kg"]', '东海', '500g/份', '冷藏保存3天', '0-4°C冷藏', 1),
('带鱼', '舟山带鱼，肉质肥美，红烧首选', 1, 35.00, NULL, 600, 1567, 'https://picsum.photos/200/150?random=103', '["500g","1kg"]', '舟山', '500g/份', '冷冻保存60天', '-18°C以下冷冻保存', 1),
('鲈鱼', '鲜活养殖，肉质鲜嫩，清蒸美味', 1, 45.00, NULL, 400, 789, 'https://picsum.photos/200/150?random=104', '["1条","2条"]', '广东', '约500g/条', '鲜活即食', '暂养池暂养', 1),
('石斑鱼', '深海石斑，肉质Q弹，高档海鲜', 1, 188.00, 228.00, 120, 345, 'https://picsum.photos/200/150?random=105', '["1kg","2kg"]', '南海', '1kg/份', '冷冻保存30天', '-18°C以下冷冻保存', 1),
('鳕鱼', '阿拉斯加鳕鱼，肉质雪白，儿童辅食', 1, 78.00, NULL, 450, 1234, 'https://picsum.photos/200/150?random=106', '["500g","1kg"]', '阿拉斯加', '500g/份', '冷冻保存90天', '-18°C以下冷冻保存', 1),
('龙利鱼', '去刺龙利鱼，肉质细嫩，老少皆宜', 1, 52.00, NULL, 380, 876, 'https://picsum.photos/200/150?random=107', '["500g"]', '越南', '500g/份', '冷冻保存60天', '-18°C以下冷冻保存', 1),
-- 虾蟹贝类
('大闸蟹礼盒', '阳澄湖直供，膏肥黄满，送礼首选', 2, 299.00, NULL, 200, 892, 'https://picsum.photos/200/150?random=2', '["4只装","8只装"]', '阳澄湖', '约500g/只', '鲜活即食', '冷藏保存', 1),
('扇贝', '新鲜扇贝，肉质鲜甜，蒜蓉粉丝最佳', 2, 58.00, NULL, 400, 789, 'https://picsum.photos/200/150?random=7', '["1kg"]', '山东', '1kg/份', '冷冻保存30天', '-18°C以下冷冻保存', 1),
('生蚝', '乳山生蚝，个大肥美，补锌佳品', 2, 48.00, NULL, 500, 1234, 'https://picsum.photos/200/150?random=8', '["2斤","5斤"]', '乳山', '约100g/个', '鲜活即食', '冷藏保存', 1),
('基围虾', '鲜活基围虾，肉质弹牙，白灼最佳', 2, 68.00, 88.00, 300, 1567, 'https://picsum.photos/200/150?random=108', '["500g","1kg"]', '广东', '500g/份', '鲜活即食', '暂养池暂养', 1),
('帝王蟹', '阿拉斯加帝王蟹，蟹中之王，宴席首选', 2, 688.00, NULL, 50, 123, 'https://picsum.photos/200/150?random=109', '["整只","半只"]', '阿拉斯加', '约3kg/只', '冷冻保存30天', '-18°C以下冷冻保存', 1),
('花蛤', '威海花蛤，肉质鲜嫩，爆炒美味', 2, 18.00, NULL, 800, 2345, 'https://picsum.photos/200/150?random=110', '["1kg","2kg"]', '威海', '1kg/份', '鲜活即食', '冷藏保存', 1),
('皮皮虾', '鲜活皮皮虾，肉质鲜美，椒盐最佳', 2, 58.00, NULL, 250, 678, 'https://picsum.photos/200/150?random=111', '["500g","1kg"]', '渤海', '500g/份', '鲜活即食', '暂养池暂养', 1),
('北极贝', '加拿大北极贝，鲜甜爽脆，刺身首选', 2, 98.00, NULL, 180, 456, 'https://picsum.photos/200/150?random=112', '["200g","500g"]', '加拿大', '200g/份', '冷冻保存60天', '-18°C以下冷冻保存', 1),
('青口贝', '新西兰青口贝，肉质饱满，蒜蓉蒸煮', 2, 38.00, NULL, 400, 987, 'https://picsum.photos/200/150?random=113', '["500g","1kg"]', '新西兰', '500g/份', '冷冻保存30天', '-18°C以下冷冻保存', 1),
('对虾', '南美白对虾，肉质紧实，多种烹饪', 2, 55.00, NULL, 500, 1456, 'https://picsum.photos/200/150?random=114', '["500g","1kg"]', '海南', '500g/份', '冷冻保存60天', '-18°C以下冷冻保存', 1),
-- 冷冻食品
('冷冻虾仁', '深海捕捞，去壳去虾线，方便烹饪', 3, 45.00, NULL, 800, 2341, 'https://picsum.photos/200/150?random=3', '["500g","1kg"]', '深海', '500g/份', '冷冻保存60天', '-18°C以下冷冻保存', 1),
('墨鱼仔', '新鲜速冻，口感Q弹，适合爆炒', 4, 38.00, NULL, 300, 567, 'https://picsum.photos/200/150?random=4', '["500g"]', '东海', '500g/份', '冷冻保存45天', '-18°C以下冷冻保存', 1),
('鱼丸', '潮汕手打鱼丸，Q弹爽滑，火锅必备', 3, 28.00, NULL, 600, 1890, 'https://picsum.photos/200/150?random=115', '["500g","1kg"]', '潮汕', '500g/份', '冷冻保存90天', '-18°C以下冷冻保存', 1),
('虾滑', '纯手工虾滑，虾肉含量高，火锅首选', 3, 48.00, NULL, 400, 1234, 'https://picsum.photos/200/150?random=116', '["200g","500g"]', '广东', '200g/份', '冷冻保存90天', '-18°C以下冷冻保存', 1),
('蟹柳', '日本风味蟹柳，鲜甜可口，沙拉必备', 3, 15.00, NULL, 1000, 3456, 'https://picsum.photos/200/150?random=117', '["200g"]', '日本', '200g/份', '冷冻保存180天', '-18°C以下冷冻保存', 1),
('鱼豆腐', '台湾风味鱼豆腐，嫩滑可口，火锅必备', 3, 18.00, NULL, 800, 2567, 'https://picsum.photos/200/150?random=118', '["300g"]', '台湾', '300g/份', '冷冻保存180天', '-18°C以下冷冻保存', 1),
('章鱼足', '深海章鱼足，肉质厚实，烧烤美味', 3, 68.00, NULL, 200, 456, 'https://picsum.photos/200/150?random=119', '["500g","1kg"]', '深海', '500g/份', '冷冻保存60天', '-18°C以下冷冻保存', 1),
('鳗鱼段', '蒲烧鳗鱼段，肥美鲜嫩，日式料理', 3, 88.00, 108.00, 150, 345, 'https://picsum.photos/200/150?random=120', '["300g","500g"]', '福建', '300g/份', '冷冻保存90天', '-18°C以下冷冻保存', 1),
-- 水产干货
('干贝', '大连干贝，鲜味浓郁，煲汤提鲜', 4, 128.00, NULL, 200, 567, 'https://picsum.photos/200/150?random=121', '["100g","250g"]', '大连', '100g/份', '常温保存12月', '阴凉干燥处', 1),
('花胶', '深海花胶，胶原蛋白丰富，滋补佳品', 4, 298.00, NULL, 100, 234, 'https://picsum.photos/200/150?random=122', '["50g","100g"]', '深海', '50g/份', '常温保存24月', '阴凉干燥处', 1),
('海参', '辽参，滋补养生，送礼佳品', 4, 388.00, NULL, 80, 123, 'https://picsum.photos/200/150?random=123', '["50g","100g"]', '辽宁', '50g/份', '常温保存24月', '阴凉干燥处', 1),
('鱿鱼干', '舟山鱿鱼干，肉质厚实，爆炒煲汤', 4, 68.00, NULL, 300, 890, 'https://picsum.photos/200/150?random=124', '["250g","500g"]', '舟山', '250g/份', '常温保存12月', '阴凉干燥处', 1),
('虾米', '金钩虾米，鲜味十足，调味佳品', 4, 45.00, NULL, 500, 1567, 'https://picsum.photos/200/150?random=125', '["100g","250g"]', '福建', '100g/份', '常温保存12月', '阴凉干燥处', 1);

-- =============================================
-- 测试数据 - 购物车 (15条)
-- =============================================
INSERT INTO `cart` (`user_id`, `product_id`, `product_name`, `product_image`, `product_spec`, `price`, `quantity`, `selected`) VALUES
(1, 1, '新鲜三文鱼', 'https://picsum.photos/100/100?random=40', '500g', 68.00, 2, 1),
(1, 2, '大闸蟹礼盒', 'https://picsum.photos/100/100?random=41', '8只装', 299.00, 1, 1),
(1, 3, '冷冻虾仁', 'https://picsum.photos/100/100?random=42', '1kg', 45.00, 3, 0),
(2, 5, '鲍鱼', 'https://picsum.photos/100/100?random=43', '6头', 158.00, 2, 1),
(2, 6, '波士顿龙虾', 'https://picsum.photos/100/100?random=44', '1只', 398.00, 1, 1),
(3, 10, '石斑鱼', 'https://picsum.photos/100/100?random=45', '1kg', 188.00, 1, 1),
(3, 15, '帝王蟹', 'https://picsum.photos/100/100?random=46', '半只', 688.00, 1, 1),
(4, 11, '基围虾', 'https://picsum.photos/100/100?random=47', '1kg', 68.00, 2, 1),
(4, 16, '花蛤', 'https://picsum.photos/100/100?random=48', '2kg', 18.00, 3, 1),
(5, 21, '鱼丸', 'https://picsum.photos/100/100?random=49', '1kg', 28.00, 2, 1),
(5, 22, '虾滑', 'https://picsum.photos/100/100?random=50', '500g', 48.00, 1, 1),
(6, 26, '鳗鱼段', 'https://picsum.photos/100/100?random=51', '500g', 88.00, 2, 1),
(7, 27, '干贝', 'https://picsum.photos/100/100?random=52', '250g', 128.00, 1, 1),
(8, 28, '花胶', 'https://picsum.photos/100/100?random=53', '100g', 298.00, 1, 1),
(9, 29, '海参', 'https://picsum.photos/100/100?random=54', '100g', 388.00, 2, 1);

-- =============================================
-- 测试数据 - 订单 (25个订单)
-- =============================================
INSERT INTO `order` (`order_no`, `user_id`, `receiver_name`, `receiver_phone`, `receiver_address`, `total_amount`, `freight`, `pay_amount`, `pay_type`, `pay_time`, `status`, `remark`) VALUES
('202401150001', 1, '张三', '13812345678', '浙江省杭州市西湖区文三路xxx号', 435.00, 0.00, 435.00, 0, NULL, 0, ''),
('202401140002', 1, '张三', '13812345678', '浙江省杭州市西湖区文三路xxx号', 135.00, 0.00, 135.00, 1, '2024-01-14 10:30:00', 2, ''),
('202401130003', 1, '张三', '13812345678', '浙江省杭州市西湖区文三路xxx号', 68.00, 0.00, 68.00, 1, '2024-01-13 17:00:00', 3, ''),
('202401120001', 2, '李四', '13912345678', '北京市朝阳区建国路xxx号', 714.00, 0.00, 714.00, 1, '2024-01-12 09:00:00', 3, '送货前请电话联系'),
('202401110002', 2, '李四', '13912345678', '北京市朝阳区建国路xxx号', 398.00, 0.00, 398.00, 2, '2024-01-11 14:30:00', 3, ''),
('202401100001', 3, '王五', '13712345678', '上海市浦东新区陆家嘴xxx号', 876.00, 0.00, 876.00, 1, '2024-01-10 16:00:00', 1, ''),
('202401090001', 4, '赵六', '13612345678', '广州市天河区天河路xxx号', 190.00, 0.00, 190.00, 1, '2024-01-09 11:00:00', 3, ''),
('202401080001', 5, '钱七', '13512345678', '深圳市南山区科技园xxx号', 104.00, 0.00, 104.00, 2, '2024-01-08 15:30:00', 3, ''),
('202401070001', 6, '孙八', '13412345678', '成都市武侯区天府大道xxx号', 176.00, 0.00, 176.00, 1, '2024-01-07 10:00:00', 2, '周末配送'),
('202401060001', 7, '周九', '13312345678', '杭州市滨江区江南大道xxx号', 128.00, 0.00, 128.00, 1, '2024-01-06 14:00:00', 3, ''),
('202401050001', 8, '吴十', '13212345678', '南京市鼓楼区中山路xxx号', 298.00, 0.00, 298.00, 2, '2024-01-05 09:30:00', 3, ''),
('202401040001', 9, '郑十一', '13112345678', '武汉市江汉区解放大道xxx号', 776.00, 0.00, 776.00, 1, '2024-01-04 16:30:00', 3, ''),
('202401030001', 10, '陈十二', '13012345678', '西安市雁塔区高新路xxx号', 398.00, 0.00, 398.00, 1, '2024-01-03 11:30:00', 2, ''),
('202401020001', 11, '林十三', '13811111111', '重庆市渝中区解放碑xxx号', 158.00, 0.00, 158.00, 1, '2024-01-02 14:00:00', 3, ''),
('202401010001', 12, '黄十四', '13822222222', '天津市和平区南京路xxx号', 68.00, 0.00, 68.00, 2, '2024-01-01 10:00:00', 3, ''),
('202312310001', 13, '许十五', '13833333333', '苏州市工业园区金鸡湖xxx号', 456.00, 0.00, 456.00, 1, '2023-12-31 15:00:00', 3, '新年礼物'),
('202312300001', 14, '何十六', '13844444444', '青岛市市南区香港中路xxx号', 234.00, 0.00, 234.00, 1, '2023-12-30 09:00:00', 3, ''),
('202312290001', 15, '张十七', '13855555555', '厦门市思明区鹭江道xxx号', 188.00, 0.00, 188.00, 2, '2023-12-29 14:30:00', 3, ''),
('202312280001', 16, '孔十八', '13866666666', '长沙市岳麓区岳麓大道xxx号', 566.00, 0.00, 566.00, 1, '2023-12-28 11:00:00', 3, ''),
('202312270001', 17, '曹十九', '13877777777', '郑州市金水区金水路xxx号', 128.00, 0.00, 128.00, 1, '2023-12-27 16:00:00', 3, ''),
('202312260001', 18, '严二十', '13888888888', '济南市历下区泉城路xxx号', 388.00, 0.00, 388.00, 2, '2023-12-26 10:30:00', 3, ''),
('202312250001', 19, '华二一', '13899999999', '合肥市蜀山区长江路xxx号', 688.00, 0.00, 688.00, 1, '2023-12-25 15:00:00', 1, '圣诞礼物'),
('202312240001', 1, '张三', '13812345678', '浙江省杭州市西湖区文三路xxx号', 256.00, 0.00, 256.00, 1, '2023-12-24 09:30:00', 3, ''),
('202312230001', 2, '李四', '13912345678', '北京市朝阳区建国路xxx号', 456.00, 0.00, 456.00, 1, '2023-12-23 14:00:00', 3, ''),
('202312220001', 3, '王五', '13712345678', '上海市浦东新区陆家嘴xxx号', 158.00, 0.00, 158.00, 2, '2023-12-22 11:30:00', 4, '');

-- =============================================
-- 测试数据 - 订单项 (50条)
-- =============================================
INSERT INTO `order_item` (`order_id`, `product_id`, `product_name`, `product_image`, `product_spec`, `price`, `quantity`, `total_amount`) VALUES
-- 订单1
(1, 1, '新鲜三文鱼', 'https://picsum.photos/80/80?random=50', '500g', 68.00, 2, 136.00),
(1, 2, '大闸蟹礼盒', 'https://picsum.photos/80/80?random=51', '8只装', 299.00, 1, 299.00),
-- 订单2
(2, 3, '冷冻虾仁', 'https://picsum.photos/80/80?random=52', '1kg', 45.00, 3, 135.00),
-- 订单3
(3, 1, '新鲜三文鱼', 'https://picsum.photos/80/80?random=53', '500g', 68.00, 1, 68.00),
-- 订单4
(4, 5, '鲍鱼', 'https://picsum.photos/80/80?random=54', '6头', 158.00, 2, 316.00),
(4, 6, '波士顿龙虾', 'https://picsum.photos/80/80?random=55', '1只', 398.00, 1, 398.00),
-- 订单5
(5, 6, '波士顿龙虾', 'https://picsum.photos/80/80?random=56', '1只', 398.00, 1, 398.00),
-- 订单6
(6, 10, '石斑鱼', 'https://picsum.photos/80/80?random=57', '1kg', 188.00, 1, 188.00),
(6, 15, '帝王蟹', 'https://picsum.photos/80/80?random=58', '半只', 688.00, 1, 688.00),
-- 订单7
(7, 11, '基围虾', 'https://picsum.photos/80/80?random=59', '1kg', 68.00, 2, 136.00),
(7, 16, '花蛤', 'https://picsum.photos/80/80?random=60', '2kg', 18.00, 3, 54.00),
-- 订单8
(8, 21, '鱼丸', 'https://picsum.photos/80/80?random=61', '1kg', 28.00, 2, 56.00),
(8, 22, '虾滑', 'https://picsum.photos/80/80?random=62', '500g', 48.00, 1, 48.00),
-- 订单9
(9, 26, '鳗鱼段', 'https://picsum.photos/80/80?random=63', '500g', 88.00, 2, 176.00),
-- 订单10
(10, 27, '干贝', 'https://picsum.photos/80/80?random=64', '250g', 128.00, 1, 128.00),
-- 订单11
(11, 28, '花胶', 'https://picsum.photos/80/80?random=65', '100g', 298.00, 1, 298.00),
-- 订单12
(12, 29, '海参', 'https://picsum.photos/80/80?random=66', '100g', 388.00, 2, 776.00),
-- 订单13
(13, 6, '波士顿龙虾', 'https://picsum.photos/80/80?random=67', '1只', 398.00, 1, 398.00),
-- 订单14
(14, 5, '鲍鱼', 'https://picsum.photos/80/80?random=68', '6头', 158.00, 1, 158.00),
-- 订单15
(15, 1, '新鲜三文鱼', 'https://picsum.photos/80/80?random=69', '500g', 68.00, 1, 68.00),
-- 订单16
(16, 10, '石斑鱼', 'https://picsum.photos/80/80?random=70', '1kg', 188.00, 1, 188.00),
(16, 11, '基围虾', 'https://picsum.photos/80/80?random=71', '1kg', 68.00, 2, 136.00),
(16, 16, '花蛤', 'https://picsum.photos/80/80?random=72', '2kg', 18.00, 2, 36.00),
(16, 21, '鱼丸', 'https://picsum.photos/80/80?random=73', '1kg', 28.00, 2, 56.00),
(16, 22, '虾滑', 'https://picsum.photos/80/80?random=74', '500g', 48.00, 2, 96.00),
-- 订单17
(17, 11, '基围虾', 'https://picsum.photos/80/80?random=75', '1kg', 68.00, 2, 136.00),
(17, 16, '花蛤', 'https://picsum.photos/80/80?random=76', '2kg', 18.00, 2, 36.00),
(17, 21, '鱼丸', 'https://picsum.photos/80/80?random=77', '1kg', 28.00, 2, 56.00),
-- 订单18
(18, 5, '鲍鱼', 'https://picsum.photos/80/80?random=78', '6头', 158.00, 1, 158.00),
(18, 10, '石斑鱼', 'https://picsum.photos/80/80?random=79', '1kg', 188.00, 1, 188.00),
(18, 26, '鳗鱼段', 'https://picsum.photos/80/80?random=80', '500g', 88.00, 1, 88.00),
(18, 27, '干贝', 'https://picsum.photos/80/80?random=81', '250g', 128.00, 1, 128.00),
-- 订单19
(19, 27, '干贝', 'https://picsum.photos/80/80?random=82', '250g', 128.00, 1, 128.00),
-- 订单20
(20, 28, '花胶', 'https://picsum.photos/80/80?random=83', '100g', 298.00, 1, 298.00),
(20, 29, '海参', 'https://picsum.photos/80/80?random=84', '100g', 388.00, 1, 388.00),
-- 订单21
(21, 15, '帝王蟹', 'https://picsum.photos/80/80?random=85', '半只', 688.00, 1, 688.00),
-- 订单22
(22, 1, '新鲜三文鱼', 'https://picsum.photos/80/80?random=86', '500g', 68.00, 2, 136.00),
(22, 3, '冷冻虾仁', 'https://picsum.photos/80/80?random=87', '1kg', 45.00, 2, 90.00),
(22, 21, '鱼丸', 'https://picsum.photos/80/80?random=88', '1kg', 28.00, 1, 28.00),
-- 订单23
(23, 10, '石斑鱼', 'https://picsum.photos/80/80?random=89', '1kg', 188.00, 1, 188.00),
(23, 26, '鳗鱼段', 'https://picsum.photos/80/80?random=90', '500g', 88.00, 1, 88.00),
(23, 27, '干贝', 'https://picsum.photos/80/80?random=91', '250g', 128.00, 1, 128.00),
(23, 21, '鱼丸', 'https://picsum.photos/80/80?random=92', '1kg', 28.00, 2, 56.00),
-- 订单24
(24, 5, '鲍鱼', 'https://picsum.photos/80/80?random=93', '6头', 158.00, 2, 316.00),
(24, 11, '基围虾', 'https://picsum.photos/80/80?random=94', '1kg', 68.00, 2, 136.00),
-- 订单25
(25, 5, '鲍鱼', 'https://picsum.photos/80/80?random=95', '6头', 158.00, 1, 158.00);

