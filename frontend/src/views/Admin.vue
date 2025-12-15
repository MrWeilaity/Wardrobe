<template>
  <div class="admin-page">
    <div class="page-header">
      <h2 class="page-title">管理员控制面板</h2>
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

    <!-- User Management -->
    <div class="users-section card">
      <div class="section-header">
        <h3>用户管理</h3>
        <button @click="showUserModal = true" class="btn btn-primary">
          ➕ 添加管理员权限
        </button>
      </div>
      <div v-if="loadingUsers" class="loading">加载中...</div>
      <div v-else-if="users.length === 0" class="empty-state">暂无用户</div>
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
            <tr v-for="user in users" :key="user.id">
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
        <button @click="loadAllClothing" class="btn btn-secondary">
          🔄 刷新衣物列表
        </button>
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
  </div>
</template>

<script>
import axios from '../api/axios'
import { Chart, registerables } from 'chart.js'

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
      loadingUsers: false,
      allClothing: [],
      loadingClothing: false,
      showDetailsModal: false,
      showUserClothingModal: false,
      showUserModal: false,
      selectedUserDetails: null,
      userClothing: [],
      charts: {
        category: null,
        color: null,
        season: null
      }
    }
  },
  mounted() {
    this.loadStats()
    this.loadUsers()
    this.loadAllClothing()
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
      } catch (error) {
        console.error('Failed to load users:', error)
        alert('加载用户列表失败')
      } finally {
        this.loadingUsers = false
      }
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
    
    formatDate(dateString) {
      if (!dateString) return ''
      const date = new Date(dateString)
      return date.toLocaleDateString('zh-CN')
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
}

.page-title {
  font-size: 2rem;
  color: var(--text-primary);
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
  margin-bottom: 1.5rem;
}

.section-header h3 {
  margin: 0;
  color: var(--text-primary);
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
}
</style>
