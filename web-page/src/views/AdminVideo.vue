<template>
  <div class="admin-video">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>视频管理</span>
          <div>
            <el-button type="primary" @click="showAddDialog">添加视频</el-button>
            <el-upload
              style="display: inline-block; margin-left: 10px"
              :show-file-list="false"
              :before-upload="beforeUpload"
              :http-request="handleUpload"
              accept="video/*"
            >
              <el-button type="success">上传视频</el-button>
            </el-upload>
          </div>
        </div>
      </template>

      <el-table :data="videoList" v-loading="loading" border>
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="title" label="标题" />
        <el-table-column prop="description" label="描述" />
        <el-table-column label="预览" width="200">
          <template #default="{ row }">
            <video v-if="row.url" :src="row.url" controls style="width: 180px; height: 100px"></video>
          </template>
        </el-table-column>
        <el-table-column prop="duration" label="时长(秒)" width="100" />
        <el-table-column prop="fileSize" label="大小" width="100">
          <template #default="{ row }">
            {{ formatSize(row.fileSize) }}
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="80">
          <template #default="{ row }">
            <el-tag :type="row.status === 1 ? 'success' : 'danger'">
              {{ row.status === 1 ? '启用' : '禁用' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="创建时间" width="180" />
        <el-table-column label="操作" width="150">
          <template #default="{ row }">
            <el-button size="small" @click="showEditDialog(row)">编辑</el-button>
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
        @size-change="loadVideos"
        @current-change="loadVideos"
        style="margin-top: 20px; justify-content: flex-end"
      />
    </el-card>

    <!-- 添加/编辑对话框 -->
    <el-dialog v-model="dialogVisible" :title="isEdit ? '编辑视频' : '添加视频'" width="500px">
      <el-form :model="form" label-width="80px">
        <el-form-item label="标题">
          <el-input v-model="form.title" />
        </el-form-item>
        <el-form-item label="描述">
          <el-input v-model="form.description" type="textarea" :rows="3" />
        </el-form-item>
        <el-form-item label="视频URL">
          <el-input v-model="form.url" placeholder="输入视频链接" />
        </el-form-item>
        <el-form-item label="封面URL">
          <el-input v-model="form.coverUrl" placeholder="输入封面图片链接" />
        </el-form-item>
        <el-form-item label="时长(秒)">
          <el-input-number v-model="form.duration" :min="0" />
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
import { getVideoList, addVideo, updateVideo, deleteVideo, uploadVideo } from '@/api/video'

const loading = ref(false)
const videoList = ref([])
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
  description: '',
  url: '',
  coverUrl: '',
  duration: 0,
  status: 1,
  sort: 0
})

const loadVideos = async () => {
  loading.value = true
  try {
    const res = await getVideoList({
      page: pagination.page,
      size: pagination.size
    })
    if (res.code === 200) {
      videoList.value = res.data.records
      pagination.total = res.data.total
    }
  } catch (e) {
    console.error(e)
  } finally {
    loading.value = false
  }
}

const beforeUpload = (file) => {
  const isVideo = file.type.startsWith('video/')
  const isLt500M = file.size / 1024 / 1024 < 500

  if (!isVideo) {
    ElMessage.error('只能上传视频文件!')
    return false
  }
  if (!isLt500M) {
    ElMessage.error('视频大小不能超过 500MB!')
    return false
  }
  return true
}

const handleUpload = async ({ file }) => {
  try {
    ElMessage.info('上传中，请稍候...')
    const res = await uploadVideo(file)
    if (res.code === 200) {
      ElMessage.success('上传成功')
      loadVideos()
    } else {
      ElMessage.error(res.message || '上传失败')
    }
  } catch (e) {
    ElMessage.error('上传失败')
  }
}

const showAddDialog = () => {
  isEdit.value = false
  Object.assign(form, {
    id: null,
    title: '',
    description: '',
    url: '',
    coverUrl: '',
    duration: 0,
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
  try {
    const res = isEdit.value ? await updateVideo(form) : await addVideo(form)
    if (res.code === 200) {
      ElMessage.success(isEdit.value ? '更新成功' : '添加成功')
      dialogVisible.value = false
      loadVideos()
    } else {
      ElMessage.error(res.message || '操作失败')
    }
  } catch (e) {
    ElMessage.error('操作失败')
  }
}

const handleDelete = (row) => {
  ElMessageBox.confirm('确定要删除这个视频吗？', '提示', {
    type: 'warning'
  }).then(async () => {
    try {
      const res = await deleteVideo(row.id)
      if (res.code === 200) {
        ElMessage.success('删除成功')
        loadVideos()
      }
    } catch (e) {
      ElMessage.error('删除失败')
    }
  })
}

const formatSize = (bytes) => {
  if (!bytes) return '-'
  if (bytes < 1024) return bytes + ' B'
  if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(2) + ' KB'
  if (bytes < 1024 * 1024 * 1024) return (bytes / 1024 / 1024).toFixed(2) + ' MB'
  return (bytes / 1024 / 1024 / 1024).toFixed(2) + ' GB'
}

onMounted(() => {
  loadVideos()
})
</script>

<style scoped>
.admin-video {
  padding: 20px;
}
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
</style>
