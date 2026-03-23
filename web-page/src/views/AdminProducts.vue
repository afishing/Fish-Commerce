<template>
  <div class="products-container">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>商品管理</span>
          <el-button type="primary" @click="handleAdd">添加商品</el-button>
        </div>
      </template>

      <!-- 搜索栏 -->
      <el-form :model="queryForm" inline class="search-form">
        <el-form-item label="商品状态">
          <el-select v-model="queryForm.status" placeholder="请选择状态" clearable>
            <el-option label="上架" :value="1" />
            <el-option label="下架" :value="0" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">查询</el-button>
          <el-button @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>

      <!-- 商品列表 -->
      <el-table :data="productList" v-loading="loading" border>
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="name" label="商品名称" min-width="150" />
        <el-table-column prop="mainImage" label="主图" width="100">
          <template #default="{ row }">
            <el-image
              v-if="row.mainImage"
              :src="getImageUrl(row.mainImage)"
              style="width: 60px; height: 60px;"
              fit="cover"
            />
            <span v-else>无图片</span>
          </template>
        </el-table-column>
        <el-table-column prop="price" label="价格" width="100">
          <template #default="{ row }">
            ¥{{ row.price?.toFixed(2) }}
          </template>
        </el-table-column>
        <el-table-column prop="originalPrice" label="原价" width="100">
          <template #default="{ row }">
            ¥{{ row.originalPrice?.toFixed(2) }}
          </template>
        </el-table-column>
        <el-table-column prop="stock" label="库存" width="80" />
        <el-table-column prop="sales" label="销量" width="80" />
        <el-table-column prop="status" label="状态" width="80">
          <template #default="{ row }">
            <el-tag :type="row.status === 1 ? 'success' : 'info'">
              {{ row.status === 1 ? '上架' : '下架' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="创建时间" width="180">
          <template #default="{ row }">
            {{ formatDate(row.createTime) }}
          </template>
        </el-table-column>
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" size="small" @click="handleEdit(row)">编辑</el-button>
            <el-button
              v-if="row.status === 1"
              type="warning"
              size="small"
              @click="handleDisable(row)"
            >
              下架
            </el-button>
            <el-button
              v-else
              type="success"
              size="small"
              @click="handleEnable(row)"
            >
              上架
            </el-button>
            <el-button type="danger" size="small" @click="handleDelete(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页 -->
      <div class="pagination-container">
        <el-pagination
          v-model:current-page="queryForm.page"
          v-model:page-size="queryForm.size"
          :page-sizes="[10, 20, 50, 100]"
          :total="total"
          layout="total, sizes, prev, pager, next, jumper"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
        />
      </div>
    </el-card>

    <!-- 添加/编辑商品对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogTitle"
      width="600px"
    >
      <el-form
        ref="productFormRef"
        :model="productForm"
        :rules="productRules"
        label-width="100px"
      >
        <el-form-item label="商品名称" prop="name">
          <el-input v-model="productForm.name" placeholder="请输入商品名称" />
        </el-form-item>
        <el-form-item label="商品描述">
          <el-input
            v-model="productForm.description"
            type="textarea"
            rows="3"
            placeholder="请输入商品描述"
          />
        </el-form-item>
        <el-form-item label="分类ID" prop="categoryId">
          <el-input-number v-model="productForm.categoryId" :min="1" />
        </el-form-item>
        <el-form-item label="价格" prop="price">
          <el-input-number v-model="productForm.price" :min="0" :precision="2" />
        </el-form-item>
        <el-form-item label="原价">
          <el-input-number v-model="productForm.originalPrice" :min="0" :precision="2" />
        </el-form-item>
        <el-form-item label="库存" prop="stock">
          <el-input-number v-model="productForm.stock" :min="0" />
        </el-form-item>
        <el-form-item label="商品主图">
          <el-upload
            class="product-image-uploader"
            action="http://localhost:5000/upload"
            :show-file-list="false"
            :on-success="handleImageSuccess"
            :before-upload="beforeImageUpload"
            accept="image/*"
          >
            <img v-if="productForm.mainImage" :src="getImageUrl(productForm.mainImage)" class="product-image" />
            <el-icon v-else class="product-image-uploader-icon"><Plus /></el-icon>
          </el-upload>
          <div class="image-tips">点击上传图片，支持 jpg/png 格式</div>
        </el-form-item>
        <el-form-item label="产地">
          <el-input v-model="productForm.origin" placeholder="请输入产地" />
        </el-form-item>
        <el-form-item label="重量">
          <el-input v-model="productForm.weight" placeholder="请输入重量，如：500g" />
        </el-form-item>
        <el-form-item label="保质期">
          <el-input v-model="productForm.shelfLife" placeholder="请输入保质期，如：12个月" />
        </el-form-item>
        <el-form-item label="储存方式">
          <el-input v-model="productForm.storage" placeholder="请输入储存方式" />
        </el-form-item>
        <el-form-item label="规格">
          <el-input
            v-model="productForm.specs"
            type="textarea"
            rows="2"
            placeholder="请输入规格信息（JSON格式）"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmit" :loading="submitLoading">
          确定
        </el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus } from '@element-plus/icons-vue'
import { getImageUrl } from '../utils/image'
import {
  getProductList,
  addProduct,
  updateProduct,
  enableProduct,
  disableProduct,
  deleteProduct
} from '../api/admin'

const loading = ref(false)
const submitLoading = ref(false)
const productList = ref([])
const total = ref(0)
const dialogVisible = ref(false)
const dialogTitle = ref('添加商品')
const isEdit = ref(false)
const productFormRef = ref(null)

const queryForm = reactive({
  status: null,
  page: 1,
  size: 10
})

const productForm = reactive({
  id: null,
  name: '',
  description: '',
  categoryId: 1,
  price: 0,
  originalPrice: 0,
  stock: 0,
  mainImage: '',
  origin: '',
  weight: '',
  shelfLife: '',
  storage: '',
  specs: ''
})

const productRules = {
  name: [{ required: true, message: '请输入商品名称', trigger: 'blur' }],
  categoryId: [{ required: true, message: '请输入分类ID', trigger: 'blur' }],
  price: [{ required: true, message: '请输入价格', trigger: 'blur' }],
  stock: [{ required: true, message: '请输入库存', trigger: 'blur' }]
}

const fetchProductList = async () => {
  loading.value = true
  try {
    const res = await getProductList(queryForm)
    if (res.success) {
      productList.value = res.data.list
      total.value = res.data.total
    } else {
      ElMessage.error(res.message || '获取商品列表失败')
    }
  } catch (error) {
    ElMessage.error('获取商品列表失败')
  } finally {
    loading.value = false
  }
}

const handleSearch = () => {
  queryForm.page = 1
  fetchProductList()
}

const handleReset = () => {
  queryForm.status = null
  queryForm.page = 1
  fetchProductList()
}

const handleSizeChange = (val) => {
  queryForm.size = val
  fetchProductList()
}

const handleCurrentChange = (val) => {
  queryForm.page = val
  fetchProductList()
}

const handleAdd = () => {
  isEdit.value = false
  dialogTitle.value = '添加商品'
  resetForm()
  dialogVisible.value = true
}

const handleEdit = (row) => {
  isEdit.value = true
  dialogTitle.value = '编辑商品'
  Object.assign(productForm, row)
  dialogVisible.value = true
}

const resetForm = () => {
  productForm.id = null
  productForm.name = ''
  productForm.description = ''
  productForm.categoryId = 1
  productForm.price = 0
  productForm.originalPrice = 0
  productForm.stock = 0
  productForm.mainImage = ''
  productForm.origin = ''
  productForm.weight = ''
  productForm.shelfLife = ''
  productForm.storage = ''
  productForm.specs = ''
}

const handleSubmit = async () => {
  if (!productFormRef.value) return
  
  await productFormRef.value.validate(async (valid) => {
    if (valid) {
      submitLoading.value = true
      try {
        let res
        if (isEdit.value) {
          res = await updateProduct(productForm)
        } else {
          res = await addProduct(productForm)
        }
        
        if (res.success) {
          ElMessage.success(isEdit.value ? '更新成功' : '添加成功')
          dialogVisible.value = false
          fetchProductList()
        } else {
          ElMessage.error(res.message || (isEdit.value ? '更新失败' : '添加失败'))
        }
      } catch (error) {
        ElMessage.error(isEdit.value ? '更新失败' : '添加失败')
      } finally {
        submitLoading.value = false
      }
    }
  })
}

const handleEnable = (row) => {
  ElMessageBox.confirm(
    `确定要上架商品 "${row.name}" 吗？`,
    '提示',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }
  ).then(async () => {
    try {
      const res = await enableProduct(row.id)
      if (res.success) {
        ElMessage.success('上架成功')
        fetchProductList()
      } else {
        ElMessage.error(res.message || '上架失败')
      }
    } catch (error) {
      ElMessage.error('上架失败')
    }
  })
}

