package com.afishing.service;

import com.afishing.common.result.Result;
import com.afishing.entity.Payment;

/**
 * 支付服务接口
 */
public interface PaymentService {

    /**
     * 创建支付记录
     */
    Result<Payment> createPayment(Long orderId, Integer payType);

    /**
     * 确认支付
     */
    Result<Void> confirmPayment(Long orderId);

    /**
     * 取消支付
     */
    Result<Void> cancelPayment(Long orderId);

    /**
     * 根据订单ID查询支付记录
     */
    Result<Payment> getByOrderId(Long orderId);
}
