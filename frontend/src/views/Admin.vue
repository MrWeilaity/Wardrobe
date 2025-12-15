<template>
  <div class="admin-page">
    <div class="page-header">
      <h2 class="page-title">管理员控制面板</h2>
      <div class="quick-actions">
        <button @click="refreshAllData" class="btn btn-primary" :disabled="isRefreshing">
          {{ isRefreshing ? '⏳ 刷新中...' : '🔄 全部刷新' }}
        </button>
      </div>
    </div>

    <!-- System Statistics -->
    <div class="stats-grid">
      <div class="stat-card card">
        <div class="stat-icon">👥</div>
        <div class="stat-info">
          <div class="stat-value">{{ stats.totalUsers }}</div>
          <div class="stat-label">总用户数</div>
        </div>
      </div>
      <div class="stat-card card">
        <div class="stat-icon">👔</div>
        <div class="stat-info">
          <div class="stat-value">{{ stats.totalClothing }}</div>
          <div class="stat-label">衣物总数</div>
        </div>
      </div>
      <div class="stat-card card">
        <div class="stat-icon">💃</div>
        <div class="stat-info">
          <div class="stat-value">{{ stats.totalOutfits }}</div>
          <div class="stat-label">穿搭方案</div>
        </div>
      </div>
      <div class="stat-card card">
        <div class="stat-icon">✈️</div>
        <div class="stat-info">
          <div class="stat-value">{{ stats.totalTravelPlans }}</div>
          <div class="stat-label">旅行计划</div>
        </div>
      </div>
    </div>

    <!-- System Health Dashboard -->
    <div class="health-dashboard card">
      <h3>🏥 系统健康监控</h3>
      <div class="health-grid">
        <div class="health-item">
          <div class="health-icon">💚</div>
          <div class="health-info">
            <div class="health-label">系统状态</div>
            <div class="health-status active">运行正常</div>
          </div>
        </div>
        <div class="health-item">
          <div class="health-icon">👥</div>
          <div class="health-info">
            <div class="health-label">活跃用户率</div>
            <div class="health-value">{{ calculateActiveUserRate() }}%</div>
          </div>
        </div>
        <div class="health-item">
          <div class="health-icon">📊</div>
          <div class="health-info">
            <div class="health-label">平均衣物数/用户</div>
            <div class="health-value">{{ calculateAvgClothingPerUser() }}</div>
          </div>
        </div>
        <div class="health-item">
          <div class="health-icon">⚡</div>
          <div class="health-info">
            <div class="health-label">系统评分</div>
            <div class="health-value">{{ calculateSystemScore() }}/100</div>
          </div>
        </div>
      </div>
    </div>

    <!-- Growth Statistics -->
    <div class="growth-stats card">
      <h3>📈 增长统计</h3>
      <div class="growth-grid">
        <div class="growth-item">
          <div class="growth-label">7天新增用户</div>
          <div class="growth-value">{{ growthStats.newUsersLast7Days || 0 }}</div>
        </div>
        <div class="growth-item">
          <div class="growth-label">30天新增用户</div>
          <div class="growth-value">{{ growthStats.newUsersLast30Days || 0 }}</div>
        </div>
        <div class="growth-item">
          <div class="growth-label">7天活动数</div>
          <div class="growth-value">{{ growthStats.activitiesLast7Days || 0 }}</div>
        </div>
        <div class="growth-item">
          <div class="growth-label">30天活动数</div>
          <div class="growth-value">{{ growthStats.activitiesLast30Days || 0 }}</div>
        </div>
      </div>
    </div>

    <!-- Charts -->
    <div class="charts-grid">
      <div class="chart-card card">
        <h3>衣物类别分布</h3>
        <canvas ref="categoryChart"></canvas>
      </div>
      <div class="chart-card card">
        <h3>衣物颜色分布</h3>
        <canvas ref="colorChart"></canvas>
      </div>
      <div class="chart-card card">
        <h3>季节分布</h3>
        <canvas ref="seasonChart"></canvas>
      </div>
    </div>

    <!-- Activity Logs -->
    <div class="activity-logs card">
      <div class="section-header">
        <h3>📋 最近活动日志</h3>
        <button @click="loadActivityLogs" class="btn btn-secondary">
          🔄 刷新日志
        </button>
      </div>
      <div v-if="loadingLogs" class="loading">加载中...</div>
      <div v-else-if="activityLogs.length === 0" class="empty-state">暂无活动记录</div>
      <div v-else class="logs-list">
        <div v-for="log in activityLogs.slice(0, 20)" :key="log.id" class="log-item">
          <div class="log-icon">📝</div>
          <div class="log-content">
            <div class="log-header">
              <span class="log-username">{{ log.username }}</span>
              <span class="log-action">{{ log.action }}</span>
            </div>
            <div class="log-description">{{ log.description }}</div>
            <div class="log-time">{{ formatDateTime(log.createdAt) }}</div>
          </div>
        </div>
      </div>
    </div>

    <!-- User Management -->
    <div class="users-section card">
      <div class="section-header">
        <h3>用户管理</h3>
        <div class="header-actions">
          <button @click="exportUsersToCSV" class="btn btn-secondary">
            📥 导出用户数据
          </button>
        </div>
      </div>
      
      <!-- Search and Filter -->
      <div class="search-filter-bar">
        <div class="search-box">
          <input 
            v-model="userSearchQuery" 
            type="text" 
            placeholder="🔍 搜索用户名或邮箱..." 
            class="form-input"
            @input="filterUsers"
          />
        </div>
        <div class="filter-group">
          <select v-model="roleFilter" @change="filterUsers" class="form-select">
            <option value="all">全部角色</option>
            <option value="admin">仅管理员</option>
            <option value="user">仅普通用户</option>
          </select>
          <select v-model="sortBy" @change="sortUsers" class="form-select">
            <option value="id">按ID排序</option>
            <option value="username">按用户名排序</option>
            <option value="createdAt">按注册时间排序</option>
            <option value="clothingCount">按衣物数量排序</option>
          </select>
        </div>
      </div>
      
      <div v-if="loadingUsers" class="loading">加载中...</div>
      <div v-else-if="filteredUsers.length === 0" class="empty-state">
        {{ userSearchQuery || roleFilter !== 'all' ? '未找到匹配的用户' : '暂无用户' }}
      </div>
      <div v-else class="users-table">
        <table>
          <thead>
            <tr>
              <th>ID</th>
              <th>用户名</th>
              <th>邮箱</th>
              <th>角色</th>
              <th>注册时间</th>
              <th>衣物数</th>
              <th>穿搭数</th>
              <th>旅行数</th>
              <th>操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="user in filteredUsers" :key="user.id">
              <td>{{ user.id }}</td>
              <td>{{ user.username }}</td>
              <td>{{ user.email }}</td>
              <td>
                <span v-if="isUserAdmin(user)" class="role-badge admin">🔴 管理员</span>
                <span v-else class="role-badge user">🔵 用户</span>
              </td>
              <td>{{ formatDate(user.createdAt) }}</td>
              <td>{{ user.clothingCount }}</td>
              <td>{{ user.outfitCount }}</td>
              <td>{{ user.travelPlanCount }}</td>
              <td>
                <div class="action-buttons">
                  <button @click="viewUserDetails(user.id)" class="btn-icon" title="查看详情">👁️</button>
                  <button @click="toggleAdminRole(user)" class="btn-icon" title="切换管理员权限">
                    {{ isUserAdmin(user) ? '⬇️' : '⬆️' }}
                  </button>
                  <button @click="deleteUser(user.id)" class="btn-delete" title="删除用户">🗑️</button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- All Clothing Management -->
    <div class="clothing-section card">
      <div class="section-header">
        <h3>全部衣物管理</h3>
        <div class="header-actions">
          <button @click="exportClothingToCSV" class="btn btn-secondary">
            📥 导出衣物数据
          </button>
          <button @click="loadAllClothing" class="btn btn-secondary">
            🔄 刷新衣物列表
          </button>
        </div>
      </div>
      <div v-if="loadingClothing" class="loading">加载中...</div>
      <div v-else-if="allClothing.length === 0" class="empty-state">暂无衣物数据</div>
      <div v-else class="clothing-grid">
        <div v-for="item in allClothing.slice(0, 20)" :key="item.id" class="clothing-item">
          <div class="clothing-image">
            <img v-if="item.imageUrl" :src="item.imageUrl" :alt="item.name" />
            <div v-else class="no-image">👔</div>
          </div>
          <div class="clothing-details">
            <h4>{{ item.name }}</h4>
            <p class="clothing-meta">
              <span class="category-tag">{{ item.category }}</span>
              <span class="color-tag">{{ item.color }}</span>
            </p>
            <p class="clothing-owner">所属用户 ID: {{ item.userId }}</p>
          </div>
        </div>
      </div>
      <p v-if="allClothing.length > 20" class="show-more">
        显示前20条，共 {{ allClothing.length }} 条记录
      </p>
    </div>

    <!-- All Outfits Management -->
    <div class="outfits-section card">
      <div class="section-header">
        <h3>全部穿搭方案管理</h3>
        <div class="header-actions">
          <button @click="loadAllOutfits" class="btn btn-secondary">
            🔄 刷新穿搭列表
          </button>
        </div>
      </div>
      <div v-if="loadingOutfits" class="loading">加载中...</div>
      <div v-else-if="allOutfits.length === 0" class="empty-state">暂无穿搭方案数据</div>
      <div v-else class="data-table-container">
        <table class="data-table">
          <thead>
            <tr>
              <th>ID</th>
              <th>名称</th>
              <th>场合</th>
              <th>衣物数量</th>
              <th>所属用户</th>
              <th>创建时间</th>
              <th>操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="outfit in allOutfits.slice(0, 20)" :key="outfit.id">
              <td>{{ outfit.id }}</td>
              <td>{{ outfit.name }}</td>
              <td>{{ outfit.occasion || '-' }}</td>
              <td>{{ outfit.clothingItems?.length || 0 }}</td>
              <td>{{ outfit.userId }}</td>
              <td>{{ formatDate(outfit.createdAt) }}</td>
              <td>
                <button @click="viewOutfitDetails(outfit)" class="btn-icon" title="查看详情">👁️</button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <p v-if="allOutfits.length > 20" class="show-more">
        显示前20条，共 {{ allOutfits.length }} 条记录
      </p>
    </div>

    <!-- All Travel Plans Management -->
    <div class="travel-section card">
      <div class="section-header">
        <h3>全部旅行计划管理</h3>
        <div class="header-actions">
          <button @click="loadAllTravelPlans" class="btn btn-secondary">
            🔄 刷新旅行列表
          </button>
        </div>
      </div>
      <div v-if="loadingTravelPlans" class="loading">加载中...</div>
      <div v-else-if="allTravelPlans.length === 0" class="empty-state">暂无旅行计划数据</div>
      <div v-else class="data-table-container">
        <table class="data-table">
          <thead>
            <tr>
              <th>ID</th>
              <th>名称</th>
              <th>目的地</th>
              <th>日期</th>
              <th>类型</th>
              <th>衣物数量</th>
              <th>所属用户</th>
              <th>操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="plan in allTravelPlans.slice(0, 20)" :key="plan.id">
              <td>{{ plan.id }}</td>
              <td>{{ plan.name }}</td>
              <td>{{ plan.destination }}</td>
              <td>{{ formatDate(plan.startDate) }} - {{ formatDate(plan.endDate) }}</td>
              <td>{{ plan.travelType || '-' }}</td>
              <td>{{ plan.clothingItems?.length || 0 }}</td>
              <td>{{ plan.userId }}</td>
              <td>
                <button @click="viewTravelPlanDetails(plan)" class="btn-icon" title="查看详情">👁️</button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <p v-if="allTravelPlans.length > 20" class="show-more">
        显示前20条，共 {{ allTravelPlans.length }} 条记录
      </p>
    </div>

    <!-- User Details Modal -->
    <div v-if="showDetailsModal" class="modal" @click.self="closeDetailsModal">
      <div class="modal-content">
        <button @click="closeDetailsModal" class="modal-close">✕</button>
        <h3>用户详细信息</h3>
        <div v-if="selectedUserDetails" class="user-details">
          <div class="detail-row">
            <span class="detail-label">用户名：</span>
            <span class="detail-value">{{ selectedUserDetails.username }}</span>
          </div>
          <div class="detail-row">
            <span class="detail-label">邮箱：</span>
            <span class="detail-value">{{ selectedUserDetails.email }}</span>
          </div>
          <div class="detail-row">
            <span class="detail-label">注册时间：</span>
            <span class="detail-value">{{ formatDate(selectedUserDetails.createdAt) }}</span>
          </div>
          <div class="detail-row">
            <span class="detail-label">衣物数量：</span>
            <span class="detail-value">{{ selectedUserDetails.clothingCount }}</span>
          </div>
          <div class="detail-row">
            <span class="detail-label">穿搭方案：</span>
            <span class="detail-value">{{ selectedUserDetails.outfitCount }}</span>
          </div>
          <div class="detail-row">
            <span class="detail-label">旅行计划：</span>
            <span class="detail-value">{{ selectedUserDetails.travelPlanCount }}</span>
          </div>
          <button @click="viewUserClothing(selectedUserDetails.id)" class="btn btn-primary">
            查看该用户的所有衣物
          </button>
        </div>
      </div>
    </div>

    <!-- User Clothing Modal -->
    <div v-if="showUserClothingModal" class="modal" @click.self="closeUserClothingModal">
      <div class="modal-content large">
        <button @click="closeUserClothingModal" class="modal-close">✕</button>
        <h3>用户衣物列表</h3>
        <div v-if="userClothing.length === 0" class="empty-state">该用户暂无衣物</div>
        <div v-else class="clothing-grid">
          <div v-for="item in userClothing" :key="item.id" class="clothing-item">
            <div class="clothing-image">
              <img v-if="item.imageUrl" :src="item.imageUrl" :alt="item.name" />
              <div v-else class="no-image">👔</div>
            </div>
            <div class="clothing-details">
              <h4>{{ item.name }}</h4>
              <p class="clothing-meta">
                <span class="category-tag">{{ item.category }}</span>
                <span class="color-tag">{{ item.color }}</span>
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Outfit Details Modal -->
    <div v-if="showOutfitDetailsModal" class="modal" @click.self="closeOutfitDetailsModal">
      <div class="modal-content large">
        <button @click="closeOutfitDetailsModal" class="modal-close">✕</button>
        <h3>穿搭方案详情</h3>
        <div v-if="selectedOutfit" class="details-section">
          <div class="detail-row">
            <span class="detail-label">名称：</span>
            <span class="detail-value">{{ selectedOutfit.name }}</span>
          </div>
          <div class="detail-row" v-if="selectedOutfit.occasion">
            <span class="detail-label">场合：</span>
            <span class="detail-value">{{ selectedOutfit.occasion }}</span>
          </div>
          <div class="detail-row" v-if="selectedOutfit.notes">
            <span class="detail-label">备注：</span>
            <span class="detail-value">{{ selectedOutfit.notes }}</span>
          </div>
          <div class="detail-row">
            <span class="detail-label">创建时间：</span>
            <span class="detail-value">{{ formatDateTime(selectedOutfit.createdAt) }}</span>
          </div>
          <h4 class="section-title">关联的衣物 ({{ selectedOutfit.clothingItems?.length || 0 }}件)</h4>
          <div v-if="!selectedOutfit.clothingItems || selectedOutfit.clothingItems.length === 0" class="empty-state">
            该穿搭方案暂无关联衣物
          </div>
          <div v-else class="clothing-grid">
            <div v-for="item in selectedOutfit.clothingItems" :key="item.id" class="clothing-item">
              <div class="clothing-image">
                <img v-if="item.imageUrl" :src="item.imageUrl" :alt="item.name" />
                <div v-else class="no-image">👔</div>
              </div>
              <div class="clothing-details">
                <h4>{{ item.name }}</h4>
                <p class="clothing-meta">
                  <span class="category-tag">{{ item.category }}</span>
                  <span class="color-tag">{{ item.color }}</span>
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Travel Plan Details Modal -->
    <div v-if="showTravelPlanDetailsModal" class="modal" @click.self="closeTravelPlanDetailsModal">
      <div class="modal-content large">
        <button @click="closeTravelPlanDetailsModal" class="modal-close">✕</button>
        <h3>旅行计划详情</h3>
        <div v-if="selectedTravelPlan" class="details-section">
          <div class="detail-row">
            <span class="detail-label">名称：</span>
            <span class="detail-value">{{ selectedTravelPlan.name }}</span>
          </div>
          <div class="detail-row">
            <span class="detail-label">目的地：</span>
            <span class="detail-value">{{ selectedTravelPlan.destination }}</span>
          </div>
          <div class="detail-row">
            <span class="detail-label">出发日期：</span>
            <span class="detail-value">{{ formatDate(selectedTravelPlan.startDate) }}</span>
          </div>
          <div class="detail-row">
            <span class="detail-label">返程日期：</span>
            <span class="detail-value">{{ formatDate(selectedTravelPlan.endDate) }}</span>
          </div>
          <div class="detail-row" v-if="selectedTravelPlan.travelType">
            <span class="detail-label">旅行类型：</span>
            <span class="detail-value">{{ selectedTravelPlan.travelType }}</span>
          </div>
          <div class="detail-row" v-if="selectedTravelPlan.notes">
            <span class="detail-label">备注：</span>
            <span class="detail-value">{{ selectedTravelPlan.notes }}</span>
          </div>
          <div class="detail-row">
            <span class="detail-label">创建时间：</span>
            <span class="detail-value">{{ formatDateTime(selectedTravelPlan.createdAt) }}</span>
          </div>
          <h4 class="section-title">打包的衣物 ({{ selectedTravelPlan.clothingItems?.length || 0 }}件)</h4>
          <div v-if="!selectedTravelPlan.clothingItems || selectedTravelPlan.clothingItems.length === 0" class="empty-state">
            该旅行计划暂无打包衣物
          </div>
          <div v-else class="clothing-grid">
            <div v-for="item in selectedTravelPlan.clothingItems" :key="item.id" class="clothing-item">
              <div class="clothing-image">
                <img v-if="item.imageUrl" :src="item.imageUrl" :alt="item.name" />
                <div v-else class="no-image">👔</div>
              </div>
              <div class="clothing-details">
                <h4>{{ item.name }}</h4>
                <p class="clothing-meta">
                  <span class="category-tag">{{ item.category }}</span>
                  <span class="color-tag">{{ item.color }}</span>
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from '../api/axios'
import { Chart, registerables } from 'chart.js'
import { formatDate, formatDateTime } from '../utils/dateFormatter'

