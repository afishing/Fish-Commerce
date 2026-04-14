package com.afishing.controller;

import com.afishing.common.result.PageResult;
import com.afishing.common.result.Result;
import com.afishing.entity.Product;
import com.afishing.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 商品控制器
 */
@RestController
@RequestMapping("/product")
public class ProductController {

    @Autowired
    private ProductService productService;

    /**
     * 获取商品列表（分页，支持排序）
     */
    @GetMapping("/list")
    public Result<PageResult<Product>> getProductList(
            @RequestParam(required = false) Long categoryId,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String sortBy,
            @RequestParam(required = false) Long tagId,
            @RequestParam(required = false) String tagIds,
            @RequestParam(required = false, defaultValue = "1") Integer page,
            @RequestParam(required = false, defaultValue = "12") Integer size) {
        // 支持多标签筛选（逗号分隔）
        List<Long> tagIdList = null;
        if (tagIds != null && !tagIds.isEmpty()) {
            tagIdList = Arrays.stream(tagIds.split(","))
                    .map(String::trim)
                    .filter(s -> !s.isEmpty())
                    .map(Long::parseLong)
                    .collect(Collectors.toList());
        }
        return productService.getProductListWithSort(categoryId, keyword, sortBy, tagId, tagIdList, page, size);
    }

    /**
     * 获取商品详情
     */
    @GetMapping("/detail/{id}")
    public Result<Product> getProductDetail(@PathVariable Long id) {
        return productService.getProductDetail(id);
    }

    /**
     * 获取热门商品
     */
    @GetMapping("/hot")
    public Result<List<Product>> getHotProducts(@RequestParam(defaultValue = "8") Integer limit) {
        return productService.getHotProducts(limit);
    }

    /**
     * 添加商品
     */
    @PostMapping("/add")
    public Result<Void> addProduct(@RequestBody Product product) {
        return productService.addProduct(product);
    }

    /**
     * 更新商品
     */
    @PutMapping("/update")
    public Result<Void> updateProduct(@RequestBody Product product) {
        return productService.updateProduct(product);
    }

    /**
     * 删除商品
     */
    @DeleteMapping("/delete/{id}")
    public Result<Void> deleteProduct(@PathVariable Long id) {
        return productService.deleteProduct(id);
    }

    /**
     * 更新库存
     */
    @PutMapping("/stock/{id}")
    public Result<Void> updateStock(@PathVariable Long id, @RequestParam Integer quantity) {
        return productService.updateStock(id, quantity);
    }

    /**
     * 更新商品销量和库存（支付成功后调用）
     * 销量+quantity，库存-quantity
     */
    @PutMapping("/sales/{id}")
    public Result<Void> updateSales(@PathVariable Long id, @RequestParam Integer quantity) {
        return productService.updateSalesAndStock(id, quantity);
    }

    // ========== 管理员接口 ==========

    /**
     * 获取商品列表（管理员用）
     */
    @GetMapping("/admin/list")
    public Result<PageResult<Product>> getProductListForAdmin(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Integer status,
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size) {
        return productService.getProductListForAdmin(keyword, status, page, size);
    }

    /**
     * 更新商品状态（上架/下架）
     */
    @PutMapping("/admin/status/{productId}")
    public Result<Void> updateProductStatus(
            @PathVariable Long productId,
            @RequestParam Integer status) {
        return productService.updateProductStatus(productId, status);
    }

    /**
     * 获取所有商品（用于统计）
     */
    @GetMapping("/admin/all")
    public Result<List<Product>> getAllProducts() {
        return productService.getAllProducts();
    }

    /**
     * 更新商品详情（Markdown内容）
     */
    @PutMapping("/admin/detail/{id}")
    public Result<Void> updateProductDetail(@PathVariable Long id, @RequestBody String detail) {
        return productService.updateProductDetail(id, detail);
    }

    /**
     * 获取轮播图商品列表
     */
    @GetMapping("/banner")
    public Result<List<Product>> getBannerProducts() {
        return productService.getBannerProducts();
    }

    /**
     * 设置/取消轮播图
     */
    @PutMapping("/admin/banner/{id}")
    public Result<Void> setBanner(
            @PathVariable Long id,
            @RequestParam Integer isBanner,
            @RequestParam(required = false, defaultValue = "0") Integer bannerSort) {
        return productService.setBanner(id, isBanner, bannerSort);
    }
}
