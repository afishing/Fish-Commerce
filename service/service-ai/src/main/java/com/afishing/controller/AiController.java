package com.afishing.controller;

import com.afishing.common.result.Result;
import com.afishing.service.AiService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.io.IOException;
import java.util.List;
import java.util.Map;

/**
 * AI 助手控制器
 */
@Slf4j
@RestController
@RequestMapping("/ai")
@RequiredArgsConstructor
public class AiController {

    private final AiService aiService;

    /**
     * 普通对话（支持多轮上下文）
     * 请求体：{ "message": "当前消息", "history": [{"role":"user","content":"..."}, ...] }
     */
    @PostMapping("/chat")
    public Result<String> chat(@RequestBody Map<String, Object> body) {
        String message = (String) body.get("message");
        if (message == null || message.isBlank()) {
            return Result.error("消息不能为空");
        }
        try {
            @SuppressWarnings("unchecked")
            List<Map<String, String>> history = (List<Map<String, String>>) body.get("history");
            String response = aiService.chat(history, message);
            return Result.success(response);
        } catch (Exception e) {
            log.error("AI 对话异常", e);
            return Result.error("AI 服务异常：" + e.getMessage());
        }
    }

    /**
     * 流式对话（SSE，支持多轮上下文）
     * 使用 SseEmitter 代替 Flux，适配 Spring MVC (Tomcat) 环境
     */
    @PostMapping(value = "/stream", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public SseEmitter stream(@RequestBody Map<String, Object> body) {
        SseEmitter emitter = new SseEmitter(120_000L);

        String message = (String) body.get("message");
        if (message == null || message.isBlank()) {
            try {
                emitter.send(SseEmitter.event().data("消息不能为空"));
            } catch (IOException ignored) {}
            emitter.complete();
            return emitter;
        }

        @SuppressWarnings("unchecked")
        List<Map<String, String>> history = (List<Map<String, String>>) body.get("history");

        aiService.stream(history, message)
                .doOnNext(token -> {
                    try {
                        emitter.send(SseEmitter.event().data(token));
                    } catch (IOException e) {
                        log.warn("SSE 发送失败", e);
                        emitter.completeWithError(e);
                    }
                })
                .doOnComplete(emitter::complete)
                .doOnError(e -> {
                    log.error("AI 流式对话异常", e);
                    try {
                        emitter.send(SseEmitter.event().name("error").data(e.getMessage()));
                    } catch (IOException ignored) {}
                    emitter.complete();
                })
                .subscribe();

        return emitter;
    }
}
