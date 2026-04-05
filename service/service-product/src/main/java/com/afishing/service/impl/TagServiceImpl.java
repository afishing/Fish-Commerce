package com.afishing.service.impl;

import com.afishing.common.result.Result;
import com.afishing.entity.ProductTagInfo;
import com.afishing.mapper.ProductTagInfoMapper;
import com.afishing.service.TagService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 商品标签服务实现类（使用 fish_product 库）
 */
@Service
public class TagServiceImpl implements TagService {

    @Autowired
    private ProductTagInfoMapper tagMapper;

    @Override
    public Result<List<ProductTagInfo>> listAll() {
        List<ProductTagInfo> tags = tagMapper.selectList(
                new LambdaQueryWrapper<ProductTagInfo>()
        );
        return Result.success("获取成功", tags);
    }

    @Override
    public Result<ProductTagInfo> getById(Long id) {
        ProductTagInfo tag = tagMapper.selectById(id);
        if (tag == null) {
            return Result.error("标签不存在");
        }
        return Result.success("获取成功", tag);
    }

    @Override
    public Result<Void> create(ProductTagInfo tag) {
        tag.setCreateTime(LocalDateTime.now());
        tag.setUpdateTime(LocalDateTime.now());
        tagMapper.insert(tag);
        return Result.success("创建成功", null);
    }

    @Override
    public Result<Void> update(ProductTagInfo tag) {
        ProductTagInfo existing = tagMapper.selectById(tag.getId());
        if (existing == null) {
            return Result.error("标签不存在");
        }
        tag.setUpdateTime(LocalDateTime.now());
        tagMapper.updateById(tag);
        return Result.success("更新成功", null);
    }

    @Override
    public Result<Void> delete(Long id) {
        ProductTagInfo existing = tagMapper.selectById(id);
        if (existing == null) {
            return Result.error("标签不存在");
        }
        tagMapper.deleteById(id);
        return Result.success("删除成功", null);
    }
}
