package com.afishing.service.impl;

import com.afishing.common.result.Result;
import com.afishing.dto.CartDTO;
import com.afishing.entity.Cart;
import com.afishing.mapper.CartMapper;
import com.afishing.service.CartService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

/**
 * 购物车服务实现
 */
@Service
public class CartServiceImpl implements CartService {

    @Autowired
    private CartMapper cartMapper;

    @Override
    public Result<List<CartDTO>> getCartList(Long userId) {
        LambdaQueryWrapper<Cart> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Cart::getUserId, userId)
                .orderByDesc(Cart::getCreateTime);
        
        List<Cart> carts = cartMapper.selectList(wrapper);
        
        List<CartDTO> cartDTOs = new ArrayList<>();
        for (Cart cart : carts) {
            CartDTO dto = new CartDTO();
            dto.setId(cart.getId());
            dto.setProductId(cart.getProductId());
            dto.setProductName(cart.getProductName());
            dto.setProductImage(cart.getProductImage());
            dto.setProductSpec(cart.getProductSpec());
            dto.setPrice(cart.getPrice());
            dto.setQuantity(cart.getQuantity());
            dto.setSelected(cart.getSelected() == 1);
            cartDTOs.add(dto);
        }
        
        return Result.success(cartDTOs);
    }

    @Override
    public Result<Void> addToCart(Cart cart) {
        // 检查购物车中是否已存在该商品
        LambdaQueryWrapper<Cart> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Cart::getUserId, cart.getUserId())
                .eq(Cart::getProductId, cart.getProductId())
                .eq(Cart::getProductSpec, cart.getProductSpec());
        
        Cart existCart = cartMapper.selectOne(wrapper);
        
        if (existCart != null) {
            // 已存在，增加数量
            existCart.setQuantity(existCart.getQuantity() + cart.getQuantity());
            cartMapper.updateById(existCart);
        } else {
            // 不存在，新增
            cart.setSelected(1);
            cartMapper.insert(cart);
        }
        
        return Result.success("添加成功", null);
    }

    @Override
    public Result<Void> updateCart(Cart cart) {
        Cart existCart = cartMapper.selectById(cart.getId());
        if (existCart == null) {
            return Result.error("购物车商品不存在");
        }
        
        existCart.setQuantity(cart.getQuantity());
        existCart.setSelected(cart.getSelected());
        cartMapper.updateById(existCart);
        
        return Result.success("更新成功", null);
    }

    @Override
    public Result<Void> deleteCart(Long id) {
        cartMapper.deleteById(id);
        return Result.success("删除成功", null);
    }

    @Override
    public Result<Void> batchDelete(List<Long> ids) {
        cartMapper.deleteBatchIds(ids);
        return Result.success("批量删除成功", null);
    }

    @Override
    public Result<Void> clearCart(Long userId) {
        LambdaQueryWrapper<Cart> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Cart::getUserId, userId);
        cartMapper.delete(wrapper);
        return Result.success("清空成功", null);
    }
}
