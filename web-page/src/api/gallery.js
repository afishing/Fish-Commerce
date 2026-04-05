import request from './request'

// ========== 图库管理 ==========

// 获取图库列表
export function getGalleryList(params) {
  return request({
    url: '/upload/list',
    method: 'get',
    params
  })
}

// 上传图片
export function uploadGalleryImage(data) {
  return request({
    url: '/upload',
    method: 'post',
    data,
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}

// 删除图片
export function deleteGalleryImage(id) {
  return request({
    url: `/upload?filename=${id}`,
    method: 'delete'
  })
}

// 更新图片信息
export function updateGalleryImage(id, data) {
  return request({
    url: '/upload/remark',
    method: 'put',
    params: { id, remark: data.remark }
  })
}
