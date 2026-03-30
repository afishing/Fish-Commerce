<template>
  <div class="profile-container">
    <!-- 头部导航 -->
    <AppHeader />

    <!-- 未登录提示 -->
    <el-empty v-if="!isLoggedIn" description="登录后才能查看个人中心" style="margin-top: 100px">
      <el-button type="primary" @click="$router.push('/login')">去登录</el-button>
    </el-empty>

    <!-- 已登录显示个人中心 -->
    <div v-else class="main-content">
      <el-aside width="240px" class="sidebar">
       <el-card class="user-card">
          <div class="avatar">
            <el-upload
              class="avatar-uploader"
              action="http://localhost:5000/upload"
              :headers="uploadHeaders"
              :show-file-list="false"
              :on-success="handleAvatarSuccess"
              :on-error="handleAvatarError"
              :before-upload="beforeAvatarUpload"
              accept="image/*"
            >
              <div class="avatar-wrapper">
                <el-avatar :size="80" :src="getImageUrl(user.avatar)" />
                <div class="avatar-overlay">
                  <el-icon v-if="!avatarUploading"><Camera /></el-icon>
                  <el-icon v-else class="is-loading"><Loading /></el-icon>
                </div>
              </div>
            </el-upload>
          </div>
          <h3>{{ user.username }}</h3>
        </el-card>
        
        <el-menu :default-active="activeMenu" class="side-menu">
          <el-menu-item index="info" @click="activeMenu = 'info'">
            <el-icon><User /></el-icon>
            <span>个人信息</span>
          </el-menu-item>
          <el-menu-item index="vip" @click="activeMenu = 'vip'">
            <el-icon><StarFilled /></el-icon>
            <span>会员中心</span>
          </el-menu-item>
          <el-menu-item index="address" @click="handleAddressMenuClick">
            <el-icon><Location /></el-icon>
            <span>收货地址</span>
          </el-menu-item>
          <el-menu-item index="security" @click="activeMenu = 'security'">
            <el-icon><Lock /></el-icon>
            <span>账号安全</span>
          </el-menu-item>
        </el-menu>
      </el-aside>

      <el-main class="content">
        <!-- 个人信息 -->
        <el-card v-if="activeMenu === 'info'">
          <template #header>
            <span>个人信息</span>
          </template>
          <el-form :model="user" label-width="80px" style="max-width: 500px">
            <el-form-item label="用户名">
              <el-input v-model="user.username" disabled />
            </el-form-item>
            <el-form-item label="昵称">
              <el-input v-model="user.nickname" />
            </el-form-item>
            <el-form-item label="邮箱">
              <el-input v-model="user.email" />
            </el-form-item>
            <el-form-item label="手机号">
              <el-input v-model="user.phone" />
            </el-form-item>
            <el-form-item label="性别">
              <el-radio-group v-model="user.gender">
                <el-radio :value="0">男</el-radio>
                <el-radio :value="1">女</el-radio>
                <el-radio :value="2">保密</el-radio>
              </el-radio-group>
            </el-form-item>
            <el-form-item label="生日">
              <el-date-picker v-model="user.birthday" type="date" placeholder="选择日期" style="width: 100%" />
            </el-form-item>
            <el-form-item>
              <el-button type="primary" @click="saveInfo" :loading="loading">保存修改</el-button>
            </el-form-item>
          </el-form>
        </el-card>

        <!-- 会员中心 -->
        <el-card v-if="activeMenu === 'vip'">
          <template #header>
            <span>会员中心</span>
          </template>
          <div class="vip-info">
            <div class="vip-status">
              <div class="vip-level">
                <el-tag v-if="user.level && user.level > 0" type="warning" size="large">
                  <el-icon><StarFilled /></el-icon>
                  {{ user.level === 1 ? '月卡会员' : user.level === 2 ? '季卡会员' : '年卡会员' }}
                </el-tag>
                <el-tag v-else type="info" size="large">普通用户</el-tag>
              </div>
              <div v-if="user.vipExpireTime" class="vip-expire">
                <p>会员有效期至：{{ formatDate(user.vipExpireTime) }}</p>
              </div>
            </div>
            
            <el-divider />
            
            <h4>开通会员</h4>
            <el-row :gutter="20" style="margin-top: 16px">
              <el-col :span="8">
                <el-card shadow="hover" class="vip-card" @click="handleBuyVip(1)">
                  <div class="vip-card-content">
                    <div class="vip-card-title">月卡会员</div>
                    <div class="vip-card-price">¥19.9</div>
                    <div class="vip-card-desc">30天会员权益</div>
                  </div>
                </el-card>
              </el-col>
              <el-col :span="8">
                <el-card shadow="hover" class="vip-card" @click="handleBuyVip(2)">
                  <div class="vip-card-content">
                    <div class="vip-card-title">季卡会员</div>
                    <div class="vip-card-price">¥49.9</div>
                    <div class="vip-card-desc">90天会员权益</div>
                    <el-tag type="success" size="small">推荐</el-tag>
                  </div>
                </el-card>
              </el-col>
              <el-col :span="8">
                <el-card shadow="hover" class="vip-card" @click="handleBuyVip(3)">
                  <div class="vip-card-content">
                    <div class="vip-card-title">年卡会员</div>
                    <div class="vip-card-price">¥149.9</div>
                    <div class="vip-card-desc">365天会员权益</div>
                    <el-tag type="danger" size="small">超值</el-tag>
                  </div>
                </el-card>
              </el-col>
            </el-row>
            
            <el-divider />
            
            <h4>会员权益</h4>
            <div class="vip-benefits">
              <div class="benefit-item">
                <el-icon><Check /></el-icon>
                <span>专属折扣：会员商品享受95折优惠</span>
              </div>
              <div class="benefit-item">
                <el-icon><Check /></el-icon>
                <span>优先配送：订单优先处理</span>
              </div>
              <div class="benefit-item">
                <el-icon><Check /></el-icon>
                <span>专属客服：一对一贴心服务</span>
              </div>
              <div class="benefit-item">
                <el-icon><Check /></el-icon>
                <span>积分加倍：购物积分翻倍</span>
              </div>
            </div>
          </div>
        </el-card>

        <!-- 收货地址 -->
        <el-card v-if="activeMenu === 'address'">
          <template #header>
            <div style="display: flex; justify-content: space-between; align-items: center">
              <span>收货地址</span>
              <el-button type="primary" size="small" @click="openAddAddressDialog">新增地址</el-button>
            </div>
          </template>
          <div v-if="addresses.length === 0" class="empty-address">
            <el-empty description="暂无收货地址" />
          </div>
          <div v-else class="address-list">
            <div v-for="addr in addresses" :key="addr.id" class="address-item">
              <div class="addr-info">
                <p><strong>{{ addr.receiverName }}</strong> {{ addr.receiverPhone }}</p>
                <p>{{ addr.province }} {{ addr.city }} {{ addr.district }} {{ addr.detail }}</p>
                <el-tag v-if="addr.isDefault === 1" type="success" size="small">默认</el-tag>
              </div>
              <div class="addr-actions">
                <el-button v-if="addr.isDefault !== 1" size="small" @click="handleSetDefault(addr)">设为默认</el-button>
                <el-button size="small" @click="openEditAddressDialog(addr)">编辑</el-button>
                <el-button type="danger" size="small" @click="handleDeleteAddress(addr)">删除</el-button>
              </div>
            </div>
          </div>
        </el-card>

        <!-- 账号安全 -->
        <el-card v-if="activeMenu === 'security'">
          <template #header>
            <span>账号安全</span>
          </template>
          <div class="security-list">
            <div class="security-item">
              <div class="info">
                <h4>登录密码</h4>
                <p>定期更换密码可以保护账号安全</p>
              </div>
              <el-button @click="modifyPassword">修改</el-button>
            </div>
            <div class="security-item">
              <div class="info">
                <h4>绑定手机</h4>
                <p>已绑定：{{ user.phone }}</p>
              </div>
              <el-button @click="modifyPhone">修改</el-button>
            </div>
            <div class="security-item">
              <div class="info">
                <h4>绑定邮箱</h4>
                <p>已绑定：{{ user.email }}</p>
              </div>
              <el-button @click="modifyEmail">修改</el-button>
            </div>
          </div>
        </el-card>
      </el-main>
    </div>

    <!-- 修改密码对话框 -->
    <el-dialog v-model="showPasswordDialog" title="修改密码" width="400px" :close-on-click-modal="false">
      <el-form label-width="100px">
        <el-form-item label="旧密码">
          <el-input v-model="passwordForm.oldPassword" type="password" placeholder="请输入旧密码" show-password />
        </el-form-item>
        <el-form-item label="新密码">
          <el-input v-model="passwordForm.newPassword" type="password" placeholder="请输入新密码" show-password />
        </el-form-item>
        <el-form-item label="确认新密码">
          <el-input v-model="passwordForm.confirmPassword" type="password" placeholder="请再次输入新密码" show-password />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showPasswordDialog = false">取消</el-button>
        <el-button type="primary" @click="submitPassword" :loading="dialogLoading">确认修改</el-button>
      </template>
    </el-dialog>

    <!-- 修改手机号对话框 -->
    <el-dialog v-model="showPhoneDialog" title="修改手机号" width="400px" :close-on-click-modal="false">
      <el-form label-width="100px">
        <el-form-item label="当前手机号">
          <el-input :value="user.phone" disabled />
        </el-form-item>
        <el-form-item label="新手机号">
          <el-input v-model="phoneForm.phone" placeholder="请输入新手机号" maxlength="11" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showPhoneDialog = false">取消</el-button>
        <el-button type="primary" @click="submitPhone" :loading="dialogLoading">确认修改</el-button>
      </template>
    </el-dialog>

    <!-- 修改邮箱对话框 -->
    <el-dialog v-model="showEmailDialog" title="修改邮箱" width="400px" :close-on-click-modal="false">
      <el-form label-width="100px">
        <el-form-item label="当前邮箱">
          <el-input :value="user.email" disabled />
        </el-form-item>
        <el-form-item label="新邮箱">
          <el-input v-model="emailForm.email" placeholder="请输入新邮箱" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showEmailDialog = false">取消</el-button>
        <el-button type="primary" @click="submitEmail" :loading="dialogLoading">确认修改</el-button>
      </template>
    </el-dialog>

    <!-- 地址编辑对话框 -->
    <el-dialog v-model="showAddressDialog" :title="isEditAddress ? '编辑地址' : '新增地址'" width="500px" :close-on-click-modal="false">
      <el-form label-width="100px">
        <el-form-item label="收货人">
          <el-input v-model="addressForm.receiverName" placeholder="请输入收货人姓名" maxlength="20" />
        </el-form-item>
        <el-form-item label="手机号">
          <el-input v-model="addressForm.receiverPhone" placeholder="请输入手机号" maxlength="11" />
        </el-form-item>
        <el-form-item label="省市区">
          <div style="display: flex; gap: 10px;">
            <el-input v-model="addressForm.province" placeholder="省" style="flex: 1" />
            <el-input v-model="addressForm.city" placeholder="市" style="flex: 1" />
            <el-input v-model="addressForm.district" placeholder="区" style="flex: 1" />
          </div>
        </el-form-item>
        <el-form-item label="详细地址">
          <el-input v-model="addressForm.detail" type="textarea" :rows="2" placeholder="请输入详细地址" maxlength="100" show-word-limit />
        </el-form-item>
        <el-form-item>
          <el-checkbox v-model="addressForm.isDefault" :true-value="1" :false-value="0">设为默认地址</el-checkbox>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showAddressDialog = false">取消</el-button>
        <el-button type="primary" @click="submitAddress" :loading="loading">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import { User, Location, Lock, Camera, Loading, StarFilled, Check } from '@element-plus/icons-vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import AppHeader from '@/components/AppHeader.vue'
