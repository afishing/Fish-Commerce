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
                new LambdaQueryWrapper<Video>().orderByDesc(Video::getCreateTime)
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
        video.setUpdateTime(LocalDateTime.now());
        videoMapper.updateById(video);
        return Result.success("更新成功", null);
    }

    @Override
    public Result<Void> incrementViewCount(Long id) {
        Video existing = videoMapper.selectById(id);
        if (existing == null) {
            return Result.error("视频不存在");
        }
        return Result.success("操作成功", null);
    }
}