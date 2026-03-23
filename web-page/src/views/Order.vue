<template>
  <div class="order-container">
    <!-- 头部导航 -->
    <AppHeader />

    <el-main class="main-content">
      <h1>我的订单</h1>
      
      <!-- 未登录提示 -->
      <el-empty v-if="!isLoggedIn" description="登录后才能查看订单">
        <el-button type="primary" @click="$router.push('/login')">去登录</el-button>
      </el-empty>
      
      <!-- 已登录显示订单 -->
      <template v-else>
      <!-- 订单状态选项卡 -->
      <el-tabs v-model="activeTab" class="order-tabs" @tab-change="handleTabChange">
        <el-tab-pane label="全部订单" name="all" />
        <el-tab-pane name="0">
          <template #label>
            待付款 <el-badge v-if="pendingCount > 0" :value="pendingCount" class="tab-badge" />
          </template>
        </el-tab-pane>
        <el-tab-pane name="1">
          <template #label>
            待发货 <el-badge v-if="toShipCount > 0" :value="toShipCount" class="tab-badge" />
          </template>
        </el-tab-pane>
        <el-tab-pane name="2">
          <template #label>
            待收货 <el-badge v-if="shippedCount > 0" :value="shippedCount" class="tab-badge" />
          </template>
        </el-tab-pane>
        <el-tab-pane label="已完成" name="3" />
      </el-tabs>

      <!-- 订单列表 -->
      <div class="order-list">
        <el-card v-for="order in filteredOrders" :key="order.id" class="order-card">
          <div class="order-header">
            <span class="order-id">订单号：{{ order.orderNo }}</span>
            <el-tag :type="getStatusType(order.status)" size="small">
              {{ getStatusText(order.status) }}
            </el-tag>
          </div>
          
          <div class="order-products">
            <div class="product-item" v-for="item in order.items" :key="item.id">
              <el-image :src="getImageUrl(item.productImage)" style="width: 80px; height: 80px; border-radius: 8px" />
              <div class="info">
                <h4>{{ item.productName }}</h4>
                <p>规格：{{ item.productSpec }} × {{ item.quantity }}</p>
              </div>
              <div class="price">¥{{ item.price }}</div>
            </div>
          </div>
          
          <div class="order-footer">
            <div class="total">
              共 {{ order.items?.reduce((sum, p) => sum + p.quantity, 0) || 0 }} 件商品，
              实付款：<strong>¥{{ (order.payAmount || order.totalAmount)?.toFixed(2) }}</strong>
            </div>
            <div class="actions">
              <el-button v-if="order.status === 0" type="danger" @click="payOrderHandler(order)">立即付款</el-button>
              <el-tag v-if="order.status === 1" type="info">等待商家发货</el-tag>
              <el-button v-if="order.status === 2" type="success" @click="confirmOrderHandler(order)">确认收货</el-button>
              <el-button @click="viewDetail(order)">查看详情</el-button>
              <el-button v-if="order.status === 3" type="warning" @click="reviewOrder(order)">评价</el-button>
              <el-button v-if="order.status === 3" type="danger" plain @click="deleteOrderHandler(order)">删除</el-button>
            </div>
          </div>
        </el-card>

        <el-empty v-if="filteredOrders.length === 0" description="暂无相关订单">
          <el-button type="primary" @click="$router.push('/products')">去购物</el-button>
        </el-empty>
      </div>
      </template>
    </el-main>

    <!-- 订单详情弹窗 -->
    <el-dialog v-model="detailVisible" title="订单详情" width="600px">
      <div v-if="currentOrder" class="order-detail">
        <div class="detail-row">
          <span class="label">订单号：</span>
          <span>{{ currentOrder.orderNo }}</span>
        </div>
        <div class="detail-row">
          <span class="label">订单状态：</span>
          <el-tag :type="getStatusType(currentOrder.status)" size="small">
            {{ getStatusText(currentOrder.status) }}
          </el-tag>
        </div>
        <div class="detail-row">
          <span class="label">实付金额：</span>
          <span class="detail-price">¥{{ (currentOrder.payAmount || currentOrder.totalAmount)?.toFixed(2) }}</span>
        </div>
        
        <el-divider content-position="left">商品信息</el-divider>
        
        <div class="detail-products">
          <div class="product-item" v-for="item in currentOrder.items" :key="item.id">
            <el-image :src="getImageUrl(item.productImage)" style="width: 60px; height: 60px; border-radius: 8px" />
            <div class="info">
              <h4>{{ item.productName }}</h4>
              <p>规格：{{ item.productSpec }}</p>
            </div>
            <div class="item-right">
              <span class="price">¥{{ item.price }}</span>
              <span class="quantity">×{{ item.quantity }}</span>
            </div>
          </div>
        </div>
        
        <div class="detail-total">
          共 {{ currentOrder.items?.reduce((sum, p) => sum + p.quantity, 0) || 0 }} 件商品，
          合计：<strong>¥{{ (currentOrder.payAmount || currentOrder.totalAmount)?.toFixed(2) }}</strong>
        </div>
      </div>
      <template #footer>
        <el-button @click="detailVisible = false">关闭</el-button>
        <el-button v-if="currentOrder?.status === 0" type="danger" @click="payOrderFromDetail">立即付款</el-button>
        <el-button v-if="currentOrder?.status === 2" type="success" @click="confirmOrderFromDetail">确认收货</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, computed, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import AppHeader from '@/components/AppHeader.vue'
