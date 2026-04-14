<template>
  <div class="admin-stock">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>库存管理</span>
          <div>
            <el-button type="primary" @click="loadAllProducts">刷新</el-button>
          </div>
        </div>
      </template>

      <!-- 搜索栏 -->
      <el-form :model="queryForm" inline class="search-form">
        <el-form-item label="商品名称">
          <el-input v-model="queryForm.keyword" placeholder="搜索商品" clearable />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">查询</el-button>
          <el-button @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>

      <!-- 统计卡片 -->
      <el-row :gutter="20" class="stats-row">
        <el-col :span="8">
          <el-statistic title="缺货商品" :value="stats.empty" class="danger-stat" />
        </el-col>
        <el-col :span="8">
          <el-statistic title="库存预警(<20)" :value="stats.warning" class="warning-stat" />
        </el-col>
        <el-col :span="8">
          <el-statistic title="库存充足" :value="stats.normal" class="success-stat" />
        </el-col>
      </el-row>

      <!-- 商品库存列表 -->
      <el-table :data="pagedList" v-loading="loading" border>
        <el-table-column type="index" label="序号" width="60" />
        <el-table-column prop="name" label="商品名称" min-width="200" />
        <el-table-column prop="mainImage" label="图片" width="80">
          <template #default="{ row }">
            <el-image v-if="row.mainImage" :src="getImageUrl(row.mainImage)" style="width: 50px; height: 50px" fit="cover" />
          </template>
        </el-table-column>
        <el-table-column prop="stock" label="当前库存" width="120">
          <template #default="{ row }">
            <el-tag :type="getStockTagType(row.stock)" size="large">
              {{ row.stock }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="sales" label="已售数量" width="100" />
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="{ row }">
            <el-input-number v-model="row.newStock" :min="0" :max="99999" style="width: 100px" />
            <el-button type="primary" size="small" @click="updateStock(row)" style="margin-left: 8px">保存</el-button>
          </template>
        </el-table-column>
      </el-table>

      <el-pagination
        v-model:current-page="pagination.page"
        v-model:page-size="pagination.size"
        :total="sortedList.length"
        :page-sizes="[10, 20, 50, 100]"
        layout="total, sizes, prev, pager, next"
        style="margin-top: 20px; justify-content: flex-end"
      />
    </el-card>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { getProductList, updateProductStock } from '@/api/product'
import { getImageUrl } from '@/utils/image'

const loading = ref(false)
const allProducts = ref([])

const queryForm = reactive({
  keyword: ''
})

const pagination = reactive({
  page: 1,
  size: 20
})

const stats = reactive({
  empty: 0,
  warning: 0,
  normal: 0
})

// 排序后的完整列表（库存从少到多）
const sortedList = computed(() => {
  let list = [...allProducts.value]
  
  // 按名称搜索
  if (queryForm.keyword) {
    list = list.filter(p => p.name?.includes(queryForm.keyword))
  }
  
  // 按库存从小到大排序（库存少的在前面）
  list.sort((a, b) => (a.stock || 0) - (b.stock || 0))
  
  return list
})

// 分页后的数据
const pagedList = computed(() => {
  const start = (pagination.page - 1) * pagination.size
  const end = start + pagination.size
  return sortedList.value.slice(start, end)
})

const loadAllProducts = async () => {
  loading.value = true
  try {
    // 获取所有商品（不分页）
    const res = await getProductList({
      page: 1,
      size: 9999
    })
    if (res.code === 200 || res.code === 0) {
      allProducts.value = (res.data?.list || []).map(p => ({
        ...p,
        newStock: p.stock
      }))
      
      // 计算统计
      stats.empty = allProducts.value.filter(p => p.stock === 0).length
      stats.warning = allProducts.value.filter(p => p.stock > 0 && p.stock < 20).length
      stats.normal = allProducts.value.filter(p => p.stock >= 20).length
    }
  } catch (e) {
    console.error(e)
  } finally {
    loading.value = false
  }
}

const handleSearch = () => {
  pagination.page = 1
}

const handleReset = () => {
  queryForm.keyword = ''
  pagination.page = 1
}

const getStockTagType = (stock) => {
  if (stock === 0) return 'danger'
  if (stock < 20) return 'warning'
  return 'success'
}

const updateStock = async (row) => {
  try {
    const res = await updateProductStock(row.id, row.newStock)
    if (res.code === 200 || res.code === 0) {
      ElMessage.success(`商品 "${row.name}" 库存已更新为 ${row.newStock}`)
      row.stock = row.newStock
      // 重新计算统计
      stats.empty = allProducts.value.filter(p => p.stock === 0).length
      stats.warning = allProducts.value.filter(p => p.stock > 0 && p.stock < 20).length
      stats.normal = allProducts.value.filter(p => p.stock >= 20).length
    } else {
      ElMessage.error(res.message || '更新失败')
    }
  } catch (e) {
    console.error(e)
    ElMessage.error('更新库存失败')
  }
}

onMounted(() => {
  loadAllProducts()
})
</script>

<style scoped>
.admin-stock {
  padding: 20px;
}
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.search-form {
  margin-bottom: 20px;
}
.stats-row {
  margin-bottom: 20px;
}
.danger-stat :deep(.el-statistic__content) {
  color: #f56c6c;
}
.warning-stat :deep(.el-statistic__content) {
  color: #e6a23c;
}
.success-stat :deep(.el-statistic__content) {
  color: #67c23a;
}
</style>