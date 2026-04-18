import axios from 'axios'
import { ElMessage } from 'element-plus'

// 购物车服务请求实例 - 通过Gateway网关访问
const cartRequest = axios.create({
  baseURL: (import.meta.env.VITE_API_BASE_URL || '') + '/api/cart',
  timeout: 10000
})

// 请求拦截器 - 携带token
cartRequest.interceptors.request.use(
  config => {
    const token = localStorage.getItem('token')
    if (token) {
      config.headers['Authorization'] = `Bearer ${token}`
    }
    return config
  },
  error => {
    return Promise.reject(error)
  }
)

// 响应拦截器
cartRequest.interceptors.response.use(
  response => {
    const res = response.data
    if (res.code === 200) {
      return res
    } else {
      ElMessage.error(res.message || '请求失败')
      return Promise.reject(new Error(res.message || '请求失败'))
    }
  },
  error => {
    ElMessage.error(error.message || '网络错误')
    return Promise.reject(error)
  }
)

// 获取购物车列表
export function getCartList(userId) {
  return cartRequest({
    url: `/list/${userId}`,
    method: 'get'
  })
}

// 添加商品到购物车
export function addToCart(data) {
  return cartRequest({
    url: '/add',
    method: 'post',
    data
  })
}

// 更新购物车商品数量
export function updateCart(data) {
  return cartRequest({
    url: '/update',
    method: 'put',
    data
  })
}

// 删除购物车商品
export function deleteCart(id) {
  return cartRequest({
    url: `/delete/${id}`,
    method: 'delete'
  })
}

// 批量删除购物车商品
export function batchDeleteCart(ids) {
  return cartRequest({
    url: '/batch',
    method: 'delete',
    data: ids
  })
}

// 清空购物车
export function clearCart(userId) {
  return cartRequest({
    url: `/clear/${userId}`,
    method: 'delete'
  })
}
