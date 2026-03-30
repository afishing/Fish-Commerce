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

    /**
     * 购买会员
     * @param userId 用户ID
     * @param vipType 会员类型 1-月卡 2-季卡 3-年卡
     */
    Result<Void> purchaseVip(Long userId, Integer vipType);

    /**
     * 检查并更新会员状态（如果已过期则降级）
     */
    Result<Void> checkVipStatus(Long userId);
}
