package com.afishing.dto;

import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * 订单项DTO
 */
@Data
public class OrderItemDTO implements Serializable {

    private Long id;

    private Long productId;

    private String productName;

    private String productImage;

    private String productSpec;

    private BigDecimal price;

    private Integer quantity;

    private BigDecimal totalAmount;
}
