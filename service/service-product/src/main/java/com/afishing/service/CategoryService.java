package com.afishing.service;

import com.afishing.common.result.Result;
import com.afishing.entity.ProductCategory;

import java.util.List;

public interface CategoryService {

    /**
     * 获取所有分类
     */
    Result<List<ProductCategory>> listAll();

    /**
     * 根据 ID 获取分类
     */
    Result<ProductCategory> getById(Long id);

    /**
     * 创建分类
     */
    Result<Void> create(ProductCategory category);

    /**
     * 更新分类
     */
    Result<Void> update(ProductCategory category);

    /**
     * 删除分类
     */
    Result<Void> delete(Long id);
}
