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
import global from "../../global.module.css";
import { useRecoilValue } from "recoil";
import { CursorState, Lang } from "../../reducers/atoms";

interface Properties {
  data: ModalType;
  callback?: (data?: any) => void;
}

export const ModalMenu = ({ data, callback }: Properties) => {
  const lang: any = useRecoilValue(Lang);
  const cursor = useRecoilValue(CursorState);
  const [fieldsValues, setFieldsValues] = useState([]);
  const handleInput = (name: string, value: any) => {
    const newValue = { ...fieldsValues, [name]: value };
    setFieldsValues(newValue);
  };
  useEffect(() => {
    if (data.info?.extraData) {
      const newValue = { ...fieldsValues, ["extraData"]: data.info?.extraData };
      setFieldsValues(newValue);
    }
  }, [data]);

  return (
    <>
      <Modal
        opened
        onClose={() => {
          data.callback ? data.callback(null) : callback && callback(null);
        }}
        classNames={global}
        lockScroll={false}
        c="white"
        withinPortal={false}
        size={data.info.size ?? "300"}
        title={data.info.title}
        centered
        trapFocus={false}
        opacity={cursor ? 1.0 : 0.1}
      >
        <Stack gap="sm">
          {data.info.options?.map((option: any, index: number) => (
            <span key={index} style={{ display: "block" }}>
              {option.type == "number" && (
                <NumberInput
                  classNames={global}
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
                  classNames={global}
                  leftSection={
                    option.icon ? (
                      <>{option.icon && <i className={option.icon} />}</>
                    ) : null
                  }
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
                  classNames={global}
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
                  classNames={global}
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
                  classNames={global}
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
                  classNames={global}
                  leftSection={
                    <>{option.icon && <i className={option.icon} />}</>
                  }
                  placeholder={option.description}
                  label={option.title}
                  withAsterisk={option.asterisk}
                  size={option.size ? option.size : "xs"}
                  onChange={(event) =>
                    handleInput(option.name, event.currentTarget.value)
                  }
                />
              )}
              {option.type == "switch" && (
                <Switch
                  classNames={global}
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

          {data.info.button && (
            <Button
              className={global.button}
              size="xs"
              onClick={() => {
                data.callback
                  ? data.callback(fieldsValues)
                  : callback && callback(fieldsValues);
              }}
              mt="sm"
              fullWidth
              color="teal"
            >
              {data.info.button}
            </Button>
          )}
        </Stack>
      </Modal>
    </>
  );
};
