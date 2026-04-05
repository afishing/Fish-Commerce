import request from './request'

// ========== 视频相关 ==========

// 获取视频列表（分页）
export function getVideoList(params) {
  return request({
    url: '/api/video/list',
    method: 'get',
    params
  })
}

// 获取启用的视频列表
export function getActiveVideos() {
  return request({
    url: '/api/video/active',
    method: 'get'
  })
}

// 获取视频详情
export function getVideoById(id) {
  return request({
    url: `/api/video/${id}`,
    method: 'get'
  })
}

// 添加视频
export function addVideo(data) {
  return request({
    url: '/api/video/add',
    method: 'post',
    data
  })
}

// 上传视频
export function uploadVideo(file, title, description) {
  const formData = new FormData()
  formData.append('file', file)
  if (title) formData.append('title', title)
  if (description) formData.append('description', description)
  return request({
    url: '/api/video/upload',
    method: 'post',
    data: formData,
    headers: { 'Content-Type': 'multipart/form-data' }
  })
}

// 更新视频
export function updateVideo(data) {
  return request({
    url: '/api/video/update',
    method: 'put',
    data
  })
}

// 删除视频
export function deleteVideo(id) {
  return request({
    url: `/api/video/delete/${id}`,
    method: 'delete'
  })
}
