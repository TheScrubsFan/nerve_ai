<template>
  <div class="">
    todo: new game button
    <button v-on:click="createGame()">NewGame</button>
 </div>
</template>

<script>
import axios from 'axios';

export default {
  methods: {
    createGame: function () {
      axios
        .post('/games')
        .then(response => (
          this.$router.push({name: 'game', params: { id: response.data.game.id }})
        ))
    }
  }
}
</script>

