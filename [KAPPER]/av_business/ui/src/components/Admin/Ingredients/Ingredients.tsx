import { useEffect, useState } from "react";
import {
  Stack,
  Group,
  Tooltip,
  Text,
  Button,
  TextInput,
  ActionIcon,
  Table,
  ScrollAreaAutosize,
} from "@mantine/core";
import { IconTrash, IconEdit } from "@tabler/icons-react";
import { IngredientsType, SelectType } from "../../../types/types";
import { Loading } from "../../Loading";
import { fetchNui } from "../../../hooks/useNuiEvents";
import { ApiIngredients } from "../../../API/products";
import { EditPanel } from "./EditPanel";
import { useAtomValue } from "jotai";
import { Lang } from "../../../reducers/atoms";
import global from "../../../global.module.css";

const Ingredients = ({
  allJobs,
  itemTypes,
  allItems,
}: {
  allJobs: SelectType[];
  itemTypes: SelectType[];
  allItems: { value: string; label: string }[];
}) => {
  const daLang: any = useAtomValue(Lang);
  const lang = daLang.admin;
  const [loaded, setLoaded] = useState(false);
  const [settings, setSettings] = useState<IngredientsType[]>(ApiIngredients);
  const [filtered, setFiltered] = useState<IngredientsType[]>(ApiIngredients);
  const [current, setCurrent] = useState<IngredientsType>();
  const [effects, setEffects] = useState<SelectType[]>([
    { value: "alcohol", label: "Alcohol" },
    { value: "drugs", label: "Drugs" },
  ]);

  const [panel, setPanel] = useState(false);

  const deleteItem = (name: string) => {
    const resp = settings.filter((item) => item.value !== name);
    setSettings(resp);
    setFiltered(resp);
    fetchNui("av_business", "updateSettings", {
      type: "ingredients",
      settings: resp,
    });
  };

  const handleSave = (item: IngredientsType) => {
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
      type: "ingredients",
      settings: updatedSettings,
    });
  };

  const handleSearch = (input: string) => {
    const res = settings.filter(
      (item) =>
        (item.value ? item.value.toLowerCase().includes(input) : false) ||
        (item.label ? item.label.toLowerCase().includes(input) : false),
    );
    setFiltered(res);
  };

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_business", "getSettings", "ingredients");
      const temp_effects = await fetchNui("av_business", "getEffects");
      if (temp_effects) {
        setEffects(temp_effects);
      }
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
        <EditPanel
          allJobs={allJobs}
          allItems={allItems}
          effects={effects}
          itemTypes={itemTypes}
          close={() => {
            setPanel(false);
            setCurrent(undefined);
          }}
          item={current}
          handleSave={handleSave}
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
            Manage the global list of ingredients available for business
            crafting recipes.
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
                setCurrent(undefined);
                setPanel(true);
              }}
            >
              Add Ingredient
            </Button>
          </Group>
        </Group>
        <ScrollAreaAutosize
          h={530}
          type="hover"
          scrollbars="y"
          scrollbarSize={5}
          mx="auto"
        >
          <Table layout="fixed">
            <Table.Thead>
              <Table.Tr>
                <Table.Th>Name</Table.Th>
                <Table.Th>Label</Table.Th>
                <Table.Th>Types</Table.Th>
                <Table.Th>Job Restricted</Table.Th>
                <Table.Th>Price</Table.Th>
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
                  <Table.Td tt="capitalize">
                    <Text
                      size={item.type && item.type.length > 3 ? "xs" : "sm"}
                      c="var(--text-dim)"
                      style={{ wordBreak: "break-word", whiteSpace: "normal" }}
                    >
                      {item.type && item.type.length > 0
                        ? item.type.join(", ")
                        : lang.ingredients_no_types}
                    </Text>
                  </Table.Td>
                  <Table.Td>
                    <Text
                      size="sm"
                      c="var(--text-dim)"
                      style={{ wordBreak: "break-word", whiteSpace: "normal" }}
                    >
                      {item.jobs && item.jobs.length > 0 ? lang.yes : "No"}
                    </Text>
                  </Table.Td>
                  <Table.Td>{`${item.price ? `$${item.price?.toLocaleString("en-US")}` : `N/A`}`}</Table.Td>
                  <Table.Td>
                    <Group>
                      <Tooltip label={lang.ingredients_edit_tip} color="var(--tooltip)" fz="xs">
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
                        label={lang.ingredients_delete_tip}
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

export default Ingredients;
