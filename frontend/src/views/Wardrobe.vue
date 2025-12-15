<template>
  <div class="wardrobe-page">
    <div class="page-header">
      <h2 class="page-title">我的衣橱</h2>
      <button @click="showAddModal = true" class="btn btn-primary">
        ➕ 添加衣物
      </button>
    </div>
    
    <div class="filters">
      <select v-model="selectedCategory" @change="loadClothing" class="form-select">
        <option value="">全部类别</option>
        <option value="上衣">上衣</option>
        <option value="裤装">裤装</option>
        <option value="裙装">裙装</option>
        <option value="外套">外套</option>
        <option value="鞋履">鞋履</option>
        <option value="配饰">配饰</option>
      </select>
      
      <select v-model="selectedSeason" @change="loadClothing" class="form-select">
        <option value="">全部季节</option>
        <option value="春">春</option>
        <option value="夏">夏</option>
        <option value="秋">秋</option>
        <option value="冬">冬</option>
        <option value="四季">四季</option>
      </select>
    </div>
    
    <div v-if="loading" class="loading">加载中...</div>
    
    <div v-else-if="clothing.length === 0" class="empty-state">
      <p>您还没有添加衣物，点击上方按钮开始添加吧！</p>
    </div>
    
    <div v-else class="grid grid-3">
      <div v-for="item in clothing" :key="item.id" class="clothing-card card" @click="viewDetails(item)">
        <div class="clothing-image">
          <img v-if="item.imageUrl" :src="item.imageUrl" :alt="item.name" />
          <div v-else class="no-image">👔</div>
        </div>
        <div class="clothing-info">
          <h3>{{ item.name }}</h3>
          <p class="clothing-meta">{{ item.category }} | {{ item.color }}</p>
          <p class="clothing-meta">{{ item.season }} | {{ item.brand }}</p>
          <div class="clothing-actions" @click.stop>
            <button @click="editClothing(item)" class="btn-icon">✏️</button>
            <button @click="deleteClothing(item.id)" class="btn-icon">🗑️</button>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Detail Modal -->
    <div v-if="showDetailModal" class="modal" @click.self="closeDetailModal">
      <div class="modal-content detail-modal">
        <button @click="closeDetailModal" class="modal-close">✕</button>
        <h3>衣物详情</h3>
        <div v-if="selectedItem" class="detail-content">
          <div class="detail-image">
            <img v-if="selectedItem.imageUrl" :src="selectedItem.imageUrl" :alt="selectedItem.name" />
            <div v-else class="no-image-large">👔</div>
          </div>
          <div class="detail-info">
            <div class="detail-row">
              <span class="detail-label">名称：</span>
              <span class="detail-value">{{ selectedItem.name }}</span>
            </div>
            <div class="detail-row">
              <span class="detail-label">类别：</span>
              <span class="detail-value">{{ selectedItem.category }}</span>
            </div>
            <div class="detail-row" v-if="selectedItem.color">
              <span class="detail-label">颜色：</span>
              <span class="detail-value">{{ selectedItem.color }}</span>
            </div>
            <div class="detail-row" v-if="selectedItem.season">
              <span class="detail-label">季节：</span>
              <span class="detail-value">{{ selectedItem.season }}</span>
            </div>
            <div class="detail-row" v-if="selectedItem.brand">
              <span class="detail-label">品牌：</span>
              <span class="detail-value">{{ selectedItem.brand }}</span>
            </div>
            <div class="detail-row" v-if="selectedItem.price">
              <span class="detail-label">价格：</span>
              <span class="detail-value">¥{{ selectedItem.price }}</span>
            </div>
            <div class="detail-row" v-if="selectedItem.size">
              <span class="detail-label">尺寸：</span>
              <span class="detail-value">{{ selectedItem.size }}</span>
            </div>
            <div class="detail-row" v-if="selectedItem.material">
              <span class="detail-label">材质：</span>
              <span class="detail-value">{{ selectedItem.material }}</span>
            </div>
            <div class="detail-row">
              <span class="detail-label">状态：</span>
              <span class="detail-value">{{ selectedItem.status }}</span>
            </div>
            <div class="detail-row" v-if="selectedItem.wearCount !== undefined">
              <span class="detail-label">穿着次数：</span>
              <span class="detail-value">{{ selectedItem.wearCount }}次</span>
            </div>
            <div class="detail-row" v-if="selectedItem.purchaseDate">
              <span class="detail-label">购买日期：</span>
              <span class="detail-value">{{ selectedItem.purchaseDate }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Add/Edit Modal -->
    <div v-if="showAddModal" class="modal" @click.self="closeModal">
      <div class="modal-content">
        <h3>{{ editingItem ? '编辑衣物' : '添加衣物' }}</h3>
        <form @submit.prevent="saveClothing">
          <div class="form-group">
            <label class="form-label">图片</label>
            <ImageUpload v-model="form.imageUrl" />
          </div>
          
          <div class="form-group">
            <label class="form-label">名称 *</label>
            <input v-model="form.name" type="text" class="form-input" required />
          </div>
          
          <div class="form-group">
            <label class="form-label">类别 *</label>
            <select v-model="form.category" class="form-select" required>
              <option value="上衣">上衣</option>
              <option value="裤装">裤装</option>
              <option value="裙装">裙装</option>
              <option value="外套">外套</option>
              <option value="鞋履">鞋履</option>
              <option value="配饰">配饰</option>
            </select>
          </div>
          
          <div class="form-group">
            <label class="form-label">颜色</label>
            <input v-model="form.color" type="text" class="form-input" />
          </div>
          
          <div class="form-group">
            <label class="form-label">季节</label>
            <select v-model="form.season" class="form-select">
              <option value="春">春</option>
              <option value="夏">夏</option>
              <option value="秋">秋</option>
              <option value="冬">冬</option>
              <option value="四季">四季</option>
            </select>
          </div>
          
          <div class="form-group">
            <label class="form-label">品牌</label>
            <input v-model="form.brand" type="text" class="form-input" />
          </div>
          
          <div class="form-group">
            <label class="form-label">价格</label>
            <input v-model.number="form.price" type="number" class="form-input" step="0.01" />
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
import ImageUpload from '../components/ImageUpload.vue'

export default {
  name: 'Wardrobe',
  components: {
    ImageUpload
  },
  data() {
    return {
      clothing: [],
      loading: false,
      showAddModal: false,
      showDetailModal: false,
      editingItem: null,
      selectedItem: null,
      selectedCategory: '',
      selectedSeason: '',
      form: {
        name: '',
        category: '上衣',
        color: '',
        season: '四季',
        brand: '',
        price: null,
        size: '',
        material: '',
        imageUrl: '',
        purchaseDate: null,
        status: '在用',
        tags: []
      }
    }
  },
  mounted() {
    this.loadClothing()
  },
  methods: {
    async loadClothing() {
      this.loading = true
      try {
        let url = '/clothing'
        if (this.selectedCategory) {
          url = `/clothing/category/${this.selectedCategory}`
        }
        const response = await axios.get(url)
        this.clothing = response.data
        
        // Filter by season if selected
        if (this.selectedSeason) {
          this.clothing = this.clothing.filter(item => item.season === this.selectedSeason)
        }
      } catch (error) {
        console.error('Failed to load clothing:', error)
      } finally {
        this.loading = false
      }
    },
    
    async saveClothing() {
      try {
        if (this.editingItem) {
          await axios.put(`/clothing/${this.editingItem.id}`, this.form)
        } else {
          await axios.post('/clothing', this.form)
        }
        this.closeModal()
        this.loadClothing()
      } catch (error) {
        alert('保存失败：' + (error.response?.data || error.message))
      }
    },
    
    editClothing(item) {
      this.editingItem = item
      this.form = { ...item }
      this.showAddModal = true
    },
    
    async deleteClothing(id) {
      if (confirm('确定要删除这件衣物吗？')) {
        try {
          await axios.delete(`/clothing/${id}`)
          this.loadClothing()
        } catch (error) {
          alert('删除失败')
        }
      }
    },
    
    closeModal() {
      this.showAddModal = false
      this.editingItem = null
      this.form = {
        name: '',
        category: '上衣',
        color: '',
        season: '四季',
        brand: '',
        price: null,
        size: '',
        material: '',
        imageUrl: '',
        purchaseDate: null,
        status: '在用',
        tags: []
      }
    },
    
    viewDetails(item) {
      this.selectedItem = item
      this.showDetailModal = true
    },
    
    closeDetailModal() {
      this.showDetailModal = false
      this.selectedItem = null
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

.filters {
  display: flex;
  gap: 1rem;
  margin-bottom: 2rem;
}

.filters .form-select {
  max-width: 200px;
}

.loading,
.empty-state {
  text-align: center;
  padding: 3rem;
  color: var(--text-secondary);
}

.clothing-card {
  overflow: hidden;
}

.clothing-image {
  width: 100%;
  height: 200px;
  background-color: var(--background);
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 1rem;
  border-radius: 10px;
  overflow: hidden;
}

.clothing-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.no-image {
  font-size: 3rem;
}

.clothing-info h3 {
  font-size: 1.2rem;
  margin-bottom: 0.5rem;
  color: var(--text-primary);
}

.clothing-meta {
  font-size: 0.9rem;
  color: var(--text-secondary);
  margin-bottom: 0.25rem;
}

.clothing-actions {
  display: flex;
  gap: 0.5rem;
  margin-top: 1rem;
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

.clothing-card {
  cursor: pointer;
  transition: transform 0.2s, box-shadow 0.2s;
}

.clothing-card:hover {
  transform: translateY(-4px);
}

.detail-modal {
  max-width: 700px;
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
  transition: color 0.2s;
}

.modal-close:hover {
  color: var(--text-primary);
}

.detail-content {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 2rem;
  margin-top: 1rem;
}

.detail-image {
  width: 100%;
  height: 300px;
  background-color: var(--background);
  border-radius: 10px;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
}

.detail-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.no-image-large {
  font-size: 80px;
}

.detail-info {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.detail-row {
  display: flex;
  padding: 0.5rem 0;
  border-bottom: 1px solid var(--border-color);
}

.detail-label {
  font-weight: 600;
  color: var(--text-secondary);
  min-width: 100px;
}

.detail-value {
  color: var(--text-primary);
  flex: 1;
}

@media (max-width: 768px) {
  .detail-content {
    grid-template-columns: 1fr;
  }
}
</style>
