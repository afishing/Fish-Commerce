package com.afishing.config;

import com.afishing.common.RabbitMQConstants;
import org.springframework.amqp.core.*;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * RabbitMQ 配置类 - Order 服务
 * 定义交换机和绑定关系
 */
@Configuration
public class RabbitMQConfig {

    // ========== 交换机定义 ==========
    
    @Bean
    public DirectExchange orderExchange() {
        return new DirectExchange(RabbitMQConstants.ORDER_EXCHANGE, true, false);
    }
    
    @Bean
    public DirectExchange payExchange() {
        return new DirectExchange(RabbitMQConstants.PAY_EXCHANGE, true, false);
    }
    
    @Bean
    public DirectExchange deadLetterExchange() {
        return new DirectExchange(RabbitMQConstants.DEAD_LETTER_EXCHANGE, true, false);
    }
}
