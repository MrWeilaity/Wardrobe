<template>
  <div id="app">
    <nav v-if="isAuthenticated" class="navbar">
      <div class="nav-container">
        <div class="nav-brand">
          <h1>👗 智衣橱</h1>
        </div>
        <div class="nav-links">
          <router-link to="/" class="nav-link">我的衣橱</router-link>
          <router-link to="/outfits" class="nav-link">穿搭方案</router-link>
          <router-link to="/travel-plans" class="nav-link">旅行计划</router-link>
          <router-link to="/admin" class="nav-link">管理面板</router-link>
          <button @click="logout" class="logout-btn">退出</button>
        </div>
      </div>
    </nav>
    <main class="main-content">
      <router-view></router-view>
    </main>
  </div>
</template>

<script>
export default {
  name: 'App',
  data() {
    return {
      isAuthenticated: false
    }
  },
  mounted() {
    // Initialize authentication state
    this.updateAuthState()
  },
  watch: {
    // Watch for route changes to update auth state
    '$route'() {
      this.updateAuthState()
    }
  },
  methods: {
    updateAuthState() {
      this.isAuthenticated = !!localStorage.getItem('token')
    },
    logout() {
      localStorage.removeItem('token')
      localStorage.removeItem('user')
      this.isAuthenticated = false
      this.$router.push('/login')
    }
  }
}
</script>

<style>
:root {
  /* Morandi Earth-tone palette - natural, cotton-linen aesthetic */
  --primary-color: #B8A398;    /* Warm taupe - main earthy tone */
  --primary-light: #D4C4B7;    /* Light beige - soft cotton */
  --primary-dark: #9D8B7F;     /* Dark taupe - grounded earth */
  --secondary-color: #C9B8A8;  /* Sandy beige - natural linen */
  --accent-color: #A8998A;     /* Muted clay - subtle accent */
  
  --background: #F5F1ED;       /* Soft ivory - cotton white */
  --card-bg: #FFFFFF;
  --text-primary: #4A4034;     /* Deep warm brown - natural text */
  --text-secondary: #7A6F63;   /* Medium warm grey - secondary text */
  --border-color: #E3D9CE;     /* Soft sand - gentle borders */
  
  --success: #A8B5A0;          /* Sage grey-green - muted success */
  --warning: #D4B896;          /* Warm sand - gentle warning */
  --danger: #C4A090;           /* Muted terracotta - soft alert */
  
  --shadow: 0 2px 8px rgba(184, 163, 152, 0.15);
  --shadow-hover: 0 4px 16px rgba(184, 163, 152, 0.25);
}

* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: 'Segoe UI', 'PingFang SC', 'Microsoft YaHei', sans-serif;
  background-color: var(--background);
  color: var(--text-primary);
  line-height: 1.6;
}

#app {
  min-height: 100vh;
}

.navbar {
  background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
  box-shadow: var(--shadow);
  padding: 0;
  position: sticky;
  top: 0;
  z-index: 100;
}

.nav-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 1rem 2rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.nav-brand h1 {
  color: white;
  font-size: 1.5rem;
  font-weight: 600;
  letter-spacing: 0.5px;
}

.nav-links {
  display: flex;
  gap: 1.5rem;
  align-items: center;
}

.nav-link {
  color: white;
  text-decoration: none;
  padding: 0.5rem 1rem;
  border-radius: 20px;
  transition: all 0.3s ease;
  font-weight: 500;
}

.nav-link:hover,
.nav-link.router-link-active {
  background-color: rgba(255, 255, 255, 0.25);
  transform: translateY(-2px);
}

.logout-btn {
  background-color: rgba(255, 255, 255, 0.2);
  color: white;
  border: 2px solid white;
  padding: 0.5rem 1.5rem;
  border-radius: 20px;
  cursor: pointer;
  font-weight: 500;
  transition: all 0.3s ease;
}

.logout-btn:hover {
  background-color: white;
  color: var(--primary-color);
  transform: translateY(-2px);
}

.main-content {
  max-width: 1200px;
  margin: 2rem auto;
  padding: 0 2rem;
}

/* Common button styles */
.btn {
  padding: 0.75rem 1.5rem;
  border: none;
  border-radius: 25px;
  cursor: pointer;
  font-weight: 500;
  transition: all 0.3s ease;
  font-size: 1rem;
}

.btn-primary {
  background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
  color: white;
}

.btn-primary:hover {
  box-shadow: var(--shadow-hover);
  transform: translateY(-2px);
}

.btn-secondary {
  background-color: var(--primary-light);
  color: var(--text-primary);
}

.btn-secondary:hover {
  background-color: var(--primary-color);
  color: white;
}

/* Card styles */
.card {
  background-color: var(--card-bg);
  border-radius: 15px;
  padding: 1.5rem;
  box-shadow: var(--shadow);
  transition: all 0.3s ease;
}

.card:hover {
  box-shadow: var(--shadow-hover);
  transform: translateY(-2px);
}

/* Form styles */
.form-group {
  margin-bottom: 1.5rem;
}

.form-label {
  display: block;
  margin-bottom: 0.5rem;
  color: var(--text-primary);
  font-weight: 500;
}

.form-input,
.form-select,
.form-textarea {
  width: 100%;
  padding: 0.75rem 1rem;
  border: 2px solid var(--border-color);
  border-radius: 10px;
  font-size: 1rem;
  transition: all 0.3s ease;
  background-color: white;
  color: var(--text-primary);
}

.form-input:focus,
.form-select:focus,
.form-textarea:focus {
  outline: none;
  border-color: var(--primary-color);
  box-shadow: 0 0 0 3px rgba(232, 160, 160, 0.1);
}

.form-textarea {
  resize: vertical;
  min-height: 100px;
}

/* Grid layouts */
.grid {
  display: grid;
  gap: 1.5rem;
}

.grid-2 {
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
}

.grid-3 {
  grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
}

/* Responsive */
@media (max-width: 768px) {
  .nav-container {
    flex-direction: column;
    gap: 1rem;
    padding: 1rem;
  }
  
  .nav-brand h1 {
    font-size: 1.25rem;
    text-align: center;
  }
  
  .nav-links {
    flex-wrap: wrap;
    justify-content: center;
    gap: 0.75rem;
    width: 100%;
  }
  
  .nav-link {
    padding: 0.4rem 0.8rem;
    font-size: 0.9rem;
  }
  
  .logout-btn {
    padding: 0.4rem 1rem;
    font-size: 0.9rem;
  }
  
  .main-content {
    padding: 0 1rem;
    margin: 1rem auto;
  }
}

@media (max-width: 480px) {
  .nav-links {
    flex-direction: column;
    width: 100%;
  }
  
  .nav-link,
  .logout-btn {
    width: 100%;
    text-align: center;
  }
}
</style>
