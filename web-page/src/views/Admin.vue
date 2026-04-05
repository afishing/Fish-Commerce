<template>
  <div class="admin-container">
    <!-- 侧边栏 -->
    <el-aside width="220px" class="sidebar">
      <div class="logo">
        <div class="logo-icon">🐟</div>
        <div class="logo-text">
          <div class="logo-title">飞鱼商城</div>
          <div class="logo-subtitle">管理后台</div>
        </div>
      </div>
      <el-menu
        :default-active="activeMenu"
        class="admin-menu"
        background-color="transparent"
        text-color="rgba(255,255,255,0.75)"
        active-text-color="#ffffff"
        router
      >
        <el-sub-menu index="/admin">
          <template #title>
            <el-icon><DataLine /></el-icon>
            <span>控制台</span>
          </template>
          <el-menu-item index="/admin/dashboard"><el-icon><Monitor /></el-icon>数据概览</el-menu-item>
          <el-menu-item index="/admin/portrait"><el-icon><PieChart /></el-icon>用户画像</el-menu-item>
        </el-sub-menu>
        <el-sub-menu index="/admin/users">
          <template #title>
            <el-icon><User /></el-icon>
            <span>用户管理</span>
          </template>
          <el-menu-item index="/admin/users"><el-icon><Avatar /></el-icon>用户列表</el-menu-item>
          <el-menu-item index="/admin/reviews"><el-icon><ChatDotRound /></el-icon>评论管理</el-menu-item>
        </el-sub-menu>
        <el-menu-item index="/admin/orders">
          <el-icon><Document /></el-icon>
          <span>订单管理</span>
        </el-menu-item>
        <el-sub-menu index="/admin/products">
          <template #title>
            <el-icon><Goods /></el-icon>
            <span>商品管理</span>
          </template>
          <el-menu-item index="/admin/products"><el-icon><Goods /></el-icon>商品列表</el-menu-item>
          <el-menu-item index="/admin/categories"><el-icon><Menu /></el-icon>分类管理</el-menu-item>
          <el-menu-item index="/admin/tags"><el-icon><PriceTag /></el-icon>标签管理</el-menu-item>
          <el-menu-item index="/admin/stock"><el-icon><Warning /></el-icon>库存管理</el-menu-item>
        </el-sub-menu>
        <el-sub-menu index="/admin/other">
          <template #title>
            <el-icon><Grid /></el-icon>
            <span>其他模块</span>
          </template>
          <el-menu-item index="/admin/gallery"><el-icon><Picture /></el-icon>图片管理</el-menu-item>
          <el-menu-item index="/admin/videos"><el-icon><VideoPlay /></el-icon>视频管理</el-menu-item>
          <el-menu-item index="/admin/notices"><el-icon><Bell /></el-icon>公告管理</el-menu-item>
        </el-sub-menu>
        <el-sub-menu index="/admin/system">
          <template #title>
            <el-icon><Setting /></el-icon>
            <span>系统工具</span>
          </template>
          <el-menu-item index="/admin/monitor"><el-icon><Monitor /></el-icon>系统监控</el-menu-item>
        </el-sub-menu>
      </el-menu>
      <div class="sidebar-footer">
        <div class="version">v1.0.0</div>
      </div>
    </el-aside>

    <!-- 主内容区 -->
    <el-container class="main-container">
      <!-- 顶部导航 -->
      <el-header class="header">
        <div class="header-left">
          <div class="page-title">{{ pageTitle }}</div>
        </div>
        <div class="header-right">
          <el-tooltip content="返回商城首页" placement="bottom">
            <el-button circle size="small" @click="$router.push('/')">
              <el-icon><House /></el-icon>
            </el-button>
          </el-tooltip>
          <div class="admin-user">
            <el-avatar :size="32" class="admin-avatar">{{ (adminInfo?.nickname || adminInfo?.username || 'A').charAt(0) }}</el-avatar>
            <span class="admin-name">{{ adminInfo?.nickname || adminInfo?.username }}</span>
          </div>
          <el-button type="danger" size="small" plain round @click="logout">
            <el-icon><SwitchButton /></el-icon>
            退出
          </el-button>
        </div>
      </el-header>

      <!-- 内容区 -->
      <el-main class="main-content">
        <router-view />
      </el-main>
    </el-container>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'
import { DataLine, User, Document, Goods, ArrowDown, Grid, Monitor, PieChart, Avatar, ChatDotRound, Picture, VideoPlay, Bell, House, SwitchButton, PriceTag, Menu, Warning, Setting } from '@element-plus/icons-vue'

const router = useRouter()
const route = useRoute()

const adminInfo = ref(null)

