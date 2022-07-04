import axios from "axios";
import { defineStore } from "pinia";
import settings from "../settings";

export const useStore = defineStore("main", {
  state: () => {
    return {
      blueprints: [] as string[],
      characters: [] as string[],
      emoteURL: "",
      parts: {} as Parts,
      selectedBlueprint: "",
      selectedCharacter: "",
      selectedParts: {} as SelectedParts
    };
  },
  actions: {
    buildEmoteURLWithBlueprint() {
      try {
        const searchParams = new URLSearchParams({character: this.selectedCharacter, ...{key: this.selectedBlueprint}});
        this.$state.emoteURL = `${settings.apiOptions.baseURL}/emote?${searchParams.toString()}`;
      } catch (error) {
        console.error(error);
      }
    },
    buildEmoteURLWithParts() {
      try {
        const searchParams = new URLSearchParams({character: this.selectedCharacter, ...this.$state.selectedParts});
        this.$state.emoteURL = `${settings.apiOptions.baseURL}/emote?${searchParams.toString()}`;
      } catch (error) {
        console.error(error);
      }
    },
    async fetchBlueprints() {
      try {
        const { data } = await axios.get("/blueprint");
        this.$state.blueprints = data;
        this.$state.characters = getCharactersFromBluePrints(data);
      } catch (error) {
        console.error(error);
      }
    },
    async fetchBlueprintsForCharacter(character: string) {
      try {
        const { data } = await axios.get(`/blueprint/${character}`);
        this.$state.blueprints = data;
        this.selectBlueprint(data[0]);
      } catch (error) {
        console.error(error);
      }
    },
    async fetchPartsForCharacter(character: string) {
      try {
        const { data } = await axios.get(`/part/${character}`);
        this.$state.parts = sortParts(data);
      } catch (error) {
        console.error(error);
      }
    },
    resetEmoteURL() {
      this.$state.emoteURL = "";
    },
    resetParts() {
      this.$state.selectedParts = {} as SelectedParts;
    },
    selectBlueprint(blueprint: string) {
      this.$state.selectedBlueprint = blueprint;
      this.buildEmoteURLWithBlueprint();
    },
    selectCharacter(character: string) {
      this.$state.selectedCharacter = character;
      this.fetchBlueprintsForCharacter(character);
      this.fetchPartsForCharacter(character);
    },
    selectPart(partName: string, part: string) {
      this.$state.selectedParts[partName as PartsKey] = part;
      // If all of the emote parts are selected, build the emote.
      if(this.$state.selectedParts.head &&
        this.$state.selectedParts.eyebrows &&
        this.$state.selectedParts.eyes &&
        this.$state.selectedParts.mouth) {
        this.buildEmoteURLWithParts();
      }
    }
  }
});

function getCharactersFromBluePrints(blueprints: string[]):string[] {
  const currentCharacters:string[] = [];
  blueprints.forEach((blueprint) => {
    const character = blueprint.split("_")[0];
    if(!currentCharacters.includes(character)) {
      currentCharacters.push(character);
    }
  });
  return currentCharacters;
}

function sortParts(parts: string[]):Parts {
  const currentParts:Parts = { head: [], eyebrows: [], eyes: [], mouth: [] };
  parts.forEach((part) => {
    const location = part.split("_")[1] as PartsKey;
    const description = part.split("_")[2].split(".")[0];
    currentParts[location].push(description);
  });
  return currentParts;
}
