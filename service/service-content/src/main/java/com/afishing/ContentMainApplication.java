package com.afishing;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.openfeign.EnableFeignClients;

/**
 * 内容服务启动类
 */
@SpringBootApplication(scanBasePackages = "com.afishing")
@EnableFeignClients
public class ContentMainApplication {

    public static void main(String[] args) {
        SpringApplication.run(ContentMainApplication.class, args);
    }
}
