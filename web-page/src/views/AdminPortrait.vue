<template>
  <div class="portrait-container">
    <el-row :gutter="20">
      <!-- 用户统计卡片 -->
      <el-col :span="6">
        <el-card class="stat-card">
          <div class="stat-item">
            <div class="stat-value">{{ portrait.totalUsers || 0 }}</div>
            <div class="stat-label">用户总数</div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stat-card success">
          <div class="stat-item">
            <div class="stat-value">{{ portrait.activeUsers || 0 }}</div>
            <div class="stat-label">活跃用户</div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stat-card danger">
          <div class="stat-item">
            <div class="stat-value">{{ portrait.disabledUsers || 0 }}</div>
            <div class="stat-label">禁用用户</div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stat-card warning">
          <div class="stat-item">
            <div class="stat-value">{{ portrait.avgOrdersPerUser || 0 }}</div>
            <div class="stat-label">人均订单数</div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="20" style="margin-top: 20px;">
      <!-- 性别分布 -->
      <el-col :span="8">
        <el-card>
          <template #header>
            <span>性别分布</span>
          </template>
          <div class="gender-stats">
            <div class="gender-item">
              <span class="gender-label">男性</span>
              <el-progress :percentage="getGenderPercentage('male')" :stroke-width="20" />
              <span class="gender-count">{{ portrait.maleCount || 0 }} 人</span>
            </div>
            <div class="gender-item">
              <span class="gender-label">女性</span>
              <el-progress :percentage="getGenderPercentage('female')" :stroke-width="20" status="success" />
              <span class="gender-count">{{ portrait.femaleCount || 0 }} 人</span>
            </div>
            <div class="gender-item">
              <span class="gender-label">保密</span>
              <el-progress :percentage="getGenderPercentage('secret')" :stroke-width="20" status="warning" />
              <span class="gender-count">{{ portrait.secretCount || 0 }} 人</span>
            </div>
          </div>
        </el-card>
      </el-col>

      <!-- 消费层次分布 -->
      <el-col :span="8">
        <el-card>
          <template #header>
            <span>消费层次分布</span>
          </template>
          <div v-if="portrait.consumeLevelDist" class="consume-level">
            <div v-for="(count, level) in portrait.consumeLevelDist" :key="level" class="level-item">
              <span class="level-label">{{ level }}</span>
              <el-tag type="primary">{{ count }} 人</el-tag>
            </div>
          </div>
          <el-empty v-else description="暂无数据" />
        </el-card>
      </el-col>

      <!-- 消费统计 -->
      <el-col :span="8">
        <el-card>
          <template #header>
            <span>消费统计</span>
          </template>
          <div class="consume-stats">
            <div class="consume-item">
              <span class="consume-label">人均消费金额</span>
              <span class="consume-value">¥{{ portrait.avgSpendPerUser || 0 }}</span>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="20" style="margin-top: 20px;">
      <!-- 注册趋势 -->
      <el-col :span="12">
        <el-card>
          <template #header>
            <span>近7日注册趋势</span>
          </template>
          <div v-if="portrait.registerTrend && portrait.registerTrend.length" class="trend-chart">
            <div v-for="item in portrait.registerTrend" :key="item.date" class="trend-item">
              <span class="trend-date">{{ item.date }}</span>
              <el-progress 
                :percentage="getTrendPercentage(item.count)" 
                :stroke-width="15"
                :show-text="false"
              />
              <span class="trend-count">{{ item.count }} 人</span>
            </div>
          </div>
          <el-empty v-else description="暂无数据" />
        </el-card>
      </el-col>

      <!-- 消费排行榜 -->
      <el-col :span="12">
        <el-card>
          <template #header>
            <span>消费排行榜 TOP5</span>
          </template>
          <el-table 
            v-if="portrait.topConsumers && portrait.topConsumers.length" 
            :data="portrait.topConsumers" 
            border
          >
            <el-table-column type="index" label="排名" width="60" />
            <el-table-column prop="username" label="用户名" width="120" />
            <el-table-column prop="nickname" label="昵称" width="120" />
            <el-table-column prop="orderCount" label="订单数" width="100" />
            <el-table-column prop="totalSpend" label="消费总额">
              <template #default="{ row }">
                <span style="color: #f56c6c; font-weight: bold;">¥{{ row.totalSpend }}</span>
              </template>
            </el-table-column>
          </el-table>
          <el-empty v-else description="暂无数据" />
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { getUserPortrait } from '../api/admin'

const portrait = ref({})

const fetchPortrait = async () => {
  try {
    const res = await getUserPortrait()
    if (res.success) {
      portrait.value = res.data || {}
    } else {
      ElMessage.error(res.message || '获取用户画像失败')
    }
  } catch (error) {
    ElMessage.error('获取用户画像失败')
  }
}

const getGenderPercentage = (type) => {
  const total = portrait.value.totalUsers || 0
  if (total === 0) return 0
  let count = 0
  if (type === 'male') count = portrait.value.maleCount || 0
  else if (type === 'female') count = portrait.value.femaleCount || 0
  else count = portrait.value.secretCount || 0
  return Math.round((count / total) * 100)
}

const getTrendPercentage = (count) => {
  const maxCount = Math.max(...(portrait.value.registerTrend || []).map(i => i.count), 1)
  return Math.round((count / maxCount) * 100)
}

onMounted(() => {
  fetchPortrait()
})
</script>

<style scoped>
.portrait-container {
  padding: 20px;
}

.stat-card {
  text-align: center;
}

.stat-card .stat-item {
  padding: 10px 0;
}

.stat-card .stat-value {
  font-size: 32px;
  font-weight: bold;
  color: #409eff;
}

.stat-card.success .stat-value {
  color: #67c23a;
}

.stat-card.danger .stat-value {
  color: #f56c6c;
}

.stat-card.warning .stat-value {
  color: #e6a23c;
}

.stat-card .stat-label {
  margin-top: 10px;
  color: #909399;
}

.gender-stats {
  padding: 10px 0;
}

.gender-item {
  margin-bottom: 15px;
  display: flex;
  align-items: center;
  gap: 10px;
}

.gender-label {
  width: 50px;
}

.gender-count {
  width: 60px;
  text-align: right;
  color: #909399;
}

.consume-level .level-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 0;
  border-bottom: 1px solid #ebeef5;
}

.consume-level .level-item:last-child {
  border-bottom: none;
}

.consume-stats {
  padding: 20px 0;
}

.consume-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.consume-label {
  color: #909399;
}

.consume-value {
  font-size: 24px;
  font-weight: bold;
  color: #f56c6c;
}

.trend-chart {
  padding: 10px 0;
}

.trend-item {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 12px;
}

.trend-date {
  width: 100px;
  color: #606266;
  font-size: 13px;
}

.trend-item .el-progress {
  flex: 1;
}

.trend-count {
  width: 60px;
  text-align: right;
  color: #909399;
}
</style>
