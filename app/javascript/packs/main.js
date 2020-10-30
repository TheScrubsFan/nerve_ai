/* eslint no-console: 0 */
import Vue from 'vue'
import App from '../app.vue'
import Router from 'vue-router'
import Vuelidate from 'vuelidate'
import ActionCableVue from 'actioncable-vue'
import axios from 'axios'

import NewGame from '../components/game/new.vue'
import Game from '../components/game/game.vue'

Vue.use(Vuelidate)
Vue.use(Router)
Vue.use(ActionCableVue, {
  debug: true,
  debugLevel: 'error',
  connectionUrl: process.env.WEBSOCKET_HOST,
  connectImmediately: true,
})

const router = new Router({
  routes: [
    {
      path:'/',
      name:'new_game',
      component: NewGame
    },
    {
      path:'/games/:id',
      name:'game',
      component: Game
    },
  ]
})

let token = document.getElementsByName('csrf-token')[0].getAttribute('content')
axios.defaults.headers.common['X-CSRF-Token'] = token
axios.defaults.headers.common['Accept'] = 'application/json'

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    render: h => h(App),
    router
  }).$mount(document.getElementById('app'))

  document.body.appendChild(app.$el)

  console.log(app)
})
