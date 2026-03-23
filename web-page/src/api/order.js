import axios from 'axios'
import { ElMessage } from 'element-plus'

// 订单服务请求实例 - 通过Gateway网关访问
const orderRequest = axios.create({
  baseURL: 'http://localhost:5000/api/order',
  timeout: 10000
})

// 请求拦截器 - 携带token
orderRequest.interceptors.request.use(
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
orderRequest.interceptors.response.use(
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

// 获取订单列表
export function getOrderList(userId, status) {
  return orderRequest({
    url: `/list/${userId}`,
    method: 'get',
    params: { status }
  })
}

// 获取订单详情
export function getOrderDetail(id) {
  return orderRequest({
    url: `/detail/${id}`,
    method: 'get'
  })
}

// 创建订单
export function createOrder(data) {
  return orderRequest({
    url: '/create',
    method: 'post',
    data
  })
}

// 创建订单（带订单项）
export function createOrderWithItems(data) {
  return orderRequest({
    url: '/createWithItems',
    method: 'post',
    data
  })
}

// 支付订单
export function payOrder(id) {
  return orderRequest({
    url: `/pay/${id}`,
    method: 'put'
  })
}

// 取消订单
export function cancelOrder(id) {
  return orderRequest({
    url: `/cancel/${id}`,
    method: 'put'
  })
}

// 确认收货
export function confirmOrder(id) {
  return orderRequest({
    url: `/confirm/${id}`,
    method: 'put'
  })
}

// 删除订单
export function deleteOrder(id) {
  return orderRequest({
    url: `/delete/${id}`,
    method: 'delete'
  })
}

// 支付服务请求实例 - 通过Gateway网关访问
const payRequest = axios.create({
  baseURL: 'http://localhost:5000/api/payment',
  timeout: 10000
})

// 请求拦截器 - 携带token
payRequest.interceptors.request.use(
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

// 支付服务响应拦截器
payRequest.interceptors.response.use(
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

// 创建支付记录
export function createPayment(orderId, payType) {
  return payRequest({
    url: `/create/${orderId}`,
    method: 'post',
    params: { payType }
  })
}

// 确认支付
export function confirmPayment(orderId) {
  return payRequest({
    url: `/confirm/${orderId}`,
    method: 'put'
  })
}

// 取消支付
export function cancelPayment(orderId) {
  return payRequest({
    url: `/cancel/${orderId}`,
    method: 'put'
  })
}
