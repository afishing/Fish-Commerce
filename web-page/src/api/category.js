import request from './request'

// 获取所有分类
export function getAllCategories() {
  return request({
    url: '/api/category/list',
    method: 'get'
  })
}

// 获取分类列表（Home.vue 使用）
export function getCategoryList() {
  return request({
    url: '/api/category/list',
    method: 'get'
  })
}

// 添加分类
export function addCategory(data) {
  return request({
    url: '/api/category',
    method: 'post',
    data
  })
}

// 更新分类
export function updateCategory(id, data) {
  return request({
    url: `/api/category/${id}`,
    method: 'put',
    data
  })
}

// 删除分类
export function deleteCategory(id) {
  return request({
    url: `/api/category/${id}`,
    method: 'delete'
  })
}
