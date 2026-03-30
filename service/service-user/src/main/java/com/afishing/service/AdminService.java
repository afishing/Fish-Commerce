package com.afishing.service;

import com.afishing.common.result.PageResult;
import com.afishing.common.result.Result;
import com.afishing.dto.*;
import com.afishing.entity.Order;
import com.afishing.entity.Product;
import com.afishing.entity.User;

/**
 * 管理员服务接口
 */
public interface AdminService {

    /**
     * 管理员登录
     */
    Result<User> adminLogin(AdminLoginDTO loginDTO);

    /**
     * 获取统计信息
     */
    Result<AdminStatisticsDTO> getStatistics();

    /**
     * 获取用户列表
     */
    Result<PageResult<User>> getUserList(UserQueryDTO queryDTO);

    /**
     * 禁用/启用用户
     */
    Result<Void> updateUserStatus(Long userId, Integer status);

    /**
     * 获取订单列表（管理员视角）
     */
    Result<PageResult<Order>> getOrderList(Integer status, Integer page, Integer size);

    /**
     * 发货
     */
    Result<Void> shipOrder(Long orderId);

    /**
     * 获取商品列表（管理员视角）
     */
    Result<PageResult<Product>> getProductList(Integer status, Integer page, Integer size);

    /**
     * 添加商品
     */
    Result<Void> addProduct(ProductAddDTO productDTO);

    /**
     * 更新商品
     */
    Result<Void> updateProduct(Product product);

    /**
     * 上架/下架商品
     */
    Result<Void> updateProductStatus(Long productId, Integer status);

    /**
     * 删除商品
     */
    Result<Void> deleteProduct(Long productId);

    /**
     * 获取用户画像
     */
    Result<UserPortraitDTO> getUserPortrait();
}
