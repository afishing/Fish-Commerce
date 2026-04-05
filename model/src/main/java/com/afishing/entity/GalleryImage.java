package com.afishing.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.annotation.TableLogic;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 图库图片实体
 */
@Data
@TableName("gallery_image")
public class GalleryImage {

    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 文件名
     */
    private String filename;

    /**
     * 原始文件名
     */
    private String originalName;

    /**
     * 访问URL
     */
    private String url;

    /**
     * 文件大小
     */
    private Long size;

    /**
     * 创建时间
     */
    private LocalDateTime createTime;

    /**
     * 更新时间
     */
    private LocalDateTime updateTime;

    /**
     * 逻辑删除
     */
    @TableLogic
    private Integer deleted;
}
