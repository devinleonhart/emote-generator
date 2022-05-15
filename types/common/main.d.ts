interface AvailableEmoteParts {
  [key: string]: string[];
  head: string[];
  eyes: string[];
  eyebrows: string[];
  mouth: string[];
}

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

interface EmoteParts {
  [key: string]: string;
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

interface QueryParams {
  [key: string]: string;
}

interface SelectedParts {
  [key: string]: string | null;
  head: string | null;
  eyes: string | null;
  eyebrows: string | null;
  mouth: string | null;
}
