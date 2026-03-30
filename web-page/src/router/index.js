import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  {
    path: '/',
    name: 'Home',
    component: () => import('../views/Home.vue')
  },
  {
    path: '/login',
    name: 'Login',
    component: () => import('../views/Login.vue')
  },
  {
    path: '/register',
    name: 'Register',
    component: () => import('../views/Register.vue')
  },
  {
    path: '/products',
    name: 'ProductList',
    component: () => import('../views/ProductList.vue')
  },
  {
    path: '/products/:id',
    name: 'ProductDetail',
    component: () => import('../views/ProductDetail.vue')
  },
  {
    path: '/cart',
    name: 'Cart',
    component: () => import('../views/Cart.vue')
  },
  {
    path: '/orders',
    name: 'Order',
    component: () => import('../views/Order.vue')
  },
  {
    path: '/profile',
    name: 'Profile',
    component: () => import('../views/Profile.vue')
  },
  // 管理员路由
  {
    path: '/admin/login',
    name: 'AdminLogin',
    component: () => import('../views/AdminLogin.vue')
  },
  {
    path: '/admin',
    name: 'Admin',
    component: () => import('../views/Admin.vue'),
    redirect: '/admin/dashboard',
    children: [
      {
        path: 'dashboard',
        name: 'AdminDashboard',
        component: () => import('../views/AdminDashboard.vue')
      },
      {
        path: 'portrait',
        name: 'AdminPortrait',
        component: () => import('../views/AdminPortrait.vue')
      },
      {
        path: 'users',
        name: 'AdminUsers',
        component: () => import('../views/AdminUsers.vue')
      },
      {
        path: 'orders',
        name: 'AdminOrders',
        component: () => import('../views/AdminOrders.vue')
      },
      {
        path: 'products',
        name: 'AdminProducts',
        component: () => import('../views/AdminProducts.vue')
      },
      {
        path: 'gallery',
        name: 'AdminGallery',
        component: () => import('../views/AdminGallery.vue')
      },
      {
        path: 'videos',
        name: 'AdminVideos',
        component: () => import('../views/AdminVideos.vue')
      },
      {
        path: 'notices',
        name: 'AdminNotices',
        component: () => import('../views/AdminNotices.vue')
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
