export interface BlueprintCollection {
  [key: string]: Blueprint
}

export interface Blueprint {
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
