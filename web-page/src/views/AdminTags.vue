<template>
  <div class="tags-container">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>标签管理</span>
          <el-button type="primary" @click="handleAdd">添加标签</el-button>
        </div>
      </template>

      <!-- 标签列表 -->
      <el-table :data="tagList" v-loading="loading" border row-key="id">
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="name" label="标签名称" min-width="150" />
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
            <span>标签仅包含名称</span>
          </template>
        </el-alert>
      </div>
    </el-card>

    <!-- 添加/编辑标签对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogTitle"
      width="500px"
      :close-on-click-modal="false"
    >
      <el-form
        ref="tagFormRef"
        :model="tagForm"
        :rules="tagRules"
        label-width="100px"
      >
        <el-form-item label="标签名称" prop="name">
          <el-input v-model="tagForm.name" placeholder="请输入标签名称" maxlength="50" show-word-limit />
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
import { getAllTags, addTag, updateTag, deleteTag } from '../api/tag'

// 数据相关
const loading = ref(false)
const submitLoading = ref(false)
const tagList = ref([])
const dialogVisible = ref(false)
const dialogTitle = ref('添加标签')
const isEdit = ref(false)
const tagFormRef = ref(null)

// 表单数据
const tagForm = reactive({
  id: null,
  name: ''
})

// 表单验证规则
const tagRules = {
  name: [{ required: true, message: '请输入标签名称', trigger: 'blur' }]
}

// 获取标签列表
const fetchTagList = async () => {
  loading.value = true
  try {
    const res = await getAllTags()
    if (res.data) {
      tagList.value = res.data
    }
  } catch (error) {
    ElMessage.error('获取标签列表失败')
  } finally {
    loading.value = false
  }
}

// 添加标签
const handleAdd = () => {
  isEdit.value = false
  dialogTitle.value = '添加标签'
  resetForm()
  dialogVisible.value = true
}

// 编辑标签
const handleEdit = (row) => {
  isEdit.value = true
  dialogTitle.value = '编辑标签'
  Object.assign(tagForm, {
    id: row.id,
    name: row.name
  })
  dialogVisible.value = true
}

// 删除标签
const handleDelete = (row) => {
  ElMessageBox.confirm(
    `确定要删除标签 "${row.name}" 吗？删除后关联该标签的商品将失去此标签！`,
    '警告',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'danger'
    }
  ).then(async () => {
    try {
      const res = await deleteTag(row.id)
      if (res.success || res.code === 200) {
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

// 重置表单
const resetForm = () => {
  tagForm.id = null
  tagForm.name = ''
}

// 提交表单
const handleSubmit = async () => {
  if (!tagFormRef.value) return
  
  await tagFormRef.value.validate(async (valid) => {
    if (valid) {
      submitLoading.value = true
      try {
        let res
        if (isEdit.value) {
          res = await updateTag(tagForm.id, {
            name: tagForm.name
          })
        } else {
          res = await addTag({
            name: tagForm.name
          })
        }
        
        if (res.success || res.code === 200) {
          ElMessage.success(isEdit.value ? '更新成功' : '添加成功')
          dialogVisible.value = false
          fetchTagList()
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

// 初始化
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
  font-size: 16px;
  font-weight: bold;
}

.tips-container {
  margin-top: 16px;
}
</style>
