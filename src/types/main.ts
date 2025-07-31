export interface EmoteConfig {
  character: string;
  head: string;
  eyes: string;
  eyebrows: string;
  mouth: string;
}

export interface Part {
  key: string;
  name: string;
  src: Buffer;
}
