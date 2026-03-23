package com.afishing.mapper;

import com.afishing.entity.Address;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;

/**
 * 收货地址Mapper
 */
@Mapper
public interface AddressMapper extends BaseMapper<Address> {
}
