package com.afishing.service.impl;

import com.afishing.common.result.Result;
import com.afishing.entity.ProductCategory;
import com.afishing.mapper.CategoryMapper;
import com.afishing.service.CategoryService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 商品分类服务实现类（使用 fish_commerce 库）
 */
@Service
public class CategoryServiceImpl implements CategoryService {

    @Autowired
    private CategoryMapper categoryMapper;

    @Override
    public Result<List<ProductCategory>> listAll() {
        List<ProductCategory> categories = categoryMapper.selectList(
                new LambdaQueryWrapper<ProductCategory>().orderByAsc(ProductCategory::getSort)
        );
        return Result.success("获取成功", categories);
    }

    @Override
    public Result<ProductCategory> getById(Long id) {
        ProductCategory category = categoryMapper.selectById(id);
        if (category == null) {
            return Result.error("分类不存在");
        }
        return Result.success("获取成功", category);
    }

    @Override
    public Result<Void> create(ProductCategory category) {
        category.setCreateTime(LocalDateTime.now());
        category.setUpdateTime(LocalDateTime.now());
        categoryMapper.insert(category);
        return Result.success("创建成功", null);
    }

    @Override
    public Result<Void> update(ProductCategory category) {
        ProductCategory existing = categoryMapper.selectById(category.getId());
        if (existing == null) {
            return Result.error("分类不存在");
        }
        category.setUpdateTime(LocalDateTime.now());
        categoryMapper.updateById(category);
        return Result.success("更新成功", null);
    }

    @Override
    public Result<Void> delete(Long id) {
        ProductCategory existing = categoryMapper.selectById(id);
        if (existing == null) {
            return Result.error("分类不存在");
        }
        categoryMapper.deleteById(id);
        return Result.success("删除成功", null);
    }
}
