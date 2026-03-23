package com.afishing.feign;

import com.afishing.common.result.PageResult;
import com.afishing.common.result.Result;
import com.afishing.entity.Order;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 订单服务 Feign 客户端
 */
@FeignClient(name = "service-order")
public interface OrderFeignClient {

    /**
     * 获取订单列表（管理员用）
     */
    @GetMapping("/order/admin/list")
    Result<PageResult<Order>> getOrderListForAdmin(
            @RequestParam(required = false) Integer status,
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size);

    /**
     * 发货
     */
    @PutMapping("/order/ship/{orderId}")
    Result<Void> shipOrder(@PathVariable("orderId") Long orderId);

    /**
     * 获取今日订单统计
     */
    @GetMapping("/order/admin/todayStatistics")
    Result<List<Order>> getTodayOrders();

    /**
     * 获取所有订单（用于统计）
     */
    @GetMapping("/order/admin/all")
    Result<List<Order>> getAllOrders();
}
