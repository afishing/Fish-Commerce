package com.afishing.feign;

import com.afishing.common.result.Result;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;

/**
 * 商品服务 Feign 客户端
 */
@FeignClient(name = "service-product")
public interface ProductFeignClient {

    /**
     * 更新商品销量
     */
    @PutMapping("/product/sales/{productId}")
    Result<Void> updateSales(
            @PathVariable("productId") Long productId,
            @RequestParam("quantity") Integer quantity);

    /**
     * 更新商品库存
     */
    @PutMapping("/product/stock/{productId}")
    Result<Void> updateStock(
            @PathVariable("productId") Long productId,
            @RequestParam("quantity") Integer quantity);
}