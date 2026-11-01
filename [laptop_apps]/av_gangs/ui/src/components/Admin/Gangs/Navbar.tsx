import { Stack, Text, ScrollArea, Button } from "@mantine/core";
import { SelectType } from "../../../types/types";
import global from "../../../global.module.css";
import { useRecoilValue } from "recoil";
import { Lang } from "../../../reducers/atoms";

interface Properties {
  current: string | null;
  gangs: SelectType[];
  setCurrent: (option: string) => void;
  handleRegister: () => void;
}

export const Navbar = ({
  gangs,
  current,
  setCurrent,
  handleRegister,
}: Properties) => {
  const { admin: lang }: any = useRecoilValue(Lang);
  return (
    <Stack
      bg="rgba(30, 30, 36, 0.5)"
      h={545}
      p="xs"
      style={{ borderRight: "solid 1.25px rgba(255, 255, 255, 0.1)" }}
    >
      <ScrollArea
        h={480}
        offsetScrollbars
        type="hover"
        scrollbars="y"
        scrollbarSize={5}
      >
        <Stack gap="xs">
          {gangs.map((gang) => (
            <Text
              fz="sm"
              truncate
              key={gang.value}
              fw={500}
              c={current == gang.value ? `var(--color-main)` : `gray.4`}
              onClick={() => {
                setCurrent(gang.value);
              }}
              style={{
                cursor: "pointer",
              }}
            >
              {gang.label}
            </Text>
          ))}
        </Stack>
      </ScrollArea>
      <Button className={global.button} size="xs" onClick={handleRegister}>
        {lang.register_button}
      </Button>
    </Stack>
  );
};
