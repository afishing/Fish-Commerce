package com.afishing.service;

import com.afishing.common.result.Result;
import com.afishing.dto.CartDTO;
import com.afishing.entity.Cart;

import java.util.List;

/**
 * 购物车服务接口
 */
public interface CartService {

    Result<List<CartDTO>> getCartList(Long userId);

    Result<Void> addToCart(Cart cart);

    Result<Void> updateCart(Cart cart);

    Result<Void> deleteCart(Long id);

    Result<Void> batchDelete(List<Long> ids);

    Result<Void> clearCart(Long userId);
}
