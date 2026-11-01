import { useState } from "react";
import {
  Stack,
  ActionIcon,
  Group,
  Text,
  PasswordInput,
  Tooltip,
  ScrollArea,
} from "@mantine/core";
import { fetchNui, useNuiEvent } from "../../../hooks/useNuiEvents";
import { GroupType } from "../../../types/types";
import {
  IconSearch,
  IconCirclePlus,
  IconUsersGroup,
  IconCopy,
  IconTrash,
  IconCrown,
} from "@tabler/icons-react";
import { useRecoilValue } from "recoil";
import { Gang, Identifier, Lang } from "../../../reducers/atoms";
import classes from "./style.module.css";
import global from "../../../global.module.css";

const iconStyle = { height: "14px", width: "14px" };

interface Properties {
  myCrew: GroupType | null;
  setMyCrew: (crew: GroupType | null) => void;
}

export const Crew = ({ myCrew, setMyCrew }: Properties) => {
  const lang: any = useRecoilValue(Lang);
  const myIdentifier = useRecoilValue(Identifier);
  const { name } = useRecoilValue(Gang);
  const [input, setInput] = useState("");
  useNuiEvent("setCrew", (data: GroupType | null) => {
    setMyCrew(data);
  });

  const handleNew = async () => {
    const resp = await fetchNui("av_gangs", "newCrew", name);
    if (resp) setMyCrew(resp);
  };

  const handleRemove = (identifier: string) => {
    fetchNui("av_gangs", "removeCrewMember", {
      crew: myCrew?.identifier,
      identifier,
    });
  };

  const handleDelete = () => {
    fetchNui("av_gangs", "deleteCrew", myCrew?.identifier);
    setInput("");
  };
  return (
    <Stack className={classes.card} p="sm" gap="xs">
      <Text ta="center" c="white" ff="Bebas Neue" lts={2} fz="1.5rem">
        {lang.mission_crew}
      </Text>
      {myCrew ? (
        <>
          {myCrew.owner === myIdentifier && (
            <Group gap="xs">
              <PasswordInput
                classNames={global}
                size="xs"
                w={170}
                value={myCrew.identifier}
              />
              <Group gap="xs">
                <Tooltip
                  label={lang.copy_share}
                  color="dark.5"
                  fz="xs"
                  position="top-start"
                  multiline
                  maw={255}
                >
                  <ActionIcon
                    variant="transparent"
                    size="xs"
                    color="cyan"
                    onClick={() => {
                      fetchNui("av_laptop", "copy", myCrew.identifier);
                    }}
                  >
                    <IconCopy style={iconStyle} />
                  </ActionIcon>
                </Tooltip>
                <Tooltip
                  label={lang.delete_crew}
                  color="dark.5"
                  fz="xs"
                  position="top-start"
                >
                  <ActionIcon
                    variant="transparent"
                    size="xs"
                    color="red"
                    onDoubleClick={() => {
                      handleDelete();
                    }}
                  >
                    <IconTrash style={iconStyle} />
                  </ActionIcon>
                </Tooltip>
              </Group>
            </Group>
          )}
          <Group>
            <Group gap={3}>
              <Text fz="xs" c="gray.3">
                {`${lang.crew_status}:`}
              </Text>
              <Text fz="xs" c="dimmed">
                {myCrew.status}
              </Text>
            </Group>
            <Group gap={3} ml="auto">
              <Text fz="xs" c="gray.3">
                {`${lang.crew_members}:`}
              </Text>
              <Text fz="xs" c="dimmed">
                {`${myCrew.members.length}/${myCrew.maxMembers}`}
              </Text>
            </Group>
          </Group>
          <ScrollArea
            h={"calc(35vh)"}
            offsetScrollbars
            type="hover"
            scrollbars="y"
            scrollbarSize={5}
            mt="sm"
          >
            <Stack gap="xs">
              {myCrew.members.map((member) => (
                <Group
                  key={member.identifier}
                  bg={"rgba(30, 30, 36, 1)"}
                  p="xs"
                  gap="xs"
                  style={{
                    borderRadius: "6px",
                    border: "solid 1px rgba(255,255,255,0.085)",
                  }}
                >
                  {member.identifier === myCrew.owner && (
                    <Tooltip
                      label={lang.crew_leader}
                      color="dark.5"
                      fz="xs"
                      position="top-start"
                    >
                      <IconCrown
                        style={{ height: "20px", width: "20px" }}
                        stroke={1.5}
                        color="#ffd43b"
                      />
                    </Tooltip>
                  )}
                  <Text fz="sm" c="gray.2">
                    {member.name}
                  </Text>
                  {(myIdentifier === myCrew.owner ||
                    myIdentifier === member.identifier) && (
                    <Tooltip
                      label={lang.remove_member}
                      color="dark.5"
                      fz="xs"
                      position="top-start"
                    >
                      <ActionIcon
                        variant="transparent"
                        size="xs"
                        color="red"
                        ml="auto"
                        onDoubleClick={() => {
                          handleRemove(member.identifier);
                        }}
                      >
                        <IconTrash style={iconStyle} />
                      </ActionIcon>
                    </Tooltip>
                  )}
                </Group>
              ))}
            </Stack>
          </ScrollArea>
        </>
      ) : (
        <>
          <Group gap="xs">
            <PasswordInput
              classNames={global}
              placeholder={lang.crew_identifier}
              value={input}
              size="xs"
              w={170}
              onChange={(e) => {
                setInput(e.currentTarget.value);
              }}
              leftSection={<IconUsersGroup style={iconStyle} stroke={1} />}
            />
            <Group gap="xs">
              <Tooltip
                label={lang.crew_join}
                color="dark.5"
                fz="xs"
                position="top-start"
              >
                <ActionIcon
                  variant="transparent"
                  size="xs"
                  color="white"
                  onClick={() => {
                    fetchNui("av_gangs", "joinCrew", input);
                  }}
                >
                  <IconSearch style={iconStyle} />
                </ActionIcon>
              </Tooltip>
              <Tooltip
                label={lang.new_crew}
                color="dark.5"
                fz="xs"
                position="top-start"
              >
                <ActionIcon
                  variant="transparent"
                  size="xs"
                  color="teal.3"
                  onClick={handleNew}
                >
                  <IconCirclePlus style={iconStyle} />
                </ActionIcon>
              </Tooltip>
            </Group>
          </Group>
        </>
      )}
    </Stack>
  );
};
