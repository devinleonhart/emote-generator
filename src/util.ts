import type { EmoteConfig } from "./types/main"

export const allPartsPresent = (emoteConfig: EmoteConfig): boolean => {
  return (!!emoteConfig.character) &&
  (!!emoteConfig.head) &&
  (!!emoteConfig.eyebrows) &&
  (!!emoteConfig.eyes) &&
  (!!emoteConfig.mouth)
}
