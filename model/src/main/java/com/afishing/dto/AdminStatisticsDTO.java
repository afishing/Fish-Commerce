package com.afishing.dto;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

/**
 * 管理员统计信息DTO
 */
@Data
public class AdminStatisticsDTO {

    /**
     * 总用户数
     */
    private Long totalUsers;

    /**
     * 今日新增用户数
     */
    private Long todayNewUsers;

    /**
     * 总订单数
     */
    private Long totalOrders;

    /**
     * 今日订单数
     */
    private Long todayOrders;

    /**
     * 今日成交金额
     */
    private BigDecimal todayAmount;

    /**
     * 总成交金额
     */
    private BigDecimal totalAmount;

    /**
     * 待发货订单数
     */
    private Long pendingShipOrders;

    /**
     * 待付款订单数
     */
    private Long pendingPayOrders;

    /**
     * 商品总数
     */
    private Long totalProducts;

    /**
     * 上架商品数
     */
    private Long onSaleProducts;

    /**
     * 最近7天订单统计
     */
    private List<DailyStatistics> recentOrders;

    /**
     * 最近7天成交金额统计
     */
    private List<DailyStatistics> recentAmount;

    /**
     * 订单状态分布
     */
    private Map<String, Long> orderStatusDistribution;

    /**
     * 日统计数据
     */
    @Data
    public static class DailyStatistics {
        private LocalDate date;
        private Long count;
        private BigDecimal amount;
    }
}
