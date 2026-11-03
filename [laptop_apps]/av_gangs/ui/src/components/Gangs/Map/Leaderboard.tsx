import { ScrollArea, Stack, Image, Text, Group, Flex } from "@mantine/core";
import { IconCrown } from "@tabler/icons-react";
import { GangStats } from "../../../types/types";
import classes from "./style.module.css";
import { useRecoilValue } from "recoil";
import { Lang } from "../../../reducers/atoms";

interface Properties {
  gangs: GangStats[];
  current: string | null;
  handleCurrent: (gang: string | null) => void;
}

export const Leaderboard = ({ gangs, current, handleCurrent }: Properties) => {
  const lang: any = useRecoilValue(Lang);
  return (
    <ScrollArea
      className={classes.scroll}
      offsetScrollbars
      type="hover"
      scrollbars="y"
      scrollbarSize={5}
    >
      <Stack gap="xs">
        {gangs.map((gang, index) => (
          <Group
            className={classes.card}
            bg={current === gang.name ? `rgba(40, 40, 46, 0.75)` : undefined}
            key={gang.gangLabel}
            p="md"
            onClick={() => {
              if (current === gang.name) {
                handleCurrent(null);
              } else {
                handleCurrent(gang.name);
              }
            }}
          >
            <Image
              src={gang.logo}
              fallbackSrc="gang_default.png"
              h={50}
              w={50}
              fit="contain"
            />
            <Flex direction="column" w="77%">
              <Group>
                <Text c="white" maw={230} truncate>
                  {gang.gangLabel}
                </Text>
                {index === 0 && (
                  <IconCrown
                    style={{
                      height: "20px",
                      width: "20px",
                      marginLeft: "auto",
                    }}
                    stroke={1.5}
                    color="#ffd43b"
                  />
                )}
              </Group>
              <Group justify="space-between">
                <Flex direction="column">
                  <Text fz="sm" c="gray.4">
                    {gang.controlledZones}
                  </Text>
                  <Text fz="xs" c="dimmed">
                    {lang.controlled_zones}
                  </Text>
                </Flex>
                <Flex direction="column">
                  <Text fz="sm" c="gray.4">
                    {gang.totalPoints}
                  </Text>
                  <Text fz="xs" c="dimmed">
                    {lang.total_points}
                  </Text>
                </Flex>
              </Group>
            </Flex>
          </Group>
        ))}
      </Stack>
    </ScrollArea>
  );
};
