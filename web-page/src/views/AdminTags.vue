<template>
  <div class="tags-container">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>标签管理</span>
          <el-button type="primary" @click="handleAdd">添加标签</el-button>
        </div>
      </template>

      <el-table :data="tagList" v-loading="loading" border>
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="name" label="标签名称" />
        <el-table-column prop="description" label="描述" />
        <el-table-column prop="sort" label="排序" width="100" />
        <el-table-column label="操作" width="200">
          <template #default="{ row }">
            <el-button type="primary" size="small" @click="handleEdit(row)">编辑</el-button>
            <el-button type="danger" size="small" @click="handleDelete(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <!-- 添加/编辑对话框 -->
    <el-dialog v-model="dialogVisible" :title="isEdit ? '编辑标签' : '添加标签'" width="500px">
      <el-form :model="form" label-width="80px">
        <el-form-item label="标签名称">
          <el-input v-model="form.name" placeholder="请输入标签名称" />
        </el-form-item>
        <el-form-item label="描述">
          <el-input v-model="form.description" type="textarea" placeholder="请输入描述" />
        </el-form-item>
        <el-form-item label="排序">
          <el-input-number v-model="form.sort" :min="0" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmit">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getAllTags, addTag, updateTag, deleteTag } from '../api/tag'

const loading = ref(false)
const tagList = ref([])
const dialogVisible = ref(false)
const isEdit = ref(false)

const form = ref({
  id: null,
  name: '',
  description: '',
  sort: 0
})

const fetchTagList = async () => {
  loading.value = true
  try {
    const res = await getAllTags()
    if (res.success) {
      tagList.value = res.data || []
    } else {
      ElMessage.error(res.message || '获取标签列表失败')
    }
  } catch (error) {
    ElMessage.error('获取标签列表失败')
  } finally {
    loading.value = false
  }
}

const handleAdd = () => {
  isEdit.value = false
  form.value = { id: null, name: '', description: '', sort: 0 }
  dialogVisible.value = true
}

const handleEdit = (row) => {
  isEdit.value = true
  form.value = { ...row }
  dialogVisible.value = true
}

const handleSubmit = async () => {
  try {
    let res
    if (isEdit.value) {
      res = await updateTag(form.value)
    } else {
      res = await addTag(form.value)
    }
    if (res.success) {
      ElMessage.success(isEdit.value ? '更新成功' : '添加成功')
      dialogVisible.value = false
      fetchTagList()
    } else {
      ElMessage.error(res.message || '操作失败')
    }
  } catch (error) {
    ElMessage.error('操作失败')
  }
}

const handleDelete = (row) => {
  ElMessageBox.confirm(`确定要删除标签 "${row.name}" 吗？`, '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    try {
      const res = await deleteTag(row.id)
      if (res.success) {
        ElMessage.success('删除成功')
        fetchTagList()
      } else {
        ElMessage.error(res.message || '删除失败')
      }
    } catch (error) {
      ElMessage.error('删除失败')
    }
  })
}

onMounted(() => {
  fetchTagList()
})
</script>

<style scoped>
.tags-container {
  padding: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
</style>
