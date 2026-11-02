import {
  Box,
  Text,
  TextInput,
  ScrollArea,
  UnstyledButton,
  Group,
  Button,
  Stack,
} from "@mantine/core";
import { LayoutGrid, ChevronUp } from "lucide-react";
import { UI_COLOR, UI_DIM_COLOR, ACCENT_COLOR } from "./utils";
import { useAtomValue } from "jotai";
import { Lang } from "../../reducers/atoms";
import classes from "./style.module.css";

export const CameraSwitcherPanel = ({ switcherProps, activeCamProps }: any) => {
  const lang: any = useAtomValue(Lang);
  const {
    switcherOpen,
    toggleSwitcher,
    searchQuery,
    setSearchQuery,
    handleSelectCam,
    searchInputRef,
    visibleCams,
  } = switcherProps;

  const { activeCam } = activeCamProps;

  if (!activeCam) {
    return null;
  }

  return (
    <Box className={classes.camSwitcherWrap}>
      <Box
        className={`${classes.camPanel} ${switcherOpen ? classes.camPanelOpen : ""}`}
      >
        <Box className={classes.cpHeader}>
          <Text
            ff="var(--font-display)"
            fz="md"
            fw={600}
            c={UI_COLOR}
            lts="1px"
            tt="uppercase"
          >
            {lang.camera_list}
          </Text>
          <Text ff="var(--font-family)" fz="xs" c="var(--text-secondary)">
            {visibleCams.length} {lang.cameras}
          </Text>
        </Box>
        <Box p="sm">
          <TextInput
            ref={searchInputRef}
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.currentTarget.value)}
            placeholder={lang.search}
            variant="unstyled"
            styles={{
              input: {
                fontFamily: "var(--font-family)",
                fontSize: 13,
                color: UI_COLOR,
                background: "var(--bg-card)",
                border: "1px solid var(--border-mid)",
                borderRadius: 6,
                padding: "6px 10px",
              },
            }}
          />
        </Box>
        <ScrollArea h={280} type="scroll" scrollbarSize={4} offsetScrollbars>
          <Stack gap={4} p="8px 12px 12px 12px">
            {visibleCams.map((cam: any) => {
              const isSelectable = cam.status !== "offline";
              const isActive = activeCam.identifier === cam.identifier;
              return (
                <UnstyledButton
                  key={cam.identifier}
                  onClick={() => {
                    handleSelectCam(cam);
                  }}
                  className={`${classes.cpCam} ${isActive ? classes.cpCamActive : ""} ${!isSelectable ? classes.cpCamOffline : ""}`}
                  style={{
                    width: "100%",
                    borderRadius: "6px",
                    padding: "10px 12px",
                  }}
                >
                  <Group wrap="nowrap" gap="md">
                    <Box style={{ flex: 1, minWidth: 0 }}>
                      <Text
                        ff="var(--font-display)"
                        fz="sm"
                        fw={600}
                        maw={200}
                        c={UI_COLOR}
                        lts="0.5px"
                        truncate
                      >
                        {cam.label}
                      </Text>
                      <Text
                        ff="var(--font-family)"
                        fz="xs"
                        c={UI_DIM_COLOR}
                        truncate
                        maw={200}
                      >
                        {cam.location || cam.loc}
                      </Text>
                    </Box>
                  </Group>
                </UnstyledButton>
              );
            })}
          </Stack>
        </ScrollArea>
      </Box>
      <Button
        onClick={toggleSwitcher}
        w={280}
        variant="unstyled"
        leftSection={<LayoutGrid size={14} />}
        rightSection={
          <ChevronUp
            size={14}
            className={`${classes.csbArrow} ${switcherOpen ? classes.csbArrowOpen : ""}`}
          />
        }
        styles={{
          root: {
            height: 38,
            padding: "0 16px",
            background: switcherOpen
              ? "var(--accent-dim)"
              : "var(--bg-card)%55",
            border: `1px solid ${switcherOpen ? "var(--accent)" : "var(--border-mid)"}`,
            borderRadius: 6,
            color: switcherOpen ? ACCENT_COLOR : UI_DIM_COLOR,
            fontFamily: "var(--font-display)",
            fontSize: 14,
            fontWeight: 600,
            letterSpacing: "1px",
            transition: "all 0.15s",
            whiteSpace: "nowrap",
            "&:hover": {
              borderColor: "var(--accent)",
              color: UI_COLOR,
              background: "var(--bg-card-hover)",
            },
          },
        }}
      >
        <Text fz="sm" truncate>
          {activeCam.label}
        </Text>
      </Button>
    </Box>
  );
};
