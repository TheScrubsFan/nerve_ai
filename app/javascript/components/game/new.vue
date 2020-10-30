<style>
.new-game {
  border: 0px;
  background-color: transparent;
	display: inline-block;
	cursor: pointer;
	color: #ffffff;
	font-family: Arial;
	font-size: 42px;
	font-weight: bold;
	font-style: italic;
	padding: 9px 23px;
	text-decoration: none;
	text-shadow: 0px -1px 0px #7a2a1d;
}
.new-game:focus {
  border: 0px;
}
.wrapper {
  align-items: center;
  justify-content: center;
  display: flex;
  height: 600px;
  position: relative;
}
</style>

<template>
  <div class="wrapper">
    <button class="new-game" v-on:click="createGame()">
      NewGame
    </button>
 </div>
</template>

<script>
import axios from 'axios'

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

