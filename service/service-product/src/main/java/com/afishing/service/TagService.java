package com.afishing.service;

import com.afishing.common.result.Result;
import com.afishing.entity.ProductTagInfo;

import java.util.List;

/**
 * 商品标签服务接口（使用 fish_product 库）
 */
public interface TagService {

    /**
     * 获取所有标签
     */
    Result<List<ProductTagInfo>> listAll();

    /**
     * 根据 ID 获取标签
     */
    Result<ProductTagInfo> getById(Long id);

    /**
     * 创建标签
     */
    Result<Void> create(ProductTagInfo tag);

    /**
     * 更新标签
     */
    Result<Void> update(ProductTagInfo tag);

    /**
     * 删除标签
     */
    Result<Void> delete(Long id);
}
