package com.afishing.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 视频实体
 */
@Data
@TableName("video")
public class Video {

    @TableId(type = IdType.AUTO)
    private Long id;

    private String title;

    private String filename;

    private String originalName;

    private String url;

    private Long size;

    private Integer duration;

    private String mimeType;

    private String description;

    private String coverUrl;

    private LocalDateTime createTime;

    private LocalDateTime updateTime;

    @TableLogic
    private Integer deleted;
}
