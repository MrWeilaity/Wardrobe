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
    meta: { requiresAuth: true, requiresAdmin: true }
  },
  {
    path: '/:pathMatch(.*)*',
    redirect: '/'
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

router.beforeEach((to, from, next) => {
  const isAuthenticated = localStorage.getItem('token')
  
  // Check if route requires admin access
  if (to.meta.requiresAdmin) {
    if (!isAuthenticated) {
      // Not authenticated, redirect to login
      next('/login')
      return
    }
    
    // Check if user has ROLE_ADMIN
    const userStr = localStorage.getItem('user')
    if (userStr) {
      try {
        const user = JSON.parse(userStr)
        if (user.roles && user.roles.includes('ROLE_ADMIN')) {
          // User is admin, allow access
          next()
        } else {
          // User is authenticated but not admin, redirect to home
          next('/')
        }
      } catch (e) {
        // Error parsing user data, redirect to home
        next('/')
      }
    } else {
      // No user data, redirect to home
      next('/')
    }
    return
  }
  
  // Check if route requires authentication
  if (to.meta.requiresAuth && !isAuthenticated) {
    next('/login')
    return
  }
  
  // Redirect authenticated users away from login/register pages
  if ((to.path === '/login' || to.path === '/register') && isAuthenticated) {
    next('/')
    return
  }
  
  // Allow navigation
  next()
})

export default router
