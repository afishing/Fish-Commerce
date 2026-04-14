package com.afishing.service;

import com.afishing.common.result.PageResult;
import com.afishing.common.result.Result;
import com.afishing.entity.Product;

import java.util.List;

/**
 * 商品服务接口
 */
public interface ProductService {

    Result<PageResult<Product>> getProductList(Long categoryId, String keyword, Integer page, Integer size);

    Result<PageResult<Product>> getProductListWithSort(Long categoryId, String keyword, String sortBy, Long tagId, List<Long> tagIds, Integer page, Integer size);

    Result<Product> getProductDetail(Long id);

    Result<List<Product>> getHotProducts(Integer limit);

    Result<Void> addProduct(Product product);

    Result<Void> updateProduct(Product product);

    Result<Void> deleteProduct(Long id);

    Result<Void> updateStock(Long id, Integer quantity);

    /**
     * 更新商品销量和库存（支付成功后调用）
     */
    Result<Void> updateSalesAndStock(Long id, Integer quantity);

    /**
     * 获取商品列表（管理员用）
     */
    Result<PageResult<Product>> getProductListForAdmin(String keyword, Integer status, Integer page, Integer size);

    /**
     * 更新商品状态（上架/下架）
     */
    Result<Void> updateProductStatus(Long productId, Integer status);

    /**
     * 获取所有商品（用于统计）
     */
    Result<List<Product>> getAllProducts();

    /**
     * 更新商品详情（Markdown内容）
     */
    Result<Void> updateProductDetail(Long id, String detail);

    /**
     * 设置/取消轮播图
     */
    Result<Void> setBanner(Long id, Integer isBanner, Integer bannerSort);

    /**
     * 获取轮播图商品列表
     */
    Result<List<Product>> getBannerProducts();
}
