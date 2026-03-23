<template>
  <div class="product-list-container">
    <!-- 头部导航 -->
    <AppHeader />

    <div class="main-content">
      <!-- 侧边栏筛选 -->
      <el-aside width="240px" class="sidebar">
        <el-card class="category-card">
          <template #header>
            <div class="category-header">
              <el-icon :size="20"><Grid /></el-icon>
              <span>商品分类</span>
            </div>
          </template>
          <el-menu :default-active="selectedCategory.toString()" class="category-menu">
            <el-menu-item v-for="cat in categories" :key="cat.id" :index="cat.id.toString()" @click="handleCategoryChange(cat.id)">
              <span class="category-icon">{{ cat.icon }}</span>
              <span>{{ cat.name }}</span>
            </el-menu-item>
          </el-menu>
        </el-card>
      </el-aside>

      <!-- 商品列表 -->
      <el-main class="product-main">
        <!-- 工具栏 -->
        <el-card class="toolbar">
          <el-row justify="space-between" align="middle">
            <el-col :span="12">
              <el-input v-model="searchKeyword" placeholder="搜索商品..." class="search-input" @keyup.enter="handleSearch">
                <template #prefix>
                  <el-icon><Search /></el-icon>
                </template>
                <template #append>
                  <el-button @click="handleSearch">
                    <el-icon><Search /></el-icon>搜索
                  </el-button>
                </template>
              </el-input>
            </el-col>
            <el-col :span="12" style="text-align: right">
              <span class="sort-label">
                <el-icon><Sort /></el-icon>排序：
              </span>
              <el-select v-model="sortBy" placeholder="请选择" style="width: 150px" @change="fetchProducts">
                <el-option label="默认排序" value="default">
                  <el-icon><List /></el-icon> 默认排序
                </el-option>
                <el-option label="价格升序" value="price-asc">
                  <el-icon><Top /></el-icon> 价格升序
                </el-option>
                <el-option label="价格降序" value="price-desc">
                  <el-icon><Bottom /></el-icon> 价格降序
                </el-option>
                <el-option label="销量优先" value="sales">
                  <el-icon><TrendCharts /></el-icon> 销量优先
                </el-option>
              </el-select>
            </el-col>
          </el-row>
        </el-card>

        <!-- 加载状态 -->
        <el-skeleton v-if="loading" :rows="5" animated style="margin-top: 20px" />

        <!-- 商品网格 -->
        <el-row v-else-if="products.length > 0" :gutter="20" style="margin-top: 20px">
          <el-col :span="6" v-for="product in products" :key="product.id">
            <el-card shadow="hover" class="product-card" @click="$router.push(`/products/${product.id}`)">
              <div class="product-image-wrapper">
                <img :src="getImageUrl(product.mainImage)" class="product-image" />
                <div class="product-badge" v-if="product.sales > 500">
                  <el-icon><Trophy /></el-icon> 热卖
                </div>
              </div>
              <div class="product-info">
                <h3>{{ product.name }}</h3>
                <p class="desc">{{ product.description }}</p>
                <div class="price-row">
                  <div class="current-price">
                    <span class="price-symbol">¥</span>
                    <span class="price">{{ product.price }}</span>
                  </div>
                  <span class="original-price" v-if="product.originalPrice">¥{{ product.originalPrice }}</span>
                </div>
                <div class="sales-info">
                  <el-icon><User /></el-icon>
                  <span>已售 {{ product.sales }} 件</span>
                </div>
              </div>
              <el-button type="primary" class="add-cart-btn" @click.stop="addToCart(product)">
                <el-icon><ShoppingCart /></el-icon>
                加入购物车
              </el-button>
            </el-card>
          </el-col>
        </el-row>

        <!-- 空状态 -->
        <el-empty v-else description="暂无商品">
          <el-button type="primary" @click="handleCategoryChange(0)">查看全部商品</el-button>
        </el-empty>

        <!-- 分页 -->
        <el-pagination
          v-model:current-page="currentPage"
          v-model:page-size="pageSize"
          :total="total"
          :page-sizes="[8, 12, 16, 24]"
          layout="total, sizes, prev, pager, next, jumper"
          background
          class="pagination"
          @size-change="fetchProducts"
          @current-change="fetchProducts"
        />
      </el-main>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { Search, Grid, Sort, List, Top, Bottom, TrendCharts, Trophy, User, ShoppingCart } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import AppHeader from '@/components/AppHeader.vue'
