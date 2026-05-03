<template>
  <div class="login-container">
    <div class="login-background">
      <div class="bubble bubble-1"></div>
      <div class="bubble bubble-2"></div>
      <div class="bubble bubble-3"></div>
    </div>
    <el-card class="login-card">
      <template #header>
        <div class="card-header">
          <div class="logo-wrapper">
            <span class="logo-emoji">🐟</span>
          </div>
          <span class="title">飞鱼商城</span>
          <span class="subtitle">欢迎回来</span>
        </div>
      </template>
      
      <el-form :model="form" :rules="rules" ref="formRef" label-position="top">
        <el-form-item label="用户名" prop="username">
          <el-input v-model="form.username" placeholder="请输入用户名" :prefix-icon="User" size="large" />
        </el-form-item>
        
        <el-form-item label="密码" prop="password">
          <el-input v-model="form.password" type="password" placeholder="请输入密码" :prefix-icon="Lock" show-password size="large" />
        </el-form-item>
        
        <el-form-item>
          <div class="form-options">
            <el-checkbox v-model="form.remember">
              <el-icon><CircleCheck /></el-icon>记住我
            </el-checkbox>
            <el-link type="primary" :underline="false">
              <el-icon><QuestionFilled /></el-icon>忘记密码？
            </el-link>
          </div>
        </el-form-item>
        
        <el-form-item>
          <el-button type="primary" @click="handleLogin" style="width: 100%" size="large" round>
            <el-icon><Unlock /></el-icon>
            登 录
          </el-button>
        </el-form-item>
      </el-form>
      
      <div class="footer">
        <span>还没有账号？</span>
        <router-link to="/register">
          <el-button type="primary" link>
            <el-icon><Plus /></el-icon>立即注册
          </el-button>
        </router-link>
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import { User, Lock, CircleCheck, QuestionFilled, Unlock, Plus } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import { login } from '@/api/user'

const router = useRouter()
const formRef = ref()

const form = reactive({
  username: '',
  password: '',
  remember: false
})

const rules = {
  username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
  password: [{ required: true, message: '请输入密码', trigger: 'blur' }]
}

const handleLogin = async () => {
  try {
    await formRef.value.validate()
    const res = await login({
      username: form.username,
      password: form.password
    })
    ElMessage.success('登录成功！')
    // 保存用户信息和 JWT Token 到 localStorage
    localStorage.setItem('userInfo', JSON.stringify(res.data.user))
    localStorage.setItem('userId', res.data.user.id)
    localStorage.setItem('token', res.data.token)
    router.push('/')
  } catch (error) {
    console.error('登录失败:', error)
  }
}
</script>

<style scoped>
.login-container {
  width: 100vw;
  height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  position: relative;
  overflow: hidden;
}

.login-background {
  position: absolute;
  width: 100%;
  height: 100%;
  overflow: hidden;
}

.bubble {
  position: absolute;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.1);
  animation: float 6s ease-in-out infinite;
}

.bubble-1 {
  width: 200px;
  height: 200px;
  top: 10%;
  left: 10%;
  animation-delay: 0s;
}

.bubble-2 {
  width: 150px;
  height: 150px;
  top: 60%;
  right: 15%;
  animation-delay: 2s;
}

.bubble-3 {
  width: 100px;
  height: 100px;
  bottom: 20%;
  left: 20%;
  animation-delay: 4s;
}

@keyframes float {
  0%, 100% { transform: translateY(0) rotate(0deg); }
  50% { transform: translateY(-20px) rotate(10deg); }
}

.login-card {
  width: 420px;
  border-radius: 16px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
  backdrop-filter: blur(10px);
  background: rgba(255, 255, 255, 0.95);
  z-index: 1;
}

.card-header {
  text-align: center;
}

.logo-wrapper {
  width: 80px;
  height: 80px;
  margin: 0 auto 15px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.logo-emoji {
  font-size: 48px;
  line-height: 1;
}

.title {
  display: block;
  font-size: 28px;
  font-weight: bold;
  color: #667eea;
  margin-bottom: 5px;
}

.subtitle {
  display: block;
  font-size: 14px;
  color: #909399;
}

.form-options {
  display: flex;
  justify-content: space-between;
  align-items: center;
  width: 100%;
}

.form-options .el-checkbox {
  display: flex;
  align-items: center;
  gap: 4px;
}

.form-options .el-link {
  display: flex;
  align-items: center;
  gap: 4px;
}

.footer {
  text-align: center;
  margin-top: 20px;
  padding-top: 20px;
  border-top: 1px solid #eee;
  color: #666;
}

.footer .el-button {
  display: inline-flex;
  align-items: center;
  gap: 4px;
}
</style>
