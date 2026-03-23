package com.afishing.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Data;

import java.math.BigDecimal;

/**
 * 商品添加DTO
 */
@Data
public class ProductAddDTO {

    @NotBlank(message = "商品名称不能为空")
    private String name;

    private String description;

    @NotNull(message = "分类ID不能为空")
    private Long categoryId;

    @NotNull(message = "价格不能为空")
    @Positive(message = "价格必须大于0")
    private BigDecimal price;

    private BigDecimal originalPrice;

    @NotNull(message = "库存不能为空")
    @Positive(message = "库存必须大于0")
    private Integer stock;

    private String mainImage;

    private String specs;

    private String origin;

    private String weight;

    private String shelfLife;

    private String storage;

    /**
     * 状态 0-下架 1-上架
     */
    private Integer status = 1;
}
