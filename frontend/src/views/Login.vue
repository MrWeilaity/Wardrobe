<template>
  <div class="auth-container">
    <div class="auth-card">
      <h2 class="auth-title">👗 欢迎回来</h2>
      <p class="auth-subtitle">登录您的智衣橱</p>
      
      <form @submit.prevent="handleLogin" class="auth-form">
        <div class="form-group">
          <label class="form-label">用户名</label>
          <input 
            v-model="form.username" 
            type="text" 
            class="form-input" 
            placeholder="请输入用户名"
            required
          />
        </div>
        
        <div class="form-group">
          <label class="form-label">密码</label>
          <input 
            v-model="form.password" 
            type="password" 
            class="form-input" 
            placeholder="请输入密码"
            required
          />
        </div>
        
        <div v-if="error" class="error-message">
          {{ error }}
        </div>
        
        <button type="submit" class="btn btn-primary btn-block" :disabled="loading">
          {{ loading ? '登录中...' : '登录' }}
        </button>
      </form>
      
      <div class="auth-footer">
        还没有账号？
        <router-link to="/register" class="auth-link">立即注册</router-link>
      </div>
    </div>
  </div>
</template>

<script>
import axios from '../api/axios'

export default {
  name: 'Login',
  data() {
    return {
      form: {
        username: '',
        password: ''
      },
      loading: false,
      error: ''
    }
  },
  methods: {
    async handleLogin() {
      this.loading = true
      this.error = ''
      
      try {
        const response = await axios.post('/auth/login', this.form)
        localStorage.setItem('token', response.data.token)
        localStorage.setItem('user', JSON.stringify({
          id: response.data.id,
          username: response.data.username,
          email: response.data.email
        }))
        
        // Navigate to home page - navbar will update via computed property
        await this.$router.push('/')
      } catch (error) {
        this.error = error.response?.data || '登录失败，请检查用户名和密码'
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
