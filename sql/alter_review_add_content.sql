-- 为 review 表添加 content 字段
ALTER TABLE `review` ADD COLUMN `content` TEXT COMMENT '评价内容' AFTER `username`;
