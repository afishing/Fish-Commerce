package com.afishing.controller;

import com.afishing.common.result.PageResult;
import com.afishing.common.result.Result;
import com.afishing.dto.*;
import com.afishing.entity.Order;
import com.afishing.entity.Product;
import com.afishing.entity.User;
import com.afishing.service.AdminService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

/**
 * 管理员控制器
 * 提供后台管理相关接口
 */
@RestController
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminController {

    private final AdminService adminService;

    /**
     * 管理员登录
     */
    @PostMapping("/login")
    public Result<LoginVO> adminLogin(@Valid @RequestBody AdminLoginDTO loginDTO) {
        return adminService.adminLogin(loginDTO);
    }

    /**
     * 获取统计信息
     */
    @GetMapping("/statistics")
    public Result<AdminStatisticsDTO> getStatistics() {
        return adminService.getStatistics();
    }

    // ========== 用户管理 ==========

    /**
     * 获取用户列表
     */
    @PostMapping("/user/list")
    public Result<PageResult<User>> getUserList(@RequestBody UserQueryDTO queryDTO) {
        return adminService.getUserList(queryDTO);
    }

    /**
     * 禁用用户
     */
    @PutMapping("/user/disable/{userId}")
    public Result<Void> disableUser(@PathVariable Long userId) {
        return adminService.updateUserStatus(userId, 1);
    }

    /**
     * 启用用户
     */
    @PutMapping("/user/enable/{userId}")
    public Result<Void> enableUser(@PathVariable Long userId) {
        return adminService.updateUserStatus(userId, 0);
    }

    // ========== 订单管理 ==========

    /**
     * 获取订单列表
     */
    @GetMapping("/order/list")
    public Result<PageResult<Order>> getOrderList(
            @RequestParam(required = false) Integer status,
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size) {
        return adminService.getOrderList(status, page, size);
    }

    /**
     * 发货
     */
    @PutMapping("/order/ship/{orderId}")
    public Result<Void> shipOrder(@PathVariable Long orderId) {
        return adminService.shipOrder(orderId);
    }

    // ========== 商品管理 ==========

    /**
     * 获取商品列表
     */
    @GetMapping("/product/list")
    public Result<PageResult<Product>> getProductList(
            @RequestParam(required = false) Integer status,
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size) {
        return adminService.getProductList(status, page, size);
    }

    /**
     * 添加商品
     */
    @PostMapping("/product/add")
    public Result<Void> addProduct(@Valid @RequestBody ProductAddDTO productDTO) {
        return adminService.addProduct(productDTO);
    }

    /**
     * 更新商品
     */
    @PutMapping("/product/update")
    public Result<Void> updateProduct(@RequestBody Product product) {
        return adminService.updateProduct(product);
    }

    /**
     * 上架商品
     */
    @PutMapping("/product/enable/{productId}")
    public Result<Void> enableProduct(@PathVariable Long productId) {
        return adminService.updateProductStatus(productId, 1);
    }

    /**
     * 下架商品
     */
    @PutMapping("/product/disable/{productId}")
    public Result<Void> disableProduct(@PathVariable Long productId) {
        return adminService.updateProductStatus(productId, 0);
    }

    /**
     * 删除商品
     */
    @DeleteMapping("/product/delete/{productId}")
    public Result<Void> deleteProduct(@PathVariable Long productId) {
        return adminService.deleteProduct(productId);
    }

    /**
     * 获取用户画像
     */
    @GetMapping("/portrait")
    public Result<UserPortraitDTO> getUserPortrait() {
        return adminService.getUserPortrait();
    }
}
