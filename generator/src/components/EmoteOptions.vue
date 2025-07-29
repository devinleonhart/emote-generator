<template>
  <section id="emote-options">
    <div class="field">
      <label class="label">Character</label>
      <div class="select is-medium">
        <select
          v-model="state.sCharacter"
          @change="onCharacterChange"
        >
          <option
            v-for="(character, index) in characters"
            :key="index"
            :value="character"
          >
            {{ capitalize(character) }}
          </option>
        </select>
      </div>
    </div>

    <div class="field">
      <label class="label">Blueprint</label>
      <div class="select is-medium">
        <select
          v-model="state.sBlueprint"
          :disabled="!selectedCharacter"
          @change="onBlueprintChange"
        >
          <option
            v-for="(blueprint, index) in blueprints"
            :key="index"
            :value="blueprint"
          >
            {{ removeName(blueprint) }}
          </option>
        </select>
      </div>
    </div>

    <div
      v-if="selectedCharacter"
      class="box"
    >
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
    </div>
  </section>
</template>

<script lang="ts" setup>
import { reactive, toRefs, watch } from "vue"
import { storeToRefs } from "pinia"
import { useStore } from "../stores/emoteStore"
import { capitalize, removeName } from "../util"
import PartPicker from "./PartPicker.vue"

import type { Parts } from "../../types/main"

const props = defineProps<{
    blueprints: string[],
    characters: string[],
    parts: Parts,
  }>()

const { blueprints, characters} = toRefs(props)

const state = reactive({
  sCharacter: "",
  sBlueprint: "",
})

const store = useStore()

const { selectedCharacter } = storeToRefs(store)

watch(blueprints, async (newBlueprints) => {
  if (state.sCharacter !== "" && newBlueprints.length > 0) {
    state.sBlueprint = newBlueprints[0]
    store.selectBlueprint(state.sBlueprint)
  }
})

function onBlueprintChange(event:any) {
  if(event.target.value && event.target.value != "") {
    store.resetParts()
    resetRadioButtons()
    store.selectBlueprint(event.target.value)
  }
}

function onCharacterChange(event:any) {
  if(event.target.value && event.target.value != "") {
    store.selectCharacter(event.target.value)
    store.resetEmoteURL()
    store.resetParts()
    resetRadioButtons()
    state.sBlueprint=""
  }
}

function resetRadioButtons() {
  const radios = document.querySelectorAll<HTMLInputElement>("input[type=\"radio\"]:checked")
  radios.forEach((radio) => {
    radio.checked = false
  })
}

</script>

<style>
</style>
