import type { EmoteConfig } from "./types/main.js"

export const allPartsPresent = (emoteConfig: EmoteConfig): boolean => {
  return (!!emoteConfig.character) &&
  (!!emoteConfig.head) &&
  (!!emoteConfig.eyebrows) &&
  (!!emoteConfig.eyes) &&
  (!!emoteConfig.mouth)
}