import { getUserInfo, updateUserInfo, updatePassword, updatePhone, updateEmail, purchaseVip } from '@/api/user'
import { getAddressList, addAddress, updateAddress, deleteAddress, setDefaultAddress } from '@/api/address'
import { getImageUrl } from '@/utils/image'

const router = useRouter()
const activeMenu = ref('info')
const showAddAddress = ref(false)
const loading = ref(false)

// 登录状态
const isLoggedIn = ref(false)

// 用户 ID（从 localStorage 获取）
const userId = ref(null)

const user = reactive({
  id: null,
  username: '',
  nickname: '',
  email: '',
  phone: '',
  gender: 2,
  birthday: '',
  level: 0,
  vipExpireTime: null,
  avatar: ''
})

// 从 localStorage 获取用户信息并加载数据
onMounted(async () => {
  const storedUserInfo = localStorage.getItem('userInfo')
  if (storedUserInfo) {
    isLoggedIn.value = true
    const info = JSON.parse(storedUserInfo)
    userId.value = info.id
    user.id = info.id
    user.username = info.username || ''
    user.nickname = info.nickname || ''
    user.email = info.email || ''
    user.phone = info.phone || ''
    user.avatar = info.avatar || ''
    user.gender = info.gender !== undefined ? info.gender : 2
    // 处理生日：localStorage 中存储的可能是字符串，需要转换为 Date 对象
    if (info.birthday) {
      user.birthday = new Date(info.birthday)
    } else {
      user.birthday = ''
    }
    
    // 从后端加载最新的用户信息
    await loadUserInfo(info.id)
  } else {
    // 未登录跳转到登录页
    router.push('/login')
  }
})

