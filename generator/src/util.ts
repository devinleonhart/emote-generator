export function capitalize (input:string):string {
  let capitalized = "";
  if(input.length > 1) {
    capitalized = input[0].toUpperCase() + input.slice(1);
  }
  else if (input.length === 1) {
    capitalized = input[0].toUpperCase();
  }
  return capitalized;
}

export function removeName (input:string):string {
  let nameRemoved = "";
  if(input.length > 0 && input.indexOf("_") > -1) {
    nameRemoved = input.split("_")[1];
  }
  return capitalize(nameRemoved);
}
