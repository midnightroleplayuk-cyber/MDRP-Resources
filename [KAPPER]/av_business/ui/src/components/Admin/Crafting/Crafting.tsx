import {
  Stack,
  Group,
  Text,
  TextInput,
  Button,
  ScrollAreaAutosize,
  Table,
  Tooltip,
  ActionIcon,
} from "@mantine/core";
import { IconTrash, IconEdit } from "@tabler/icons-react";
import { useEffect, useState } from "react";
import { ApiCrafting, CraftingAction } from "./api";
import { fetchNui } from "../../../hooks/useNuiEvents";
import { Loading } from "../../Loading";
import { useAtomValue } from "jotai";
import { Lang } from "../../../reducers/atoms";
import global from "../../../global.module.css";
import { Panel } from "./Panel";

const Crafting = () => {
  const daLang: any = useAtomValue(Lang);
  const lang = daLang.admin;
  const [loaded, setLoaded] = useState(false);
  const [settings, setSettings] = useState<CraftingAction[]>(ApiCrafting);
  const [filtered, setFiltered] = useState<CraftingAction[]>(ApiCrafting);
  const [current, setCurrent] = useState<CraftingAction | null>(null);
  const [panel, setPanel] = useState(false);

  const handleSearch = (input: string) => {
    const res = settings.filter(
      (item) =>
        (item.value ? item.value.toLowerCase().includes(input) : false) ||
        (item.label ? item.label.toLowerCase().includes(input) : false),
    );
    setFiltered(res);
  };

  const deleteItem = (name: string) => {
    const resp = settings.filter((item) => item.value !== name);
    setSettings(resp);
    setFiltered(resp);
    fetchNui("av_business", "updateSettings", {
      type: "crafting",
      settings: resp,
    });
  };

  const handleSave = (item: CraftingAction) => {
    let updatedSettings = [...settings];
    const exists = settings.some((s) => s.value === item.value);
    if (exists) {
      updatedSettings = settings.map((s) =>
        s.value === item.value ? item : s,
      );
    } else {
      updatedSettings = [...settings, item];
    }
    setSettings(updatedSettings);
    setFiltered(updatedSettings);
    setPanel(false);
    fetchNui("av_business", "updateSettings", {
      type: "crafting",
      settings: updatedSettings,
    });
  };

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_business", "getSettings", "crafting");
      if (resp) {
        setSettings(resp);
        setFiltered(resp);
      }
      setTimeout(() => {
        setLoaded(true);
      }, 100);
    };
    fetchData();
  }, []);

  if (!loaded) return <Loading />;
  return (
    <>
      {panel && (
        <Panel
          item={current}
          handleSave={handleSave}
          close={() => {
            setCurrent(null);
            setPanel(false);
          }}
        />
      )}
      <Stack>
        <Group>
          <Text
            fz="xs"
            maw={300}
            style={{ wordBreak: "break-word" }}
            c="var(--text-dim)"
            lts={0.55}
          >
            Add, edit, or remove animations and props for your crafting zones.
          </Text>
          <Group ml="auto">
            <TextInput
              classNames={global}
              size="xs"
              placeholder={lang.search}
              onChange={(e) => {
                handleSearch(e.currentTarget.value);
              }}
            />
            <Button
              className={global.button}
              size="xs"
              variant="filled"
              onClick={() => {
                setCurrent(null);
                setPanel(true);
              }}
            >
              Add Animation
            </Button>
          </Group>
        </Group>
        <ScrollAreaAutosize
          h={530}
          type="hover"
          scrollbars="y"
          scrollbarSize={5}
        >
          <Table layout="fixed">
            <Table.Thead>
              <Table.Tr>
                <Table.Th>Name</Table.Th>
                <Table.Th>Progress Label</Table.Th>
                <Table.Th>Duration</Table.Th>
                <Table.Th>Prop</Table.Th>
                <Table.Th>Actions</Table.Th>
              </Table.Tr>
            </Table.Thead>
            <Table.Tbody>
              {filtered.map((item) => (
                <Table.Tr key={item.value}>
                  <Table.Td>
                    <Text fz="sm" truncate maw={200}>
                      {item.value}
                    </Text>
                  </Table.Td>
                  <Table.Td>
                    <Text fz="sm" truncate maw={200}>
                      {item.label}
                    </Text>
                  </Table.Td>
                  <Table.Td>
                    <Text fz="sm" truncate maw={200}>
                      {`${item.duration / 1000} seconds`}
                    </Text>
                  </Table.Td>
                  <Table.Td>
                    {item.prop && item.prop.length > 0 ? lang.yes : "No"}
                  </Table.Td>
                  <Table.Td>
                    <Group>
                      <Tooltip label={lang.crafting_edit_tip} color="var(--tooltip)" fz="xs">
                        <ActionIcon
                          size="xs"
                          variant="transparent"
                          color="cyan"
                          onClick={() => {
                            setCurrent(item);
                            setPanel(true);
                          }}
                        >
                          <IconEdit
                            style={{ height: 14, width: 14 }}
                            stroke={1.55}
                          />
                        </ActionIcon>
                      </Tooltip>
                      <Tooltip
                        label={lang.crafting_delete_tip}
                        color="var(--tooltip)"
                        fz="xs"
                      >
                        <ActionIcon
                          size="xs"
                          variant="transparent"
                          color="red"
                          onDoubleClick={() => {
                            deleteItem(item.value);
                          }}
                        >
                          <IconTrash
                            style={{ height: 14, width: 14 }}
                            stroke={1.55}
                          />
                        </ActionIcon>
                      </Tooltip>
                    </Group>
                  </Table.Td>
                </Table.Tr>
              ))}
            </Table.Tbody>
          </Table>
        </ScrollAreaAutosize>
      </Stack>
    </>
  );
};

export default Crafting;
