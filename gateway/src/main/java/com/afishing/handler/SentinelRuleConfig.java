package com.afishing.handler;

import com.alibaba.csp.sentinel.slots.block.RuleConstant;
import com.alibaba.csp.sentinel.slots.block.flow.FlowRule;
import com.alibaba.csp.sentinel.slots.block.flow.FlowRuleManager;
import jakarta.annotation.PostConstruct;
import org.springframework.context.annotation.Configuration;

import java.util.ArrayList;
import java.util.List;

/**
 * Sentinel 限流规则配置
 * 定义各服务的限流策略
 */
@Configuration
public class SentinelRuleConfig {

    @PostConstruct
    public void initRules() {
        List<FlowRule> rules = new ArrayList<>();

        // 订单服务限流：每秒最多 200 个请求（防止超卖，不宜过高）
        FlowRule orderRule = new FlowRule();
        orderRule.setResource("service-order");
        orderRule.setGrade(RuleConstant.FLOW_GRADE_QPS);
        orderRule.setCount(200);
        rules.add(orderRule);

        // 商品服务限流：每秒最多 1000 个请求（商品查询高频，阈值放宽）
        FlowRule productRule = new FlowRule();
        productRule.setResource("service-product");
        productRule.setGrade(RuleConstant.FLOW_GRADE_QPS);
        productRule.setCount(1000);
        rules.add(productRule);

        // 支付服务限流：每秒最多 200 个请求
        FlowRule payRule = new FlowRule();
        payRule.setResource("service-pay");
        payRule.setGrade(RuleConstant.FLOW_GRADE_QPS);
        payRule.setCount(200);
        rules.add(payRule);

        // 用户服务限流：每秒最多 500 个请求
        FlowRule userRule = new FlowRule();
        userRule.setResource("service-user");
        userRule.setGrade(RuleConstant.FLOW_GRADE_QPS);
        userRule.setCount(500);
        rules.add(userRule);

        FlowRuleManager.loadRules(rules);
    }
}
