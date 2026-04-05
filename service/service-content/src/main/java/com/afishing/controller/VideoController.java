package com.afishing.controller;

import com.afishing.common.result.Result;
import com.afishing.entity.Video;
import com.afishing.service.VideoService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

/**
 * 视频控制器
 */
@Slf4j
@RestController
@RequestMapping("/video")
public class VideoController {

    @Autowired
    private VideoService videoService;

    @Value("${file.upload.path:E:/Desktop/Code/afishing/Fish-Commerce/uploads/}")
    private String uploadPath;

    @Value("${file.access.url:/uploads/}")
    private String accessUrl;

    /**
     * 获取所有视频列表
     */
    @GetMapping("/list")
    public Result<List<Video>> list() {
        return videoService.listAll();
    }

    /**
     * 获取已发布的视频列表（前台展示）
     */
    @GetMapping("/published")
    public Result<List<Video>> listPublished() {
        return videoService.listPublished();
    }

    /**
     * 根据ID获取视频详情
     */
    @GetMapping("/{id}")
    public Result<Video> getById(@PathVariable Long id) {
        return videoService.getById(id);
    }

    /**
     * 创建视频记录（通过上传视频文件）
     */
    @PostMapping
    public Result<Void> create(
            @RequestParam(value = "file", required = false) MultipartFile file,
            @RequestParam(value = "title", required = false) String title,
            @RequestParam(value = "description", required = false) String description,
            @RequestParam(value = "category", required = false, defaultValue = "0") Integer category) {
        
        String videoUrl = null;
        
        // 如果上传了视频文件
        if (file != null && !file.isEmpty()) {
            try {
                // 检查文件类型
                String contentType = file.getContentType();
                if (contentType == null || !contentType.startsWith("video/")) {
                    return Result.error("只能上传视频文件");
                }
                
                // 创建上传目录
                Path uploadDir = Paths.get(uploadPath + "videos/").toAbsolutePath().normalize();
                if (!java.nio.file.Files.exists(uploadDir)) {
                    java.nio.file.Files.createDirectories(uploadDir);
                }
                
                // 生成文件名
                String originalFilename = file.getOriginalFilename();
                String extension = originalFilename != null
                        ? originalFilename.substring(originalFilename.lastIndexOf("."))
                        : ".mp4";
                String filename = UUID.randomUUID().toString() + extension;
                
                // 保存文件到磁盘
                Path targetPath = uploadDir.resolve(filename);
                file.transferTo(targetPath.toFile());
                
                // 构建访问 URL
                videoUrl = accessUrl + "videos/" + filename;
                
                log.info("视频上传成功：{}", videoUrl);
            } catch (IOException e) {
                log.error("视频上传失败", e);
                return Result.error("视频上传失败：" + e.getMessage());
            }
        }
        
        // 创建视频记录
        Video video = new Video();
        video.setTitle(title);
        video.setDescription(description);
        video.setVideoUrl(videoUrl);
        video.setStatus(0); // 待审核
        video.setViewCount(0);
        video.setCreateTime(LocalDateTime.now());
        video.setUpdateTime(LocalDateTime.now());
        
        return videoService.create(video);
    }

    /**
     * 更新视频
     */
    @PutMapping("/{id}")
    public Result<Void> update(@PathVariable Long id, @RequestBody Video video) {
        video.setId(id);
        return videoService.update(video);
    }

    /**
     * 删除视频
     */
    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        return videoService.delete(id);
    }

    /**
     * 发布视频
     */
    @PutMapping("/{id}/publish")
    public Result<Void> publish(@PathVariable Long id) {
        return videoService.updateStatus(id, 1);
    }

    /**
     * 下架视频
     */
    @PutMapping("/{id}/unpublish")
    public Result<Void> unpublish(@PathVariable Long id) {
        return videoService.updateStatus(id, 2);
    }

    /**
     * 增加浏览次数
     */
    @PutMapping("/{id}/view")
    public Result<Void> incrementViewCount(@PathVariable Long id) {
        return videoService.incrementViewCount(id);
    }
}