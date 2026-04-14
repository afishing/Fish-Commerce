<template>
  <div class="admin-monitor">
    <iframe 
      src="http://localhost:8080" 
      width="100%" 
      height="100%" 
      frameborder="0"
    />
  </div>
</template>

<script setup>
// 系统监控页面 - 嵌入 Spring Boot Admin
</script>

<style scoped>
.admin-monitor {
  width: 100%;
  height: calc(100vh - 60px);
  overflow: hidden;
}

.admin-monitor iframe {
  width: 100%;
  height: 100%;
  border: none;
  display: block;
}
</style>