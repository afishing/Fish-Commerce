package com.afishing.service.impl;

import com.afishing.common.result.PageResult;
import com.afishing.common.result.Result;
import com.afishing.entity.Product;
import com.afishing.mapper.ProductMapper;
import com.afishing.service.ProductService;
import com.afishing.entity.ProductTag;
import com.afishing.mapper.ProductTagMapper;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 商品服务实现
 */
@Service
public class ProductServiceImpl implements ProductService {

    @Autowired
    private ProductMapper productMapper;

    @Autowired
    private ProductTagMapper productTagMapper;

    @Override
    public Result<PageResult<Product>> getProductList(Long categoryId, String keyword, Integer page, Integer size) {
        LambdaQueryWrapper<Product> wrapper = new LambdaQueryWrapper<>();
        
        // 只查询上架商品
        wrapper.eq(Product::getStatus, 1);
        
        // 按分类筛选
        if (categoryId != null && categoryId > 0) {
            wrapper.eq(Product::getCategoryId, categoryId);
        }
        
        // 按关键字搜索
        if (keyword != null && !keyword.isEmpty()) {
            wrapper.and(w -> w.like(Product::getName, keyword)
                    .or()
                    .like(Product::getDescription, keyword));
        }
        
        // 排序逻辑：默认按销量降序
        wrapper.orderByDesc(Product::getSales);
        
        Page<Product> pageResult = productMapper.selectPage(new Page<>(page, size), wrapper);
        
        PageResult<Product> result = PageResult.of(
                pageResult.getRecords(),
                pageResult.getTotal(),
                page,
                size
        );
        
        return Result.success(result);
    }

    @Override
    public Result<PageResult<Product>> getProductListWithSort(Long categoryId, String keyword, String sortBy, Long tagId, List<Long> tagIds, Integer page, Integer size) {
        LambdaQueryWrapper<Product> wrapper = new LambdaQueryWrapper<>();
        
        // 只查询上架商品
        wrapper.eq(Product::getStatus, 1);
        
        // 按单标签筛选（兼容旧版）
        if (tagId != null) {
            LambdaQueryWrapper<ProductTag> ptWrapper = new LambdaQueryWrapper<>();
            ptWrapper.eq(ProductTag::getTagId, tagId);
            List<Long> productIds = productTagMapper.selectList(ptWrapper).stream()
                    .map(ProductTag::getProductId)
                    .collect(Collectors.toList());
            if (productIds.isEmpty()) {
                return Result.success(PageResult.of(Collections.emptyList(), 0L, page, size));
            }
            wrapper.in(Product::getId, productIds);
        }
        
        // 按多标签筛选（取交集：商品必须同时包含所有选中的标签）
        if (tagIds != null && !tagIds.isEmpty()) {
            // 获取每个标签对应的商品ID集合
            List<List<Long>> productIdLists = tagIds.stream().map(tid -> {
                LambdaQueryWrapper<ProductTag> ptWrapper = new LambdaQueryWrapper<>();
                ptWrapper.eq(ProductTag::getTagId, tid);
                return productTagMapper.selectList(ptWrapper).stream()
                        .map(ProductTag::getProductId)
                        .collect(Collectors.toList());
            }).collect(Collectors.toList());
            
            // 如果任一标签没有商品，直接返回空结果
            if (productIdLists.stream().anyMatch(List::isEmpty)) {
                return Result.success(PageResult.of(Collections.emptyList(), 0L, page, size));
            }
            
            // 取交集：商品必须出现在所有标签的商品列表中
            List<Long> intersection = productIdLists.get(0);
            for (int i = 1; i < productIdLists.size(); i++) {
                intersection.retainAll(productIdLists.get(i));
            }
            
            if (intersection.isEmpty()) {
                return Result.success(PageResult.of(Collections.emptyList(), 0L, page, size));
            }
            wrapper.in(Product::getId, intersection);
        }
        
        // 按分类筛选
        if (categoryId != null && categoryId > 0) {
            wrapper.eq(Product::getCategoryId, categoryId);
        }
        
        // 按关键字搜索
        if (keyword != null && !keyword.isEmpty()) {
            wrapper.and(w -> w.like(Product::getName, keyword)
                    .or()
                    .like(Product::getDescription, keyword));
        }
        
        // 根据 sortBy 参数决定排序方式
        if ("price-asc".equals(sortBy)) {
            wrapper.orderByAsc(Product::getPrice);
        } else if ("price-desc".equals(sortBy)) {
            wrapper.orderByDesc(Product::getPrice);
        } else if ("sales".equals(sortBy)) {
            wrapper.orderByDesc(Product::getSales);
        } else {
            wrapper.orderByDesc(Product::getSales);
        }
        
        Page<Product> pageResult = productMapper.selectPage(new Page<>(page, size), wrapper);
        
        PageResult<Product> result = PageResult.of(
                pageResult.getRecords(),
                pageResult.getTotal(),
                page,
                size
        );
        
        return Result.success(result);
    }

