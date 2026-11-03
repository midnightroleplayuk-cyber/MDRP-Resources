import { useState } from "react";
import { TextInput, Button, Group } from "@mantine/core";
import { fetchNui } from "../hooks/useNuiEvents";
import classes from "./style.module.css";
import { useRecoilValue } from "recoil";
import { Lang } from "../reducers/atoms";

interface Properties {
  name: string;
  type: string;
  event: string;
  cb: (data: any) => void;
}

export const Search = ({ name, type, event, cb }: Properties) => {
  const { admin: lang }: any = useRecoilValue(Lang);
  const [identifier, setIdentifier] = useState("");
  const handleSearch = async (closest: boolean) => {
    const resp = await fetchNui("av_drugs", event, {
      closest,
      identifier,
      type,
    });
    cb(resp);
  };
  return (
    <Group gap="xs">
      <TextInput
        classNames={classes}
        value={identifier}
        placeholder={`${lang.search} ${name} ${lang.by_identifier}`}
        size="xs"
        onChange={(e) => {
          setIdentifier(e.target.value);
        }}
      />
      <Button
        size="xs"
        onClick={() => {
          handleSearch(false);
        }}
      >
        {lang.search_button}
      </Button>
      <Button
        size="xs"
        color="violet"
        onClick={() => {
          handleSearch(true);
        }}
      >{`${lang.closest} ${name}`}</Button>
    </Group>
  );
};
