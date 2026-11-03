import { Group, ColorSwatch, rem } from "@mantine/core";
import { Check } from "lucide-react";
import { ColorsMapProps, ColorOption } from "./types";

export const ColorsMap = ({
  type,
  colors,
  selected,
  onSelect,
}: ColorsMapProps) => {
  return (
    <Group gap="sm">
      {colors.map((color: ColorOption, index: number) => (
        <ColorSwatch
          size={28}
          radius={4}
          key={index}
          component="button"
          color={color.color}
          onClick={() => {
            onSelect(type, color.name);
          }}
          style={{
            color: "#fff",
            cursor: "pointer",
            border: "1px solid rgba(255,255,255,0.1)",
          }}
        >
          {selected === color.name && (
            <Check style={{ width: rem(16), color: "#000" }} strokeWidth={3} />
          )}
        </ColorSwatch>
      ))}
    </Group>
  );
};
