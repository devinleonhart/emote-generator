<template>
  <div class="part-picker">
    <n-h3>{{ capitalize(partName) }}</n-h3>
    <n-radio-group v-model:value="selectedPart" @update:value="onChange" name="button-group">
      <n-space :vertical="isMobile" :size="8">
        <n-radio-button
          v-for="(part, index) in partSelection"
          :key="index"
          :value="part"
        >
          {{ part }}
        </n-radio-button>
      </n-space>
    </n-radio-group>
  </div>
</template>

<script lang="ts" setup>
import { ref, toRefs, watch, computed, onMounted } from "vue"
import { NH3, NRadioGroup, NRadioButton, NSpace } from "naive-ui"
import { storeToRefs } from "pinia"
import { useStore } from "../stores/emoteStore"
import { useResponsive } from "../composables"

const props = defineProps<{
    partName: string,
    partSelection: string[]
  }>()

const { partName, partSelection } = toRefs(props)

const store = useStore()
const selectedPart = ref<string>("")

// Use responsive composable
const { isMobile } = useResponsive()

// Get selectedParts from store
const { selectedParts } = storeToRefs(store)

// Initialize selectedPart with store value
onMounted(() => {
  const partValue = selectedParts.value[partName.value as keyof typeof selectedParts.value]
  if (partValue) {
    selectedPart.value = partValue
  }
})

// Watch for changes in selectedParts from store and update local state
watch(selectedParts, (newSelectedParts) => {
  const partValue = newSelectedParts[partName.value as keyof typeof newSelectedParts]
  if (partValue && partValue !== selectedPart.value) {
    selectedPart.value = partValue
  }
}, { deep: true })

// Watch for partSelection changes to handle initial load
watch(partSelection, (newPartSelection) => {
  // If we have parts and no selection yet, check if store has a value
  if (newPartSelection.length > 0 && !selectedPart.value) {
    const partValue = selectedParts.value[partName.value as keyof typeof selectedParts.value]
    if (partValue && newPartSelection.includes(partValue)) {
      selectedPart.value = partValue
    }
  }

  // Reset selection if current value is not in new selection
  const currentValue = selectedPart.value
  if (currentValue && !newPartSelection.includes(currentValue)) {
    selectedPart.value = ""
  }
})

function onChange(value: string) {
  store.selectPart(partName.value, value)
}

function capitalize(str: string): string {
  return str.charAt(0).toUpperCase() + str.slice(1)
}
</script>

<style scoped>
.part-picker {
  width: 100%;
}

/* Ensure radio buttons wrap properly on mobile */
@media (max-width: 768px) {
  .part-picker :deep(.n-radio-button) {
    flex: 1;
    min-width: 0;
  }
}
</style>
