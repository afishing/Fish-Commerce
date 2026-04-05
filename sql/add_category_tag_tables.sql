-- =============================================
-- 添加商品分类和标签表（根据实际表结构调整）
-- =============================================

-- =============================================
-- 在 fish_product 库中创建分类表和标签表
-- =============================================
USE fish_product;

-- 商品分类表（如果已存在则跳过）
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '分类 ID',
    `name` VARCHAR(50) NOT NULL COMMENT '分类名称',
    `icon` VARCHAR(255) DEFAULT NULL COMMENT '分类图标',
    `sort` INT DEFAULT 0 COMMENT '排序权重（值越大越靠前）',
    `description` VARCHAR(255) DEFAULT NULL COMMENT '描述信息',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品分类表';

-- 商品标签信息表（如果已存在则跳过）
DROP TABLE IF EXISTS `tag`;
CREATE TABLE `tag` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '标签 ID',
    `name` VARCHAR(50) NOT NULL COMMENT '标签名称',
    `sort` INT DEFAULT 0 COMMENT '排序权重（值越大越靠前）',
    `description` VARCHAR(255) DEFAULT NULL COMMENT '描述信息',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品标签信息表';

-- 商品标签关联表（如果已存在则跳过）
DROP TABLE IF EXISTS `product_tag`;
CREATE TABLE `product_tag` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '关联 ID',
    `product_id` BIGINT NOT NULL COMMENT '商品 ID',
    `tag_id` BIGINT NOT NULL COMMENT '标签 ID',
    PRIMARY KEY (`id`),
    KEY `idx_product_id` (`product_id`),
    KEY `idx_tag_id` (`tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品标签关联表';

-- =============================================
-- 插入测试数据
-- =============================================
USE fish_product;

-- 分类数据
INSERT INTO `category` (`name`, `icon`, `sort`, `description`) VALUES
('海鲜水产', '/imgs/category/seafood.png', 100, '新鲜海鲜，深海直供'),
('水果蔬菜', '/imgs/category/fruit.png', 90, '新鲜采摘，绿色健康'),
('肉禽蛋品', '/imgs/category/meat.png', 80, '优质肉品，新鲜直达'),
('粮油调味', '/imgs/category/grain.png', 70, '品质粮油，调味必备'),
('熟食烘焙', '/imgs/category/cooked.png', 60, '即食美食，新鲜出炉'),
('乳品冷饮', '/imgs/category/dairy.png', 50, '优质乳品，清凉一夏'),
('酒水饮料', '/imgs/category/drink.png', 40, '美酒佳饮，畅饮无限'),
('休闲零食', '/imgs/category/snack.png', 30, '休闲时刻，美味相伴');

-- 标签数据
INSERT INTO `tag` (`name`, `sort`, `description`) VALUES
('热卖', 100, '热销商品'),
('新品', 90, '新上市商品'),
('推荐', 80, '店长推荐'),
('特价', 70, '特价优惠'),
('进口', 60, '进口商品'),
('有机', 50, '有机认证'),
('绿色', 40, '绿色食品'),
('无添加', 30, '无添加剂');
