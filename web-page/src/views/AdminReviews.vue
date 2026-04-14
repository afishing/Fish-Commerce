<template>
  <div class="admin-reviews">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>评论管理</span>
          <el-button type="primary" @click="loadReviews">刷新</el-button>
        </div>
      </template>

      <!-- 搜索栏 -->
      <el-form :model="queryForm" inline class="search-form">
        <el-form-item label="商品名称">
          <el-input v-model="queryForm.productName" placeholder="搜索商品" clearable />
        </el-form-item>
        <el-form-item label="用户名">
          <el-input v-model="queryForm.username" placeholder="搜索用户" clearable />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">查询</el-button>
          <el-button @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>

      <!-- 评论列表 -->
      <el-table :data="reviewList" v-loading="loading" border>
        <el-table-column type="index" label="序号" width="60" />
        <el-table-column prop="productName" label="商品名称" min-width="150">
          <template #default="{ row }">
            <el-link type="primary" @click="viewProduct(row.productId)">{{ row.productName || '商品' + row.productId }}</el-link>
          </template>
        </el-table-column>
        <el-table-column prop="username" label="用户" width="120" />
        <el-table-column prop="content" label="评论内容" min-width="200" show-overflow-tooltip>
          <template #default="{ row }">
            {{ row.content || '用户未填写评价内容' }}
          </template>
        </el-table-column>
        <el-table-column prop="rating" label="评分" width="100">
          <template #default="{ row }">
            <el-rate v-model="row.rating" disabled />
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="评论时间" width="160">
          <template #default="{ row }">
            {{ row.createTime ? new Date(row.createTime).toLocaleString() : '' }}
          </template>
        </el-table-column>
        <el-table-column label="操作" width="120" fixed="right">
          <template #default="{ row }">
            <el-button type="danger" size="small" @click="deleteReview(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <el-pagination
        v-model:current-page="pagination.page"
        v-model:page-size="pagination.size"
        :total="pagination.total"
        :page-sizes="[10, 20, 50]"
        layout="total, sizes, prev, pager, next"
        @size-change="loadReviews"
        @current-change="loadReviews"
        style="margin-top: 20px; justify-content: flex-end"
      />
    </el-card>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getAllReviews, deleteReview as deleteReviewApi } from '@/api/admin'

const router = useRouter()

const loading = ref(false)
const reviewList = ref([])

const queryForm = reactive({
  productName: '',
  username: ''
})

const pagination = reactive({
  page: 1,
  size: 20,
  total: 0
})

const loadReviews = async () => {
  loading.value = true
  try {
    const res = await getAllReviews({
      page: pagination.page,
      size: pagination.size,
      ...queryForm
    })
    if (res.code === 200 || res.code === 0) {
      const list = res.data?.records || res.data?.list || []
      reviewList.value = list.map(r => ({
        ...r,
        rating: r.rating || 5 // 默认5星
      }))
      pagination.total = res.data?.total || 0
    }
  } catch (e) {
    console.error(e)
  } finally {
    loading.value = false
  }
}

const handleSearch = () => {
  pagination.page = 1
  loadReviews()
}

const handleReset = () => {
  queryForm.productName = ''
  queryForm.username = ''
  pagination.page = 1
  loadReviews()
}

const viewProduct = (productId) => {
  router.push(`/products/${productId}`)
}

const deleteReview = async (row) => {
  try {
    await ElMessageBox.confirm('确定要删除这条评论吗？', '提示', {
      type: 'warning'
    })
    const res = await deleteReviewApi(row.id)
    if (res.code === 200 || res.code === 0) {
      ElMessage.success('删除成功')
      loadReviews()
    }
  } catch (e) {
    if (e !== 'cancel') {
      console.error(e)
    }
  }
}

onMounted(() => {
  loadReviews()
})
</script>

<style scoped>
.admin-reviews {
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
</style>
