-- =============================================
-- 为 tag 表添加 sort 和 description 字段
-- =============================================

USE fish_product;

-- 添加 sort 字段（如果不存在）
ALTER TABLE `tag` 
ADD COLUMN `sort` INT DEFAULT 0 COMMENT '排序权重（值越大越靠前）' 
AFTER `name`;

-- 添加 description 字段（如果不存在）
ALTER TABLE `tag` 
ADD COLUMN `description` VARCHAR(255) DEFAULT NULL COMMENT '描述信息' 
AFTER `sort`;
