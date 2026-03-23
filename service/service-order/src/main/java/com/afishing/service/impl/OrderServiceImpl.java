package com.afishing.service.impl;

import com.afishing.common.result.PageResult;
import com.afishing.common.result.Result;
import com.afishing.dto.CreateOrderDTO;
import com.afishing.dto.OrderDTO;
import com.afishing.dto.OrderItemDTO;
import com.afishing.entity.Order;
import com.afishing.entity.OrderItem;
import com.afishing.mapper.OrderItemMapper;
import com.afishing.mapper.OrderMapper;
import com.afishing.service.OrderService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

/**
 * 订单服务实现
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class OrderServiceImpl implements OrderService {

    private final OrderMapper orderMapper;
    private final OrderItemMapper orderItemMapper;
    private final StringRedisTemplate redisTemplate;

    private static final String ORDER_KEY_PREFIX = "order:";

    @Override
    public Result<List<OrderDTO>> getOrderList(Long userId, Integer status) {
        LambdaQueryWrapper<Order> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Order::getUserId, userId);
        
        if (status != null) {
            wrapper.eq(Order::getStatus, status);
        }
        
        wrapper.orderByDesc(Order::getCreateTime);
        
        List<Order> orders = orderMapper.selectList(wrapper);
        
        List<OrderDTO> orderDTOs = new ArrayList<>();
        for (Order order : orders) {
            orderDTOs.add(convertToDTO(order));
        }
        
        return Result.success(orderDTOs);
    }

    @Override
    public Result<OrderDTO> getOrderDetail(Long id) {
        Order order = orderMapper.selectById(id);
        if (order == null) {
            return Result.error("订单不存在");
        }
        return Result.success(convertToDTO(order));
    }

    @Override
    @Transactional
    public Result<Order> createOrder(Order order) {
        // 生成订单号
        String orderNo = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmssSSS"));
        order.setOrderNo(orderNo);
        order.setStatus(0); // 待付款
        order.setPayType(0); // 未支付
        
        orderMapper.insert(order);
        
        return Result.success("订单创建成功", order);
    }

    @Override
    @Transactional
    public Result<Order> createOrderFromDTO(CreateOrderDTO dto) {
        // 创建订单
        Order order = new Order();
        String orderNo = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmssSSS"));
        order.setOrderNo(orderNo);
        order.setUserId(dto.getUserId());
        order.setReceiverName(dto.getReceiverName());
        order.setReceiverPhone(dto.getReceiverPhone());
        order.setReceiverAddress(dto.getReceiverAddress());
        order.setTotalAmount(dto.getTotalAmount());
        order.setPayAmount(dto.getPayAmount());
        order.setRemark(dto.getRemark());
        order.setStatus(0); // 待付款
        order.setPayType(0); // 未支付
        
        orderMapper.insert(order);
        
        // 保存订单项
        if (dto.getItems() != null && !dto.getItems().isEmpty()) {
            for (OrderItemDTO itemDTO : dto.getItems()) {
                OrderItem item = new OrderItem();
                item.setOrderId(order.getId());
                item.setProductId(itemDTO.getProductId());
                item.setProductName(itemDTO.getProductName());
                item.setProductImage(itemDTO.getProductImage());
                item.setProductSpec(itemDTO.getProductSpec());
                item.setPrice(itemDTO.getPrice());
                item.setQuantity(itemDTO.getQuantity());
                item.setTotalAmount(itemDTO.getPrice().multiply(new BigDecimal(itemDTO.getQuantity())));
                orderItemMapper.insert(item);
            }
        }
        
        // 存入 Redis，记录创建时间
        redisTemplate.opsForValue().set(ORDER_KEY_PREFIX + order.getId(), LocalDateTime.now().toString());
        log.info("订单 {} 创建，2分钟后超时", order.getId());
        
        return Result.success("订单创建成功", order);
    }

    @Override
    public Result<Void> payOrder(Long id) {
        Order order = orderMapper.selectById(id);
        if (order == null) {
            return Result.error("订单不存在");
        }
        
        if (order.getStatus() != 0) {
            return Result.error("订单状态异常");
        }
        
        order.setStatus(1); // 待发货（支付后等待管理员发货）
        order.setPayType(1); // 支付宝
        order.setPayTime(LocalDateTime.now());
        orderMapper.updateById(order);
        
        // 支付成功，删除 Redis key
        redisTemplate.delete(ORDER_KEY_PREFIX + id);
        log.info("订单 {} 支付成功，删除超时标记", id);
        
        return Result.success("支付成功，等待商家发货", null);
    }

    @Override
    public Result<Void> cancelOrder(Long id) {
        Order order = orderMapper.selectById(id);
        if (order == null) {
            return Result.error("订单不存在");
        }
        
        if (order.getStatus() != 0) {
            return Result.error("只能取消待付款订单");
        }
        
        order.setStatus(4); // 已取消
        orderMapper.updateById(order);
        
        return Result.success("订单已取消", null);
    }

    @Override
    public Result<Void> confirmOrder(Long id) {
        Order order = orderMapper.selectById(id);
        if (order == null) {
            return Result.error("订单不存在");
        }
        
        if (order.getStatus() != 2) {
            return Result.error("只能确认待收货订单");
        }
        
        order.setStatus(3); // 已完成
        orderMapper.updateById(order);
        
        return Result.success("确认收货成功", null);
    }

    @Override
    public Result<Void> deleteOrder(Long id) {
        orderMapper.deleteById(id);
        return Result.success("订单已删除", null);
    }

    @Override
    public Result<Void> updatePayStatus(Long id, Integer status, Integer payType) {
        Order order = orderMapper.selectById(id);
        if (order == null) {
            return Result.error("订单不存在");
        }
        
        order.setStatus(status);
        order.setPayType(payType);
        order.setPayTime(LocalDateTime.now());
        orderMapper.updateById(order);
        
        return Result.success("订单状态更新成功", null);
    }

    @Override
    public Result<PageResult<Order>> getOrderListForAdmin(Integer status, Integer page, Integer size) {
        Page<Order> pageParam = new Page<>(page, size);
        LambdaQueryWrapper<Order> wrapper = new LambdaQueryWrapper<>();
        
        if (status != null) {
            wrapper.eq(Order::getStatus, status);
        }
        
        wrapper.orderByDesc(Order::getCreateTime);
        
        Page<Order> resultPage = orderMapper.selectPage(pageParam, wrapper);
        
        PageResult<Order> pageResult = new PageResult<>();
        pageResult.setList(resultPage.getRecords());
        pageResult.setTotal(resultPage.getTotal());
        pageResult.setPage((int) resultPage.getCurrent());
        pageResult.setSize((int) resultPage.getSize());
        pageResult.setPages((int) resultPage.getPages());
        
        return Result.success(pageResult);
    }

    @Override
    public Result<Void> shipOrder(Long orderId) {
        Order order = orderMapper.selectById(orderId);
        if (order == null) {
            return Result.error("订单不存在");
        }
        
        if (order.getStatus() != 1) {
            return Result.error("只能发货待发货订单");
        }
        
        order.setStatus(2); // 待收货
        orderMapper.updateById(order);
        
        return Result.success("发货成功", null);
    }

    @Override
    public Result<List<Order>> getAllOrders() {
        List<Order> orders = orderMapper.selectList(null);
        return Result.success(orders);
    }

    private OrderDTO convertToDTO(Order order) {
        OrderDTO dto = new OrderDTO();
        dto.setId(order.getId());
        dto.setOrderNo(order.getOrderNo());
        dto.setUserId(order.getUserId());
        dto.setReceiverName(order.getReceiverName());
        dto.setReceiverPhone(order.getReceiverPhone());
        dto.setReceiverAddress(order.getReceiverAddress());
        dto.setTotalAmount(order.getTotalAmount());
        dto.setPayAmount(order.getPayAmount());
        dto.setStatus(order.getStatus());
        
        // 查询订单项
        LambdaQueryWrapper<OrderItem> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(OrderItem::getOrderId, order.getId());
        List<OrderItem> items = orderItemMapper.selectList(wrapper);
        
        List<OrderItemDTO> itemDTOs = new ArrayList<>();
        for (OrderItem item : items) {
            OrderItemDTO itemDTO = new OrderItemDTO();
            itemDTO.setId(item.getId());
            itemDTO.setProductId(item.getProductId());
            itemDTO.setProductName(item.getProductName());
            itemDTO.setProductImage(item.getProductImage());
            itemDTO.setProductSpec(item.getProductSpec());
            itemDTO.setPrice(item.getPrice());
            itemDTO.setQuantity(item.getQuantity());
            itemDTO.setTotalAmount(item.getTotalAmount());
            itemDTOs.add(itemDTO);
        }
        dto.setItems(itemDTOs);
        
        return dto;
    }
}