    @Override
    public Result<Product> getProductDetail(Long id) {
        Product product = productMapper.selectById(id);
        if (product == null) {
            return Result.error("商品不存在");
        }
        return Result.success(product);
    }

    @Override
    public Result<List<Product>> getHotProducts(Integer limit) {
        LambdaQueryWrapper<Product> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Product::getStatus, 1)
                .orderByDesc(Product::getSales)
                .last("LIMIT " + limit);
        
        List<Product> products = productMapper.selectList(wrapper);
        return Result.success(products);
    }

    @Override
    public Result<Void> addProduct(Product product) {
        product.setStatus(1);
        product.setSales(0);
        productMapper.insert(product);
        return Result.success("添加成功", null);
    }

    @Override
    public Result<Void> updateProduct(Product product) {
        Product existProduct = productMapper.selectById(product.getId());
        if (existProduct == null) {
            return Result.error("商品不存在");
        }
        
        productMapper.updateById(product);
        return Result.success("更新成功", null);
    }

    @Override
    public Result<Void> deleteProduct(Long id) {
        productMapper.deleteById(id);
        return Result.success("删除成功", null);
    }

    @Override
    public Result<Void> updateStock(Long id, Integer quantity) {
        Product product = productMapper.selectById(id);
        if (product == null) {
            return Result.error("商品不存在");
        }
        
        product.setStock(product.getStock() + quantity);
        productMapper.updateById(product);
        return Result.success("库存更新成功", null);
    }

    @Override
    public Result<Void> updateSalesAndStock(Long id, Integer quantity) {
        Product product = productMapper.selectById(id);
        if (product == null) {
            return Result.error("商品不存在");
        }
        
        // 销量+quantity，库存-quantity
        product.setSales(product.getSales() + quantity);
        product.setStock(product.getStock() - quantity);
        productMapper.updateById(product);
        return Result.success("销量和库存更新成功", null);
    }

    @Override
    public Result<PageResult<Product>> getProductListForAdmin(Integer status, Integer page, Integer size) {
        Page<Product> pageParam = new Page<>(page, size);
        LambdaQueryWrapper<Product> wrapper = new LambdaQueryWrapper<>();
        
        if (status != null) {
            wrapper.eq(Product::getStatus, status);
        }
        
        wrapper.orderByDesc(Product::getCreateTime);
        
        Page<Product> resultPage = productMapper.selectPage(pageParam, wrapper);
        
        PageResult<Product> pageResult = PageResult.of(
                resultPage.getRecords(),
                resultPage.getTotal(),
                page,
                size
        );
        
        return Result.success(pageResult);
    }

    @Override
    public Result<Void> updateProductStatus(Long productId, Integer status) {
        Product product = productMapper.selectById(productId);
        if (product == null) {
            return Result.error("商品不存在");
        }
        
        product.setStatus(status);
        productMapper.updateById(product);
        
        String action = status == 1 ? "上架" : "下架";
        return Result.success(action + "成功", null);
    }

    @Override
    public Result<List<Product>> getAllProducts() {
        List<Product> products = productMapper.selectList(null);
        return Result.success(products);
    }

    @Override
    public Result<Void> updateProductDetail(Long id, String detail) {
        Product product = productMapper.selectById(id);
        if (product == null) {
            return Result.error("商品不存在");
        }
        product.setDetail(detail);
        productMapper.updateById(product);
        return Result.success("详情更新成功", null);
    }

    @Override
    public Result<Void> setBanner(Long id, Integer isBanner, Integer bannerSort) {
        Product product = productMapper.selectById(id);
        if (product == null) {
            return Result.error("商品不存在");
        }
        product.setIsBanner(isBanner);
        if (bannerSort != null) {
            product.setBannerSort(bannerSort);
        }
        productMapper.updateById(product);
        String action = isBanner == 1 ? "设置" : "取消";
        return Result.success("轮播图" + action + "成功", null);
    }

    @Override
    public Result<List<Product>> getBannerProducts() {
        LambdaQueryWrapper<Product> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Product::getIsBanner, 1)
               .eq(Product::getStatus, 1)
               .orderByAsc(Product::getBannerSort);
        List<Product> products = productMapper.selectList(wrapper);
        return Result.success(products);
    }
}
