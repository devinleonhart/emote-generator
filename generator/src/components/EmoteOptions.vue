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
            value=""
            selected
          />
          <option v-for="character in characters">
            {{ character }}
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
            value=""
            selected
          />
          <option v-for="blueprint in blueprints">
            {{ blueprint }}
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
import { reactive } from "vue";
import { storeToRefs } from "pinia";
import { useStore } from "../stores/emoteStore";
import PartPicker from "./PartPicker.vue";

const { blueprints, characters } = defineProps<{
    blueprints: string[],
    characters: string[],
    parts: Parts,
  }>();

const state = reactive({
  sCharacter: "",
  sBlueprint: "",
});

const store = useStore();

const { selectedCharacter } = storeToRefs(store);

function onBlueprintChange(event:any) {
  if(event.target.value && event.target.value != "") {
    store.resetParts();
    resetRadioButtons();
    store.selectBlueprint(event.target.value);
  }
}

function onCharacterChange(event:any) {
  if(event.target.value && event.target.value != "") {
    store.selectCharacter(event.target.value);
    store.resetEmoteURL();
    store.resetParts();
    resetRadioButtons();
    state.sBlueprint="";
  }
}

function resetRadioButtons() {
  const radios = document.querySelectorAll<HTMLInputElement>("input[type=\"radio\"]:checked");
  radios.forEach((radio) => {
    radio.checked = false;
  });
}

</script>

<style lang="scss" scoped>
  #emote-options {
    .select {
      width: 100%
    }
  }
</style>