const handleDisable = (row) => {
  ElMessageBox.confirm(
    `确定要下架商品 "${row.name}" 吗？`,
    '提示',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }
  ).then(async () => {
    try {
      const res = await disableProduct(row.id)
      if (res.success) {
        ElMessage.success('下架成功')
        fetchProductList()
      } else {
        ElMessage.error(res.message || '下架失败')
      }
    } catch (error) {
      ElMessage.error('下架失败')
    }
  })
}

const handleDelete = (row) => {
  ElMessageBox.confirm(
    `确定要删除商品 "${row.name}" 吗？此操作不可恢复！`,
    '警告',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'danger'
    }
  ).then(async () => {
    try {
      const res = await deleteProduct(row.id)
      if (res.success) {
        ElMessage.success('删除成功')
        fetchProductList()
      } else {
        ElMessage.error(res.message || '删除失败')
      }
    } catch (error) {
      ElMessage.error('删除失败')
    }
  })
}

const formatDate = (dateStr) => {
  if (!dateStr) return '-'
  const date = new Date(dateStr)
  return date.toLocaleString()
}

// 图片上传相关
const handleImageSuccess = (response) => {
  if (response.success) {
    productForm.mainImage = response.data
    ElMessage.success('图片上传成功')
  } else {
    ElMessage.error(response.message || '图片上传失败')
  }
}

