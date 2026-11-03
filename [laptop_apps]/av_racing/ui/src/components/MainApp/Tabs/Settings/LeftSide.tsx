import { Box, Image, Text, TextInput } from "@mantine/core";
import { UserPen, Map as IconMap, Image as IconPhotoEdit } from "lucide-react";
import { SettingsData } from "./types";
import classes from "./style.module.css";

interface Properties {
  lang: any;
  photo: string;
  smoke: string;
  blip: string;
  name: string;
  nationality: string;
  handleEdit: (
    field: keyof SettingsData,
    value: string | number | null,
    scope?: string,
  ) => void;
}

export const LeftSide = ({
  lang,
  photo,
  smoke,
  blip,
  name,
  nationality,
  handleEdit,
}: Properties) => {
  return (
    <Box className={classes.leftSide}>
      <Box className={classes.previewGroup}>
        <Image
          src={photo}
          fallbackSrc="https://r2.fivemanage.com/QmVAYSlqeAlD4IxVbdvu5/p0oT829.png"
          className={classes.avatarPreview}
        />
        <Box className={classes.colorBox} bg={smoke}>
          <Text className={classes.colorsText}>
            {lang.smoke ?? "SMOKE COLOR"}
          </Text>
        </Box>
        <Box className={classes.colorBox} bg={blip ? `${blip}.5` : "gray.5"}>
          <Text className={classes.colorsText}>{lang.blips ?? "BLIPS"}</Text>
        </Box>
      </Box>

      <Box className={classes.inputField}>
        <UserPen size={18} className={classes.inputIcon} />
        <Box className={classes.inputContent}>
          <Text className={classes.inputTitle}>
            {lang.username ?? "USERNAME"}
          </Text>
          <TextInput
            variant="unstyled"
            size="sm"
            value={name}
            maxLength={30}
            onChange={(e) => handleEdit("name", e.target.value, "profile")}
            styles={{
              input: {
                color: "var(--text-main)",
                padding: 0,
                minHeight: "unset",
                lineHeight: 1.2,
              },
            }}
          />
        </Box>
      </Box>

      <Box className={classes.inputField}>
        <IconMap size={18} className={classes.inputIcon} />
        <Box className={classes.inputContent}>
          <Text className={classes.inputTitle}>
            {lang.nationality ?? "NATIONALITY"}
          </Text>
          <TextInput
            variant="unstyled"
            size="sm"
            value={nationality}
            maxLength={30}
            onChange={(e) => handleEdit("nationality", e.target.value)}
            styles={{
              input: {
                color: "var(--text-main)",
                padding: 0,
                minHeight: "unset",
                lineHeight: 1.2,
              },
            }}
          />
        </Box>
      </Box>

      <Box className={classes.inputField}>
        <IconPhotoEdit size={18} className={classes.inputIcon} />
        <Box className={classes.inputContent}>
          <Text className={classes.inputTitle}>
            {lang.photo ?? "PHOTO URL"}
          </Text>
          <TextInput
            variant="unstyled"
            size="sm"
            value={photo}
            onChange={(e) => handleEdit("photo", e.target.value, "profile")}
            styles={{
              input: {
                color: "var(--text-main)",
                padding: 0,
                minHeight: "unset",
                lineHeight: 1.2,
              },
            }}
          />
        </Box>
      </Box>
    </Box>
  );
};
