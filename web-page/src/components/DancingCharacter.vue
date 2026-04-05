<template>
  <div class="dancing-character" @click="toggleChat">
    <div class="character-body" :class="{ dancing: isDancing }">
      <span class="character">🐱</span>
    </div>
    <div v-if="showChat" class="chat-bubble">
      <p>嗨！我是小猫咪助手~</p>
      <p>有什么可以帮你的吗？</p>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'

const isDancing = ref(false)
const showChat = ref(false)

const toggleChat = () => {
  showChat.value = !showChat.value
}

let danceInterval = null

onMounted(() => {
  danceInterval = setInterval(() => {
    isDancing.value = true
    setTimeout(() => {
      isDancing.value = false
    }, 500)
  }, 3000)
})

onUnmounted(() => {
  if (danceInterval) {
    clearInterval(danceInterval)
  }
})
</script>

<style scoped>
.dancing-character {
  position: fixed;
  bottom: 80px;
  right: 30px;
  z-index: 1000;
  cursor: pointer;
}

.character-body {
  width: 60px;
  height: 60px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
  transition: transform 0.3s ease;
}

.character-body:hover {
  transform: scale(1.1);
}

.character {
  font-size: 32px;
}

.character-body.dancing {
  animation: dance 0.5s ease;
}

@keyframes dance {
  0%, 100% {
    transform: translateY(0) rotate(0deg);
  }
  25% {
    transform: translateY(-10px) rotate(-5deg);
  }
  50% {
    transform: translateY(0) rotate(0deg);
  }
  75% {
    transform: translateY(-10px) rotate(5deg);
  }
}

.chat-bubble {
  position: absolute;
  bottom: 70px;
  right: 0;
  background: white;
  padding: 15px;
  border-radius: 12px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
  min-width: 180px;
  animation: fadeIn 0.3s ease;
}

.chat-bubble::after {
  content: '';
  position: absolute;
  bottom: -8px;
  right: 20px;
  border-left: 8px solid transparent;
  border-right: 8px solid transparent;
  border-top: 8px solid white;
}

.chat-bubble p {
  margin: 5px 0;
  font-size: 14px;
  color: #333;
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
</style>