import { getProductList } from '@/api/product'
import { addToCart as addToCartApi } from '@/api/cart'
import { getImageUrl } from '@/utils/image'

const router = useRouter()

const categories = reactive([
  { id: 0, name: '全部', icon: '📋' },
  { id: 1, name: '海鲜鱼类', icon: '🐟' },
  { id: 2, name: '虾蟹贝类', icon: '🦐' },
  { id: 3, name: '冷冻食品', icon: '🧊' },
  { id: 4, name: '水产干货', icon: '🦑' },
  { id: 5, name: '特色美食', icon: '🍣' }
])

const selectedCategory = ref(0)
const searchKeyword = ref('')
const sortBy = ref('default')
const currentPage = ref(1)
const pageSize = ref(12)
const total = ref(0)
const loading = ref(false)

const products = reactive([])

// 获取商品列表
const fetchProducts = async () => {
  loading.value = true
  try {
    const params = {
      page: currentPage.value,
      size: pageSize.value,
      keyword: searchKeyword.value || undefined
    }
    
    // 分类筛选
    if (selectedCategory.value > 0) {
      params.categoryId = selectedCategory.value
    }
    
    // 排序参数
    if (sortBy.value && sortBy.value !== 'default') {
      params.sortBy = sortBy.value
    }
    
    const res = await getProductList(params)
    // 后端返回的是 PageResult，包含 data, total, page, size
    products.splice(0, products.length, ...res.data.data)
    total.value = res.data.total
  } catch (error) {
    console.error('获取商品列表失败:', error)
    ElMessage.error('获取商品列表失败')
  } finally {
    loading.value = false
  }
}

// 分类切换
const handleCategoryChange = (categoryId) => {
  selectedCategory.value = categoryId
  currentPage.value = 1
  fetchProducts()
}

// 搜索
const handleSearch = () => {
  currentPage.value = 1
  fetchProducts()
}

// 加入购物车
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
      productImage: getImageUrl(product.mainImage),
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

// 初始化
onMounted(() => {
  fetchProducts()
})
</script>

<style scoped>
.product-list-container {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  background: linear-gradient(180deg, #f5f7fa 0%, #e4e7ed 100%);
}

.main-content {
  display: flex;
  flex: 1;
  padding: 20px;
  max-width: 1400px;
  margin: 0 auto;
  width: 100%;
}

.sidebar {
  margin-right: 20px;
}

.category-card {
  border-radius: 12px;
  border: none;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
}

.category-header {
  display: flex;
  align-items: center;
  gap: 8px;
  font-weight: 600;
  color: #303133;
}

.category-menu {
  border: none;
}

.category-menu .el-menu-item {
  border-radius: 8px;
  margin: 4px 0;
  transition: all 0.3s ease;
}

.category-icon {
  font-size: 18px;
  margin-right: 8px;
}

.category-menu .el-menu-item:hover {
  background: linear-gradient(135deg, #409eff 0%, #66b1ff 100%);
  color: #fff;
}

.category-menu .el-menu-item.is-active {
  background: linear-gradient(135deg, #409eff 0%, #66b1ff 100%);
  color: #fff;
}

.product-main {
  padding: 0;
  background: transparent;
}

.toolbar {
  border-radius: 12px;
  border: none;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
}

.search-input {
  width: 350px;
}

.sort-label {
  margin-right: 10px;
  display: inline-flex;
  align-items: center;
  gap: 4px;
  color: #606266;
}

.product-card {
  cursor: pointer;
  margin-bottom: 20px;
  border-radius: 12px;
  border: none;
  overflow: hidden;
  transition: all 0.3s ease;
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
  padding: 15px;
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
  font-size: 12px;
  color: #909399;
  margin-bottom: 10px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.price-row {
  display: flex;
  align-items: baseline;
  gap: 10px;
  margin-bottom: 8px;
}

.current-price {
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
  font-size: 22px;
  font-weight: bold;
}

.original-price {
  color: #909399;
  font-size: 14px;
  text-decoration: line-through;
}

.sales-info {
  display: flex;
  align-items: center;
  gap: 4px;
  color: #909399;
  font-size: 12px;
}

.add-cart-btn {
  width: calc(100% - 30px);
  margin: 0 15px 15px;
  border-radius: 8px;
}

.pagination {
  margin-top: 30px;
  justify-content: center;
}
</style>
