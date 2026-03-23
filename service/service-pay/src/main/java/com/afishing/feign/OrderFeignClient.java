package com.afishing.feign;

import com.afishing.common.result.Result;
import com.afishing.entity.Order;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;

/**
 * 订单服务Feign客户端
 */
@FeignClient("service-order")
public interface OrderFeignClient {

    /**
     * 根据ID获取订单
     */
    @GetMapping("/order/get/{id}")
    Result<Order> getOrderById(@PathVariable("id") Long id);

    /**
     * 更新订单支付状态
     */
    @PutMapping("/order/payStatus/{id}")
    Result<Void> updatePayStatus(
            @PathVariable("id") Long id,
            @RequestParam Integer status,
            @RequestParam Integer payType);
}
