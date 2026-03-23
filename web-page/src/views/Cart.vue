<template>
  <div class="cart-container">
    <!-- 头部导航 -->
    <AppHeader />

    <el-main class="main-content">
      <div class="page-header">
        <el-icon :size="28" class="header-icon"><ShoppingCart /></el-icon>
        <h1>我的购物车</h1>
      </div>
      
      <!-- 未登录提示 -->
      <el-empty v-if="!isLoggedIn" description="登录后才能查看购物车">
        <template #image>
          <el-icon :size="80" color="#c0c4cc"><ShoppingCart /></el-icon>
        </template>
        <el-button type="primary" round @click="$router.push('/login')">
          <el-icon><User /></el-icon>去登录
        </el-button>
      </el-empty>
      
      <!-- 已登录显示购物车 -->
      <template v-else>
        <el-card v-if="cartItems.length > 0" class="cart-card">
        <el-table :data="cartItems" @selection-change="handleSelectionChange" class="cart-table">
          <el-table-column type="selection" width="55" />
          <el-table-column label="商品信息" min-width="350">
            <template #default="{ row }">
              <div class="product-info">
                <el-image :src="getImageUrl(row.productImage)" class="product-image" />
                <div class="info">
                  <h4>{{ row.productName }}</h4>
                  <p><el-icon><Box /></el-icon>规格：{{ row.productSpec }}</p>
                </div>
              </div>
            </template>
          </el-table-column>
          <el-table-column label="单价" width="130">
            <template #default="{ row }">
              <div class="price-wrapper">
                <span class="price-symbol">¥</span>
                <span class="price">{{ row.price }}</span>
              </div>
            </template>
          </el-table-column>
          <el-table-column label="数量" width="150">
            <template #default="{ row }">
              <el-input-number v-model="row.quantity" :min="1" size="small" @change="updateQuantity(row)" />
            </template>
          </el-table-column>
          <el-table-column label="小计" width="130">
            <template #default="{ row }">
              <span class="subtotal">¥{{ (row.price * row.quantity).toFixed(2) }}</span>
            </template>
          </el-table-column>
          <el-table-column label="操作" width="100">
            <template #default="{ row }">
              <el-button type="danger" link @click="removeItem(row)">
                <el-icon><Delete /></el-icon>删除
              </el-button>
            </template>
          </el-table-column>
        </el-table>
        
        <div class="cart-footer">
          <div class="footer-left">
            <el-checkbox v-model="selectAll" @change="toggleSelectAll">
              <el-icon><Finished /></el-icon>全选
            </el-checkbox>
            <el-button type="danger" link @click="removeSelected">
              <el-icon><Delete /></el-icon>删除选中
            </el-button>
          </div>
          <div class="footer-right">
            <span class="selected-count">
              <el-icon><Goods /></el-icon>
              已选 <strong>{{ selectedItems.length }}</strong> 件商品
            </span>
            <span class="total">
              合计：<strong>¥{{ totalPrice.toFixed(2) }}</strong>
            </span>
            <el-button type="primary" size="large" round @click="checkout">
              <el-icon><CreditCard /></el-icon>去结算
            </el-button>
          </div>
        </div>
      </el-card>
      
      <el-empty v-else description="购物车还是空的，快去选购商品吧！">
        <template #image>
          <el-icon :size="80" color="#c0c4cc"><ShoppingCart /></el-icon>
        </template>
        <el-button type="primary" round @click="$router.push('/products')">
          <el-icon><Goods /></el-icon>去购物
        </el-button>
      </el-empty>
      </template>

      <!-- 推荐商品 -->
      <div class="recommend">
        <div class="recommend-header">
          <el-icon :size="24" class="recommend-icon"><Star /></el-icon>
          <h2>猜你喜欢</h2>
        </div>
        <el-row :gutter="20">
          <el-col :span="6" v-for="item in recommendItems" :key="item.id">
            <el-card shadow="hover" class="recommend-card" @click="$router.push(`/products/${item.id}`)">
              <el-image :src="item.image" class="recommend-image" fit="cover" />
              <div class="recommend-info">
                <h4>{{ item.name }}</h4>
                <div class="price-row">
                  <span class="price-symbol">¥</span>
                  <span class="price">{{ item.price }}</span>
                </div>
              </div>
            </el-card>
          </el-col>
        </el-row>
      </div>
    </el-main>

    <!-- 支付方式选择对话框 -->
    <el-dialog v-model="payMethodDialogVisible" title="选择支付方式" width="450px" :close-on-click-modal="false" class="pay-dialog">
      <div class="pay-methods">
        <div class="pay-method-item" :class="{ active: selectedPayMethod === 'wechat' }" @click="selectedPayMethod = 'wechat'">
          <div class="pay-icon wechat">
            <el-icon size="40"><ChatDotRound /></el-icon>
          </div>
          <span>微信支付</span>
        </div>
        <div class="pay-method-item" :class="{ active: selectedPayMethod === 'alipay' }" @click="selectedPayMethod = 'alipay'">
          <div class="pay-icon alipay">
            <el-icon size="40"><Wallet /></el-icon>
          </div>
          <span>支付宝</span>
        </div>
      </div>
      <template #footer>
        <el-button @click="payMethodDialogVisible = false">取消</el-button>
        <el-button type="primary" round @click="confirmPayMethod" :disabled="!selectedPayMethod">
          <el-icon><Check /></el-icon>确认支付
        </el-button>
      </template>
    </el-dialog>

    <!-- 二维码支付对话框 -->
    <el-dialog v-model="qrcodeDialogVisible" title="扫码支付" width="450px" :close-on-click-modal="false" class="qrcode-dialog">
      <div class="qrcode-container">
        <div class="pay-amount">
          支付金额：<span class="amount">¥{{ currentOrderAmount }}</span>
        </div>
        <div class="qrcode-wrapper">
          <el-image :src="currentQrcode" class="qrcode-image" fit="contain" />
        </div>
        <p class="pay-tip">
          <el-icon><Iphone /></el-icon>
          请使用{{ selectedPayMethod === 'wechat' ? '微信' : '支付宝' }}扫码支付
        </p>
      </div>
      <template #footer>
        <el-button @click="handleCancelPayment">取消支付</el-button>
        <el-button type="primary" round @click="handleConfirmPayment">
          <el-icon><Check /></el-icon>我已付款
        </el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, computed, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { 
  ChatDotRound, Wallet, ShoppingCart, User, Box, Delete, Finished, 
  Goods, CreditCard, Check, Star, Iphone
} from '@element-plus/icons-vue'
import AppHeader from '@/components/AppHeader.vue'
import { getCartList, deleteCart, batchDeleteCart, updateCart } from '@/api/cart'
import { createOrderWithItems, createPayment, confirmPayment, cancelPayment } from '@/api/order'
import { getImageUrl } from '@/utils/image'

