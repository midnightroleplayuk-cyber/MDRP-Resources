import { useState } from "react";
import {
  Box,
  Group,
  Button,
  Text,
  TextInput,
  Grid,
  Card,
  ScrollArea,
  Stack,
  ActionIcon,
  Tooltip,
} from "@mantine/core";
import { IconCopy, IconGps, IconMapPinShare } from "@tabler/icons-react";
import { Search } from "../Search";
import { fetchNui, isEnvBrowser } from "../../hooks/useNuiEvents";
import { DemoUser } from "../../API/labData";
import { useRecoilValue } from "recoil";
import { Lang } from "../../reducers/atoms";
import classes from "../style.module.css";

export const Players = () => {
  const { admin: lang }: any = useRecoilValue(Lang);
  const [player, setPlayer] = useState<any>(isEnvBrowser() ? DemoUser : {});
  const [sum, setSum] = useState("");
  const iconStyle = { width: "14px", height: "14px" };
  const handleCallback = (data: any) => {
    if (data) {
      setPlayer(data);
    }
  };
  const handleWipe = (type: string) => {
    fetchNui("av_drugs", "productWipe", {
      type,
      identifier: player.identifier,
    });
    if (type == "all") {
      setPlayer({});
      return;
    }
    const copy = { ...player, [type]: {} };
    setPlayer(copy);
  };
  return (
    <Box p="sm">
      <Search
        name={lang.player}
        type={"player"}
        event={"getPlayer"}
        cb={handleCallback}
      />
      {player && player.identifier && (
        <Box
          p="sm"
          mt="xs"
          style={{
            border: "solid 1.25px rgba(255,255,255,0.1)",
            borderRadius: "4px",
          }}
        >
          <Group>
            <Group gap="xs">
              <Text
                fz="sm"
                fw={600}
                style={{ cursor: "pointer" }}
              >{`${player.identifier}`}</Text>
              <ActionIcon
                size="xs"
                variant="transparent"
                onClick={() => {
                  fetchNui("av_drugs", "copy", player.identifier);
                }}
              >
                <IconCopy style={iconStyle} />
              </ActionIcon>
            </Group>
            <Group ml="auto">
              <TextInput
                classNames={classes}
                placeholder="2+2=?"
                size="xs"
                onChange={(e) => {
                  setSum(e.target.value);
                }}
              />
              <Button
                size="xs"
                color="red.9"
                disabled={sum !== "4"}
                onClick={() => {
                  handleWipe("all");
                }}
              >
                {lang.wipe_player}
              </Button>
            </Group>
          </Group>
          <Grid mt="sm">
            <Grid.Col span={4}>
              <Card className={classes.card} p="xs">
                <Group>
                  <Text fw={500} fz="md">
                    {lang.tables_tab}
                  </Text>
                  <Tooltip label={lang.double_click} fz="xs" color="dark.4">
                    <Button
                      size="xs"
                      variant="subtle"
                      ml="auto"
                      color="red"
                      onDoubleClick={() => {
                        handleWipe("tables");
                      }}
                    >
                      {lang.wipe_tables}
                    </Button>
                  </Tooltip>
                </Group>
                <ScrollArea
                  h={300}
                  type="hover"
                  scrollbars="y"
                  offsetScrollbars
                  scrollbarSize={7}
                  mt="sm"
                >
                  <Stack>
                    {player?.tables &&
                      Object.keys(player.tables).map((drugKey: any) => (
                        <Group gap="xs" key={drugKey}>
                          <Text fz="xs">{drugKey}</Text>
                          <Tooltip label={lang.copy} fz="xs" color="dark.4">
                            <ActionIcon
                              ml="auto"
                              size="xs"
                              variant="transparent"
                              onClick={() => {
                                fetchNui("av_drugs", "copy", drugKey);
                              }}
                            >
                              <IconCopy style={iconStyle} />
                            </ActionIcon>
                          </Tooltip>
                          <Tooltip label={lang.waypoint} fz="xs" color="dark.4">
                            <ActionIcon
                              size="xs"
                              variant="transparent"
                              onClick={() => {
                                fetchNui("av_drugs", "productAction", {
                                  type: "table",
                                  identifier: drugKey,
                                  action: "waypoint",
                                });
                              }}
                            >
                              <IconGps style={iconStyle} />
                            </ActionIcon>
                          </Tooltip>
                          <Tooltip label={lang.teleport} fz="xs" color="dark.4">
                            <ActionIcon
                              size="xs"
                              variant="transparent"
                              onClick={() => {
                                fetchNui("av_drugs", "productAction", {
                                  type: "table",
                                  identifier: drugKey,
                                  action: "teleport",
                                });
                              }}
                            >
                              <IconMapPinShare style={iconStyle} />
                            </ActionIcon>
                          </Tooltip>
                        </Group>
                      ))}
                  </Stack>
                </ScrollArea>
              </Card>
            </Grid.Col>
            <Grid.Col span={4}>
              <Card className={classes.card} p="xs">
                <Group>
                  <Text fw={500} fz="md">
                    {lang.labs_tab}
                  </Text>
                  <Tooltip label={lang.double_click} fz="xs" color="dark.4">
                    <Button
                      size="xs"
                      variant="subtle"
                      ml="auto"
                      color="red"
                      onDoubleClick={() => {
                        handleWipe("labs");
                      }}
                    >
                      {lang.wipe_labs}
                    </Button>
                  </Tooltip>
                </Group>
                <ScrollArea
                  h={300}
                  type="hover"
                  scrollbars="y"
                  offsetScrollbars
                  scrollbarSize={7}
                  mt="sm"
                >
                  <Stack>
                    {player?.labs &&
                      Object.keys(player.labs).map((drugKey: any) => (
                        <Group gap="xs" key={drugKey}>
                          <Text fz="xs">{drugKey}</Text>
                          <Tooltip label={lang.copy} fz="xs" color="dark.4">
                            <ActionIcon
                              ml="auto"
                              size="xs"
                              variant="transparent"
                              onClick={() => {
                                fetchNui("av_drugs", "copy", drugKey);
                              }}
                            >
                              <IconCopy style={iconStyle} />
                            </ActionIcon>
                          </Tooltip>
                          <Tooltip label={lang.waypoint} fz="xs" color="dark.4">
                            <ActionIcon
                              size="xs"
                              variant="transparent"
                              onClick={() => {
                                fetchNui("av_drugs", "productAction", {
                                  type: "lab",
                                  identifier: drugKey,
                                  action: "waypoint",
                                });
                              }}
                            >
                              <IconGps style={iconStyle} />
                            </ActionIcon>
                          </Tooltip>
                          <Tooltip label={lang.teleport} fz="xs" color="dark.4">
                            <ActionIcon
                              size="xs"
                              variant="transparent"
                              onClick={() => {
                                fetchNui("av_drugs", "productAction", {
                                  type: "lab",
                                  identifier: drugKey,
                                  action: "teleport",
                                });
                              }}
                            >
                              <IconMapPinShare style={iconStyle} />
                            </ActionIcon>
                          </Tooltip>
                        </Group>
                      ))}
                  </Stack>
                </ScrollArea>
              </Card>
            </Grid.Col>
            <Grid.Col span={4}>
              <Card className={classes.card} p="xs">
                <Group>
                  <Text fw={500} fz="md">
                    {lang.drugsxp}
                  </Text>
                  <Tooltip label={lang.double_click} fz="xs" color="dark.4">
                    <Button
                      size="xs"
                      variant="subtle"
                      ml="auto"
                      color="red"
                      onDoubleClick={() => {
                        handleWipe("drugs");
                      }}
                    >
                      {lang.wipe_drugs}
                    </Button>
                  </Tooltip>
                </Group>
                <ScrollArea
                  h={300}
                  type="hover"
                  scrollbars="y"
                  offsetScrollbars
                  scrollbarSize={7}
                  mt="sm"
                >
                  <Stack>
                    {player?.drugs &&
                      Object.keys(player.drugs).map((drugKey: any) => (
                        <Group gap="xs">
                          <Text
                            fz="xs"
                            fw={500}
                          >{`${player.drugs[drugKey].label}:`}</Text>
                          <Text fz="xs">{`xp: ${
                            player.drugs[drugKey].xp
                              ? player.drugs[drugKey].xp
                              : 0
                          }, ${lang.sold}: ${
                            player.drugs[drugKey].sold
                              ? player.drugs[drugKey].sold
                              : 0
                          }, ${lang.income}: $${
                            player.drugs[drugKey].income
                              ? player.drugs[drugKey].income
                              : 0
                          }`}</Text>
                        </Group>
                      ))}
                  </Stack>
                </ScrollArea>
              </Card>
            </Grid.Col>
          </Grid>
        </Box>
      )}
    </Box>
  );
};
