import { Group, Box, Title, Button } from "@mantine/core";
import {
  IconTestPipe,
  IconIdBadge2,
  IconTransfer,
  IconBolt,
  IconLock,
  IconTrash,
} from "@tabler/icons-react";
import { fetchNui } from "../hooks/useNuiEvents";
import classes from "./styles.module.css";
import { useRecoilValue } from "recoil";
import { Lang } from "../reducers/atoms";

interface Properties {
  identifier: string | boolean;
  status: boolean;
  toggleLab: () => void;
  isOwner: boolean;
  canTransfer: boolean;
  canDelete: boolean;
  isCop: boolean;
  setNotification: (title: string, description: string, event: string) => void;
}

export const Header = ({
  identifier,
  status = true,
  toggleLab,
  isOwner,
  canTransfer,
  canDelete,
  isCop,
  setNotification,
}: Properties) => {
  const { labs: lang }: any = useRecoilValue(Lang);
  const seizeLab = (identifier: string | boolean) => {
    fetchNui("av_drugs", "seizeLab", identifier);
  };
  return (
    <>
      <Group p="sm">
        <Group gap="xs">
          <Box className={classes.iconBox}>
            <IconTestPipe
              style={{ width: "20px", height: "20px" }}
              color="#a5d8ff"
            />
          </Box>
          <Title order={2} fw={600} c="blue.2">
            {lang.header}
          </Title>
        </Group>
        <Group ml="auto" gap="sm">
          <Button
            style={{ cursor: "pointer" }}
            variant="light"
            color="gray"
            c={status ? `blue.2` : `gray`}
            size="xs"
            leftSection={
              <IconBolt
                stroke={1.5}
                style={{ width: "16px", height: "16px" }}
              />
            }
            onClick={() => {
              toggleLab();
            }}
          >
            {status ? lang.lab_on : lang.lab_off}
          </Button>
          <Button
            style={{ cursor: "pointer" }}
            variant="light"
            color="gray"
            size="xs"
            leftSection={
              <IconIdBadge2
                stroke={1.5}
                style={{ width: "16px", height: "16px" }}
              />
            }
            onClick={() => {
              fetchNui("av_drugs", "copy", identifier);
            }}
          >
            {lang.lab_id}
          </Button>
          {isOwner && canTransfer ? (
            <Button
              style={{ cursor: "pointer" }}
              variant="light"
              color="gray"
              size="xs"
              leftSection={
                <IconTransfer
                  stroke={1.5}
                  style={{ width: "16px", height: "16px" }}
                />
              }
              onClick={() => {
                setNotification(
                  lang.transfer,
                  lang.transfer_description,
                  "transferLab"
                );
              }}
            >
              {lang.transfer}
            </Button>
          ) : null}
          {isOwner && canDelete ? (
            <Button
              style={{ cursor: "pointer" }}
              variant="light"
              color="red"
              size="xs"
              leftSection={
                <IconTrash
                  stroke={1.5}
                  style={{ width: "16px", height: "16px" }}
                />
              }
              onClick={() => {
                setNotification(
                  lang.delete,
                  lang.delete_description,
                  "deleteLab"
                );
              }}
            >
              {lang.delete}
            </Button>
          ) : null}
          {isCop && (
            <Button
              style={{ cursor: "pointer" }}
              variant="light"
              color="gray"
              size="xs"
              leftSection={
                <IconLock
                  stroke={1.5}
                  style={{ width: "16px", height: "16px" }}
                />
              }
              onClick={() => {
                seizeLab(identifier);
              }}
            >
              {lang.seize}
            </Button>
          )}
        </Group>
      </Group>
      <Box className={classes.divider} />
    </>
  );
};
