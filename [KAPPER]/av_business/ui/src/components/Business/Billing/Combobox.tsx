import { useState, useEffect } from "react";
import { Combobox, TextInput, useCombobox } from "@mantine/core";
import { SelectType } from "../../../types/types";
import global from "../../../global.module.css";

interface Properties {
  handleItem: (type: string, field: string) => void;
  items: SelectType[];
  daLang: any;
  clear: number;
}

export const ComboInput = ({
  handleItem,
  items,
  daLang,
  clear,
}: Properties) => {
  const lang = daLang.billing;
  const combobox = useCombobox();
  const [value, setValue] = useState("");

  const shouldFilterOptions = !items.some((item) => item.value === value);

  const filteredOptions = shouldFilterOptions
    ? items.filter((item) =>
        item.label.toLowerCase().includes(value.toLowerCase().trim())
      )
    : items;
  const options = filteredOptions.map((item) => (
    <Combobox.Option value={item.value} key={item.value}>
      {item.label}
    </Combobox.Option>
  ));

  useEffect(() => {
    if (options.length == 0) {
      combobox.closeDropdown();
    }
  }, [value]);

  useEffect(() => {
    combobox.updateSelectedOptionIndex();
    setValue("");
  }, [clear]);

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
        handleItem("name", selected?.value || optionValue);
        combobox.closeDropdown();
      }}
      store={combobox}
    >
      <Combobox.Target>
        <TextInput
          classNames={global}
          label={lang.product}
          placeholder={lang.productPlaceholder}
          value={value}
          onChange={(event) => {
            const val = event.currentTarget.value;
            setValue(val);
            handleItem("name", val);
            combobox.updateSelectedOptionIndex();
            if (options.length > 0) {
              combobox.openDropdown();
            }
          }}
          onClick={() => combobox.openDropdown()}
          onFocus={() => combobox.openDropdown()}
          onBlur={() => combobox.closeDropdown()}
          size="xs"
        />
      </Combobox.Target>
      <Combobox.Dropdown>
        <Combobox.Options>{options}</Combobox.Options>
      </Combobox.Dropdown>
    </Combobox>
  );
};
