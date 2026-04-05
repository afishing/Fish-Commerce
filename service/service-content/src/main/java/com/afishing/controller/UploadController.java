package com.afishing.controller;

import com.afishing.common.result.Result;
import com.afishing.entity.GalleryImage;
import com.afishing.service.GalleryService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;

/**
 * 文件上传控制器
 */
@Slf4j
@RestController
@RequestMapping("/upload")
public class UploadController {

    @Value("${file.upload.path:E:/Desktop/Code/afishing/Fish-Commerce/uploads/}")
    private String uploadPath;

    @Value("${file.access.url:/uploads/}")
    private String accessUrl;

    @Autowired
    private GalleryService galleryService;

    /**
     * 上传图片并写入图库记录
     */
    @PostMapping
    public Result<String> uploadImage(
            @RequestParam("file") MultipartFile file,
            @RequestParam(value = "title", required = false) String title,
            @RequestParam(value = "description", required = false) String description,
            @RequestParam(value = "category", required = false, defaultValue = "0") Integer category) {
        if (file.isEmpty()) {
            return Result.error("请选择要上传的文件");
        }
    
        // 检查文件类型
        String contentType = file.getContentType();
        if (contentType == null || !contentType.startsWith("image/")) {
            return Result.error("只能上传图片文件");
        }
    
        try {
            // 创建上传目录
            Path uploadDir = Paths.get(uploadPath).toAbsolutePath().normalize();
            if (!Files.exists(uploadDir)) {
                Files.createDirectories(uploadDir);
            }
    
            // 生成文件名
            String originalFilename = file.getOriginalFilename();
            String extension = originalFilename != null
                    ? originalFilename.substring(originalFilename.lastIndexOf("."))
                    : ".jpg";
            String filename = UUID.randomUUID().toString() + extension;
    
            // 保存文件到磁盘
            Path targetPath = uploadDir.resolve(filename);
            file.transferTo(targetPath.toFile());
    
            // 构建访问 URL
            String fileUrl = accessUrl + filename;
    
            // 写入图库数据库记录
            galleryService.saveImageWithDetails(
                    filename,
                    originalFilename,
                    fileUrl,
                    file.getSize(),
                    contentType,
                    title,
                    description,
                    category
            );
    
            log.info("图片上传成功：{}", fileUrl);
            return Result.success("上传成功", fileUrl);
        } catch (IOException e) {
            log.error("图片上传失败", e);
            return Result.error("图片上传失败：" + e.getMessage());
        }
    }

    /**
     * 获取图库图片列表
     */
    @GetMapping("/list")
    public Result<List<GalleryImage>> listImages() {
        return galleryService.listImages();
    }

    /**
     * 删除图库图片（物理文件 + 数据库记录）
     */
    @DeleteMapping
    public Result<Void> deleteImage(@RequestParam("filename") String filename) {
        try {
            // 删除磁盘文件
            Path uploadDir = Paths.get(uploadPath).toAbsolutePath().normalize();
            Path filePath = uploadDir.resolve(filename);
            Files.deleteIfExists(filePath);
        } catch (IOException e) {
            log.warn("物理文件删除失败: {}", filename, e);
        }
        // 删除数据库记录
        return galleryService.deleteImageByFilename(filename);
    }

    /**
     * 更新图片备注
     */
    @PutMapping("/remark")
    public Result<Void> updateRemark(@RequestParam("id") Long id,
                                     @RequestParam(value = "remark", required = false, defaultValue = "") String remark) {
        return galleryService.updateRemark(id, remark);
    }
}