Chart.register(...registerables)

export default {
  name: 'Admin',
  data() {
    return {
      stats: {
        totalUsers: 0,
        totalClothing: 0,
        totalOutfits: 0,
        totalTravelPlans: 0,
        clothingByCategory: {},
        clothingByColor: {},
        clothingBySeason: {}
      },
      users: [],
      filteredUsers: [],
      loadingUsers: false,
      allClothing: [],
      loadingClothing: false,
      allOutfits: [],
      loadingOutfits: false,
      allTravelPlans: [],
      loadingTravelPlans: false,
      showDetailsModal: false,
      showUserClothingModal: false,
      showOutfitDetailsModal: false,
      showTravelPlanDetailsModal: false,
      showUserModal: false,
      selectedUserDetails: null,
      userClothing: [],
      selectedOutfit: null,
      selectedTravelPlan: null,
      charts: {
        category: null,
        color: null,
        season: null
      },
      // Search and filter
      userSearchQuery: '',
      roleFilter: 'all',
      sortBy: 'id',
      // Activity logs
      activityLogs: [],
      loadingLogs: false,
      // Growth stats
      growthStats: {
        newUsersLast7Days: 0,
        newUsersLast30Days: 0,
        activitiesLast7Days: 0,
        activitiesLast30Days: 0
      },
      isRefreshing: false
    }
  },
  mounted() {
    this.loadStats()
    this.loadUsers()
    this.loadAllClothing()
    this.loadAllOutfits()
    this.loadAllTravelPlans()
    this.loadActivityLogs()
    this.loadGrowthStats()
  },
  beforeUnmount() {
    // Destroy charts to prevent memory leaks
    Object.values(this.charts).forEach(chart => {
      if (chart) chart.destroy()
    })
  },
  methods: {
    async loadStats() {
      try {
        const response = await axios.get('/admin/stats')
        this.stats = response.data
        this.$nextTick(() => {
          this.renderCharts()
        })
      } catch (error) {
        console.error('Failed to load stats:', error)
        alert('加载统计数据失败')
      }
    },
    
    async loadUsers() {
      this.loadingUsers = true
      try {
        const response = await axios.get('/admin/users')
        this.users = response.data
        this.filterUsers()
      } catch (error) {
        console.error('Failed to load users:', error)
        alert('加载用户列表失败')
      } finally {
        this.loadingUsers = false
      }
    },

    filterUsers() {
      let filtered = [...this.users]
      
      // Search filter
      if (this.userSearchQuery) {
        const query = this.userSearchQuery.toLowerCase()
        filtered = filtered.filter(user => 
          user.username.toLowerCase().includes(query) ||
          user.email.toLowerCase().includes(query)
        )
      }
      
      // Role filter
      if (this.roleFilter === 'admin') {
        filtered = filtered.filter(user => this.isUserAdmin(user))
      } else if (this.roleFilter === 'user') {
        filtered = filtered.filter(user => !this.isUserAdmin(user))
      }
      
      this.filteredUsers = filtered
      this.sortUsers()
    },

    sortUsers() {
      const sorted = [...this.filteredUsers]
      
      switch(this.sortBy) {
        case 'username':
          sorted.sort((a, b) => a.username.localeCompare(b.username))
          break
        case 'createdAt':
          sorted.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt))
          break
        case 'clothingCount':
          sorted.sort((a, b) => b.clothingCount - a.clothingCount)
          break
        case 'id':
        default:
          sorted.sort((a, b) => a.id - b.id)
          break
      }
      
      this.filteredUsers = sorted
    },

    downloadCSV(header, rows, filename) {
      // Build CSV content
      const csvContent = [
        header.join(','),
        ...rows.map(row => row.map(cell => `"${cell}"`).join(','))
      ].join('\n')
      
      // Create download link
      const blob = new Blob(['\uFEFF' + csvContent], { type: 'text/csv;charset=utf-8;' })
      const link = document.createElement('a')
      const url = URL.createObjectURL(blob)
      
      link.setAttribute('href', url)
      link.setAttribute('download', filename)
      link.style.visibility = 'hidden'
      
      document.body.appendChild(link)
      link.click()
      document.body.removeChild(link)
    },

    exportUsersToCSV() {
      if (this.filteredUsers.length === 0) {
        alert('没有数据可以导出')
        return
      }

      const header = ['ID', '用户名', '邮箱', '角色', '注册时间', '衣物数', '穿搭数', '旅行计划数']
      const rows = this.filteredUsers.map(user => [
        user.id,
        user.username,
        user.email,
        this.isUserAdmin(user) ? '管理员' : '用户',
        this.formatDate(user.createdAt),
        user.clothingCount,
        user.outfitCount,
        user.travelPlanCount
      ])
      
      const filename = `用户数据_${new Date().toISOString().split('T')[0]}.csv`
      this.downloadCSV(header, rows, filename)
      alert('用户数据已导出')
    },
    
    async deleteUser(userId) {
      if (!confirm('确定要删除该用户吗？此操作不可恢复！')) {
        return
      }
      
      try {
        await axios.delete(`/admin/users/${userId}`)
        this.loadUsers()
        this.loadStats()
        alert('用户已删除')
      } catch (error) {
        console.error('Failed to delete user:', error)
        alert('删除用户失败: ' + (error.response?.data || '未知错误'))
      }
    },

    async loadAllClothing() {
      this.loadingClothing = true
      try {
        const response = await axios.get('/admin/clothing')
        this.allClothing = response.data
      } catch (error) {
        console.error('Failed to load clothing:', error)
        alert('加载衣物数据失败')
      } finally {
        this.loadingClothing = false
      }
    },

    async loadAllOutfits() {
      this.loadingOutfits = true
      try {
        const response = await axios.get('/admin/outfits')
        this.allOutfits = response.data
      } catch (error) {
        console.error('Failed to load outfits:', error)
        alert('加载穿搭数据失败')
      } finally {
        this.loadingOutfits = false
      }
    },

    async loadAllTravelPlans() {
      this.loadingTravelPlans = true
      try {
        const response = await axios.get('/admin/travel-plans')
        this.allTravelPlans = response.data
      } catch (error) {
        console.error('Failed to load travel plans:', error)
        alert('加载旅行计划数据失败')
      } finally {
        this.loadingTravelPlans = false
      }
    },

    async viewUserDetails(userId) {
      try {
        const response = await axios.get(`/admin/users/${userId}/details`)
        this.selectedUserDetails = response.data
        this.showDetailsModal = true
      } catch (error) {
        console.error('Failed to load user details:', error)
        alert('加载用户详情失败')
      }
    },

    async viewUserClothing(userId) {
      try {
        const response = await axios.get(`/admin/users/${userId}/clothing`)
        this.userClothing = response.data
        this.showUserClothingModal = true
        this.showDetailsModal = false
      } catch (error) {
        console.error('Failed to load user clothing:', error)
        alert('加载用户衣物失败')
      }
    },

    async toggleAdminRole(user) {
      const isAdmin = this.isUserAdmin(user)
      const action = isAdmin ? 'remove' : 'add'
      const confirmMessage = isAdmin 
        ? `确定要移除 ${user.username} 的管理员权限吗？`
        : `确定要授予 ${user.username} 管理员权限吗？`

      if (!confirm(confirmMessage)) {
        return
      }

      try {
        await axios.put(`/admin/users/${user.id}/role`, {
          action: action,
          role: 'ROLE_ADMIN'
        })
        this.loadUsers()
        alert(isAdmin ? '管理员权限已移除' : '管理员权限已授予')
      } catch (error) {
        console.error('Failed to update user role:', error)
        alert('更新用户角色失败: ' + (error.response?.data || '未知错误'))
      }
    },

    isUserAdmin(user) {
      // Check if user response has roles field (from backend)
      return user.roles && user.roles.includes('ROLE_ADMIN')
    },

    closeDetailsModal() {
      this.showDetailsModal = false
      this.selectedUserDetails = null
    },

    closeUserClothingModal() {
      this.showUserClothingModal = false
      this.userClothing = []
    },

    async viewOutfitDetails(outfit) {
      try {
        const response = await axios.get(`/admin/outfits/${outfit.id}`)
        this.selectedOutfit = response.data
        this.showOutfitDetailsModal = true
      } catch (error) {
        console.error('Failed to load outfit details:', error)
        alert('加载穿搭详情失败')
      }
    },

    closeOutfitDetailsModal() {
      this.showOutfitDetailsModal = false
      this.selectedOutfit = null
    },

    async viewTravelPlanDetails(plan) {
      try {
        const response = await axios.get(`/admin/travel-plans/${plan.id}`)
        this.selectedTravelPlan = response.data
        this.showTravelPlanDetailsModal = true
      } catch (error) {
        console.error('Failed to load travel plan details:', error)
        alert('加载旅行计划详情失败')
      }
    },

    closeTravelPlanDetailsModal() {
      this.showTravelPlanDetailsModal = false
      this.selectedTravelPlan = null
    },
    
    formatDate,
    formatDateTime,

    async loadActivityLogs() {
      this.loadingLogs = true
      try {
        const response = await axios.get('/admin/activity-logs')
        this.activityLogs = response.data
      } catch (error) {
        console.error('Failed to load activity logs:', error)
        this.activityLogs = []
      } finally {
        this.loadingLogs = false
      }
    },

    async loadGrowthStats() {
      try {
        const response = await axios.get('/admin/stats/growth')
        this.growthStats = response.data
      } catch (error) {
        console.error('Failed to load growth stats:', error)
      }
    },

    exportClothingToCSV() {
      if (this.allClothing.length === 0) {
        alert('没有衣物数据可以导出')
        return
      }

      const header = ['ID', '名称', '类别', '颜色', '季节', '品牌', '价格', '尺寸', '所属用户ID']
      const rows = this.allClothing.map(item => [
        item.id,
        item.name,
        item.category || '',
        item.color || '',
        item.season || '',
        item.brand || '',
        item.price || '',
        item.size || '',
        item.userId
      ])
      
      const filename = `衣物数据_${new Date().toISOString().split('T')[0]}.csv`
      this.downloadCSV(header, rows, filename)
      alert('衣物数据已导出')
    },

    calculateActiveUserRate() {
      if (this.users.length === 0) return 0
      const activeUsers = this.users.filter(u => u.clothingCount > 0).length
      return Math.round((activeUsers / this.users.length) * 100)
    },

    calculateAvgClothingPerUser() {
      if (this.stats.totalUsers === 0) return 0
      return Math.round(this.stats.totalClothing / this.stats.totalUsers)
    },

    calculateSystemScore() {
      // Simple scoring based on various metrics
      let score = 60 // Base score
      
      // Add points for active users
      const activeRate = this.calculateActiveUserRate()
      score += Math.min(activeRate / 5, 20)
      
      // Add points for user engagement
      const avgClothing = this.calculateAvgClothingPerUser()
      score += Math.min(avgClothing, 10)
      
      // Add points for growth
      if (this.growthStats.newUsersLast7Days > 0) score += 5
      if (this.growthStats.activitiesLast7Days > 10) score += 5
      
      return Math.min(Math.round(score), 100)
    },

    async refreshAllData() {
      if (this.isRefreshing) return
      
      this.isRefreshing = true
      try {
        await Promise.all([
          this.loadStats(),
          this.loadUsers(),
          this.loadAllClothing(),
          this.loadAllOutfits(),
          this.loadAllTravelPlans(),
          this.loadActivityLogs(),
          this.loadGrowthStats()
        ])
        alert('✅ 所有数据已刷新')
      } catch (error) {
        console.error('Failed to refresh data:', error)
        alert('❌ 刷新失败，请重试')
      } finally {
        this.isRefreshing = false
      }
    },
    
    renderCharts() {
      this.renderCategoryChart()
      this.renderColorChart()
      this.renderSeasonChart()
    },
    
    renderCategoryChart() {
      if (this.charts.category) this.charts.category.destroy()
      
      const ctx = this.$refs.categoryChart
      if (!ctx) return
      
      const data = this.stats.clothingByCategory || {}
      
      this.charts.category = new Chart(ctx, {
        type: 'doughnut',
        data: {
          labels: Object.keys(data),
          datasets: [{
            data: Object.values(data),
            backgroundColor: [
              '#B8A398',
              '#D4C4B7',
              '#9D8B7F',
              '#C9B8A8',
              '#A8998A',
              '#E3D9CE'
            ]
          }]
        },
        options: {
          responsive: true,
          maintainAspectRatio: true,
          plugins: {
            legend: {
              position: 'bottom'
            }
          }
        }
      })
    },
    
    renderColorChart() {
      if (this.charts.color) this.charts.color.destroy()
      
      const ctx = this.$refs.colorChart
      if (!ctx) return
      
      const data = this.stats.clothingByColor || {}
      const sortedData = Object.entries(data)
        .sort((a, b) => b[1] - a[1])
        .slice(0, 10) // Top 10 colors
      
      this.charts.color = new Chart(ctx, {
        type: 'bar',
        data: {
          labels: sortedData.map(([key]) => key),
          datasets: [{
            label: '数量',
            data: sortedData.map(([, value]) => value),
            backgroundColor: '#B8A398'
          }]
        },
        options: {
          responsive: true,
          maintainAspectRatio: true,
          plugins: {
            legend: {
              display: false
            }
          },
          scales: {
            y: {
              beginAtZero: true,
              ticks: {
                stepSize: 1
              }
            }
          }
        }
      })
    },
    
    renderSeasonChart() {
      if (this.charts.season) this.charts.season.destroy()
      
      const ctx = this.$refs.seasonChart
      if (!ctx) return
      
      const data = this.stats.clothingBySeason || {}
      
      this.charts.season = new Chart(ctx, {
        type: 'pie',
        data: {
          labels: Object.keys(data),
          datasets: [{
            data: Object.values(data),
            backgroundColor: [
              '#A8B5A0',
              '#D4B896',
              '#C4A090',
              '#B8A398',
              '#C9B8A8'
            ]
          }]
        },
        options: {
          responsive: true,
          maintainAspectRatio: true,
          plugins: {
            legend: {
              position: 'bottom'
            }
          }
        }
      })
    }
  }
}
</script>

