package com.afishing;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;
import org.springframework.cloud.openfeign.EnableFeignClients;

/**
 * AI服务启动类
 */
@SpringBootApplication(scanBasePackages = "com.afishing", exclude = {DataSourceAutoConfiguration.class})
@EnableFeignClients
public class AiMainApplication {

    public static void main(String[] args) {
        SpringApplication.run(AiMainApplication.class, args);
    }
}
