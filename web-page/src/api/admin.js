import request from './request'

// ========== 管理员登录 ==========
export function adminLogin(data) {
  return request({
    url: '/api/admin/login',
    method: 'post',
    data
  })
}

// ========== 统计信息 ==========
export function getStatistics() {
  return request({
    url: '/api/admin/statistics',
    method: 'get'
  })
}

// ========== 用户管理 ==========
export function getUserList(data) {
  return request({
    url: '/api/admin/user/list',
    method: 'post',
    data
  })
}

export function disableUser(userId) {
  return request({
    url: `/api/admin/user/disable/${userId}`,
    method: 'put'
  })
}

export function enableUser(userId) {
  return request({
    url: `/api/admin/user/enable/${userId}`,
    method: 'put'
  })
}

// ========== 订单管理 ==========
export function getOrderList(params) {
  return request({
    url: '/api/admin/order/list',
    method: 'get',
    params
  })
}

export function shipOrder(orderId) {
  return request({
    url: `/api/admin/order/ship/${orderId}`,
    method: 'put'
  })
}

// ========== 商品管理 ==========
export function getProductList(params) {
  return request({
    url: '/api/admin/product/list',
    method: 'get',
    params
  })
}

export function addProduct(data) {
  return request({
    url: '/api/admin/product/add',
    method: 'post',
    data
  })
}

export function updateProduct(data) {
  return request({
    url: '/api/admin/product/update',
    method: 'put',
    data
  })
}

export function enableProduct(productId) {
  return request({
    url: `/api/admin/product/enable/${productId}`,
    method: 'put'
  })
}

export function disableProduct(productId) {
  return request({
    url: `/api/admin/product/disable/${productId}`,
    method: 'put'
  })
}

export function deleteProduct(productId) {
  return request({
    url: `/api/admin/product/delete/${productId}`,
    method: 'delete'
  })
}

// ========== 用户画像 ==========
export function getUserPortrait() {
  return request({
    url: '/api/admin/portrait',
    method: 'get'
  })
}
