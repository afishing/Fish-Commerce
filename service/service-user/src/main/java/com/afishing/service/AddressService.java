package com.afishing.service;

import com.afishing.common.result.Result;
import com.afishing.entity.Address;

import java.util.List;

/**
 * 收货地址服务接口
 */
public interface AddressService {

    /**
     * 获取用户的收货地址列表
     */
    Result<List<Address>> getAddressList(Long userId);

    /**
     * 添加收货地址
     */
    Result<Void> addAddress(Address address);

    /**
     * 更新收货地址
     */
    Result<Void> updateAddress(Address address);

    /**
     * 删除收货地址
     */
    Result<Void> deleteAddress(Long id, Long userId);

    /**
     * 设置默认地址
     */
    Result<Void> setDefaultAddress(Long id, Long userId);
}