<style scoped>
.page-header {
  margin-bottom: 2rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  gap: 1rem;
}

.page-title {
  font-size: 2rem;
  color: var(--text-primary);
}

.quick-actions {
  display: flex;
  gap: 0.5rem;
}

.btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1.5rem;
  margin-bottom: 2rem;
}

.stat-card {
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 1.5rem;
}

.stat-icon {
  font-size: 3rem;
}

.stat-info {
  flex: 1;
}

.stat-value {
  font-size: 2rem;
  font-weight: 700;
  color: var(--primary-color);
  line-height: 1;
}

.stat-label {
  font-size: 0.9rem;
  color: var(--text-secondary);
  margin-top: 0.25rem;
}

.charts-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 1.5rem;
  margin-bottom: 2rem;
}

.chart-card {
  padding: 1.5rem;
}

.chart-card h3 {
  margin-bottom: 1rem;
  color: var(--text-primary);
  font-size: 1.1rem;
}

.chart-card canvas {
  max-height: 300px;
}

.users-section {
  padding: 1.5rem;
}

.users-section h3 {
  margin-bottom: 1.5rem;
  color: var(--text-primary);
}

.users-table {
  overflow-x: auto;
}

table {
  width: 100%;
  border-collapse: collapse;
}

thead {
  background-color: var(--background);
}

