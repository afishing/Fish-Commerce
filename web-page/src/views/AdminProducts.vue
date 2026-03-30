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
        <el-table-column label="操作" width="280" fixed="right">
          <template #default="{ row }">
            <el-button type="info" size="small" @click="handleDetail(row)">详情</el-button>
            <el-button type="primary" size="small" @click="handleEdit(row)">编辑</el-button>
            <el-button
              v-if="row.isBanner == 1"
              size="small"
              @click="handleCancelBanner(row)"
            >
              <el-icon><StarFilled /></el-icon>取消轮播
            </el-button>
            <el-button
              v-else
              type="warning"
              size="small"
              @click="handleSetBanner(row)"
            >
              <el-icon><Star /></el-icon>设为轮播
            </el-button>
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
        <el-form-item label="商品标签">
          <el-select
            v-model="selectedTagIds"
            multiple
            collapse-tags
            collapse-tags-tooltip
            placeholder="请选择标签"
            style="width: 100%"
          >
            <el-option
              v-for="tag in allTags"
              :key="tag.id"
              :label="tag.name"
              :value="tag.id"
            >
              <div style="display:flex;align-items:center;gap:6px">
                <span :style="{ width:'12px', height:'12px', borderRadius:'50%', background: tag.color, display:'inline-block', flexShrink:0 }"></span>
                <span>{{ tag.name }}</span>
              </div>
            </el-option>
          </el-select>
          <div v-if="selectedTagIds.length > 0" style="margin-top:8px;display:flex;flex-wrap:wrap;gap:6px">
            <el-tag
              v-for="id in selectedTagIds"
              :key="id"
              closable
              @close="selectedTagIds = selectedTagIds.filter(t => t !== id)"
              :style="{ backgroundColor: allTags.find(t=>t.id===id)?.color, color:'#fff', borderColor: allTags.find(t=>t.id===id)?.color }"
              size="small"
            >
              {{ allTags.find(t => t.id === id)?.name }}
            </el-tag>
          </div>
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

    <!-- 图库选择对话框 -->
    <el-dialog
      v-model="galleryDialogVisible"
      title="从图库选择图片"
      width="800px"
      :close-on-click-modal="false"
    >
      <div v-loading="galleryLoading" class="gallery-container">
        <el-empty v-if="!galleryLoading && galleryList.length === 0" description="暂无图片" />
        <div v-else class="gallery-grid">
          <div
            v-for="(img, index) in galleryList"
            :key="index"
            class="gallery-item"
            @click="selectGalleryImage(img.url)"
          >
            <el-image
              :src="getImageUrl(img.url)"
              fit="cover"
              class="gallery-image"
              :preview-src-list="[]"
            />
            <div class="gallery-item-overlay">
              <el-icon size="24" color="#fff"><Plus /></el-icon>
            </div>
          </div>
        </div>
      </div>
    </el-dialog>

    <!-- 商品详情编辑对话框 -->
    <el-dialog
      v-model="detailDialogVisible"
      title="编辑商品详情（Markdown）"
      width="900px"
      top="5vh"
    >
      <div class="detail-editor">
        <div class="editor-pane">
          <div class="pane-header">编辑</div>
          <!-- Markdown 工具栏 -->
          <div class="markdown-toolbar">
            <el-button-group>
              <el-button size="small" @click="insertMarkdown('h1')" title="一级标题">
                <span class="toolbar-icon">H1</span>
              </el-button>
              <el-button size="small" @click="insertMarkdown('h2')" title="二级标题">
                <span class="toolbar-icon">H2</span>
              </el-button>
              <el-button size="small" @click="insertMarkdown('h3')" title="三级标题">
                <span class="toolbar-icon">H3</span>
              </el-button>
            </el-button-group>
            <el-divider direction="vertical" />
            <el-button-group>
              <el-button size="small" @click="insertMarkdown('bold')" title="粗体">
                <span class="toolbar-icon" style="font-weight:bold">B</span>
              </el-button>
              <el-button size="small" @click="insertMarkdown('italic')" title="斜体">
                <span class="toolbar-icon" style="font-style:italic">I</span>
              </el-button>
            </el-button-group>
            <el-divider direction="vertical" />
            <el-button-group>
              <el-button size="small" @click="insertMarkdown('ul')" title="无序列表">
                <el-icon><List /></el-icon>
              </el-button>
              <el-button size="small" @click="insertMarkdown('ol')" title="有序列表">
                <el-icon><Operation /></el-icon>
              </el-button>
            </el-button-group>
            <el-divider direction="vertical" />
            <el-button-group>
              <el-button size="small" @click="insertMarkdown('link')" title="链接">
                <el-icon><Link /></el-icon>
              </el-button>
              <el-button size="small" @click="insertMarkdown('image')" title="图片">
                <el-icon><Picture /></el-icon>
              </el-button>
              <el-button size="small" @click="openGalleryDialog" title="从图库选择">
                <el-icon><FolderOpened /></el-icon>
              </el-button>
              <el-button size="small" @click="insertMarkdown('code')" title="代码块">
                <el-icon><Document /></el-icon>
              </el-button>
            </el-button-group>
            <el-divider direction="vertical" />
            <el-button-group>
              <el-button size="small" @click="insertMarkdown('quote')" title="引用">
                <el-icon><ChatLineSquare /></el-icon>
              </el-button>
              <el-button size="small" @click="insertMarkdown('hr')" title="分割线">
                <el-icon><Minus /></el-icon>
              </el-button>
            </el-button-group>
          </div>
          <el-input
            ref="detailTextareaRef"
            v-model="detailForm.detail"
            type="textarea"
            :rows="18"
            placeholder="请输入商品详情，支持 Markdown 格式&#10;&#10;示例：&#10;## 商品介绍&#10;这是商品介绍内容&#10;&#10;### 产地信息&#10;- 产地：挪威&#10;- 捕捞方式：深海捕捞&#10;&#10;### 保存方法&#10;请放置于-18°C以下冷冻保存"
            class="detail-textarea"
          />
        </div>
        <div class="preview-pane">
          <div class="pane-header">预览</div>
          <div class="markdown-preview" v-html="renderedMarkdown"></div>
        </div>
      </div>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="detailDialogVisible = false">取消</el-button>
          <el-button type="primary" @click="handleDetailSubmit" :loading="detailSaving">
            保存
          </el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus, List, Operation, Link, Picture, Document, ChatLineSquare, Minus, FolderOpened, Star, StarFilled } from '@element-plus/icons-vue'
