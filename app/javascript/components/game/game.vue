<template>
  <div class="">
    todo: xo table and actioncable
 </div>
</template>

<script>
module.exports = {
  channels: {
    GamesChannel: {
      connected() {
        console.log('I am connected.');
      },
      rejected() {},
      received(data) {
        console.log(data)
        console.log('newnew')
      },
      disconnected() {}
    }
  },
  mounted() {
    this.$cable.subscribe({
      channel: 'GamesChannel'
    });
  }
}
</script>

