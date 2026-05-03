<template>
  <div class="ai-chat-widget">
    <!-- 浮动按钮 -->
    <transition name="float-btn">
      <div v-if="!isOpen" class="ai-float-btn" @click="openChat" title="AI 购物助手">
        <div class="float-icon">🐟</div>
        <span class="float-label">AI助手</span>
      </div>
    </transition>

    <!-- 聊天窗口 -->
    <transition name="chat-window">
      <div v-if="isOpen" class="ai-chat-window">
        <!-- 头部 -->
        <div class="chat-header">
          <div class="header-left">
            <span class="header-avatar">🐟</span>
            <div>
              <div class="header-title">小飞 AI助手</div>
              <div class="header-sub">飞鱼商城智能导购</div>
            </div>
          </div>
          <div class="header-actions">
            <el-tooltip content="清空对话" placement="bottom">
              <el-button text circle size="small" @click="clearHistory">
                <el-icon><Delete /></el-icon>
              </el-button>
            </el-tooltip>
            <el-button text circle size="small" @click="isOpen = false">
              <el-icon><Close /></el-icon>
            </el-button>
          </div>
        </div>

        <!-- 消息区域 -->
        <div class="chat-messages" ref="messagesEl">
          <!-- 欢迎消息 -->
          <div class="message assistant">
            <div class="message-avatar">🐟</div>
            <div class="message-bubble">
              您好！我是飞鱼商城的 AI 购物助手小飞 🛒<br>
              我可以帮您推荐商品、解答产品问题、查询订单等。<br>
              请问有什么可以帮您的？
            </div>
          </div>

          <!-- 对话消息 -->
          <div
            v-for="msg in messages"
            :key="msg.id"
            :class="['message', msg.role]"
          >
            <div v-if="msg.role === 'assistant'" class="message-avatar">🐟</div>
            <div class="message-bubble" v-html="formatMessage(msg.content)"></div>
            <div v-if="msg.role === 'user'" class="message-avatar user-avatar">
              {{ userInitial }}
            </div>
          </div>

          <!-- 流式输出中的消息 -->
          <div v-if="streamingContent" class="message assistant">
            <div class="message-avatar">🐟</div>
            <div class="message-bubble streaming" v-html="formatMessage(streamingContent)">
            </div>
          </div>

          <!-- 加载中 -->
          <div v-if="isLoading && !streamingContent" class="message assistant">
            <div class="message-avatar">🐟</div>
            <div class="message-bubble loading">
              <span class="dot"></span>
              <span class="dot"></span>
              <span class="dot"></span>
            </div>
          </div>
        </div>

        <!-- 输入区域 -->
        <div class="chat-input-area">
          <div class="quick-questions" v-if="messages.length === 0">
            <div
              v-for="q in quickQuestions"
              :key="q"
              class="quick-tag"
              @click="sendQuickQuestion(q)"
            >{{ q }}</div>
          </div>
          <div class="input-row">
            <el-input
              v-model="inputText"
              placeholder="输入您的问题..."
              :disabled="isLoading"
              @keydown.enter.exact.prevent="sendMessage"
              @keydown.enter.shift.exact="inputText += '\n'"
              type="textarea"
              :rows="1"
              :autosize="{ minRows: 1, maxRows: 4 }"
              resize="none"
            />
            <el-button
              type="primary"
              :loading="isLoading"
              :disabled="!inputText.trim()"
              @click="sendMessage"
              class="send-btn"
            >
              <el-icon v-if="!isLoading"><Promotion /></el-icon>
            </el-button>
          </div>
        </div>
      </div>
    </transition>
  </div>
</template>

<script setup>
import { ref, nextTick, computed } from 'vue'
import { Delete, Close, Promotion } from '@element-plus/icons-vue'
import { streamChatWithAi } from '@/api/ai.js'

const isOpen = ref(false)
const inputText = ref('')
const messages = ref([])
const isLoading = ref(false)
const streamingContent = ref('')
const messagesEl = ref(null)
let currentController = null

const quickQuestions = [
  '有什么热门商品推荐？',
  '如何选择适合的商品？',
  '新用户有什么优惠？',
  '有促销活动吗？'
]

const userInitial = computed(() => {
  try {
    const info = localStorage.getItem('adminInfo') || localStorage.getItem('userInfo')
    if (info) {
      const parsed = JSON.parse(info)
      return (parsed.nickname || parsed.username || 'U').charAt(0).toUpperCase()
    }
  } catch { /* ignore */ }
  return 'U'
})

