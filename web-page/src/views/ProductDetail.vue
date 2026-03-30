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
            <div class="detail-content" v-if="product.detail" v-html="renderedDetail"></div>
            <div class="detail-images" v-else>
              <p class="no-detail">暂无商品详情</p>
            </div>
          </el-tab-pane>
          <el-tab-pane :label="`用户评价 (${reviews.length})`" name="reviews">
            <div class="review-section">
              <!-- 写评论按钮 -->
              <div class="review-actions">
                <el-button type="primary" @click="showReviewForm = true">
                  <el-icon><Edit /></el-icon>
                  写评价
                </el-button>
              </div>
              
              <!-- 评论表单 -->
              <el-card v-if="showReviewForm" class="review-form-card">
                <template #header>
                  <span>发表评价</span>
                </template>
                <el-form :model="reviewForm" label-width="80px">
                  <el-form-item label="评分">
                    <el-rate v-model="reviewForm.rating" :max="5" />
                  </el-form-item>
                  <el-form-item label="评价内容">
                    <el-input
                      v-model="reviewForm.content"
                      type="textarea"
                      :rows="4"
                      placeholder="分享您的使用体验..."
                      maxlength="500"
                      show-word-limit
                    />
                  </el-form-item>
                  <el-form-item>
                    <el-button @click="showReviewForm = false">取消</el-button>
                    <el-button type="primary" @click="submitReview" :loading="reviewSubmitting">
                      提交评价
                    </el-button>
                  </el-form-item>
                </el-form>
              </el-card>
              
              <!-- 评论列表 -->
              <div v-loading="reviewsLoading" class="review-list">
                <el-empty v-if="reviews.length === 0" description="暂无评价，快来抢沙发吧！" />
                <div v-else class="review-item" v-for="review in reviews" :key="review.id">
                  <div class="review-header">
                    <el-avatar :size="40">{{ review.username ? review.username.charAt(0) : '用' }}</el-avatar>
                    <div class="review-info">
                      <span class="username">{{ review.username || '匿名用户' }}</span>
                      <el-rate v-model="review.rating" disabled />
                    </div>
                    <span class="date">{{ review.createTime ? new Date(review.createTime).toLocaleDateString() : '' }}</span>
                  </div>
                  <p class="review-content">{{ review.content }}</p>
                </div>
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
import { ChatDotRound, Wallet, Edit } from '@element-plus/icons-vue'
import AppHeader from '@/components/AppHeader.vue'
import { addToCart as addToCartApi } from '@/api/cart'
import { getProductDetail } from '@/api/product'
import { createOrderWithItems, createPayment, confirmPayment, cancelPayment } from '@/api/order'
import { getImageUrl } from '@/utils/image'
import { marked } from 'marked'
import { getProductReviews, addReview } from '@/api/review'

// 配置marked选项
marked.setOptions({
  breaks: true,
  gfm: true
})

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
  storage: '',
  detail: ''
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

// 渲染Markdown详情
const renderedDetail = computed(() => {
  if (!product.detail) return ''
  // 先处理图片URL，将相对路径转换为完整URL
  const processedDetail = product.detail.replace(
    /!\[([^\]]*)\]\(([^)]+)\)/g,
    (match, alt, url) => {
      const fullUrl = getImageUrl(url)
      return `![${alt}](${fullUrl})`
    }
  )
  return marked.parse(processedDetail)
})

// 评论相关
const reviews = ref([])
const reviewsLoading = ref(false)
const reviewForm = reactive({
  rating: 5,
  content: ''
})
const reviewSubmitting = ref(false)
const showReviewForm = ref(false)

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
      product.detail = data.detail || ''
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
  fetchReviews()
})

// 获取评论列表
const fetchReviews = async () => {
  const productId = route.params.id
  if (!productId) return
  
  reviewsLoading.value = true
  try {
    const res = await getProductReviews(productId)
    if (res.code === 200 || res.success) {
      reviews.value = res.data || []
    }
  } catch (error) {
    console.error('获取评论失败:', error)
  } finally {
    reviewsLoading.value = false
  }
}

// 提交评论
const submitReview = async () => {
  // 检查登录状态
  const userInfo = localStorage.getItem('userInfo')
  if (!userInfo) {
    ElMessage.warning('请先登录后再评论')
    router.push('/login')
    return
  }
  
  const user = JSON.parse(userInfo)
  
  if (!reviewForm.content.trim()) {
    ElMessage.warning('请输入评论内容')
    return
  }
  
  reviewSubmitting.value = true
  try {
    const res = await addReview({
      productId: product.id,
      userId: user.id,
      username: user.username || user.nickname || '匿名用户',
      rating: reviewForm.rating,
      content: reviewForm.content.trim()
    })
    
    if (res.code === 200 || res.success) {
      ElMessage.success('评论提交成功')
      reviewForm.content = ''
      reviewForm.rating = 5
      showReviewForm.value = false
      fetchReviews() // 刷新评论列表
    } else {
      ElMessage.error(res.message || '评论提交失败')
    }
  } catch (error) {
    console.error('提交评论失败:', error)
    ElMessage.error('评论提交失败')
  } finally {
    reviewSubmitting.value = false
  }
}

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
  background: #f7f8fc;
}