import { getOrderList, payOrder, confirmOrder, deleteOrder } from '@/api/order'
import { getImageUrl } from '@/utils/image'

// 登录状态
const isLoggedIn = ref(false)
const userId = ref(null)

// 订单详情弹窗
const detailVisible = ref(false)
const currentOrder = ref(null)

const activeTab = ref('all')

const orders = reactive([])

// 订单状态: 0-待付款 2-待收货 3-已完成 4-已取消
const statusMap = {
  0: { text: '待付款', type: 'warning' },
  1: { text: '待发货', type: 'info' },
  2: { text: '待收货', type: 'primary' },
  3: { text: '已完成', type: 'success' },
  4: { text: '已取消', type: 'info' }
}

// 从后端获取订单列表
const fetchOrderList = async (status = null) => {
  if (!userId.value) return
  
  try {
    const res = await getOrderList(userId.value, status)
    orders.splice(0, orders.length, ...res.data)
  } catch (error) {
    console.error('获取订单列表失败:', error)
  }
}

// 检查登录状态
onMounted(() => {
  const storedUserInfo = localStorage.getItem('userInfo')
  if (storedUserInfo) {
    isLoggedIn.value = true
    userId.value = JSON.parse(storedUserInfo).id
    fetchOrderList()
  }
})

// 计算各状态订单数量
const pendingCount = computed(() => orders.filter(o => o.status === 0).length)
const toShipCount = computed(() => orders.filter(o => o.status === 1).length)
const shippedCount = computed(() => orders.filter(o => o.status === 2).length)

const filteredOrders = computed(() => {
  if (activeTab.value === 'all') return orders
  return orders.filter(order => order.status === parseInt(activeTab.value))
})

const getStatusType = (status) => {
  return statusMap[status]?.type || 'info'
}

const getStatusText = (status) => {
  return statusMap[status]?.text || '未知状态'
}

// 标签页切换
const handleTabChange = (tabName) => {
  if (tabName === 'all') {
    fetchOrderList()
  } else {
    fetchOrderList(parseInt(tabName))
  }
}

// 支付订单
const payOrderHandler = async (order) => {
  try {
    await payOrder(order.id)
    order.status = 1 // 变为待发货
    ElMessage.success('支付成功！等待商家发货')
  } catch (error) {
    console.error('支付失败:', error)
  }
}

