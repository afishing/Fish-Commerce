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
              <el-input v-model="searchKeyword" placeholder="搜索商品..." class="search-input" @keyup.enter="handleSearch" size="large">
                <template #prefix>
                  <el-icon><Search /></el-icon>
                </template>
                <template #append>
                  <el-button @click="handleSearch" type="primary">搜索</el-button>
                </template>
              </el-input>
            </el-col>
            <el-col :span="12" style="text-align: right">
              <el-select v-model="sortBy" placeholder="请选择" style="width: 150px" @change="fetchProducts">
                <el-option label="默认排序" value="default" />
                <el-option label="价格升序" value="price-asc" />
                <el-option label="价格降序" value="price-desc" />
                <el-option label="销量优先" value="sales" />
              </el-select>
            </el-col>
          </el-row>
          <!-- 标签筛选（多选） -->
          <div v-if="tagList.length > 0" class="tag-filter-bar">
            <span class="tag-filter-label">
              <el-icon><PriceTag /></el-icon> 标签筛选：
            </span>
            <div class="tag-filter-list">
              <el-tag
                v-for="tag in tagList"
                :key="tag.id"
                class="tag-filter-item"
                :class="{ 'tag-active': selectedTagIds.includes(tag.id) }"
                :style="selectedTagIds.includes(tag.id)
                  ? { backgroundColor: tag.color, color: '#fff', borderColor: tag.color }
                  : { backgroundColor: tag.color + '15', color: tag.color, borderColor: tag.color + '40' }"
                @click="handleTagFilter(tag.id)"
              >
                <el-icon v-if="selectedTagIds.includes(tag.id)" style="margin-right:2px"><Check /></el-icon>
                {{ tag.name }}
              </el-tag>
              <el-tag
                v-if="selectedTagIds.length > 0"
                class="tag-filter-item tag-clear"
                @click="clearAllTags"
              >
                <el-icon><Close /></el-icon> 清除 ({{ selectedTagIds.length }})
              </el-tag>
            </div>
          </div>
        </el-card>

        <!-- 加载状态 -->
        <el-skeleton v-if="loading" :rows="5" animated style="margin-top: 20px" />

        <!-- 商品网格 -->
        <el-row v-else-if="products.length > 0" :gutter="20" style="margin-top: 20px">
          <el-col :span="6" v-for="product in products" :key="product.id">
            <el-card shadow="never" class="product-card" @click="$router.push(`/products/${product.id}`)">
              <div class="product-image-wrapper">
                <img :src="getImageUrl(product.mainImage)" class="product-image" />
                <div class="product-badge" v-if="product.sales > 500">
                  <el-icon><Trophy /></el-icon> 热卖
                </div>
                <div class="product-hover-btn">
                  <el-button type="primary" size="small" round @click.stop="addToCart(product)">加入购物车</el-button>
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
import { Search, Grid, Sort, List, Top, Bottom, TrendCharts, Trophy, User, ShoppingCart, PriceTag, Close, Check } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import AppHeader from '@/components/AppHeader.vue'
import { getProductList } from '@/api/product'
import { addToCart as addToCartApi } from '@/api/cart'
import { getImageUrl } from '@/utils/image'
import { getAllTags } from '@/api/tag'

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
const selectedTagIds = ref([])
const tagList = ref([])

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
    
    // 标签筛选（多选）
    if (selectedTagIds.value && selectedTagIds.value.length > 0) {
      params.tagIds = selectedTagIds.value.join(',')
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

// 标签筛选（多选）
const handleTagFilter = (tagId) => {
  const index = selectedTagIds.value.indexOf(tagId)
  if (index > -1) {
    selectedTagIds.value.splice(index, 1)
  } else {
    selectedTagIds.value.push(tagId)
  }
  selectedCategory.value = 0
  currentPage.value = 1
  fetchProducts()
}

// 清除所有标签筛选
const clearAllTags = () => {
  selectedTagIds.value = []
  currentPage.value = 1
  fetchProducts()
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
onMounted(async () => {
  fetchProducts()
  try {
    const res = await getAllTags()
    tagList.value = res.data || []
  } catch (e) {}
})
</script>

<style scoped>
.product-list-container {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  background: #f7f8fc;
}

.main-content {
  display: flex;
  flex: 1;
  padding: 24px 32px;
  max-width: 1400px;
  margin: 0 auto;
  width: 100%;
  box-sizing: border-box;
}

.sidebar {
  margin-right: 20px;
}

.category-card {
  border-radius: 16px;
  border: none;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.06);
  overflow: hidden;
}

.tag-card {
  border-radius: 16px;
  border: none;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.06);
  overflow: hidden;
}

