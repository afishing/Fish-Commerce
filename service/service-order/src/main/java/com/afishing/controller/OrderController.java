package com.afishing.controller;

import com.afishing.common.result.PageResult;
import com.afishing.common.result.Result;
import com.afishing.dto.CreateOrderDTO;
import com.afishing.dto.OrderDTO;
import com.afishing.entity.Order;
import com.afishing.entity.OrderItem;
import com.afishing.mapper.OrderMapper;
import com.afishing.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 订单控制器
 */
@RestController
@RequestMapping("/order")
public class OrderController {

    @Autowired
    private OrderService orderService;

    @Autowired
    private OrderMapper orderMapper;

    /**
     * 获取订单列表
     */
    @GetMapping("/list/{userId}")
    public Result<List<OrderDTO>> getOrderList(
            @PathVariable Long userId,
            @RequestParam(required = false) Integer status) {
        return orderService.getOrderList(userId, status);
    }

    /**
     * 获取订单详情
     */
    @GetMapping("/detail/{id}")
    public Result<OrderDTO> getOrderDetail(@PathVariable Long id) {
        return orderService.getOrderDetail(id);
    }

    /**
     * 创建订单（简单版）
     */
    @PostMapping("/create")
    public Result<Order> createOrder(@RequestBody Order order) {
        return orderService.createOrder(order);
    }

    /**
     * 创建订单（带订单项）
     */
    @PostMapping("/createWithItems")
    public Result<Order> createOrderWithItems(@RequestBody CreateOrderDTO dto) {
        return orderService.createOrderFromDTO(dto);
    }

    /**
     * 支付订单
     */
    @PutMapping("/pay/{id}")
    public Result<Void> payOrder(@PathVariable Long id) {
        return orderService.payOrder(id);
    }

    /**
     * 取消订单
     */
    @PutMapping("/cancel/{id}")
    public Result<Void> cancelOrder(@PathVariable Long id) {
        return orderService.cancelOrder(id);
    }

    /**
     * 确认收货
     */
    @PutMapping("/confirm/{id}")
    public Result<Void> confirmOrder(@PathVariable Long id) {
        return orderService.confirmOrder(id);
    }

    /**
     * 删除订单
     */
    @DeleteMapping("/delete/{id}")
    public Result<Void> deleteOrder(@PathVariable Long id) {
        return orderService.deleteOrder(id);
    }

    /**
     * 根据ID获取订单（供Feign调用）
     */
    @GetMapping("/get/{id}")
    public Result<Order> getOrderById(@PathVariable Long id) {
        Order order = orderMapper.selectById(id);
        if (order == null) {
            return Result.error("订单不存在");
        }
        return Result.success(order);
    }

    /**
     * 更新订单支付状态（供Feign调用）
     */
    @PutMapping("/payStatus/{id}")
    public Result<Void> updatePayStatus(
            @PathVariable Long id,
            @RequestParam Integer status,
            @RequestParam Integer payType) {
        return orderService.updatePayStatus(id, status, payType);
    }

    /**
     * 获取订单项列表（供Feign调用）
     */
    @GetMapping("/items/{orderId}")
    public Result<List<OrderItem>> getOrderItems(@PathVariable Long orderId) {
        return orderService.getOrderItems(orderId);
    }

    // ========== 管理员接口 ==========

    /**
     * 获取订单列表（管理员用）
     */
    @GetMapping("/admin/list")
    public Result<PageResult<Order>> getOrderListForAdmin(
            @RequestParam(required = false) Integer status,
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size) {
        return orderService.getOrderListForAdmin(status, page, size);
    }

    /**
     * 发货
     */
    @PutMapping("/ship/{orderId}")
    public Result<Void> shipOrder(@PathVariable Long orderId) {
        return orderService.shipOrder(orderId);
    }

    /**
     * 获取所有订单（用于统计）
     */
    @GetMapping("/admin/all")
    public Result<List<Order>> getAllOrders() {
        return orderService.getAllOrders();
    }
}