th {
  padding: 1rem;
  text-align: left;
  font-weight: 600;
  color: var(--text-primary);
  border-bottom: 2px solid var(--border-color);
}

td {
  padding: 1rem;
  border-bottom: 1px solid var(--border-color);
  color: var(--text-primary);
}

tbody tr:hover {
  background-color: var(--background);
}

.btn-delete {
  padding: 0.5rem 1rem;
  background-color: var(--danger);
  color: white;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  font-size: 0.9rem;
  transition: opacity 0.2s;
}

.btn-delete:hover {
  opacity: 0.8;
}

.loading,
.empty-state {
  text-align: center;
  padding: 2rem;
  color: var(--text-secondary);
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1rem;
}

.section-header h3 {
  margin: 0;
  color: var(--text-primary);
}

.header-actions {
  display: flex;
  gap: 0.5rem;
}

.search-filter-bar {
  display: flex;
  gap: 1rem;
  margin-bottom: 1.5rem;
  flex-wrap: wrap;
}

.search-box {
  flex: 1;
  min-width: 250px;
}

.filter-group {
  display: flex;
  gap: 0.5rem;
  flex-wrap: wrap;
}

.form-select {
  padding: 0.75rem 1rem;
  border: 2px solid var(--border-color);
  border-radius: 8px;
  background-color: white;
  color: var(--text-primary);
  font-size: 0.9rem;
  cursor: pointer;
  transition: all 0.2s;
}