function openChat() {
  isOpen.value = true
  nextTick(() => scrollToBottom())
}

function scrollToBottom() {
  if (messagesEl.value) {
    messagesEl.value.scrollTop = messagesEl.value.scrollHeight
  }
}

function formatMessage(content) {
  if (!content) return ''
  return content
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/\n/g, '<br>')
}

function clearHistory() {
  messages.value = []
  streamingContent.value = ''
  if (currentController) {
    currentController.abort()
    currentController = null
  }
  isLoading.value = false
}

function sendQuickQuestion(question) {
  inputText.value = question
  sendMessage()
}

async function sendMessage() {
  const text = inputText.value.trim()
  if (!text || isLoading.value) return

  // 加入用户消息
  messages.value.push({ id: Date.now(), role: 'user', content: text })
  inputText.value = ''
  isLoading.value = true
  streamingContent.value = ''

  await nextTick()
  scrollToBottom()

  // 构建历史（最多保留最近 10 条）
  const history = messages.value
    .slice(-11, -1)
    .map(m => ({ role: m.role, content: m.content }))

  let accumulated = ''

  currentController = streamChatWithAi(
    text,
    history,
    // onToken
    (token) => {
      accumulated += token
      streamingContent.value = accumulated
      nextTick(() => scrollToBottom())
    },
    // onDone
    () => {
      if (accumulated) {
        messages.value.push({ id: Date.now(), role: 'assistant', content: accumulated })
      }
      streamingContent.value = ''
      isLoading.value = false
      currentController = null
      nextTick(() => scrollToBottom())
    },
    // onError
    (err) => {
      console.error('AI 请求失败:', err)
      const errMsg = err.message || ''
      let tip = '抱歉，AI 助手暂时不可用，请稍后再试。'
      if (errMsg.includes('401') || errMsg.toLowerCase().includes('unauthorized') || errMsg.toLowerCase().includes('api key')) {
        tip = '❌ OpenAI API Key 无效，请在 service-ai 的 application.yml 中配置正确的 api-key。'
      } else if (errMsg.includes('HTTP 5') || errMsg.includes('service-ai')) {
        tip = '❌ AI 服务未启动，请先启动 service-ai（端口 9100）。'
      } else if (errMsg.includes('Failed to fetch') || errMsg.includes('NetworkError')) {
        tip = '❌ 网络连接失败，请检查网关（端口 5000）和 service-ai（端口 9100）是否正常运行。'
      } else if (errMsg) {
        tip = `❌ 错误：${errMsg}`
      }
      messages.value.push({
        id: Date.now(),
        role: 'assistant',
        content: tip
      })
      streamingContent.value = ''
      isLoading.value = false
      currentController = null
      nextTick(() => scrollToBottom())
    }
  )
}
</script>

<style scoped>
.ai-chat-widget {
  position: fixed;
  bottom: 30px;
  right: 30px;
  z-index: 9999;
}

