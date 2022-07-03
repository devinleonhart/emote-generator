<template>
  <div
    id="emote-generator"
    class="container"
  >
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
import { storeToRefs } from "pinia";
import { useStore } from "../stores/emoteStore";
import EmoteOptions from "./EmoteOptions.vue";
import EmotePreview from "./EmotePreview.vue";

const store = useStore();
const { blueprints, characters, parts } = storeToRefs(store);

// Initial population of blueprints.
store.fetchBlueprints();

// If all the parts are selected, we can build an emote.
store.$subscribe((mutation, state) => {
  if(["head", "eyes", "eyebrows", "mouth"].includes(mutation.events.key)) {
    if(state.selectedParts.head &&
         state.selectedParts.eyebrows &&
         state.selectedParts.eyes &&
         state.selectedParts.mouth) {
      store.buildEmoteURLWithParts();
    }
  }
});

</script>

<style lang="scss">
  #emote-generator {
    color: #DDD;

    label {
      text-align: left;
    }

    select {
      width: 100%
    }

    section {
      padding: 2em;
    }

    // Bulma Override
    label {
      color: #DDD !important;
      &.radio:hover {
        color: #FFF !important;
      }
    }
  }
</style>
