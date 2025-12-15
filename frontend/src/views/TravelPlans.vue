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
          <button @click="viewPlan(plan)" class="btn btn-secondary">查看详情</button>
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
  </div>
</template>

<script>
import axios from '../api/axios'

export default {
  name: 'TravelPlans',
  data() {
    return {
      plans: [],
      loading: false,
      showAddModal: false,
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
    
    viewPlan(plan) {
      alert(`查看旅行计划：${plan.name}`)
      // TODO: Implement detailed view with clothing selection
    },
    
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
    
    formatDate(dateString) {
      if (!dateString) return ''
      const date = new Date(dateString)
      return date.toLocaleDateString('zh-CN')
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
</style>
