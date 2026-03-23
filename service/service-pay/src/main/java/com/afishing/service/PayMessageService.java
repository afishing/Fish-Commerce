package com.afishing.service;

import com.afishing.common.RabbitMQConstants;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

/**
 * 支付消息服务
 * 负责发送支付相关的消息到 RabbitMQ
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class PayMessageService {

    private final RabbitTemplate rabbitTemplate;

    /**
     * 发送支付成功消息
     * @param orderId 订单ID
     * @param payId 支付记录ID
     * @param amount 支付金额
     */
    public void sendPaySuccessMessage(Long orderId, Long payId, java.math.BigDecimal amount) {
        Map<String, Object> message = new HashMap<>();
        message.put("orderId", orderId);
        message.put("payId", payId);
        message.put("amount", amount);
        message.put("timestamp", System.currentTimeMillis());
        
        rabbitTemplate.convertAndSend(
                RabbitMQConstants.PAY_EXCHANGE,
                RabbitMQConstants.PAY_SUCCESS_ROUTING_KEY,
                message
        );
        log.info("发送支付成功消息: orderId={}, payId={}, amount={}", orderId, payId, amount);
    }

    /**
     * 发送支付超时消息
     * @param orderId 订单ID
     * @param reason 超时原因
     */
    public void sendPayTimeoutMessage(Long orderId, String reason) {
        Map<String, Object> message = new HashMap<>();
        message.put("orderId", orderId);
        message.put("reason", reason);
        message.put("timestamp", System.currentTimeMillis());
        
        rabbitTemplate.convertAndSend(
                RabbitMQConstants.PAY_EXCHANGE,
                RabbitMQConstants.PAY_TIMEOUT_ROUTING_KEY,
                message
        );
        log.info("发送支付超时消息: orderId={}, reason={}", orderId, reason);
    }
}
