package com.afishing.controller;

import com.afishing.common.result.Result;
import org.springframework.web.bind.annotation.*;

/**
 * AI助手控制器
 */
@RestController
@RequestMapping("/ai")
public class AiController {

    /**
     * AI对话接口
     */
    @PostMapping("/chat")
    public Result<String> chat(@RequestBody String message) {
        // TODO: 实现AI对话逻辑
        return Result.success("AI助手功能待实现", "您好，我是AI助手，请问有什么可以帮助您的？");
    }
}