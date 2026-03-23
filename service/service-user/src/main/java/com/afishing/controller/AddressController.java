package com.afishing.controller;

import com.afishing.common.result.Result;
import com.afishing.entity.Address;
import com.afishing.service.AddressService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 收货地址控制器
 */
@RestController
@RequestMapping("/address")
public class AddressController {

    @Autowired
    private AddressService addressService;

    /**
     * 获取用户的收货地址列表
     */
    @GetMapping("/list/{userId}")
    public Result<List<Address>> getAddressList(@PathVariable Long userId) {
        return addressService.getAddressList(userId);
    }

    /**
     * 添加收货地址
     */
    @PostMapping("/add")
    public Result<Void> addAddress(@RequestBody Address address) {
        return addressService.addAddress(address);
    }

    /**
     * 更新收货地址
     */
    @PutMapping("/update")
    public Result<Void> updateAddress(@RequestBody Address address) {
        return addressService.updateAddress(address);
    }

    /**
     * 删除收货地址
     */
    @DeleteMapping("/delete/{id}")
    public Result<Void> deleteAddress(@PathVariable Long id, @RequestParam Long userId) {
        return addressService.deleteAddress(id, userId);
    }

    /**
     * 设置默认地址
     */
    @PostMapping("/default/{id}")
    public Result<Void> setDefaultAddress(@PathVariable Long id, @RequestParam Long userId) {
        return addressService.setDefaultAddress(id, userId);
    }
}
