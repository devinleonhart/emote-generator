<template>
  <form>
    <div class="control">
      <h1>{{ partName }}</h1>
      <label
        v-for="(part, index) in partSelection"
        :key="index"
        class="radio"
      >
        <input
          type="radio"
          :name="partName"
          :value="part"
          @change="onChange"
        >
        {{ part }}
      </label>
    </div>
  </form>
</template>

<script lang="ts" setup>
import { toRefs } from "vue"
import { useStore } from "../stores/emoteStore"

const props = defineProps<{
    partName: string,
    partSelection: string[]
  }>()

const { partName, partSelection } = toRefs(props)

const store = useStore()

function onChange(event:any) {
  store.selectPart(partName.value, event.target.value)
}
</script>

<style>
</style>