// 从后端加载用户信息
const loadUserInfo = async (id) => {
  try {
    loading.value = true
    const res = await getUserInfo(id)
    if ((res.code === 0 || res.code === 200) && res.data) {
      const data = res.data
      user.id = data.id || id
      user.nickname = data.nickname || ''
      user.email = data.email || ''
      user.phone = data.phone || ''
      user.gender = data.gender !== undefined ? data.gender : 2
      // 处理生日：后端返回的可能是字符串，需要转换为 Date 对象
      if (data.birthday) {
        user.birthday = new Date(data.birthday)
      } else {
        user.birthday = ''
      }
      user.avatar = data.avatar || ''
      user.level = data.level || 0
      user.vipExpireTime = data.vipExpireTime || null
    }
  } catch (error) {
    console.error('加载用户信息失败:', error)
    ElMessage.warning('加载用户信息失败')
  } finally {
    loading.value = false
  }
}

// 格式化日期
const formatDate = (dateStr) => {
  if (!dateStr) return ''
  const date = new Date(dateStr)
  return date.toLocaleString('zh-CN', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit'
  })
}

// 购买会员
const handleBuyVip = async (vipType) => {
  const vipNames = {
    1: '月卡会员（¥19.9）',
    2: '季卡会员（¥49.9）',
    3: '年卡会员（¥149.9）'
  }
  
  try {
    await ElMessageBox.confirm(
      `确认购买${vipNames[vipType]}？`,
      '购买会员',
      {
        confirmButtonText: '确认购买',
        cancelButtonText: '取消',
        type: 'info'
      }
    )
    
    const res = await purchaseVip(user.id, vipType)
    if (res.code === 0 || res.code === 200) {
      ElMessage.success('购买成功')
      // 重新加载用户信息
      await loadUserInfo(user.id)
      // 更新 localStorage
      const currentUserInfo = JSON.parse(localStorage.getItem('userInfo'))
      if (currentUserInfo) {
        currentUserInfo.level = user.level
        currentUserInfo.vipExpireTime = user.vipExpireTime
        localStorage.setItem('userInfo', JSON.stringify(currentUserInfo))
      }
    } else {
      ElMessage.error(res.message || res.msg || '购买失败')
    }
  } catch (error) {
    if (error !== 'cancel') {
      console.error('购买会员失败:', error)
      ElMessage.error('购买失败，请稍后重试')
    }
  }
}

