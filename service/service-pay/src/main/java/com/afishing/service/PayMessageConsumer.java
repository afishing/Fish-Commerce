package com.afishing.service;

import com.afishing.common.RabbitMQConstants;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.Map;

/**
 * 支付消息消费者
 * 监听并处理订单服务发送的消息
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class PayMessageConsumer {

    /**
     * 监听订单创建消息
     * 创建待支付记录
     */
    @RabbitListener(queuesToDeclare = @org.springframework.amqp.rabbit.annotation.Queue(
            name = "order.create.queue",
            durable = "true"
    ))
    public void handleOrderCreateMessage(Map<String, Object> message) {
        Long orderId = Long.valueOf(message.get("orderId").toString());
        Long userId = Long.valueOf(message.get("userId").toString());
        BigDecimal amount = new BigDecimal(message.get("amount").toString());
        
        log.info("收到订单创建消息: orderId={}, userId={}, amount={}", orderId, userId, amount);
        
        // TODO: 创建待支付记录
        // payService.createPendingPay(orderId, userId, amount);
    }

    /**
     * 监听订单取消消息
     * 关闭相关支付记录
     */
    @RabbitListener(queuesToDeclare = @org.springframework.amqp.rabbit.annotation.Queue(
            name = "order.cancel.queue",
            durable = "true"
    ))
    public void handleOrderCancelMessage(Map<String, Object> message) {
        Long orderId = Long.valueOf(message.get("orderId").toString());
        String reason = message.get("reason").toString();
        
        log.info("收到订单取消消息: orderId={}, reason={}", orderId, reason);
        
        // TODO: 关闭该订单的待支付记录
        // payService.closePendingPay(orderId);
    }

    /**
     * 监听死信队列消息
     * 处理处理失败或超时的消息
     */
    @RabbitListener(queuesToDeclare = @org.springframework.amqp.rabbit.annotation.Queue(
            name = "dead.letter.queue",
            durable = "true"
    ))
    public void handleDeadLetterMessage(Map<String, Object> message) {
        log.error("收到死信消息: {}", message);
        
        // TODO: 记录死信消息，进行人工处理或补偿
    }
}
