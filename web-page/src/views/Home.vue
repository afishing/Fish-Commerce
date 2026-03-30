<template>
  <div class="home-container">
    <!-- 头部导航 -->
    <AppHeader />

    <!-- 轮播图 -->
    <el-carousel height="450px" class="banner" :interval="5000">
      <el-carousel-item v-for="item in banners" :key="item.id">
        <div class="banner-content" :style="{ background: item.color }">
          <div class="banner-icon">{{ item.icon }}</div>
          <h1>{{ item.title }}</h1>
          <p>{{ item.desc }}</p>
          <el-button type="primary" size="large" round @click="$router.push('/products')">
            <el-icon><ShoppingCart /></el-icon>
            立即选购
          </el-button>
        </div>
      </el-carousel-item>
    </el-carousel>

    <!-- 商品分类 -->
    <div class="section categories">
      <div class="section-header">
        <el-icon class="section-icon" :size="28"><Grid /></el-icon>
        <h2 class="section-title">商品分类</h2>
      </div>
      <div class="category-grid">
        <el-card shadow="hover" class="category-card" v-for="cat in categories" :key="cat.id" @click="$router.push('/products')">
          <div class="icon-wrapper">{{ cat.icon }}</div>
          <div class="name">{{ cat.name }}</div>
        </el-card>
      </div>
    </div>

    <!-- 热门商品 -->
    <div class="section hot-products">
      <div class="section-header">
        <el-icon class="section-icon" :size="28"><TrendCharts /></el-icon>
        <h2 class="section-title">热门商品</h2>
      </div>
      
      <!-- 商品列表 -->
      <template v-if="hotProducts.length > 0">
        <el-row :gutter="20">
          <el-col :span="6" v-for="product in hotProducts" :key="product.id">
            <el-card shadow="hover" class="product-card" @click="$router.push(`/products/${product.id}`)">
              <div class="product-image-wrapper">
                <img :src="getImageUrl(product.mainImage || product.image)" class="product-image" />
                <div class="product-badge" v-if="product.sales > 1000">
                  <el-icon><Trophy /></el-icon> 热销
                </div>
              </div>
              <div class="product-info">
                <h3>{{ product.name }}</h3>
                <p class="desc">{{ product.description || product.desc }}</p>
                <div class="price-row">
                  <div class="price-wrapper">
                    <span class="price-symbol">¥</span>
                    <span class="price">{{ product.price }}</span>
                  </div>
                  <span class="sales">
                    <el-icon><User /></el-icon>
                    已售 {{ product.sales || 0 }}
                  </span>
                </div>
              </div>
              <el-button type="primary" class="add-cart-btn" @click.stop="addToCart(product)">
                <el-icon><ShoppingCart /></el-icon>
                加入购物车
              </el-button>
            </el-card>
          </el-col>
        </el-row>
        
        <!-- 加载更多状态 -->
        <div class="loading-more" v-if="loadingMore">
          <el-icon class="is-loading"><Loading /></el-icon>
          <span>加载更多...</span>
        </div>
        
        <!-- 没有更多数据 -->
        <div class="no-more" v-if="finished">
          <el-divider>没有更多了</el-divider>
        </div>
      </template>
      
      <!-- 加载中状态 -->
      <div class="loading-more" v-else-if="loading">
        <el-icon class="is-loading"><Loading /></el-icon>
        <span>加载中...</span>
      </div>
      
      <!-- 空状态 -->
      <div v-else class="empty-products">
        <el-empty description="暂无商品数据" />
      </div>
    </div>

    <!-- 页脚 -->
    <el-footer class="footer">
      <div class="footer-content">
        <div class="footer-logo">🐟 飞鱼商城</div>
        <p>分布式电商系统 | 新鲜直达 品质保证</p>
        <div class="footer-links">
          <span><el-icon><Phone /></el-icon> 客服热线: 400-888-8888</span>
          <span><el-icon><Message /></el-icon> 邮箱: service@afishing.com</span>
        </div>
      </div>
    </el-footer>
    
    <!-- 回到顶部按钮 -->
    <el-backtop :visibility-height="200" />

    <!-- AI 小猫咪助手 -->
    <DancingCharacter />
  </div>
</template>

