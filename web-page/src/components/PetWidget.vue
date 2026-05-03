<template>
  <div class="pet-widget">
    <!-- 桌宠 -->
    <div
      id="pet"
      class="cywl"
      :class="{ dragging: isDragging }"
      :style="{ left: pet.x + 'px', bottom: pet.y + 'px' }"
      @mousedown="onMouseDown"
      @click="onPetClick"
      title="点击与我聊天~"
    >
      <img id="pet-img" :src="currentFrame" draggable="false">
    </div>

    <!-- AI 聊天窗口 -->
    <transition name="chat-window">
      <div v-if="isChatOpen" class="ai-chat-window" :style="chatPosition">
        <!-- 头部 -->
        <div class="chat-header">
          <div class="header-left">
            <span class="header-avatar">🐱</span>
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
            <el-button text circle size="small" @click="isChatOpen = false">
              <el-icon><Close /></el-icon>
            </el-button>
          </div>
        </div>

        <!-- 消息区域 -->
        <div class="chat-messages" ref="messagesEl">
          <!-- 欢迎消息 -->
          <div class="message assistant">
            <div class="message-avatar">🐱</div>
            <div class="message-bubble">
              喵~ 我是飞鱼商城的 AI 助手小飞 🛒<br>
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
            <div v-if="msg.role === 'assistant'" class="message-avatar">🐱</div>
            <div class="message-bubble" v-html="formatMessage(msg.content)"></div>
            <div v-if="msg.role === 'user'" class="message-avatar user-avatar">
              {{ userInitial }}
            </div>
          </div>

          <!-- 流式输出中的消息 -->
          <div v-if="streamingContent" class="message assistant">
            <div class="message-avatar">🐱</div>
            <div class="message-bubble streaming" v-html="formatMessage(streamingContent)">
            </div>
          </div>

          <!-- 加载中 -->
          <div v-if="isLoading && !streamingContent" class="message assistant">
            <div class="message-avatar">🐱</div>
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
import { ref, computed, onMounted, onUnmounted, nextTick } from 'vue'
import { Delete, Close, Promotion } from '@element-plus/icons-vue'
import { streamChatWithAi } from '@/api/ai.js'

// ============ 桌宠相关 ============
const pet = ref({ 
  x: typeof window !== 'undefined' ? window.innerWidth - 150 : 50,  // 默认右下角
  y: 50,
  vx: 1 
})
const isDragging = ref(false)
const dragOffset = ref({ x: 0, y: 0 })
const currentFrame = ref('/pet/stand1.png')
const action = ref('stand')

// 动画帧
const frames = {
  walkLeft: [],
  walkRight: [],
  drag: [],
  fish: [],
  kiss: [],
  sleep: [],
  stand: [],
  falling: []
}

// 预加载图片到浏览器缓存，避免动画切换时重复请求
const imageCache = new Map()
function preloadImage(src) {
  if (!imageCache.has(src)) {
    const img = new Image()
    img.src = src
    imageCache.set(src, img)
  }
  return src
}

for (let i = 1; i <= 12; i++) {
  frames.walkLeft.push(preloadImage(`/pet/walkleft${i}.png`))
  frames.walkRight.push(preloadImage(`/pet/walkright${i}.png`))
  frames.drag.push(preloadImage(`/pet/drag${i}.png`))
  frames.fish.push(preloadImage(`/pet/fish${i}.png`))
  frames.kiss.push(preloadImage(`/pet/kiss${i}.png`))
  frames.sleep.push(preloadImage(`/pet/sleep${i}.png`))
  frames.stand.push(preloadImage(`/pet/stand${i}.png`))
}
frames.falling.push(preloadImage('/pet/falling1.png'))

// 动作权重
const actions = {
  walkleft: 1,
  walkright: 1,
  fish: 1,
  sleep: 1,
  kiss: 1,
  stand: 2
}

let frameIndex = 0
let animationTimer = null
let actionTimer = null
let lastTime = 0

