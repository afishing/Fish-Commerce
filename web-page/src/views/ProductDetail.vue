<template>
  <div class="detail-container">
    <!-- 头部导航 -->
    <AppHeader />

    <el-main class="main-content">
      <!-- 面包屑 -->
      <el-breadcrumb separator="/">
        <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
        <el-breadcrumb-item :to="{ path: '/products' }">商品列表</el-breadcrumb-item>
        <el-breadcrumb-item>{{ product.name }}</el-breadcrumb-item>
      </el-breadcrumb>

      <!-- 商品详情 -->
      <el-card class="product-card" v-loading="loading">
        <el-row :gutter="40">
          <el-col :span="10">
            <el-image :src="getImageUrl(product.image)" fit="cover" style="width: 100%; border-radius: 10px" />
          </el-col>
          <el-col :span="14">
            <h1>{{ product.name }}</h1>
            <p class="desc">{{ product.description }}</p>
            
            <div class="price-box">
              <span class="label">价格</span>
              <span class="price">¥{{ totalPrice.toFixed(2) }}</span>
              <span class="original-price" v-if="product.originalPrice">¥{{ (product.originalPrice * (product.specWeights[selectedSpec] || 1) * quantity).toFixed(2) }}</span>
            </div>
            
            <el-descriptions :column="1" border style="margin: 20px 0">
              <el-descriptions-item label="销量">{{ product.sales }} 件</el-descriptions-item>
              <el-descriptions-item label="库存">{{ product.stock }} 件</el-descriptions-item>
              <el-descriptions-item label="产地">{{ product.origin }}</el-descriptions-item>
              <el-descriptions-item label="净重">{{ product.weight }}</el-descriptions-item>
              <el-descriptions-item label="保质期">{{ product.shelfLife }}</el-descriptions-item>
              <el-descriptions-item label="储存方式">{{ product.storage }}</el-descriptions-item>
            </el-descriptions>
            
            <div class="spec-row">
              <span class="label">规格</span>
              <el-radio-group v-model="selectedSpec">
                <el-radio-button v-for="spec in product.specs" :key="spec" :value="spec">
                  {{ spec }}
                </el-radio-button>
              </el-radio-group>
            </div>
            
            <div class="quantity-row">
              <span class="label">数量</span>
              <el-input-number v-model="quantity" :min="1" :max="Math.max(product.stock || 1, 1)" />
            </div>
            
            <div class="action-buttons">
              <el-button type="danger" size="large" @click="buyNow">立即购买</el-button>
              <el-button type="primary" size="large" @click="addToCart">加入购物车</el-button>
            </div>
          </el-col>
        </el-row>
      </el-card>

      <!-- 详情选项卡 -->
      <el-card style="margin-top: 20px">
        <el-tabs v-model="activeTab">
          <el-tab-pane label="商品详情" name="detail">
            <div class="detail-images">
              <el-image src="https://picsum.photos/600/400?random=20" fit="cover" />
              <el-image src="https://picsum.photos/600/400?random=21" fit="cover" />
            </div>
          </el-tab-pane>
          <el-tab-pane :label="`用户评价 (${reviews.length})`" name="reviews">
            <div class="review-list">
              <div class="review-item" v-for="review in reviews" :key="review.id">
                <div class="review-header">
                  <el-avatar :size="40">{{ review.username.charAt(0) }}</el-avatar>
                  <div class="review-info">
                    <span class="username">{{ review.username }}</span>
                    <el-rate v-model="review.rating" disabled />
                  </div>
                  <span class="date">{{ review.date }}</span>
                </div>
                <p class="review-content">{{ review.content }}</p>
              </div>
            </div>
          </el-tab-pane>
        </el-tabs>
      </el-card>
    </el-main>

    <!-- 支付方式选择对话框 -->
    <el-dialog v-model="payMethodDialogVisible" title="选择支付方式" width="400px" :close-on-click-modal="false">
      <div class="pay-methods">
        <div class="pay-method-item" :class="{ active: selectedPayMethod === 'wechat' }" @click="selectedPayMethod = 'wechat'">
          <el-icon size="40" color="#07c160"><ChatDotRound /></el-icon>
          <span>微信支付</span>
        </div>
        <div class="pay-method-item" :class="{ active: selectedPayMethod === 'alipay' }" @click="selectedPayMethod = 'alipay'">
          <el-icon size="40" color="#1677ff"><Wallet /></el-icon>
          <span>支付宝</span>
        </div>
      </div>
      <template #footer>
        <el-button @click="payMethodDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="confirmPayMethod" :disabled="!selectedPayMethod">确认支付</el-button>
      </template>
    </el-dialog>

    <!-- 二维码支付对话框 -->
    <el-dialog v-model="qrcodeDialogVisible" title="扫码支付" width="400px" :close-on-click-modal="false">
      <div class="qrcode-container">
        <div class="pay-amount">支付金额：<span class="amount">¥{{ currentOrderAmount.toFixed(2) }}</span></div>
        <el-image :src="currentQrcode" style="width: 250px; height: 250px" fit="contain" />
        <p class="pay-tip">请使用{{ selectedPayMethod === 'wechat' ? '微信' : '支付宝' }}扫码支付</p>
      </div>
      <template #footer>
        <el-button @click="handleCancelPayment">取消支付</el-button>
        <el-button type="primary" @click="handleConfirmPayment">我已付款</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'
