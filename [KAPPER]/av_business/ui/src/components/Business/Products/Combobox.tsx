import { useState } from "react";
import { Combobox, TextInput, useCombobox } from "@mantine/core";
import { useAtomValue } from "jotai";
import { Lang } from "../../../reducers/atoms";
import { SelectType } from "../../../types/types";
import global from "../../../global.module.css";

interface Properties {
  handleField: (field: string, value: any) => void;
  items: SelectType[];
  disabled: boolean;
  name: string;
}

export const ComboInput = ({
  handleField,
  items,
  disabled,
  name,
}: Properties) => {
  const daLang: any = useAtomValue(Lang);
  const { menu: lang } = daLang;
  const combobox = useCombobox();
  const [value, setValue] = useState(name);

  const shouldFilterOptions = !items.some((item) => item.value === value);

  const filteredOptions = shouldFilterOptions
    ? items.filter((item) =>
        item.label.toLowerCase().includes(value.toLowerCase().trim()),
      )
    : items;
  const options = filteredOptions.map((item) => (
    <Combobox.Option value={item.value} key={item.value}>
      {item.label}
    </Combobox.Option>
  ));

  return (
    <Combobox
      classNames={global}
      styles={{
        dropdown: {
          maxHeight: "160px",
          overflow: "auto",
        },
      }}
      onOptionSubmit={(optionValue) => {
        setValue(optionValue);

        const selected = items.find((item) => item.value === optionValue);
        handleField("name", selected?.value || optionValue);
        handleField("isNew", selected?.value ? false : true);
        combobox.closeDropdown();
      }}
      store={combobox}
    >
      <Combobox.Target>
        <TextInput
          classNames={global}
          label={lang.name}
          placeholder={lang.namePlaceholder}
          value={value}
          onChange={(event) => {
            const val = event.currentTarget.value;
            setValue(val);
            handleField("name", val);
            const existsInList = items.some((item) => item.value === val);
            handleField("isNew", !existsInList);
            combobox.updateSelectedOptionIndex();
            if (options.length > 0) {
              combobox.openDropdown();
            }
          }}
          onClick={() => combobox.openDropdown()}
          onFocus={() => combobox.openDropdown()}
          onBlur={() => combobox.closeDropdown()}
          maxLength={50}
          size="xs"
          styles={{
            input: {
              textTransform: "capitalize",
            },
          }}
          disabled={disabled}
        />
      </Combobox.Target>
      <Combobox.Dropdown>
        <Combobox.Options>
          {options.length === 0 ? (
            <Combobox.Empty>{lang.isNew}</Combobox.Empty>
          ) : (
            options
          )}
        </Combobox.Options>
      </Combobox.Dropdown>
    </Combobox>
  );
};
