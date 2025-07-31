<template>
  <div
    id="emote-generator"
    class="container"
  >
    <h1 class="title">Cheese</h1>
    <div class="columns is-centered">
      <emote-options
        class="column is-half"
        :blueprints="blueprints"
        :characters="characters"
        :parts="parts"
      />

      <emote-preview
        class="column is-half"
      />
    </div>
  </div>
</template>

<script lang="ts" setup>
import { storeToRefs } from "pinia"
import { useStore } from "../stores/emoteStore"
import EmoteOptions from "./EmoteOptions.vue"
import EmotePreview from "./EmotePreview.vue"

const store = useStore()
const { blueprints, characters, parts } = storeToRefs(store)

// Initial population of blueprints.
store.fetchBlueprints()

</script>

<style>

</style>