<script setup>
import { reactive, ref, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { 
  Loading, ShoppingCart, Grid, TrendCharts, Trophy, User, 
  Phone, Message, Star
} from '@element-plus/icons-vue'
import AppHeader from '@/components/AppHeader.vue'
import DancingCharacter from '@/components/DancingCharacter.vue'
import { addToCart as addToCartApi } from '@/api/cart'
import { getProductList } from '@/api/product'
import { getImageUrl } from '@/utils/image'

const router = useRouter()

const banners = reactive([
  { id: 1, title: '欢迎来到飞鱼商城', desc: '新鲜直达，品质保证', color: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)', icon: '🐟' },
  { id: 2, title: '限时特惠', desc: '全场商品低至5折起', color: 'linear-gradient(135deg, #f093fb 0%, #f5576c 100%)', icon: '🔥' },
  { id: 3, title: '新品上市', desc: '挪威三文鱼新鲜到货', color: 'linear-gradient(135deg, #4facfe 0%, #00f2fe 100%)', icon: '✨' }
])

const categories = reactive([
  { id: 1, name: '海鲜鱼类', icon: '🐟' },
  { id: 2, name: '虾蟹贝类', icon: '🦐' },
  { id: 3, name: '冷冻食品', icon: '🧊' },
  { id: 4, name: '水产干货', icon: '🦑' },
  { id: 5, name: '特色美食', icon: '🍣' },
  { id: 6, name: '限时特惠', icon: '🔥' }
])

// 热门商品无限滚动相关
const hotProducts = reactive([])
const page = ref(1)
const pageSize = 8
const loading = ref(false)
const finished = ref(false)
const loadingMore = ref(false)

// 备用商品数据（当接口失败时使用）
const useBackupData = () => {
  const backupProducts = [
    { id: 1, name: '新鲜三文鱼', description: '挪威进口，肉质鲜美', price: 68.00, sales: 1256, mainImage: 'https://picsum.photos/200/150?random=1' },
    { id: 2, name: '大闸蟹礼盒', description: '阳澄湖直供，膏肥黄满', price: 299.00, sales: 892, mainImage: 'https://picsum.photos/200/150?random=2' },
    { id: 3, name: '冷冻虾仁', description: '深海捕捞，去壳去虾线', price: 45.00, sales: 2341, mainImage: 'https://picsum.photos/200/150?random=3' },
    { id: 4, name: '墨鱼仔', description: '新鲜速冻，口感Q弹', price: 38.00, sales: 567, mainImage: 'https://picsum.photos/200/150?random=4' },
    { id: 5, name: '波士顿龙虾', description: '鲜活空运，肉质鲜美', price: 398.00, sales: 234, mainImage: 'https://picsum.photos/200/150?random=5' },
    { id: 6, name: '鲍鱼', description: '大连野生，肉质肥厚', price: 158.00, sales: 432, mainImage: 'https://picsum.photos/200/150?random=6' },
    { id: 7, name: '扇贝', description: '新鲜扇贝，肉质鲜甜', price: 58.00, sales: 789, mainImage: 'https://picsum.photos/200/150?random=7' },
    { id: 8, name: '生蚝', description: '乳山生蚝，个大肥美', price: 48.00, sales: 1234, mainImage: 'https://picsum.photos/200/150?random=8' }
  ]
  hotProducts.length = 0
  hotProducts.push(...backupProducts)
  finished.value = true
  console.log('使用备用数据')
}

// 加载商品列表
const loadProducts = async (isLoadMore = false) => {
  if (loading.value || loadingMore.value) return
  
  if (isLoadMore) {
    loadingMore.value = true
  } else {
    loading.value = true
    page.value = 1
  }
  
  try {
    console.log('正在加载商品，页码:', page.value)
    const res = await getProductList({
      page: page.value,
      pageSize: pageSize,
      sortBy: 'sales'
    })
    
    console.log('商品接口返回:', res)
    console.log('res.data:', res.data)
    console.log('res.data.data:', res.data?.data)
    
    if ((res.code === 0 || res.code === 200) && res.data) {
      // 后端返回的数据在 res.data.data 中
      const products = res.data.data || []
      console.log('获取到商品数量:', products.length, '商品数据:', products)
      
      if (isLoadMore) {
        hotProducts.push(...products)
      } else {
        hotProducts.length = 0
        hotProducts.push(...products)
      }
      
      // 判断是否还有更多数据（注意：分页信息在 res.data 中，商品列表在 res.data.data 中）
      if (products.length < pageSize || page.value >= res.data.totalPages || products.length === 0) {
        finished.value = true
      }
      
      page.value++
    } else {
      console.error('接口返回错误:', res)
      // 如果接口失败，使用备用数据
      if (!isLoadMore && hotProducts.length === 0) {
        useBackupData()
      }
    }
  } catch (error) {
    console.error('加载商品失败:', error)
    // 如果接口失败，使用备用数据
    if (!isLoadMore && hotProducts.length === 0) {
      useBackupData()
    }
  } finally {
    loading.value = false
    loadingMore.value = false
  }
}

// 滚动监听
const handleScroll = () => {
  const scrollTop = window.scrollY || document.documentElement.scrollTop
  const windowHeight = window.innerHeight
  const documentHeight = document.documentElement.scrollHeight
  
  // 距离底部 200px 时加载更多
  if (scrollTop + windowHeight >= documentHeight - 200) {
    if (!finished.value && !loadingMore.value) {
      loadProducts(true)
    }
  }
}

onMounted(() => {
  loadProducts()
  window.addEventListener('scroll', handleScroll)
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
})

const addToCart = async (product) => {
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
      productImage: getImageUrl(product.mainImage || product.image),
      productSpec: '500g',
      price: product.price,
      quantity: 1
    })
    
    // 触发购物车更新事件
    window.dispatchEvent(new Event('cartUpdated'))
    
    ElMessage.success(`已将 ${product.name} 加入购物车`)
  } catch (error) {
    console.error('添加到购物车失败:', error)
  }
}
</script>

