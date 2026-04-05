package com.afishing.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

/**
 * 商品标签关联实体（多对多关系）
 */
@Data
@TableName("product_tag")
public class ProductTag {

    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 商品 ID
     */
    private Long productId;

    /**
     * 标签 ID
     */
    private Long tagId;
}