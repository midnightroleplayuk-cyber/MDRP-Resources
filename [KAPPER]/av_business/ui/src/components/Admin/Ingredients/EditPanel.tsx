import { Modal, NumberInput, Button, Select, Stack } from "@mantine/core";
import { IngredientsType, SelectType } from "../../../types/types";
import { useState } from "react";
import { MultiSelector } from "../MultiSelector";
import global from "../../../global.module.css";

interface Properties {
  allItems: { value: string; label: string }[];
  allJobs: SelectType[];
  effects: SelectType[];
  itemTypes: SelectType[];
  item?: IngredientsType | null;
  close: () => void;
  handleSave: (item: IngredientsType) => void;
}

export const EditPanel = ({
  allJobs,
  effects,
  item,
  close,
  itemTypes,
  handleSave,
  allItems,
}: Properties) => {
  const [tempItem, setTempItem] = useState(
    item ?? { label: "", jobs: [], type: [], value: "", effects: [], price: 0 },
  );

  const updateField = <K extends keyof IngredientsType>(
    field: K,
    value: IngredientsType[K],
  ) => {
    setTempItem((prev) => ({
      ...prev,
      [field]: value,
    }));
  };

  return (
    <Modal
      lockScroll={false}
      classNames={global}
      opened
      onClose={close}
      withinPortal={false}
      centered
      size={355}
      title="Ingredient Editor"
    >
      <Stack gap="xs">
        <Select
          classNames={global}
          size="xs"
          value={tempItem?.value}
          label="Item name"
          placeholder="Start typing the name..."
          limit={25}
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
        <MultiSelector
          label="Allowed Jobs"
          description="Limit access to specific jobs. If none are selected, this ingredient will be available to everyone."
          values={tempItem?.jobs ? tempItem.jobs : undefined}
          data={allJobs}
          updateData={(e) => {
            updateField("jobs", e);
          }}
        />
        <MultiSelector
          label="Consumable Effects"
          description="Define player effects. Leave blank for standard consumables."
          values={tempItem?.effects ? tempItem.effects : undefined}
          data={effects}
          updateData={(e) => {
            updateField("effects", e);
          }}
        />
        <MultiSelector
          label="Item Types"
          description="Ingredient will be available for the selected item types."
          values={tempItem?.type ? tempItem.type : undefined}
          data={itemTypes}
          updateData={(e) => {
            updateField("type", e);
          }}
        />
        <NumberInput
          classNames={global}
          size="xs"
          label="Price"
          description="Supplies tab price. Use 0 to make it unavailable for purchase"
          onChange={(e) => {
            updateField("price", Number(e));
          }}
          min={0}
          value={tempItem?.price ? tempItem.price : "N/A"}
          prefix={tempItem?.price ? "$" : undefined}
          allowNegative={false}
          allowDecimal={false}
          max={1000000}
        />
        <Button
          className={global.button}
          variant="filled"
          size="xs"
          mt="sm"
          disabled={tempItem.value.length == 0 || tempItem.label.length == 0}
          onClick={() => {
            handleSave(tempItem);
          }}
        >
          Save
        </Button>
      </Stack>
    </Modal>
  );
};
