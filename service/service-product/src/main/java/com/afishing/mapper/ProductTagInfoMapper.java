package com.afishing.mapper;

import com.afishing.entity.ProductTagInfo;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;

/**
 * 商品标签 Mapper（使用 fish_product 库）
 */
@Mapper
public interface ProductTagInfoMapper extends BaseMapper<ProductTagInfo> {
}
