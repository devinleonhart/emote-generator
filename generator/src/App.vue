<script setup lang="ts">
import { NConfigProvider, NMessageProvider, NDialogProvider, NLoadingBarProvider } from "naive-ui"
import { darkTheme } from "naive-ui"
import EmoteLayout from "@/components/EmoteLayout.vue"
</script>

<template>
  <n-config-provider :theme="darkTheme">
    <n-message-provider>
      <n-dialog-provider>
        <n-loading-bar-provider>
          <div class="app-container">
            <EmoteLayout />
          </div>
        </n-loading-bar-provider>
      </n-dialog-provider>
    </n-message-provider>
  </n-config-provider>
</template>

<style>
.app-container {
  min-height: 100vh;
  color: #ffffff;
  padding: 20px;
}

body {
  background-color: #101014;
  margin: 0;
  font-family: 'Lato', -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', sans-serif;
}
</style>
