<template>
  <div class="admin-notice">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>公告管理</span>
          <el-button type="primary" @click="showAddDialog">添加公告</el-button>
        </div>
      </template>

      <el-table :data="noticeList" v-loading="loading" border>
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="title" label="标题" />
        <el-table-column prop="content" label="内容">
          <template #default="{ row }">
            <div class="content-cell">{{ row.content }}</div>
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="80">
          <template #default="{ row }">
            <el-tag :type="row.status === 1 ? 'success' : 'danger'">
              {{ row.status === 1 ? '启用' : '禁用' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="sort" label="排序" width="80" />
        <el-table-column prop="createTime" label="创建时间" width="180" />
        <el-table-column label="操作" width="200">
          <template #default="{ row }">
            <el-button size="small" @click="showEditDialog(row)">编辑</el-button>
            <el-button size="small" :type="row.status === 1 ? 'warning' : 'success'" @click="handleToggle(row)">
              {{ row.status === 1 ? '禁用' : '启用' }}
            </el-button>
            <el-button type="danger" size="small" @click="handleDelete(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <el-pagination
        v-model:current-page="pagination.page"
        v-model:page-size="pagination.size"
        :total="pagination.total"
        :page-sizes="[10, 20, 50]"
        layout="total, sizes, prev, pager, next"
        @size-change="loadNotices"
        @current-change="loadNotices"
        style="margin-top: 20px; justify-content: flex-end"
      />
    </el-card>

    <!-- 添加/编辑对话框 -->
    <el-dialog v-model="dialogVisible" :title="isEdit ? '编辑公告' : '添加公告'" width="600px">
      <el-form :model="form" label-width="80px">
        <el-form-item label="标题" required>
          <el-input v-model="form.title" placeholder="请输入公告标题" />
        </el-form-item>
        <el-form-item label="内容" required>
          <el-input v-model="form.content" type="textarea" :rows="5" placeholder="请输入公告内容" />
        </el-form-item>
        <el-form-item label="状态">
          <el-switch v-model="form.status" :active-value="1" :inactive-value="0" />
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
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getNoticeList, addNotice, updateNotice, deleteNotice, toggleNotice } from '@/api/notice'

const loading = ref(false)
const noticeList = ref([])
const pagination = reactive({
  page: 1,
  size: 10,
  total: 0
})
const dialogVisible = ref(false)
const isEdit = ref(false)
const form = reactive({
  id: null,
  title: '',
  content: '',
  status: 1,
  sort: 0
})

const loadNotices = async () => {
  loading.value = true
  try {
    const res = await getNoticeList({
      page: pagination.page,
      size: pagination.size
    })
    if (res.code === 200) {
      noticeList.value = res.data.records
      pagination.total = res.data.total
    }
  } catch (e) {
    console.error(e)
  } finally {
    loading.value = false
  }
}

const showAddDialog = () => {
  isEdit.value = false
  Object.assign(form, {
    id: null,
    title: '',
    content: '',
    status: 1,
    sort: 0
  })
  dialogVisible.value = true
}

const showEditDialog = (row) => {
  isEdit.value = true
  Object.assign(form, row)
  dialogVisible.value = true
}

const handleSubmit = async () => {
  if (!form.title || !form.content) {
    ElMessage.warning('请填写标题和内容')
    return
  }
  try {
    const res = isEdit.value ? await updateNotice(form) : await addNotice(form)
    if (res.code === 200) {
      ElMessage.success(isEdit.value ? '更新成功' : '添加成功')
      dialogVisible.value = false
      loadNotices()
    } else {
      ElMessage.error(res.message || '操作失败')
    }
  } catch (e) {
    ElMessage.error('操作失败')
  }
}

const handleToggle = async (row) => {
  try {
    const res = await toggleNotice(row.id)
    if (res.code === 200) {
      ElMessage.success('操作成功')
      loadNotices()
    }
  } catch (e) {
    ElMessage.error('操作失败')
  }
}

const handleDelete = (row) => {
  ElMessageBox.confirm('确定要删除这条公告吗？', '提示', {
    type: 'warning'
  }).then(async () => {
    try {
      const res = await deleteNotice(row.id)
      if (res.code === 200) {
        ElMessage.success('删除成功')
        loadNotices()
      }
    } catch (e) {
      ElMessage.error('删除失败')
    }
  })
}

onMounted(() => {
  loadNotices()
})
</script>

<style scoped>
.admin-notice {
  padding: 20px;
}
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.content-cell {
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
}
</style>
