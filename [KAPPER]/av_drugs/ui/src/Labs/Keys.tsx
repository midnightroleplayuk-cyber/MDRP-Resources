import { useState } from "react";
import {
  Box,
  TextInput,
  Group,
  ActionIcon,
  Text,
  Stack,
  Tooltip,
} from "@mantine/core";
import { IconUserPlus, IconKeyOff } from "@tabler/icons-react";
import { keyHolder } from "../types/types";
import classes from "./styles.module.css";
import { fetchNui } from "../hooks/useNuiEvents";
import { useRecoilValue } from "recoil";
import { Lang } from "../reducers/atoms";

interface Properties {
  identifier: string;
  holders: keyHolder[];
  setHolders: (data: keyHolder[]) => void;
  isOwner: boolean;
}

export const Keys = ({
  identifier,
  holders,
  setHolders,
  isOwner,
}: Properties) => {
  const { labs: lang }: any = useRecoilValue(Lang);
  const [currentHolders, setCurrentHolders] = useState(holders);
  const handleSearch = (input: string) => {
    if (input == "") {
      setCurrentHolders(holders);
      return;
    }
    const res = holders.filter((holder) =>
      holder.name.toLowerCase().includes(input.toLowerCase())
    );
    setCurrentHolders(res);
  };
  const handleRemove = (playerIdentifier: string) => {
    const copy = holders.filter(
      (holder) => holder.identifier !== playerIdentifier
    );
    setCurrentHolders(copy);
    setHolders(copy);
    fetchNui("av_drugs", "removeKeys", {
      lab: identifier,
      player: playerIdentifier,
    });
  };
  const giveKeys = async () => {
    const resp = await fetchNui("av_drugs", "giveKeys", identifier);
    if (resp) {
      setCurrentHolders(resp);
      setHolders(resp);
    }
  };
  return (
    <Box
      p="sm"
      style={{
        backgroundColor: "rgba(155,155,155,0.055)",
        borderRadius: "8px",
        boxShadow: "0px 0px 10px 1px rgba(0, 0, 0, 0.095)",
      }}
    >
      <Group>
        <Text fz="lg" fw={500}>
          {lang.keys}
        </Text>
        {isOwner && (
          <Tooltip label={lang.give_keys} color="dark.4">
            <ActionIcon
              ml="auto"
              size="md"
              variant="transparent"
              color="gray"
              c="blue.2"
              onClick={giveKeys}
            >
              <IconUserPlus style={{ width: "14px", height: "14px" }} />
            </ActionIcon>
          </Tooltip>
        )}
      </Group>
      <TextInput
        mt="xs"
        classNames={classes}
        placeholder={lang.search}
        size="xs"
        maw="100%"
        onChange={(e) => {
          handleSearch(e.target.value);
        }}
      />
      {currentHolders[0] ? (
        <Stack className={classes.keys} mt="sm" gap={0}>
          {currentHolders.map((user, index) => (
            <Group
              key={user.identifier}
              bg={index % 2 == 0 ? "rgba(80,80,80,0.25)" : "transparent"}
              p="xs"
              style={{
                borderRadius: "4px",
              }}
            >
              <Text truncate maw={125} c="white" fz="sm">
                {user.name}
              </Text>
              {isOwner && (
                <ActionIcon
                  ml="auto"
                  size="sm"
                  variant="subtle"
                  color="red"
                  onClick={() => {
                    handleRemove(user.identifier);
                  }}
                >
                  <IconKeyOff style={{ width: "12px", height: "12px" }} />
                </ActionIcon>
              )}
            </Group>
          ))}
        </Stack>
      ) : (
        <Box className={classes.keys}>
          <Text mt="sm" ta="center" c="dimmed" fz="xs">
            {lang.no_holders}
          </Text>
        </Box>
      )}
    </Box>
  );
};
