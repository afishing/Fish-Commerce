package com.afishing.service.impl;

import com.afishing.common.result.Result;
import com.afishing.entity.Order;
import com.afishing.entity.Payment;
import com.afishing.feign.OrderFeignClient;
import com.afishing.mapper.PaymentMapper;
import com.afishing.service.PaymentService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

/**
 * 支付服务实现
 */
@Service
public class PaymentServiceImpl implements PaymentService {

    @Autowired
    private PaymentMapper paymentMapper;

    @Autowired
    private OrderFeignClient orderFeignClient;

    @Override
    @Transactional
    public Result<Payment> createPayment(Long orderId, Integer payType) {
        // 通过Feign获取订单信息
        Result<Order> orderResult = orderFeignClient.getOrderById(orderId);
        if (orderResult == null || orderResult.getData() == null) {
            return Result.error("订单不存在");
        }
        Order order = orderResult.getData();

        // 检查是否已存在支付记录
        LambdaQueryWrapper<Payment> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Payment::getOrderId, orderId);
        Payment existPayment = paymentMapper.selectOne(wrapper);
        if (existPayment != null) {
            // 更新支付方式
            existPayment.setPayType(payType);
            paymentMapper.updateById(existPayment);
            return Result.success(existPayment);
        }

        // 创建支付记录
        Payment payment = new Payment();
        payment.setOrderId(orderId);
        payment.setOrderNo(order.getOrderNo());
        payment.setUserId(order.getUserId());
        payment.setPayAmount(order.getPayAmount());
        payment.setPayType(payType);
        payment.setStatus(0); // 待支付

        paymentMapper.insert(payment);

        return Result.success(payment);
    }

    @Override
    @Transactional
    public Result<Void> confirmPayment(Long orderId) {
        // 查询支付记录
        LambdaQueryWrapper<Payment> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Payment::getOrderId, orderId);
        Payment payment = paymentMapper.selectOne(wrapper);

        if (payment == null) {
            return Result.error("支付记录不存在");
        }

        // 更新支付记录状态
        payment.setStatus(1); // 支付成功
        payment.setPayTime(LocalDateTime.now());
        // 生成交易流水号
        String transactionNo = "PAY" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmssSSS")) 
                + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        payment.setTransactionNo(transactionNo);
        paymentMapper.updateById(payment);

        // 通过Feign更新订单状态
        orderFeignClient.updatePayStatus(orderId, 2, payment.getPayType());

        return Result.success("支付成功", null);
    }

    @Override
    @Transactional
    public Result<Void> cancelPayment(Long orderId) {
        // 查询支付记录
        LambdaQueryWrapper<Payment> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Payment::getOrderId, orderId);
        Payment payment = paymentMapper.selectOne(wrapper);

        if (payment != null) {
            payment.setStatus(2); // 支付失败/取消
            paymentMapper.updateById(payment);
        }

        return Result.success("支付已取消", null);
    }

    @Override
    public Result<Payment> getByOrderId(Long orderId) {
        LambdaQueryWrapper<Payment> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Payment::getOrderId, orderId);
        Payment payment = paymentMapper.selectOne(wrapper);

        if (payment == null) {
            return Result.error("支付记录不存在");
        }

        return Result.success(payment);
    }
}
