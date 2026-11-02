import {
  Box,
  TextInput,
  Title,
  Button,
  Flex,
  Group,
  Image,
} from "@mantine/core";
import { Profile } from "../../types/types";
import { useState } from "react";
import { fetchNui } from "../../hooks/useNuiEvents";
import { useClickOutside } from "@mantine/hooks";
import classes from "./style.module.css";
import { useRecoilValue } from "recoil";
import { Lang } from "../../reducers/atoms";

interface Properties {
  profile: Profile;
  setProfile: (options: Profile) => void;
  show: (option: boolean) => void;
}

export const Settings = ({ profile, setProfile, show }: Properties) => {
  const { app: lang }: any = useRecoilValue(Lang);
  const [edited, setEdited] = useState(profile);
  const [canSave, setCanSave] = useState(false);
  const ref = useClickOutside(() => show(false));
  const handleEdit = (field: string, input: string) => {
    setCanSave(true);
    const copy = { ...edited, [field]: input };
    setEdited(copy);
  };
  const handleSave = async () => {
    if (!canSave) {
      show(false);
      return;
    }
    const saved = await fetchNui("av_drugs", "saveProfile", edited);
    if (saved) {
      setProfile(edited);
      show(false);
    }
  };
  return (
    <Box className={classes.container}>
      <Box className={classes.box} p="md" ref={ref}>
        <Title
          className={classes.title}
          fw={600}
          order={3}
          lts={1.5}
          tt={"uppercase"}
        >
          {lang.edit_profile}
        </Title>
        <Box className={classes.divider} />
        <Group mt="xs">
          <Image
            w={175}
            h={175}
            src={edited.photo}
            fallbackSrc="./avatar_default.png"
            radius={6}
          />
          <Flex direction="column" gap="sm" w={200}>
            <TextInput
              classNames={classes}
              value={edited.username}
              label={lang.username}
              fz="xs"
              size="xs"
              maxLength={20}
              onChange={(e) => {
                handleEdit("username", e.target.value);
              }}
            />
            <TextInput
              classNames={classes}
              value={edited.strain}
              label={lang.strain}
              fz="xs"
              size="xs"
              maxLength={20}
              onChange={(e) => {
                handleEdit("strain", e.target.value);
              }}
            />
            <TextInput
              classNames={classes}
              value={edited.photo}
              label={lang.photo}
              fz="xs"
              size="xs"
              onChange={(e) => {
                handleEdit("photo", e.target.value);
              }}
            />
          </Flex>
        </Group>
        <Button
          mt="sm"
          fullWidth
          variant="light"
          lts={5}
          fw={400}
          onClick={handleSave}
        >
          {lang.save_profile}
        </Button>
      </Box>
    </Box>
  );
};
