import request from './request'

// ========== 公告相关 ==========

// 获取公告列表（分页）
export function getNoticeList(params) {
  return request({
    url: '/api/notice/list',
    method: 'get',
    params
  })
}

// 获取有效公告列表
export function getActiveNotices() {
  return request({
    url: '/api/notice/active',
    method: 'get'
  })
}

// 获取公告详情
export function getNoticeById(id) {
  return request({
    url: `/api/notice/${id}`,
    method: 'get'
  })
}

// 添加公告
export function addNotice(data) {
  return request({
    url: '/api/notice/add',
    method: 'post',
    data
  })
}

// 更新公告
export function updateNotice(data) {
  return request({
    url: '/api/notice/update',
    method: 'put',
    data
  })
}

// 删除公告
export function deleteNotice(id) {
  return request({
    url: `/api/notice/delete/${id}`,
    method: 'delete'
  })
}

// 启用/禁用公告
export function toggleNotice(id) {
  return request({
    url: `/api/notice/toggle/${id}`,
    method: 'put'
  })
}