.form-select:hover {
  border-color: var(--primary-color);
}

.form-select:focus {
  outline: none;
  border-color: var(--primary-color);
  box-shadow: 0 0 0 3px rgba(184, 163, 152, 0.1);
}

.role-badge {
  display: inline-block;
  padding: 0.25rem 0.75rem;
  border-radius: 12px;
  font-size: 0.85rem;
  font-weight: 500;
}

.role-badge.admin {
  background-color: #FFE5E5;
  color: #C4A090;
}

.role-badge.user {
  background-color: #E8F4F8;
  color: #7A6F63;
}

.action-buttons {
  display: flex;
  gap: 0.5rem;
  align-items: center;
}

.btn-icon {
  padding: 0.5rem;
  background: transparent;
  border: 1px solid var(--border-color);
  border-radius: 6px;
  cursor: pointer;
  font-size: 1.2rem;
  transition: all 0.2s;
}

.btn-icon:hover {
  background-color: var(--background);
  border-color: var(--primary-color);
}

.clothing-section {
  padding: 1.5rem;
  margin-top: 2rem;
}

.clothing-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  gap: 1.5rem;
  margin-top: 1rem;
}

.clothing-item {
  background: var(--background);
  border-radius: 12px;
  overflow: hidden;
  transition: transform 0.2s, box-shadow 0.2s;
}

