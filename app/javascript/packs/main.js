/* eslint no-console: 0 */
import Vue from 'vue'
import App from '../app.vue'
import Router from 'vue-router'
import Vuelidate from 'vuelidate';

import NewGame from '../components/game/new.vue'

Vue.use(Vuelidate)
Vue.use(Router)

const router = new Router({
  routes: [
    {
      path:'/',
      name:'newGame',
      component: NewGame
    },
  ]
})

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    render: h => h(App),
    router
  }).$mount()

  document.body.appendChild(app.$el)

  console.log(app)
})
