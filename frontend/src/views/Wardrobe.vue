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
      <div v-for="item in clothing" :key="item.id" class="clothing-card card">
        <div class="clothing-image">
          <img v-if="item.imageUrl" :src="item.imageUrl" :alt="item.name" />
          <div v-else class="no-image">👔</div>
        </div>
        <div class="clothing-info">
          <h3>{{ item.name }}</h3>
          <p class="clothing-meta">{{ item.category }} | {{ item.color }}</p>
          <p class="clothing-meta">{{ item.season }} | {{ item.brand }}</p>
          <div class="clothing-actions">
            <button @click="editClothing(item)" class="btn-icon">✏️</button>
            <button @click="deleteClothing(item.id)" class="btn-icon">🗑️</button>
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

export default {
  name: 'Wardrobe',
  data() {
    return {
      clothing: [],
      loading: false,
      showAddModal: false,
      editingItem: null,
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
</style>
