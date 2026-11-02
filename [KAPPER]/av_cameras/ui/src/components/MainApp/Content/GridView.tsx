import {
  Box,
  Image,
  Text,
  Button,
  ActionIcon,
  Group,
  Menu,
  Divider,
} from "@mantine/core";
import { CameraType, SelectType } from "../../../types/types";
import {
  EllipsisVertical,
  FolderOutput,
  Share,
  SquarePen,
  Trash2,
  Group as GroupIcon,
  HardDrive,
  BatteryFull,
  BatteryMedium,
  BatteryLow,
  BatteryWarning,
} from "lucide-react";
import { useAtomValue } from "jotai";
import { isBoss, Lang } from "../../../reducers/atoms";
import classes from "./grid.module.css";

interface Properties {
  filtered: CameraType[];
  allGroups: SelectType[];
  handleConnection: (camera: CameraType) => void;
  handleRename: (camera: CameraType) => void;
  handleSendToGroup: (cameraGroup: string, targetGroup: string) => void;
  handleShare: (identifier: string) => void;
  handleRemove: (identifier: string) => void;
  handleAccessMemory: (identifier: string) => void;
}

const BatteryIndicator = ({
  battery,
  isOffline,
}: {
  battery: number;
  isOffline: boolean;
}) => {
  let Icon = BatteryFull;
  let color = "var(--success, #4ade80)";

  if (isOffline) {
    color = "var(--text-dim, #94a3b8)";
  } else if (battery <= 15) {
    Icon = BatteryWarning;
    color = "var(--danger, #f87171)";
  } else if (battery <= 45) {
    Icon = BatteryLow;
    color = "var(--orange, #ff7022)";
  } else if (battery <= 80) {
    Icon = BatteryMedium;
    color = "var(--yellow, #fab005)";
  }

  return (
    <Group
      gap={4}
      wrap="nowrap"
      style={{
        backgroundColor: "rgba(0, 0, 0, 0.1)",
        backdropFilter: "blur(4px)",
        padding: "4px 8px",
        borderRadius: "var(--border-radius-base, 8px)",
        border: "1px solid rgba(255, 255, 255, 0.1)",
      }}
    >
      <Icon size={14} color={color} strokeWidth={2.5} />
      <Text fz={11} fw={700} c={color} ff="var(--font-display)">
        {battery}%
      </Text>
    </Group>
  );
};

const GridView = ({
  filtered,
  allGroups,
  handleConnection,
  handleRename,
  handleSendToGroup,
  handleShare,
  handleRemove,
  handleAccessMemory,
}: Properties) => {
  const lang: any = useAtomValue(Lang);
  const boss = useAtomValue(isBoss);

  const getAvailableGroups = (camera: CameraType) =>
    allGroups.filter((g) => {
      if (g.value === camera.group_id) return false;
      if (g.type === "server" || g.server) return false;
      if (g.type === "business" && !boss) return false;
      return true;
    });

  return (
    <Box className={classes.camGrid}>
      {filtered.map((camera) => {
        const isOffline = camera.status === "offline";
        const availableGroups = getAvailableGroups(camera);
        return (
          <Box key={camera.identifier} className={classes.camCard}>
            <Box className={classes.camThumb}>
              <Image
                src={camera.thumbnail}
                alt={camera.label}
                style={{
                  filter: isOffline ? "grayscale(1) opacity(0.25)" : "none",
                }}
                fallbackSrc="./thumbnail.jpg"
              />
              <Box
                className={`${classes.camStatusBadge} ${
                  isOffline ? classes.offline : classes.live
                }`}
              >
                {isOffline ? lang.offline : lang.online}
              </Box>
              <Box className={classes.camOverlayInfo}>
                <BatteryIndicator
                  battery={camera.battery ?? 0}
                  isOffline={isOffline}
                />
              </Box>
            </Box>
            <Box className={classes.camBody} pl="sm" pt="sm" pb="sm">
              <Box className={classes.camInfo}>
                <Text className={classes.camName}>{camera.label}</Text>
                <Text className={classes.camLoc}>{camera.location}</Text>
              </Box>
              <Group gap={1}>
                <Button
                  className={`${classes.camConnectBtn} ${
                    isOffline ? classes.offlineBtn : ""
                  }`}
                  disabled={isOffline}
                  onClick={() => handleConnection(camera)}
                >
                  {isOffline ? lang.no_signal : lang.connect}
                </Button>
                <Menu
                  classNames={{
                    dropdown: "dropdown",
                    item: "item",
                  }}
                  position="right-end"
                  offset={0}
                >
                  <Menu.Target>
                    <ActionIcon
                      variant="transparent"
                      color="gray.6"
                      ml="auto"
                      disabled={isOffline}
                      bg={"transparent"}
                    >
                      <EllipsisVertical size={16} />
                    </ActionIcon>
                  </Menu.Target>
                  <Menu.Dropdown>
                    {camera.type !== "server" && camera.owned && (
                      <>
                        <Menu.Item
                          leftSection={<SquarePen size={14} />}
                          onClick={() => handleRename(camera)}
                        >
                          {lang.rename}
                        </Menu.Item>
                        <Menu.Item
                          leftSection={<Share size={14} />}
                          onClick={() => handleShare(camera.identifier)}
                        >
                          {lang.share}
                        </Menu.Item>
                      </>
                    )}
                    {camera.owned && availableGroups.length > 0 && (
                      <Menu.Sub
                        openDelay={120}
                        closeDelay={150}
                        position="right-end"
                      >
                        <Menu.Sub.Target>
                          <Menu.Sub.Item
                            leftSection={<FolderOutput size={14} />}
                          >
                            {lang.send_to_group}
                          </Menu.Sub.Item>
                        </Menu.Sub.Target>
                        <Menu.Sub.Dropdown
                          miw={120}
                          mah={255}
                          style={{ overflowY: "auto" }}
                        >
                          {availableGroups.map((targetGroup) => (
                            <Menu.Item
                              key={targetGroup.value}
                              fz="xs"
                              onClick={() =>
                                handleSendToGroup(
                                  camera.identifier,
                                  targetGroup.value,
                                )
                              }
                            >
                              {targetGroup.label}
                            </Menu.Item>
                          ))}
                        </Menu.Sub.Dropdown>
                      </Menu.Sub>
                    )}
                    <Menu.Item
                      leftSection={<HardDrive size={14} />}
                      color="var(--accent)"
                      onClick={() => handleAccessMemory(camera.identifier)}
                    >
                      {lang.access_memory}
                    </Menu.Item>
                    {camera.type !== "server" && camera.owned && (
                      <>
                        <Divider />
                        {camera.group_id && (
                          <Menu.Item
                            leftSection={<GroupIcon size={14} />}
                            color="red"
                            onClick={() =>
                              handleSendToGroup(camera.identifier, "none")
                            }
                          >
                            {lang.remove_from_group}
                          </Menu.Item>
                        )}
                        <Menu.Item
                          leftSection={<Trash2 size={14} />}
                          color="red"
                          onClick={() => handleRemove(camera.identifier)}
                        >
                          {lang.delete}
                        </Menu.Item>
                      </>
                    )}
                  </Menu.Dropdown>
                </Menu>
              </Group>
            </Box>
          </Box>
        );
      })}
    </Box>
  );
};

export default GridView;
