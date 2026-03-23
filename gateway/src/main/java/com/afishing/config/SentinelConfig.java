package com.afishing.config;

import com.alibaba.csp.sentinel.adapter.gateway.sc.callback.GatewayCallbackManager;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.web.reactive.function.server.ServerResponse;

import java.util.HashMap;
import java.util.Map;

/**
 * Sentinel 限流配置
 * 配置网关层面的限流规则和异常处理
 * 注：SentinelGatewayFilter 和 SentinelGatewayBlockExceptionHandler
 * 已由 Spring Cloud Alibaba 自动配置，此处仅配置自定义限流响应
 */
@Configuration
@RequiredArgsConstructor
public class SentinelConfig {

    private final ObjectMapper objectMapper;

    /**
     * 初始化限流异常处理
     */
    @PostConstruct
    public void init() {
        // 自定义限流响应
        GatewayCallbackManager.setBlockHandler((exchange, t) -> {
            Map<String, Object> result = new HashMap<>();
            result.put("code", HttpStatus.TOO_MANY_REQUESTS.value());
            result.put("message", "系统繁忙，请稍后再试");
            result.put("data", null);

            try {
                byte[] bytes = objectMapper.writeValueAsBytes(result);
                return ServerResponse
                        .status(HttpStatus.TOO_MANY_REQUESTS)
                        .contentType(MediaType.APPLICATION_JSON)
                        .bodyValue(new String(bytes));
            } catch (Exception e) {
                return ServerResponse
                        .status(HttpStatus.TOO_MANY_REQUESTS)
                        .contentType(MediaType.APPLICATION_JSON)
                        .bodyValue("{\"code\":429,\"message\":\"系统繁忙，请稍后再试\",\"data\":null}");
            }
        });
    }
}
