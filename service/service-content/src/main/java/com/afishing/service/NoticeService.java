package com.afishing.service;

import com.afishing.common.result.Result;
import com.afishing.entity.Notice;

import java.util.List;

public interface NoticeService {

    /**
     * 获取所有公告列表
     */
    Result<List<Notice>> listAll();

    /**
     * 获取启用的公告列表
     */
    Result<List<Notice>> listEnabled();

    /**
     * 根据ID获取公告
     */
    Result<Notice> getById(Long id);

    /**
     * 创建公告
     */
    Result<Void> create(Notice notice);

    /**
     * 更新公告
     */
    Result<Void> update(Notice notice);

    /**
     * 删除公告
     */
    Result<Void> delete(Long id);

    /**
     * 更新公告状态
     */
    Result<Void> updateStatus(Long id, Integer enabled);
}