function randomAction() {
  const total = Object.values(actions).reduce((a, b) => a + b, 0)
  let random = Math.random() * total
  for (const [name, weight] of Object.entries(actions)) {
    random -= weight
    if (random <= 0) return name
  }
  return 'stand'
}

function updateAnimation() {
  const now = Date.now()
  if (now - lastTime < 100) return
  lastTime = now

  frameIndex = (frameIndex + 1) % 12

  switch (action.value) {
    case 'walkleft':
      currentFrame.value = frames.walkLeft[frameIndex]
      pet.value.x -= 0.5
      break
    case 'walkright':
      currentFrame.value = frames.walkRight[frameIndex]
      pet.value.x += 0.5
      break
    case 'fish':
      currentFrame.value = frames.fish[frameIndex]
      break
    case 'kiss':
      currentFrame.value = frames.kiss[frameIndex]
      break
    case 'sleep':
      currentFrame.value = frames.sleep[frameIndex]
      break
    case 'stand':
      currentFrame.value = frames.stand[frameIndex]
      break
  }

  // 边界检测
  const maxX = window.innerWidth - 100
  if (pet.value.x < 0) {
    pet.value.x = 0
    action.value = 'walkright'
  }
  if (pet.value.x > maxX) {
    pet.value.x = maxX
    action.value = 'walkleft'
  }
}

function loop() {
  if (!isDragging.value) {
    updateAnimation()
  }
  animationTimer = requestAnimationFrame(loop)
}

// 拖拽事件
function onMouseDown(e) {
  isDragging.value = true
  // 计算偏移：x 是 left，y 需要转换为 bottom（视口高度 - clientY）
  const rect = e.currentTarget.getBoundingClientRect()
  dragOffset.value = {
    x: e.clientX - rect.left,
    y: e.clientY - rect.top
  }
  currentFrame.value = frames.drag[frameIndex]
  clearInterval(actionTimer)

  const onMouseMove = (e) => {
    if (!isDragging.value) return
    // x = left 位置
    pet.value.x = e.clientX - dragOffset.value.x
    // y = bottom 位置 = 视口高度 - (clientY - 偏移)
    pet.value.y = window.innerHeight - (e.clientY - dragOffset.value.y) - 100
    currentFrame.value = frames.drag[frameIndex]
  }

  const onMouseUp = () => {
    if (!isDragging.value) return
    isDragging.value = false
    currentFrame.value = frames.falling[0]
    action.value = 'stand'
    actionTimer = setInterval(() => {
      action.value = randomAction()
    }, 3000)

    // 越界回到屏幕内
    const maxX = window.innerWidth - 100
    const maxY = window.innerHeight - 100
    if (pet.value.x < 0) pet.value.x = 50
    if (pet.value.x > maxX) pet.value.x = maxX - 50
    if (pet.value.y < 0) pet.value.y = 50
    if (pet.value.y > maxY) pet.value.y = maxY - 50

    document.removeEventListener('mousemove', onMouseMove)
    document.removeEventListener('mouseup', onMouseUp)
  }

  document.addEventListener('mousemove', onMouseMove)
  document.addEventListener('mouseup', onMouseUp)
}

// 点击桌宠打开聊天
function onPetClick(e) {
  // 如果是拖拽结束，不触发点击
  if (isDragging.value) return
  isChatOpen.value = true
  nextTick(() => scrollToBottom())
}

// ============ AI 聊天相关 ============
const isChatOpen = ref(false)
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

