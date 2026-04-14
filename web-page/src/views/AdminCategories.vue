<template>
  <div class="categories-container">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>分类管理</span>
          <el-button type="primary" @click="handleAdd">添加分类</el-button>
        </div>
      </template>

      <!-- 分类列表 -->
      <el-table :data="categoryList" v-loading="loading" border row-key="id">
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="icon" label="图标" width="100">
          <template #default="{ row }">
            <span v-if="row.icon" style="font-size: 28px;">{{ row.icon }}</span>
            <span v-else class="icon-placeholder">
              <el-icon :size="24"><Menu /></el-icon>
            </span>
          </template>
        </el-table-column>
        <el-table-column prop="name" label="分类名称" min-width="150" />
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" size="small" @click="handleEdit(row)">编辑</el-button>
            <el-button type="danger" size="small" @click="handleDelete(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <!-- 提示信息 -->
      <div class="tips-container">
        <el-alert type="info" :closable="false">
          <template #title>
            <span>排序规则：数值越大越靠后</span>
          </template>
        </el-alert>
      </div>
    </el-card>

    <!-- 添加/编辑分类对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogTitle"
      width="500px"
      :close-on-click-modal="false"
    >
      <el-form
        ref="categoryFormRef"
        :model="categoryForm"
        :rules="categoryRules"
        label-width="100px"
      >
        <el-form-item label="分类名称" prop="name">
          <el-input v-model="categoryForm.name" placeholder="请输入分类名称" maxlength="50" show-word-limit />
        </el-form-item>
        <el-form-item label="分类图标">
          <el-input v-model="categoryForm.icon" placeholder="请输入 emoji 图标，如：🐟 🍎 " maxlength="10" show-word-limit />
          <div class="upload-tip">建议使用 emoji 图标，也可以输入图片 URL</div>
        </el-form-item>
        <el-form-item label="排序权重" prop="sort">
          <el-input-number v-model="categoryForm.sort" :min="0" :max="999" />
          <span class="sort-tip">数值越大排序越靠后</span>
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
import { Plus, Menu } from '@element-plus/icons-vue'
import { getImageUrl } from '../utils/image'
import { getAllCategories, addCategory, updateCategory, deleteCategory } from '../api/category'

// 数据相关
const loading = ref(false)
const submitLoading = ref(false)
const categoryList = ref([])
const dialogVisible = ref(false)
const dialogTitle = ref('添加分类')
const isEdit = ref(false)
const categoryFormRef = ref(null)

// 表单数据
const categoryForm = reactive({
  id: null,
  name: '',
  icon: '',
  sort: 0
})

// 表单验证规则
const categoryRules = {
  name: [{ required: true, message: '请输入分类名称', trigger: 'blur' }],
  sort: [{ required: true, message: '请输入排序权重', trigger: 'blur' }]
}

// 获取分类列表
const fetchCategoryList = async () => {
  loading.value = true
  try {
    const res = await getAllCategories()
    if (res.data) {
      // 按 sort 升序排列（数值越小越靠前）
      categoryList.value = res.data.sort((a, b) => a.sort - b.sort)
    }
  } catch (error) {
    ElMessage.error('获取分类列表失败')
  } finally {
    loading.value = false
  }
}

// 添加分类
const handleAdd = () => {
  isEdit.value = false
  dialogTitle.value = '添加分类'
  resetForm()
  dialogVisible.value = true
}

// 编辑分类
const handleEdit = (row) => {
  isEdit.value = true
  dialogTitle.value = '编辑分类'
  Object.assign(categoryForm, {
    id: row.id,
    name: row.name,
    icon: row.icon || '',
    sort: row.sort || 0
  })
  dialogVisible.value = true
}

// 删除分类
const handleDelete = (row) => {
  ElMessageBox.confirm(
    `确定要删除分类 "${row.name}" 吗？删除后该分类下的商品将失去分类关联！`,
    '警告',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'danger'
    }
  ).then(async () => {
    try {
      const res = await deleteCategory(row.id)
      if (res.success || res.code === 200) {
        ElMessage.success('删除成功')
        fetchCategoryList()
      } else {
        ElMessage.error(res.message || '删除失败')
      }
    } catch (error) {
      ElMessage.error('删除失败')
    }
  })
}

// 重置表单
const resetForm = () => {
  categoryForm.id = null
  categoryForm.name = ''
  categoryForm.icon = ''
  categoryForm.sort = 0
}

// 提交表单
const handleSubmit = async () => {
  if (!categoryFormRef.value) return
  
  await categoryFormRef.value.validate(async (valid) => {
    if (valid) {
      submitLoading.value = true
      try {
        let res
        if (isEdit.value) {
          res = await updateCategory(categoryForm.id, {
            name: categoryForm.name,
            icon: categoryForm.icon,
            sort: categoryForm.sort
          })
        } else {
          res = await addCategory({
            name: categoryForm.name,
            icon: categoryForm.icon,
            sort: categoryForm.sort
          })
        }
        
        if (res.success || res.code === 200) {
          ElMessage.success(isEdit.value ? '更新成功' : '添加成功')
          dialogVisible.value = false
          fetchCategoryList()
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

// 格式化日期
const formatDate = (dateStr) => {
  if (!dateStr) return '-'
  const date = new Date(dateStr)
  return date.toLocaleString()
}

// 初始化
onMounted(() => {
  fetchCategoryList()
})
</script>

<style scoped>
.categories-container {
  padding: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 16px;
  font-weight: bold;
}

.tips-container {
  margin-top: 16px;
}

.icon-placeholder {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 40px;
  height: 40px;
  background: #f5f7fa;
  border-radius: 4px;
  color: #909399;
}

.upload-tip {
  font-size: 12px;
  color: #909399;
  margin-top: 8px;
}

.sort-tip {
  font-size: 12px;
  color: #909399;
  margin-left: 8px;
}
</style>
