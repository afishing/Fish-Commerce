-- =============================================
-- 添加商品标签表（用于 content 库）
-- =============================================

-- 如果还没有使用 content 库，请先执行：
-- CREATE DATABASE IF NOT EXISTS content DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
-- USE content;

-- =============================================
-- 商品标签信息表
-- =============================================
DROP TABLE IF EXISTS `product_tag_info`;
CREATE TABLE `product_tag_info` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '标签 ID',
    `name` VARCHAR(50) NOT NULL COMMENT '标签名称',
    `sort` INT DEFAULT 0 COMMENT '排序权重（值越大越靠前）',
    `description` VARCHAR(255) DEFAULT NULL COMMENT '描述信息',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品标签信息表';

-- =============================================
-- 商品标签关联表（多对多）
-- =============================================
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
-- 插入测试数据 - 商品标签
-- =============================================
INSERT INTO `product_tag_info` (`name`, `sort`, `description`) VALUES
('热卖', 100, '热销商品'),
('新品', 90, '新上市商品'),
('推荐', 80, '店长推荐'),
('特价', 70, '特价优惠'),
('进口', 60, '进口商品'),
('有机', 50, '有机认证'),
('绿色', 40, '绿色食品'),
('无添加', 30, '无添加剂');
