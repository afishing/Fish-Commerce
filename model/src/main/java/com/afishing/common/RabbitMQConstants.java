package com.afishing.common;

/**
 * RabbitMQ 常量定义
 * 用于订单和支付服务之间的消息传递
 */
public class RabbitMQConstants {

    // ========== 交换机 ==========
    /** 订单相关交换机 */
    public static final String ORDER_EXCHANGE = "order.exchange";
    
    /** 支付相关交换机 */
    public static final String PAY_EXCHANGE = "pay.exchange";
    
    /** 死信交换机 */
    public static final String DEAD_LETTER_EXCHANGE = "dead.letter.exchange";

    // ========== 队列 ==========
    /** 订单创建队列 */
    public static final String ORDER_CREATE_QUEUE = "order.create.queue";
    
    /** 订单取消队列 */
    public static final String ORDER_CANCEL_QUEUE = "order.cancel.queue";
    
    /** 支付成功队列 */
    public static final String PAY_SUCCESS_QUEUE = "pay.success.queue";
    
    /** 支付超时队列 */
    public static final String PAY_TIMEOUT_QUEUE = "pay.timeout.queue";
    
    /** 死信队列 */
    public static final String DEAD_LETTER_QUEUE = "dead.letter.queue";

    // ========== 路由键 ==========
    /** 订单创建路由键 */
    public static final String ORDER_CREATE_ROUTING_KEY = "order.create";
    
    /** 订单取消路由键 */
    public static final String ORDER_CANCEL_ROUTING_KEY = "order.cancel";
    
    /** 支付成功路由键 */
    public static final String PAY_SUCCESS_ROUTING_KEY = "pay.success";
    
    /** 支付超时路由键 */
    public static final String PAY_TIMEOUT_ROUTING_KEY = "pay.timeout";
    
    /** 死信路由键 */
    public static final String DEAD_LETTER_ROUTING_KEY = "dead.letter";

    private RabbitMQConstants() {
        // 私有构造方法，防止实例化
    }
}