.clothing-item:hover {
  transform: translateY(-4px);
  box-shadow: var(--shadow-hover);
}

.clothing-image {
  width: 100%;
  height: 150px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: white;
  overflow: hidden;
}

.clothing-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.no-image {
  font-size: 3rem;
  color: var(--text-secondary);
}

.clothing-details {
  padding: 1rem;
}

.clothing-details h4 {
  margin: 0 0 0.5rem 0;
  color: var(--text-primary);
  font-size: 1rem;
}

.clothing-meta {
  display: flex;
  gap: 0.5rem;
  flex-wrap: wrap;
  margin-bottom: 0.5rem;
}

.category-tag,
.color-tag {
  padding: 0.25rem 0.5rem;
  border-radius: 6px;
  font-size: 0.75rem;
  background-color: var(--primary-light);
  color: var(--text-primary);
}

.clothing-owner {
  font-size: 0.8rem;
  color: var(--text-secondary);
  margin: 0;
}

.show-more {
  text-align: center;
  margin-top: 1rem;
  color: var(--text-secondary);
  font-size: 0.9rem;
}

.modal {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  padding: 1rem;
}

.modal-content {
  background: white;
  border-radius: 20px;
  padding: 2rem;
  max-width: 500px;
  width: 100%;
  max-height: 80vh;
  overflow-y: auto;
  position: relative;
}

