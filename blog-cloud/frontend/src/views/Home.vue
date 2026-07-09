<!-- src/views/Home.vue -->
<template>
  <div class="home">
    <header class="header">
      <h1>我的博客</h1>
    </header>

    <main class="main">
      <div class="post-list">
        <div v-for="post in posts" :key="post.id" class="post-item">
          <h2 @click="viewPost(post.id)" class="post-title">{{ post.title }}</h2>
          <p class="post-meta">作者：{{ post.author }} | 发布时间：{{ post.createTime }}</p>
          <p class="post-content">{{ post.content.substring(0, 100) }}...</p>
        </div>
      </div>
    </main>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'HomePage', // 修改为多词名称
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
        const response = await axios.get('/home/api/posts')
        this.posts = response.data
      } catch (error) {
        console.error('获取文章列表失败:', error)
      }
    },
    viewPost(id) {
      this.$router.push(`/post/${id}`)
    }
  }
}
</script>

<style scoped>
.header {
  text-align: center;
  padding: 20px;
  background: #f5f5f5;
}

.post-list {
  max-width: 800px;
  margin: 0 auto;
  padding: 20px;
}

.post-item {
  border: 1px solid #ddd;
  border-radius: 5px;
  padding: 20px;
  margin-bottom: 20px;
  cursor: pointer;
}

.post-title {
  color: #333;
  margin: 0 0 10px 0;
}

.post-meta {
  color: #666;
  font-size: 14px;
  margin: 10px 0;
}

.post-content {
  color: #444;
  line-height: 1.6;
}
</style>