import { getImageUrl } from '../utils/image'
import {
  getProductList,
  addProduct,
  updateProduct,
  enableProduct,
  disableProduct,
  deleteProduct,
  updateProductDetail,
  getProductDetail
} from '../api/admin'
import { getGalleryList } from '../api/gallery'
import { setBanner } from '../api/product'
import { getAllTags, getProductTags, setProductTags } from '../api/tag'

// 标签相关
const allTags = ref([])
const selectedTagIds = ref([])

const loadAllTags = async () => {
  try {
    const res = await getAllTags()
    allTags.value = res.data || []
  } catch (e) {
    console.error('加载标签失败')
  }
}

const loading = ref(false)
const submitLoading = ref(false)
const productList = ref([])
const total = ref(0)
const dialogVisible = ref(false)
const dialogTitle = ref('添加商品')
const isEdit = ref(false)
const productFormRef = ref(null)
const detailDialogVisible = ref(false)
const detailSaving = ref(false)
const detailTextareaRef = ref(null)
const detailForm = reactive({
  id: null,
  detail: ''
})

// 图库选择相关
const galleryDialogVisible = ref(false)
const galleryList = ref([])
const galleryLoading = ref(false)

// 打开图库选择对话框
const openGalleryDialog = async () => {
  galleryDialogVisible.value = true
  galleryLoading.value = true
  try {
    const res = await getGalleryList()
    if (res.code === 200 || res.success) {
      // 图库数据是 GalleryImage 对象数组，直接使用
      galleryList.value = res.data || []
    } else {
      ElMessage.error(res.message || '获取图库列表失败')
    }
  } catch (error) {
    console.error('获取图库列表失败:', error)
    ElMessage.error('获取图库列表失败')
  } finally {
    galleryLoading.value = false
  }
}