const addresses = reactive([])

const saveInfo = async () => {
  try {
    // 验证必填字段
    if (!user.nickname || !user.nickname.trim()) {
      ElMessage.warning('昵称不能为空')
      return
    }
    
    // 验证邮箱格式
    if (user.email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(user.email)) {
      ElMessage.warning('邮箱格式不正确')
      return
    }
    
    // 验证手机号格式（简单验证）
    if (user.phone && !/^1[3-9]\d{9}$/.test(user.phone)) {
      ElMessage.warning('手机号格式不正确')
      return
    }
    
    loading.value = true
    
    // 准备提交的数据
    const updateData = {
      id: user.id,
      nickname: user.nickname.trim(),
      email: user.email ? user.email.trim() : null,
      phone: user.phone ? user.phone.trim() : null,
      gender: user.gender,
      birthday: user.birthday || null,
      avatar: user.avatar || null
    }
    
    const res = await updateUserInfo(updateData)
    
    if (res.code === 0 || res.code === 200) {
      ElMessage.success('个人信息保存成功')
      
      // 更新 localStorage 中的用户信息
      const currentUserInfo = JSON.parse(localStorage.getItem('userInfo'))
      if (currentUserInfo) {
        currentUserInfo.nickname = user.nickname
        currentUserInfo.email = user.email
        currentUserInfo.phone = user.phone
        currentUserInfo.gender = user.gender
        // 存储生日时转换为 ISO 字符串格式
        currentUserInfo.birthday = user.birthday ? new Date(user.birthday).toISOString() : ''
        currentUserInfo.avatar = user.avatar
        localStorage.setItem('userInfo', JSON.stringify(currentUserInfo))
      }
    } else {
      ElMessage.error(res.message || res.msg || '保存失败')
    }
  } catch (error) {
    console.error('保存失败:', error)
    ElMessage.error('保存失败，请稍后重试')
  } finally {
    loading.value = false
  }
}

