package com.afishing.controller;

import com.afishing.common.result.Result;
import com.afishing.entity.ProductTagInfo;
import com.afishing.mapper.ProductTagInfoMapper;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 标签控制器
 */
@RestController
@RequestMapping("/tag")
public class TagController {

    @Autowired
    private ProductTagInfoMapper tagInfoMapper;

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