// 选择图库图片插入到编辑器
const selectGalleryImage = (imageUrl) => {
  const textarea = detailTextareaRef.value?.$refs?.textarea
  if (!textarea) return
  
  const start = textarea.selectionStart
  const end = textarea.selectionEnd
  const text = detailForm.detail
  const imageMarkdown = `![商品图片](${imageUrl})`
  
  const newText = text.substring(0, start) + imageMarkdown + text.substring(end)
  detailForm.detail = newText
  
  // 关闭对话框并设置光标位置
  galleryDialogVisible.value = false
  setTimeout(() => {
    const newCursorPos = start + imageMarkdown.length
    textarea.focus()
    textarea.setSelectionRange(newCursorPos, newCursorPos)
  }, 0)
}

// 插入 Markdown 语法
const insertMarkdown = (type) => {
  const textarea = detailTextareaRef.value?.$refs?.textarea
  if (!textarea) return
  
  const start = textarea.selectionStart
  const end = textarea.selectionEnd
  const text = detailForm.detail
  const selectedText = text.substring(start, end)
  
  let insertion = ''
  let cursorOffset = 0
  
  switch (type) {
    case 'h1':
      insertion = `# ${selectedText || '标题'}`
      cursorOffset = 2
      break
    case 'h2':
      insertion = `## ${selectedText || '标题'}`
      cursorOffset = 3
      break
    case 'h3':
      insertion = `### ${selectedText || '标题'}`
      cursorOffset = 4
      break
    case 'bold':
      insertion = `**${selectedText || '粗体文本'}**`
      cursorOffset = 2
      break
    case 'italic':
      insertion = `*${selectedText || '斜体文本'}*`
      cursorOffset = 1
      break
    case 'ul':
      insertion = selectedText 
        ? selectedText.split('\n').map(line => `- ${line}`).join('\n')
        : '- 列表项'
      break
    case 'ol':
      insertion = selectedText
        ? selectedText.split('\n').map((line, i) => `${i + 1}. ${line}`).join('\n')
        : '1. 列表项'
      break
    case 'link':
      insertion = `[${selectedText || '链接文字'}](https://example.com)`
      break
    case 'image':
      insertion = `![${selectedText || '图片描述'}](图片URL)`
      break
    case 'code':
      insertion = selectedText.includes('\n')
        ? `\`\`\`\n${selectedText || '代码块'}\n\`\`\``
        : `\`${selectedText || '代码'}\``
      break
    case 'quote':
      insertion = selectedText
        ? selectedText.split('\n').map(line => `> ${line}`).join('\n')
        : '> 引用内容'
      break
    case 'hr':
      insertion = '\n---\n'
      break
  }
  
  const newText = text.substring(0, start) + insertion + text.substring(end)
  detailForm.detail = newText
  
  // 设置光标位置
  setTimeout(() => {
    const newCursorPos = selectedText ? start + insertion.length : start + cursorOffset
    textarea.focus()
    textarea.setSelectionRange(newCursorPos, newCursorPos)
  }, 0)
}

// 简单的 Markdown 渲染
const renderedMarkdown = computed(() => {
  if (!detailForm.detail) return '<p style="color:#999">暂无内容</p>'
  return parseMarkdown(detailForm.detail)
})