// 收货地址菜单点击处理
const handleAddressMenuClick = () => {
  activeMenu.value = 'address'
  loadAddressList()
}

// 收货地址相关
const showAddressDialog = ref(false)
const isEditAddress = ref(false)
const addressForm = reactive({
  id: null,
  receiverName: '',
  receiverPhone: '',
  province: '',
  city: '',
  district: '',
  detail: '',
  isDefault: 0
})

// 加载收货地址列表
const loadAddressList = async () => {
  try {
    const res = await getAddressList(user.id)
    if (res.code === 0 || res.code === 200) {
      addresses.length = 0
      if (res.data) {
        addresses.push(...res.data)
      }
    }
  } catch (error) {
    console.error('加载地址列表失败:', error)
  }
}

// 打开新增地址对话框
const openAddAddressDialog = () => {
  isEditAddress.value = false
  addressForm.id = null
  addressForm.receiverName = ''
  addressForm.receiverPhone = ''
  addressForm.province = ''
  addressForm.city = ''
  addressForm.district = ''
  addressForm.detail = ''
  addressForm.isDefault = 0
  showAddressDialog.value = true
}

// 打开编辑地址对话框
const openEditAddressDialog = (addr) => {
  isEditAddress.value = true
  addressForm.id = addr.id
  addressForm.receiverName = addr.receiverName
  addressForm.receiverPhone = addr.receiverPhone
  addressForm.province = addr.province
  addressForm.city = addr.city
  addressForm.district = addr.district
  addressForm.detail = addr.detail
  addressForm.isDefault = addr.isDefault
  showAddressDialog.value = true
}

// 提交地址表单
const submitAddress = async () => {
  // 表单验证
  if (!addressForm.receiverName.trim()) {
    ElMessage.warning('请输入收货人姓名')
    return
  }
  if (!addressForm.receiverPhone.trim()) {
    ElMessage.warning('请输入收货人电话')
    return
  }
  if (!/^1[3-9]\d{9}$/.test(addressForm.receiverPhone)) {
    ElMessage.warning('手机号格式不正确')
    return
  }
  if (!addressForm.province.trim() || !addressForm.city.trim() || !addressForm.district.trim()) {
    ElMessage.warning('请输入省市区')
    return
  }
  if (!addressForm.detail.trim()) {
    ElMessage.warning('请输入详细地址')
    return
  }
  
  try {
    loading.value = true
    const data = {
      ...addressForm,
      userId: user.id
    }
    
    let res
    if (isEditAddress.value) {
      res = await updateAddress(data)
    } else {
      res = await addAddress(data)
    }
    
    if (res.code === 0 || res.code === 200) {
      ElMessage.success(isEditAddress.value ? '地址更新成功' : '地址添加成功')
      showAddressDialog.value = false
      await loadAddressList()
    } else {
      ElMessage.error(res.message || res.msg || '操作失败')
    }
  } catch (error) {
    console.error('保存地址失败:', error)
    ElMessage.error('保存失败，请稍后重试')
  } finally {
    loading.value = false
  }
}

// 删除地址
const handleDeleteAddress = async (addr) => {
  try {
    await ElMessageBox.confirm('确定要删除该地址吗？', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })
    
    const res = await deleteAddress(addr.id, user.id)
    if (res.code === 0 || res.code === 200) {
      ElMessage.success('删除成功')
      await loadAddressList()
    } else {
      ElMessage.error(res.message || res.msg || '删除失败')
    }
  } catch (error) {
    if (error !== 'cancel') {
      console.error('删除地址失败:', error)
      ElMessage.error('删除失败，请稍后重试')
    }
  }
}

// 设置默认地址
const handleSetDefault = async (addr) => {
  try {
    const res = await setDefaultAddress(addr.id, user.id)
    if (res.code === 0 || res.code === 200) {
      ElMessage.success('已设为默认地址')
      await loadAddressList()
    } else {
      ElMessage.error(res.message || res.msg || '设置失败')
    }
  } catch (error) {
    console.error('设置默认地址失败:', error)
    ElMessage.error('设置失败，请稍后重试')
  }
}