.main-content {
  max-width: 1200px;
  margin: 0 auto;
  width: 100%;
  padding: 0 20px;
}

.product-card {
  margin-top: 20px;
  padding: 32px;
  border-radius: 20px;
  border: none;
  box-shadow: 0 4px 24px rgba(0,0,0,0.06);
}

.product-card h1 {
  font-size: 26px;
  margin-bottom: 12px;
  color: #1a2744;
  font-weight: 700;
  line-height: 1.4;
}

.desc {
  color: #909399;
  margin-bottom: 20px;
  line-height: 1.7;
  font-size: 14px;
}

.price-box {
  background: linear-gradient(135deg, #fff5f5 0%, #fff0f0 100%);
  padding: 20px 24px;
  border-radius: 12px;
  border-left: 4px solid #f56c6c;
  margin-bottom: 4px;
}

.price-box .label {
  color: #909399;
  margin-right: 16px;
  font-size: 14px;
}

.price {
  color: #f56c6c;
  font-size: 32px;
  font-weight: 700;
}

.original-price {
  color: #c0c4cc;
  text-decoration: line-through;
  margin-left: 12px;
  font-size: 16px;
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
  font-size: 14px;
}

.action-buttons {
  margin-top: 28px;
  display: flex;
  gap: 16px;
}

.action-buttons .el-button {
  padding: 14px 36px;
  font-size: 15px;
  border-radius: 12px;
  font-weight: 500;
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
  border-bottom: 1px solid #f0f2f5;
}

.review-header {
  display: flex;
  align-items: center;
  gap: 14px;
  margin-bottom: 10px;
}

.review-info {
  flex: 1;
}

.username {
  font-weight: 600;
  margin-right: 10px;
  color: #1a2744;
}

.date {
  color: #c0c4cc;
  font-size: 12px;
}

.review-content {
  color: #606266;
  line-height: 1.7;
  margin-left: 54px;
  font-size: 14px;
}

/* 支付方式选择 */
.pay-methods {
  display: flex;
  justify-content: center;
  gap: 30px;
  padding: 20px 0;
}

.pay-method-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 10px;
  padding: 20px 30px;
  border: 2px solid #e4e7ed;
  border-radius: 12px;
  cursor: pointer;
  transition: all 0.3s;
}

.pay-method-item:hover {
  border-color: #409eff;
  box-shadow: 0 4px 16px rgba(64,158,255,0.15);
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
  font-size: 26px;
  font-weight: 700;
}

.pay-tip {
  color: #909399;
  font-size: 14px;
}

/* 评论区域样式 */
.review-section {
  padding: 10px 0;
}

.review-actions {
  margin-bottom: 20px;
  display: flex;
  justify-content: flex-end;
}

.review-form-card {
  margin-bottom: 20px;
  background: #f7f8fc;
  border-radius: 12px;
}

.review-list {
  min-height: 200px;
}

/* Markdown渲染样式 */
.detail-content {
  padding: 20px;
  line-height: 1.8;
  color: #333;
}

.detail-content :deep(h1),
.detail-content :deep(h2),
.detail-content :deep(h3),
.detail-content :deep(h4),
.detail-content :deep(h5),
.detail-content :deep(h6) {
  margin: 20px 0 10px;
  color: #1a2744;
}

.detail-content :deep(h1) { font-size: 24px; }
.detail-content :deep(h2) { font-size: 22px; }
.detail-content :deep(h3) { font-size: 20px; }
.detail-content :deep(h4) { font-size: 18px; }

.detail-content :deep(p) {
  margin: 10px 0;
}

.detail-content :deep(ul),
.detail-content :deep(ol) {
  margin: 10px 0;
  padding-left: 30px;
}

.detail-content :deep(li) {
  margin: 5px 0;
}

.detail-content :deep(img) {
  max-width: 100%;
  border-radius: 8px;
  margin: 15px 0;
}

.detail-content :deep(blockquote) {
  margin: 15px 0;
  padding: 10px 20px;
  border-left: 4px solid #409eff;
  background: #ecf5ff;
  color: #606266;
}

.detail-content :deep(code) {
  background: #f5f7fa;
  padding: 2px 6px;
  border-radius: 4px;
  font-family: Consolas, monospace;
  font-size: 14px;
}

.detail-content :deep(pre) {
  background: #f5f7fa;
  padding: 15px;
  border-radius: 8px;
  overflow-x: auto;
}

.detail-content :deep(pre code) {
  background: transparent;
  padding: 0;
}

.detail-content :deep(table) {
  width: 100%;
  border-collapse: collapse;
  margin: 15px 0;
}

.detail-content :deep(th),
.detail-content :deep(td) {
  border: 1px solid #ebeef5;
  padding: 10px 15px;
  text-align: left;
}

.detail-content :deep(th) {
  background: #f5f7fa;
  font-weight: bold;
}

.detail-content :deep(hr) {
  border: none;
  border-top: 1px solid #ebeef5;
  margin: 20px 0;
}

.no-detail {
  text-align: center;
  color: #909399;
  padding: 40px;
  font-size: 14px;
}
</style>
