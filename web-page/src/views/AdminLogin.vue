<template>
  <div class="admin-login-container">
    <!-- 左侧装饰区 -->
    <div class="login-left">
      <div class="left-content">
        <div class="brand-logo">🐟</div>
        <h1 class="brand-name">飞鱼商城</h1>
        <p class="brand-desc">分布式电商系统管理平台</p>
        <div class="feature-list">
          <div class="feature-item">
            <span class="feature-icon">📊</span>
            <span>实时数据监控</span>
          </div>
          <div class="feature-item">
            <span class="feature-icon">📦</span>
            <span>商品订单管理</span>
          </div>
          <div class="feature-item">
            <span class="feature-icon">👥</span>
            <span>用户权限控制</span>
          </div>
        </div>
      </div>
    </div>
    <!-- 右侧登录表单 -->
    <div class="login-right">
      <div class="login-box">
        <div class="login-header">
          <div class="login-title">管理员登录</div>
          <div class="login-subtitle">欢迎回来，请登录您的账号</div>
        </div>
        <el-form
          ref="loginFormRef"
          :model="loginForm"
          :rules="loginRules"
          label-position="top"
          @keyup.enter="handleLogin"
        >
          <el-form-item label="用户名" prop="username">
            <el-input
              v-model="loginForm.username"
              placeholder="请输入管理员用户名"
              prefix-icon="User"
              size="large"
            />
          </el-form-item>
          <el-form-item label="密码" prop="password">
            <el-input
              v-model="loginForm.password"
              type="password"
              placeholder="请输入密码"
              prefix-icon="Lock"
              size="large"
              show-password
            />
          </el-form-item>
          <el-form-item>
            <el-button
              type="primary"
              size="large"
              :loading="loading"
              @click="handleLogin"
              class="login-btn"
            >
              {{ loading ? '登录中...' : '登录' }}
            </el-button>
          </el-form-item>
        </el-form>
        <div class="back-link">
          <router-link to="/">← 返回商城首页</router-link>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { adminLogin } from '../api/admin'

const router = useRouter()
const loginFormRef = ref(null)
const loading = ref(false)

const loginForm = reactive({
  username: '',
  password: ''
})

const loginRules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, message: '密码长度至少6位', trigger: 'blur' }
  ]
}

const handleLogin = async () => {
  if (!loginFormRef.value) return
  
  await loginFormRef.value.validate(async (valid) => {
    if (valid) {
      loading.value = true
      try {
        const res = await adminLogin(loginForm)
        if (res.success) {
          ElMessage.success('登录成功')
          // 存储管理员信息
          localStorage.setItem('adminInfo', JSON.stringify(res.data))
          localStorage.setItem('isAdmin', 'true')
          router.push('/admin')
        } else {
          ElMessage.error(res.message || '登录失败')
        }
      } catch (error) {
        ElMessage.error('登录失败，请检查网络连接')
      } finally {
        loading.value = false
      }
    }
  })
}
</script>

<style scoped>
.admin-login-container {
  min-height: 100vh;
  display: flex;
}

.login-left {
  flex: 1;
  background: linear-gradient(135deg, #1a2744 0%, #243357 50%, #1e3a5f 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  overflow: hidden;
}

.login-left::before {
  content: '';
  position: absolute;
  width: 400px;
  height: 400px;
  border-radius: 50%;
  background: rgba(64, 158, 255, 0.1);
  top: -100px;
  right: -100px;
}

.login-left::after {
  content: '';
  position: absolute;
  width: 300px;
  height: 300px;
  border-radius: 50%;
  background: rgba(64, 158, 255, 0.07);
  bottom: -80px;
  left: -60px;
}

.left-content {
  text-align: center;
  color: #fff;
  position: relative;
  z-index: 1;
}

.brand-logo {
  font-size: 72px;
  margin-bottom: 20px;
  filter: drop-shadow(0 4px 12px rgba(0,0,0,0.3));
}

.brand-name {
  font-size: 36px;
  font-weight: 700;
  margin-bottom: 12px;
  letter-spacing: 2px;
}

.brand-desc {
  font-size: 16px;
  color: rgba(255,255,255,0.65);
  margin-bottom: 40px;
}

.feature-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
  text-align: left;
}

.feature-item {
  display: flex;
  align-items: center;
  gap: 12px;
  background: rgba(255,255,255,0.08);
  padding: 12px 20px;
  border-radius: 12px;
  font-size: 15px;
}

.feature-icon {
  font-size: 20px;
}

.login-right {
  width: 480px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #f5f7fa;
}

.login-box {
  width: 380px;
  padding: 44px 40px;
  background: white;
  border-radius: 16px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.08);
}

.login-header {
  margin-bottom: 32px;
}

.login-title {
  font-size: 26px;
  font-weight: 700;
  color: #1a2744;
  margin-bottom: 8px;
}

.login-subtitle {
  color: #909399;
  font-size: 14px;
}

.login-btn {
  width: 100%;
  height: 46px;
  font-size: 16px;
  background: linear-gradient(135deg, #409eff, #66b1ff);
  border: none;
  border-radius: 10px;
  letter-spacing: 1px;
}

.login-btn:hover {
  background: linear-gradient(135deg, #337ecc, #409eff);
}

.back-link {
  text-align: center;
  margin-top: 24px;
}

.back-link a {
  color: #409eff;
  text-decoration: none;
  font-size: 14px;
  transition: color 0.2s;
}

.back-link a:hover {
  color: #66b1ff;
}
</style>
