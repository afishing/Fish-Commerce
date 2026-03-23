package com.afishing.dto;

import lombok.Data;

import java.io.Serializable;
import java.util.List;

/**
 * 订单DTO
 */
@Data
public class OrderDTO implements Serializable {

    private Long id;

    private String orderNo;

    private Long userId;

    private String receiverName;

    private String receiverPhone;

    private String receiverAddress;

    private java.math.BigDecimal totalAmount;

    private java.math.BigDecimal payAmount;

    private Integer status;

    private List<OrderItemDTO> items;
}
