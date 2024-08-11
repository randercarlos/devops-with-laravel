import Vue from 'vue';
import App from './App.vue';
import VueRouter from 'vue-router';
import PostList from './components/Post/List';
import PostForm from './components/Post/Form';
import Login from './components/User/Login';
import axios from 'axios';

Vue.use(VueRouter);


const routes = [
  { path: '/', redirect: '/posts' },
  { path: '/posts', name: 'posts-list', component: PostList },
  { path: '/posts/create', name: 'posts-form', component: PostForm },
  { path: '/login', name: 'login', component: Login },
];

const router = new VueRouter({
  mode: 'history',
  routes,
});

Vue.config.productionTip = false

axios.interceptors.response.use(function (response) {
  return response;
}, function (error) {
  if (error.response.status === 401) {
    router.replace({ name: 'login' });
  }

  return error;
});


new Vue({
  render: h => h(App),
  router,
}).$mount('#app')
