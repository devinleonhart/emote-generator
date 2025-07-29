<template>
  <section id="emote-preview">
    <figure class="box">
      <img
        :src="emoteURL"
        alt="Emote!"
      >
    </figure>
    <button
      class="button is-primary"
      :disabled="!emoteURL"
      @click="copyToClipboard"
    >
      Copy URL
    </button>
  </section>
</template>

<script lang="ts" setup>
import { storeToRefs } from "pinia"
import { useStore } from "../stores/emoteStore"

const store = useStore()
const { emoteURL } = storeToRefs(store)

function copyToClipboard() {
  navigator.clipboard.writeText(emoteURL.value)
}
</script>

<style>
</style>
