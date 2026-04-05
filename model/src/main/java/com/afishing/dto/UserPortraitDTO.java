package com.afishing.dto;

import lombok.Data;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * 用户画像DTO
 */
@Data
public class UserPortraitDTO {

    /**
     * 用户总数
     */
    private Long totalUsers;

    /**
     * 活跃用户数
     */
    private Long activeUsers;

    /**
     * 禁用用户数
     */
    private Long disabledUsers;

    /**
     * 男性用户数
     */
    private Long maleCount;

    /**
     * 女性用户数
     */
    private Long femaleCount;

    /**
     * 保密用户数
     */
    private Long secretCount;

    /**
     * 人均订单数
     */
    private BigDecimal avgOrdersPerUser;

    /**
     * 人均消费金额
     */
    private BigDecimal avgSpendPerUser;

    /**
     * 消费层次分布
     */
    private Map<String, Long> consumeLevelDist;

    /**
     * 注册趋势
     */
    private List<RegisterTrendItem> registerTrend;

    /**
     * 消费排行榜
     */
    private List<TopConsumerItem> topConsumers;

    /**
     * 注册趋势项
     */
    @Data
    public static class RegisterTrendItem {
        private String date;
        private Long count;
    }

    /**
     * 消费排行项
     */
    @Data
    public static class TopConsumerItem {
        private Long userId;
        private String username;
        private String nickname;
        private BigDecimal totalSpend;
        private Long orderCount;
    }
}
