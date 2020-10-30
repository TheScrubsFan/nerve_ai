<style>
table {
  border: 1px black solid;
}
.cell {
  width: 30px;
  height: 30px;
}
</style>

<template>
  <div class="">
    <div v-if="!game.gamers || game.gamers && game.gamers.length < 2">
      Чтобы начать игру - отправьте ссылку другому игроку
    </div>

    <div v-if="game.gamers && game.gamers.length == 2">
      <span v-if="canStep()">
        Ваш ход
      </span>

      <span v-if="!canStep()">
        Ход соперника
      </span>
    </div>

    <div v-if="game.state == 'finished'">
      <div v-if="youWinner()">
        Вы выиграли
      </div>
      <div v-if="!youWinner()">
        Вы проиграли
      </div>
    </div>

    <table v-if="game.gamers && game.gamers.length == 2">
      <tr v-for="row in game.cells">
        <td v-for="cell in row">
          <div v-if="canStep(cell)">
            <button class="cell" v-on:click="makeStep(cell)" v-if="!cell.kind">
            </button>
          </div>

          <span v-if="cell.kind">
            {{ cell.kind }}
          </span>
        </td>
      </tr>
    </table>
 </div>
</template>

<script>
import axios from 'axios'

export default {
  channels: {
    GamesChannel: {
      connected() {
        console.log('I am connected.');
      },
      rejected() {},
      received(data) {
        this.game = data.game
      },
      disconnected() {}
    }
  },
  mounted() {
    this.$cable.subscribe({
      channel: 'GamesChannel'
    })
    axios
      .get('/games/'+ this.$route.params.id)
      .then(response => (
        this.game = response.data
      ))
    axios
      .get('/users/current')
      .then(response => (
        this.user = response.data.user
      ))
  },
  data: function () {
    return {
      game: {},
      user: {}
    }
  },
  methods: {
    makeStep: function (cell) {
      if(!this.canStep(cell))
        return

      let params = {
        cell: cell
      }
      let url = '/games/' + this.$route.params.id + '/make_step'

      axios
        .post(url, params)
    },

    canStep: function (cell) {
      return !cell.kind && this.canStep()
    },

    canStep: function () {
      return this.game.state == 'started' &&
        this.game.current_gamer.user_id == this.user.id
    },

    youWinner: function () {
      return this.game.winner && this.game.winner.user.id == this.user.id
    }
  },
}
</script>

