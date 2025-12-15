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
          <button @click="viewOutfitDetails(outfit.id)" class="btn btn-secondary">查看详情</button>
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

    <!-- Details Modal -->
    <div v-if="showDetailsModal" class="modal" @click.self="closeDetailsModal">
      <div class="modal-content large-modal">
        <button @click="closeDetailsModal" class="modal-close">✕</button>
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
            <div v-for="item in selectedOutfit.clothingItems" :key="item.id" class="clothing-card">
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

export default {
  name: 'Outfits',
  data() {
    return {
      outfits: [],
      loading: false,
      showAddModal: false,
      showDetailsModal: false,
      selectedOutfit: null,
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
    
    async viewOutfitDetails(outfitId) {
      try {
        const response = await axios.get(`/outfits/${outfitId}`)
        this.selectedOutfit = response.data
        this.showDetailsModal = true
      } catch (error) {
        console.error('Failed to load outfit details:', error)
        alert('加载穿搭详情失败')
      }
    },

    closeDetailsModal() {
      this.showDetailsModal = false
      this.selectedOutfit = null
    },

    formatDateTime(dateString) {
      if (!dateString) return ''
      const date = new Date(dateString)
      return date.toLocaleString('zh-CN', {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
        hour: '2-digit',
        minute: '2-digit'
      })
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
