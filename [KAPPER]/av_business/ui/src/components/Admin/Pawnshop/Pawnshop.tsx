import { useEffect, useState } from "react";
import {
  Stack,
  Group,
  Text,
  Select,
  Button,
  TextInput,
  NumberInput,
  Paper,
  SimpleGrid,
  ActionIcon,
  Box,
  ScrollArea,
  Divider,
  Tooltip,
} from "@mantine/core";
import { ItemImage } from "../../ItemImage/ItemImage";
import {
  IconPlus,
  IconTrash,
  IconDeviceFloppy,
  IconFilePlus,
  IconInfoCircle,
} from "@tabler/icons-react";
import {
  fetchNui,
  isEnvBrowser,
  useNuiEvent,
} from "../../../hooks/useNuiEvents";
import { SelectType } from "../../../types/types";
import { useAtomValue } from "jotai";
import { Lang } from "../../../reducers/atoms";
import global from "../../../global.module.css";

export interface itemPawnType {
  name: string;
  label: string;
  buyPrice: number;
  sellPrice: number;
}

export interface PawnshopConfig {
  name: string;
  label: string;
  job: string;
  items: itemPawnType[];
  daily: number;
}

interface Properties {
  allItems: SelectType[];
  allJobs: SelectType[];
  inventory: string;
}

