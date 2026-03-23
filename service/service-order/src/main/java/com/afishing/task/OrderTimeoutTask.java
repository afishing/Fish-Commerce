package com.afishing.task;

import com.afishing.entity.Order;
import com.afishing.mapper.OrderMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.Set;

@Slf4j
@Component
@EnableScheduling
@RequiredArgsConstructor
public class OrderTimeoutTask {

    private final StringRedisTemplate redisTemplate;
    private final OrderMapper orderMapper;

    private static final String ORDER_KEY_PREFIX = "order:";
    private static final long TIMEOUT_MINUTES = 2;

    /**
     * 每 10 秒检查一次超时订单
     */
    @Scheduled(fixedRate = 10000)
    public void checkTimeoutOrders() {
        Set<String> keys = redisTemplate.keys(ORDER_KEY_PREFIX + "*");
        if (keys == null || keys.isEmpty()) return;

        for (String key : keys) {
            String orderId = key.substring(ORDER_KEY_PREFIX.length());
            String value = redisTemplate.opsForValue().get(key);
            
            if (value == null) continue;
            
            // 检查是否超时
            LocalDateTime createTime = LocalDateTime.parse(value);
            long minutes = ChronoUnit.MINUTES.between(createTime, LocalDateTime.now());
            
            if (minutes >= TIMEOUT_MINUTES) {
                cancelOrder(Long.parseLong(orderId));
                redisTemplate.delete(key);
            }
        }
    }

    private void cancelOrder(Long orderId) {
        Order order = orderMapper.selectById(orderId);
        if (order != null && order.getStatus() == 0) {
            order.setStatus(4);
            orderMapper.updateById(order);
            log.info("订单 {} 超时自动取消", orderId);
        }
    }
}
