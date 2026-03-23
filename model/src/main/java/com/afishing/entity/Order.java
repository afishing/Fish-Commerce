package com.afishing.entity;

import com.afishing.common.entity.BaseEntity;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;

/**
 * 订单实体
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("`order`")
public class Order extends BaseEntity {

    /**
     * 订单号
     */
    private String orderNo;

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
     * 运费
     */
    private BigDecimal freight;

    /**
     * 实付金额
     */
    private BigDecimal payAmount;

    /**
     * 支付方式 0-未支付 1-支付宝 2-微信 3-银行卡
     */
    private Integer payType;

    /**
     * 支付时间
     */
    private java.time.LocalDateTime payTime;

    /**
     * 订单状态 0-待付款 1-待发货 2-待收货 3-已完成 4-已取消 5-已退款
     */
    private Integer status;

    /**
     * 订单备注
     */
    private String remark;
}
