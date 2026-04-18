import request from './request'

const GATEWAY_BASE = import.meta.env.VITE_API_BASE_URL || ''

/**
 * 普通对话（非流式）
 * @param {string} message 当前消息
 * @param {Array} history 历史消息 [{role: 'user'|'assistant', content: '...'}]
 */
export const chatWithAi = (message, history = []) => {
  return request.post('/api/ai/chat', { message, history })
}

/**
 * 流式对话（SSE）
 * @param {string} message 当前消息
 * @param {Array} history 历史消息
 * @param {Function} onToken 每个 token 回调 (token: string) => void
 * @param {Function} onDone 完成回调 () => void
 * @param {Function} onError 错误回调 (err) => void
 * @returns {AbortController} 用于取消请求
 */
export const streamChatWithAi = (message, history = [], onToken, onDone, onError) => {
  const controller = new AbortController()

  const token = localStorage.getItem('token') ||
    (() => {
      try {
        const info = localStorage.getItem('adminInfo')
        return info ? JSON.parse(info).token : null
      } catch { return null }
    })()

  const headers = { 'Content-Type': 'application/json' }
  if (token) headers['Authorization'] = `Bearer ${token}`

  fetch(`${GATEWAY_BASE}/api/ai/stream`, {
    method: 'POST',
    headers,
    body: JSON.stringify({ message, history }),
    signal: controller.signal
  })
    .then(async (response) => {
      if (!response.ok) {
        throw new Error(`HTTP ${response.status}: 请检查 service-ai 是否启动`)
      }
      const reader = response.body.getReader()
      const decoder = new TextDecoder()

      while (true) {
        const { done, value } = await reader.read()
        if (done) {
          if (onDone) onDone()
          break
        }
        const chunk = decoder.decode(value, { stream: true })
        // 解析 SSE 格式: "data:token\n\n" 或 "data: token\n\n"(Spring SseEmitter 默认无空格)
        const lines = chunk.split('\n')
        let eventName = 'message'
        for (const line of lines) {
          if (line.startsWith('event:')) {
            eventName = line.replace(/^event:\s*/, '').trim()
          } else if (line.startsWith('data:')) {
            const text = line.replace(/^data:\s*/, '')
            if (text && text !== '[DONE]') {
              if (eventName === 'error') {
                if (onError) onError(new Error(text))
                eventName = 'message'
              } else {
                if (onToken) onToken(text)
              }
            }
          } else if (line === '') {
            eventName = 'message' // 重置事件名
          }
        }
      }
    })
    .catch((err) => {
      if (err.name !== 'AbortError' && onError) {
        onError(err)
      }
    })

  return controller
}
