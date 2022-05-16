interface BlueprintCollection {
  [key: string]: Blueprint
}

interface Blueprint {
  character: string;
  head: string;
  eyes: string;
  eyebrows: string;
  mouth: string;
}

interface Part {
  key: string;
  name: string;
  src: Buffer;
}