.modal-content.large {
  max-width: 900px;
}

.modal-close {
  position: absolute;
  top: 1rem;
  right: 1rem;
  background: none;
  border: none;
  font-size: 1.5rem;
  cursor: pointer;
  color: var(--text-secondary);
  padding: 0.5rem;
  line-height: 1;
}

.modal-close:hover {
  color: var(--text-primary);
}

.modal-content h3 {
  margin-top: 0;
  margin-bottom: 1.5rem;
  color: var(--text-primary);
}

.user-details {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.detail-row {
  display: flex;
  justify-content: space-between;
  padding: 0.75rem;
  background: var(--background);
  border-radius: 8px;
}

.detail-label {
  font-weight: 600;
  color: var(--text-primary);
}

.detail-value {
  color: var(--text-secondary);
}

.btn {
  padding: 0.75rem 1.5rem;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-size: 1rem;
  transition: all 0.2s;
  margin-top: 1rem;
}

.btn-primary {
  background-color: var(--primary-color);
  color: white;
}

.btn-primary:hover {
  background-color: var(--primary-dark);
}

.btn-secondary {
  background-color: var(--secondary-color);
  color: white;
}

.btn-secondary:hover {
  opacity: 0.9;
}

.health-dashboard {
  padding: 1.5rem;
  margin-bottom: 2rem;
}

.health-dashboard h3 {
  margin-bottom: 1rem;
  color: var(--text-primary);
}

.health-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
  gap: 1rem;
}

