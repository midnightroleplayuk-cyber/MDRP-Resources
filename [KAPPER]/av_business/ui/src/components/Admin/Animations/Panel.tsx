import {
  Modal,
  Stack,
  Grid,
  Button,
  TextInput,
  NumberInput,
  Group,
  Checkbox,
  ScrollArea,
} from "@mantine/core";
import { useState } from "react";
import { AnimType, ApiAnimation } from "./api";
import { SelectType } from "../../../types/types";
import { MultiSelector } from "../MultiSelector";
import { fetchNui } from "../../../hooks/useNuiEvents";
import { PropList } from "./Propslist";
import { useAtomValue } from "jotai";
import { Lang } from "../../../reducers/atoms";
import global from "../../../global.module.css";
import { CraftingAction } from "../Crafting/api";

interface Properties {
  allJobs: SelectType[];
  itemTypes: SelectType[];
  item?: AnimType | null;
  close: () => void;
  handleSave: (item: AnimType) => void;
}

export const Panel = ({
  item,
  itemTypes,
  allJobs,
  close,
  handleSave,
}: Properties) => {
  const daLang: any = useAtomValue(Lang);
  const lang = daLang.admin;
  const [tempItem, setTempItem] = useState<AnimType>(() => {
    const base = item ?? ApiAnimation;
    return {
      ...base,
      anim: base.anim ?? { clip: "", dict: "" },
      prop: base.prop ?? {
        model: "",
        bone: 0,
        pos: { x: 0, y: 0, z: 0 },
        rot: { x: 0, y: 0, z: 0 },
      },
    };
  });

  const updateField = (
    field: keyof AnimType | keyof CraftingAction,
    value: any,
  ) => {
    setTempItem((prev) => ({
      ...prev,
      [field]: value,
    }));
  };

  const updateAnim = (field: keyof AnimType["anim"], value: string) => {
    setTempItem((prev) => ({
      ...prev,
      anim: { ...prev.anim!, [field]: value },
    }));
  };

  return (
    <Modal
      classNames={global}
      opened
      onClose={close}
      withinPortal={false}
      centered
      lockScroll={false}
      size="auto"
      title={lang.anims_panel_title}
      styles={{
        content: {
          minWidth: 600,
        },
      }}
    >
      <ScrollArea
        h={510}
        type="hover"
        scrollbars="y"
        scrollbarSize={5}
        offsetScrollbars
        pr="xs"
      >
        <Stack>
          <Grid>
            <Grid.Col span={6}>
              <Stack gap="xs">
                <TextInput
                  classNames={global}
                  size="xs"
                  label={lang.anims_key}
                  value={tempItem.value}
                  onChange={(e) => updateField("value", e.currentTarget.value)}
                />
                <TextInput
                  classNames={global}
                  size="xs"
                  label={lang.anims_dictionary}
                  value={tempItem.anim?.dict ?? ""}
                  onChange={(e) => updateAnim("dict", e.currentTarget.value)}
                />
                <MultiSelector
                  values={
                    tempItem.jobs ? (tempItem.jobs as string[]) : undefined
                  }
                  data={allJobs}
                  updateData={(e) => updateField("jobs", e)}
                  label={lang.anims_allowed_jobs}
                />
                <TextInput
                  classNames={global}
                  size="xs"
                  label={lang.anims_progress_label}
                  value={tempItem.progressLabel}
                  onChange={(e) =>
                    updateField("progressLabel", e.currentTarget.value)
                  }
                />
              </Stack>
            </Grid.Col>
            <Grid.Col span={6}>
              <Stack gap="xs">
                <TextInput
                  classNames={global}
                  size="xs"
                  label={lang.label}
                  value={tempItem.label}
                  onChange={(e) => updateField("label", e.currentTarget.value)}
                />

                <TextInput
                  classNames={global}
                  size="xs"
                  label={lang.anims_animation}
                  value={tempItem.anim?.clip ?? ""}
                  onChange={(e) => updateAnim("clip", e.currentTarget.value)}
                />

                <MultiSelector
                  values={tempItem.type}
                  data={itemTypes}
                  updateData={(e) => updateField("type", e)}
                  label={lang.anims_item_types}
                />

                <NumberInput
                  classNames={global}
                  size="xs"
                  value={tempItem.time / 1000}
                  label={lang.anims_duration}
                  onChange={(e) => updateField("time", Number(e) * 1000)}
                />
              </Stack>
            </Grid.Col>
          </Grid>
          <PropList tempItem={tempItem} updateField={updateField} />
          <Group>
            <Checkbox
              ml="auto"
              classNames={global}
              size="xs"
              label={lang.anims_walkable}
              checked={tempItem.canWalk}
              onChange={(e) => updateField("canWalk", e.currentTarget.checked)}
            />
            <Checkbox
              classNames={global}
              size="xs"
              label={lang.anims_allow_driving}
              checked={tempItem.canDrive}
              onChange={(e) => updateField("canDrive", e.currentTarget.checked)}
            />
          </Group>
        </Stack>
      </ScrollArea>
      <Group mt="sm">
        <Button
          size="xs"
          ml="auto"
          onClick={() => fetchNui("av_business", "testAnim", tempItem)}
        >
          {lang.anims_preview}
        </Button>
        <Button
          className={global.button}
          size="xs"
          onClick={() => handleSave(tempItem)}
          disabled={tempItem.value.length === 0 || tempItem.label.length === 0}
        >
          {lang.save}
        </Button>
      </Group>
    </Modal>
  );
};
