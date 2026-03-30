<template>
  <el-header class="header">
    <div class="logo" @click="$router.push('/')">
      <span class="logo-emoji">🐟</span>
      <span>飞鱼商城</span>
    </div>
    <el-menu mode="horizontal" :ellipsis="false" class="nav-menu" :default-active="activeIndex">
      <el-menu-item index="1" @click="$router.push('/')">
        <el-icon><HomeFilled /></el-icon>首页
      </el-menu-item>
      <el-menu-item index="2" @click="$router.push('/products')">
        <el-icon><Goods /></el-icon>商品
      </el-menu-item>
      <el-menu-item index="3" @click="$router.push('/cart')">
        <el-icon><ShoppingCart /></el-icon>购物车
        <el-badge :value="cartCount" class="cart-badge" v-if="cartCount > 0" />
      </el-menu-item>
      <el-menu-item index="4" @click="$router.push('/orders')">
        <el-icon><List /></el-icon>订单
      </el-menu-item>
    </el-menu>
    <div class="user-area">
      <!-- 未登录状态 -->
      <template v-if="!isLoggedIn">
        <el-button type="primary" plain round @click="$router.push('/login')">
          <el-icon><User /></el-icon>登录
        </el-button>
        <el-button type="primary" round @click="$router.push('/register')">
          <el-icon><Plus /></el-icon>注册
        </el-button>
      </template>
      <!-- 已登录状态 -->
      <template v-else>
        <el-dropdown @command="handleCommand">
          <div class="user-info">
            <el-avatar :size="36" :src="getImageUrl(userInfo.avatar)" class="avatar">
              {{ userInfo.nickname?.charAt(0) || 'U' }}
            </el-avatar>
            <span class="username">{{ userInfo.nickname || userInfo.username }}</span>
            <el-icon class="dropdown-icon"><ArrowDown /></el-icon>
          </div>
          <template #dropdown>
            <el-dropdown-menu>
              <el-dropdown-item command="profile">
                <el-icon><User /></el-icon>个人中心
              </el-dropdown-item>
              <el-dropdown-item command="orders">
                <el-icon><List /></el-icon>我的订单
              </el-dropdown-item>
              <el-dropdown-item command="cart">
                <el-icon><ShoppingCart /></el-icon>购物车
              </el-dropdown-item>
              <el-dropdown-item divided command="logout">
                <el-icon><SwitchButton /></el-icon>退出登录
              </el-dropdown-item>
            </el-dropdown-menu>
          </template>
        </el-dropdown>
      </template>
    </div>
  </el-header>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { ArrowDown, User, List, ShoppingCart, SwitchButton, HomeFilled, Goods, Plus } from '@element-plus/icons-vue'
import { getImageUrl } from '@/utils/image'

const router = useRouter()
const route = useRoute()

// 当前激活的菜单项
const activeIndex = computed(() => {
  const path = route.path
  if (path === '/') return '1'
  if (path.startsWith('/products')) return '2'
  if (path.startsWith('/cart')) return '3'
  if (path.startsWith('/orders')) return '4'
  return '1'
})

// 购物车数量
const cartCount = ref(0)

// 用户登录状态
const userInfo = ref({})
const isLoggedIn = computed(() => !!userInfo.value.id)

// 更新购物车数量
const updateCartCount = () => {
  const storedCart = localStorage.getItem('cart')
  if (storedCart && userInfo.value.id) {
    const cartItems = JSON.parse(storedCart)
    cartCount.value = cartItems.filter(item => item.userId === userInfo.value.id).length
  } else {
    cartCount.value = 0
  }
}

// 检查登录状态
const refreshUserInfo = () => {
  const storedUserInfo = localStorage.getItem('userInfo')
  if (storedUserInfo) {
    userInfo.value = JSON.parse(storedUserInfo)
  }
}

