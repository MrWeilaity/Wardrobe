<template>
  <div class="travel-page">
    <div class="page-header">
      <h2 class="page-title">✈️ 旅行计划</h2>
      <button @click="showAddModal = true" class="btn btn-primary">
        ➕ 创建旅行
      </button>
    </div>
    
    <div v-if="loading" class="loading">加载中...</div>
    
    <div v-else-if="plans.length === 0" class="empty-state">
      <p>还没有旅行计划，创建您的第一个旅行清单吧！</p>
    </div>
    
    <div v-else class="grid grid-2">
      <div v-for="plan in plans" :key="plan.id" class="travel-card card">
        <h3>{{ plan.name }}</h3>
        <div class="travel-info">
          <p>📍 目的地：{{ plan.destination }}</p>
          <p>📅 {{ formatDate(plan.startDate) }} - {{ formatDate(plan.endDate) }}</p>
          <p v-if="plan.travelType">🎯 类型：{{ plan.travelType }}</p>
          <p>👔 衣物：{{ plan.clothingItems?.length || 0 }} 件</p>
        </div>
        <div class="travel-actions">
          <button @click="viewPlanDetails(plan.id)" class="btn btn-secondary">查看详情</button>
          <button @click="deletePlan(plan.id)" class="btn-icon">🗑️</button>
        </div>
      </div>
    </div>
    
    <!-- Add Modal -->
    <div v-if="showAddModal" class="modal" @click.self="closeModal">
      <div class="modal-content">
        <h3>创建旅行计划</h3>
        <form @submit.prevent="savePlan">
          <div class="form-group">
            <label class="form-label">旅行名称 *</label>
            <input v-model="form.name" type="text" class="form-input" required placeholder="例如：三亚之旅" />
          </div>
          
          <div class="form-group">
            <label class="form-label">目的地 *</label>
            <input v-model="form.destination" type="text" class="form-input" required />
          </div>
          
          <div class="form-group">
            <label class="form-label">出发日期 *</label>
            <input v-model="form.startDate" type="date" class="form-input" required />
          </div>
          
          <div class="form-group">
            <label class="form-label">返程日期 *</label>
            <input v-model="form.endDate" type="date" class="form-input" required />
          </div>
          
          <div class="form-group">
            <label class="form-label">旅行类型</label>
            <select v-model="form.travelType" class="form-select">
              <option value="">请选择</option>
              <option value="度假休闲">度假休闲</option>
              <option value="商务出差">商务出差</option>
              <option value="探险运动">探险运动</option>
              <option value="城市观光">城市观光</option>
            </select>
          </div>
          
          <div class="form-group">
            <label class="form-label">备注</label>
            <textarea v-model="form.notes" class="form-textarea"></textarea>
          </div>
          
          <div class="modal-actions">
            <button type="button" @click="closeModal" class="btn btn-secondary">取消</button>
            <button type="submit" class="btn btn-primary">保存</button>
          </div>
        </form>
      </div>
    </div>

    <!-- Details Modal -->
    <div v-if="showDetailsModal" class="modal" @click.self="closeDetailsModal">
      <div class="modal-content large-modal">
        <button @click="closeDetailsModal" class="modal-close">✕</button>
        <h3>旅行计划详情</h3>
        <div v-if="selectedPlan" class="details-section">
          <div class="detail-row">
            <span class="detail-label">名称：</span>
            <span class="detail-value">{{ selectedPlan.name }}</span>
          </div>
          <div class="detail-row">
            <span class="detail-label">目的地：</span>
            <span class="detail-value">{{ selectedPlan.destination }}</span>
          </div>
          <div class="detail-row">
            <span class="detail-label">出发日期：</span>
            <span class="detail-value">{{ formatDate(selectedPlan.startDate) }}</span>
          </div>
          <div class="detail-row">
            <span class="detail-label">返程日期：</span>
            <span class="detail-value">{{ formatDate(selectedPlan.endDate) }}</span>
          </div>
          <div class="detail-row" v-if="selectedPlan.travelType">
            <span class="detail-label">旅行类型：</span>
            <span class="detail-value">{{ selectedPlan.travelType }}</span>
          </div>
          <div class="detail-row" v-if="selectedPlan.notes">
            <span class="detail-label">备注：</span>
            <span class="detail-value">{{ selectedPlan.notes }}</span>
          </div>
          <div class="detail-row">
            <span class="detail-label">创建时间：</span>
            <span class="detail-value">{{ formatDateTime(selectedPlan.createdAt) }}</span>
          </div>
          <h4 class="section-title">打包的衣物 ({{ selectedPlan.clothingItems?.length || 0 }}件)</h4>
          <div v-if="!selectedPlan.clothingItems || selectedPlan.clothingItems.length === 0" class="empty-state">
            该旅行计划暂无打包衣物
          </div>
          <div v-else class="clothing-grid">
            <div v-for="item in selectedPlan.clothingItems" :key="item.id" class="clothing-card">
              <div class="clothing-image">
                <img v-if="item.imageUrl" :src="item.imageUrl" :alt="item.name" />
                <div v-else class="no-image">👔</div>
              </div>
              <div class="clothing-info">
                <h4>{{ item.name }}</h4>
                <p class="clothing-meta">
                  <span class="category-badge">{{ item.category }}</span>
                  <span class="color-badge">{{ item.color }}</span>
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
import { formatDate, formatDateTime } from '../utils/dateFormatter'

