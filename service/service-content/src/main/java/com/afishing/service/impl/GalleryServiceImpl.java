package com.afishing.service.impl;

import com.afishing.common.result.Result;
import com.afishing.entity.GalleryImage;
import com.afishing.mapper.GalleryImageMapper;
import com.afishing.service.GalleryService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class GalleryServiceImpl implements GalleryService {

    @Autowired
    private GalleryImageMapper galleryImageMapper;

    @Override
    public void saveImage(String filename, String originalFilename, String url, Long size, String contentType) {
        GalleryImage image = new GalleryImage();
        image.setFilename(filename);
        image.setOriginalName(originalFilename);
        image.setUrl(url);
        image.setSize(size);
        image.setCreateTime(LocalDateTime.now());
        image.setUpdateTime(LocalDateTime.now());
        galleryImageMapper.insert(image);
    }

    @Override
    public void saveImageWithDetails(String filename, String originalFilename, String url, Long size,
                                     String contentType, String title, String description, Integer category) {
        GalleryImage image = new GalleryImage();
        image.setFilename(filename);
        image.setOriginalName(originalFilename);
        image.setUrl(url);
        image.setSize(size);
        image.setCreateTime(LocalDateTime.now());
        image.setUpdateTime(LocalDateTime.now());
        galleryImageMapper.insert(image);
    }

    @Override
    public Result<List<GalleryImage>> listImages() {
        List<GalleryImage> images = galleryImageMapper.selectList(
                new LambdaQueryWrapper<GalleryImage>().orderByDesc(GalleryImage::getCreateTime)
        );
        return Result.success("获取成功", images);
    }

    @Override
    public Result<Void> deleteImageByFilename(String filename) {
        GalleryImage image = galleryImageMapper.selectOne(
                new LambdaQueryWrapper<GalleryImage>().eq(GalleryImage::getFilename, filename)
        );
        if (image == null) {
            return Result.error("图片不存在");
        }
        galleryImageMapper.deleteById(image.getId());
        return Result.success("删除成功", null);
    }

    @Override
    public Result<Void> updateRemark(Long id, String remark) {
        GalleryImage image = galleryImageMapper.selectById(id);
        if (image == null) {
            return Result.error("图片不存在");
        }
        GalleryImage update = new GalleryImage();
        update.setId(id);
        update.setUpdateTime(LocalDateTime.now());
        galleryImageMapper.updateById(update);
        return Result.success("更新成功", null);
    }
}