import { ChatDotRound, Wallet } from '@element-plus/icons-vue'
import AppHeader from '@/components/AppHeader.vue'
import { addToCart as addToCartApi } from '@/api/cart'
import { getProductDetail } from '@/api/product'
import { createOrderWithItems, createPayment, confirmPayment, cancelPayment } from '@/api/order'
import { getImageUrl } from '@/utils/image'

const router = useRouter()
const route = useRoute()

const product = reactive({
  id: null,
  name: '',
  description: '',
  basePrice: 0,
  originalPrice: 0,
  sales: 0,
  stock: 0,
  image: '',
  mainImage: '',
  specs: ['500g', '1kg', '2kg'],
  specWeights: { '500g': 1, '1kg': 2, '2kg': 4 },
  origin: '',
  weight: '',
  shelfLife: '',
  storage: ''
})

const selectedSpec = ref('500g')
const quantity = ref(1)
const activeTab = ref('detail')
const loading = ref(false)

// 计算当前单价（根据规格）
const unitPrice = computed(() => {
  const weight = product.specWeights[selectedSpec.value] || 1
  return product.basePrice * weight
})

// 计算总价（根据规格和数量）
const totalPrice = computed(() => {
  return unitPrice.value * quantity.value
})

const reviews = reactive([
  { id: 1, username: '用户***鱼', rating: 5, date: '2024-01-15', content: '非常新鲜，肉质很好，下次还会购买！' },
  { id: 2, username: '用户***虾', rating: 4, date: '2024-01-14', content: '包装很好，配送速度快，味道不错。' },
  { id: 3, username: '用户***蟹', rating: 5, date: '2024-01-13', content: '三文鱼很新鲜，做刺身一级棒！' }
])

// 支付相关状态
const payMethodDialogVisible = ref(false)
const qrcodeDialogVisible = ref(false)
const selectedPayMethod = ref('')
const currentOrderId = ref(null)
const currentOrderAmount = ref(0)

// 二维码图片
const wechatQrcode = '/imgs/wechat-pay.png'
const alipayQrcode = '/imgs/alipay.png'
const currentQrcode = computed(() => {
  return selectedPayMethod.value === 'wechat' ? wechatQrcode : alipayQrcode
})

// 获取商品详情
const fetchProductDetail = async () => {
  const productId = route.params.id
  console.log('获取商品详情, ID:', productId)
  if (!productId) {
    ElMessage.error('商品ID不存在')
    return
  }
  
  loading.value = true
  try {
    const res = await getProductDetail(productId)
    console.log('商品详情响应:', res)
    // 拦截器返回的是 { code: 200, data: {...}, message: 'success' }
    // 所以商品数据在 res.data 中
    if (res && res.data) {
      const data = res.data
      console.log('商品数据:', data)
      product.id = data.id
      product.name = data.name
      product.description = data.description || ''
      product.basePrice = data.price || 0
      product.originalPrice = data.originalPrice || data.price || 0
      product.sales = data.sales || 0
      product.stock = data.stock || 0
      product.image = data.mainImage || ''
      product.mainImage = data.mainImage || ''
      product.origin = data.origin || ''
      product.weight = data.weight || ''
      product.shelfLife = data.shelfLife || ''
      product.storage = data.storage || ''
      console.log('设置后的product:', product)
    }
  } catch (error) {
    console.error('获取商品详情失败:', error)
    ElMessage.error('获取商品详情失败')
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchProductDetail()
})

const buyNow = async () => {
  // 检查登录状态
  const userInfo = localStorage.getItem('userInfo')
  if (!userInfo) {
    ElMessage.warning('您尚未登录，请先登录')
    router.push('/login')
    return
  }
  
  const user = JSON.parse(userInfo)
  
  try {
    // 创建订单（待付款状态 status=0）
    const orderData = {
      userId: user.id,
      totalAmount: totalPrice.value,
      payAmount: totalPrice.value,
      receiverName: user.username || user.nickname || '未知用户',
      receiverPhone: user.phone || '',
      receiverAddress: user.address || '用户默认地址',
      items: [{
        productId: product.id,
        productName: product.name,
        productImage: getImageUrl(product.image),
        productSpec: selectedSpec.value,
        price: unitPrice.value,
        quantity: quantity.value
      }]
    }
    
    const res = await createOrderWithItems(orderData)
    currentOrderId.value = res.data.id
    currentOrderAmount.value = totalPrice.value
    
    // 显示支付方式选择对话框
    payMethodDialogVisible.value = true
  } catch (error) {
    console.error('创建订单失败:', error)
    ElMessage.error('创建订单失败，请重试')
  }
}