const activeMenu = computed(() => route.path)

const pageTitleMap = {
  '/admin/dashboard': '数据概览',
  '/admin/portrait': '用户画像',
  '/admin/users': '用户列表',
  '/admin/reviews': '评论管理',
  '/admin/orders': '订单管理',
  '/admin/products': '商品管理',
  '/admin/categories': '分类管理',
  '/admin/gallery': '图片管理',
  '/admin/videos': '视频管理',
  '/admin/notices': '公告管理',
  '/admin/tags': '标签管理',
  '/admin/stock': '库存管理',
  '/admin/monitor': '系统监控'
}
const pageTitle = computed(() => pageTitleMap[route.path] || '后台管理')

onMounted(() => {
  const info = localStorage.getItem('adminInfo')
  if (info) {
    adminInfo.value = JSON.parse(info)
  } else {
    router.push('/admin/login')
  }
})

const logout = () => {
  localStorage.removeItem('adminInfo')
  localStorage.removeItem('isAdmin')
  ElMessage.success('已退出登录')
  router.push('/admin/login')
}
</script>

<style scoped>
.admin-container {
  display: flex;
  min-height: 100vh;
}

.sidebar {
  background: linear-gradient(180deg, #1a2744 0%, #243357 50%, #1e3a5f 100%);
  position: fixed;
  left: 0;
  top: 0;
  bottom: 0;
  z-index: 100;
  display: flex;
  flex-direction: column;
  box-shadow: 4px 0 20px rgba(0, 0, 0, 0.15);
}

.logo {
  height: 72px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
  color: white;
  border-bottom: 1px solid rgba(255,255,255,0.08);
  padding: 0 20px;
  background: rgba(255,255,255,0.04);
  flex-shrink: 0;
}

.logo-icon {
  font-size: 32px;
  filter: drop-shadow(0 2px 4px rgba(0,0,0,0.3));
}

.logo-title {
  font-size: 16px;
  font-weight: 700;
  color: #fff;
  letter-spacing: 1px;
}

.logo-subtitle {
  font-size: 11px;
  color: rgba(255,255,255,0.5);
  letter-spacing: 2px;
  margin-top: 2px;
}

.admin-menu {
  border-right: none;
  flex: 1;
  overflow-y: auto;
}

.admin-menu :deep(.el-menu-item) {
  border-radius: 8px;
  margin: 2px 10px;
  width: calc(100% - 20px);
  transition: all 0.2s;
}

.admin-menu :deep(.el-menu-item.is-active) {
  background: linear-gradient(135deg, #409eff 0%, #66b1ff 100%) !important;
  box-shadow: 0 4px 12px rgba(64, 158, 255, 0.4);
}

.admin-menu :deep(.el-menu-item:hover) {
  background: rgba(255,255,255,0.1) !important;
}

.admin-menu :deep(.el-sub-menu__title) {
  border-radius: 8px;
  margin: 2px 10px;
  width: calc(100% - 20px);
  transition: all 0.2s;
}

.admin-menu :deep(.el-sub-menu__title:hover) {
  background: rgba(255,255,255,0.1) !important;
}

.sidebar-footer {
  padding: 12px;
  text-align: center;
  border-top: 1px solid rgba(255,255,255,0.08);
  flex-shrink: 0;
}

.version {
  font-size: 12px;
  color: rgba(255,255,255,0.3);
}

.main-container {
  margin-left: 220px;
  flex: 1;
  min-height: 100vh;
  background: #f0f2f5;
}

.header {
  background: #fff;
  display: flex;
  align-items: center;
  justify-content: space-between;
  box-shadow: 0 1px 8px rgba(0, 21, 41, 0.06);
  padding: 0 24px;
  border-bottom: 1px solid #f0f0f0;
}

.header-left {
  display: flex;
  align-items: center;
}

.page-title {
  font-size: 18px;
  font-weight: 600;
  color: #1a2744;
  position: relative;
  padding-left: 14px;
}

.page-title::before {
  content: '';
  position: absolute;
  left: 0;
  top: 50%;
  transform: translateY(-50%);
  width: 4px;
  height: 20px;
  background: linear-gradient(180deg, #409eff, #66b1ff);
  border-radius: 2px;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 12px;
}

.admin-user {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 4px 10px;
  border-radius: 20px;
  background: #f5f7fa;
}

.admin-avatar {
  background: linear-gradient(135deg, #409eff, #66b1ff);
  color: #fff;
  font-weight: bold;
}

.admin-name {
  color: #303133;
  font-size: 14px;
  font-weight: 500;
}

.main-content {
  padding: 24px;
  min-height: calc(100vh - 60px);
}
</style>
