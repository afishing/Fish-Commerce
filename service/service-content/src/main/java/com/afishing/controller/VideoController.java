package com.afishing.controller;

import com.afishing.common.result.Result;
import com.afishing.entity.Video;
import com.afishing.mapper.VideoMapper;
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

/**
 * 视频管理控制器
 */
@RestController
@RequestMapping("/video")
public class VideoController {

    @Autowired
    private VideoMapper videoMapper;

    @Value("${file.upload.path:E:/Desktop/Code/afishing/Fish-Commerce/uploads/}")
    private String uploadPath;

    /**
     * 获取视频列表（分页）
     */
    @GetMapping("/list")
    public Result<Page<Video>> getVideoList(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size) {
        Page<Video> pageObj = new Page<>(page, size);
        LambdaQueryWrapper<Video> wrapper = new LambdaQueryWrapper<>();
        wrapper.orderByDesc(Video::getCreateTime);
        Page<Video> result = videoMapper.selectPage(pageObj, wrapper);
        return Result.success(result);
    }

    /**
     * 获取启用的视频列表
     */
    @GetMapping("/active")
    public Result<List<Video>> getActiveVideos() {
        LambdaQueryWrapper<Video> wrapper = new LambdaQueryWrapper<>();
        wrapper.orderByDesc(Video::getCreateTime);
        List<Video> videos = videoMapper.selectList(wrapper);
        return Result.success(videos);
    }

    /**
     * 获取视频详情
     */
    @GetMapping("/{id}")
    public Result<Video> getVideoById(@PathVariable Long id) {
        Video video = videoMapper.selectById(id);
        if (video == null) {
            return Result.error("视频不存在");
        }
        return Result.success(video);
    }

    /**
     * 添加视频
     */
    @PostMapping("/add")
    public Result<Void> addVideo(@RequestBody Video video) {
        video.setCreateTime(LocalDateTime.now());
        video.setUpdateTime(LocalDateTime.now());
        videoMapper.insert(video);
        return Result.success("添加成功", null);
    }

    /**
     * 上传视频
     */
    @PostMapping("/upload")
    public Result<Video> uploadVideo(@RequestParam("file") MultipartFile file,
                                     @RequestParam(required = false) String title,
                                     @RequestParam(required = false) String description) {
        if (file.isEmpty()) {
            return Result.error("请选择文件");
        }

        try {
            String originalFilename = file.getOriginalFilename();
            String extension = originalFilename.substring(originalFilename.lastIndexOf("."));
            String filename = java.util.UUID.randomUUID().toString() + extension;

            File dest = new File(uploadPath + "videos/" + filename);
            if (!dest.getParentFile().exists()) {
                dest.getParentFile().mkdirs();
            }
            file.transferTo(dest);

            Video video = new Video();
            video.setTitle(title != null ? title : originalFilename);
            video.setFilename(filename);
            video.setOriginalName(originalFilename);
            video.setUrl("/uploads/videos/" + filename);
            video.setSize(file.getSize());
            video.setMimeType(file.getContentType());
            video.setDescription(description);
            video.setCreateTime(LocalDateTime.now());
            video.setUpdateTime(LocalDateTime.now());
            videoMapper.insert(video);

            return Result.success(video);
        } catch (IOException e) {
            return Result.error("上传失败：" + e.getMessage());
        }
    }

    /**
     * 更新视频
     */
    @PutMapping("/update")
    public Result<Void> updateVideo(@RequestBody Video video) {
        video.setUpdateTime(LocalDateTime.now());
        videoMapper.updateById(video);
        return Result.success("更新成功", null);
    }

    /**
     * 删除视频
     */
    @DeleteMapping("/delete/{id}")
    public Result<Void> deleteVideo(@PathVariable Long id) {
        Video video = videoMapper.selectById(id);
        if (video != null && video.getUrl() != null) {
            // 删除文件
            String filename = video.getUrl().replace("/uploads/", "");
            File file = new File(uploadPath + filename);
            if (file.exists()) {
                file.delete();
            }
        }
        videoMapper.deleteById(id);
        return Result.success("删除成功", null);
    }
}
