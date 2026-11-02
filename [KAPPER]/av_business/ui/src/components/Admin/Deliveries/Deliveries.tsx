import { useEffect, useState } from "react";
import {
  Stack,
  Button,
  Group,
  Text,
  Grid,
  Switch,
  Card,
  NumberInput,
  RangeSlider,
  Flex,
  Tooltip,
  Box,
  SegmentedControl,
  TextInput,
  ScrollAreaAutosize,
  Table,
  ActionIcon,
  Badge,
} from "@mantine/core";
import {
  IconTrash,
  IconCurrentLocation,
  IconCheck,
  IconMapPinShare,
} from "@tabler/icons-react";
import { SelectType } from "../../../types/types";
import { useAtomValue } from "jotai";
import { Lang } from "../../../reducers/atoms";
import { fetchNui, isEnvBrowser } from "../../../hooks/useNuiEvents";
import { ApiDeliveries } from "../../../API/admin_settings";
import { DeliveriesType } from "../types";
import global from "../../../global.module.css";
import classes from "./style.module.css";
import { Loading } from "../../Loading";
import { MultiSelector } from "../MultiSelector";

const SettingCard = ({ title, tooltip, children, span = 3 }: any) => (
  <Grid.Col span={span}>
    <Card className={classes.card}>
      <Flex direction="column" gap="sm">
        <Group>
          <Text fz="sm" c="var(--text-dim)">
            {title}
          </Text>
          <Tooltip
            label={tooltip}
            fz="xs"
            color="var(--tooltip)"
            lts={1}
            multiline
            maw={220}
            withArrow
            position="top-start"
          >
            <Box className={classes.tooltip} bg="var(--tooltip)">
              <Text fz={10} c="var(--text-dim)">
                ?
              </Text>
            </Box>
          </Tooltip>
        </Group>
        {children}
      </Flex>
    </Card>
  </Grid.Col>
);

const SettingsSection = ({
  settings,
  updateField,
  itemTypes,
}: {
  settings: DeliveriesType;
  updateField: <K extends keyof DeliveriesType>(
    k: K,
    v: DeliveriesType[K],
  ) => void;
  itemTypes: SelectType[];
}) => {
  const daLang: any = useAtomValue(Lang);
  const lang = daLang.admin;
  return (
  <Grid>
    <SettingCard title={lang.del_max_distance} tooltip={lang.del_max_distance_tip}>
      <NumberInput
        classNames={global}
        size="xs"
        min={1}
        max={10000}
        value={settings.maxDistance}
        allowDecimal={false}
        onChange={(e) => updateField("maxDistance", Number(e))}
      />
    </SettingCard>
    <SettingCard title={lang.del_min_products} tooltip={lang.del_min_products_tip}>
      <NumberInput
        classNames={global}
        size="xs"
        min={1}
        max={50}
        value={settings.minProducts}
        allowDecimal={false}
        allowNegative={false}
        onChange={(e) => updateField("minProducts", Number(e))}
      />
    </SettingCard>
    <SettingCard title={lang.del_max_products} tooltip={lang.del_max_products_tip}>
      <NumberInput
        classNames={global}
        size="xs"
        min={1}
        max={1000}
        value={settings.maxProducts}
        allowDecimal={false}
        allowNegative={false}
        onChange={(e) => updateField("maxProducts", Number(e))}
      />
    </SettingCard>
    <SettingCard
      title={lang.del_max_orders}
      tooltip={lang.del_max_orders_tip}
    >
      <NumberInput
        classNames={global}
        size="xs"
        min={1}
        max={100}
        value={settings.maxOrders}
        allowDecimal={false}
        allowNegative={false}
        onChange={(e) => updateField("maxOrders", Number(e))}
      />
    </SettingCard>
    <SettingCard
      title={lang.del_max_price}
      tooltip={lang.del_max_price_tip}
    >
      <NumberInput
        classNames={global}
        size="xs"
        min={1}
        max={1000000}
        value={settings.maxPrice}
        allowDecimal={false}
        allowNegative={false}
        onChange={(e) => updateField("maxPrice", Number(e))}
      />
    </SettingCard>
    <SettingCard
      title={lang.del_max_tip_val}
      tooltip={lang.del_max_tip_tip}
    >
      <NumberInput
        classNames={global}
        size="xs"
        min={1}
        max={1000000}
        value={settings.maxTip}
        allowDecimal={false}
        allowNegative={false}
        onChange={(e) => updateField("maxTip", Number(e))}
      />
    </SettingCard>
    <SettingCard
      title={lang.del_overprice}
      tooltip={lang.del_overprice_tip}
    >
      <NumberInput
        classNames={global}
        size="xs"
        min={1}
        max={100}
        value={settings.overprice}
        allowDecimal={false}
        allowNegative={false}
        onChange={(e) => updateField("overprice", Number(e))}
      />
    </SettingCard>
    <SettingCard
      title={lang.del_ignored_types}
      tooltip={lang.del_ignored_types_tip}
    >
      <MultiSelector
        values={settings.toIgnore}
        data={itemTypes}
        updateData={(e) => updateField("toIgnore", e)}
      />
    </SettingCard>
    <SettingCard
      title={lang.del_waiting_time}
      tooltip={lang.del_waiting_time_tip}
    >
      <RangeSlider
        mt="xs"
        classNames={global}
        size="xs"
        value={[settings.deliveryWait[0] ?? 1, settings.deliveryWait[1] ?? 30]}
        min={1}
        max={30}
        step={1}
        minRange={1}
        onChange={(e) => updateField("deliveryWait", e)}
      />
    </SettingCard>
  </Grid>
  );
};

