<template>
  <div class="dancing-character" :style="characterStyle">
    <div class="character-body">
      <div class="character-head">
        <div class="character-face">
          <div class="eye left"></div>
          <div class="eye right"></div>
          <div class="mouth"></div>
        </div>
      </div>
      <div class="character-body-main">
        <div class="arm left"></div>
        <div class="arm right"></div>
      </div>
      <div class="character-legs">
        <div class="leg left"></div>
        <div class="leg right"></div>
      </div>
    </div>
    <div class="speech-bubble" v-if="showQuestion">
      <div class="bubble-content">{{ currentQuestion }}</div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'

const showQuestion = ref(false)
const currentQuestion = ref('您好！有什么可以帮您？')

const characterStyle = computed(() => ({
  position: 'fixed',
  bottom: '100px',
  right: '30px',
  width: '80px',
  height: '120px',
  cursor: 'pointer',
  zIndex: 9999,
  animation: 'bounce 2s infinite',
  transition: 'transform 0.3s'
}))

const questions = [
  '您好！有什么可以帮您？',
  '需要推荐商品吗？',
  '有问题可以随时问我哦！',
  '今天有优惠活动哦！'
]

const changeQuestion = () => {
  const randomIndex = Math.floor(Math.random() * questions.length)
  currentQuestion.value = questions[randomIndex]
  showQuestion.value = true
  setTimeout(() => {
    showQuestion.value = false
  }, 3000)
}

const handleClick = () => {
  changeQuestion()
  // 可以在这里添加点击事件，比如打开客服聊天窗口
}

onMounted(() => {
  // 每隔 10 秒随机显示问题
  const interval = setInterval(() => {
    if (Math.random() > 0.7) {
      changeQuestion()
    }
  }, 10000)
  
  onUnmounted(() => {
    clearInterval(interval)
  })
})
</script>

<style scoped>
.dancing-character {
  position: fixed;
  bottom: 100px;
  right: 30px;
  width: 80px;
  height: 120px;
  cursor: pointer;
  z-index: 9999;
}

@keyframes bounce {
  0%, 100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-10px);
  }
}

.character-body {
  width: 100%;
  height: 100%;
  position: relative;
}

.character-head {
  width: 50px;
  height: 50px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 50%;
  position: absolute;
  top: 0;
  left: 50%;
  transform: translateX(-50%);
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
}

.character-face {
  position: relative;
  width: 100%;
  height: 100%;
}

.eye {
  width: 8px;
  height: 8px;
  background: white;
  border-radius: 50%;
  position: absolute;
  top: 18px;
  animation: blink 3s infinite;
}

.eye.left {
  left: 12px;
}

.eye.right {
  right: 12px;
}

@keyframes blink {
  0%, 90%, 100% {
    transform: scaleY(1);
  }
  95% {
    transform: scaleY(0.1);
  }
}

.mouth {
  width: 20px;
  height: 10px;
  border-bottom: 3px solid white;
  border-radius: 0 0 20px 20px;
  position: absolute;
  bottom: 10px;
  left: 50%;
  transform: translateX(-50%);
}

.character-body-main {
  width: 60px;
  height: 50px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 25px;
  position: absolute;
  top: 55px;
  left: 50%;
  transform: translateX(-50%);
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
}

.arm {
  width: 15px;
  height: 30px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 10px;
  position: absolute;
  top: 5px;
}

.arm.left {
  left: -10px;
  transform: rotate(20deg);
  animation: wave-left 3s infinite;
}

.arm.right {
  right: -10px;
  transform: rotate(-20deg);
  animation: wave-right 3s infinite;
}

@keyframes wave-left {
  0%, 100% {
    transform: rotate(20deg);
  }
  50% {
    transform: rotate(40deg);
  }
}

@keyframes wave-right {
  0%, 100% {
    transform: rotate(-20deg);
  }
  50% {
    transform: rotate(-40deg);
  }
}

.character-legs {
  position: absolute;
  bottom: 0;
  left: 50%;
  transform: translateX(-50%);
  width: 50px;
  height: 20px;
}

.leg {
  width: 12px;
  height: 20px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 0 0 10px 10px;
  position: absolute;
  bottom: 0;
}

.leg.left {
  left: 5px;
}

.leg.right {
  right: 5px;
}

.speech-bubble {
  position: absolute;
  bottom: 130px;
  right: 0;
  background: white;
  padding: 12px 16px;
  border-radius: 12px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
  min-width: 150px;
  max-width: 250px;
  animation: fadeIn 0.3s ease-in-out;
}

.speech-bubble::after {
  content: '';
  position: absolute;
  bottom: -8px;
  right: 20px;
  width: 16px;
  height: 16px;
  background: white;
  transform: rotate(45deg);
}

.bubble-content {
  font-size: 13px;
  color: #333;
  line-height: 1.5;
  text-align: center;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.dancing-character:hover {
  transform: scale(1.1);
}
</style>