const chatPosition = computed(() => ({
  left: Math.min(pet.value.x - 140, window.innerWidth - 400) + 'px',
  bottom: (pet.value.y + 100) + 'px'
}))

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

  messages.value.push({ id: Date.now(), role: 'user', content: text })
  inputText.value = ''
  isLoading.value = true
  streamingContent.value = ''

  await nextTick()
  scrollToBottom()

  const history = messages.value
    .slice(-11, -1)
    .map(m => ({ role: m.role, content: m.content }))

  let accumulated = ''

  currentController = streamChatWithAi(
    text,
    history,
    (token) => {
      accumulated += token
      streamingContent.value = accumulated
      nextTick(() => scrollToBottom())
    },
    () => {
      if (accumulated) {
        messages.value.push({ id: Date.now(), role: 'assistant', content: accumulated })
      }
      streamingContent.value = ''
      isLoading.value = false
      currentController = null
      nextTick(() => scrollToBottom())
    },
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
      messages.value.push({ id: Date.now(), role: 'assistant', content: tip })
      streamingContent.value = ''
      isLoading.value = false
      currentController = null
      nextTick(() => scrollToBottom())
    }
  )
}

onMounted(() => {
  loop()
  actionTimer = setInterval(() => {
    if (!isDragging.value) {
      action.value = randomAction()
    }
  }, 3000)
})

onUnmounted(() => {
  cancelAnimationFrame(animationTimer)
  clearInterval(actionTimer)
})
</script>

<style scoped>
/* 桌宠 */
.cywl {
  position: fixed;
  width: 100px;
  height: 100px;
  z-index: 9999;
  cursor: pointer;
  user-select: none;
  transition: transform 0.1s;
}

.cywl:hover {
  transform: scale(1.05);
}

.cywl.dragging {
  cursor: grabbing;
}

.cywl img {
  width: 90px;
  height: 90px;
  pointer-events: none;
  user-select: none;
}

/* AI 聊天窗口 */
.ai-chat-window {
  position: fixed;
  width: 380px;
  height: 520px;
  background: #fff;
  border-radius: 16px;
  box-shadow: 0 8px 40px rgba(0, 0, 0, 0.2);
  display: flex;
  flex-direction: column;
  overflow: hidden;
  z-index: 10000;
}

/* 头部 */
.chat-header {
  background: linear-gradient(135deg, #ff9a56, #ff6b6b);
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
  color: rgba(255, 255, 255, 0.85);
  font-size: 11px;
  margin-top: 1px;
}

.header-actions {
  display: flex;
  gap: 4px;
}

.header-actions :deep(.el-button) {
  color: rgba(255, 255, 255, 0.9) !important;
}

.header-actions :deep(.el-button:hover) {
  color: white !important;
  background: rgba(255, 255, 255, 0.2) !important;
}

/* 消息区域 */
.chat-messages {
  flex: 1;
  overflow-y: auto;
  padding: 16px;
  display: flex;
  flex-direction: column;
  gap: 12px;
  background: #fff8f5;
}

.chat-messages::-webkit-scrollbar {
  width: 4px;
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
  background: linear-gradient(135deg, #ff9a56, #ff6b6b);
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
  background: linear-gradient(135deg, #ff9a56, #ff6b6b);
  color: white;
  border-radius: 12px 2px 12px 12px;
}

/* 流式光标 */
.message-bubble.streaming::after {
  content: '▌';
  animation: blink 0.8s step-end infinite;
  color: #ff6b6b;
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
  background: #ff6b6b;
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
  border-top: 1px solid #ffe8e0;
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
  background: #fff0eb;
  color: #ff6b6b;
  cursor: pointer;
  border: 1px solid #ffd4c7;
  transition: all 0.2s;
  white-space: nowrap;
}

.quick-tag:hover {
  background: #ff6b6b;
  color: white;
  border-color: #ff6b6b;
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
  border: 1px solid #ffd4c7;
  transition: border-color 0.2s;
}

.input-row :deep(.el-textarea__inner:focus) {
  border-color: #ff6b6b;
  box-shadow: 0 0 0 2px rgba(255, 107, 107, 0.15);
}

.send-btn {
  border-radius: 50%;
  width: 38px;
  height: 38px;
  padding: 0;
  flex-shrink: 0;
  background: linear-gradient(135deg, #ff9a56, #ff6b6b);
  border: none;
}

.send-btn:hover {
  background: linear-gradient(135deg, #ff8a46, #ff5b5b);
}

/* 过渡动画 */
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
  transform-origin: bottom center;
}
</style>
