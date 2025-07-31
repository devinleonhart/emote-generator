<template>
  <section id="emote-options">
    <n-space vertical :size="16">
      <n-form-item label="Character">
        <n-select
          v-model:value="state.sCharacter"
          filterable
          clearable
          :options="characterOptions"
          placeholder="Select a character"
          @update:value="onCharacterChange"
        />
      </n-form-item>



      <n-card v-if="selectedCharacter" title="Custom Parts" size="small">
        <n-space vertical :size="16">
          <part-picker
            :part-selection="parts.head || []"
            :part-name="'head'"
          />
          <part-picker
            :part-selection="parts.eyebrows || []"
            :part-name="'eyebrows'"
          />
          <part-picker
            :part-selection="parts.eyes || []"
            :part-name="'eyes'"
          />
          <part-picker
            :part-selection="parts.mouth || []"
            :part-name="'mouth'"
          />
        </n-space>
      </n-card>
    </n-space>
  </section>
</template>

<script lang="ts" setup>
import { reactive, toRefs, watch, computed } from "vue"
import { NFormItem, NSelect, NCard, NSpace } from "naive-ui"
import { storeToRefs } from "pinia"
import { useStore } from "../stores/emoteStore"
import { capitalize, removeName } from "../util"
import PartPicker from "./PartPicker.vue"

import type { Parts } from "../../types/main"

const props = defineProps<{
    characters: string[],
    parts: Parts,
  }>()

const { characters} = toRefs(props)

const state = reactive({
  sCharacter: "",
})

const store = useStore()

const { selectedCharacter } = storeToRefs(store)

// Convert arrays to select options
const characterOptions = computed(() =>
  characters.value.map(char => ({
    label: capitalize(char),
    value: char
  }))
)



// Watch for changes in selectedCharacter from store and update local state
watch(selectedCharacter, (newCharacter) => {
  if (newCharacter && newCharacter !== state.sCharacter) {
    state.sCharacter = newCharacter
  }
})

function onCharacterChange(value: string) {
  if(value && value !== "") {
    store.selectCharacter(value)
    store.resetEmoteURL()
    store.resetParts()
    resetRadioButtons()
  }
}

function resetRadioButtons() {
  const radios = document.querySelectorAll<HTMLInputElement>("input[type=\"radio\"]:checked")
  radios.forEach((radio) => {
    radio.checked = false
  })
}
</script>

<style scoped>
#emote-options {
  width: 100%;
}

/* Mobile optimizations */
@media (max-width: 768px) {
  #emote-options {
    padding: 0 8px;
  }
}
</style>
