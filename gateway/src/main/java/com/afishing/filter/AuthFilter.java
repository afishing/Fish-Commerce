package com.afishing.filter;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cloud.gateway.filter.GatewayFilterChain;
import org.springframework.cloud.gateway.filter.GlobalFilter;
import org.springframework.core.Ordered;
import org.springframework.core.io.buffer.DataBuffer;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.http.server.reactive.ServerHttpResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

import java.nio.charset.StandardCharsets;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 认证过滤器
 * 处理 Token 验证、白名单路径放行
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class AuthFilter implements GlobalFilter, Ordered {

    private final ObjectMapper objectMapper;

    /**
     * 白名单路径（不需要登录即可访问）
     */
    private static final List<String> WHITE_LIST = Arrays.asList(
            // 用户相关
            "/user/login",
            "/user/register",
            "/user/check-username",
            "/user/check-email",
            // 商品相关
            "/product/list",
            "/product/detail",
            "/product/category",
            "/product/banner",
            // 公告相关
            "/notice/enabled",
            // 分类相关
            "/category/list",
            // 标签相关
            "/tag/list",
            // 静态资源
            "/uploads/",
            // 支付回调
            "/pay/callback"
    );

    @Override
    public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
        ServerHttpRequest request = exchange.getRequest();
        String path = request.getPath().value();

        // 白名单路径直接放行
        if (isWhitePath(path)) {
            return chain.filter(exchange);
        }

        // 获取 Token
        String token = request.getHeaders().getFirst(HttpHeaders.AUTHORIZATION);

        // Token 为空，返回未授权
        if (token == null || token.isEmpty()) {
            return unauthorized(exchange, "未登录，请先登录");
        }

        // TODO: 这里可以添加 Token 验证逻辑
        // 1. 验证 Token 是否有效
        // 2. 解析用户信息
        // 3. 将用户信息传递给下游服务

        // 暂时直接放行（后续可接入 Redis 验证 Token）
        return chain.filter(exchange);
    }

    /**
     * 判断是否为白名单路径
     */
    private boolean isWhitePath(String path) {
        // 移除 /api 前缀后判断
        String actualPath = path.startsWith("/api/") ? path.substring(4) : path;
        return WHITE_LIST.stream().anyMatch(actualPath::startsWith);
    }

    /**
     * 返回未授权响应
     */
    private Mono<Void> unauthorized(ServerWebExchange exchange, String message) {
        ServerHttpResponse response = exchange.getResponse();
        response.setStatusCode(HttpStatus.UNAUTHORIZED);
        response.getHeaders().setContentType(MediaType.APPLICATION_JSON);

        Map<String, Object> result = new HashMap<>();
        result.put("code", HttpStatus.UNAUTHORIZED.value());
        result.put("message", message);
        result.put("data", null);

        try {
            byte[] bytes = objectMapper.writeValueAsBytes(result);
            DataBuffer buffer = response.bufferFactory().wrap(bytes);
            return response.writeWith(Mono.just(buffer));
        } catch (JsonProcessingException e) {
            log.error("JSON序列化异常", e);
            String errorJson = "{\"code\":401,\"message\":\"未授权\",\"data\":null}";
            DataBuffer buffer = response.bufferFactory().wrap(errorJson.getBytes(StandardCharsets.UTF_8));
            return response.writeWith(Mono.just(buffer));
        }
    }

    @Override
    public int getOrder() {
        return Ordered.HIGHEST_PRECEDENCE + 10;
    }
}
