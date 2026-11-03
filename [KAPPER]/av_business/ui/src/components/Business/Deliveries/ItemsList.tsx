import { useEffect, useState } from "react";
import {
  Modal,
  Stack,
  Checkbox,
  Group,
  Text,
  ScrollArea,
  TextInput,
  Button,
} from "@mantine/core";
import { SelectType } from "../../../types/types";
import { fetchNui, isEnvBrowser } from "../../../hooks/useNuiEvents";
import { ApiItemList, ApiSelectedItems } from "./api";
import global from "../../../global.module.css";
import { Loading } from "../../Loading";

interface Properties {
  setItemPanel: (state: boolean) => void;
  lang: any;
}

export const ItemsList = ({ setItemPanel, lang }: Properties) => {
  const [loaded, setLoaded] = useState(false);
  const [allItems, setAllItems] = useState<SelectType[]>([]);
  const [selected, setSelected] = useState<string[]>([]);
  const [filtered, setFiltered] = useState<SelectType[]>([]);

  const handleSearch = (input: string) => {
    const searchLower = input.toLowerCase();
    const res = allItems.filter(
      (item) =>
        (item.value ? item.value.toLowerCase().includes(searchLower) : false) ||
        (item.label ? item.label.toLowerCase().includes(searchLower) : false),
    );

    setFiltered([...res].sort((a, b) => a.label.localeCompare(b.label)));
  };

  const toggleCheck = (name: string) => {
    if (selected.includes(name)) {
      setSelected(selected.filter((item) => item !== name));
    } else {
      setSelected([...selected, name]);
    }
  };

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_business", "getDeliveriesItems");
      let initialItems: SelectType[] = [];

      if (resp) {
        initialItems = resp.allItems;
        setSelected(resp.selected || []);
      } else if (isEnvBrowser()) {
        initialItems = ApiItemList;
        setSelected(ApiSelectedItems);
      }

      const sorted = [...initialItems].sort((a, b) =>
        a.label.localeCompare(b.label),
      );
      setAllItems(sorted);
      setFiltered(sorted);

      setTimeout(() => {
        setLoaded(true);
      }, 50);
    };
    fetchData();
  }, []);

  return (
    <Modal
      opened
      centered
      classNames={global}
      zIndex={99999}
      title={
        <Text c="var(--text-main)" fw={600} style={{ letterSpacing: "1px" }}>
          {lang.inventory_header}
        </Text>
      }
      lockScroll={false}
      size={355}
      onClose={() => {
        setItemPanel(false);
      }}
    >
      <Stack mih={245} gap="md">
        {!loaded ? (
          <Loading />
        ) : (
          <>
            <Text fz="xs" c="var(--text-dim)" lh={1.4}>
              {lang.inventory_description}
            </Text>
            <TextInput
              classNames={global}
              size="xs"
              placeholder="Filter items..."
              onChange={(e) => {
                handleSearch(e.currentTarget.value);
              }}
              styles={{
                input: {
                  backgroundColor: "rgba(0,0,0,0.2)",
                  border: "1px solid rgba(255,255,255,0.1)",
                },
              }}
            />
            <ScrollArea
              h={280}
              type="hover"
              scrollbars="y"
              scrollbarSize={7}
              offsetScrollbars
              pr="xs"
            >
              <Stack gap="xs">
                {filtered.map((item) => (
                  <Group
                    key={item.value}
                    p="xs"
                    style={{
                      backgroundColor: "rgba(255,255,255,0.02)",
                      borderRadius: "4px",
                      border: "1px solid rgba(255,255,255,0.03)",
                    }}
                  >
                    <Text fz="xs" fw={500}>
                      {item.label}
                    </Text>
                    <Checkbox
                      color="var(--accent)"
                      size="xs"
                      ml="auto"
                      checked={selected.includes(item.value)}
                      onChange={() => {
                        toggleCheck(item.value);
                      }}
                      styles={{
                        input: { cursor: "pointer" },
                      }}
                    />
                  </Group>
                ))}
              </Stack>
            </ScrollArea>
            <Button
              className={global.button}
              size="xs"
              fullWidth
              mt="md"
              onClick={() => {
                fetchNui("av_business", "setDeliveryItems", selected);
              }}
            >
              {lang.save_changes}
            </Button>
          </>
        )}
      </Stack>
    </Modal>
  );
};
