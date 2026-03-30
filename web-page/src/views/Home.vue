<template>
  <div class="home-container">
    <!-- 头部导航 -->
    <AppHeader />

    <!-- 轮播图 -->
    <el-carousel height="480px" class="banner" :interval="5000" arrow="always">
      <el-carousel-item v-for="item in banners" :key="item.id">
        <!-- 商品轮播图：以商品主图为背景 -->
        <div
          v-if="item.type === 'product'"
          class="banner-content banner-product"
          :style="{ backgroundImage: `url(${getImageUrl(item.image)})` }"
          @click="$router.push(`/products/${item.productId}`)"
        >
          <div class="banner-overlay"></div>
          <div class="banner-inner">
            <h1>{{ item.title }}</h1>
            <p>{{ item.desc }}</p>
            <el-button type="primary" size="large" round @click.stop="$router.push(`/products/${item.productId}`)" class="banner-btn">
              <el-icon><ShoppingCart /></el-icon>
              查看详情
            </el-button>
          </div>
        </div>
        <!-- 静态轮播图：渐变色背景 -->
        <div
          v-else
          class="banner-content"
          :style="{ background: item.color }"
        >
          <div class="banner-overlay"></div>
          <div class="banner-inner">
            <div class="banner-icon">{{ item.icon }}</div>
            <h1>{{ item.title }}</h1>
            <p>{{ item.desc }}</p>
            <el-button type="primary" size="large" round @click="$router.push('/products')" class="banner-btn">
              <el-icon><ShoppingCart /></el-icon>
              立即选购
            </el-button>
          </div>
        </div>
      </el-carousel-item>
    </el-carousel>

    <!-- 商品分类 -->
    <div class="section categories">
      <div class="section-header">
        <div class="section-title-wrapper">
          <el-icon class="section-icon" :size="24"><Grid /></el-icon>
          <h2 class="section-title">商品分类</h2>
        </div>
        <div class="section-line"></div>
      </div>
      <div class="category-grid">
        <div class="category-card" v-for="cat in categories" :key="cat.id" @click="$router.push('/products')">
          <div class="icon-wrapper">{{ cat.icon }}</div>
          <div class="name">{{ cat.name }}</div>
        </div>
      </div>
    </div>

    <!-- 热门商品 -->
    <div class="section hot-products">
      <div class="section-header">
        <div class="section-title-wrapper">
          <el-icon class="section-icon" :size="24"><TrendCharts /></el-icon>
          <h2 class="section-title">热门商品</h2>
        </div>
        <div class="section-line"></div>
      </div>
      
      <!-- 商品列表 -->
      <template v-if="hotProducts.length > 0">
        <el-row :gutter="20">
          <el-col :span="6" v-for="product in hotProducts" :key="product.id">
            <el-card shadow="never" class="product-card" @click="$router.push(`/products/${product.id}`)">
              <div class="product-image-wrapper">
                <img :src="getImageUrl(product.mainImage || product.image)" class="product-image" />
                <div class="product-badge" v-if="product.sales > 1000">
                  <el-icon><Trophy /></el-icon> 热销
                </div>
                <div class="product-overlay">
                  <el-button type="primary" size="small" round @click.stop="addToCart(product)">加入购物车</el-button>
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
    <footer class="footer">
      <div class="footer-content">
        <div class="footer-brand">
          <div class="footer-logo">🐟 飞鱼商城</div>
          <p class="footer-slogan">分布式电商系统 | 新鲜直达 品质保证</p>
        </div>
        <div class="footer-divider"></div>
        <div class="footer-links">
          <div class="footer-link-item">
            <el-icon><Phone /></el-icon>
            <div>
              <div class="link-label">客服热线</div>
              <div class="link-value">400-888-8888</div>
            </div>
          </div>
          <div class="footer-link-item">
            <el-icon><Message /></el-icon>
            <div>
              <div class="link-label">邮笱联系</div>
              <div class="link-value">service@afishing.com</div>
            </div>
          </div>
        </div>
      </div>
      <div class="footer-bottom">
        <span>© 2024 飞鱼商城. All rights reserved.</span>
      </div>
    </footer>
    
    <!-- 回到顶部按钮 -->
    <el-backtop :visibility-height="200" />

    <!-- AI 小猫咪助手 -->
    <DancingCharacter />
  </div>
</template>

