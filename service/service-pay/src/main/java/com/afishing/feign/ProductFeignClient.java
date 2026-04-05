package com.afishing.feign;

import com.afishing.common.result.Result;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;

/**
 * 商品服务Feign客户端
 */
@FeignClient("service-product")
public interface ProductFeignClient {

    /**
     * 更新商品销量
     */
    @PutMapping("/product/sales/{id}")
    Result<Void> updateSales(
            @PathVariable("id") Long productId,
            @RequestParam Integer quantity);
}
