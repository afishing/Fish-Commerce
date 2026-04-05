package com.afishing.mapper;

import com.afishing.entity.ProductTag;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;

/**
 * 商品标签关联Mapper
 */
@Mapper
public interface ProductTagMapper extends BaseMapper<ProductTag> {
}