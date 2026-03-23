/**
 * 图片URL处理工具
 */

/**
 * 获取图片完整URL
 * @param {string} url - 图片URL
 * @returns {string} 完整的图片URL
 */
export function getImageUrl(url) {
  if (!url) return ''
  
  // 如果已经是完整URL，直接返回
  if (url.startsWith('http://') || url.startsWith('https://')) {
    return url
  }
  
  // 本地图片，通过Gateway网关访问
  if (url.startsWith('/uploads/')) {
    return `http://localhost:5000${url}`
  }
  
  return url
}