// 确认收货
const confirmOrderHandler = (order) => {
  ElMessageBox.confirm('确定已收到货物吗？', '确认收货', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'info'
  }).then(async () => {
    try {
      await confirmOrder(order.id)
      order.status = 3 // 变为已完成
      ElMessage.success('确认收货成功！订单已完成')
    } catch (error) {
      console.error('确认收货失败:', error)
    }
  }).catch(() => {})
}

// 删除订单
const deleteOrderHandler = (order) => {
  ElMessageBox.confirm('确定要删除该订单记录吗？', '删除订单', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    try {
      await deleteOrder(order.id)
      const index = orders.findIndex(o => o.id === order.id)
      if (index > -1) orders.splice(index, 1)
      ElMessage.success('订单已删除')
    } catch (error) {
      console.error('删除订单失败:', error)
    }
  }).catch(() => {})
}

const viewDetail = (order) => {
  currentOrder.value = order
  detailVisible.value = true
}

const reviewOrder = (order) => {
  ElMessage.info(`评价订单：${order.id}`)
}

// 从详情弹窗付款
const payOrderFromDetail = () => {
  if (currentOrder.value) {
    payOrderHandler(currentOrder.value)
    detailVisible.value = false
  }
}

// 从详情弹窗确认收货
const confirmOrderFromDetail = () => {
  if (currentOrder.value) {
    confirmOrderHandler(currentOrder.value)
    detailVisible.value = false
  }
}
</script>

<style scoped>
.order-container {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  background: #f5f7fa;
}

.main-content {
  max-width: 1200px;
  margin: 0 auto;
  width: 100%;
}

.main-content h1 {
  margin-bottom: 20px;
}

.order-tabs {
  margin-bottom: 20px;
}

.tab-badge {
  margin-left: 5px;
}

.order-card {
  margin-bottom: 20px;
}

.order-header {
  display: flex;
  align-items: center;
  gap: 20px;
  padding-bottom: 15px;
  border-bottom: 1px solid #ebeef5;
  margin-bottom: 15px;
}

.order-id {
  font-weight: bold;
}

.order-products {
  margin-bottom: 15px;
}

.product-item {
  display: flex;
  align-items: center;
  gap: 15px;
  padding: 10px 0;
  border-bottom: 1px solid #f5f5f5;
}

.product-item:last-child {
  border-bottom: none;
}

.product-item .info {
  flex: 1;
}

.product-item .info h4 {
  margin-bottom: 5px;
}

.product-item .info p {
  color: #909399;
  font-size: 14px;
}

.product-item .price {
  color: #f56c6c;
  font-weight: bold;
}

.order-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 15px;
  border-top: 1px solid #ebeef5;
}

.total {
  color: #606266;
}

.total strong {
  color: #f56c6c;
  font-size: 18px;
}

.actions {
  display: flex;
  gap: 10px;
}

/* 订单详情弹窗样式 */
.order-detail {
  padding: 10px 0;
}

.detail-row {
  display: flex;
  align-items: center;
  margin-bottom: 15px;
}

.detail-row .label {
  width: 80px;
  color: #909399;
}

.detail-price {
  color: #f56c6c;
  font-size: 20px;
  font-weight: bold;
}

.detail-products {
  margin: 15px 0;
}

.detail-products .product-item {
  display: flex;
  align-items: center;
  gap: 15px;
  padding: 10px 0;
  border-bottom: 1px solid #f5f5f5;
}

.detail-products .product-item:last-child {
  border-bottom: none;
}

.detail-products .info {
  flex: 1;
}

.detail-products .info h4 {
  margin-bottom: 5px;
  font-size: 14px;
}

.detail-products .info p {
  color: #909399;
  font-size: 12px;
}

.item-right {
  text-align: right;
}

.item-right .price {
  color: #f56c6c;
  display: block;
}

.item-right .quantity {
  color: #909399;
  font-size: 12px;
}

.detail-total {
  text-align: right;
  padding-top: 15px;
  border-top: 1px solid #ebeef5;
  color: #606266;
}

.detail-total strong {
  color: #f56c6c;
  font-size: 18px;
}
</style>
