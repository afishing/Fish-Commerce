package com.afishing.controller;

import com.afishing.common.result.Result;
import com.afishing.entity.Review;
import com.afishing.mapper.ReviewMapper;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 商品评价控制器
 */
@RestController
@RequestMapping("/product")
public class ReviewController {

    @Autowired
    private ReviewMapper reviewMapper;

    /**
     * 获取商品评价列表（前台）
     */
    @GetMapping("/reviews/{productId}")
    public Result<Page<Review>> getProductReviews(
            @PathVariable Long productId,
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size) {
        Page<Review> pageObj = new Page<>(page, size);
        LambdaQueryWrapper<Review> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Review::getProductId, productId)
               .orderByDesc(Review::getCreateTime);
        Page<Review> result = reviewMapper.selectPage(pageObj, wrapper);
        return Result.success(result);
    }

    /**
     * 获取所有评价列表（后台管理）
     */
    @GetMapping("/admin/reviews")
    public Result<Page<Review>> getAllReviews(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "20") Integer size,
            @RequestParam(required = false) String productName,
            @RequestParam(required = false) String username) {
        Page<Review> pageObj = new Page<>(page, size);
        LambdaQueryWrapper<Review> wrapper = new LambdaQueryWrapper<>();
        
        // 支持按用户名搜索
        if (username != null && !username.isEmpty()) {
            wrapper.like(Review::getUsername, username);
        }
        
        wrapper.orderByDesc(Review::getCreateTime);
        Page<Review> result = reviewMapper.selectPage(pageObj, wrapper);
        return Result.success(result);
    }

    /**
     * 添加评价
     */
    @PostMapping("/review/add")
    public Result<Review> addReview(@RequestBody Review review) {
        review.setCreateTime(LocalDateTime.now());
        review.setUpdateTime(LocalDateTime.now());
        reviewMapper.insert(review);
        return Result.success("评价成功", review);
    }

    /**
     * 删除评价
     */
    @DeleteMapping("/review/delete/{id}")
    public Result<Void> deleteReview(@PathVariable Long id) {
        reviewMapper.deleteById(id);
        return Result.success("删除成功", null);
    }
}
