package com.afishing.controller;

import com.afishing.common.result.Result;
import com.afishing.entity.ProductTagInfo;
import com.afishing.service.TagService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 商品标签控制器（使用 fish_product 库）
 */
@RestController
@RequestMapping("/tag")
public class TagController {

    @Autowired
    private TagService tagService;

    /**
     * 获取所有标签
     */
    @GetMapping("/list")
    public Result<List<ProductTagInfo>> list() {
        return tagService.listAll();
    }

    /**
     * 获取标签详情
     */
    @GetMapping("/{id}")
    public Result<ProductTagInfo> getById(@PathVariable Long id) {
        return tagService.getById(id);
    }

    /**
     * 创建标签
     */
    @PostMapping
    public Result<Void> create(@RequestBody ProductTagInfo tag) {
        return tagService.create(tag);
    }

    /**
     * 更新标签
     */
    @PutMapping("/{id}")
    public Result<Void> update(@PathVariable Long id, @RequestBody ProductTagInfo tag) {
        tag.setId(id);
        return tagService.update(tag);
    }

    /**
     * 删除标签
     */
    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        return tagService.delete(id);
    }
}
