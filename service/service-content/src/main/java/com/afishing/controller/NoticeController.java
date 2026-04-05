package com.afishing.controller;

import com.afishing.common.result.Result;
import com.afishing.entity.Notice;
import com.afishing.mapper.NoticeMapper;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 公告管理控制器
 */
@RestController
@RequestMapping("/notice")
public class NoticeController {

    @Autowired
    private NoticeMapper noticeMapper;

    /**
     * 获取公告列表（分页）
     */
    @GetMapping("/list")
    public Result<Page<Notice>> getNoticeList(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size) {
        Page<Notice> pageObj = new Page<>(page, size);
        LambdaQueryWrapper<Notice> wrapper = new LambdaQueryWrapper<>();
        wrapper.orderByDesc(Notice::getCreateTime);
        Page<Notice> result = noticeMapper.selectPage(pageObj, wrapper);
        return Result.success(result);
    }

    /**
     * 获取启用的公告列表
     */
    @GetMapping("/active")
    public Result<List<Notice>> getActiveNotices() {
        LambdaQueryWrapper<Notice> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Notice::getStatus, 1)
               .orderByDesc(Notice::getCreateTime);
        List<Notice> notices = noticeMapper.selectList(wrapper);
        return Result.success(notices);
    }

    /**
     * 获取公告详情
     */
    @GetMapping("/{id}")
    public Result<Notice> getNoticeById(@PathVariable Long id) {
        Notice notice = noticeMapper.selectById(id);
        if (notice == null) {
            return Result.error("公告不存在");
        }
        return Result.success(notice);
    }

    /**
     * 添加公告
     */
    @PostMapping("/add")
    public Result<Void> addNotice(@RequestBody Notice notice) {
        notice.setCreateTime(LocalDateTime.now());
        notice.setUpdateTime(LocalDateTime.now());
        noticeMapper.insert(notice);
        return Result.success("添加成功", null);
    }

    /**
     * 更新公告
     */
    @PutMapping("/update")
    public Result<Void> updateNotice(@RequestBody Notice notice) {
        notice.setUpdateTime(LocalDateTime.now());
        noticeMapper.updateById(notice);
        return Result.success("更新成功", null);
    }

    /**
     * 删除公告
     */
    @DeleteMapping("/delete/{id}")
    public Result<Void> deleteNotice(@PathVariable Long id) {
        noticeMapper.deleteById(id);
        return Result.success("删除成功", null);
    }

    /**
     * 启用/禁用公告
     */
    @PutMapping("/toggle/{id}")
    public Result<Void> toggleNotice(@PathVariable Long id) {
        Notice notice = noticeMapper.selectById(id);
        if (notice == null) {
            return Result.error("公告不存在");
        }
        notice.setStatus(notice.getStatus() == 1 ? 0 : 1);
        notice.setUpdateTime(LocalDateTime.now());
        noticeMapper.updateById(notice);
        return Result.success("操作成功", null);
    }
}
