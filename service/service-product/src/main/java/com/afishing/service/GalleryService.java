package com.afishing.service;

import com.afishing.common.result.Result;
import com.afishing.entity.GalleryImage;

import java.util.List;

/**
 * 图库服务接口
 */
public interface GalleryService {

    /**
     * 保存图片记录
     */
    void saveImage(String filename, String originalFilename, String url, Long size, String contentType);

    /**
     * 获取图库列表
     */
    Result<List<GalleryImage>> listImages();

    /**
     * 根据文件名删除图片
     */
    Result<Void> deleteImageByFilename(String filename);

    /**
     * 更新备注
     */
    Result<Void> updateRemark(Long id, String remark);
}