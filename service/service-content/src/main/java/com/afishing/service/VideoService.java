package com.afishing.service;

import com.afishing.common.result.Result;
import com.afishing.entity.Video;

import java.util.List;

public interface VideoService {

    /**
     * 获取所有视频列表
     */
    Result<List<Video>> listAll();

    /**
     * 获取已发布的视频列表
     */
    Result<List<Video>> listPublished();

    /**
     * 根据ID获取视频
     */
    Result<Video> getById(Long id);

    /**
     * 创建视频
     */
    Result<Void> create(Video video);

    /**
     * 更新视频
     */
    Result<Void> update(Video video);

    /**
     * 删除视频
     */
    Result<Void> delete(Long id);

    /**
     * 更新视频状态
     */
    Result<Void> updateStatus(Long id, Integer status);

    /**
     * 增加浏览次数
     */
    Result<Void> incrementViewCount(Long id);
}