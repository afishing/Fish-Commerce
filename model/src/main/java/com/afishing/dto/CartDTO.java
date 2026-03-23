package com.afishing.dto;

import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * 购物车DTO
 */
@Data
public class CartDTO implements Serializable {

    private Long id;

    private Long productId;

    private String productName;

    private String productImage;

    private String productSpec;

    private BigDecimal price;

    private Integer quantity;

    private Boolean selected;
}
