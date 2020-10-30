<style>
body {
  background-color: #051d0a;
	color: #ffffff;
}
</style>

<template>
  <div id="app">
    <router-view :key="$route.fullPath"></router-view>
  </div>
</template>

<script>
export default {}
</script>
