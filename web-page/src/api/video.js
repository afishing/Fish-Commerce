import request from './request'

// ========== 视频管理 ==========

// 获取视频列表
export function getVideoList(params) {
  return request({
    url: '/video/list',
    method: 'get',
    params
  })
}

// 上传视频
export function uploadVideo(data) {
  return request({
    url: '/video',
    method: 'post',
    data,
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}

// 删除视频
export function deleteVideo(id) {
  return request({
    url: `/video/${id}`,
    method: 'delete'
  })
}

// 更新视频信息
export function updateVideo(id, data) {
  return request({
    url: `/video/${id}`,
    method: 'put',
    data
  })
}
