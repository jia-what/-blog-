// src/router/index.js
import { createRouter, createWebHistory } from 'vue-router'
import HomePage from '../views/Home.vue'
import PostDetailPage from '../views/PostDetail.vue'
import AdminPage from '../views/Admin.vue'

const routes = [
  {
    path: '/',
    name: 'HomePage',
    component: HomePage
  },
  {
    path: '/post/:id',
    name: 'PostDetailPage',
    component: PostDetailPage
  },
  {
    path: '/admin',
    name: 'AdminPage',
    component: AdminPage
  }
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

export default router
