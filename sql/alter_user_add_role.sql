-- 为 user 表添加 role 字段
ALTER TABLE user ADD COLUMN role INT DEFAULT 0 COMMENT '角色 0-普通用户 1-管理员';

-- 创建管理员账号（密码建议后续修改）
INSERT INTO user (username, password, nickname, email, phone, gender, level, status, role, create_time, update_time)
VALUES ('admin', '123456', '管理员', 'admin@fish.com', '13800000000', 0, 0, 0, 1, NOW(), NOW());
