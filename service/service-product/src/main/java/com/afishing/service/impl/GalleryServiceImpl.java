package com.afishing.service.impl;

import com.afishing.common.result.Result;
import com.afishing.entity.GalleryImage;
import com.afishing.mapper.GalleryImageMapper;
import com.afishing.service.GalleryService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 图库服务实现
 */
@Slf4j
@Service
public class GalleryServiceImpl implements GalleryService {

    @Autowired
    private GalleryImageMapper galleryImageMapper;

    @Override
    public void saveImage(String filename, String originalFilename, String url, Long fileSize, String contentType) {
        GalleryImage image = new GalleryImage();
        image.setFilename(filename);
        image.setOriginalName(originalFilename);
        image.setUrl(url);
        image.setSize(fileSize);
        image.setCreateTime(LocalDateTime.now());
        image.setUpdateTime(LocalDateTime.now());
        galleryImageMapper.insert(image);
    }

    @Override
    public Result<List<GalleryImage>> listImages() {
        LambdaQueryWrapper<GalleryImage> wrapper = new LambdaQueryWrapper<>();
        wrapper.orderByDesc(GalleryImage::getCreateTime);
        List<GalleryImage> images = galleryImageMapper.selectList(wrapper);
        return Result.success(images);
    }

    @Override
    public Result<Void> deleteImageByFilename(String filename) {
        LambdaQueryWrapper<GalleryImage> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(GalleryImage::getFilename, filename);
        int deleted = galleryImageMapper.delete(wrapper);
        if (deleted > 0) {
            return Result.success("删除成功", null);
        }
        return Result.error("图片记录不存在");
    }

    @Override
    public Result<Void> updateRemark(Long id, String remark) {
        // remark field no longer exists, just update updateTime
        GalleryImage image = galleryImageMapper.selectById(id);
        if (image == null) {
            return Result.error("图片不存在");
        }
        image.setUpdateTime(LocalDateTime.now());
        galleryImageMapper.updateById(image);
        return Result.success("更新成功", null);
    }
}