const router = useRouter()

// 登录状态
const isLoggedIn = ref(false)
const userId = ref(null)

const cartItems = reactive([])

const recommendItems = reactive([
  { id: 1, name: '墨鱼仔', price: 38.00, image: 'https://picsum.photos/150/100?random=43' },
  { id: 2, name: '鲍鱼', price: 158.00, image: 'https://picsum.photos/150/100?random=44' },
  { id: 3, name: '龙虾', price: 398.00, image: 'https://picsum.photos/150/100?random=45' },
  { id: 4, name: '扇贝', price: 58.00, image: 'https://picsum.photos/150/100?random=46' }
])

const selectedItems = ref([])
const selectAll = ref(false)

const totalPrice = computed(() => {
  return selectedItems.value.reduce((sum, item) => sum + item.price * item.quantity, 0)
})

// 支付相关状态
const payMethodDialogVisible = ref(false)
const qrcodeDialogVisible = ref(false)
const selectedPayMethod = ref('')
const currentOrderId = ref(null)
const currentOrderAmount = ref(0)
const currentCartItemIds = ref([])

// 二维码图片
const wechatQrcode = '/imgs/wechat-pay.png'
const alipayQrcode = '/imgs/alipay.png'
const currentQrcode = computed(() => {
  return selectedPayMethod.value === 'wechat' ? wechatQrcode : alipayQrcode
})