// 确认支付方式，显示二维码
const confirmPayMethod = async () => {
  try {
    // 创建支付记录：1-支付宝，2-微信
    const payType = selectedPayMethod.value === 'wechat' ? 2 : 1
    await createPayment(currentOrderId.value, payType)
    
    payMethodDialogVisible.value = false
    qrcodeDialogVisible.value = true
  } catch (error) {
    console.error('创建支付记录失败:', error)
    ElMessage.error('创建支付记录失败')
  }
}

// 取消支付
const handleCancelPayment = async () => {
  try {
    await cancelPayment(currentOrderId.value)
    qrcodeDialogVisible.value = false
    selectedPayMethod.value = ''
    ElMessage.info('订单已保存到待付款列表')
    router.push('/orders')
  } catch (error) {
    console.error('取消支付失败:', error)
  }
}

// 确认支付完成
const handleConfirmPayment = async () => {
  try {
    await confirmPayment(currentOrderId.value)
    qrcodeDialogVisible.value = false
    selectedPayMethod.value = ''
    ElMessage.success('支付成功！')
    router.push('/orders')
  } catch (error) {
    console.error('确认支付失败:', error)
    ElMessage.error('支付确认失败，请稍后重试')
  }
}

const addToCart = async () => {
  // 检查登录状态
  const userInfo = localStorage.getItem('userInfo')
  if (!userInfo) {
    ElMessage.warning('您尚未登录，请先登录')
    router.push('/login')
    return
  }
  
  const user = JSON.parse(userInfo)
  
  try {
    await addToCartApi({
      userId: user.id,
      productId: product.id,
      productName: product.name,
      productImage: getImageUrl(product.image),
      productSpec: selectedSpec.value,
      price: unitPrice.value,
      quantity: quantity.value
    })
    
    // 触发购物车更新事件
    window.dispatchEvent(new Event('cartUpdated'))
    
    ElMessage.success(`已加入购物车：${product.name} x ${quantity.value}`)
  } catch (error) {
    console.error('添加到购物车失败:', error)
  }
}
</script>

<style scoped>
.detail-container {
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

.product-card {
  margin-top: 20px;
  padding: 30px;
}

.product-card h1 {
  font-size: 24px;
  margin-bottom: 15px;
}

.desc {
  color: #909399;
  margin-bottom: 20px;
  line-height: 1.6;
}

.price-box {
  background: #fff5f5;
  padding: 20px;
  border-radius: 8px;
}

.price-box .label {
  color: #909399;
  margin-right: 20px;
}

.price {
  color: #f56c6c;
  font-size: 28px;
  font-weight: bold;
}

.original-price {
  color: #909399;
  text-decoration: line-through;
  margin-left: 15px;
}

.spec-row,
.quantity-row {
  margin: 20px 0;
}

.spec-row .label,
.quantity-row .label {
  display: inline-block;
  width: 60px;
  color: #606266;
}

.action-buttons {
  margin-top: 30px;
  display: flex;
  gap: 20px;
}

.detail-images {
  text-align: center;
}

.detail-images .el-image {
  width: 100%;
  max-width: 600px;
  margin-bottom: 20px;
  border-radius: 8px;
}

.review-item {
  padding: 20px 0;
  border-bottom: 1px solid #ebeef5;
}

.review-header {
  display: flex;
  align-items: center;
  gap: 15px;
  margin-bottom: 10px;
}

.review-info {
  flex: 1;
}

.username {
  font-weight: bold;
  margin-right: 10px;
}

.date {
  color: #909399;
  font-size: 12px;
}

.review-content {
  color: #606266;
  line-height: 1.6;
  margin-left: 55px;
}

/* 支付方式选择 */
.pay-methods {
  display: flex;
  justify-content: center;
  gap: 40px;
  padding: 20px 0;
}

.pay-method-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 10px;
  padding: 20px 30px;
  border: 2px solid #e4e7ed;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s;
}

.pay-method-item:hover {
  border-color: #409eff;
}

.pay-method-item.active {
  border-color: #409eff;
  background: #ecf5ff;
}

.pay-method-item span {
  font-size: 14px;
  color: #606266;
}

/* 二维码支付 */
.qrcode-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 15px;
}

.pay-amount {
  font-size: 16px;
  color: #606266;
}

.pay-amount .amount {
  color: #f56c6c;
  font-size: 24px;
  font-weight: bold;
}

.pay-tip {
  color: #909399;
  font-size: 14px;
}
</style>
