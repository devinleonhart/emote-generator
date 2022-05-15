
export const allPartsPresent = (blueprint: Blueprint): boolean => {
  return (!!blueprint.character) &&
    (!!blueprint.head) &&
    (!!blueprint.eyebrows) &&
    (!!blueprint.eyes) &&
    (!!blueprint.mouth);
};