// 从后端加载购物车数据
const fetchCartList = async () => {
  if (!userId.value) return
  
  try {
    const res = await getCartList(userId.value)
    cartItems.splice(0, cartItems.length, ...res.data)
  } catch (error) {
    console.error('获取购物车失败:', error)
  }
}

// 检查登录状态并加载购物车
onMounted(() => {
  const storedUserInfo = localStorage.getItem('userInfo')
  if (storedUserInfo) {
    isLoggedIn.value = true
    userId.value = JSON.parse(storedUserInfo).id
    fetchCartList()
  }
})

const handleSelectionChange = (selection) => {
  selectedItems.value = selection
  selectAll.value = selection.length === cartItems.length
}

const toggleSelectAll = (val) => {
  selectedItems.value = val ? [...cartItems] : []
}

// 更新数量
const updateQuantity = async (item) => {
  try {
    await updateCart({
      id: item.id,
      quantity: item.quantity,
      selected: item.selected ? 1 : 0
    })
  } catch (error) {
    console.error('更新数量失败:', error)
  }
}

// 删除单个商品
const removeItem = (item) => {
  ElMessageBox.confirm('确定删除该商品吗？', '提示', {
    type: 'warning'
  }).then(async () => {
    try {
      await deleteCart(item.id)
      const index = cartItems.findIndex(i => i.id === item.id)
      if (index > -1) cartItems.splice(index, 1)
      window.dispatchEvent(new Event('cartUpdated'))
      ElMessage.success('删除成功')
    } catch (error) {
      console.error('删除失败:', error)
    }
  })
}

// 删除选中商品
const removeSelected = () => {
  if (selectedItems.value.length === 0) {
    ElMessage.warning('请选择要删除的商品')
    return
  }
  ElMessageBox.confirm('确定删除选中的商品吗？', '提示', {
    type: 'warning'
  }).then(async () => {
    try {
      const ids = selectedItems.value.map(item => item.id)
      await batchDeleteCart(ids)
      
      selectedItems.value.forEach(item => {
        const index = cartItems.findIndex(i => i.id === item.id)
        if (index > -1) cartItems.splice(index, 1)
      })
      selectedItems.value = []
      window.dispatchEvent(new Event('cartUpdated'))
      ElMessage.success('删除成功')
    } catch (error) {
      console.error('批量删除失败:', error)
    }
  })
}