.health-item {
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 1rem;
  background: var(--background);
  border-radius: 10px;
  transition: all 0.2s;
}

.health-item:hover {
  transform: translateY(-2px);
  box-shadow: var(--shadow);
}

.health-icon {
  font-size: 2rem;
  flex-shrink: 0;
}

.health-info {
  flex: 1;
}

.health-label {
  font-size: 0.85rem;
  color: var(--text-secondary);
  margin-bottom: 0.25rem;
}

.health-status {
  font-weight: 600;
  color: var(--success);
  font-size: 1rem;
}

.health-status.active {
  color: #5FA35F;
}

.health-value {
  font-size: 1.5rem;
  font-weight: 700;
  color: var(--primary-color);
}

.growth-stats {
  padding: 1.5rem;
  margin-bottom: 2rem;
}

.growth-stats h3 {
  margin-bottom: 1rem;
  color: var(--text-primary);
}

.growth-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1rem;
}

.growth-item {
  padding: 1rem;
  background: var(--background);
  border-radius: 10px;
  text-align: center;
}

.growth-label {
  font-size: 0.9rem;
  color: var(--text-secondary);
  margin-bottom: 0.5rem;
}

.growth-value {
  font-size: 2rem;
  font-weight: 700;
  color: var(--primary-color);
}

.activity-logs {
  padding: 1.5rem;
  margin-top: 2rem;
}

.activity-logs h3 {
  margin-bottom: 1rem;
  color: var(--text-primary);
}

.logs-list {
  display: flex;
  flex-direction: column;
  gap: 1rem;
  max-height: 600px;
  overflow-y: auto;
}

.log-item {
  display: flex;
  gap: 1rem;
  padding: 1rem;
  background: var(--background);
  border-radius: 10px;
  transition: all 0.2s;
}

.log-item:hover {
  background: var(--primary-light);
}

.log-icon {
  font-size: 1.5rem;
  flex-shrink: 0;
}

.log-content {
  flex: 1;
}

.log-header {
  display: flex;
  gap: 0.5rem;
  align-items: center;
  margin-bottom: 0.25rem;
}

.log-username {
  font-weight: 600;
  color: var(--text-primary);
}

.log-action {
  padding: 0.15rem 0.5rem;
  background: var(--primary-color);
  color: white;
  border-radius: 6px;
  font-size: 0.8rem;
}

.log-description {
  color: var(--text-secondary);
  font-size: 0.9rem;
  margin-bottom: 0.25rem;
}

.log-time {
  color: var(--text-secondary);
  font-size: 0.75rem;
}

@media (max-width: 768px) {
  .stats-grid {
    grid-template-columns: repeat(2, 1fr);
  }
  
  .charts-grid {
    grid-template-columns: 1fr;
  }
  
  .users-table {
    font-size: 0.85rem;
  }
  
  th, td {
    padding: 0.5rem;
  }

  .clothing-grid {
    grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
  }

  .section-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 1rem;
  }

  .action-buttons {
    flex-wrap: wrap;
  }

  .search-filter-bar {
    flex-direction: column;
  }

  .filter-group {
    width: 100%;
  }

  .form-select {
    width: 100%;
  }

  .growth-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

.outfits-section,
.travel-section {
  padding: 1.5rem;
  margin-top: 2rem;
}

.outfits-section h3,
.travel-section h3 {
  margin-bottom: 1rem;
  color: var(--text-primary);
}

.data-table-container {
  overflow-x: auto;
  margin-top: 1rem;
}

.data-table {
  width: 100%;
  border-collapse: collapse;
  background: white;
}

.data-table thead {
  background-color: var(--background);
}

.data-table th {
  padding: 1rem;
  text-align: left;
  font-weight: 600;
  color: var(--text-primary);
  border-bottom: 2px solid var(--border-color);
  white-space: nowrap;
}

.data-table td {
  padding: 1rem;
  border-bottom: 1px solid var(--border-color);
  color: var(--text-primary);
}

.data-table tbody tr:hover {
  background-color: var(--background);
}

.details-section {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.details-section h4 {
  color: var(--text-primary);
  font-size: 1.1rem;
}

.section-title {
  margin-top: 1.5rem;
  margin-bottom: 1rem;
  color: var(--text-primary);
  font-size: 1.1rem;
}
</style>
