import request from './request'

// 用户登录
export function login(data) {
  return request({
    url: '/api/user/login',
    method: 'post',
    data
  })
}

// 用户注册
export function register(data) {
  return request({
    url: '/api/user/register',
    method: 'post',
    data
  })
}

// 获取用户信息
export function getUserInfo(id) {
  return request({
    url: `/api/user/info/${id}`,
    method: 'get'
  })
}

// 更新用户信息
export function updateUserInfo(data) {
  return request({
    url: '/api/user/update',
    method: 'put',
    data
  })
}

// 修改密码
export function updatePassword(data) {
  return request({
    url: '/api/user/password',
    method: 'post',
    data
  })
}

// 修改手机号
export function updatePhone(data) {
  return request({
    url: '/api/user/phone',
    method: 'post',
    data
  })
}

// 修改邮箱
export function updateEmail(data) {
  return request({
    url: '/api/user/email',
    method: 'post',
    data
  })
}