const Pawnshop = ({ allItems, allJobs, inventory }: Properties) => {
  const daLang: any = useAtomValue(Lang);
  const lang = daLang.admin;
  const [allPawnshops, setAllPawnshops] = useState<SelectType[]>([]);
  const [config, setConfig] = useState<PawnshopConfig | null>(null);
  const [selectedItem, setSelectedItem] = useState<string | null>(null);

  useNuiEvent("updatePawnshops", (data: SelectType[]) => {
    setAllPawnshops(data);
    if (config) {
      const updatedConfig = data.find((p) => p.value === config.name);
      if (updatedConfig) {
        handlePawnshow(updatedConfig.value);
      } else {
        setConfig(null);
      }
    }
  });

  const handlePawnshow = async (name: string) => {
    const resp = await fetchNui("av_business", "getPawnshop", name);
    if (resp) {
      setConfig(resp);
    } else {
      if (isEnvBrowser()) {
        setConfig({
          name: name,
          label: "Test Pawnshop",
          job: "police",
          items: [],
          daily: 50,
        });
      }
    }
  };

  const handleCreateNew = () => {
    setConfig({
      name: "",
      label: "",
      job: "",
      items: [],
      daily: 0,
    });
  };

  const updateConfig = (key: keyof PawnshopConfig, value: any) => {
    if (!config) return;
    setConfig({ ...config, [key]: value });
  };

  const addItem = () => {
    if (!selectedItem || !config) return;
    const itemDef = allItems.find((i) => i.value === selectedItem);
    if (!itemDef || config.items.find((i) => i.name === selectedItem)) return;

    updateConfig("items", [
      ...config.items,
      {
        name: itemDef.value,
        label: itemDef.label,
        buyPrice: 50,
        sellPrice: 100,
      },
    ]);
    setSelectedItem(null);
  };

  const removeItem = (name: string) => {
    if (!config) return;
    updateConfig(
      "items",
      config.items.filter((i) => i.name !== name),
    );
  };

  const updateItemConfig = (
    name: string,
    key: keyof itemPawnType,
    value: number,
  ) => {
    if (!config) return;
    updateConfig(
      "items",
      config.items.map((i) => (i.name === name ? { ...i, [key]: value } : i)),
    );
  };

  const handleSave = () => {
    if (!config) return;
    fetchNui("av_business", "savePawnshop", config);
  };

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_business", "getPawnshops");
      if (resp) {
        setAllPawnshops(resp);
      } else {
        if (isEnvBrowser()) {
          setAllPawnshops([
            { label: "Pawnshop 1", value: "pawnshop1" },
            { label: "Pawnshop 2", value: "pawnshop2" },
          ]);
        }
      }
    };
    fetchData();
  }, []);

  return (
    <Stack style={{ fontFamily: "var(--font-display)" }}>
      <Group>
        <Text
          fz="xs"
          maw={400}
          style={{ wordBreak: "break-word" }}
          c="var(--text-dim)"
          lts={0.55}
        >
          You can configure the items that are available for pawn, the prices,
          and the job that can access every pawnshop.
        </Text>
        <Group ml="auto">
          <Button
            size="xs"
            color="#22d3ee"
            variant="light"
            leftSection={<IconFilePlus size={14} />}
            onClick={handleCreateNew}
          >
            Create New
          </Button>
          <Select
            classNames={global}
            size="xs"
            placeholder={lang.pawn_select}
            data={allPawnshops}
            onChange={(val) => {
              if (val) handlePawnshow(val);
            }}
          />
          <Button
            className={global.button}
            size="xs"
            color="#4ade80"
            leftSection={<IconDeviceFloppy size={14} />}
            onClick={handleSave}
            disabled={!config}
          >
            {lang.save_changes}
          </Button>
        </Group>
      </Group>
      {config && (
        <ScrollArea h={530} offsetScrollbars scrollbarSize={4}>
          <Stack gap="md">
            <Paper
              radius="sm"
              p="md"
              bg="var(--bg-card)"
              style={{ border: "1px solid var(--border)" }}
            >
              <Text size="sm" fw={600} c="var(--text-main)" mb="md">
                General Configuration
              </Text>
              <SimpleGrid cols={3} spacing="md">
                <TextInput
                  classNames={global}
                  label={lang.label}
                  description={lang.pawn_label_desc}
                  size="xs"
                  maxLength={30}
                  value={config.label}
                  onChange={(e) => updateConfig("label", e.currentTarget.value)}
                />
                <Select
                  classNames={global}
                  label={lang.pawn_linked_job}
                  description={lang.pawn_linked_job_desc}
                  size="xs"
                  data={allJobs}
                  value={config.job}
                  onChange={(val) => updateConfig("job", val || "")}
                  searchable
                />
              </SimpleGrid>
            </Paper>
            <Paper
              radius="sm"
              p="md"
              bg="var(--bg-card)"
              style={{ border: "1px solid var(--border)" }}
            >
              <Group justify="space-between" mb="md">
                <Box>
                  <Text size="sm" fw={600} c="var(--text-main)">
                    Items & Pricing
                  </Text>
                  <Text size="xs" c="var(--text-dim)">
                    Configure which items can be sold and their sell prices.
                  </Text>
                </Box>
                <Group gap="xs">
                  <Select
                    classNames={global}
                    placeholder={lang.pawn_select_item}
                    data={allItems}
                    value={selectedItem}
                    onChange={setSelectedItem}
                    searchable
                    size="xs"
                  />
                  <Button
                    className={global.button}
                    size="xs"
                    leftSection={<IconPlus size={13} />}
                    onClick={addItem}
                    disabled={!selectedItem}
                  >
                    Add Item
                  </Button>
                </Group>
              </Group>

              <Divider color="var(--border)" mb="md" />

              {config.items.length === 0 ? (
                <Text size="sm" c="var(--text-dim)" ta="center" py="xl">
                  No items added to this pawnshop yet.
                </Text>
              ) : (
                <Stack gap="xs">
                  {config.items.map((item) => (
                    <Group
                      key={item.name}
                      wrap="nowrap"
                      bg="var(--bg-input)"
                      p="xs"
                      style={{
                        borderRadius: "4px",
                        border: "1px solid var(--border)",
                      }}
                    >
                      <Group>
                        <ItemImage
                          inventory={inventory}
                          name={item?.name}
                          h={32}
                          w={32}
                          fit="contain"
                        />
                      </Group>
                      <Box style={{ flex: 1, minWidth: 150 }}>
                        <Text size="sm" fw={500} c="var(--text-main)" truncate>
                          {item.label}
                        </Text>
                        <Text size="xs" c="var(--text-dim)">
                          {item.name}
                        </Text>
                      </Box>
                      <NumberInput
                        size="xs"
                        min={0}
                        value={item.buyPrice}
                        onChange={(val) =>
                          updateItemConfig(
                            item.name,
                            "buyPrice",
                            Number(val) || 0,
                          )
                        }
                        classNames={global}
                        w={120}
                        label={
                          <Group gap={4}>
                            <Text size="xs">{lang.pawn_buy_label}</Text>
                            <Tooltip
                              label={lang.pawn_buy_price}
                              withArrow
                              bg="var(--tooltip)"
                              c="var(--text-main)"
                            >
                              <IconInfoCircle
                                size={14}
                                color="var(--text-dim)"
                                style={{ cursor: "help" }}
                              />
                            </Tooltip>
                          </Group>
                        }
                      />
                      <NumberInput
                        size="xs"
                        min={item.buyPrice}
                        value={item.sellPrice}
                        onChange={(val) =>
                          updateItemConfig(
                            item.name,
                            "sellPrice",
                            Number(val) || 0,
                          )
                        }
                        classNames={global}
                        w={120}
                        label={
                          <Group gap={4}>
                            <Text size="xs">{lang.pawn_sell_label}</Text>
                            <Tooltip
                              label={lang.pawn_sell_price}
                              bg="var(--tooltip)"
                              c="var(--text-main)"
                              withArrow
                            >
                              <IconInfoCircle
                                size={14}
                                color="var(--text-dim)"
                                style={{ cursor: "help" }}
                              />
                            </Tooltip>
                          </Group>
                        }
                      />
                      <ActionIcon
                        color="#f87171"
                        variant="subtle"
                        onClick={() => removeItem(item.name)}
                        mt={18}
                      >
                        <IconTrash size={16} />
                      </ActionIcon>
                    </Group>
                  ))}
                </Stack>
              )}
            </Paper>
          </Stack>
        </ScrollArea>
      )}
    </Stack>
  );
};

export default Pawnshop;
