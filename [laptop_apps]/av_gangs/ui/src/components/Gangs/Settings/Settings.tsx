import {
  Image,
  Stack,
  Button,
  Group,
  Text,
  ColorPicker,
  TextInput,
  Flex,
  Popover,
  ColorSwatch,
} from "@mantine/core";
import { useRecoilState, useRecoilValue } from "recoil";
import { Gang, Lang } from "../../../reducers/atoms";
import { fetchNui } from "../../../hooks/useNuiEvents";
import classes from "./style.module.css";
import global from "../../../global.module.css";
import { useViewportSize } from "@mantine/hooks";

const Settings = () => {
  const lang: any = useRecoilValue(Lang);
  const [gang, setGang] = useRecoilState(Gang);
  const handleField = (field: string, value: any) => {
    setGang({ ...gang, [field]: value });
  };
  const { height } = useViewportSize();
  return (
    <Stack className={classes.card} p="md" w={300} ta="center" gap="xs">
      <Image
        src={gang.logo}
        h={height > 900 ? 155 : 110}
        w={height > 900 ? 155 : 110}
        fit="contain"
        fallbackSrc="gang_default.png"
        ml="auto"
        mr="auto"
      />
      <Stack gap="sm">
        <TextInput
          classNames={global}
          value={gang.logo}
          label={lang.gang_logo}
          placeholder={lang.image_url}
          size="xs"
          w={250}
          onChange={(e) => {
            handleField("logo", e.currentTarget.value);
          }}
          styles={{
            label: {
              fontWeight: 600,
            },
          }}
        />
        <TextInput
          classNames={global}
          value={gang.strain}
          label={lang.strain}
          size="xs"
          w={250}
          onChange={(e) => {
            handleField("strain", e.currentTarget.value);
          }}
          maxLength={20}
          styles={{
            label: {
              fontWeight: 600,
            },
          }}
        />
        <Group justify="center">
          <Flex direction="column" gap={4}>
            <Text fz="12px" fw={600}>
              {lang.gang_color}
            </Text>
            <Popover position="top-start" withArrow shadow="md">
              <Popover.Target>
                <ColorSwatch
                  ml="auto"
                  mr="auto"
                  color={gang.colors?.buttons ?? "var(--color-main)"}
                  withShadow={false}
                  style={{
                    border: "solid 2px rgba(255,255,255,1)",
                    cursor: "pointer",
                  }}
                  maw={10}
                />
              </Popover.Target>
              <Popover.Dropdown bg="rgba(30, 30, 36, 0.8)" p="xs">
                <ColorPicker
                  format="rgb"
                  value={gang.colors?.buttons ?? undefined}
                  onChange={(e) => {
                    const colors = gang.colors;
                    handleField("colors", {
                      ...colors,
                      buttons: e,
                    });
                  }}
                />
              </Popover.Dropdown>
            </Popover>
          </Flex>
          <Flex direction="column" gap={4}>
            <Text fz="12px" fw={600}>
              {lang.text_color}
            </Text>
            <Popover position="top-start" withArrow shadow="md">
              <Popover.Target>
                <ColorSwatch
                  ml="auto"
                  mr="auto"
                  color={gang.colors?.text ?? "var(--color-text)"}
                  withShadow={false}
                  style={{
                    border: "solid 2px rgba(255,255,255,1)",
                    cursor: "pointer",
                  }}
                  maw={10}
                />
              </Popover.Target>
              <Popover.Dropdown bg="rgba(30, 30, 36, 0.8)" p="xs">
                <ColorPicker
                  format="rgb"
                  value={gang.colors?.text ?? undefined}
                  onChange={(e) => {
                    const colors = gang.colors;
                    handleField("colors", {
                      ...colors,
                      text: e,
                    });
                  }}
                />
              </Popover.Dropdown>
            </Popover>
          </Flex>
        </Group>
        <Button
          className={global.button}
          w={250}
          size="xs"
          onClick={() => {
            fetchNui("av_gangs", "saveSettings", gang);
          }}
        >
          {lang.save_changes}
        </Button>
      </Stack>
    </Stack>
  );
};

export default Settings;
