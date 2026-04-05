package com.afishing.controller;

import com.afishing.common.result.Result;
import com.afishing.entity.GalleryImage;
import com.afishing.mapper.GalleryImageMapper;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

/**
 * 图库管理控制器
 */
@RestController
@RequestMapping("/gallery")
public class GalleryController {

    @Autowired
    private GalleryImageMapper galleryImageMapper;

    @Value("${file.upload.path:E:/Desktop/Code/afishing/Fish-Commerce/uploads/}")
    private String uploadPath;

    /**
     * 获取图片列表（分页）
     */
    @GetMapping("/list")
    public Result<Page<GalleryImage>> getImageList(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "20") Integer size) {
        Page<GalleryImage> pageObj = new Page<>(page, size);
        LambdaQueryWrapper<GalleryImage> wrapper = new LambdaQueryWrapper<>();
        wrapper.orderByDesc(GalleryImage::getCreateTime);
        Page<GalleryImage> result = galleryImageMapper.selectPage(pageObj, wrapper);
        return Result.success(result);
    }

    /**
     * 获取所有图片
     */
    @GetMapping("/all")
    public Result<List<GalleryImage>> getAllImages() {
        List<GalleryImage> images = galleryImageMapper.selectList(null);
        return Result.success(images);
    }

    /**
     * 上传图片
     */
    @PostMapping("/upload")
    public Result<GalleryImage> uploadImage(@RequestParam("file") MultipartFile file) {
        if (file.isEmpty()) {
            return Result.error("请选择文件");
        }

        try {
            String originalFilename = file.getOriginalFilename();
            String extension = originalFilename.substring(originalFilename.lastIndexOf("."));
            String filename = UUID.randomUUID().toString() + extension;

            File dest = new File(uploadPath + filename);
            if (!dest.getParentFile().exists()) {
                dest.getParentFile().mkdirs();
            }
            file.transferTo(dest);

            GalleryImage image = new GalleryImage();
            image.setFilename(filename);
            image.setOriginalName(originalFilename);
            image.setUrl("/uploads/" + filename);
            image.setSize(file.getSize());
            image.setCreateTime(LocalDateTime.now());
            image.setUpdateTime(LocalDateTime.now());
            galleryImageMapper.insert(image);

            return Result.success(image);
        } catch (IOException e) {
            return Result.error("上传失败：" + e.getMessage());
        }
    }

    /**
     * 删除图片
     */
    @DeleteMapping("/delete/{id}")
    public Result<Void> deleteImage(@PathVariable Long id) {
        GalleryImage image = galleryImageMapper.selectById(id);
        if (image != null) {
            // 删除文件
            File file = new File(uploadPath + image.getFilename());
            if (file.exists()) {
                file.delete();
            }
            galleryImageMapper.deleteById(id);
        }
        return Result.success("删除成功", null);
    }

    /**
     * 批量删除图片
     */
    @DeleteMapping("/delete/batch")
    public Result<Void> batchDeleteImages(@RequestBody List<Long> ids) {
        for (Long id : ids) {
            GalleryImage image = galleryImageMapper.selectById(id);
            if (image != null) {
                File file = new File(uploadPath + image.getFilename());
                if (file.exists()) {
                    file.delete();
                }
                galleryImageMapper.deleteById(id);
            }
        }
        return Result.success("批量删除成功", null);
    }

    /**
     * 更新图片信息
     */
    @PutMapping("/update")
    public Result<Void> updateImage(@RequestBody GalleryImage image) {
        galleryImageMapper.updateById(image);
        return Result.success("更新成功", null);
    }
}
