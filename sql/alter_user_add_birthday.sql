-- 为用户表添加 birthday 字段
ALTER TABLE `user` ADD COLUMN `birthday` DATE DEFAULT NULL COMMENT '生日' AFTER `avatar`;
