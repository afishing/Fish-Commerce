package com.afishing.controller;

import com.afishing.common.result.Result;
import com.afishing.entity.Notice;
import com.afishing.service.NoticeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 公告控制器
 */
@RestController
@RequestMapping("/notice")
public class NoticeController {

    @Autowired
    private NoticeService noticeService;

    /**
     * 获取所有公告列表（管理端）
     */
    @GetMapping("/list")
    public Result<List<Notice>> list() {
        return noticeService.listAll();
    }

    /**
     * 获取启用的公告列表（前台展示）
     */
    @GetMapping("/enabled")
    public Result<List<Notice>> listEnabled() {
        return noticeService.listEnabled();
    }

    /**
     * 根据ID获取公告详情
     */
    @GetMapping("/{id}")
    public Result<Notice> getById(@PathVariable Long id) {
        return noticeService.getById(id);
    }

    /**
     * 创建公告
     */
    @PostMapping
    public Result<Void> create(@RequestBody Notice notice) {
        return noticeService.create(notice);
    }

    /**
     * 更新公告
     */
    @PutMapping("/{id}")
    public Result<Void> update(@PathVariable Long id, @RequestBody Notice notice) {
        notice.setId(id);
        return noticeService.update(notice);
    }

    /**
     * 删除公告
     */
    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        return noticeService.delete(id);
    }

    /**
     * 启用/禁用公告
     */
    @PutMapping("/{id}/status")
    public Result<Void> updateStatus(@PathVariable Long id, @RequestParam Integer enabled) {
        return noticeService.updateStatus(id, enabled);
    }
}