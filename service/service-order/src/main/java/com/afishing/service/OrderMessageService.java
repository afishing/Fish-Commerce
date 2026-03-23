package com.afishing.service;

import com.afishing.common.RabbitMQConstants;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

/**
 * 订单消息服务
 * 负责发送订单相关的消息到 RabbitMQ
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class OrderMessageService {

    private final RabbitTemplate rabbitTemplate;

    /**
     * 发送订单创建消息
     * @param orderId 订单ID
     * @param userId 用户ID
     * @param amount 订单金额
     */
    public void sendOrderCreateMessage(Long orderId, Long userId, BigDecimal amount) {
        Map<String, Object> message = new HashMap<>();
        message.put("orderId", orderId);
        message.put("userId", userId);
        message.put("amount", amount);
        message.put("timestamp", System.currentTimeMillis());
        
        rabbitTemplate.convertAndSend(
                RabbitMQConstants.ORDER_EXCHANGE,
                RabbitMQConstants.ORDER_CREATE_ROUTING_KEY,
                message
        );
        log.info("发送订单创建消息: orderId={}, userId={}, amount={}", orderId, userId, amount);
    }

    /**
     * 发送订单取消消息
     * @param orderId 订单ID
     * @param reason 取消原因
     */
    public void sendOrderCancelMessage(Long orderId, String reason) {
        Map<String, Object> message = new HashMap<>();
        message.put("orderId", orderId);
        message.put("reason", reason);
        message.put("timestamp", System.currentTimeMillis());
        
        rabbitTemplate.convertAndSend(
                RabbitMQConstants.ORDER_EXCHANGE,
                RabbitMQConstants.ORDER_CANCEL_ROUTING_KEY,
                message
        );
        log.info("发送订单取消消息: orderId={}, reason={}", orderId, reason);
    }
}
