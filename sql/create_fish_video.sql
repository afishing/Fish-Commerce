-- fish_video Database DDL

CREATE DATABASE IF NOT EXISTS `fish_video` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `fish_video`;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='视频管理表（广告模块）';

