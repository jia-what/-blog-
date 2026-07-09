<template>
  <div class="admin">
    <header class="header">
      <h1>博客后台管理</h1>
    </header>

    <main class="main">
      <button @click="createPost" class="btn-primary">新建文章</button>

      <table class="table">
        <thead>
          <tr>
            <th>ID</th>
            <th>标题</th>
            <th>作者</th>
            <th>状态</th>
            <th>创建时间</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="post in posts" :key="post.id">
            <td>{{ post.id }}</td>
            <td>{{ post.title }}</td>
            <td>{{ post.author }}</td>
            <td>{{ post.status }}</td>
            <td>{{ post.createTime }}</td>
            <td>
              <button @click="deletePost(post.id)" class="btn-danger">删除</button>
            </td>
          </tr>
        </tbody>
      </table>
    </main>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'AdminPage',
  data() {
    return {
      posts: []
    }
  },
  mounted() {
    this.fetchPosts()
  },
  methods: {
    async fetchPosts() {
      try {
        const response = await axios.get('/admin/posts') // ✅ 关键修改
        this.posts = response.data
      } catch (error) {
        console.error('获取文章列表失败:', error)
      }
    },
    async createPost() {
      // 实现创建逻辑
    },
    async deletePost(id) {
      try {
        await axios.delete(`/admin/posts/${id}`)
        this.fetchPosts() // 刷新列表
      } catch (error) {
        console.error('删除失败:', error)
      }
    }
  }
}
</script>

<style scoped>
.header {
  text-align: center;
  padding: 20px;
  background: #333;
  color: white;
}

.main {
  padding: 20px;
}

.btn-primary {
  background: #007bff;
  color: white;
  border: none;
  padding: 10px 20px;
  border-radius: 5px;
  cursor: pointer;
  margin-bottom: 20px;
}

.btn-danger {
  background: #dc3545;
  color: white;
  border: none;
  padding: 5px 10px;
  border-radius: 3px;
  cursor: pointer;
}

.table {
  width: 100%;
  border-collapse: collapse;
  margin-top: 20px;
}

.table th,
.table td {
  border: 1px solid #ddd;
  padding: 12px;
  text-align: left;
}

.table th {
  background-color: #f2f2f2;
}
</style>
