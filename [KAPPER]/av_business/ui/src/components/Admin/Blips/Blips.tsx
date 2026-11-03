import { useEffect, useState } from "react";
import {
  Stack,
  Group,
  Text,
  Grid,
  Switch,
  NumberInput,
  TextInput,
  Select,
  Button,
  ActionIcon,
  ScrollAreaAutosize,
  Table,
  Tooltip,
  Badge,
} from "@mantine/core";
import { IconEdit, IconTrash, IconCurrentLocation } from "@tabler/icons-react";
import { useAtomValue } from "jotai";
import { Lang } from "../../../reducers/atoms";
import { fetchNui, isEnvBrowser } from "../../../hooks/useNuiEvents";
import { ApiBlips } from "../../../API/admin_settings";
import { BlipEntry, BlipsType } from "../types";
import { SelectType } from "../../../types/types";
import { Loading } from "../../Loading";
import global from "../../../global.module.css";
import classes from "./style.module.css";

const DEFAULT_ENTRY: BlipEntry = {
  x: 0,
  y: 0,
  z: 0,
  label: "",
  sprite: 59,
  color: 2,
  online: false,
};

const Blips = ({ allJobs }: { allJobs: SelectType[] }) => {
  const daLang: any = useAtomValue(Lang);
  const lang = daLang.admin;
  const [loaded, setLoaded] = useState(false);
  const [blips, setBlips] = useState<BlipsType>({});
  const [selectedJob, setSelectedJob] = useState<string | null>(null);
  const [form, setForm] = useState<BlipEntry>(DEFAULT_ENTRY);
  const [editingJob, setEditingJob] = useState<string | null>(null);
  const [fetchingCoords, setFetchingCoords] = useState(false);

  const updateForm = <K extends keyof BlipEntry>(key: K, value: BlipEntry[K]) =>
    setForm((prev) => ({ ...prev, [key]: value }));

  const resetForm = () => {
    setSelectedJob(null);
    setForm(DEFAULT_ENTRY);
    setEditingJob(null);
  };

  const loadForEdit = (job: string) => {
    const entry = blips[job];
    if (!entry) return;
    setSelectedJob(job);
    setForm({ ...entry });
    setEditingJob(job);
  };

  const useMyCoords = async () => {
    setFetchingCoords(true);
    const coords = await fetchNui<{ x: number; y: number; z: number }>(
      "av_business",
      "getPlayerCoords",
    );
    if (coords) {
      setForm((prev) => ({ ...prev, x: coords.x, y: coords.y, z: coords.z }));
    }
    setFetchingCoords(false);
  };

  const handleAddOrUpdate = () => {
    if (!selectedJob) return;
    setBlips((prev) => ({ ...prev, [selectedJob]: { ...form } }));
    resetForm();
  };

  const handleDelete = (job: string) => {
    setBlips((prev) => {
      const updated = { ...prev };
      delete updated[job];
      return updated;
    });
    if (editingJob === job) resetForm();
  };

  const handleSave = () => {
    fetchNui("av_business", "updateSettings", {
      settings: blips,
      type: "blips",
    });
  };

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_business", "getSettings", "blips");
      if (resp && Object.keys(resp).length > 0) {
        setBlips(resp);
      } else if (isEnvBrowser()) {
        setBlips(ApiBlips);
      }
      setTimeout(() => setLoaded(true), 100);
    };
    fetchData();
  }, []);

  if (!loaded) return <Loading />;
  const entries = Object.entries(blips);
  const canAdd = !!selectedJob && form.label.trim().length > 0;

  return (
    <Grid h={660} gap="md">
      <Grid.Col span={5}>
        <Stack className={classes.formCard} gap="xs" h="100%">
          <Text fz="xs" c="var(--text-dim)" lts={0.55}>
            {editingJob
              ? `${lang.blips_editing} ${editingJob}`
              : lang.blips_add_new}
          </Text>
          <Select
            classNames={global}
            label={lang.blips_job}
            placeholder="Select job..."
            size="xs"
            searchable
            data={allJobs}
            value={selectedJob}
            onChange={setSelectedJob}
            disabled={!!editingJob}
          />
          <TextInput
            classNames={global}
            label={lang.blips_blip_label}
            placeholder={lang.blips_label_placeholder}
            size="xs"
            value={form.label}
            onChange={(e) => updateForm("label", e.currentTarget.value)}
          />
          <Stack gap={4}>
            <Group justify="space-between" align="center">
              <Text fz="xs" c="var(--text-dim)">
                {lang.blips_coordinates}
              </Text>
              <Tooltip
                label={lang.blips_use_coords_tip}
                fz="xs"
                color="var(--tooltip)"
                withArrow
              >
                <Button
                  size="xs"
                  variant="subtle"
                  color="cyan"
                  loading={fetchingCoords}
                  leftSection={
                    <IconCurrentLocation style={{ height: 12, width: 12 }} />
                  }
                  onClick={useMyCoords}
                  px={8}
                >
                  {lang.blips_use_coords}
                </Button>
              </Tooltip>
            </Group>
            <Group gap="xs">
              <NumberInput
                classNames={global}
                placeholder="X"
                size="xs"
                decimalScale={3}
                allowNegative
                value={form.x}
                onChange={(e) => updateForm("x", Number(e))}
                style={{ flex: 1 }}
              />
              <NumberInput
                classNames={global}
                placeholder="Y"
                size="xs"
                decimalScale={3}
                allowNegative
                value={form.y}
                onChange={(e) => updateForm("y", Number(e))}
                style={{ flex: 1 }}
              />
              <NumberInput
                classNames={global}
                placeholder="Z"
                size="xs"
                decimalScale={3}
                allowNegative
                value={form.z}
                onChange={(e) => updateForm("z", Number(e))}
                style={{ flex: 1 }}
              />
            </Group>
          </Stack>
          <Group gap="xs">
            <Stack gap={4} style={{ flex: 1 }}>
              <Tooltip
                label={lang.blips_sprite_tip}
                fz="xs"
                color="var(--tooltip)"
                withArrow
                position="top-start"
              >
                <Text fz="xs" c="var(--text-dim)" style={{ cursor: "help" }}>
                  {lang.blips_sprite}
                </Text>
              </Tooltip>
              <NumberInput
                classNames={global}
                size="xs"
                min={0}
                max={999}
                allowDecimal={false}
                allowNegative={false}
                value={form.sprite}
                onChange={(e) => updateForm("sprite", Number(e))}
              />
            </Stack>
            <Stack gap={4} style={{ flex: 1 }}>
              <Tooltip
                label={lang.blips_color_tip}
                fz="xs"
                color="var(--tooltip)"
                withArrow
                position="top-start"
              >
                <Text fz="xs" c="var(--text-dim)" style={{ cursor: "help" }}>
                  {lang.blips_color}
                </Text>
              </Tooltip>
              <NumberInput
                classNames={global}
                size="xs"
                min={0}
                max={85}
                allowDecimal={false}
                allowNegative={false}
                value={form.color}
                onChange={(e) => updateForm("color", Number(e))}
              />
            </Stack>
          </Group>
          <Switch
            classNames={global}
            size="xs"
            color="var(--accent)"
            label={lang.blips_online}
            checked={form.online}
            onChange={(e) => updateForm("online", e.currentTarget.checked)}
          />
          <Group mt="auto" gap="xs">
            <Button
              className={global.button}
              size="xs"
              disabled={!canAdd}
              onClick={handleAddOrUpdate}
              style={{ flex: 1 }}
            >
              {editingJob ? lang.blips_update : lang.blips_add}
            </Button>
            {editingJob && (
              <Button
                size="xs"
                variant="subtle"
                color="gray"
                onClick={resetForm}
              >
                {lang.cancel}
              </Button>
            )}
          </Group>
        </Stack>
      </Grid.Col>
      <Grid.Col span="auto">
        <Stack gap="xs" h="100%">
          <Group>
            <Text fz="xs" c="var(--text-dim)" lts={0.55}>
              {entries.length > 0
                ? `${entries.length} ${lang.blips_configured}`
                : lang.blips_none_configured}
            </Text>
            <Button
              className={global.button}
              size="xs"
              ml="auto"
              disabled={entries.length === 0}
              onClick={handleSave}
            >
              {lang.save_changes}
            </Button>
          </Group>
          {entries.length === 0 ? (
            <Text className={classes.emptyState}>{lang.blips_empty_hint}</Text>
          ) : (
            <ScrollAreaAutosize
              h={590}
              type="hover"
              scrollbars="y"
              scrollbarSize={5}
            >
              <Table layout="fixed" fz="xs">
                <Table.Thead>
                  <Table.Tr>
                    <Table.Th w={110}>{lang.blips_job}</Table.Th>
                    <Table.Th>{lang.label}</Table.Th>
                    <Table.Th w={55}>{lang.blips_sprite}</Table.Th>
                    <Table.Th w={50}>{lang.blips_color}</Table.Th>
                    <Table.Th w={65}>{lang.blips_online_col}</Table.Th>
                    <Table.Th w={60}>{lang.actions}</Table.Th>
                  </Table.Tr>
                </Table.Thead>
                <Table.Tbody>
                  {entries.map(([job, entry]) => (
                    <Table.Tr
                      key={job}
                      bg={
                        editingJob === job
                          ? "rgba(255,255,255,0.04)"
                          : undefined
                      }
                    >
                      <Table.Td>
                        <Text fz="xs" truncate>
                          {job}
                        </Text>
                      </Table.Td>
                      <Table.Td>
                        <Text fz="xs" truncate>
                          {entry.label}
                        </Text>
                      </Table.Td>
                      <Table.Td>{entry.sprite}</Table.Td>
                      <Table.Td>{entry.color}</Table.Td>
                      <Table.Td>
                        <Badge
                          size="xs"
                          color={entry.online ? "teal" : "gray"}
                          variant="light"
                        >
                          {entry.online ? lang.yes : lang.no}
                        </Badge>
                      </Table.Td>
                      <Table.Td>
                        <Group gap={4}>
                          <Tooltip
                            label={lang.blips_edit_tip}
                            fz="xs"
                            color="var(--tooltip)"
                          >
                            <ActionIcon
                              size="xs"
                              variant="transparent"
                              color="cyan"
                              onClick={() => loadForEdit(job)}
                            >
                              <IconEdit
                                style={{ height: 13, width: 13 }}
                                stroke={1.5}
                              />
                            </ActionIcon>
                          </Tooltip>
                          <Tooltip
                            label={lang.blips_delete_tip}
                            fz="xs"
                            color="var(--tooltip)"
                          >
                            <ActionIcon
                              size="xs"
                              variant="transparent"
                              color="red"
                              onDoubleClick={() => handleDelete(job)}
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
                </Table.Tbody>
              </Table>
            </ScrollAreaAutosize>
          )}
        </Stack>
      </Grid.Col>
    </Grid>
  );
};

export default Blips;