const ModelsSection = ({
  models,
  setModels,
}: {
  models: string[];
  setModels: (m: string[]) => void;
}) => {
  const daLang: any = useAtomValue(Lang);
  const lang = daLang.admin;
  const [input, setInput] = useState("");
  const [filter, setFilter] = useState("");

  const addModel = () => {
    const trimmed = input.trim().toLowerCase();
    if (!trimmed || models.includes(trimmed)) return;
    setModels([...models, trimmed]);
    setInput("");
  };

  const verifyAsset = () => {
    if (input.trim()) fetchNui("av_business", "verifyAsset", input.trim());
  };

  const removeModel = (name: string) =>
    setModels(models.filter((m) => m !== name));

  const filtered = filter
    ? models.filter((m) => m.toLowerCase().includes(filter.toLowerCase()))
    : models;

  return (
    <Stack gap="xs">
      <Group gap="xs">
        <TextInput
          classNames={global}
          size="xs"
          placeholder={lang.del_model_placeholder}
          value={input}
          style={{ flex: 1 }}
          onChange={(e) => setInput(e.currentTarget.value)}
          onKeyDown={(e) => {
            if (e.key === "Enter") addModel();
          }}
        />
        <Tooltip
          label={lang.del_test_model}
          fz="xs"
          color="var(--tooltip)"
          withArrow
        >
          <Button
            size="xs"
            variant="subtle"
            color="cyan"
            onClick={verifyAsset}
            disabled={!input.trim()}
          >
            Test
          </Button>
        </Tooltip>
        <Button
          className={global.button}
          size="xs"
          onClick={addModel}
          disabled={!input.trim()}
        >
          Add
        </Button>
      </Group>
      <Group gap="xs">
        <TextInput
          classNames={global}
          size="xs"
          placeholder="Search..."
          value={filter}
          style={{ flex: 1 }}
          onChange={(e) => setFilter(e.currentTarget.value)}
        />
        <Badge size="sm" variant="light" color="gray">
          {models.length} models
        </Badge>
      </Group>
      <ScrollAreaAutosize h={430} type="hover" scrollbars="y" scrollbarSize={5}>
        <Table layout="fixed" fz="xs">
          <Table.Thead>
            <Table.Tr>
              <Table.Th w={45}>#</Table.Th>
              <Table.Th>Model name</Table.Th>
              <Table.Th w={60}>Remove</Table.Th>
            </Table.Tr>
          </Table.Thead>
          <Table.Tbody>
            {filtered.map((model) => (
              <Table.Tr key={model}>
                <Table.Td c="var(--text-dim)">
                  {models.indexOf(model) + 1}
                </Table.Td>
                <Table.Td>
                  <Text fz="xs" ff="monospace" truncate>
                    {model}
                  </Text>
                </Table.Td>
                <Table.Td>
                  <Tooltip
                    label={lang.access_remove_tooltip}
                    fz="xs"
                    color="var(--tooltip)"
                  >
                    <ActionIcon
                      size="xs"
                      variant="transparent"
                      color="red"
                      onDoubleClick={() => removeModel(model)}
                    >
                      <IconTrash
                        style={{ height: 13, width: 13 }}
                        stroke={1.5}
                      />
                    </ActionIcon>
                  </Tooltip>
                </Table.Td>
              </Table.Tr>
            ))}
            {filtered.length === 0 && (
              <Table.Tr>
                <Table.Td colSpan={3}>
                  <Text fz="xs" c="var(--text-dim)" ta="center" py="md">
                    {filter
                      ? "No models match your search"
                      : "No NPC models added yet"}
                  </Text>
                </Table.Td>
              </Table.Tr>
            )}
          </Table.Tbody>
        </Table>
      </ScrollAreaAutosize>
    </Stack>
  );
};

