interface ValuesInterface {
  height: number;
  value: number;
}

const allHeights: ValuesInterface[] = [
  { height: 400, value: 45 },
  { height: 640, value: 70 },
  { height: 700, value: 110 },
  { height: 800, value: 125 },
  { height: 870, value: 145 },
  { height: 935, value: 165 },
  { height: 950, value: 175 },
];

export const getExtraHeight = (height: number): number => {
  const match = [...allHeights]
    .sort((a, b) => b.height - a.height)
    .find((item) => item.height <= height);

  return match ? match.value : 0;
};
