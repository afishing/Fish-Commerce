package com.afishing.service.impl;

import com.afishing.common.result.Result;
import com.afishing.entity.Video;
import com.afishing.mapper.VideoMapper;
import com.afishing.service.VideoService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class VideoServiceImpl implements VideoService {

    @Autowired
    private VideoMapper videoMapper;

    @Override
    public Result<List<Video>> listAll() {
        List<Video> videos = videoMapper.selectList(
                new LambdaQueryWrapper<Video>().orderByDesc(Video::getCreateTime)
        );
        return Result.success("获取成功", videos);
    }

    @Override
    public Result<List<Video>> listPublished() {
        List<Video> videos = videoMapper.selectList(
                new LambdaQueryWrapper<Video>()
                        .eq(Video::getStatus, 1)
                        .orderByDesc(Video::getCreateTime)
        );
        return Result.success("获取成功", videos);
    }

    @Override
    public Result<Video> getById(Long id) {
        Video video = videoMapper.selectById(id);
        if (video == null) {
            return Result.error("视频不存在");
        }
        return Result.success("获取成功", video);
    }

    @Override
    public Result<Void> create(Video video) {
        video.setCreateTime(LocalDateTime.now());
        video.setUpdateTime(LocalDateTime.now());
        if (video.getStatus() == null) {
            video.setStatus(0);
        }
        if (video.getViewCount() == null) {
            video.setViewCount(0);
        }
        videoMapper.insert(video);
        return Result.success("创建成功", null);
    }

    @Override
    public Result<Void> update(Video video) {
        Video existing = videoMapper.selectById(video.getId());
        if (existing == null) {
            return Result.error("视频不存在");
        }
        video.setUpdateTime(LocalDateTime.now());
        videoMapper.updateById(video);
        return Result.success("更新成功", null);
    }

    @Override
    public Result<Void> delete(Long id) {
        Video existing = videoMapper.selectById(id);
        if (existing == null) {
            return Result.error("视频不存在");
        }
        videoMapper.deleteById(id);
        return Result.success("删除成功", null);
    }

    @Override
    public Result<Void> updateStatus(Long id, Integer status) {
        Video existing = videoMapper.selectById(id);
        if (existing == null) {
            return Result.error("视频不存在");
        }
        Video video = new Video();
        video.setId(id);
        video.setStatus(status);
        video.setUpdateTime(LocalDateTime.now());
        videoMapper.updateById(video);
        String msg = status == 1 ? "已发布" : "已下架";
        return Result.success(msg, null);
    }

    @Override
    public Result<Void> incrementViewCount(Long id) {
        Video existing = videoMapper.selectById(id);
        if (existing == null) {
            return Result.error("视频不存在");
        }
        Video video = new Video();
        video.setId(id);
        video.setViewCount(existing.getViewCount() + 1);
        videoMapper.updateById(video);
        return Result.success("已增加浏览次数", null);
    }
}