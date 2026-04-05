-- =============================================
-- 为 gallery_image 表添加 original_filename 字段
-- =============================================

USE fish_content;

-- 添加 original_filename 字段（如果不存在）
ALTER TABLE `gallery_image` 
ADD COLUMN `original_filename` VARCHAR(255) DEFAULT NULL COMMENT '原始文件名' 
AFTER `filename`;