// 对话框显示状态
const showPasswordDialog = ref(false)
const showPhoneDialog = ref(false)
const showEmailDialog = ref(false)

// 密码表单
const passwordForm = reactive({
  oldPassword: '',
  newPassword: '',
  confirmPassword: ''
})

// 手机号表单
const phoneForm = reactive({
  phone: ''
})

// 邮箱表单
const emailForm = reactive({
  email: ''
})

// 对话框加载状态
const dialogLoading = ref(false)

const avatarUploading = ref(false)

// 上传请求头（携带 token）
const uploadHeaders = computed(() => ({
  Authorization: `Bearer ${localStorage.getItem('token') || ''}`
}))

// 头像上传成功
const handleAvatarSuccess = async (response) => {
  if (response.success || response.code === 200 || response.data) {
    const newAvatar = response.data
    user.avatar = newAvatar
    avatarUploading.value = false
    try {
      await updateUserInfo({ id: user.id, avatar: newAvatar })
      // 同步更新 localStorage
      const currentUserInfo = JSON.parse(localStorage.getItem('userInfo'))
      if (currentUserInfo) {
        currentUserInfo.avatar = newAvatar
        localStorage.setItem('userInfo', JSON.stringify(currentUserInfo))
      }
      // 通知导航栏刷新头像
      window.dispatchEvent(new Event('userInfoUpdated'))
      ElMessage.success('头像更新成功')
    } catch (e) {
      ElMessage.error('头像保存失败')
    }
  } else {
    avatarUploading.value = false
    ElMessage.error(response.message || '上传失败')
  }
}

const handleAvatarError = () => {
  avatarUploading.value = false
  ElMessage.error('头像上传失败，请重试')
}

const beforeAvatarUpload = (file) => {
  const isImage = file.type.startsWith('image/')
  const isLt2M = file.size / 1024 / 1024 < 2
  if (!isImage) {
    ElMessage.error('只支持图片格式')
    return false
  }
  if (!isLt2M) {
    ElMessage.error('图片大小不能超过 2MB')
    return false
  }
  avatarUploading.value = true
  return true
}

const modifyPassword = () => {
  passwordForm.oldPassword = ''
  passwordForm.newPassword = ''
  passwordForm.confirmPassword = ''
  showPasswordDialog.value = true
}

const modifyPhone = () => {
  phoneForm.phone = ''
  showPhoneDialog.value = true
}

const modifyEmail = () => {
  emailForm.email = ''
  showEmailDialog.value = true
}

// 提交修改密码
const submitPassword = async () => {
  if (!passwordForm.oldPassword) {
    ElMessage.warning('请输入旧密码')
    return
  }
  if (!passwordForm.newPassword) {
    ElMessage.warning('请输入新密码')
    return
  }
  if (passwordForm.newPassword !== passwordForm.confirmPassword) {
    ElMessage.warning('两次新密码输入不一致')
    return
  }
  if (passwordForm.newPassword.length < 6) {
    ElMessage.warning('新密码长度不能少于6位')
    return
  }
  
  try {
    dialogLoading.value = true
    const res = await updatePassword({
      userId: user.id,
      oldPassword: passwordForm.oldPassword,
      newPassword: passwordForm.newPassword,
      confirmPassword: passwordForm.confirmPassword
    })
    
    if (res.code === 0 || res.code === 200) {
      ElMessage.success('密码修改成功')
      showPasswordDialog.value = false
    } else {
      ElMessage.error(res.message || res.msg || '修改失败')
    }
  } catch (error) {
    console.error('修改密码失败:', error)
    ElMessage.error('修改失败，请稍后重试')
  } finally {
    dialogLoading.value = false
  }
}

// 提交修改手机号
const submitPhone = async () => {
  if (!phoneForm.phone) {
    ElMessage.warning('请输入新手机号')
    return
  }
  if (!/^1[3-9]\d{9}$/.test(phoneForm.phone)) {
    ElMessage.warning('手机号格式不正确')
    return
  }
  
  try {
    dialogLoading.value = true
    const res = await updatePhone({
      userId: user.id,
      phone: phoneForm.phone
    })
    
    if (res.code === 0 || res.code === 200) {
      ElMessage.success('手机号修改成功')
      user.phone = phoneForm.phone
      // 更新 localStorage
      const currentUserInfo = JSON.parse(localStorage.getItem('userInfo'))
      if (currentUserInfo) {
        currentUserInfo.phone = phoneForm.phone
        localStorage.setItem('userInfo', JSON.stringify(currentUserInfo))
      }
      showPhoneDialog.value = false
    } else {
      ElMessage.error(res.message || res.msg || '修改失败')
    }
  } catch (error) {
    console.error('修改手机号失败:', error)
    ElMessage.error('修改失败，请稍后重试')
  } finally {
    dialogLoading.value = false
  }
}