onMounted(() => {
  refreshUserInfo()
  
  updateCartCount()
  
  // 监听购物车变化事件
  window.addEventListener('storage', updateCartCount)
  window.addEventListener('cartUpdated', updateCartCount)
  // 监听用户信息更新（如头像修改）
  window.addEventListener('userInfoUpdated', refreshUserInfo)
})

onUnmounted(() => {
  window.removeEventListener('storage', updateCartCount)
  window.removeEventListener('cartUpdated', updateCartCount)
  window.removeEventListener('userInfoUpdated', refreshUserInfo)
})

// 下拉菜单命令处理
const handleCommand = (command) => {
  switch (command) {
    case 'profile':
      router.push('/profile')
      break
    case 'orders':
      router.push('/orders')
      break
    case 'cart':
      router.push('/cart')
      break
    case 'logout':
      handleLogout()
      break
  }
}

// 退出登录
const handleLogout = () => {
  ElMessageBox.confirm('确定要退出登录吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(() => {
    localStorage.removeItem('userInfo')
    localStorage.removeItem('userId')
    localStorage.removeItem('token')
    userInfo.value = {}
    cartCount.value = 0
    ElMessage.success('已退出登录')
    router.push('/')
  }).catch(() => {})
}

// 暴露方法供外部更新用户信息
const updateUserInfo = (info) => {
  userInfo.value = info
}

defineExpose({ updateUserInfo, updateCartCount })
</script>

<style scoped>
.header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 48px;
  background: rgba(255, 255, 255, 0.96);
  backdrop-filter: blur(10px);
  box-shadow: 0 2px 20px rgba(0, 0, 0, 0.06);
  height: 68px;
  position: sticky;
  top: 0;
  z-index: 1000;
  border-bottom: 1px solid rgba(64, 158, 255, 0.12);
}

.logo {
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: 20px;
  font-weight: 700;
  background: linear-gradient(135deg, #409eff 0%, #764ba2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  cursor: pointer;
  transition: all 0.3s ease;
}

.logo-emoji {
  font-size: 30px;
  -webkit-text-fill-color: initial;
  filter: drop-shadow(0 2px 4px rgba(64,158,255,0.3));
}

.logo:hover {
  transform: scale(1.03);
  filter: brightness(1.1);
}

.nav-menu {
  border-bottom: none;
  background: transparent !important;
  flex: 1;
  justify-content: center;
}

.nav-menu :deep(.el-menu-item) {
  font-size: 15px;
  font-weight: 500;
  border-radius: 8px;
  margin: 0 4px;
  transition: all 0.25s;
  position: relative;
}

.nav-menu :deep(.el-menu-item.is-active) {
  background: linear-gradient(135deg, rgba(64,158,255,0.1), rgba(118,75,162,0.08)) !important;
  color: #409eff !important;
}

.nav-menu :deep(.el-menu-item.is-active::after) {
  content: '';
  position: absolute;
  bottom: 0;
  left: 50%;
  transform: translateX(-50%);
  width: 20px;
  height: 3px;
  background: linear-gradient(135deg, #409eff, #764ba2);
  border-radius: 2px;
}

.cart-badge {
  margin-left: 5px;
}

.user-area {
  display: flex;
  gap: 10px;
  align-items: center;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 10px;
  cursor: pointer;
  padding: 6px 14px;
  border-radius: 25px;
  transition: all 0.3s ease;
  background: rgba(64, 158, 255, 0.05);
  border: 1px solid rgba(64, 158, 255, 0.12);
}

.user-info:hover {
  background: rgba(64, 158, 255, 0.1);
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(64,158,255,0.15);
}

.avatar {
  border: 2px solid #409eff;
  box-shadow: 0 2px 8px rgba(64, 158, 255, 0.3);
}

.username {
  font-size: 14px;
  font-weight: 500;
  color: #303133;
}

.dropdown-icon {
  font-size: 12px;
  color: #909399;
  transition: transform 0.3s ease;
}

.user-info:hover .dropdown-icon {
  transform: rotate(180deg);
}
</style>
