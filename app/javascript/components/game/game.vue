<style>
.game-wrapper {
  text-align: center;
	font-size: 32px;
  padding-top: 20px;
}
a {
  color: white;
  text-decoration: underline;
  cursor: pointer;
}
.field {
	font-size: 42px;
  color: rgba(255, 255, 255, 0.97);
}
.cell {
  width: 60px;
  height: 60px;
  border: 0px;
	cursor: pointer;
  background-color: transparent;
}
.cell:focus {
  outline:0;
}
.tablecell {
  height: 60px;
}
table {
  border-collapse: collapse;
  margin: auto;
  margin-top: 20px;
}
table td, table th {
  border: 3px solid rgba(255, 255, 255, 0.5);
  padding: 2px;
  min-width: 60px;
  min-height: 60px;
}
table tr:first-child td {
  border-top: 0;
}
table tr:last-child td {
  border-bottom: 0;
}
table tr td:first-child,
table tr th:first-child {
  border-left: 0;
}
table tr td:last-child,
table tr th:last-child {
  border-right: 0;
}
</style>

<template>
  <div class="game-wrapper">
    <div v-if="!game.gamers || game.gamers && game.gamers.length < 2">
      Чтобы начать игру - отправьте ссылку другому игроку
    </div>

    <div v-if="gameStarted()">
      <span v-if="canStep()">
        Ваш ход
      </span>

      <span v-if="!canStep()">
        Ход соперника
      </span>
    </div>

    <div v-if="gameOver()">
      <div v-if="youWinner()">
        Вы выиграли
      </div>
      <div v-if="!youWinner()">
        <div v-if="game.winner">
          Вы проиграли
        </div>
        <div v-if="!game.winner">
          Ничья. Ходы кончились
        </div>
      </div>
      <div>
        <a v-on:click="createGame()">Новая игра</a>
      </div>
    </div>

    <div>

    <table class="field" v-if="game.gamers && game.gamers.length == 2">
      <tr v-for="row in game.cells">
        <td v-for="cell in row">
          <div class="tablecell">
            <button class="cell" v-on:click="makeStep(cell)" v-if="canStepCell(cell)">
            </button>

            <span v-if="cell.kind">
              {{ cell.kind }}
            </span>
          </div>
        </td>
      </tr>
    </table>
    </div>
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
        this.game = data.game,
        this.blocked = false
      },
      disconnected() {}
    }
  },
  mounted() {
    this.$cable.subscribe({
      channel: 'GamesChannel',
      room: 'Game_' + this.$route.params.id
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
      user: {},
      blocked: false
    }
  },
  methods: {
    makeStep: function (cell) {
      if(!this.canStepCell(cell))
        return

      this.blocked = true
      let params = {
        cell: cell
      }
      let url = '/games/' + this.$route.params.id + '/make_step'

      axios
        .post(url, params)
    },

    canStepCell: function (cell) {
      return !this.blocked && !cell.kind && this.canStep()
    },

    canStep: function () {
      return this.game.state == 'started' &&
        this.game.current_gamer.user_id == this.user.id
    },

    youWinner: function () {
      return this.game.winner && this.game.winner.user.id == this.user.id
    },

    gameStarted: function () {
      return this.game.state == 'started' &&
        this.game.gamers &&
        this.game.gamers.length == 2
    },

    gameOver: function () {
      return this.game.state == 'finished'
    },

    createGame: function () {
      axios
        .post('/games')
        .then(response => (
          this.$router.push({name: 'game', params: { id: response.data.game.id }})
        ))
    }
  },
}
</script>