export default {
  name: 'TravelPlans',
  data() {
    return {
      plans: [],
      loading: false,
      showAddModal: false,
      showDetailsModal: false,
      selectedPlan: null,
      form: {
        name: '',
        destination: '',
        startDate: '',
        endDate: '',
        travelType: '',
        notes: '',
        clothingItems: []
      }
    }
  },
  mounted() {
    this.loadPlans()
  },
  methods: {
    async loadPlans() {
      this.loading = true
      try {
        const response = await axios.get('/travel-plans')
        this.plans = response.data
      } catch (error) {
        console.error('Failed to load travel plans:', error)
      } finally {
        this.loading = false
      }
    },
    
    async savePlan() {
      try {
        await axios.post('/travel-plans', this.form)
        this.closeModal()
        this.loadPlans()
      } catch (error) {
        alert('保存失败：' + (error.response?.data || error.message))
      }
    },
    
    async viewPlanDetails(planId) {
      try {
        const response = await axios.get(`/travel-plans/${planId}`)
        this.selectedPlan = response.data
        this.showDetailsModal = true
      } catch (error) {
        console.error('Failed to load travel plan details:', error)
        alert('加载旅行计划详情失败')
      }
    },

    closeDetailsModal() {
      this.showDetailsModal = false
      this.selectedPlan = null
    },

    formatDateTime,
    formatDate,
    
    async deletePlan(id) {
      if (confirm('确定要删除这个旅行计划吗？')) {
        try {
          await axios.delete(`/travel-plans/${id}`)
          this.loadPlans()
        } catch (error) {
          alert('删除失败')
        }
      }
    },
    
    closeModal() {
      this.showAddModal = false
      this.form = {
        name: '',
        destination: '',
        startDate: '',
        endDate: '',
        travelType: '',
        notes: '',
        clothingItems: []
      }
    }
  }
}
</script>

<style scoped>
.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 2rem;
}

.page-title {
  font-size: 2rem;
  color: var(--text-primary);
}

.loading,
.empty-state {
  text-align: center;
  padding: 3rem;
  color: var(--text-secondary);
}

.travel-card h3 {
  font-size: 1.3rem;
  margin-bottom: 1rem;
  color: var(--text-primary);
}

.travel-info p {
  font-size: 0.95rem;
  color: var(--text-secondary);
  margin-bottom: 0.5rem;
}

.travel-actions {
  display: flex;
  gap: 1rem;
  margin-top: 1rem;
  align-items: center;
}

.btn-icon {
  background: none;
  border: none;
  font-size: 1.2rem;
  cursor: pointer;
  padding: 0.25rem 0.5rem;
  transition: transform 0.2s;
}

.btn-icon:hover {
  transform: scale(1.2);
}

.modal {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.modal-content {
  background-color: var(--card-bg);
  border-radius: 15px;
  padding: 2rem;
  max-width: 500px;
  width: 90%;
  max-height: 90vh;
  overflow-y: auto;
}

.modal-content h3 {
  margin-bottom: 1.5rem;
  color: var(--text-primary);
}

.modal-actions {
  display: flex;
  gap: 1rem;
  justify-content: flex-end;
  margin-top: 1.5rem;
}

.large-modal {
  max-width: 900px;
  max-height: 90vh;
  overflow-y: auto;
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
  z-index: 1;
}

.modal-close:hover {
  color: var(--text-primary);
}

.details-section {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.detail-row {
  display: flex;
  justify-content: space-between;
  padding: 0.75rem;
  background: var(--background, #FFF5F5);
  border-radius: 8px;
}

.detail-label {
  font-weight: 600;
  color: var(--text-primary);
}

.detail-value {
  color: var(--text-secondary);
  text-align: right;
}

.section-title {
  margin-top: 1.5rem;
  margin-bottom: 1rem;
  color: var(--text-primary);
  font-size: 1.1rem;
}

.clothing-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
  gap: 1rem;
  margin-top: 1rem;
}

.clothing-card {
  background: var(--background, #FFF5F5);
  border-radius: 12px;
  overflow: hidden;
  transition: transform 0.2s, box-shadow 0.2s;
}

.clothing-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
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

.clothing-info {
  padding: 1rem;
}

.clothing-info h4 {
  margin: 0 0 0.5rem 0;
  color: var(--text-primary);
  font-size: 0.95rem;
}

.clothing-meta {
  display: flex;
  gap: 0.5rem;
  flex-wrap: wrap;
  margin: 0;
}

.category-badge,
.color-badge {
  padding: 0.25rem 0.5rem;
  border-radius: 6px;
  font-size: 0.75rem;
  background-color: rgba(184, 163, 152, 0.2);
  color: var(--text-primary);
}
</style>
