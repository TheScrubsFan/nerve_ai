<template>
  <div class="">
    todo: new game button
    <button v-on:click="createGame()">NewGame</button>
 </div>
</template>

<script>
module.exports = {
  methods: {
    createGame: function () {
      console.log(this.$router)
      this.$router.push({name: 'game'})
    }
  }
}
</script>

