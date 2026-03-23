package com.afishing.service;

import com.afishing.common.RabbitMQConstants;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.core.Queue;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.stereotype.Service;

import java.util.Map;

/**
 * 订单消息消费者
 * 监听并处理支付服务发送的消息
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class OrderMessageConsumer {

    /**
     * 监听支付成功消息
     * 更新订单状态为已支付
     */
    @RabbitListener(queuesToDeclare = @org.springframework.amqp.rabbit.annotation.Queue(
            name = "pay.success.queue",
            durable = "true"
    ))
    public void handlePaySuccessMessage(Map<String, Object> message) {
        Long orderId = Long.valueOf(message.get("orderId").toString());
        String payId = message.get("payId").toString();
        
        log.info("收到支付成功消息: orderId={}, payId={}", orderId, payId);
        
        // TODO: 更新订单状态为已支付
        // orderService.updateOrderStatus(orderId, OrderStatus.PAID);
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
