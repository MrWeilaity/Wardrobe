<template>
  <div class="auth-container">
    <div class="auth-card">
      <h2 class="auth-title">✨ 创建账号</h2>
      <p class="auth-subtitle">开启您的智能衣橱之旅</p>
      
      <form @submit.prevent="handleRegister" class="auth-form">
        <div class="form-group">
          <label class="form-label">用户名</label>
          <input 
            v-model="form.username" 
            type="text" 
            class="form-input" 
            placeholder="请输入用户名（3-50个字符）"
            required
            minlength="3"
            maxlength="50"
          />
        </div>
        
        <div class="form-group">
          <label class="form-label">邮箱</label>
          <input 
            v-model="form.email" 
            type="email" 
            class="form-input" 
            placeholder="请输入邮箱"
            required
          />
        </div>
        
        <div class="form-group">
          <label class="form-label">密码</label>
          <input 
            v-model="form.password" 
            type="password" 
            class="form-input" 
            placeholder="请输入密码（至少6个字符）"
            required
            minlength="6"
          />
        </div>
        
        <div v-if="error" class="error-message">
          {{ error }}
        </div>
        
        <div v-if="success" class="success-message">
          {{ success }}
        </div>
        
        <button type="submit" class="btn btn-primary btn-block" :disabled="loading">
          {{ loading ? '注册中...' : '注册' }}
        </button>
      </form>
      
      <div class="auth-footer">
        已有账号？
        <router-link to="/login" class="auth-link">立即登录</router-link>
      </div>
    </div>
  </div>
</template>

<script>
import axios from '../api/axios'

export default {
  name: 'Register',
  data() {
    return {
      form: {
        username: '',
        email: '',
        password: ''
      },
      loading: false,
      error: '',
      success: ''
    }
  },
  methods: {
    async handleRegister() {
      this.loading = true
      this.error = ''
      this.success = ''
      
      try {
        await axios.post('/auth/signup', this.form)
        this.success = '注册成功！正在跳转到登录页...'
        setTimeout(() => {
          this.$router.push('/login')
        }, 1500)
      } catch (error) {
        this.error = error.response?.data || '注册失败，请稍后重试'
      } finally {
        this.loading = false
      }
    }
  }
}
</script>

<style scoped>
.auth-container {
  min-height: calc(100vh - 4rem);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 2rem;
}

.auth-card {
  background-color: var(--card-bg);
  border-radius: 20px;
  padding: 3rem;
  box-shadow: var(--shadow-hover);
  max-width: 450px;
  width: 100%;
}

.auth-title {
  font-size: 2rem;
  color: var(--text-primary);
  margin-bottom: 0.5rem;
  text-align: center;
}

.auth-subtitle {
  color: var(--text-secondary);
  text-align: center;
  margin-bottom: 2rem;
}

.auth-form {
  margin-bottom: 1.5rem;
}

.btn-block {
  width: 100%;
  margin-top: 1rem;
}

.error-message {
  background-color: #FFE8E8;
  color: #D8000C;
  padding: 0.75rem;
  border-radius: 8px;
  margin-bottom: 1rem;
  text-align: center;
}

.success-message {
  background-color: #E8F5E8;
  color: #4CAF50;
  padding: 0.75rem;
  border-radius: 8px;
  margin-bottom: 1rem;
  text-align: center;
}

.auth-footer {
  text-align: center;
  color: var(--text-secondary);
}

.auth-link {
  color: var(--primary-color);
  text-decoration: none;
  font-weight: 500;
}

.auth-link:hover {
  color: var(--primary-dark);
  text-decoration: underline;
}
</style>
