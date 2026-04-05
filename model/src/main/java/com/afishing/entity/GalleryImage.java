package com.afishing.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 图库图片实体类
 */
@Data
@TableName("gallery_image")
public class GalleryImage {

    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 文件名 (UUID 格式)
     */
    private String filename;
    
    /**
     * 原始文件名
     */
    private String originalFilename;
    
    /**
     * 访问 URL
     */
    private String url;

    /**
     * 文件大小(字节)
     */
    private Long size;

    /**
     * 文件类型(MIME)
     */
    private String contentType;

    /**
     * 备注
     */
    private String remark;

    /**
     * 图片标题
     */
    private String title;

    /**
     * 图片描述
     */
    private String description;

    /**
     * 分类：0-其他，1-商品图片，2-轮播图，3-宣传图片
     */
    private Integer category;

    /**
     * 创建时间
     */
    private LocalDateTime createTime;
}