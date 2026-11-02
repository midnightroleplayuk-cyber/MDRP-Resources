import {
  Modal,
  ScrollAreaAutosize,
  Checkbox,
  Button,
  Select,
  Stack,
  TextInput,
  NumberInput,
} from "@mantine/core";
import { SelectType } from "../../../types/types";
import { useState } from "react";
import { WhitelistItems } from "./Whitelist/api";
import { TypesInterface } from "./Types/api";
import { CombinedItem } from "./types";
import { useAtomValue } from "jotai";
import { Lang } from "../../../reducers/atoms";
import global from "../../../global.module.css";
import { MultiSelector } from "../MultiSelector";

interface Properties {
  allItems: { value: string; label: string }[];
  allJobs: SelectType[];
  itemTypes: SelectType[];
  item?: CombinedItem | null;
  close: () => void;
  handleSave: (item: CombinedItem) => void;
  type: string;
}

const apiWhitelisted = {
  label: "",
  jobs: [],
  type: [],
  value: "",
  override: false,
};

const apiType = {
  value: "",
  label: "",
  jobs: [],
  event: "av_business:consumable",
  weight: 1000,
};

export const Panel = ({
  allJobs,
  item,
  close,
  itemTypes,
  handleSave,
  allItems,
  type,
}: Properties) => {
  const daLang: any = useAtomValue(Lang);
  const lang = daLang.admin;
  const [tempItem, setTempItem] = useState<WhitelistItems | TypesInterface>(
    item ?? (type == "whitelist" ? apiWhitelisted : apiType),
  );

  const updateField = (field: keyof CombinedItem, value: any) => {
    setTempItem((prev) => ({
      ...prev,
      [field]: value,
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
      size={355}
      title={
        type == "whitelist"
          ? lang.items_whitelist_title
          : lang.items_types_title
      }
    >
      <ScrollAreaAutosize
        h={440}
        type="hover"
        scrollbars="y"
        scrollbarSize={5}
        mx="auto"
      >
        <Stack gap="xs">
          {type === "whitelist" ? (
            <Select
              classNames={global}
              size="xs"
              value={tempItem?.value}
              label={lang.items_item_name}
              placeholder={lang.items_item_name_placeholder}
              limit={50}
              allowDeselect={false}
              onChange={(e) => {
                if (!e) return;
                const label = allItems.find((item) => item.value === e)?.label;
                updateField("value", e);
                updateField("label", label || e);
              }}
              searchable
              data={allItems}
            />
          ) : (
            <>
              <TextInput
                classNames={global}
                size="xs"
                value={tempItem?.value}
                description={lang.items_type_name_desc}
                label={lang.items_type_name}
                onChange={(e) => {
                  updateField("value", e.currentTarget.value.toLowerCase());
                }}
              />
              <TextInput
                classNames={global}
                size="xs"
                value={tempItem?.label}
                description={lang.items_type_label_desc}
                label={lang.items_type_label}
                onChange={(e) => {
                  updateField("label", e.currentTarget.value);
                }}
              />
            </>
          )}
          <MultiSelector
            label={lang.items_allowed_jobs}
            description={
              type == "whitelist"
                ? "Select the jobs with access to this item."
                : "Limit access to specific jobs. If none are selected, this item type will be available to everyone."
            }
            values={tempItem?.jobs ? tempItem.jobs : undefined}
            data={allJobs}
            updateData={(e) => {
              updateField("jobs", e);
            }}
          />
          {type === "whitelist" ? (
            <>
              <MultiSelector
                label={lang.items_item_types}
                description={lang.items_item_types_desc}
                values={(tempItem as WhitelistItems).type}
                data={itemTypes}
                updateData={(e) => {
                  updateField("type", e);
                }}
              />
              <Checkbox
                classNames={global}
                mt="xs"
                size="xs"
                label={lang.items_override}
                description={lang.items_override_desc}
                checked={(tempItem as WhitelistItems).override}
                onChange={(e) => {
                  updateField("override", e.currentTarget.checked);
                }}
              />
            </>
          ) : (
            <>
              <NumberInput
                classNames={global}
                label={lang.items_weight}
                description={lang.items_weight_desc}
                size="xs"
                min={0}
                max={1000000}
                value={(tempItem as CombinedItem).weight}
                onChange={(e) => {
                  updateField("weight", Number(e));
                }}
              />
              <TextInput
                classNames={global}
                size="xs"
                label={lang.items_client_event}
                description={lang.items_client_event_desc}
                value={(tempItem as CombinedItem).event}
                placeholder={lang.items_client_event_placeholder}
                onChange={(e) => updateField("event", e.currentTarget.value)}
              />
              <Checkbox
                classNames={global}
                size="xs"
                mt="xs"
                mb="xs"
                checked={(tempItem as CombinedItem).remove}
                label={lang.items_remove_on_use}
                description={lang.items_remove_on_use_desc}
                onChange={(e) => updateField("remove", e.currentTarget.checked)}
              />
            </>
          )}
        </Stack>
      </ScrollAreaAutosize>
      <Button
        className={global.button}
        variant="filled"
        size="xs"
        mt="md"
        fullWidth
        disabled={tempItem.value.length == 0 || tempItem.label.length == 0}
        onClick={() => {
          handleSave(tempItem as CombinedItem);
        }}
      >
        {lang.save}
      </Button>
    </Modal>
  );
};
