/* eslint no-console: 0 */
import Vue from 'vue'
import App from '../app.vue'
import Router from 'vue-router'
import Vuelidate from 'vuelidate'
import ActionCableVue from 'actioncable-vue'

import NewGame from '../components/game/new.vue'
import Game from '../components/game/game.vue'

Vue.use(Vuelidate)
Vue.use(Router)
Vue.use(ActionCableVue, {
  debug: true,
  debugLevel: 'error',
  //connectionUrl: 'ws://localhost:3001/cable',
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
      path:'/game/1/',
      name:'game',
      component: Game
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
