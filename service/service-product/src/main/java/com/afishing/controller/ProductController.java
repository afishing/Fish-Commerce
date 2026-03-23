package com.afishing.controller;

import com.afishing.common.result.PageResult;
import com.afishing.common.result.Result;
import com.afishing.entity.Product;
import com.afishing.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

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
            @RequestParam(required = false, defaultValue = "1") Integer page,
            @RequestParam(required = false, defaultValue = "12") Integer size) {
        return productService.getProductListWithSort(categoryId, keyword, sortBy, page, size);
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

    // ========== 管理员接口 ==========

    /**
     * 获取商品列表（管理员用）
     */
    @GetMapping("/admin/list")
    public Result<PageResult<Product>> getProductListForAdmin(
            @RequestParam(required = false) Integer status,
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size) {
        return productService.getProductListForAdmin(status, page, size);
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
}
