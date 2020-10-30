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
    <table>
      <tr v-for="row in game.cells">
        <td v-for="cell in row">
          <button v-on:click="makeStep(cell)">
            {{ cell.kind }}
          </button>
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
        console.log(data),
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
      game: {}
    }
  },
  methods: {
    makeStep: function (cell) {
      console.log(cell)
      let params = {
        cell: cell
      }
      let url = '/games/' + this.$route.params.id + '/make_step'
      axios
        .post(url, params)
    }
  },
  computed: {
    loadGame: function () {
      axios
        .get('/games/'+ this.$route.params.id)
        .then(response => (
          this.game = response.data
        ))
    }
  }
}
</script>

