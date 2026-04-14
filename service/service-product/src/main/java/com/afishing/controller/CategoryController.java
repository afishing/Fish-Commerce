package com.afishing.controller;

import com.afishing.common.result.Result;
import com.afishing.entity.ProductCategory;
import com.afishing.service.CategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 分类控制器
 */
@RestController
@RequestMapping("/category")
public class CategoryController {

    @Autowired
    private CategoryService categoryService;

    /**
     * 获取所有分类
     */
    @GetMapping("/list")
    public Result<List<ProductCategory>> list() {
        return categoryService.listAll();
    }

    /**
     * 获取分类详情
     */
    @GetMapping("/{id}")
    public Result<ProductCategory> getById(@PathVariable Long id) {
        return categoryService.getById(id);
    }

    /**
     * 创建分类
     */
    @PostMapping
    public Result<Void> create(@RequestBody ProductCategory category) {
        return categoryService.create(category);
    }

    /**
     * 更新分类
     */
    @PutMapping("/{id}")
    public Result<Void> update(@PathVariable Long id, @RequestBody ProductCategory category) {
        category.setId(id);
        return categoryService.update(category);
    }

    /**
     * 删除分类
     */
    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        return categoryService.delete(id);
    }
}
