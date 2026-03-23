package com.afishing.controller;

import com.afishing.common.result.Result;
import com.afishing.dto.*;
import com.afishing.entity.User;
import com.afishing.service.UserService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * 用户控制器
 */
@RestController
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserService userService;

    /**
     * 用户登录
     */
    @PostMapping("/login")
    public Result<User> login(@Valid @RequestBody LoginDTO loginDTO) {
        return userService.login(loginDTO);
    }

    /**
     * 用户注册
     */
    @PostMapping("/register")
    public Result<Void> register(@Valid @RequestBody RegisterDTO registerDTO) {
        return userService.register(registerDTO);
    }

    /**
     * 获取用户信息
     */
    @GetMapping("/info/{id}")
    public Result<User> getUserInfo(@PathVariable Long id) {
        return userService.getUserInfo(id);
    }

    /**
     * 更新用户信息
     */
    @PutMapping("/update")
    public Result<Void> updateUser(@RequestBody User user) {
        return userService.updateUser(user);
    }

    /**
     * 修改密码
     */
    @PostMapping("/password")
    public Result<Void> updatePassword(@Valid @RequestBody UpdatePasswordDTO updatePasswordDTO) {
        return userService.updatePassword(updatePasswordDTO);
    }

    /**
     * 修改手机号
     */
    @PostMapping("/phone")
    public Result<Void> updatePhone(@Valid @RequestBody UpdatePhoneDTO updatePhoneDTO) {
        return userService.updatePhone(updatePhoneDTO);
    }

    /**
     * 修改邮箱
     */
    @PostMapping("/email")
    public Result<Void> updateEmail(@Valid @RequestBody UpdateEmailDTO updateEmailDTO) {
        return userService.updateEmail(updateEmailDTO);
    }
}
