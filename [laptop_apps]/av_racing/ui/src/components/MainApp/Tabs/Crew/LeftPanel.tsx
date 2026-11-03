import { Text, TextInput, Image, Box } from "@mantine/core";
import { CrewProperties } from "../../../../types/types";
import classes from "./style.module.css";
import global from "../../../../global.module.css";

interface Properties {
  crew?: CrewProperties;
  handlePhoto: (input: string) => void;
  handleSave: () => void;
  wide: boolean;
  isModal?: boolean;
  lang: any;
}

export const LeftPanel = ({
  crew,
  handlePhoto,
  handleSave,
  wide,
  isModal,
  lang,
}: Properties) => {
  if (!crew) return null;

  return (
    <Box
      className={classes.leftPanel}
      style={
        isModal ? { padding: 0, border: "none", background: "transparent" } : {}
      }
    >
      <Text className={classes.crewName}>{crew.label}</Text>

      <Box className={classes.imageWrapper}>
        <Image
          src={crew.photo}
          fallbackSrc="avatar_default.png"
          className={classes.crewLogo}
        />
      </Box>

      {crew.isBoss && (
        <Box className={classes.bossControls}>
          <TextInput
            classNames={global}
            value={crew.photo}
            size="sm"
            placeholder="Image URL"
            onChange={(e) => handlePhoto(e.currentTarget.value)}
            styles={{
              input: {
                backgroundColor: "var(--bg-main)",
                border: "1px solid var(--border-color)",
                color: "var(--text-main)",
                textAlign: "center",
              },
            }}
          />
          <button className={classes.primaryButton} onClick={handleSave}>
            {lang.save_changes ?? "SAVE CHANGES"}
          </button>
        </Box>
      )}
    </Box>
  );
};
