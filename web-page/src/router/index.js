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
        path: 'reviews',
        name: 'AdminReviews',
        component: () => import('../views/AdminReviews.vue')
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
        path: 'categories',
        name: 'AdminCategories',
        component: () => import('../views/AdminCategories.vue')
      },
      {
        path: 'tags',
        name: 'AdminTags',
        component: () => import('../views/AdminTags.vue')
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
      },
      {
        path: 'gallery',
        name: 'AdminGallery',
        component: () => import('../views/AdminGallery.vue')
      },
      {
        path: 'stock',
        name: 'AdminStock',
        component: () => import('../views/AdminStock.vue')
      },
      {
        path: 'monitor',
        name: 'AdminMonitor',
        component: () => import('../views/AdminMonitor.vue')
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// 路由守卫 - 保护管理后台路由
router.beforeEach((to, from, next) => {
  // 检查是否是管理后台路由
  if (to.path.startsWith('/admin')) {
    // 如果是登录页面，直接放行
    if (to.path === '/admin/login') {
      next()
    } else {
      // 其他管理后台页面需要登录
      const adminInfo = localStorage.getItem('adminInfo')
      
      if (adminInfo) {
        next()
      } else {
        // 未登录，重定向到登录页
        next('/admin/login')
      }
    }
  } else {
    next()
  }
})

export default router
