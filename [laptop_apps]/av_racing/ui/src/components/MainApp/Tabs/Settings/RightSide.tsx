import {
  Box,
  Text,
  Select,
  ColorInput,
  Switch,
  Group,
  Tooltip,
  Slider,
} from "@mantine/core";
import { Crown } from "lucide-react";
import { ColorsMap } from "./ColorsMap";
import { SettingsData } from "./types";
import { COLOR_OPTIONS } from "./helpers";
import { SelectType } from "../../../../types/types";
import classes from "./style.module.css";

interface Properties {
  lang: any;
  handleEdit: (
    field: keyof SettingsData,
    value: string | null | number | boolean,
    scope?: string,
  ) => void;
  handleSave: () => void;
  animations: SelectType[];
  smoke: string;
  blip: string;
  animation: string;
  pathColor: string;
  pathEnabled: boolean;
  pathOpacity: number;
  pathAvailable: boolean;
  ghostEnabled: boolean;
  ghostTarget: string;
  ghostAvailable: boolean;
}

export const RightSide = ({
  lang,
  handleEdit,
  handleSave,
  animations,
  smoke,
  blip,
  animation,
  pathColor,
  pathEnabled,
  pathOpacity,
  pathAvailable,
  ghostEnabled,
  ghostTarget,
  ghostAvailable,
}: Properties) => {
  return (
    <Box className={classes.rightSide}>
      <Box className={classes.settingsBlock}>
        <Text className={classes.settingsTitle}>
          {lang.smoke ?? "SMOKE COLOR"}
        </Text>
        <ColorInput
          format="rgb"
          value={smoke}
          onChange={(value) => handleEdit("smoke", value)}
          size="sm"
          styles={{
            input: {
              backgroundColor: "var(--bg-panel)",
              border: "1px solid var(--border-color)",
              color: "var(--text-main)",
            },
            dropdown: {
              backgroundColor: "var(--bg-panel)",
              border: "1px solid var(--border-color)",
            },
          }}
        />
      </Box>
      <Box className={classes.settingsBlock}>
        <Text className={classes.settingsTitle}>
          {lang.blips ?? "CHECKPOINT BLIPS"}
        </Text>
        <ColorsMap
          type="blip"
          colors={COLOR_OPTIONS}
          onSelect={handleEdit}
          selected={blip}
        />
      </Box>
      <Box className={classes.inputField}>
        <Crown size={18} className={classes.inputIcon} />
        <Box className={classes.inputContent}>
          <Text className={classes.inputTitle}>
            {lang.animation ?? "FAVORITE ANIMATION"}
          </Text>
          <Select
            data={animations}
            value={animation}
            onChange={(e) => handleEdit("animation", e)}
            variant="unstyled"
            size="sm"
            styles={{
              input: {
                color: "var(--text-main)",
                padding: 0,
                minHeight: "unset",
                lineHeight: 1.2,
              },
              dropdown: {
                backgroundColor: "var(--bg-panel)",
                border: "1px solid var(--border-color)",
              },
              option: { color: "var(--text-main)" },
            }}
          />
        </Box>
      </Box>

      {pathAvailable && (
        <Box className={classes.settingsBlock}>
          <Group justify="space-between" align="center" wrap="nowrap">
            <Box>
              <Group gap={6} align="center" wrap="nowrap">
                <Text className={classes.settingsTitle}>
                  {lang.race_path ?? "RACE PATH"}
                </Text>
                <Tooltip
                  label={
                    lang.race_path_help ??
                    "Draws the fastest lap ever set on the track as arrows on the road, so you can follow and copy that line. Arrows turn red where the record holder was braking. If nobody has set a lap on a track yet, nothing is drawn there."
                  }
                  color="var(--tooltip)"
                  withArrow
                  multiline
                  w={240}
                >
                  <Text
                    fz="9px"
                    c="var(--text-main)"
                    fw={800}
                    style={{
                      cursor: "help",
                      backgroundColor: "rgba(255,255,255,0.1)",
                      padding: "0 4px",
                      borderRadius: "4px",
                      display: "inline-flex",
                    }}
                  >
                    ?
                  </Text>
                </Tooltip>
              </Group>
              <Text fz="xs" c="var(--text-dim)">
                {lang.race_path_desc ??
                  "Follow the track record's racing line"}
              </Text>
            </Box>
            <Switch
              size="sm"
              color="cyan.3"
              checked={pathEnabled}
              onChange={(e) =>
                handleEdit("pathEnabled", e.currentTarget.checked)
              }
            />
          </Group>
          {pathEnabled && (
            <>
              <ColorInput
                mt="xs"
                format="rgb"
                value={pathColor}
                onChange={(value) => handleEdit("pathColor", value)}
                size="sm"
                styles={{
                  input: {
                    backgroundColor: "var(--bg-panel)",
                    border: "1px solid var(--border-color)",
                    color: "var(--text-main)",
                  },
                  dropdown: {
                    backgroundColor: "var(--bg-panel)",
                    border: "1px solid var(--border-color)",
                  },
                }}
              />
              <Text fz="xs" c="var(--text-dim)" mt="sm">
                {lang.race_path_opacity ?? "OPACITY"}
              </Text>
              <Slider
                mt={4}
                min={10}
                max={100}
                step={5}
                value={pathOpacity}
                onChange={(value) => handleEdit("pathOpacity", value)}
                label={(v) => `${v}%`}
                color="cyan.5"
                size="sm"
              />
            </>
          )}
        </Box>
      )}

      {ghostAvailable && (
      <Box className={classes.settingsBlock}>
        <Group justify="space-between" align="center" wrap="nowrap">
          <Box>
            <Text className={classes.settingsTitle}>
              {lang.ghost_car ?? "GHOST CAR"}
            </Text>
            <Text fz="xs" c="var(--text-dim)">
              {lang.ghost_car_desc ??
                "Race a translucent replay of a past run"}
            </Text>
          </Box>
          <Switch
            size="sm"
            color="cyan.3"
            checked={ghostEnabled}
            onChange={(e) =>
              handleEdit("ghostEnabled", e.currentTarget.checked)
            }
          />
        </Group>
        {ghostEnabled && (
          <Select
            mt="xs"
            data={[
              { value: "best", label: lang.ghost_best ?? "My Best Lap" },
              { value: "record", label: lang.ghost_record ?? "Track Record" },
              { value: "both", label: lang.ghost_both ?? "Best + Record" },
            ]}
            value={ghostTarget}
            onChange={(v) => handleEdit("ghostTarget", v)}
            allowDeselect={false}
            size="sm"
            styles={{
              input: {
                backgroundColor: "var(--bg-panel)",
                border: "1px solid var(--border-color)",
                color: "var(--text-main)",
              },
              dropdown: {
                backgroundColor: "var(--bg-panel)",
                border: "1px solid var(--border-color)",
              },
              option: { color: "var(--text-main)" },
            }}
          />
        )}
      </Box>
      )}

      <button className={classes.primaryButton} onClick={handleSave}>
        {lang.save_changes ?? "SAVE CHANGES"}
      </button>
    </Box>
  );
};
