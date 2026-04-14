package com.afishing.controller;

import com.afishing.common.result.Result;
import com.afishing.entity.ProductTag;
import com.afishing.entity.ProductTagInfo;
import com.afishing.mapper.ProductTagInfoMapper;
import com.afishing.mapper.ProductTagMapper;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 标签控制器
 */
@RestController
@RequestMapping("/tag")
public class TagController {

    @Autowired
    private ProductTagInfoMapper tagInfoMapper;

    @Autowired
    private ProductTagMapper productTagMapper;

    /**
     * 获取所有标签
     */
    @GetMapping("/list")
    public Result<List<ProductTagInfo>> getAllTags() {
        LambdaQueryWrapper<ProductTagInfo> wrapper = new LambdaQueryWrapper<>();
        wrapper.orderByDesc(ProductTagInfo::getCreateTime);
        List<ProductTagInfo> tags = tagInfoMapper.selectList(wrapper);
        return Result.success(tags);
    }

    /**
     * 获取商品标签
     */
    @GetMapping("/product/{productId}")
    public Result<List<ProductTagInfo>> getProductTags(@PathVariable Long productId) {
        LambdaQueryWrapper<ProductTag> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(ProductTag::getProductId, productId);
        List<Long> tagIds = productTagMapper.selectList(wrapper)
                .stream()
                .map(ProductTag::getTagId)
                .collect(Collectors.toList());
        if (tagIds.isEmpty()) {
            return Result.success(List.of());
        }
        LambdaQueryWrapper<ProductTagInfo> tagWrapper = new LambdaQueryWrapper<>();
        tagWrapper.in(ProductTagInfo::getId, tagIds);
        List<ProductTagInfo> tags = tagInfoMapper.selectList(tagWrapper);
        return Result.success(tags);
    }

    /**
     * 设置商品标签
     */
    @PostMapping("/product/{productId}")
    public Result<Void> setProductTags(@PathVariable Long productId, @RequestBody List<Long> tagIds) {
        // 删除原有标签
        LambdaQueryWrapper<ProductTag> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(ProductTag::getProductId, productId);
        productTagMapper.delete(wrapper);
        // 添加新标签
        for (Long tagId : tagIds) {
            ProductTag productTag = new ProductTag();
            productTag.setProductId(productId);
            productTag.setTagId(tagId);
            productTagMapper.insert(productTag);
        }
        return Result.success("设置成功", null);
    }

    /**
     * 添加标签
     */
    @PostMapping("/add")
    public Result<Void> addTag(@RequestBody ProductTagInfo tag) {
        tagInfoMapper.insert(tag);
        return Result.success("添加成功", null);
    }

    /**
     * 更新标签
     */
    @PutMapping("/update")
    public Result<Void> updateTag(@RequestBody ProductTagInfo tag) {
        tagInfoMapper.updateById(tag);
        return Result.success("更新成功", null);
    }

    /**
     * 删除标签
     */
    @DeleteMapping("/delete/{id}")
    public Result<Void> deleteTag(@PathVariable Long id) {
        tagInfoMapper.deleteById(id);
        return Result.success("删除成功", null);
    }
}
