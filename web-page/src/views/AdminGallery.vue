<template>
  <div class="admin-gallery">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>图库管理</span>
          <el-button type="primary" @click="handleUpload">
            <el-icon><Upload /></el-icon>
            上传图片
          </el-button>
        </div>
      </template>

      <!-- 图片列表 -->
      <div class="gallery-list">
        <div v-for="item in galleryList" :key="item.id" class="gallery-item">
          <div class="image-wrapper">
            <el-image
              :src="getImageUrl(item.imageUrl)"
              fit="cover"
              class="gallery-image"
              :preview-src-list="[getImageUrl(item.imageUrl)]"
            />
          </div>
          <div class="image-info">
            <div class="image-title">{{ item.title || '未命名' }}</div>
            <div class="image-desc">{{ item.description || '无描述' }}</div>
            <div class="image-meta">
              <span>分类：{{ getCategoryName(item.category) }}</span>
              <span>{{ formatDate(item.createTime) }}</span>
            </div>
          </div>
          <div class="image-actions">
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
      title="上传图片"
      width="500px"
    >
      <el-form :model="uploadForm" label-width="80px">
        <el-form-item label="图片文件" required>
          <el-upload
            ref="uploadRef"
            drag
            :limit="1"
            :auto-upload="false"
            :on-change="handleFileChange"
            accept="image/*"
          >
            <el-icon class="el-icon--upload"><UploadFilled /></el-icon>
            <div class="el-upload__text">
              将图片拖到此处，或<em>点击上传</em>
            </div>
          </el-upload>
        </el-form-item>
        <el-form-item label="图片标题">
          <el-input v-model="uploadForm.title" placeholder="请输入图片标题" />
        </el-form-item>
        <el-form-item label="描述">
          <el-input
            v-model="uploadForm.description"
            type="textarea"
            :rows="3"
            placeholder="请输入图片描述"
          />
        </el-form-item>
        <el-form-item label="分类">
          <el-select v-model="uploadForm.category" placeholder="请选择分类">
            <el-option label="商品图片" :value="1" />
            <el-option label="轮播图" :value="2" />
            <el-option label="宣传图片" :value="3" />
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
import { getGalleryList, uploadGalleryImage, deleteGalleryImage } from '@/api/gallery'
import { getImageUrl } from '@/utils/image'

const galleryList = ref([])
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
    const res = await getGalleryList({
      page: currentPage.value,
      size: pageSize.value
    })
    if (res.success) {
      galleryList.value = res.data?.data || []
      total.value = res.data?.total || 0
    }
  } catch (error) {
    console.error('获取图库列表失败:', error)
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
    ElMessage.warning('请选择图片文件')
    return
  }

  uploading.value = true
  try {
    const formData = new FormData()
    formData.append('file', uploadForm.file)
    if (uploadForm.title) formData.append('title', uploadForm.title)
    if (uploadForm.description) formData.append('description', uploadForm.description)
    formData.append('category', uploadForm.category)

    const res = await uploadGalleryImage(formData)
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
  ElMessageBox.confirm('确定要删除这张图片吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    try {
      const res = await deleteGalleryImage(id)
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
    1: '商品图片',
    2: '轮播图',
    3: '宣传图片'
  }
  return names[category] || '未知'
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
.admin-gallery {
  padding: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.gallery-list {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 20px;
}

.gallery-item {
  border: 1px solid #e4e7ed;
  border-radius: 8px;
  overflow: hidden;
  transition: all 0.3s;
}

.gallery-item:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  transform: translateY(-4px);
}

.image-wrapper {
  height: 200px;
  overflow: hidden;
  background: #f5f7fa;
}

.gallery-image {
  width: 100%;
  height: 100%;
}

.image-info {
  padding: 12px;
}

.image-title {
  font-size: 14px;
  font-weight: bold;
  color: #303133;
  margin-bottom: 6px;
}

.image-desc {
  font-size: 12px;
  color: #909399;
  margin-bottom: 8px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.image-meta {
  display: flex;
  justify-content: space-between;
  font-size: 12px;
  color: #c0c4cc;
}

.image-actions {
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