const CoordsSection = ({
  coords,
  setCoords,
}: {
  coords: number[][];
  setCoords: (c: number[][]) => void;
}) => {
  const daLang: any = useAtomValue(Lang);
  const lang = daLang.admin;
  const [x, setX] = useState<number>(0);
  const [y, setY] = useState<number>(0);
  const [z, setZ] = useState<number>(0);
  const [fetching, setFetching] = useState(false);

  const useMyCoords = async () => {
    setFetching(true);
    const res = await fetchNui<{ x: number; y: number; z: number }>(
      "av_business",
      "getPlayerCoords",
    );
    if (res) {
      setX(res.x);
      setY(res.y);
      setZ(res.z);
    }
    setFetching(false);
  };

  const teleport = (coord: number[]) => {
    fetchNui("av_laptop", "teleport", {
      x: coord[0],
      y: coord[1],
      z: coord[2],
    });
  };

  const addCoord = () => {
    setCoords([...coords, [x, y, z]]);
    setX(0);
    setY(0);
    setZ(0);
  };

  const removeCoord = (idx: number) =>
    setCoords(coords.filter((_, i) => i !== idx));

  return (
    <Stack gap="xs">
      <Group gap="xs" align="flex-end">
        <NumberInput
          classNames={global}
          label="X"
          size="xs"
          decimalScale={3}
          allowNegative
          value={x}
          onChange={(e) => setX(Number(e))}
          style={{ flex: 1 }}
        />
        <NumberInput
          classNames={global}
          label="Y"
          size="xs"
          decimalScale={3}
          allowNegative
          value={y}
          onChange={(e) => setY(Number(e))}
          style={{ flex: 1 }}
        />
        <NumberInput
          classNames={global}
          label="Z"
          size="xs"
          decimalScale={3}
          allowNegative
          value={z}
          onChange={(e) => setZ(Number(e))}
          style={{ flex: 1 }}
        />
        <Tooltip
          label={lang.del_use_pos}
          fz="xs"
          color="var(--tooltip)"
          withArrow
        >
          <Button
            size="xs"
            variant="subtle"
            color="cyan"
            loading={fetching}
            leftSection={
              <IconCurrentLocation style={{ height: 12, width: 12 }} />
            }
            onClick={useMyCoords}
            px={8}
          >
            My Coords
          </Button>
        </Tooltip>
        <Tooltip label="Add to list" fz="xs" color="var(--tooltip)" withArrow>
          <ActionIcon className={global.button} size="lg" onClick={addCoord}>
            <IconCheck style={{ height: 14, width: 14 }} />
          </ActionIcon>
        </Tooltip>
      </Group>
      <Group justify="flex-end">
        <Badge size="sm" variant="light" color="gray">
          {coords.length} spawn points
        </Badge>
      </Group>
      <ScrollAreaAutosize h={405} type="hover" scrollbars="y" scrollbarSize={5}>
        <Table layout="fixed" fz="xs">
          <Table.Thead>
            <Table.Tr>
              <Table.Th w={38}>#</Table.Th>
              <Table.Th>X</Table.Th>
              <Table.Th>Y</Table.Th>
              <Table.Th>Z</Table.Th>
              <Table.Th w={65}>Actions</Table.Th>
            </Table.Tr>
          </Table.Thead>
          <Table.Tbody>
            {coords.map((coord, i) => (
              <Table.Tr key={i}>
                <Table.Td c="var(--text-dim)">{i + 1}</Table.Td>
                <Table.Td ff="monospace">{coord[0] ?? 0}</Table.Td>
                <Table.Td ff="monospace">{coord[1] ?? 0}</Table.Td>
                <Table.Td ff="monospace">{coord[2] ?? 0}</Table.Td>
                <Table.Td>
                  <Group gap={4}>
                    <Tooltip
                      label={lang.zones_teleport}
                      fz="xs"
                      color="var(--tooltip)"
                    >
                      <ActionIcon
                        size="xs"
                        variant="transparent"
                        onClick={() => teleport(coord)}
                      >
                        <IconMapPinShare
                          style={{ height: 13, width: 13 }}
                          stroke={1.5}
                        />
                      </ActionIcon>
                    </Tooltip>
                    <Tooltip
                      label={lang.access_remove_tooltip}
                      fz="xs"
                      color="var(--tooltip)"
                    >
                      <ActionIcon
                        size="xs"
                        variant="transparent"
                        color="red"
                        onDoubleClick={() => removeCoord(i)}
                      >
                        <IconTrash
                          style={{ height: 13, width: 13 }}
                          stroke={1.5}
                        />
                      </ActionIcon>
                    </Tooltip>
                  </Group>
                </Table.Td>
              </Table.Tr>
            ))}
            {coords.length === 0 && (
              <Table.Tr>
                <Table.Td colSpan={5}>
                  <Text fz="xs" c="var(--text-dim)" ta="center" py="md">
                    No spawn points added yet
                  </Text>
                </Table.Td>
              </Table.Tr>
            )}
          </Table.Tbody>
        </Table>
      </ScrollAreaAutosize>
    </Stack>
  );
};

