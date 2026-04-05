package com.afishing.service.impl;

import com.afishing.common.result.Result;
import com.afishing.entity.Notice;
import com.afishing.mapper.NoticeMapper;
import com.afishing.service.NoticeService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class NoticeServiceImpl implements NoticeService {

    @Autowired
    private NoticeMapper noticeMapper;

    @Override
    public Result<List<Notice>> listAll() {
        List<Notice> notices = noticeMapper.selectList(
                new LambdaQueryWrapper<Notice>().orderByDesc(Notice::getCreateTime)
        );
        return Result.success("获取成功", notices);
    }

    @Override
    public Result<List<Notice>> listEnabled() {
        List<Notice> notices = noticeMapper.selectList(
                new LambdaQueryWrapper<Notice>()
                        .eq(Notice::getEnabled, 1)
                        .orderByDesc(Notice::getCreateTime)
        );
        return Result.success("获取成功", notices);
    }

    @Override
    public Result<Notice> getById(Long id) {
        Notice notice = noticeMapper.selectById(id);
        if (notice == null) {
            return Result.error("公告不存在");
        }
        return Result.success("获取成功", notice);
    }

    @Override
    public Result<Void> create(Notice notice) {
        notice.setCreateTime(LocalDateTime.now());
        notice.setUpdateTime(LocalDateTime.now());
        if (notice.getEnabled() == null) {
            notice.setEnabled(1);
        }
        noticeMapper.insert(notice);
        return Result.success("创建成功", null);
    }

    @Override
    public Result<Void> update(Notice notice) {
        Notice existing = noticeMapper.selectById(notice.getId());
        if (existing == null) {
            return Result.error("公告不存在");
        }
        notice.setUpdateTime(LocalDateTime.now());
        noticeMapper.updateById(notice);
        return Result.success("更新成功", null);
    }

    @Override
    public Result<Void> delete(Long id) {
        Notice existing = noticeMapper.selectById(id);
        if (existing == null) {
            return Result.error("公告不存在");
        }
        noticeMapper.deleteById(id);
        return Result.success("删除成功", null);
    }

    @Override
    public Result<Void> updateStatus(Long id, Integer enabled) {
        Notice existing = noticeMapper.selectById(id);
        if (existing == null) {
            return Result.error("公告不存在");
        }
        Notice notice = new Notice();
        notice.setId(id);
        notice.setEnabled(enabled);
        notice.setUpdateTime(LocalDateTime.now());
        noticeMapper.updateById(notice);
        return Result.success(enabled == 1 ? "已启用" : "已禁用", null);
    }
}