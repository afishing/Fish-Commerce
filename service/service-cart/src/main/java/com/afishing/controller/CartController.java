package com.afishing.controller;

import com.afishing.common.result.Result;
import com.afishing.dto.CartDTO;
import com.afishing.entity.Cart;
import com.afishing.service.CartService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 购物车控制器
 */
@RestController
@RequestMapping("/cart")
public class CartController {

    @Autowired
    private CartService cartService;

    /**
     * 获取购物车列表
     */
    @GetMapping("/list/{userId}")
    public Result<List<CartDTO>> getCartList(@PathVariable Long userId) {
        return cartService.getCartList(userId);
    }

    /**
     * 添加商品到购物车
     */
    @PostMapping("/add")
    public Result<Void> addToCart(@RequestBody Cart cart) {
        return cartService.addToCart(cart);
    }

    /**
     * 更新购物车商品数量
     */
    @PutMapping("/update")
    public Result<Void> updateCart(@RequestBody Cart cart) {
        return cartService.updateCart(cart);
    }

    /**
     * 删除购物车商品
     */
    @DeleteMapping("/delete/{id}")
    public Result<Void> deleteCart(@PathVariable Long id) {
        return cartService.deleteCart(id);
    }

    /**
     * 批量删除购物车商品
     */
    @DeleteMapping("/batch")
    public Result<Void> batchDelete(@RequestBody List<Long> ids) {
        return cartService.batchDelete(ids);
    }

    /**
     * 清空购物车
     */
    @DeleteMapping("/clear/{userId}")
    public Result<Void> clearCart(@PathVariable Long userId) {
        return cartService.clearCart(userId);
    }
}