const Deliveries = ({ itemTypes }: { itemTypes: SelectType[] }) => {
  const daLang: any = useAtomValue(Lang);
  const lang = daLang.admin;
  const [loaded, setLoaded] = useState(false);
  const [settings, setSettings] = useState<DeliveriesType>(ApiDeliveries);
  const [section, setSection] = useState("settings");

  const updateField = <K extends keyof DeliveriesType>(
    field: K,
    value: DeliveriesType[K],
  ) => setSettings((prev) => ({ ...prev, [field]: value }));

  const handleSave = () => {
    fetchNui("av_business", "updateSettings", { settings, type: "deliveries" });
  };

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_business", "getSettings", "deliveries");
      if (resp) {
        setSettings(resp);
      } else if (isEnvBrowser()) {
        setSettings(ApiDeliveries);
      }
      setTimeout(() => setLoaded(true), 100);
    };
    fetchData();
  }, []);

  if (!loaded) return <Loading />;

  return (
    <Stack gap="xs">
      <Group>
        <Text fz="xs" maw={360} c="var(--text-dim)" lts={0.55}>
          Configure delivery parameters, NPC pedestrian models and spawn
          locations.
        </Text>
        <Group ml="auto" gap="xs">
          <Switch
            checked={settings.enabled}
            classNames={global}
            color="var(--accent)"
            size="xs"
            label={settings.enabled ? lang.enabled : lang.disabled}
            onChange={(e) => updateField("enabled", e.currentTarget.checked)}
          />
          <Button className={global.button} size="xs" onClick={handleSave}>
            {lang.save_changes}
          </Button>
        </Group>
      </Group>
      <SegmentedControl
        size="xs"
        value={section}
        onChange={setSection}
        classNames={{ label: classes.segLabel }}
        data={[
          { label: "Settings", value: "settings" },
          {
            label: `NPC Models (${settings.models?.length ?? 0})`,
            value: "models",
          },
          {
            label: `Spawn Points (${settings.coords?.length ?? 0})`,
            value: "coords",
          },
        ]}
        styles={{
          root: {
            backgroundColor: "var(--bg-card)",
            border: "solid 1px var(--border)",
            width: "fit-content",
          },
          indicator: { backgroundColor: "var(--accent)" },
        }}
      />
      {section === "settings" && (
        <SettingsSection
          settings={settings}
          updateField={updateField}
          itemTypes={itemTypes}
        />
      )}
      {section === "models" && (
        <ModelsSection
          models={settings.models ?? []}
          setModels={(m) => updateField("models", m)}
        />
      )}
      {section === "coords" && (
        <CoordsSection
          coords={settings.coords ?? []}
          setCoords={(c) => updateField("coords", c)}
        />
      )}
    </Stack>
  );
};

export default Deliveries;
