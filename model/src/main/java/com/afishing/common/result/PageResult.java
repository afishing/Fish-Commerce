package com.afishing.common.result;

import lombok.Data;

import java.io.Serializable;
import java.util.List;

/**
 * 分页结果
 */
@Data
public class PageResult<T> implements Serializable {

    private List<T> list;
    private List<T> data;
    private Long total;
    private Integer page;
    private Integer size;
    private Integer pages;

    public PageResult() {
    }

    public PageResult(List<T> data, Long total, Integer page, Integer size) {
        this.data = data;
        this.list = data;
        this.total = total;
        this.page = page;
        this.size = size;
        this.pages = size > 0 ? (int) Math.ceil((double) total / size) : 0;
    }

    public static <T> PageResult<T> of(List<T> data, Long total, Integer page, Integer size) {
        return new PageResult<>(data, total, page, size);
    }
}
