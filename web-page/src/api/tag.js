import request from './request'

// ========== 标签相关 ==========

// 获取所有标签
export function getAllTags() {
  return request({
    url: '/api/tag/list',
    method: 'get'
  })
}

// 获取商品标签
export function getProductTags(productId) {
  return request({
    url: `/api/tag/product/${productId}`,
    method: 'get'
  })
}

// 设置商品标签
export function setProductTags(productId, tagIds) {
  return request({
    url: `/api/tag/product/${productId}`,
    method: 'post',
    data: tagIds
  })
}

// 添加标签
export function addTag(data) {
  return request({
    url: '/api/tag/add',
    method: 'post',
    data
  })
}

// 更新标签
export function updateTag(data) {
  return request({
    url: '/api/tag/update',
    method: 'put',
    data
  })
}

// 删除标签
export function deleteTag(id) {
  return request({
    url: `/api/tag/delete/${id}`,
    method: 'delete'
  })
}
