/**
 * 图片URL处理工具
 */

const GATEWAY = 'http://localhost:5000'

/**
 * 获取图片完整URL
 * @param {string} url - 图片URL（支持：完整http地址、/uploads/xxx、纯文件名）
 * @returns {string} 完整的图片URL
 */
export function getImageUrl(url) {
  if (!url) return ''

  // 已经是完整URL
  if (url.startsWith('http://') || url.startsWith('https://')) {
    return url
  }

  // /uploads/xxx 格式
  if (url.startsWith('/uploads/')) {
    return `${GATEWAY}${url}`
  }

  // 纯文件名（如 uuid.jpg）或其他相对路径
  if (!url.startsWith('/')) {
    return `${GATEWAY}/uploads/${url}`
  }

  return `${GATEWAY}${url}`
}
