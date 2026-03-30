package com.afishing.service.impl;

import com.afishing.common.result.Result;
import com.afishing.dto.*;
import com.afishing.entity.User;
import com.afishing.mapper.UserMapper;
import com.afishing.service.UserService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

/**
 * 用户服务实现
 */
@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    @Override
    public Result<User> login(LoginDTO loginDTO) {
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(User::getUsername, loginDTO.getUsername());
        User user = userMapper.selectOne(wrapper);
        
        if (user == null) {
            return Result.error("用户不存在");
        }
        
        if (!user.getPassword().equals(loginDTO.getPassword())) {
            return Result.error("密码错误");
        }
        
        if (user.getStatus() == 1) {
            return Result.error("账号已被禁用");
        }
        
        // 清除密码后返回
        user.setPassword(null);
        return Result.success("登录成功", user);
    }

    @Override
    public Result<Void> register(RegisterDTO registerDTO) {
        if (!registerDTO.getPassword().equals(registerDTO.getConfirmPassword())) {
            return Result.error("两次密码输入不一致");
        }
        
        // 检查用户名是否存在
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(User::getUsername, registerDTO.getUsername());
        if (userMapper.selectCount(wrapper) > 0) {
            return Result.error("用户名已存在");
        }
        
        // 创建用户
        User user = new User();
        user.setUsername(registerDTO.getUsername());
        user.setPassword(registerDTO.getPassword());
        user.setEmail(registerDTO.getEmail());
        user.setPhone(registerDTO.getPhone());
        user.setNickname(registerDTO.getUsername());
        user.setLevel(0);
        user.setStatus(0);
        user.setGender(2);
        
        userMapper.insert(user);
        return Result.success("注册成功", null);
    }

    @Override
    public Result<User> getUserInfo(Long id) {
        User user = userMapper.selectById(id);
        if (user == null) {
            return Result.error("用户不存在");
        }
        user.setPassword(null);
        return Result.success(user);
    }

    @Override
    public Result<Void> updateUser(User user) {
        User existUser = userMapper.selectById(user.getId());
        if (existUser == null) {
            return Result.error("用户不存在");
        }
        
        // 只更新允许修改的字段
        existUser.setNickname(user.getNickname());
        existUser.setEmail(user.getEmail());
        existUser.setPhone(user.getPhone());
        existUser.setGender(user.getGender());
        existUser.setAvatar(user.getAvatar());
        existUser.setBirthday(user.getBirthday());
        
        userMapper.updateById(existUser);
        return Result.success("更新成功", null);
    }

    @Override
    public Result<Void> updatePassword(UpdatePasswordDTO updatePasswordDTO) {
        // 检查两次新密码是否一致
        if (!updatePasswordDTO.getNewPassword().equals(updatePasswordDTO.getConfirmPassword())) {
            return Result.error("两次新密码输入不一致");
        }
        
        User user = userMapper.selectById(updatePasswordDTO.getUserId());
        if (user == null) {
            return Result.error("用户不存在");
        }
        
        // 验证旧密码
        if (!user.getPassword().equals(updatePasswordDTO.getOldPassword())) {
            return Result.error("旧密码错误");
        }
        
        // 更新密码
        user.setPassword(updatePasswordDTO.getNewPassword());
        userMapper.updateById(user);
        
        return Result.success("密码修改成功", null);
    }

    @Override
    public Result<Void> updatePhone(UpdatePhoneDTO updatePhoneDTO) {
        User user = userMapper.selectById(updatePhoneDTO.getUserId());
        if (user == null) {
            return Result.error("用户不存在");
        }
        
        // 检查手机号是否已被其他用户使用
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(User::getPhone, updatePhoneDTO.getPhone());
        wrapper.ne(User::getId, updatePhoneDTO.getUserId());
        if (userMapper.selectCount(wrapper) > 0) {
            return Result.error("该手机号已被其他账号绑定");
        }
        
        // 更新手机号
        user.setPhone(updatePhoneDTO.getPhone());
        userMapper.updateById(user);
        
        return Result.success("手机号修改成功", null);
    }

    @Override
    public Result<Void> updateEmail(UpdateEmailDTO updateEmailDTO) {
        User user = userMapper.selectById(updateEmailDTO.getUserId());
        if (user == null) {
            return Result.error("用户不存在");
        }
        
        // 检查邮箱是否已被其他用户使用
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(User::getEmail, updateEmailDTO.getEmail());
        wrapper.ne(User::getId, updateEmailDTO.getUserId());
        if (userMapper.selectCount(wrapper) > 0) {
            return Result.error("该邮箱已被其他账号绑定");
        }
        
        // 更新邮箱
        user.setEmail(updateEmailDTO.getEmail());
        userMapper.updateById(user);
        
        return Result.success("邮箱修改成功", null);
    }

    @Override
    public Result<Void> purchaseVip(Long userId, Integer vipType) {
        User user = userMapper.selectById(userId);
        if (user == null) {
            return Result.error("用户不存在");
        }

        LocalDateTime now = LocalDateTime.now();
        LocalDateTime baseTime = user.getVipExpireTime() != null && user.getVipExpireTime().isAfter(now)
                ? user.getVipExpireTime()
                : now;

        LocalDateTime newExpireTime;
        switch (vipType) {
            case 1: // 月卡
                newExpireTime = baseTime.plusMonths(1);
                break;
            case 2: // 季卡
                newExpireTime = baseTime.plusMonths(3);
                break;
            case 3: // 年卡
                newExpireTime = baseTime.plusYears(1);
                break;
            default:
                return Result.error("无效的会员类型");
        }

        user.setLevel(vipType);
        user.setVipExpireTime(newExpireTime);
        userMapper.updateById(user);

        return Result.success("购买成功", null);
    }

    @Override
    public Result<Void> checkVipStatus(Long userId) {
        User user = userMapper.selectById(userId);
        if (user == null) {
            return Result.error("用户不存在");
        }

        // 如果会员已过期，降级为普通用户
        if (user.getVipExpireTime() != null && user.getVipExpireTime().isBefore(LocalDateTime.now())) {
            user.setLevel(0);
            user.setVipExpireTime(null);
            userMapper.updateById(user);
        }

        return Result.success(null);
    }
}
