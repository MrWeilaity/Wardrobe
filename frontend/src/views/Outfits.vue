<template>
  <div class="outfits-page">
    <div class="page-header">
      <h2 class="page-title">穿搭方案</h2>
      <button @click="showAddModal = true" class="btn btn-primary">
        ➕ 创建穿搭
      </button>
    </div>
    
    <div v-if="loading" class="loading">加载中...</div>
    
    <div v-else-if="outfits.length === 0" class="empty-state">
      <p>还没有穿搭方案，创建您的第一个穿搭吧！</p>
    </div>
    
    <div v-else class="grid grid-2">
      <div v-for="outfit in outfits" :key="outfit.id" class="outfit-card card">
        <h3>{{ outfit.name }}</h3>
        <p v-if="outfit.occasion" class="outfit-meta">场合：{{ outfit.occasion }}</p>
        <p v-if="outfit.notes" class="outfit-notes">{{ outfit.notes }}</p>
        <p class="outfit-items">衣物数量：{{ outfit.clothingItems?.length || 0 }} 件</p>
        <div class="outfit-actions">
          <button @click="viewOutfit(outfit)" class="btn btn-secondary">查看详情</button>
          <button @click="deleteOutfit(outfit.id)" class="btn-icon">🗑️</button>
        </div>
      </div>
    </div>
    
    <!-- Add Modal -->
    <div v-if="showAddModal" class="modal" @click.self="closeModal">
      <div class="modal-content">
        <h3>创建穿搭方案</h3>
        <form @submit.prevent="saveOutfit">
          <div class="form-group">
            <label class="form-label">穿搭名称 *</label>
            <input v-model="form.name" type="text" class="form-input" required />
          </div>
          
          <div class="form-group">
            <label class="form-label">场合</label>
            <select v-model="form.occasion" class="form-select">
              <option value="">请选择</option>
              <option value="日常">日常</option>
              <option value="工作">工作</option>
              <option value="约会">约会</option>
              <option value="运动">运动</option>
              <option value="正式">正式</option>
              <option value="休闲">休闲</option>
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
  name: 'Outfits',
  data() {
    return {
      outfits: [],
      loading: false,
      showAddModal: false,
      form: {
        name: '',
        occasion: '',
        notes: '',
        clothingItems: []
      }
    }
  },
  mounted() {
    this.loadOutfits()
  },
  methods: {
    async loadOutfits() {
      this.loading = true
      try {
        const response = await axios.get('/outfits')
        this.outfits = response.data
      } catch (error) {
        console.error('Failed to load outfits:', error)
      } finally {
        this.loading = false
      }
    },
    
    async saveOutfit() {
      try {
        await axios.post('/outfits', this.form)
        this.closeModal()
        this.loadOutfits()
      } catch (error) {
        alert('保存失败：' + (error.response?.data || error.message))
      }
    },
    
    viewOutfit(outfit) {
      alert(`查看穿搭：${outfit.name}`)
      // TODO: Implement detailed view
    },
    
    async deleteOutfit(id) {
      if (confirm('确定要删除这个穿搭方案吗？')) {
        try {
          await axios.delete(`/outfits/${id}`)
          this.loadOutfits()
        } catch (error) {
          alert('删除失败')
        }
      }
    },
    
    closeModal() {
      this.showAddModal = false
      this.form = {
        name: '',
        occasion: '',
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

.outfit-card h3 {
  font-size: 1.3rem;
  margin-bottom: 0.5rem;
  color: var(--text-primary);
}

.outfit-meta,
.outfit-notes,
.outfit-items {
  font-size: 0.95rem;
  color: var(--text-secondary);
  margin-bottom: 0.5rem;
}

.outfit-actions {
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
