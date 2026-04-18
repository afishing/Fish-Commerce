package com.afishing.service;

import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.messages.AssistantMessage;
import org.springframework.ai.chat.messages.Message;
import org.springframework.ai.chat.messages.UserMessage;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * AI 对话服务
 */
@Service
public class AiService {

    private final ChatClient chatClient;

    private static final String SYSTEM_PROMPT = """
            你是飞鱼商城的 AI 购物助手小飞，专注于各类产品的推荐与咨询。
            你的职责：
            1. 友好、专业地回答用户关于各类产品的问题
            2. 根据用户需求和预算推荐合适的商品
            3. 提供各类产品的使用和售后建议
            4. 解答订单、物流、退换货等售后问题
            5. 介绍商城的促销活动和优惠信息
            请始终使用中文回复，语气亲切自然，回答简洁清晰。
            如果用户询问与钓鱼无关的话题，请礼貌引导回到购物助手的职责范围。
            """;

    public AiService(ChatClient.Builder builder) {
        this.chatClient = builder
                .defaultSystem(SYSTEM_PROMPT)
                .build();
    }

    /**
     * 普通对话（支持多轮上下文）
     *
     * @param history 历史消息列表，格式：[{"role":"user","content":"..."}, {"role":"assistant","content":"..."}]
     * @param message 当前用户消息
     * @return AI 回复内容
     */
    public String chat(List<Map<String, String>> history, String message) {
        List<Message> messages = buildMessages(history, message);
        return chatClient.prompt()
                .messages(messages)
                .call()
                .content();
    }

    /**
     * 流式对话（SSE，支持多轮上下文）
     *
     * @param history 历史消息列表
     * @param message 当前用户消息
     * @return Token 流
     */
    public Flux<String> stream(List<Map<String, String>> history, String message) {
        List<Message> messages = buildMessages(history, message);
        return chatClient.prompt()
                .messages(messages)
                .stream()
                .content();
    }

    /**
     * 将前端传入的历史消息转为 Spring AI Message 列表
     */
    private List<Message> buildMessages(List<Map<String, String>> history, String currentMessage) {
        List<Message> messages = new ArrayList<>();
        if (history != null) {
            for (Map<String, String> msg : history) {
                String role = msg.get("role");
                String content = msg.get("content");
                if ("user".equals(role)) {
                    messages.add(new UserMessage(content));
                } else if ("assistant".equals(role)) {
                    messages.add(new AssistantMessage(content));
                }
            }
        }
        messages.add(new UserMessage(currentMessage));
        return messages;
    }
}
