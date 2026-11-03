import { useState, useEffect } from "react";
import {
  Modal,
  Button,
  NumberInput,
  TextInput,
  Image,
  Textarea,
  Select,
  Text,
  MultiSelect,
  PasswordInput,
  Switch,
  Stack,
  Avatar,
} from "@mantine/core";
import { ModalType } from "../../types/types";
import { Lang } from "../../reducers/atoms";
import { useAtomValue } from "jotai";

interface Properties {
  data: ModalType;
  callback?: (data?: any) => void;
}

export const ModalMenu = ({ data, callback }: Properties) => {
  const lang: any = useAtomValue(Lang);
  const [fieldsValues, setFieldsValues] = useState<Record<string, any>>([]);
  const handleInput = (name: string, value: any) => {
    setFieldsValues((prev) => ({ ...prev, [name]: value }));
  };
  useEffect(() => {
    if (!data?.info) return;
    const newValues: Record<string, any> = {};
    if (data.info.extraData) {
      newValues["extraData"] = data.info.extraData;
    }
    if (data.info.options && Array.isArray(data.info.options)) {
      data.info.options.forEach((option: any) => {
        if (option.default !== undefined) {
          newValues[option.name] = option.default;
        }
      });
    }
    setFieldsValues(newValues);
  }, [data]);
  if (!data) return null;
  return (
    <>
      <Modal
        opened
        onClose={() => {
          data.callback ? data.callback(null) : callback && callback(null);
        }}
        classNames={{
          header: "header",
          title: "title",
          body: "body",
          content: "content",
        }}
        lockScroll={false}
        c="white"
        title={data.info?.title}
        zIndex={9999}
        centered
        trapFocus={false}
      >
        <Stack gap="sm">
          {data.info?.options?.map((option: any, index: number) => (
            <span key={index} style={{ display: "block" }}>
              {option.type == "number" && (
                <NumberInput
                  classNames={{
                    input: "input",
                  }}
                  leftSection={
                    option.icon ? (
                      <>{option.icon && <i className={option.icon} />}</>
                    ) : null
                  }
                  description={option.subtitle}
                  placeholder={option.description}
                  label={option.title}
                  onChange={(e) => {
                    handleInput(option.name, e);
                  }}
                  disabled={option.disabled}
                  style={option.style}
                  withAsterisk={option.asterisk}
                  defaultValue={option.default}
                  size={option.size ? option.size : "xs"}
                  min={option.min ?? undefined}
                  max={99999999}
                  allowDecimal={option.decimal ?? undefined}
                  allowNegative={option.negative ?? undefined}
                  allowLeadingZeros={option.zero ?? undefined}
                  prefix={option.isMoney ? lang.money_symbol : undefined}
                  thousandSeparator={option.isMoney ? true : false}
                />
              )}
              {option.type == "text" && (
                <TextInput
                  classNames={{
                    input: "input",
                  }}
                  leftSection={
                    option.icon ? (
                      <>{option.icon && <i className={option.icon} />}</>
                    ) : null
                  }
                  maxLength={option.max}
                  description={option.subtitle}
                  placeholder={option.description}
                  defaultValue={option.default}
                  label={option.title}
                  onChange={(e) => {
                    handleInput(option.name, e.target.value);
                  }}
                  disabled={option.disabled}
                  style={option.style}
                  withAsterisk={option.asterisk}
                  size={option.size ? option.size : "xs"}
                />
              )}
              {option.type == "avatar" && (
                <Avatar
                  src={option.image}
                  size={option.size ?? "xl"}
                  ml="auto"
                  mr="auto"
                />
              )}
              {option.type == "image" && (
                <Image
                  src={option.image}
                  height={option.height}
                  alt={option.title}
                  style={option.style}
                  fit="contain"
                  fallbackSrc={option.default}
                />
              )}
              {option.type == "textarea" && (
                <Textarea
                  classNames={{
                    input: "input",
                  }}
                  defaultValue={option.description}
                  label={option.label}
                  disabled={option.disabled}
                  style={option.style}
                  maxRows={4}
                  autosize
                  onChange={(e) => {
                    handleInput(option.name, e.target.value);
                  }}
                  withAsterisk={option.asterisk}
                  size={option.size ? option.size : "xs"}
                />
              )}
              {option.type == "info" && (
                <Text
                  style={option.style}
                  fz={option.size ? option.size : "md"}
                  c={option.color ? option.color : "gray"}
                >
                  {option.description}
                </Text>
              )}
              {option.type == "select" && (
                <Select
                  classNames={{
                    input: "input",
                    dropdown: "dropdown",
                    option: "option",
                  }}
                  label={option.title}
                  defaultValue={option.default}
                  data={option.options}
                  onChange={(value) => {
                    handleInput(option.name, value);
                  }}
                  style={option.style}
                  withAsterisk={option.asterisk}
                  searchable={option.searchable}
                  size={option.size ? option.size : "xs"}
                />
              )}
              {option.type == "multiselect" && (
                <MultiSelect
                  classNames={{
                    input: "input",
                    dropdown: "dropdown",
                    option: "option",
                  }}
                  label={option.title}
                  data={option.options}
                  onChange={(value) => {
                    handleInput(option.name, value);
                  }}
                  style={option.style}
                  withAsterisk={option.asterisk}
                  maxValues={option.max}
                  searchable={option.searchable}
                  defaultValue={option.default}
                  size={option.size ? option.size : "xs"}
                />
              )}
              {option.type == "password" && (
                <PasswordInput
                  classNames={{
                    input: "input",
                  }}
                  leftSection={
                    option.icon ? <i className={option.icon} /> : undefined
                  }
                  defaultValue={option.default}
                  placeholder={option.description}
                  label={option.title}
                  withAsterisk={option.asterisk}
                  size={option.size ? option.size : "xs"}
                  maxLength={option.max}
                  onChange={(event) =>
                    handleInput(option.name, event.currentTarget.value)
                  }
                />
              )}
              {option.type == "switch" && (
                <Switch
                  classNames={{
                    input: "input",
                  }}
                  label={option.title}
                  defaultChecked={option.default}
                  checked={fieldsValues[option.name]}
                  size={option.size ? option.size : "xs"}
                  onChange={(event) =>
                    handleInput(option.name, event.currentTarget.checked)
                  }
                  style={option.style}
                />
              )}
            </span>
          ))}

          {data.info?.button && (
            <Button
              size="xs"
              lts={1}
              onClick={() => {
                data.callback
                  ? data.callback(fieldsValues)
                  : callback && callback(fieldsValues);
              }}
              variant="outline"
              color="var(--accent)"
              mt="sm"
              fullWidth
            >
              {data.info?.button}
            </Button>
          )}
        </Stack>
      </Modal>
    </>
  );
};
