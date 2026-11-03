import {
  Modal,
  Grid,
  TextInput,
  NumberInput,
  Select,
  Switch,
  Tooltip,
  Group,
  Text,
  Box,
  Button,
  Stack,
} from "@mantine/core";
import { useState } from "react";
import { Info } from "lucide-react";
import { CameraType, SelectType } from "../../../types/types";
import { fetchNui } from "../../../hooks/useNuiEvents";

interface Properties {
  camera: CameraType;
  onClose: () => void;
  isServer?: boolean;
  isCreator?: boolean;
  allGroups?: SelectType[];
}

const commonClasses = {
  input: "input",
  label: "label",
  dropdown: "dropdown",
  option: "option",
};

const FieldLabel = ({ title, desc }: { title: string; desc: string }) => (
  <Group gap={4} wrap="nowrap">
    <Text span size="sm" inherit>
      {title}
    </Text>
    <Tooltip
      label={desc}
      withArrow
      position="top"
      fz="xs"
      color="var(--tooltip)"
      multiline
      maw={300}
    >
      <Box
        component="span"
        style={{
          display: "inline-flex",
          cursor: "help",
          pointerEvents: "auto",
          zIndex: 99999,
        }}
      >
        <Info size={14} color="var(--text-dim)" />
      </Box>
    </Tooltip>
  </Group>
);

