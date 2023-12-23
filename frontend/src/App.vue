<template>
  <div id="app">
    <h3>Ambiente: {{ currentEnvironment }}</h3>
    <router-view v-slot="{ Component }">
      <component :is="Component" />
    </router-view>
  </div>
</template>

<script>
import axios from 'axios';
import PostList from './components/Post/List.vue';

export default {
  name: 'App',
  components: {
      PostList,
  },
  data() {
    return {
      currentEnvironment: null,
    }
  },
  methods: {
    async getCurrentEnvironment() {
      const { data } = await axios.get('/api/current-environment');

      this.currentEnvironment = data.data['current-environment'];
    }
  },
  mounted() {
    this.getCurrentEnvironment();
  }
}
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
