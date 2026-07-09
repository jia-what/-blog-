<!-- src/views/Admin.vue -->
<template>
  <div class="admin">
    <header class="admin-header">
      <h1>博客后台管理</h1>
    </header>

    <div class="admin-content">
      <div class="post-management">
        <div class="toolbar">
          <button @click="showCreateForm = true" class="btn-primary">新建文章</button>
        </div>

        <table class="post-table">
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
                <button @click="editPost(post)" class="btn-edit">编辑</button>
                <button @click="deletePost(post.id)" class="btn-delete">删除</button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- 新建/编辑文章表单 -->
      <div v-if="showCreateForm || editingPost" class="modal">
        <div class="modal-content">
          <h2>{{ editingPost ? '编辑文章' : '新建文章' }}</h2>
          <form @submit.prevent="savePost">
            <div class="form-group">
              <label>标题:</label>
              <input v-model="form.title" type="text" required>
            </div>
            <div class="form-group">
              <label>内容:</label>
              <textarea v-model="form.content" rows="10" required></textarea>
            </div>
            <div class="form-actions">
              <button type="submit" class="btn-primary">保存</button>
              <button type="button" @click="cancelEdit" class="btn-secondary">取消</button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'AdminPage',
  data() {
    return {
      posts: [],
      showCreateForm: false,
      editingPost: null,
      form: {
        title: '',
        content: ''
      }
    }
  },
  mounted() {
    this.fetchPosts()
  },
  methods: {
    async fetchPosts() {
      try {
        // 添加完整的URL路径
        const response = await axios.get('/api/admin/posts')
        this.posts = response.data
      } catch (error) {
        console.error('获取文章列表失败:', error)
        alert('获取文章列表失败，请检查网络或联系管理员')
      }
    },

    editPost(post) {
      this.editingPost = post
      this.form = {
        title: post.title,
        content: post.content
      }
    },

    async savePost() {
      try {
        if (this.editingPost) {
          // 更新文章
          await axios.put(`/api/admin/posts/${this.editingPost.id}`, this.form)
        } else {
          // 新建文章
          await axios.post('/api/admin/posts', this.form)
        }
        this.cancelEdit()
        this.fetchPosts()
      } catch (error) {
        console.error('保存文章失败:', error.response?.data || error.message)
        alert('保存失败，请检查网络或联系管理员')
      }
    },

    async deletePost(id) {
      if (confirm('确定要删除这篇文章吗？')) {
        try {
          await axios.delete(`/api/admin/posts/${id}`)
          this.fetchPosts()
        } catch (error) {
          console.error('删除文章失败:', error)
          alert('删除文章失败，请检查网络或联系管理员')
        }
      }
    },

    cancelEdit() {
      this.showCreateForm = false
      this.editingPost = null
      this.form = {
        title: '',
        content: ''
      }
    }
  }
}
</script>

<style scoped>
.admin-header {
  background: #333;
  color: white;
  padding: 20px;
}

.admin-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

.toolbar {
  margin-bottom: 20px;
}

.btn-primary {
  background: #007bff;
  color: white;
  border: none;
  padding: 10px 15px;
  border-radius: 5px;
  cursor: pointer;
}

.post-table {
  width: 100%;
  border-collapse: collapse;
}

.post-table th,
.post-table td {
  border: 1px solid #ddd;
  padding: 10px;
  text-align: left;
}

.post-table th {
  background: #f5f5f5;
}

.btn-edit,
.btn-delete {
  margin-right: 5px;
  padding: 5px 10px;
  border: none;
  border-radius: 3px;
  cursor: pointer;
}

.btn-edit {
  background: #28a745;
  color: white;
}

.btn-delete {
  background: #dc3545;
  color: white;
}

.modal {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
}

.modal-content {
  background: white;
  padding: 20px;
  border-radius: 5px;
  width: 600px;
  max-width: 90%;
}

.form-group {
  margin-bottom: 15px;
}

.form-group label {
  display: block;
  margin-bottom: 5px;
}

.form-group input,
.form-group textarea {
  width: 100%;
  padding: 8px;
  border: 1px solid #ddd;
  border-radius: 3px;
}

.form-actions {
  text-align: right;
}

.btn-secondary {
  background: #6c757d;
  color: white;
  border: none;
  padding: 10px 15px;
  border-radius: 5px;
  cursor: pointer;
  margin-left: 10px;
}
</style>
