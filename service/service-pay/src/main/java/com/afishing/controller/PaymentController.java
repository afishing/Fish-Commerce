package com.afishing.controller;

import com.afishing.common.result.Result;
import com.afishing.entity.Payment;
import com.afishing.service.PaymentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * 支付控制器
 */
@RestController
@RequestMapping("/payment")
public class PaymentController {

    @Autowired
    private PaymentService paymentService;

    /**
     * 创建支付记录（选择支付方式后调用）
     */
    @PostMapping("/create/{orderId}")
    public Result<Payment> createPayment(
            @PathVariable Long orderId,
            @RequestParam Integer payType) {
        return paymentService.createPayment(orderId, payType);
    }

    /**
     * 确认支付（用户点击"我已付款"后调用）
     */
    @PutMapping("/confirm/{orderId}")
    public Result<Void> confirmPayment(@PathVariable Long orderId) {
        return paymentService.confirmPayment(orderId);
    }

    /**
     * 取消支付
     */
    @PutMapping("/cancel/{orderId}")
    public Result<Void> cancelPayment(@PathVariable Long orderId) {
        return paymentService.cancelPayment(orderId);
    }

    /**
     * 查询支付记录
     */
    @GetMapping("/order/{orderId}")
    public Result<Payment> getByOrderId(@PathVariable Long orderId) {
        return paymentService.getByOrderId(orderId);
    }
}
