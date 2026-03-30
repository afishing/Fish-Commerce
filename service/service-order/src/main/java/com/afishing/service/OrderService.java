package com.afishing.service;

import com.afishing.common.result.Result;
import com.afishing.dto.CreateOrderDTO;
import com.afishing.dto.OrderDTO;
import com.afishing.entity.Order;
import com.afishing.entity.OrderItem;

import java.util.List;

/**
 * 订单服务接口
 */
public interface OrderService {

    Result<List<OrderDTO>> getOrderList(Long userId, Integer status);

    Result<OrderDTO> getOrderDetail(Long id);

    Result<Order> createOrder(Order order);

    Result<Order> createOrderFromDTO(CreateOrderDTO dto);

    Result<Void> payOrder(Long id);

    Result<Void> cancelOrder(Long id);

    Result<Void> confirmOrder(Long id);

    Result<Void> deleteOrder(Long id);

    /**
     * 更新订单支付状态（供Feign调用）
     */
    Result<Void> updatePayStatus(Long id, Integer status, Integer payType);

    /**
     * 获取订单列表（管理员用）
     */
    Result<com.afishing.common.result.PageResult<Order>> getOrderListForAdmin(Integer status, Integer page, Integer size);

    /**
     * 发货
     */
    Result<Void> shipOrder(Long orderId);

    /**
     * 获取所有订单（用于统计）
     */
    Result<List<Order>> getAllOrders();

    /**
     * 获取订单项列表
     */
    Result<List<OrderItem>> getOrderItems(Long orderId);
}
