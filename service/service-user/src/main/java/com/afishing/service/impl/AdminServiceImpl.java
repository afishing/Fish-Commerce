package com.afishing.service.impl;

import com.afishing.common.result.PageResult;
import com.afishing.common.result.Result;
import com.afishing.dto.*;
import com.afishing.entity.Order;
import com.afishing.entity.Product;
import com.afishing.entity.User;
import com.afishing.feign.OrderFeignClient;
import com.afishing.feign.ProductFeignClient;
import com.afishing.mapper.UserMapper;
import com.afishing.service.AdminService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 管理员服务实现
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class AdminServiceImpl implements AdminService {

    private final UserMapper userMapper;
    private final OrderFeignClient orderFeignClient;
    private final ProductFeignClient productFeignClient;

    @Override
    public Result<User> adminLogin(AdminLoginDTO loginDTO) {
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(User::getUsername, loginDTO.getUsername());
        User user = userMapper.selectOne(wrapper);

        if (user == null) {
            return Result.error("用户不存在");
        }

        if (!user.getPassword().equals(loginDTO.getPassword())) {
            return Result.error("密码错误");
        }

        // 检查是否为管理员
        if (user.getRole() == null || user.getRole() != 1) {
            return Result.error("无权访问，仅管理员可登录");
        }

        if (user.getStatus() == 1) {
            return Result.error("账号已被禁用");
        }

        // 清除密码后返回
        user.setPassword(null);
        return Result.success("登录成功", user);
    }

    @Override
    public Result<AdminStatisticsDTO> getStatistics() {
        AdminStatisticsDTO statistics = new AdminStatisticsDTO();

        // 1. 用户统计
        // 总用户数
        statistics.setTotalUsers(userMapper.selectCount(null));

        // 今日新增用户
        LocalDateTime todayStart = LocalDateTime.of(LocalDate.now(), LocalTime.MIN);
        LocalDateTime todayEnd = LocalDateTime.of(LocalDate.now(), LocalTime.MAX);
        LambdaQueryWrapper<User> todayUserWrapper = new LambdaQueryWrapper<>();
        todayUserWrapper.between(User::getCreateTime, todayStart, todayEnd);
        statistics.setTodayNewUsers(userMapper.selectCount(todayUserWrapper));

        // 2. 订单统计（通过Feign调用订单服务）
        try {
            Result<List<Order>> allOrdersResult = orderFeignClient.getAllOrders();
            if (allOrdersResult.isSuccess() && allOrdersResult.getData() != null) {
                List<Order> allOrders = allOrdersResult.getData();
                statistics.setTotalOrders((long) allOrders.size());

                // 今日订单
                List<Order> todayOrders = allOrders.stream()
                        .filter(order -> order.getCreateTime() != null
                                && order.getCreateTime().toLocalDate().equals(LocalDate.now()))
                        .collect(Collectors.toList());
                statistics.setTodayOrders((long) todayOrders.size());

                // 今日成交金额
                BigDecimal todayAmount = todayOrders.stream()
                        .filter(order -> order.getStatus() >= 1) // 已支付的订单
                        .map(Order::getPayAmount)
                        .filter(amount -> amount != null)
                        .reduce(BigDecimal.ZERO, BigDecimal::add);
                statistics.setTodayAmount(todayAmount);

                // 总成交金额
                BigDecimal totalAmount = allOrders.stream()
                        .filter(order -> order.getStatus() >= 1)
                        .map(Order::getPayAmount)
                        .filter(amount -> amount != null)
                        .reduce(BigDecimal.ZERO, BigDecimal::add);
                statistics.setTotalAmount(totalAmount);

                // 待发货订单数（status=1）
                long pendingShip = allOrders.stream()
                        .filter(order -> order.getStatus() != null && order.getStatus() == 1)
                        .count();
                statistics.setPendingShipOrders(pendingShip);

                // 待付款订单数（status=0）
                long pendingPay = allOrders.stream()
                        .filter(order -> order.getStatus() != null && order.getStatus() == 0)
                        .count();
                statistics.setPendingPayOrders(pendingPay);

                // 订单状态分布
                Map<String, Long> statusDistribution = new HashMap<>();
                statusDistribution.put("待付款", pendingPay);
                statusDistribution.put("待发货", pendingShip);
                statusDistribution.put("待收货", allOrders.stream()
                        .filter(order -> order.getStatus() != null && order.getStatus() == 2).count());
                statusDistribution.put("已完成", allOrders.stream()
                        .filter(order -> order.getStatus() != null && order.getStatus() == 3).count());
                statusDistribution.put("已取消", allOrders.stream()
                        .filter(order -> order.getStatus() != null && order.getStatus() == 4).count());
                statistics.setOrderStatusDistribution(statusDistribution);

                // 最近7天统计
                List<AdminStatisticsDTO.DailyStatistics> recentOrders = new ArrayList<>();
                List<AdminStatisticsDTO.DailyStatistics> recentAmount = new ArrayList<>();

                for (int i = 6; i >= 0; i--) {
                    LocalDate date = LocalDate.now().minusDays(i);
                    final LocalDate currentDate = date;

                    List<Order> dayOrders = allOrders.stream()
                            .filter(order -> order.getCreateTime() != null
                                    && order.getCreateTime().toLocalDate().equals(currentDate))
                            .collect(Collectors.toList());

                    AdminStatisticsDTO.DailyStatistics orderStat = new AdminStatisticsDTO.DailyStatistics();
                    orderStat.setDate(date);
                    orderStat.setCount((long) dayOrders.size());
                    recentOrders.add(orderStat);

                    BigDecimal dayAmount = dayOrders.stream()
                            .filter(order -> order.getStatus() >= 1)
                            .map(Order::getPayAmount)
                            .filter(amount -> amount != null)
                            .reduce(BigDecimal.ZERO, BigDecimal::add);

                    AdminStatisticsDTO.DailyStatistics amountStat = new AdminStatisticsDTO.DailyStatistics();
                    amountStat.setDate(date);
                    amountStat.setAmount(dayAmount);
                    recentAmount.add(amountStat);
                }
                statistics.setRecentOrders(recentOrders);
                statistics.setRecentAmount(recentAmount);
            }
        } catch (Exception e) {
            log.error("获取订单统计失败", e);
        }

        // 3. 商品统计（通过Feign调用商品服务）
        try {
            Result<List<Product>> allProductsResult = productFeignClient.getAllProducts();
            if (allProductsResult.isSuccess() && allProductsResult.getData() != null) {
                List<Product> allProducts = allProductsResult.getData();
                statistics.setTotalProducts((long) allProducts.size());

                // 上架商品数
                long onSale = allProducts.stream()
                        .filter(product -> product.getStatus() != null && product.getStatus() == 1)
                        .count();
                statistics.setOnSaleProducts(onSale);
            }
        } catch (Exception e) {
            log.error("获取商品统计失败", e);
        }

        return Result.success(statistics);
    }

    @Override
    public Result<PageResult<User>> getUserList(UserQueryDTO queryDTO) {
        Page<User> page = new Page<>(queryDTO.getPage(), queryDTO.getSize());
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();

        // 模糊查询用户名
        if (queryDTO.getUsername() != null && !queryDTO.getUsername().isEmpty()) {
            wrapper.like(User::getUsername, queryDTO.getUsername());
        }

        // 查询手机号
        if (queryDTO.getPhone() != null && !queryDTO.getPhone().isEmpty()) {
            wrapper.eq(User::getPhone, queryDTO.getPhone());
        }

        // 查询邮箱
        if (queryDTO.getEmail() != null && !queryDTO.getEmail().isEmpty()) {
            wrapper.eq(User::getEmail, queryDTO.getEmail());
        }

        // 查询状态
        if (queryDTO.getStatus() != null) {
            wrapper.eq(User::getStatus, queryDTO.getStatus());
        }

        // 只查询普通用户（role=0或null），不显示管理员
        wrapper.and(w -> w.eq(User::getRole, 0).or().isNull(User::getRole));

        // 按创建时间倒序
        wrapper.orderByDesc(User::getCreateTime);

        Page<User> resultPage = userMapper.selectPage(page, wrapper);

        // 清除密码
        resultPage.getRecords().forEach(user -> user.setPassword(null));

        PageResult<User> pageResult = new PageResult<>();
        pageResult.setList(resultPage.getRecords());
        pageResult.setTotal(resultPage.getTotal());
        pageResult.setPage((int) resultPage.getCurrent());
        pageResult.setSize((int) resultPage.getSize());
        pageResult.setPages((int) resultPage.getPages());

        return Result.success(pageResult);
    }

    @Override
    public Result<Void> updateUserStatus(Long userId, Integer status) {
        User user = userMapper.selectById(userId);
        if (user == null) {
            return Result.error("用户不存在");
        }

        // 不能禁用管理员
        if (user.getRole() != null && user.getRole() == 1) {
            return Result.error("不能修改管理员状态");
        }

        user.setStatus(status);
        userMapper.updateById(user);
        return Result.success("操作成功", null);
    }

    @Override
    public Result<PageResult<Order>> getOrderList(Integer status, Integer page, Integer size) {
        return orderFeignClient.getOrderListForAdmin(status, page, size);
    }

    @Override
    public Result<Void> shipOrder(Long orderId) {
        return orderFeignClient.shipOrder(orderId);
    }

    @Override
    public Result<PageResult<Product>> getProductList(Integer status, Integer page, Integer size) {
        return productFeignClient.getProductListForAdmin(status, page, size);
    }

    @Override
    public Result<Void> addProduct(ProductAddDTO productDTO) {
        Product product = new Product();
        BeanUtils.copyProperties(productDTO, product);
        return productFeignClient.addProduct(product);
    }

    @Override
    public Result<Void> updateProduct(Product product) {
        return productFeignClient.updateProduct(product);
    }

    @Override
    public Result<Void> updateProductStatus(Long productId, Integer status) {
        return productFeignClient.updateProductStatus(productId, status);
    }

    @Override
    public Result<Void> deleteProduct(Long productId) {
        return productFeignClient.deleteProduct(productId);
    }
}
