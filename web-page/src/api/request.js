import axios from 'axios'
import { ElMessage } from 'element-plus'

// 创建 axios 实例 - 通过 Gateway 网关访问
const request = axios.create({
  baseURL: 'http://localhost:5000',
  timeout: 10000
})

// 请求拦截器
request.interceptors.request.use(
  config => {
    // 从 localStorage 获取 token（支持普通用户和管理员）
    let token = localStorage.getItem('token')
    
    // 如果没有普通用户 token，尝试从 adminInfo 中获取管理员 token
    if (!token) {
      const adminInfoStr = localStorage.getItem('adminInfo')
      if (adminInfoStr) {
        try {
          const adminInfo = JSON.parse(adminInfoStr)
          token = adminInfo.token
        } catch (e) {
          console.error('解析 adminInfo 失败:', e)
        }
      }
    }
    
    // 公开接口不需要 token（公告、分类、商品列表等）
    const publicPaths = [
      '/api/notice/enabled',
      '/api/category/list',
      '/api/product/banner',
      '/api/product/list'
    ]
    
    const isPublicPath = publicPaths.some(path => config.url.includes(path))
    
    // 只有非公开接口且有 token 时才添加 Authorization 头
    if (token && !isPublicPath) {
      config.headers['Authorization'] = `Bearer ${token}`
    }
    return config
  },
  error => {
    return Promise.reject(error)
  }
)

// 响应拦截器
request.interceptors.response.use(
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

export default request
