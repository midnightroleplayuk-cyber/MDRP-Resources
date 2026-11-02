import {
  Box,
  Flex,
  Text,
  UnstyledButton,
  ScrollArea,
  Group,
  ActionIcon,
  Menu,
} from "@mantine/core";
import {
  LayoutGrid,
  Radio,
  Group as GroupIcon,
  Star,
  Webcam,
  BriefcaseBusiness,
  EllipsisVertical,
  Share,
  Trash2,
  SquarePen,
  ScanEye,
} from "lucide-react";
import { CameraType, SelectType } from "../../../types/types";
import { useAtomValue } from "jotai";
import { Lang } from "../../../reducers/atoms";
import classes from "./style.module.css";

interface Properties {
  allCameras: CameraType[];
  allGroups: SelectType[];
  filteredBy: string;
  handleFiltered: (type: string) => void;
  setModalData: React.Dispatch<
    React.SetStateAction<{ state: boolean; [key: string]: any }>
  >;
  handleRemoveGroup: (groupId: string) => void;
  handleAuth: (type: string, identifier: string) => void;
}

export const Sidebar = ({
  allGroups,
  allCameras,
  filteredBy,
  handleFiltered,
  handleRemoveGroup,
  handleAuth,
  setModalData,
}: Properties) => {
  const lang: any = useAtomValue(Lang);
  const quickAccessItems = [
    {
      id: "all",
      label: lang.all_cameras,
      icon: LayoutGrid,
      count: allCameras.length.toString().padStart(2, "0"),
    },
    {
      id: "live",
      label: lang.live_only,
      icon: Radio,
      count: allCameras
        .filter((c) => c.status === "live")
        .length.toString()
        .padStart(2, "0"),
    },
    {
      id: "vehicle",
      label: lang.vehicles,
      icon: Webcam,
      count: allCameras
        .filter((c) => c.type === "vehicle")
        .length.toString()
        .padStart(2, "0"),
    },
  ];

  const handleRename = (groupId: string) => {
    setModalData({
      state: true,
      info: {
        title: lang.rename_group,
        options: [
          {
            type: "text",
            name: "name",
            title: lang.new_group_name,
            max: 30,
          },
        ],
        extraData: {
          action: "rename",
          type: "group",
          identifier: groupId,
        },
        button: lang.confirm,
      },
    });
  };

  const handleShare = (groupId: string) => {
    setModalData({
      state: true,
      info: {
        title: lang.share_group,
        options: [
          {
            name: "playerId",
            type: "number",
            size: "xs",
            decimal: false,
            min: 1,
            max: 9999,
            title: lang.player_server_id_to_share_with,
            description: lang.player_id,
          },
          {
            name: "label",
            type: "text",
            size: "xs",
            max: 30,
            title: lang.display_name,
            description: lang.name,
          },
        ],
        button: lang.send,
        extraData: {
          action: "share",
          type: "group",
          identifier: groupId,
        },
      },
    });
  };

  return (
    <Flex className={classes.sidebar} direction="column" h="100%">
      <Box p="16px 12px 8px" style={{ flexShrink: 0 }}>
        <Text
          ff="var(--font-mono)"
          fz="xs"
          c="var(--text-dim)"
          lts={3}
          tt="uppercase"
          px={8}
          mb={8}
        >
          {lang.quick_access}
        </Text>

        {quickAccessItems.map((item) => {
          const Icon = item.icon;
          const isActive = filteredBy === item.id;

          return (
            <UnstyledButton
              key={item.id}
              className={`${classes.navItem} ${isActive ? classes.navItemActive : ""}`}
              onClick={() => handleFiltered(item.id)}
            >
              <Icon size={16} />
              {item.label}
              <Text
                className={`${classes.navBadge} ${isActive ? classes.navBadgeActive : ""}`}
              >
                {item.count}
              </Text>
            </UnstyledButton>
          );
        })}
      </Box>
      <Flex
        direction="column"
        p="16px 12px 8px"
        style={{ flex: 1, minHeight: 0 }}
      >
        <Group>
          <Text
            ff="var(--font-mono)"
            fz="xs"
            c="var(--text-dim)"
            lts={3}
            tt="uppercase"
            px={8}
            mb={8}
            style={{ flexShrink: 0 }}
          >
            {lang.groups}
          </Text>
          <Text
            className={classes.addGroupBtn}
            ff="var(--font-mono)"
            fz="xs"
            lts={3}
            tt="uppercase"
            ml="auto"
            px={8}
            mb={8}
            style={{ flexShrink: 0, cursor: "pointer" }}
            onClick={() => {
              setModalData({
                state: true,
                info: {
                  title: lang.create_group,
                  options: [
                    {
                      type: "text",
                      name: "name",
                      title: lang.group_name,
                      max: 30,
                    },
                  ],
                  extraData: {
                    action: "addGroup",
                  },
                  button: lang.confirm,
                },
              });
            }}
          >
            {lang.add}
          </Text>
        </Group>
        <ScrollArea
          style={{ flex: 1 }}
          scrollbarSize={4}
          offsetScrollbars
          type="hover"
          scrollHideDelay={100}
        >
          {allGroups.map((group) => {
            const isActive = filteredBy === group.value;
            return (
              <Group
                key={group.value}
                className={`${classes.navItem} ${isActive ? classes.navItemActive : ""}`}
                wrap="nowrap"
                onClick={() => handleFiltered(group.value)}
                style={{ cursor: "pointer" }}
              >
                <UnstyledButton className={classes.navItemName}>
                  <GroupIcon size={16} />
                  <Text fz="xs" ml="xs" fw={500}>
                    {group.label}
                  </Text>
                </UnstyledButton>
                {!group.server && group.owned && (
                  <>
                    <Menu
                      classNames={{
                        dropdown: "dropdown",
                        item: "item",
                      }}
                      shadow="md"
                      width={200}
                      position="right"
                      withinPortal
                    >
                      <Menu.Target>
                        <ActionIcon
                          variant="transparent"
                          color="gray"
                          size="sm"
                          onClick={(e) => {
                            e.stopPropagation();
                          }}
                        >
                          <EllipsisVertical size={16} color="var(--text-dim)" />
                        </ActionIcon>
                      </Menu.Target>
                      <Menu.Dropdown
                        onClick={(e) => {
                          e.stopPropagation();
                        }}
                      >
                        <Menu.Item
                          leftSection={<SquarePen size={14} />}
                          onClick={() => handleRename(group.value)}
                        >
                          {lang.rename}
                        </Menu.Item>
                        <Menu.Item
                          leftSection={<Share size={14} />}
                          onClick={() => handleShare(group.value)}
                        >
                          {lang.share}
                        </Menu.Item>
                        <Menu.Item
                          leftSection={<ScanEye size={14} />}
                          onClick={() => handleAuth("group", group.value)}
                        >
                          {lang.manage_access}
                        </Menu.Item>
                        <Menu.Item
                          leftSection={<Trash2 size={14} />}
                          color="red"
                          onClick={() => handleRemoveGroup(group.value)}
                        >
                          {lang.delete}
                        </Menu.Item>
                      </Menu.Dropdown>
                    </Menu>
                  </>
                )}
              </Group>
            );
          })}
        </ScrollArea>
      </Flex>
    </Flex>
  );
};
