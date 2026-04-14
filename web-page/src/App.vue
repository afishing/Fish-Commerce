<template>
  <router-view />
  <PetWidget />
</template>

<script setup>
import PetWidget from '@/components/PetWidget.vue'
</script>

<style>
html, body, #app {
  margin: 0;
  padding: 0;
  width: 100%;
  height: 100%;
}

* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}
</style>
