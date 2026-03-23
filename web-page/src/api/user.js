import request from './request'

// 用户登录
export function login(data) {
  return request({
    url: '/login',
    method: 'post',
    data
  })
}

// 用户注册
export function register(data) {
  return request({
    url: '/register',
    method: 'post',
    data
  })
}

// 获取用户信息
export function getUserInfo(id) {
  return request({
    url: `/info/${id}`,
    method: 'get'
  })
}

// 更新用户信息
export function updateUserInfo(data) {
  return request({
    url: '/update',
    method: 'put',
    data
  })
}

// 修改密码
export function updatePassword(data) {
  return request({
    url: '/password',
    method: 'post',
    data
  })
}

// 修改手机号
export function updatePhone(data) {
  return request({
    url: '/phone',
    method: 'post',
    data
  })
}

// 修改邮箱
export function updateEmail(data) {
  return request({
    url: '/email',
    method: 'post',
    data
  })
}
