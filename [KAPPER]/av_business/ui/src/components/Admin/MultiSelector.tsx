import {
  CheckIcon,
  Combobox,
  Group,
  Input,
  Pill,
  PillsInput,
  useCombobox,
} from "@mantine/core";
import { useState, useEffect } from "react";
import { SelectType } from "../../types/types";
import global from "../../global.module.css";

interface Properties {
  data: SelectType[];
  values?: string[];
  updateData: (options: string[]) => void;
  label?: string;
  description?: string;
}

const MAX_DISPLAYED_VALUES = 2;

export function MultiSelector({
  data,
  values,
  updateData,
  label,
  description,
}: Properties) {
  const combobox = useCombobox({
    onDropdownClose: () => combobox.resetSelectedOption(),
    onDropdownOpen: () => combobox.updateSelectedOptionIndex("active"),
  });

  const [value, setValue] = useState<string[]>(values ?? []);

  useEffect(() => {
    setValue(values ?? []);
  }, [values]);

  const updateValues = (nextValue: string[]) => {
    updateData(nextValue);
  };

  const handleValueSelect = (val: string) => {
    const nextValue = value.includes(val)
      ? value.filter((v) => v !== val)
      : [...value, val];

    setValue(nextValue);
    updateValues(nextValue);
  };

  const handleValueRemove = (val: string) => {
    const nextValue = value.filter((v) => v !== val);
    setValue(nextValue);
    updateValues(nextValue);
  };

  const value_options = value
    .slice(
      0,
      MAX_DISPLAYED_VALUES === value.length
        ? MAX_DISPLAYED_VALUES
        : MAX_DISPLAYED_VALUES - 1,
    )
    .map((val) => {
      const job = data.find((j) => j.value === val);
      return (
        <Pill
          key={val}
          withRemoveButton
          onRemove={() => handleValueRemove(val)}
        >
          {job ? job.label : val}
        </Pill>
      );
    });

  const options = data.map((item) => (
    <Combobox.Option
      value={item.value}
      key={item.value}
      active={value.includes(item.value)}
    >
      <Group gap="sm">
        {value.includes(item.value) ? <CheckIcon size={12} /> : null}
        <span>{item.label}</span>
      </Group>
    </Combobox.Option>
  ));

  return (
    <Combobox
      classNames={global}
      store={combobox}
      onOptionSubmit={handleValueSelect}
      withinPortal
    >
      <Combobox.DropdownTarget>
        <PillsInput
          label={label ?? undefined}
          description={description ?? undefined}
          pointer
          onClick={() => combobox.toggleDropdown()}
          classNames={global}
          size="xs"
        >
          <Pill.Group>
            {value.length > 0 ? (
              <>
                {value_options}
                {value.length > MAX_DISPLAYED_VALUES && (
                  <Pill>+{value.length - (MAX_DISPLAYED_VALUES - 1)} more</Pill>
                )}
              </>
            ) : (
              <Input.Placeholder>Pick one or more values</Input.Placeholder>
            )}

            <Combobox.EventsTarget>
              <PillsInput.Field
                type="hidden"
                onBlur={() => combobox.closeDropdown()}
                onKeyDown={(event) => {
                  if (event.key === "Backspace" && value.length > 0) {
                    event.preventDefault();
                    handleValueRemove(value[value.length - 1]);
                  }
                }}
              />
            </Combobox.EventsTarget>
          </Pill.Group>
        </PillsInput>
      </Combobox.DropdownTarget>
      <Combobox.Dropdown mah={150} style={{ overflow: "auto" }}>
        <Combobox.Options>{options}</Combobox.Options>
      </Combobox.Dropdown>
    </Combobox>
  );
}
