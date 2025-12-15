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
      <h3>用户管理</h3>
      <div v-if="loadingUsers" class="loading">加载中...</div>
      <div v-else-if="users.length === 0" class="empty-state">暂无用户</div>
      <div v-else class="users-table">
        <table>
          <thead>
            <tr>
              <th>ID</th>
              <th>用户名</th>
              <th>邮箱</th>
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
              <td>{{ formatDate(user.createdAt) }}</td>
              <td>{{ user.clothingCount }}</td>
              <td>{{ user.outfitCount }}</td>
              <td>{{ user.travelPlanCount }}</td>
              <td>
                <button @click="deleteUser(user.id)" class="btn-delete">删除</button>
              </td>
            </tr>
          </tbody>
        </table>
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
        alert('删除用户失败')
      }
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
}
</style>