.tag-list {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.tag-item {
  border-radius: 20px;
  font-size: 12px;
  transition: all 0.2s;
  user-select: none;
}

.tag-item:hover {
  opacity: 0.85;
  transform: translateY(-1px);
}

.category-header {
  display: flex;
  align-items: center;
  gap: 8px;
  font-weight: 700;
  color: #1a2744;
  font-size: 15px;
}

.category-menu {
  border: none;
}

.category-menu :deep(.el-menu-item) {
  border-radius: 10px;
  margin: 4px 6px;
  width: calc(100% - 12px);
  transition: all 0.25s ease;
  font-size: 14px;
}

.category-icon {
  font-size: 17px;
  margin-right: 8px;
}

.category-menu :deep(.el-menu-item:hover) {
  background: linear-gradient(135deg, rgba(64,158,255,0.1), rgba(118,75,162,0.08));
  color: #409eff;
}

.category-menu :deep(.el-menu-item.is-active) {
  background: linear-gradient(135deg, #409eff 0%, #764ba2 100%);
  color: #fff;
  box-shadow: 0 4px 12px rgba(64,158,255,0.3);
}

.product-main {
  padding: 0;
  background: transparent;
}

.toolbar {
  border-radius: 16px;
  border: none;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.06);
}

.search-input {
  width: 360px;
}

.tag-filter-bar {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-top: 16px;
  padding-top: 16px;
  border-top: 1px dashed #e4e7ed;
}

.tag-filter-label {
  display: flex;
  align-items: center;
  gap: 4px;
  font-size: 13px;
  color: #606266;
  font-weight: 500;
  white-space: nowrap;
}

.tag-filter-list {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  flex: 1;
}

.tag-filter-item {
  cursor: pointer;
  border-radius: 16px;
  font-size: 12px;
  padding: 4px 12px;
  transition: all 0.2s;
  user-select: none;
}

.tag-filter-item:hover {
  opacity: 0.85;
  transform: translateY(-1px);
}

.tag-filter-item.tag-active {
  font-weight: 500;
}

.tag-filter-item.tag-clear {
  background: #f5f7fa;
  color: #909399;
  border-color: #dcdfe6;
}

.tag-filter-item.tag-clear:hover {
  background: #f56c6c;
  color: #fff;
  border-color: #f56c6c;
}

.product-card {
  cursor: pointer;
  margin-bottom: 20px;
  border-radius: 16px;
  border: 1px solid #f0f2f5;
  overflow: hidden;
  transition: all 0.3s ease;
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
  height: 185px;
  object-fit: cover;
  transition: transform 0.4s ease;
}

.product-card:hover .product-image {
  transform: scale(1.08);
}

.product-hover-btn {
  position: absolute;
  inset: 0;
  background: rgba(0,0,0,0.35);
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: opacity 0.3s;
}

.product-card:hover .product-hover-btn {
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
  padding: 14px 16px;
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
  gap: 8px;
  margin-bottom: 8px;
}

.current-price {
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

.original-price {
  color: #c0c4cc;
  font-size: 13px;
  text-decoration: line-through;
}

.sales-info {
  display: flex;
  align-items: center;
  gap: 4px;
  color: #c0c4cc;
  font-size: 12px;
}

.pagination {
  margin-top: 30px;
  justify-content: center;
}
</style>
