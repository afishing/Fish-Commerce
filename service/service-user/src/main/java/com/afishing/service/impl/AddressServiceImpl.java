package com.afishing.service.impl;

import com.afishing.common.result.Result;
import com.afishing.entity.Address;
import com.afishing.mapper.AddressMapper;
import com.afishing.service.AddressService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 收货地址服务实现
 */
@Service
public class AddressServiceImpl implements AddressService {

    @Autowired
    private AddressMapper addressMapper;

    @Override
    public Result<List<Address>> getAddressList(Long userId) {
        LambdaQueryWrapper<Address> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Address::getUserId, userId);
        wrapper.eq(Address::getDeleted, 0);
        wrapper.orderByDesc(Address::getIsDefault);
        wrapper.orderByDesc(Address::getCreateTime);
        List<Address> list = addressMapper.selectList(wrapper);
        return Result.success(list);
    }

    @Override
    @Transactional
    public Result<Void> addAddress(Address address) {
        // 如果是第一个地址或设置为默认，需要处理其他地址的默认状态
        if (address.getIsDefault() != null && address.getIsDefault() == 1) {
            // 将其他地址设为非默认
            LambdaUpdateWrapper<Address> wrapper = new LambdaUpdateWrapper<>();
            wrapper.eq(Address::getUserId, address.getUserId());
            wrapper.set(Address::getIsDefault, 0);
            addressMapper.update(null, wrapper);
        }
        
        addressMapper.insert(address);
        return Result.success("添加成功", null);
    }

    @Override
    @Transactional
    public Result<Void> updateAddress(Address address) {
        // 验证地址是否存在且属于当前用户
        Address existAddress = addressMapper.selectById(address.getId());
        if (existAddress == null || !existAddress.getUserId().equals(address.getUserId())) {
            return Result.error("地址不存在");
        }
        
        // 如果设置为默认，需要处理其他地址的默认状态
        if (address.getIsDefault() != null && address.getIsDefault() == 1) {
            LambdaUpdateWrapper<Address> wrapper = new LambdaUpdateWrapper<>();
            wrapper.eq(Address::getUserId, address.getUserId());
            wrapper.ne(Address::getId, address.getId());
            wrapper.set(Address::getIsDefault, 0);
            addressMapper.update(null, wrapper);
        }
        
        addressMapper.updateById(address);
        return Result.success("更新成功", null);
    }

    @Override
    @Transactional
    public Result<Void> deleteAddress(Long id, Long userId) {
        // 验证地址是否存在且属于当前用户
        Address existAddress = addressMapper.selectById(id);
        if (existAddress == null || !existAddress.getUserId().equals(userId)) {
            return Result.error("地址不存在");
        }
        
        // 逻辑删除
        LambdaUpdateWrapper<Address> wrapper = new LambdaUpdateWrapper<>();
        wrapper.eq(Address::getId, id);
        wrapper.set(Address::getDeleted, 1);
        addressMapper.update(null, wrapper);
        
        return Result.success("删除成功", null);
    }

    @Override
    @Transactional
    public Result<Void> setDefaultAddress(Long id, Long userId) {
        // 验证地址是否存在且属于当前用户
        Address existAddress = addressMapper.selectById(id);
        if (existAddress == null || !existAddress.getUserId().equals(userId)) {
            return Result.error("地址不存在");
        }
        
        // 将所有地址设为非默认
        LambdaUpdateWrapper<Address> wrapper = new LambdaUpdateWrapper<>();
        wrapper.eq(Address::getUserId, userId);
        wrapper.set(Address::getIsDefault, 0);
        addressMapper.update(null, wrapper);
        
        // 将指定地址设为默认
        Address updateAddress = new Address();
        updateAddress.setId(id);
        updateAddress.setIsDefault(1);
        addressMapper.updateById(updateAddress);
        
        return Result.success("设置成功", null);
    }
}