<script setup>
import { reactive, ref, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElNotification } from 'element-plus'
import { 
  Loading, ShoppingCart, Grid, TrendCharts, Trophy, User, 
  Phone, Message, Star
} from '@element-plus/icons-vue'
import AppHeader from '@/components/AppHeader.vue'
import DancingCharacter from '@/components/DancingCharacter.vue'
import { addToCart as addToCartApi } from '@/api/cart'
import { getProductList, getBannerProducts } from '@/api/product'
import { getImageUrl } from '@/utils/image'
import { getActiveNotices } from '@/api/notice'

const router = useRouter()

const banners = reactive([
  { id: 1, title: '欢迎来到飞鱼商城', desc: '新鲜直达，品质保证', color: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)', icon: '🐟', type: 'static' },
  { id: 2, title: '限时特惠', desc: '全场商品低至5折起', color: 'linear-gradient(135deg, #f093fb 0%, #f5576c 100%)', icon: '🔥', type: 'static' },
  { id: 3, title: '新品上市', desc: '挝威三文鱼新鲜到货', color: 'linear-gradient(135deg, #4facfe 0%, #00f2fe 100%)', icon: '✨', type: 'static' }
])

// 加载轮播图商品
const loadBannerProducts = async () => {
  try {
    const res = await getBannerProducts()
    const products = res.data || []
    if (products.length > 0) {
      // 将商品数据转换为轮播图数据，替换静态轮播图
      banners.length = 0
      products.forEach(product => {
        banners.push({
          id: product.id,
          title: product.name,
          desc: product.description || '新鲜直达，品质保证',
          image: product.mainImage,
          productId: product.id,
          type: 'product'
        })
      })
    }
  } catch (error) {
    console.error('加载轮播图商品失败，使用默认轮播图')
  }
}

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
  loadBannerProducts()
  loadProducts()
  loadAndShowNotices()
  window.addEventListener('scroll', handleScroll)
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
})

// 加载并显示公告
const loadAndShowNotices = async () => {
  try {
    const res = await getActiveNotices()
    const notices = res.data || []
    if (notices.length > 0) {
      notices.forEach((notice, index) => {
        setTimeout(() => {
          const noticeType = notice.type === 1 ? 'info' : notice.type === 2 ? 'success' : 'warning'
          ElNotification({
            title: notice.title,
            message: notice.content,
            type: noticeType,
            position: 'top-right',
            duration: 5000, // 5秒后自动关闭（悬停时暂停）
            offset: index * 120
          })
        }, index * 300) // 错开显示时间
      })
    }
  } catch (error) {
    console.error('加载公告失败:', error)
  }
}

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
  background: #f7f8fc;
}

.banner {
  width: 100%;
}

.banner-content {
  height: 100%;
  position: relative;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
}

.banner-product {
  background-size: cover;
  background-position: center;
  cursor: pointer;
}

.banner-overlay {
  position: absolute;
  inset: 0;
  background: rgba(0,0,0,0.15);
  backdrop-filter: blur(1px);
}

.banner-inner {
  position: relative;
  z-index: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  color: #fff;
  animation: fadeInUp 0.6s ease-out;
}

.banner-icon {
  margin-bottom: 20px;
  font-size: 90px;
  line-height: 1;
  filter: drop-shadow(0 4px 12px rgba(0,0,0,0.3));
}

.banner-inner h1 {
  font-size: 52px;
  margin-bottom: 16px;
  font-weight: 700;
  letter-spacing: 2px;
  text-shadow: 0 2px 12px rgba(0,0,0,0.25);
}

.banner-inner p {
  font-size: 20px;
  margin-bottom: 32px;
  opacity: 0.92;
  font-weight: 300;
  letter-spacing: 1px;
}

.banner-btn {
  padding: 14px 36px;
  font-size: 16px;
  font-weight: 500;
  background: rgba(255,255,255,0.2);
  backdrop-filter: blur(4px);
  border: 1.5px solid rgba(255,255,255,0.6);
  color: #fff;
  letter-spacing: 1px;
  transition: all 0.3s;
}

.banner-btn:hover {
  background: rgba(255,255,255,0.35);
  transform: translateY(-2px);
  box-shadow: 0 8px 24px rgba(0,0,0,0.2);
}

.section {
  padding: 50px 40px;
  max-width: 1400px;
  margin: 0 auto;
  width: 100%;
  box-sizing: border-box;
}

.section-header {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-bottom: 36px;
}

.section-title-wrapper {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 12px;
}

.section-icon {
  color: #409eff;
}

.section-title {
  font-size: 28px;
  color: #1a2744;
  margin: 0;
  font-weight: 700;
  letter-spacing: 1px;
}

