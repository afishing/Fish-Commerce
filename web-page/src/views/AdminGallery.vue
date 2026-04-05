<template>
  <div class="admin-gallery">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>图库管理</span>
          <div>
            <el-button type="danger" :disabled="!selectedIds.length" @click="handleBatchDelete">
              批量删除 ({{ selectedIds.length }})
            </el-button>
            <el-upload
              :show-file-list="false"
              :before-upload="beforeUpload"
              :http-request="handleUpload"
              accept="image/*"
              style="display: inline-block; margin-left: 12px"
            >
              <el-button type="primary">上传图片</el-button>
            </el-upload>
          </div>
        </div>
      </template>

      <div class="gallery-grid" v-loading="loading">
        <div
          class="gallery-item"
          :class="{ selected: selectedIds.includes(item.id) }"
          v-for="item in imageList"
          :key="item.id"
          @click.self="toggleSelect(item.id)"
        >
          <el-image
            :src="getImageUrl(item.url)"
            :preview-src-list="previewList"
            :initial-index="imageList.indexOf(item)"
            fit="cover"
            class="gallery-img"
          />
          <div class="gallery-check" @click.stop="toggleSelect(item.id)">
            <el-checkbox :model-value="selectedIds.includes(item.id)" />
          </div>
          <div class="gallery-overlay">
            <el-button type="danger" :icon="Delete" circle size="small" @click.stop="handleDelete(item)" />
          </div>
        </div>
      </div>

      <el-pagination
        v-model:current-page="pagination.page"
        v-model:page-size="pagination.size"
        :total="pagination.total"
        :page-sizes="[20, 40, 80]"
        layout="total, sizes, prev, pager, next"
        @size-change="loadImages"
        @current-change="loadImages"
        style="margin-top: 20px; justify-content: flex-end"
      />
    </el-card>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Delete } from '@element-plus/icons-vue'
import { getGalleryList, uploadImage, deleteGalleryImage, batchDeleteGalleryImages } from '@/api/gallery'
import { getImageUrl } from '@/utils/image'

const loading = ref(false)
const imageList = ref([])
const pagination = reactive({
  page: 1,
  size: 20,
  total: 0
})

const selectedIds = ref([])
const previewList = computed(() => imageList.value.map(item => getImageUrl(item.url)))

const toggleSelect = (id) => {
  const idx = selectedIds.value.indexOf(id)
  if (idx > -1) {
    selectedIds.value.splice(idx, 1)
  } else {
    selectedIds.value.push(id)
  }
}

const handleBatchDelete = () => {
  if (!selectedIds.value.length) return
  ElMessageBox.confirm(`确定要删除选中的 ${selectedIds.value.length} 张图片吗？`, '批量删除', {
    type: 'warning'
  }).then(async () => {
    try {
      const res = await batchDeleteGalleryImages(selectedIds.value)
      if (res.code === 200) {
        ElMessage.success('批量删除成功')
        selectedIds.value = []
        loadImages()
      }
    } catch (e) {
      ElMessage.error('批量删除失败')
    }
  })
}

const loadImages = async () => {
  loading.value = true
  try {
    const res = await getGalleryList({
      page: pagination.page,
      size: pagination.size
    })
    if (res.code === 200) {
      imageList.value = res.data.records
      pagination.total = res.data.total
    }
  } catch (e) {
    console.error(e)
  } finally {
    loading.value = false
  }
}

const beforeUpload = (file) => {
  const isImage = file.type.startsWith('image/')
  const isLt10M = file.size / 1024 / 1024 < 10

  if (!isImage) {
    ElMessage.error('只能上传图片文件!')
    return false
  }
  if (!isLt10M) {
    ElMessage.error('图片大小不能超过 10MB!')
    return false
  }
  return true
}

const handleUpload = async ({ file }) => {
  try {
    const res = await uploadImage(file)
    if (res.code === 200) {
      ElMessage.success('上传成功')
      loadImages()
    } else {
      ElMessage.error(res.message || '上传失败')
    }
  } catch (e) {
    ElMessage.error('上传失败')
  }
}

const handleDelete = (row) => {
  ElMessageBox.confirm('确定要删除这张图片吗？', '提示', {
    type: 'warning'
  }).then(async () => {
    try {
      const res = await deleteGalleryImage(row.id)
      if (res.code === 200) {
        ElMessage.success('删除成功')
        loadImages()
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
  return (bytes / 1024 / 1024).toFixed(2) + ' MB'
}

onMounted(() => {
  loadImages()
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
.gallery-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
  gap: 12px;
}
.gallery-item {
  position: relative;
  aspect-ratio: 1;
  border-radius: 8px;
  overflow: hidden;
  border: 1px solid #ebeef5;
}
.gallery-img {
  width: 100%;
  height: 100%;
}
.gallery-overlay {
  position: absolute;
  top: 4px;
  right: 4px;
  opacity: 0;
  transition: opacity 0.2s;
}
.gallery-item:hover .gallery-overlay {
  opacity: 1;
}
.gallery-check {
  position: absolute;
  top: 4px;
  left: 4px;
}
.gallery-item.selected {
  border-color: #409eff;
  box-shadow: 0 0 0 2px rgba(64, 158, 255, 0.3);
}
</style>