<style scoped>
.home-container {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  background: linear-gradient(180deg, #f5f7fa 0%, #e4e7ed 100%);
}

.banner {
  width: 100%;
}

.banner-content {
  height: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  color: #fff;
  animation: fadeIn 0.5s ease-in-out;
}

.banner-icon {
  margin-bottom: 20px;
  opacity: 0.9;
  font-size: 80px;
  line-height: 1;
}

.banner-content h1 {
  font-size: 48px;
  margin-bottom: 15px;
  text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.2);
}

.banner-content p {
  font-size: 20px;
  margin-bottom: 30px;
  opacity: 0.9;
}

.section {
  padding: 50px 40px;
  max-width: 1400px;
  margin: 0 auto;
  width: 100%;
}

.section-header {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 12px;
  margin-bottom: 35px;
}

.section-icon {
  color: #409eff;
}

.section-title {
  text-align: center;
  font-size: 28px;
  color: #303133;
  margin: 0;
  font-weight: 600;
}

.categories {
  background: #fff;
  border-radius: 16px;
  margin: -30px auto 30px;
  position: relative;
  z-index: 10;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  max-width: 1320px;
}

.category-grid {
  display: flex;
  justify-content: space-between;
  gap: 20px;
}

.category-card {
  text-align: center;
  cursor: pointer;
  padding: 25px 15px;
  border-radius: 12px;
  border: none;
  transition: all 0.3s ease;
  background: linear-gradient(145deg, #ffffff 0%, #f5f7fa 100%);
  flex: 1;
}

.category-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 12px 24px rgba(64, 158, 255, 0.2);
  background: linear-gradient(145deg, #409eff 0%, #66b1ff 100%);
}

.category-card:hover .icon-wrapper {
  background: rgba(255, 255, 255, 0.2);
}

.category-card:hover .name {
  color: #fff;
}

.category-card .icon-wrapper {
  width: 70px;
  height: 70px;
  margin: 0 auto 15px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #409eff 0%, #66b1ff 100%);
  border-radius: 50%;
  color: #fff;
  transition: all 0.3s ease;
  font-size: 32px;
}

.category-card .name {
  color: #606266;
  font-weight: 500;
  transition: all 0.3s ease;
}

.hot-products {
  min-height: 500px;
}

.product-card {
  cursor: pointer;
  transition: all 0.3s ease;
  margin-bottom: 20px;
  border-radius: 12px;
  overflow: hidden;
  border: none;
}

.product-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 12px 30px rgba(0, 0, 0, 0.12);
}

.product-image-wrapper {
  position: relative;
  overflow: hidden;
}

.product-image {
  width: 100%;
  height: 180px;
  object-fit: cover;
  transition: transform 0.3s ease;
}

.product-card:hover .product-image {
  transform: scale(1.05);
}

.product-badge {
  position: absolute;
  top: 10px;
  left: 10px;
  background: linear-gradient(135deg, #f56c6c 0%, #e6a23c 100%);
  color: #fff;
  padding: 4px 12px;
  border-radius: 20px;
  font-size: 12px;
  display: flex;
  align-items: center;
  gap: 4px;
}

.product-info {
  padding: 18px;
}

.product-info h3 {
  font-size: 16px;
  margin-bottom: 8px;
  color: #303133;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.product-info .desc {
  font-size: 13px;
  color: #909399;
  margin-bottom: 12px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.price-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
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
  font-size: 24px;
  font-weight: bold;
}

.sales {
  color: #909399;
  font-size: 12px;
  display: flex;
  align-items: center;
  gap: 4px;
}

.add-cart-btn {
  width: calc(100% - 36px);
  margin: 0 18px 18px;
  border-radius: 8px;
  font-weight: 500;
}

.footer {
  background: linear-gradient(135deg, #303133 0%, #1a1a1a 100%);
  color: #fff;
  padding: 40px 20px;
  margin-top: auto;
}

.footer-content {
  max-width: 1400px;
  margin: 0 auto;
  text-align: center;
}

.footer-logo {
  font-size: 24px;
  font-weight: bold;
  margin-bottom: 10px;
}

.footer-content p {
  opacity: 0.8;
  margin-bottom: 15px;
}

.footer-links {
  display: flex;
  justify-content: center;
  gap: 30px;
  opacity: 0.7;
}

.footer-links span {
  display: flex;
  align-items: center;
  gap: 6px;
}

.loading-more {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 30px;
  color: #909399;
  gap: 10px;
}

.no-more {
  padding: 20px 0;
}

.empty-products {
  padding: 60px 0;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(20px); }
  to { opacity: 1; transform: translateY(0); }
}
</style>
