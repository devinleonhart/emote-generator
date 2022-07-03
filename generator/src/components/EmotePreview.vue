<template>
  <section id="emote-preview">
    <figure class="box">
      <img :src="emoteURL" alt="Emote!" />
    </figure>
     <button
        class="button is-primary"
        @click="copyToClipboard"
        :disabled="!emoteURL"
      >
        Copy URL
      </button>
  </section>
</template>

<script lang="ts" setup>
  import { storeToRefs } from 'pinia';
  import { useStore } from '../stores/emoteStore';

  const store = useStore()
  const { emoteURL } = storeToRefs(store)

  function copyToClipboard() {
    navigator.clipboard.writeText(emoteURL.value);
  }
</script>

<style lang="scss" scoped>
  #emote-preview {
    text-align: center;

    figure {
      display: flex;
      align-items: center;
      justify-content: center;
      height: 400px;
      border: 1px solid #EEE;
      border-radius: 5px;
      margin-bottom: 2em;
    }
  }
</style>
