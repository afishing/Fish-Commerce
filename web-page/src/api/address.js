import axios from 'axios'
import { ElMessage } from 'element-plus'

// 地址服务请求实例 - 通过Gateway网关访问
const addressRequest = axios.create({
  baseURL: 'http://localhost:5000/api/address',
  timeout: 10000
})

// 请求拦截器 - 携带token
addressRequest.interceptors.request.use(
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
addressRequest.interceptors.response.use(
  response => {
    const res = response.data
    if (res.code === 200 || res.code === 0) {
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

// 获取收货地址列表
export function getAddressList(userId) {
  return addressRequest({
    url: `/list/${userId}`,
    method: 'get'
  })
}

// 添加收货地址
export function addAddress(data) {
  return addressRequest({
    url: '/add',
    method: 'post',
    data
  })
}

// 更新收货地址
export function updateAddress(data) {
  return addressRequest({
    url: '/update',
    method: 'put',
    data
  })
}

// 删除收货地址
export function deleteAddress(id, userId) {
  return addressRequest({
    url: `/delete/${id}`,
    method: 'delete',
    params: { userId }
  })
}

// 设置默认地址
export function setDefaultAddress(id, userId) {
  return addressRequest({
    url: `/default/${id}`,
    method: 'post',
    params: { userId }
  })
}