// 结算 - 创建待付款订单
const checkout = async () => {
  if (selectedItems.value.length === 0) {
    ElMessage.warning('请选择要结算的商品')
    return
  }
  
  try {
    // 从 localStorage 获取用户信息
    const userInfo = JSON.parse(localStorage.getItem('userInfo') || '{}')
    
    // 创建订单（待付款状态 status=0）
    const orderData = {
      userId: userId.value,
      totalAmount: totalPrice.value,
      payAmount: totalPrice.value,
      receiverName: userInfo.username || userInfo.nickname || '未知用户',
      receiverPhone: userInfo.phone || '',
      receiverAddress: userInfo.address || '用户默认地址',
      cartItemIds: selectedItems.value.map(item => item.id),
      items: selectedItems.value.map(item => ({
        productId: item.productId,
        productName: item.productName,
        productImage: item.productImage,
        productSpec: item.productSpec,
        price: item.price,
        quantity: item.quantity
      }))
    }
    
    const res = await createOrderWithItems(orderData)
    currentOrderId.value = res.data.id
    currentOrderAmount.value = totalPrice.value
    currentCartItemIds.value = selectedItems.value.map(item => item.id)
    
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

// 确认已付款
const handleConfirmPayment = async () => {
  try {
    // 调用支付确认接口，更新订单状态为待收货
    await confirmPayment(currentOrderId.value)
    
    // 删除已结算的购物车商品
    await batchDeleteCart(currentCartItemIds.value)
    
    // 更新本地列表
    currentCartItemIds.value.forEach(id => {
      const index = cartItems.findIndex(i => i.id === id)
      if (index > -1) cartItems.splice(index, 1)
    })
    selectedItems.value = []
    
    window.dispatchEvent(new Event('cartUpdated'))
    
    qrcodeDialogVisible.value = false
    selectedPayMethod.value = ''
    
    ElMessage.success('支付成功！')
    router.push('/orders')
  } catch (error) {
    console.error('支付失败:', error)
    ElMessage.error('支付失败，请重试')
  }
}
</script>

<style scoped>
.cart-container {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  background: linear-gradient(180deg, #f5f7fa 0%, #e4e7ed 100%);
}

.main-content {
  max-width: 1200px;
  margin: 0 auto;
  width: 100%;
}

.page-header {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 25px;
}

.header-icon {
  color: #409eff;
}

.page-header h1 {
  margin: 0;
  font-size: 24px;
  color: #303133;
}

.cart-card {
  border-radius: 12px;
  border: none;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
}

.cart-table {
  border-radius: 8px;
}

.product-info {
  display: flex;
  align-items: center;
  gap: 15px;
}

.product-image {
  width: 80px;
  height: 80px;
  border-radius: 10px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.product-info .info h4 {
  margin-bottom: 8px;
  color: #303133;
}

.product-info .info p {
  color: #909399;
  font-size: 12px;
  display: flex;
  align-items: center;
  gap: 4px;
}

.price-wrapper {
  display: flex;
  align-items: baseline;
}

.price-symbol {
  color: #f56c6c;
  font-size: 14px;
  margin-right: 2px;
}

.price {
  color: #f56c6c;
  font-size: 18px;
  font-weight: 600;
}

.subtotal {
  color: #f56c6c;
  font-weight: bold;
  font-size: 16px;
}

.cart-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 20px;
  padding: 20px;
  background: linear-gradient(135deg, #f5f7fa 0%, #fff 100%);
  border-radius: 12px;
}

.footer-left {
  display: flex;
  align-items: center;
  gap: 20px;
}

.footer-left .el-checkbox {
  display: flex;
  align-items: center;
  gap: 4px;
}

.footer-right {
  display: flex;
  align-items: center;
  gap: 25px;
}

.selected-count {
  display: flex;
  align-items: center;
  gap: 4px;
  color: #606266;
}

.total {
  font-size: 16px;
}

.total strong {
  color: #f56c6c;
  font-size: 24px;
}

.recommend {
  margin-top: 50px;
}

.recommend-header {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 20px;
}

.recommend-icon {
  color: #e6a23c;
}

.recommend-header h2 {
  margin: 0;
  font-size: 20px;
}

.recommend-card {
  cursor: pointer;
  border-radius: 12px;
  border: none;
  overflow: hidden;
  transition: all 0.3s ease;
}

.recommend-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12);
}

.recommend-image {
  width: 100%;
  height: 120px;
}

.recommend-info {
  padding: 12px;
  text-align: center;
}

.recommend-info h4 {
  margin: 0 0 8px;
  color: #303133;
}

.recommend-info .price-row {
  justify-content: center;
}

/* 支付方式选择 */
.pay-methods {
  display: flex;
  justify-content: center;
  gap: 30px;
  padding: 30px 0;
}

.pay-method-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12px;
  padding: 25px 35px;
  border: 2px solid #e4e7ed;
  border-radius: 12px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.pay-method-item:hover {
  border-color: #409eff;
  transform: translateY(-3px);
}

.pay-method-item.active {
  border-color: #409eff;
  background: linear-gradient(135deg, #ecf5ff 0%, #f0f7ff 100%);
}

.pay-icon {
  width: 60px;
  height: 60px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
}

.pay-icon.wechat {
  background: linear-gradient(135deg, #07c160 0%, #2aae67 100%);
}

.pay-icon.alipay {
  background: linear-gradient(135deg, #1677ff 0%, #40a9ff 100%);
}

.pay-method-item span {
  font-size: 14px;
  color: #606266;
  font-weight: 500;
}

/* 二维码支付 */
.qrcode-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 20px;
  padding: 10px 0;
}

.pay-amount {
  font-size: 16px;
  color: #606266;
}

.pay-amount .amount {
  color: #f56c6c;
  font-size: 28px;
  font-weight: bold;
}

.qrcode-wrapper {
  padding: 15px;
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
}

.qrcode-image {
  width: 200px;
  height: 200px;
}

.pay-tip {
  color: #909399;
  font-size: 14px;
  display: flex;
  align-items: center;
  gap: 6px;
}
</style>