/* 浮动按钮 */
.ai-float-btn {
  width: 60px;
  height: 60px;
  border-radius: 50%;
  background: linear-gradient(135deg, #409eff, #66b1ff);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  box-shadow: 0 4px 20px rgba(64, 158, 255, 0.5);
  transition: all 0.3s;
  user-select: none;
}

.ai-float-btn:hover {
  transform: scale(1.1);
  box-shadow: 0 6px 25px rgba(64, 158, 255, 0.6);
}

.float-icon {
  font-size: 24px;
  line-height: 1;
}

.float-label {
  font-size: 10px;
  color: white;
  margin-top: 2px;
  font-weight: 500;
}

/* 聊天窗口 */
.ai-chat-window {
  width: 380px;
  height: 560px;
  background: #fff;
  border-radius: 16px;
  box-shadow: 0 8px 40px rgba(0, 0, 0, 0.15);
  display: flex;
  flex-direction: column;
  overflow: hidden;
  position: absolute;
  bottom: 0;
  right: 0;
}

/* 头部 */
.chat-header {
  background: linear-gradient(135deg, #409eff, #66b1ff);
  padding: 12px 16px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  flex-shrink: 0;
}

.header-left {
  display: flex;
  align-items: center;
  gap: 10px;
}

.header-avatar {
  font-size: 28px;
  filter: drop-shadow(0 2px 4px rgba(0,0,0,0.2));
}

.header-title {
  color: white;
  font-weight: 600;
  font-size: 15px;
}

.header-sub {
  color: rgba(255, 255, 255, 0.8);
  font-size: 11px;
  margin-top: 1px;
}

.header-actions {
  display: flex;
  gap: 4px;
}

.header-actions :deep(.el-button) {
  color: rgba(255, 255, 255, 0.85) !important;
}

.header-actions :deep(.el-button:hover) {
  color: white !important;
  background: rgba(255, 255, 255, 0.15) !important;
}

/* 消息区域 */
.chat-messages {
  flex: 1;
  overflow-y: auto;
  padding: 16px;
  display: flex;
  flex-direction: column;
  gap: 12px;
  background: #f7f8fa;
}

.chat-messages::-webkit-scrollbar {
  width: 4px;
}

.chat-messages::-webkit-scrollbar-track {
  background: transparent;
}

.chat-messages::-webkit-scrollbar-thumb {
  background: #ddd;
  border-radius: 2px;
}

/* 消息气泡 */
.message {
  display: flex;
  align-items: flex-start;
  gap: 8px;
}

.message.user {
  flex-direction: row-reverse;
}

.message-avatar {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  font-size: 18px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.user-avatar {
  background: linear-gradient(135deg, #409eff, #66b1ff);
  color: white;
  font-size: 13px;
  font-weight: 600;
}

.message-bubble {
  max-width: 70%;
  padding: 10px 14px;
  border-radius: 12px;
  font-size: 14px;
  line-height: 1.6;
  word-break: break-word;
}

.message.assistant .message-bubble {
  background: white;
  color: #333;
  border-radius: 2px 12px 12px 12px;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.08);
}

.message.user .message-bubble {
  background: linear-gradient(135deg, #409eff, #66b1ff);
  color: white;
  border-radius: 12px 2px 12px 12px;
}

/* 流式输出光标 */
.message-bubble.streaming::after {
  content: '▌';
  animation: blink 0.8s step-end infinite;
  color: #409eff;
}

@keyframes blink {
  0%, 100% { opacity: 1; }
  50% { opacity: 0; }
}

/* 加载动画 */
.message-bubble.loading {
  display: flex;
  align-items: center;
  gap: 4px;
  padding: 12px 16px;
}

.dot {
  width: 7px;
  height: 7px;
  border-radius: 50%;
  background: #409eff;
  animation: bounce 1.2s infinite ease-in-out;
}

.dot:nth-child(2) { animation-delay: 0.2s; }
.dot:nth-child(3) { animation-delay: 0.4s; }

@keyframes bounce {
  0%, 80%, 100% { transform: translateY(0); opacity: 0.5; }
  40% { transform: translateY(-6px); opacity: 1; }
}

/* 输入区域 */
.chat-input-area {
  padding: 12px;
  border-top: 1px solid #f0f0f0;
  background: white;
  flex-shrink: 0;
}

.quick-questions {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
  margin-bottom: 10px;
}

.quick-tag {
  font-size: 12px;
  padding: 4px 10px;
  border-radius: 20px;
  background: #ecf5ff;
  color: #409eff;
  cursor: pointer;
  border: 1px solid #d9ecff;
  transition: all 0.2s;
  white-space: nowrap;
}

.quick-tag:hover {
  background: #409eff;
  color: white;
  border-color: #409eff;
}

.input-row {
  display: flex;
  gap: 8px;
  align-items: flex-end;
}

.input-row :deep(.el-textarea__inner) {
  border-radius: 20px;
  padding: 8px 16px;
  font-size: 14px;
  resize: none;
  border: 1px solid #e4e7ed;
  transition: border-color 0.2s;
}

.input-row :deep(.el-textarea__inner:focus) {
  border-color: #409eff;
  box-shadow: 0 0 0 2px rgba(64, 158, 255, 0.15);
}

.send-btn {
  border-radius: 50%;
  width: 38px;
  height: 38px;
  padding: 0;
  flex-shrink: 0;
}

/* 过渡动画 */
.float-btn-enter-active,
.float-btn-leave-active {
  transition: all 0.3s;
}

.float-btn-enter-from,
.float-btn-leave-to {
  opacity: 0;
  transform: scale(0.5);
}

.chat-window-enter-active {
  transition: all 0.35s cubic-bezier(0.34, 1.56, 0.64, 1);
}

.chat-window-leave-active {
  transition: all 0.25s ease-in;
}

.chat-window-enter-from,
.chat-window-leave-to {
  opacity: 0;
  transform: scale(0.8) translateY(20px);
  transform-origin: bottom right;
}
</style>
