<template>
  <div class="admin-videos">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>视频管理</span>
          <el-button type="primary" @click="handleUpload">
            <el-icon><Upload /></el-icon>
            上传视频
          </el-button>
        </div>
      </template>

      <!-- 视频列表 -->
      <div class="video-list">
        <div v-for="item in videoList" :key="item.id" class="video-item">
          <div class="video-wrapper">
            <video
              :src="item.videoUrl"
              controls
              class="video-player"
            />
          </div>
          <div class="video-info">
            <div class="video-title">{{ item.title || '未命名' }}</div>
            <div class="video-desc">{{ item.description || '无描述' }}</div>
            <div class="video-meta">
              <span>分类：{{ getCategoryName(item.category) }}</span>
              <span>时长：{{ formatDuration(item.duration) }}</span>
              <span>{{ formatDate(item.createTime) }}</span>
            </div>
          </div>
          <div class="video-actions">
            <el-button size="small" @click="handleEdit(item)">编辑</el-button>
            <el-button size="small" type="danger" @click="handleDelete(item.id)">删除</el-button>
          </div>
        </div>
      </div>

      <!-- 分页 -->
      <el-pagination
        v-model:current-page="currentPage"
        v-model:page-size="pageSize"
        :total="total"
        :page-sizes="[12, 24, 36, 48]"
        layout="total, sizes, prev, pager, next, jumper"
        @size-change="fetchData"
        @current-change="fetchData"
        class="pagination"
      />
    </el-card>

    <!-- 上传对话框 -->
    <el-dialog
      v-model="uploadVisible"
      title="上传视频"
      width="600px"
    >
      <el-form :model="uploadForm" label-width="80px">
        <el-form-item label="视频文件" required>
          <el-upload
            ref="uploadRef"
            drag
            :limit="1"
            :auto-upload="false"
            :on-change="handleFileChange"
            accept="video/*"
          >
            <el-icon class="el-icon--upload"><UploadFilled /></el-icon>
            <div class="el-upload__text">
              将视频拖到此处，或<em>点击上传</em>
            </div>
          </el-upload>
        </el-form-item>
        <el-form-item label="视频标题">
          <el-input v-model="uploadForm.title" placeholder="请输入视频标题" />
        </el-form-item>
        <el-form-item label="描述">
          <el-input
            v-model="uploadForm.description"
            type="textarea"
            :rows="3"
            placeholder="请输入视频描述"
          />
        </el-form-item>
        <el-form-item label="分类">
          <el-select v-model="uploadForm.category" placeholder="请选择分类">
            <el-option label="商品介绍" :value="1" />
            <el-option label="使用教程" :value="2" />
            <el-option label="品牌宣传" :value="3" />
            <el-option label="其他" :value="0" />
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="uploadVisible = false">取消</el-button>
        <el-button type="primary" @click="submitUpload" :loading="uploading">上传</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Upload, UploadFilled } from '@element-plus/icons-vue'
import { getVideoList, uploadVideo, deleteVideo } from '@/api/video'

const videoList = ref([])
const currentPage = ref(1)
const pageSize = ref(12)
const total = ref(0)
const uploadVisible = ref(false)
const uploading = ref(false)
const uploadRef = ref(null)

const uploadForm = reactive({
  file: null,
  title: '',
  description: '',
  category: 0
})

const fetchData = async () => {
  try {
    const res = await getVideoList({
      page: currentPage.value,
      size: pageSize.value
    })
    if (res.success) {
      videoList.value = res.data?.data || []
      total.value = res.data?.total || 0
    }
  } catch (error) {
    console.error('获取视频列表失败:', error)
  }
}

const handleUpload = () => {
  uploadForm.file = null
  uploadForm.title = ''
  uploadForm.description = ''
  uploadForm.category = 0
  uploadVisible.value = true
  if (uploadRef.value) {
    uploadRef.value.clearFiles()
  }
}

const handleFileChange = (file) => {
  uploadForm.file = file.raw
}

const submitUpload = async () => {
  if (!uploadForm.file) {
    ElMessage.warning('请选择视频文件')
    return
  }

  uploading.value = true
  try {
    const formData = new FormData()
    formData.append('file', uploadForm.file)
    if (uploadForm.title) formData.append('title', uploadForm.title)
    if (uploadForm.description) formData.append('description', uploadForm.description)
    formData.append('category', uploadForm.category)

    const res = await uploadVideo(formData)
    if (res.success) {
      ElMessage.success('上传成功')
      uploadVisible.value = false
      fetchData()
    } else {
      ElMessage.error(res.message || '上传失败')
    }
  } catch (error) {
    ElMessage.error('上传失败')
  } finally {
    uploading.value = false
  }
}

const handleEdit = (item) => {
  ElMessage.info('编辑功能开发中...')
}

const handleDelete = (id) => {
  ElMessageBox.confirm('确定要删除这个视频吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    try {
      const res = await deleteVideo(id)
      if (res.success) {
        ElMessage.success('删除成功')
        fetchData()
      } else {
        ElMessage.error(res.message || '删除失败')
      }
    } catch (error) {
      ElMessage.error('删除失败')
    }
  }).catch(() => {})
}

const getCategoryName = (category) => {
  const names = {
    0: '其他',
    1: '商品介绍',
    2: '使用教程',
    3: '品牌宣传'
  }
  return names[category] || '未知'
}

const formatDuration = (seconds) => {
  if (!seconds) return '00:00'
  const mins = Math.floor(seconds / 60)
  const secs = seconds % 60
  return `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`
}

const formatDate = (date) => {
  if (!date) return ''
  return new Date(date).toLocaleString('zh-CN')
}

onMounted(() => {
  fetchData()
})
</script>

<style scoped>
.admin-videos {
  padding: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.video-list {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: 20px;
}

.video-item {
  border: 1px solid #e4e7ed;
  border-radius: 8px;
  overflow: hidden;
  transition: all 0.3s;
}

.video-item:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  transform: translateY(-4px);
}

.video-wrapper {
  background: #000;
  height: 200px;
}

.video-player {
  width: 100%;
  height: 100%;
  object-fit: contain;
}

.video-info {
  padding: 12px;
}

.video-title {
  font-size: 14px;
  font-weight: bold;
  color: #303133;
  margin-bottom: 6px;
}

.video-desc {
  font-size: 12px;
  color: #909399;
  margin-bottom: 8px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.video-meta {
  display: flex;
  justify-content: space-between;
  font-size: 12px;
  color: #c0c4cc;
  flex-wrap: wrap;
  gap: 8px;
}

.video-actions {
  padding: 12px;
  border-top: 1px solid #e4e7ed;
  display: flex;
  gap: 8px;
}

.pagination {
  margin-top: 20px;
  display: flex;
  justify-content: center;
}
</style>