const beforeImageUpload = (rawFile) => {
  const allowedTypes = ['image/jpeg', 'image/png', 'image/jpg', 'image/gif', 'image/webp']
  const isImage = allowedTypes.includes(rawFile.type)
  const isLt2M = rawFile.size / 1024 / 1024 < 2

  if (!isImage) {
    ElMessage.error('只支持图片格式!')
    return false
  }
  if (!isLt2M) {
    ElMessage.error('图片大小不能超过 2MB!')
    return false
  }
  return true
}

onMounted(() => {
  fetchProductList()
})
</script>

<style scoped>
.products-container {
  padding: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 16px;
  font-weight: bold;
}

.search-form {
  margin-bottom: 20px;
}

.pagination-container {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}

/* 图片上传样式 */
.product-image-uploader {
  border: 1px dashed var(--el-border-color);
  border-radius: 6px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
  transition: var(--el-transition-duration-fast);
  width: 178px;
  height: 178px;
}

.product-image-uploader:hover {
  border-color: var(--el-color-primary);
}

.product-image-uploader-icon {
  font-size: 28px;
  color: #8c939d;
  width: 178px;
  height: 178px;
  text-align: center;
  display: flex;
  align-items: center;
  justify-content: center;
}

.product-image {
  width: 178px;
  height: 178px;
  display: block;
  object-fit: cover;
}

.image-tips {
  font-size: 12px;
  color: #909399;
  margin-top: 8px;
}
</style>
