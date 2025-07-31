<template>
  <section id="emote-preview">
    <n-space vertical :size="16" align="center">
      <n-card title="Preview" size="small">
        <div class="preview-container">
          <img
            v-if="emoteURL"
            :src="emoteURL"
            alt="Emote!"
            class="emote-image"
          >
          <n-empty v-else description="No emote selected" />
        </div>
      </n-card>

      <n-button
        type="primary"
        :disabled="!emoteURL"
        @click="copyToClipboard"
        size="large"
      >
        Copy URL
      </n-button>
    </n-space>
  </section>
</template>

<script lang="ts" setup>
import { NCard, NButton, NSpace, NEmpty } from "naive-ui"
import { storeToRefs } from "pinia"
import { useStore } from "../stores/emoteStore"

const store = useStore()
const { emoteURL } = storeToRefs(store)

function copyToClipboard() {
  if (emoteURL.value) {
    navigator.clipboard.writeText(emoteURL.value)
    // You can add a success message here using the message API
  }
}
</script>

<style scoped>
.preview-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 200px;
  padding: 16px;
}

.emote-image {
  max-width: 100%;
  max-height: 300px;
  object-fit: contain;
}

#emote-preview {
  width: 100%;
}

/* Mobile optimizations */
@media (max-width: 768px) {
  .preview-container {
    min-height: 150px;
    padding: 8px;
  }

  .emote-image {
    max-height: 200px;
  }
}
</style>
