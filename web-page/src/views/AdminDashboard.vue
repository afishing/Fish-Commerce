<template>
  <div class="dashboard-container">
    <!-- 统计卡片 -->
    <el-row :gutter="20" class="statistics-row">
      <el-col :span="6">
        <el-card class="stat-card">
          <div class="stat-item">
            <div class="stat-icon" style="background-color: #409EFF;">
              <el-icon><User /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-title">总用户数</div>
              <div class="stat-value">{{ statistics.totalUsers || 0 }}</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stat-card">
          <div class="stat-item">
            <div class="stat-icon" style="background-color: #67C23A;">
              <el-icon><ShoppingCart /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-title">今日订单</div>
              <div class="stat-value">{{ statistics.todayOrders || 0 }}</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stat-card">
          <div class="stat-item">
            <div class="stat-icon" style="background-color: #E6A23C;">
              <el-icon><Money /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-title">今日成交额</div>
              <div class="stat-value">¥{{ formatAmount(statistics.todayAmount) }}</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stat-card">
          <div class="stat-item">
            <div class="stat-icon" style="background-color: #F56C6C;">
              <el-icon><Goods /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-title">商品总数</div>
              <div class="stat-value">{{ statistics.totalProducts || 0 }}</div>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 待处理事项 -->
    <el-row :gutter="20" class="todo-row">
      <el-col :span="12">
        <el-card>
          <template #header>
            <span>待处理事项</span>
          </template>
          <div class="todo-list">
            <div class="todo-item">
              <span class="todo-label">待付款订单</span>
              <el-tag type="warning">{{ statistics.pendingPayOrders || 0 }}</el-tag>
            </div>
            <div class="todo-item">
              <span class="todo-label">待发货订单</span>
              <el-tag type="danger">{{ statistics.pendingShipOrders || 0 }}</el-tag>
            </div>
            <div class="todo-item">
              <span class="todo-label">今日新增用户</span>
              <el-tag type="success">{{ statistics.todayNewUsers || 0 }}</el-tag>
            </div>
            <div class="todo-item">
              <span class="todo-label">上架商品数</span>
              <el-tag type="info">{{ statistics.onSaleProducts || 0 }}</el-tag>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="12">
        <el-card>
          <template #header>
            <span>订单状态分布</span>
          </template>
          <div class="status-distribution">
            <div
              v-for="(count, status) in statistics.orderStatusDistribution"
              :key="status"
              class="status-item"
            >
              <span class="status-name">{{ status }}</span>
              <el-progress
                :percentage="calculatePercentage(count)"
                :color="getStatusColor(status)"
              />
              <span class="status-count">{{ count }}</span>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 最近7天趋势 -->
    <el-row class="chart-row">
      <el-col :span="24">
        <el-card>
          <template #header>
            <span>最近7天订单趋势</span>
          </template>
          <div class="chart-container">
            <div
              v-for="(item, index) in statistics.recentOrders"
              :key="index"
              class="chart-bar"
            >
              <div class="bar" :style="{ height: getBarHeight(item.count) + 'px' }"></div>
              <div class="bar-label">{{ formatDate(item.date) }}</div>
              <div class="bar-value">{{ item.count }}</div>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { User, ShoppingCart, Money, Goods } from '@element-plus/icons-vue'
import { getStatistics } from '../api/admin'

const statistics = ref({
  totalUsers: 0,
  todayOrders: 0,
  todayAmount: 0,
  totalProducts: 0,
  pendingPayOrders: 0,
  pendingShipOrders: 0,
  todayNewUsers: 0,
  onSaleProducts: 0,
  orderStatusDistribution: {},
  recentOrders: []
})

const loading = ref(false)

const fetchStatistics = async () => {
  // 检查是否已登录
  const adminInfo = localStorage.getItem('adminInfo')
  if (!adminInfo) {
    ElMessage.warning('请先登录')
    router.push('/admin/login')
    return
  }
  
  loading.value = true
  try {
    const res = await getStatistics()
    if (res.success) {
      statistics.value = res.data
    } else {
      ElMessage.error(res.message || '获取统计数据失败')
    }
  } catch (error) {
    // 401 错误不显示提示，由 request.js 统一处理
  } finally {
    loading.value = false
  }
}

const formatAmount = (amount) => {
  if (!amount) return '0.00'
  return parseFloat(amount).toFixed(2)
}

const formatDate = (dateStr) => {
  if (!dateStr) return ''
  const date = new Date(dateStr)
  return `${date.getMonth() + 1}/${date.getDate()}`
}

const getBarHeight = (count) => {
  const max = Math.max(...(statistics.value.recentOrders || []).map(item => item.count || 0), 1)
  return (count / max) * 150
}

const calculatePercentage = (count) => {
  const total = statistics.value.totalOrders || 1
  return Math.round((count / total) * 100)
}

const getStatusColor = (status) => {
  const colors = {
    '待付款': '#E6A23C',
    '待发货': '#F56C6C',
    '待收货': '#409EFF',
    '已完成': '#67C23A',
    '已取消': '#909399'
  }
  return colors[status] || '#409EFF'
}

onMounted(() => {
  fetchStatistics()
})
</script>

<style scoped>
.dashboard-container {
  padding: 20px;
}

.statistics-row {
  margin-bottom: 20px;
}

.stat-card {
  cursor: pointer;
  transition: all 0.3s;
}

.stat-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
}

.stat-item {
  display: flex;
  align-items: center;
}

.stat-icon {
  width: 60px;
  height: 60px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 15px;
}

.stat-icon .el-icon {
  font-size: 30px;
  color: white;
}

.stat-info {
  flex: 1;
}

.stat-title {
  font-size: 14px;
  color: #909399;
  margin-bottom: 8px;
}

.stat-value {
  font-size: 24px;
  font-weight: bold;
  color: #303133;
}

.todo-row {
  margin-bottom: 20px;
}

.todo-list {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.todo-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 0;
  border-bottom: 1px solid #EBEEF5;
}

.todo-item:last-child {
  border-bottom: none;
}

.todo-label {
  font-size: 14px;
  color: #606266;
}

.status-distribution {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.status-item {
  display: flex;
  align-items: center;
  gap: 10px;
}

.status-name {
  width: 80px;
  font-size: 14px;
  color: #606266;
}

.status-item .el-progress {
  flex: 1;
}

.status-count {
  width: 50px;
  text-align: right;
  font-size: 14px;
  color: #909399;
}

.chart-row {
  margin-top: 20px;
}

.chart-container {
  display: flex;
  justify-content: space-around;
  align-items: flex-end;
  height: 200px;
  padding: 20px;
}

.chart-bar {
  display: flex;
  flex-direction: column;
  align-items: center;
  flex: 1;
}

.bar {
  width: 40px;
  background: linear-gradient(to top, #409EFF, #67C23A);
  border-radius: 4px 4px 0 0;
  transition: all 0.3s;
}

.bar:hover {
  opacity: 0.8;
}

.bar-label {
  margin-top: 10px;
  font-size: 12px;
  color: #909399;
}

.bar-value {
  margin-top: 5px;
  font-size: 14px;
  font-weight: bold;
  color: #303133;
}
</style>
