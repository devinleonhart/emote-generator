<template>
  <form>
    <div class="control">
      <span>{{ partName }}</span>
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
import { toRefs } from "vue";
import { useStore } from "../stores/emoteStore";

const props = defineProps<{
    partName: string,
    partSelection: string[]
  }>();

const { partName, partSelection } = toRefs(props);

const store = useStore();

function onChange(event:any) {
  store.selectPart(partName.value, event.target.value);
}
</script>

<style lang="scss" scoped>
  form {
    margin: 1em 0;

    label {
      text-transform: capitalize;
      margin-right: .5em;
    }
  }
  span {
    display: block;
    font-size: large;
    &::first-letter {
      text-transform: capitalize;
    }
  }
</style>
