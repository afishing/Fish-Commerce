import request from './request'

// 获取商品评价列表
export function getProductReviews(productId, params = {}) {
  return request({
    url: `/api/product/reviews/${productId}`,
    method: 'get',
    params
  })
}

// 添加评价
export function addReview(data) {
  return request({
    url: '/api/product/review/add',
    method: 'post',
    data
  })
}
