import request from './request'

// ========== 公告管理 ==========

// 获取公告列表
export function getNoticeList(params) {
  return request({
    url: '/api/notice/list',
    method: 'get',
    params
  })
}

// 添加公告
export function addNotice(data) {
  return request({
    url: '/api/notice',
    method: 'post',
    data
  })
}

// 更新公告
export function updateNotice(id, data) {
  return request({
    url: `/api/notice/${id}`,
    method: 'put',
    data
  })
}

// 删除公告
export function deleteNotice(id) {
  return request({
    url: `/api/notice/${id}`,
    method: 'delete'
  })
}

// 获取启用的公告
export function getActiveNotices() {
  return request({
    url: '/api/notice/enabled',
    method: 'get'
  })
}
