import request from './request'

// 获取所有标签
export function getAllTags() {
  return request({
    url: '/api/tag/list',
    method: 'get'
  })
}

// 获取商品的标签
export function getProductTags(productId) {
  return request({
    url: `/api/tag/product/${productId}`,
    method: 'get'
  })
}

// 设置商品标签
export function setProductTags(productId, tagIds) {
  return request({
    url: '/api/tag/product',
    method: 'post',
    data: { productId, tagIds }
  })
}

// 添加标签
export function addTag(data) {
  return request({
    url: '/api/tag',
    method: 'post',
    data
  })
}

// 更新标签
export function updateTag(id, data) {
  return request({
    url: `/api/tag/${id}`,
    method: 'put',
    data
  })
}

// 删除标签
export function deleteTag(id) {
  return request({
    url: `/api/tag/${id}`,
    method: 'delete'
  })
}
