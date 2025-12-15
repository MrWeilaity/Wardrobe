import { createRouter, createWebHistory } from 'vue-router'
import Login from '../views/Login.vue'
import Register from '../views/Register.vue'
import Wardrobe from '../views/Wardrobe.vue'
import Outfits from '../views/Outfits.vue'
import TravelPlans from '../views/TravelPlans.vue'
import Admin from '../views/Admin.vue'

const routes = [
  {
    path: '/login',
    name: 'Login',
    component: Login
  },
  {
    path: '/register',
    name: 'Register',
    component: Register
  },
  {
    path: '/',
    name: 'Wardrobe',
    component: Wardrobe,
    meta: { requiresAuth: true }
  },
  {
    path: '/outfits',
    name: 'Outfits',
    component: Outfits,
    meta: { requiresAuth: true }
  },
  {
    path: '/travel-plans',
    name: 'TravelPlans',
    component: TravelPlans,
    meta: { requiresAuth: true }
  },
  {
    path: '/admin',
    name: 'Admin',
    component: Admin,
    meta: { requiresAuth: true }
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

router.beforeEach((to, from, next) => {
  const isAuthenticated = localStorage.getItem('token')
  
  if (to.meta.requiresAuth && !isAuthenticated) {
    next('/login')
  } else if ((to.path === '/login' || to.path === '/register') && isAuthenticated) {
    next('/')
  } else {
    next()
  }
})

export default router
