package com.afishing.entity;

import com.afishing.common.entity.BaseEntity;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;

/**
 * 商品实体
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("product")
public class Product extends BaseEntity {

    /**
     * 商品名称
     */
    private String name;

    /**
     * 商品描述
     */
    private String description;

    /**
     * 分类ID
     */
    private Long categoryId;

    /**
     * 价格
     */
    private BigDecimal price;

    /**
     * 原价
     */
    private BigDecimal originalPrice;

    /**
     * 库存
     */
    private Integer stock;

    /**
     * 销量
     */
    private Integer sales;

    /**
     * 主图
     */
    private String mainImage;

    /**
     * 规格信息JSON
     */
    private String specs;

    /**
     * 产地
     */
    private String origin;

    /**
     * 重量
     */
    private String weight;

    /**
     * 保质期
     */
    private String shelfLife;

    /**
     * 储存方式
     */
    private String storage;

    /**
     * 状态 0-下架 1-上架
     */
    private Integer status;

    /**
     * 商品详情（Markdown格式）
     */
    private String detail;

    /**
     * 是否为轮播图商品 0-否 1-是
     */
    @TableField("is_banner")
    private Integer isBanner;

    /**
     * 轮播图排序（数字越小越靠前）
     */
    @TableField("banner_sort")
    private Integer bannerSort;
}
