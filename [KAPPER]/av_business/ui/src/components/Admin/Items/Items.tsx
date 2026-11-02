import { useState } from "react";
import { Stack, Group, Select, Text, Button, TextInput } from "@mantine/core";
import { SelectType } from "../../../types/types";
import { Whitelist } from "./Whitelist/Whitelist";
import { WhitelistItems } from "./Whitelist/api";
import { fetchNui } from "../../../hooks/useNuiEvents";
import { Panel } from "./Panel";
import { TypesInterface } from "./Types/api";
import { Types } from "./Types/Types";
import { CombinedItem } from "./types";
import { useAtomValue } from "jotai";
import { Lang } from "../../../reducers/atoms";
import global from "../../../global.module.css";

const Items = ({
  allJobs,
  allItems,
  itemTypes,
}: {
  allJobs: SelectType[];
  itemTypes: TypesInterface[];
  allItems: { value: string; label: string }[];
}) => {
  const daLang: any = useAtomValue(Lang);
  const lang = daLang.admin;
  const [tab, setTab] = useState<string>("types");
  const [textButton, setTextButton] = useState(lang.items_new_type);
  const [panel, setPanel] = useState(false);
  const [item, setItem] = useState<CombinedItem | null>(null);
  const [search, setSearch] = useState("");

  const handleSave = (item: WhitelistItems) => {
    setPanel(false);
    setItem(null);
    switch (tab) {
      case "whitelist":
        fetchNui("av_business", "setWhitelist", item);
        break;
      case "types":
        fetchNui("av_business", "setTypes", item);
        break;
      default:
        break;
    }
  };

  const handleChange = (e: string) => {
    setSearch("");
    setItem(null);
    setPanel(false);
    setTab(e);
    setTextButton(e == "whitelist" ? lang.items_add_item : lang.items_add_type);
  };
  return (
    <>
      <>
        {panel && (
          <Panel
            allItems={allItems}
            allJobs={allJobs}
            itemTypes={itemTypes}
            item={item}
            type={tab}
            close={() => {
              setPanel(false);
              setItem(null);
            }}
            handleSave={handleSave}
          />
        )}
      </>
      <Stack>
        <Group>
          <Text
            fz="xs"
            w={300}
            style={{ wordBreak: "break-word" }}
            c="var(--text-dim)"
            lts={0.55}
          >
            {tab == "whitelist" && (
              <>
                Authorize framework items for business use and define
                job-specific access.
              </>
            )}
            {tab == "types" && (
              <>Manage item types and authorized business access.</>
            )}
          </Text>
          <Group ml="auto" gap="xs">
            <TextInput
              classNames={global}
              size="xs"
              placeholder={lang.search}
              value={search}
              onChange={(e) => {
                setSearch(e.currentTarget.value);
              }}
            />
            <Select
              classNames={global}
              size="xs"
              value={tab}
              onChange={(e) => {
                if (!e) return;
                handleChange(e);
              }}
              data={[
                {
                  value: "types",
                  label: lang.items_tab_types,
                },
                {
                  value: "whitelist",
                  label: lang.items_tab_whitelist,
                },
              ]}
            />
            <Button
              className={global.button}
              size="xs"
              onClick={() => {
                setItem(null);
                setPanel(true);
              }}
            >
              {textButton}
            </Button>
          </Group>
        </Group>
        {tab == "whitelist" && (
          <Whitelist
            handleItem={(e) => {
              setItem(e as CombinedItem);
              setPanel(true);
            }}
            search={search}
          />
        )}
        {tab == "types" && (
          <Types
            itemTypes={itemTypes}
            handleItem={(e) => {
              setItem(e as CombinedItem);
              setPanel(true);
            }}
            search={search}
          />
        )}
      </Stack>
    </>
  );
};

export default Items;
