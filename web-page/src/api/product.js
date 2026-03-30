import axios from 'axios'
import { ElMessage } from 'element-plus'

// 商品服务请求实例 - 通过Gateway网关访问
const productRequest = axios.create({
  baseURL: 'http://localhost:5000/api/product',
  timeout: 10000
})

// 请求拦截器 - 携带token
productRequest.interceptors.request.use(
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
productRequest.interceptors.response.use(
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
    console.error('API请求错误:', error)
    ElMessage.error(error.message || '网络错误')
    return Promise.reject(error)
  }
)

// 获取商品列表（分页）
export function getProductList(params) {
  return productRequest({
    url: '/list',
    method: 'get',
    params
  })
}

// 获取商品详情
export function getProductDetail(id) {
  return productRequest({
    url: `/detail/${id}`,
    method: 'get'
  })
}

// 获取热门商品
export function getHotProducts(limit = 8) {
  return productRequest({
    url: '/hot',
    method: 'get',
    params: { limit }
  })
}

// 获取轮播图商品列表
export function getBannerProducts() {
  return productRequest({
    url: '/banner',
    method: 'get'
  })
}

// 设置/取消商品轮播图
export function setBanner(id, isBanner, bannerSort = 0) {
  return productRequest({
    url: `/admin/banner/${id}`,
    method: 'put',
    params: { isBanner, bannerSort }
  })
}
