package com.afishing.entity;

import com.afishing.common.entity.BaseEntity;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 用户实体
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("user")
public class User extends BaseEntity {

    /**
     * 用户名
     */
    private String username;

    /**
     * 密码
     */
    private String password;

    /**
     * 昵称
     */
    private String nickname;

    /**
     * 邮箱
     */
    private String email;

    /**
     * 手机号
     */
    private String phone;

    /**
     * 性别 0-男 1-女 2-保密
     */
    private Integer gender;

    /**
     * 头像
     */
    private String avatar;

    /**
     * 生日
     */
    private java.time.LocalDate birthday;

    /**
     * 会员等级
     */
    private Integer level;

    /**
     * 状态 0-正常 1-禁用
     */
    private Integer status;

    /**
     * 角色 0-普通用户 1-管理员
     */
    private Integer role;
}
