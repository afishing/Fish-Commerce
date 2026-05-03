package com.afishing.dto;

import com.afishing.entity.User;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

/**
 * 登录响应VO
 * 包含 JWT Token 和用户信息
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class LoginVO implements Serializable {

    /**
     * JWT Token
     */
    private String token;

    /**
     * 用户信息
     */
    private User user;
}