// 简易 Markdown 解析器
const parseMarkdown = (text) => {
  if (!text) return ''
  // 1. 先处理图片语法（在转义前）
  let html = text
    // 图片语法 - 将相对路径转换为完整URL
    .replace(/!\[([^\]]*)\]\(([^)]+)\)/g, (match, alt, url) => {
      const fullUrl = getImageUrl(url)
      return `<img src="${fullUrl}" alt="${alt}" class="md-img" style="max-width:100%;border-radius:6px;margin:8px 0;box-shadow:0 2px 8px rgba(0,0,0,0.1)"/>`
    })
    // 链接语法
    .replace(/\[([^\]]+)\]\(([^)]+)\)/g, '<a href="$2" target="_blank" class="md-link">$1</a>')
  
  // 2. 转义 HTML（排除我们刚生成的标签）
  html = html
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
  
  // 3. 恢复我们生成的标签
  html = html
    .replace(/&lt;img/g, '<img')
    .replace(/class="md-img"\/&gt;/g, 'class="md-img" style="max-width:100%;border-radius:6px;margin:8px 0;box-shadow:0 2px 8px rgba(0,0,0,0.1)"&gt;')
    .replace(/&lt;a /g, '<a ')
    .replace(/class="md-link"&gt;/g, 'class="md-link" style="color:#409eff;text-decoration:underline"&gt;')
    .replace(/&lt;\/a&gt;/g, '</a>')
    .replace(/&gt;/g, '>')
  
  // 4. 其他 Markdown 语法
  html = html
    // 标题（在行首或<br>后）
    .replace(/(^|<br>)### (.+?)(?=<br>|$)/g, '$1<h3>$2</h3>')
    .replace(/(^|<br>)## (.+?)(?=<br>|$)/g, '$1<h2>$2</h2>')
    .replace(/(^|<br>)# (.+?)(?=<br>|$)/g, '$1<h1>$2</h1>')
    // 粗体和斜体
    .replace(/\*\*([^*]+?)\*\*/g, '<strong>$1</strong>')
    .replace(/\*([^*]+?)\*/g, '<em>$1</em>')
    // 无序列表
    .replace(/(^|<br>)- (.+?)(?=<br>|$)/g, '$1<li>$2</li>')
    // 有序列表
    .replace(/(^|<br>)\d+\. (.+?)(?=<br>|$)/g, '$1<li>$2</li>')
    // 分割线
    .replace(/(^|<br>)---(?=<br>|$)/g, '$1<hr style="border:none;border-top:1px solid #ddd;margin:16px 0">')
    // 行内代码
    .replace(/`([^`]+)`/g, '<code style="background:#f5f5f5;padding:2px 6px;border-radius:3px;font-size:12px">$1</code>')
    // 换行
    .replace(/\n/g, '<br>')
  
  return html
}

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
  selectedTagIds.value = []
  dialogVisible.value = true
}

const handleEdit = async (row) => {
  isEdit.value = true
  dialogTitle.value = '编辑商品'
  Object.assign(productForm, row)
  // 加载该商品已有标签
  try {
    const res = await getProductTags(row.id)
    selectedTagIds.value = (res.data || []).map(t => t.id)
  } catch (e) {
    selectedTagIds.value = []
  }
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
          // 保存商品成功后同步标签
          const productId = productForm.id || res.data
          if (productId) {
            try {
              await setProductTags(productId, selectedTagIds.value)
            } catch (e) {
              console.error('标签设置失败')
            }
          }
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
  loadAllTags()
})

// 打开详情编辑对话框
const handleDetail = async (row) => {
  detailForm.id = row.id
  detailForm.detail = ''
  try {
    const res = await getProductDetail(row.id)
    if (res.success && res.data) {
      detailForm.detail = res.data.detail || ''
    }
  } catch (error) {
    console.error('获取商品详情失败:', error)
  }
  detailDialogVisible.value = true
}

// 设为轮播图
const handleSetBanner = async (row) => {
  try {
    await setBanner(row.id, 1, row.bannerSort || 0)
    // 直接更新行数据，按钮立即切换
    row.isBanner = 1
    ElMessage.success(`商品「${row.name}」已设为轮播图`)
  } catch (error) {
    ElMessage.error('设置轮播图失败')
  }
}

// 取消轮播图
const handleCancelBanner = async (row) => {
  try {
    await setBanner(row.id, 0, 0)
    // 直接更新行数据，按钮立即切换
    row.isBanner = 0
    ElMessage.success(`商品「${row.name}」已取消轮播图`)
  } catch (error) {
    ElMessage.error('取消轮播图失败')
  }
}

// 保存详情
const handleDetailSubmit = async () => {
  detailSaving.value = true
  try {
    const res = await updateProductDetail(detailForm.id, detailForm.detail)
    if (res.success) {
      ElMessage.success('详情保存成功')
      detailDialogVisible.value = false
    } else {
      ElMessage.error(res.message || '保存失败')
    }
  } catch (error) {
    ElMessage.error('保存失败')
  } finally {
    detailSaving.value = false
  }
}
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

/* 详情编辑器样式 */
.detail-editor {
  display: flex;
  gap: 16px;
  height: 500px;
}

.markdown-toolbar {
  padding: 8px 12px;
  background: #f5f7fa;
  border-bottom: 1px solid #dcdfe6;
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 8px;
}

.markdown-toolbar .el-button-group {
  display: flex;
}

.markdown-toolbar .el-button {
  padding: 6px 10px;
  font-size: 13px;
}

.markdown-toolbar .toolbar-icon {
  font-size: 12px;
  font-weight: 500;
}

.markdown-toolbar .el-divider--vertical {
  height: 20px;
  margin: 0 4px;
}

.editor-pane,
.preview-pane {
  flex: 1;
  display: flex;
  flex-direction: column;
  border: 1px solid #dcdfe6;
  border-radius: 4px;
  overflow: hidden;
}

.pane-header {
  padding: 8px 12px;
  background: #f5f7fa;
  border-bottom: 1px solid #dcdfe6;
  font-weight: 500;
  font-size: 14px;
}

.detail-textarea {
  flex: 1;
}

.detail-textarea :deep(.el-textarea__inner) {
  height: 100% !important;
  resize: none;
  border: none;
  border-radius: 0;
  font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;
  font-size: 13px;
  line-height: 1.6;
}

.preview-pane {
  background: #fff;
}

.markdown-preview {
  flex: 1;
  padding: 16px;
  overflow-y: auto;
  font-size: 14px;
  line-height: 1.8;
}

.markdown-preview h1 {
  font-size: 24px;
  margin: 16px 0 12px;
  padding-bottom: 8px;
  border-bottom: 2px solid #409eff;
}

.markdown-preview h2 {
  font-size: 20px;
  margin: 14px 0 10px;
  color: #303133;
}

.markdown-preview h3 {
  font-size: 16px;
  margin: 12px 0 8px;
  color: #606266;
}

.markdown-preview ul {
  padding-left: 20px;
  margin: 8px 0;
}

.markdown-preview li {
  margin: 4px 0;
}

.markdown-preview strong {
  color: #409eff;
}

.markdown-preview img {
  max-width: 100%;
  border-radius: 6px;
  margin: 8px 0;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
  display: block;
}

.markdown-preview a {
  color: #409eff;
  text-decoration: underline;
}

.markdown-preview a:hover {
  color: #66b1ff;
}

.markdown-preview code {
  background: #f5f5f5;
  padding: 2px 6px;
  border-radius: 3px;
  font-size: 12px;
  color: #e6a23c;
}

.markdown-preview ul,
.markdown-preview ol {
  padding-left: 24px;
  margin: 8px 0;
}

.markdown-preview li {
  margin: 4px 0;
  line-height: 1.6;
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  padding-top: 12px;
}

.dialog-footer .el-button {
  min-width: 88px;
  border-radius: 6px;
}

/* 图库选择样式 */
.gallery-container {
  min-height: 200px;
}

.gallery-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
  gap: 16px;
  padding: 10px;
}

.gallery-item {
  position: relative;
  width: 100%;
  aspect-ratio: 1;
  border-radius: 8px;
  overflow: hidden;
  cursor: pointer;
  border: 2px solid transparent;
  transition: all 0.3s;
}

.gallery-item:hover {
  border-color: #409eff;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.gallery-image {
  width: 100%;
  height: 100%;
  display: block;
}

.gallery-item-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.4);
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: opacity 0.3s;
}

.gallery-item:hover .gallery-item-overlay {
  opacity: 1;
}
</style>
