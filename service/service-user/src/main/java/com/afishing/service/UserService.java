package com.afishing.service;

import com.afishing.common.result.Result;
import com.afishing.dto.*;
import com.afishing.entity.User;

/**
 * 用户服务接口
 */
public interface UserService {

    /**
     * 用户登录
     */
    Result<User> login(LoginDTO loginDTO);

    /**
     * 用户注册
     */
    Result<Void> register(RegisterDTO registerDTO);

    /**
     * 获取用户信息
     */
    Result<User> getUserInfo(Long id);

    /**
     * 更新用户信息
     */
    Result<Void> updateUser(User user);

    /**
     * 修改密码
     */
    Result<Void> updatePassword(UpdatePasswordDTO updatePasswordDTO);

    /**
     * 修改手机号
     */
    Result<Void> updatePhone(UpdatePhoneDTO updatePhoneDTO);

    /**
     * 修改邮箱
     */
    Result<Void> updateEmail(UpdateEmailDTO updateEmailDTO);
}
