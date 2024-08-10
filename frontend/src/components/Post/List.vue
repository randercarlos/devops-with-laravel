<template>
<div>
    <div class="actions">
      <router-link :to="{ name: 'posts-form' }">New post</router-link>
      <button @click="exportPosts()">Export All Posts</button>
    </div>
    <table>
        <tr>
            <th>Title</th>
            <th>Headline</th>
            <th>Publish at</th>
            <th></th>
        </tr>
        <tr v-for="post in posts" v-bind:key="post.id">
            <td>{{ post.title }}</td>
            <td>{{ post.headline }}</td>
            <td>{{ post.publish_at }}</td>
            <td>
                <button v-if="!post.is_published" @click="publish(post)" :disabled="isPublishing">Publish</button>
            </td>
        </tr>
    </table>
</div>
</template>

<script>
import axios from 'axios';

export default {
    name: 'PostList',

    data() {
        return {
            posts: [],
            isPublishing: false
        };
    },

    async created() {
        await this.fetch();
    },

    methods: {
        async fetch() {
          const { data } = await axios.get('/api/posts', {
            headers: { 'Authorization': `Bearer ${localStorage.getItem('access_token')}` },
          });

          this.posts = data.data;
        },

        async publish(post) {
          this.isPublishing = true;
          await axios.patch(`/api/posts/${post.id}/publish`, {}, {
            headers: { 'Authorization': `Bearer ${localStorage.getItem('access_token')}` },
          });

          await this.fetch();
          this.isPublishing = false;
        },

        async exportPosts() {
          try {
            await axios.get(`/api/posts/export`, {
              headers: { 'Authorization': `Bearer ${localStorage.getItem('access_token')}` },
            });

            alert('Posts will be export in async way. On finish, a email will be sent.')
          } catch(e) {
            alert('Falha ao exportar posts')
          }
        }
    }
}
</script>

<style scoped>
  .actions {
    display: flex;
    align-items: center;
    justify-content: space-around;
    height: 50px;
  }
</style>