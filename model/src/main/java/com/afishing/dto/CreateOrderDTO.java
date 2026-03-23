package com.afishing.dto;

import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;

/**
 * 创建订单DTO
 */
@Data
public class CreateOrderDTO implements Serializable {

    /**
     * 用户ID
     */
    private Long userId;

    /**
     * 收货人姓名
     */
    private String receiverName;

    /**
     * 收货人电话
     */
    private String receiverPhone;

    /**
     * 收货地址
     */
    private String receiverAddress;

    /**
     * 商品总金额
     */
    private BigDecimal totalAmount;

    /**
     * 实付金额
     */
    private BigDecimal payAmount;

    /**
     * 订单备注
     */
    private String remark;

    /**
     * 购物车项ID列表（用于结算后删除购物车）
     */
    private List<Long> cartItemIds;

    /**
     * 订单项列表
     */
    private List<OrderItemDTO> items;
}