export const CamPanel = ({
  camera,
  onClose,
  isServer,
  isCreator,
  allGroups,
}: Properties) => {
  const [current, setCurrent] = useState(camera);

  const handleChange = <K extends keyof CameraType>(
    key: K,
    value: CameraType[K],
  ) => {
    setCurrent((c) => ({ ...c, [key]: value }));
  };

  const handleSettingsChange = (
    key: keyof CameraType["settings"],
    value: boolean | number | string | null,
  ) => {
    setCurrent((c) => ({
      ...c,
      settings: {
        ...c.settings,
        [key]: value,
      },
    }));
  };

  const handleSave = async () => {
    fetchNui(
      "av_cameras",
      isCreator ? "createCamera" : "updateCamera",
      current,
    );
    onClose();
  };

  return (
    <Modal
      classNames={{
        content: "content",
        header: "header",
        body: "body",
      }}
      opened
      onClose={onClose}
      centered
      size={600}
      title={isCreator ? "Create new camera" : "Edit camera"}
    >
      <Stack>
        <Grid>
          <Grid.Col span={4}>
            {isServer ? (
              <Select
                classNames={commonClasses}
                size="xs"
                label={<FieldLabel title="Group" desc="Camera group" />}
                value={current.group_id || undefined}
                onChange={(e) => handleChange("group_id", e as string)}
                data={allGroups || []}
                searchable
              />
            ) : (
              <TextInput
                classNames={commonClasses}
                size="xs"
                label={
                  <FieldLabel
                    title="Owner"
                    desc="Identifier of the camera owner."
                  />
                }
                value={current.owner}
                onChange={(e) => handleChange("owner", e.currentTarget.value)}
                maxLength={30}
              />
            )}
          </Grid.Col>
          <Grid.Col span={4}>
            <TextInput
              classNames={commonClasses}
              size="xs"
              label={
                <FieldLabel
                  title="Label"
                  desc="The display name of the camera."
                />
              }
              value={current.label}
              onChange={(e) => handleChange("label", e.currentTarget.value)}
              maxLength={30}
            />
          </Grid.Col>
          <Grid.Col span={4}>
            <NumberInput
              classNames={commonClasses}
              size="xs"
              label={
                <FieldLabel
                  title="Battery"
                  desc="Current battery percentage (0-100%)."
                />
              }
              value={current.battery}
              onChange={(e) => handleChange("battery", Number(e))}
              min={0}
              max={100}
              allowDecimal={false}
              allowNegative={false}
              allowLeadingZeros={false}
            />
          </Grid.Col>
          <Grid.Col span={4}>
            <NumberInput
              classNames={commonClasses}
              size="xs"
              label={
                <FieldLabel
                  title="Rotation Angle (0-360°)"
                  desc="Max rotation angle allowed."
                />
              }
              value={current.settings.rotationAngle}
              onChange={(e) => handleSettingsChange("rotationAngle", Number(e))}
              min={0}
              max={360}
              allowDecimal={false}
              allowNegative={false}
              allowLeadingZeros={false}
            />
          </Grid.Col>
          <Grid.Col span={4}>
            <NumberInput
              classNames={commonClasses}
              size="xs"
              label={
                <FieldLabel
                  title="Failure Chance (%)"
                  desc="Probability of the camera dropping connection."
                />
              }
              value={current.settings.damageChance}
              onChange={(e) => handleSettingsChange("damageChance", Number(e))}
              min={0}
              max={100}
              allowDecimal={false}
              allowNegative={false}
              allowLeadingZeros={false}
            />
          </Grid.Col>
          <Grid.Col span="auto">
            <Select
              classNames={{
                ...commonClasses,
                dropdown: "dropdown",
                option: "option",
              }}
              size="xs"
              label={
                <FieldLabel
                  title="Status"
                  desc="Current operational state of the camera."
                />
              }
              value={current.status}
              data={[
                { value: "live", label: "Live" },
                { value: "offline", label: "Offline" },
                { value: "unassigned", label: "Unassigned" },
                { value: "support-needed", label: "Support needed" },
              ]}
              onChange={(e) => {
                if (e) handleChange("status", e as any);
              }}
            />
          </Grid.Col>
          <Grid.Col span={4} mt="md">
            <Switch
              classNames={{ label: "label" }}
              color="var(--accent)"
              size="xs"
              label={
                <FieldLabel
                  title="Night vision"
                  desc="Allows visibility in low-light environments."
                />
              }
              checked={current.settings.nightVision}
              onChange={(e) =>
                handleSettingsChange("nightVision", e.currentTarget.checked)
              }
            />
          </Grid.Col>
          <Grid.Col span={4} mt="md">
            <Switch
              classNames={{ label: "label" }}
              color="var(--accent)"
              size="xs"
              label={
                <FieldLabel
                  title="Thermal Vision"
                  desc="Highlights heat signatures in the feed."
                />
              }
              checked={current.settings.thermalVision}
              onChange={(e) =>
                handleSettingsChange("thermalVision", e.currentTarget.checked)
              }
            />
          </Grid.Col>
          <Grid.Col span={4} mt="md">
            <Switch
              classNames={{ label: "label" }}
              color="var(--accent)"
              size="xs"
              label={<FieldLabel title="Zoom" desc="Allows zooming." />}
              checked={current.settings.allowZoom}
              onChange={(e) =>
                handleSettingsChange("allowZoom", e.currentTarget.checked)
              }
            />
          </Grid.Col>
          <Grid.Col span={4} mt="md">
            <Switch
              classNames={{ label: "label" }}
              color="var(--accent)"
              size="xs"
              label={
                <FieldLabel
                  title="Hacking"
                  desc="Allows player to hack the camera."
                />
              }
              checked={current.settings.allowHacking}
              onChange={(e) =>
                handleSettingsChange("allowHacking", e.currentTarget.checked)
              }
            />
          </Grid.Col>
          <Grid.Col span={4} mt="md">
            <Switch
              classNames={{ label: "label" }}
              color="var(--accent)"
              size="xs"
              label={
                <FieldLabel
                  title="Record"
                  desc="Allows player to record and upload footage to Fivemanage."
                />
              }
              checked={current.settings.recording}
              onChange={(e) =>
                handleSettingsChange("recording", e.currentTarget.checked)
              }
            />
          </Grid.Col>
          <Grid.Col span={4} mt="md">
            <Switch
              classNames={{ label: "label" }}
              color="var(--accent)"
              size="xs"
              label={
                <FieldLabel
                  title="Replay"
                  desc="Allows the camera to start recording when an in game action occurs. Moderate performance impact, use with caution."
                />
              }
              checked={current.settings.replay}
              onChange={(e) =>
                handleSettingsChange("replay", e.currentTarget.checked)
              }
            />
          </Grid.Col>
          <Grid.Col span={4} mt="md">
            <Switch
              classNames={{ label: "label" }}
              color="var(--accent)"
              size="xs"
              label={
                <FieldLabel
                  title="Plugged"
                  desc="If enabled, battery drain will be ignored."
                />
              }
              checked={current.settings.plugged}
              onChange={(e) =>
                handleSettingsChange("plugged", e.currentTarget.checked)
              }
            />
          </Grid.Col>
        </Grid>
        <Button
          variant="outline"
          color="var(--accent)"
          fullWidth
          mt="sm"
          onClick={handleSave}
        >
          {isCreator ? "Start Placement" : "Save Changes"}
        </Button>
      </Stack>
    </Modal>
  );
};
