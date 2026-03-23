package com.afishing.feign;

import com.afishing.common.result.PageResult;
import com.afishing.common.result.Result;
import com.afishing.entity.Product;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 商品服务 Feign 客户端
 */
@FeignClient(name = "service-product")
public interface ProductFeignClient {

    /**
     * 获取商品列表（管理员用）
     */
    @GetMapping("/product/admin/list")
    Result<PageResult<Product>> getProductListForAdmin(
            @RequestParam(required = false) Integer status,
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size);

    /**
     * 添加商品
     */
    @PostMapping("/product/add")
    Result<Void> addProduct(@RequestBody Product product);

    /**
     * 更新商品
     */
    @PutMapping("/product/update")
    Result<Void> updateProduct(@RequestBody Product product);

    /**
     * 更新商品状态
     */
    @PutMapping("/product/admin/status/{productId}")
    Result<Void> updateProductStatus(
            @PathVariable("productId") Long productId,
            @RequestParam("status") Integer status);

    /**
     * 删除商品
     */
    @DeleteMapping("/product/delete/{productId}")
    Result<Void> deleteProduct(@PathVariable("productId") Long productId);

    /**
     * 获取所有商品（用于统计）
     */
    @GetMapping("/product/admin/all")
    Result<List<Product>> getAllProducts();
}