.section-line {
  width: 48px;
  height: 3px;
  background: linear-gradient(90deg, #409eff, #764ba2);
  border-radius: 2px;
}

.categories {
  background: #fff;
  border-radius: 20px;
  margin: -36px auto 30px;
  position: relative;
  z-index: 10;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.08);
  max-width: 1320px;
}

.category-grid {
  display: flex;
  justify-content: space-between;
  gap: 16px;
}

.category-card {
  text-align: center;
  cursor: pointer;
  padding: 24px 12px;
  border-radius: 16px;
  transition: all 0.3s ease;
  background: #f7f8fc;
  flex: 1;
}

.category-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 12px 28px rgba(64, 158, 255, 0.22);
  background: linear-gradient(145deg, #409eff 0%, #764ba2 100%);
}

.category-card:hover .icon-wrapper {
  background: rgba(255, 255, 255, 0.25);
}

.category-card:hover .name {
  color: #fff;
}

.category-card .icon-wrapper {
  width: 66px;
  height: 66px;
  margin: 0 auto 14px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #409eff 0%, #764ba2 100%);
  border-radius: 50%;
  transition: all 0.3s ease;
  font-size: 30px;
}

.category-card .name {
  color: #606266;
  font-weight: 500;
  font-size: 14px;
  transition: all 0.3s ease;
}

.hot-products {
  min-height: 500px;
}

.product-card {
  cursor: pointer;
  transition: all 0.3s ease;
  margin-bottom: 20px;
  border-radius: 16px;
  overflow: hidden;
  border: 1px solid #f0f2f5;
  box-shadow: 0 2px 12px rgba(0,0,0,0.04);
}

.product-card:hover {
  transform: translateY(-6px);
  box-shadow: 0 16px 40px rgba(64, 158, 255, 0.14);
  border-color: rgba(64,158,255,0.2);
}

.product-image-wrapper {
  position: relative;
  overflow: hidden;
}

.product-image {
  width: 100%;
  height: 190px;
  object-fit: cover;
  transition: transform 0.4s ease;
}

.product-card:hover .product-image {
  transform: scale(1.08);
}

.product-overlay {
  position: absolute;
  inset: 0;
  background: rgba(0,0,0,0.35);
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: opacity 0.3s ease;
}

.product-card:hover .product-overlay {
  opacity: 1;
}

.product-badge {
  position: absolute;
  top: 10px;
  left: 10px;
  background: linear-gradient(135deg, #f56c6c 0%, #e6a23c 100%);
  color: #fff;
  padding: 4px 10px;
  border-radius: 20px;
  font-size: 12px;
  display: flex;
  align-items: center;
  gap: 4px;
  font-weight: 500;
}

.product-info {
  padding: 16px;
}

.product-info h3 {
  font-size: 15px;
  margin-bottom: 6px;
  color: #1a2744;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  font-weight: 600;
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
  font-size: 13px;
  margin-right: 1px;
  font-weight: 600;
}

.price {
  color: #f56c6c;
  font-size: 22px;
  font-weight: 700;
}

.sales {
  color: #c0c4cc;
  font-size: 12px;
  display: flex;
  align-items: center;
  gap: 3px;
}

.footer {
  background: linear-gradient(135deg, #1a2744 0%, #0d1b36 100%);
  color: #fff;
  margin-top: auto;
}

.footer-content {
  max-width: 1400px;
  margin: 0 auto;
  padding: 48px 40px 32px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  gap: 32px;
}

.footer-brand {
  text-align: left;
}

.footer-logo {
  font-size: 24px;
  font-weight: 700;
  margin-bottom: 8px;
  letter-spacing: 1px;
}

.footer-slogan {
  color: rgba(255,255,255,0.55);
  font-size: 14px;
  margin: 0;
}

.footer-divider {
  width: 1px;
  height: 60px;
  background: rgba(255,255,255,0.15);
}

.footer-links {
  display: flex;
  gap: 40px;
}

.footer-link-item {
  display: flex;
  align-items: center;
  gap: 12px;
  color: rgba(255,255,255,0.7);
}

.footer-link-item .el-icon {
  font-size: 22px;
  color: #409eff;
}

.link-label {
  font-size: 12px;
  color: rgba(255,255,255,0.45);
  margin-bottom: 2px;
}

.link-value {
  font-size: 14px;
  font-weight: 500;
}

.footer-bottom {
  text-align: center;
  padding: 16px 40px;
  border-top: 1px solid rgba(255,255,255,0.08);
  font-size: 13px;
  color: rgba(255,255,255,0.3);
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

@keyframes fadeInUp {
  from { opacity: 0; transform: translateY(30px); }
  to { opacity: 1; transform: translateY(0); }
}
</style>