// 提交修改邮箱
const submitEmail = async () => {
  if (!emailForm.email) {
    ElMessage.warning('请输入新邮箱')
    return
  }
  if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(emailForm.email)) {
    ElMessage.warning('邮箱格式不正确')
    return
  }
  
  try {
    dialogLoading.value = true
    const res = await updateEmail({
      userId: user.id,
      email: emailForm.email
    })
    
    if (res.code === 0 || res.code === 200) {
      ElMessage.success('邮箱修改成功')
      user.email = emailForm.email
      // 更新 localStorage
      const currentUserInfo = JSON.parse(localStorage.getItem('userInfo'))
      if (currentUserInfo) {
        currentUserInfo.email = emailForm.email
        localStorage.setItem('userInfo', JSON.stringify(currentUserInfo))
      }
      showEmailDialog.value = false
    } else {
      ElMessage.error(res.message || res.msg || '修改失败')
    }
  } catch (error) {
    console.error('修改邮箱失败:', error)
    ElMessage.error('修改失败，请稍后重试')
  } finally {
    dialogLoading.value = false
  }
}
</script>

<style scoped>
.profile-container {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  background: #f5f7fa;
}

.main-content {
  display: flex;
  flex: 1;
  padding: 20px;
  max-width: 1200px;
  margin: 0 auto;
  width: 100%;
}

.sidebar {
  margin-right: 20px;
}

.user-card {
  text-align: center;
  padding: 20px;
  margin-bottom: 20px;
}

.avatar {
  margin-bottom: 15px;
  display: flex;
  justify-content: center;
}

.avatar-uploader {
  cursor: pointer;
}

.avatar-wrapper {
  position: relative;
  width: 80px;
  height: 80px;
  border-radius: 50%;
  overflow: hidden;
}

.avatar-overlay {
  position: absolute;
  inset: 0;
  background: rgba(0, 0, 0, 0.45);
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: opacity 0.2s;
  color: #fff;
  font-size: 22px;
}

.avatar-wrapper:hover .avatar-overlay {
  opacity: 1;
}

.user-card h3 {
  margin-bottom: 10px;
}

.side-menu {
  border-right: none;
}

.content {
  background: transparent;
  padding: 0;
}

.address-list {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.address-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px;
  border: 1px solid #ebeef5;
  border-radius: 8px;
}

.address-item:has(.el-tag--success) {
  border-color: #67c23a;
}

.addr-info p {
  margin-bottom: 5px;
}

.addr-actions {
  display: flex;
  gap: 10px;
}

.security-list {
  display: flex;
  flex-direction: column;
}

.security-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px 0;
  border-bottom: 1px solid #ebeef5;
}

.security-item:last-child {
  border-bottom: none;
}

.security-item .info h4 {
  margin-bottom: 5px;
}

.security-item .info p {
  color: #909399;
  font-size: 14px;
}

.vip-info {
  padding: 10px 0;
}

.vip-status {
  text-align: center;
  padding: 20px 0;
}

.vip-level {
  margin-bottom: 10px;
}

.vip-expire {
  color: #909399;
  font-size: 14px;
}

.vip-card {
  cursor: pointer;
  text-align: center;
  transition: transform 0.2s, box-shadow 0.2s;
  border: 2px solid transparent;
}

.vip-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  border-color: #409eff;
}

.vip-card-content {
  padding: 10px 0;
}

.vip-card-title {
  font-size: 16px;
  font-weight: bold;
  margin-bottom: 10px;
}

.vip-card-price {
  font-size: 24px;
  color: #f56c6c;
  font-weight: bold;
  margin-bottom: 10px;
}

.vip-card-desc {
  color: #909399;
  font-size: 12px;
  margin-bottom: 10px;
}

.vip-benefits {
  margin-top: 16px;
}

.benefit-item {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 10px 0;
  color: #67c23a;
}

.benefit-item .el-icon {
  font-size: 18px;
}
</style>
