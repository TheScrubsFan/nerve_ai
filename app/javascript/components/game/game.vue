<style>
table {
  border: 1px black solid;
}
button {
  width: 30px;
  height: 30px;
}
</style>

<template>
  <div class="">
    <span v-if="game.gamers && game.gamers.length < 2">
      Чтобы начать игру - отправьте ссылку другому игроку
    </span>

    <table v-if="game.gamers && game.gamers.length == 2">
      <tr v-for="row in game.cells">
        <td v-for="cell in row">
          <div v-if="game.state == 'started'">
            <button v-on:click="makeStep(cell)" v-if="canStep(cell)">
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
import axios from 'axios';

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
    });
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
      !cell.kind && this.game.current_gamer.user_id == this.user.id
    }
  },
  computed: {
    loadGame: function () {
      console.warn('load')
      axios
        .get('/games/'+ this.$route.params.id)
        .then(response => (
          this.game = response.data
        ))
    },
    loadCurrentUser: function () {
      axios
        .get('/users/current')
        .then(response => (
          this.user = response.data.user
        ))

    }
  }
}
</script>

