<style>
body {
  background-color: #07290e;
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
