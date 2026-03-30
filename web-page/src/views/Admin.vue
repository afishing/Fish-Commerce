<template>
  <div class="admin-container">
    <!-- 侧边栏 -->
    <el-aside width="200px" class="sidebar">
      <div class="logo">
        <h3>后台管理</h3>
      </div>
      <el-menu
        :default-active="activeMenu"
        class="admin-menu"
        background-color="#304156"
        text-color="#bfcbd9"
        active-text-color="#409EFF"
        router
      >
        <el-sub-menu index="/admin">
          <template #title>
            <el-icon><DataLine /></el-icon>
            <span>控制台</span>
          </template>
          <el-menu-item index="/admin/dashboard">数据概览</el-menu-item>
          <el-menu-item index="/admin/portrait">用户画像</el-menu-item>
        </el-sub-menu>
        <el-sub-menu index="/admin/users">
          <template #title>
            <el-icon><User /></el-icon>
            <span>用户管理</span>
          </template>
          <el-menu-item index="/admin/users">用户列表</el-menu-item>
        </el-sub-menu>
        <el-menu-item index="/admin/orders">
          <el-icon><Document /></el-icon>
          <span>订单管理</span>
        </el-menu-item>
        <el-menu-item index="/admin/products">
          <el-icon><Goods /></el-icon>
          <span>商品管理</span>
        </el-menu-item>
        <el-sub-menu index="/admin/other">
          <template #title>
            <el-icon><Grid /></el-icon>
            <span>其他模块</span>
          </template>
          <el-menu-item index="/admin/gallery">图片管理</el-menu-item>
          <el-menu-item index="/admin/videos">视频管理</el-menu-item>
          <el-menu-item index="/admin/notices">公告管理</el-menu-item>
        </el-sub-menu>
      </el-menu>
    </el-aside>

    <!-- 主内容区 -->
    <el-container class="main-container">
      <!-- 顶部导航 -->
      <el-header class="header">
        <div class="header-right">
          <span class="admin-name">{{ adminInfo?.nickname || adminInfo?.username }}</span>
          <el-button type="danger" size="small" @click="logout">退出登录</el-button>
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
import { DataLine, User, Document, Goods, ArrowDown, Grid } from '@element-plus/icons-vue'

const router = useRouter()
const route = useRoute()

const adminInfo = ref(null)

const activeMenu = computed(() => route.path)

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
  background-color: #304156;
  position: fixed;
  left: 0;
  top: 0;
  bottom: 0;
  z-index: 100;
}

.logo {
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  border-bottom: 1px solid #1f2d3d;
}

.logo h3 {
  margin: 0;
  font-size: 18px;
}

.admin-menu {
  border-right: none;
}

.main-container {
  margin-left: 200px;
  flex: 1;
  min-height: 100vh;
  background-color: #f0f2f5;
}

.header {
  background-color: white;
  display: flex;
  align-items: center;
  justify-content: flex-end;
  box-shadow: 0 1px 4px rgba(0, 21, 41, 0.08);
}

.header-right {
  display: flex;
  align-items: center;
  gap: 15px;
}

.admin-name {
  color: #606266;
  font-size: 14px;
}

.main-content {
  padding: 20px;
}
</style>
