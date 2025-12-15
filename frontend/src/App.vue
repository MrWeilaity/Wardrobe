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
  computed: {
    isAuthenticated() {
      return !!localStorage.getItem('token')
    }
  },
  methods: {
    logout() {
      localStorage.removeItem('token')
      localStorage.removeItem('user')
      this.$router.push('/login')
    }
  }
}
</script>

<style>
:root {
  /* Feminine color palette - soft pinks, roses, and warm neutrals */
  --primary-color: #E8A0A0;  /* Soft rose pink */
  --primary-light: #F5C7C7;  /* Light dusty pink */
  --primary-dark: #D67B7B;   /* Deeper rose */
  --secondary-color: #D4A5A5; /* Mauve rose */
  --accent-color: #C9A0A0;    /* Muted rose */
  
  --background: #FFF5F5;      /* Very soft pink-white */
  --card-bg: #FFFFFF;
  --text-primary: #5A3A3A;    /* Warm brown */
  --text-secondary: #8B6B6B;  /* Lighter warm brown */
  --border-color: #E8D7D7;    /* Soft pink-grey */
  
  --success: #A8C9A8;         /* Soft sage green */
  --warning: #F0C8A0;         /* Soft peach */
  --danger: #E8A0A0;          /* Matches primary */
  
  --shadow: 0 2px 8px rgba(232, 160, 160, 0.15);
  --shadow-hover: 0 4px 16px rgba(232, 160, 160, 0.25);
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
  }
  
  .nav-links {
    flex-wrap: wrap;
    justify-content: center;
  }
  
  .main-content {
    padding: 0 1rem;
  }
}
</style>
