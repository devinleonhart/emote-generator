<template>
  <div id="emote-generator">
    <n-card title="Emote Generator" class="main-card">
      <n-grid :cols="gridCols" :x-gap="24" :y-gap="24">
        <!-- Emote Preview - appears first on mobile -->
        <n-grid-item :span="isMobile ? 1 : 1" class="preview-item">
          <emote-preview />
        </n-grid-item>

        <!-- Emote Options - appears second on mobile -->
        <n-grid-item :span="isMobile ? 1 : 1" class="options-item">
          <emote-options
            :characters="characters"
            :parts="parts"
          />
        </n-grid-item>
      </n-grid>
    </n-card>
  </div>
</template>

<script lang="ts" setup>
import { NCard, NGrid, NGridItem } from "naive-ui"
import { storeToRefs } from "pinia"
import { useStore } from "@/stores/emoteStore"
import { useResponsive } from "@/composables"
import EmoteOptions from "@/components/EmoteOptions.vue"
import EmotePreview from "@/components/EmotePreview.vue"

const store = useStore()
const { characters, parts } = storeToRefs(store)

// Use responsive composable
const { isMobile, gridCols } = useResponsive()

// Initial population of characters.
store.fetchCharacters()
</script>

<style scoped>
.main-card {
  max-width: 1200px;
  margin: 0 auto;
  padding: 16px;
}

#emote-generator {
  width: 100%;
}

.preview-item {
  order: 1; /* Preview appears first on mobile */
}

.options-item {
  order: 2; /* Options appear second on mobile */
}

/* Desktop layout adjustments */
@media (min-width: 769px) {
  .preview-item {
    order: 2; /* Preview appears second on desktop */
  }

  .options-item {
    order: 1; /* Options appear first on desktop */
  }
}
</style>
