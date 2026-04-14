import request from './request'

// ========== 图库相关 ==========

// 获取图库列表（分页）
export function getGalleryList(params) {
  return request({
    url: '/api/gallery/list',
    method: 'get',
    params
  })
}

// 获取所有图片
export function getAllImages() {
  return request({
    url: '/api/gallery/all',
    method: 'get'
  })
}

// 上传图片
export function uploadImage(file) {
  const formData = new FormData()
  formData.append('file', file)
  return request({
    url: '/api/gallery/upload',
    method: 'post',
    data: formData,
    headers: { 'Content-Type': 'multipart/form-data' }
  })
}

// 删除图片
export function deleteGalleryImage(id) {
  return request({
    url: `/api/gallery/delete/${id}`,
    method: 'delete'
  })
}

// 批量删除图片
export function batchDeleteGalleryImages(ids) {
  return request({
    url: '/api/gallery/delete/batch',
    method: 'post',
    data: ids
  })
}

// 更新图片信息
export function updateGalleryImage(data) {
  return request({
    url: '/api/gallery/update',
    method: 'put',
    data
  })
}
