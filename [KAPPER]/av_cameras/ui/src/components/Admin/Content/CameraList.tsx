import { useState, useMemo, useEffect } from "react";
import {
  Table,
  TextInput,
  Select,
  Group,
  Badge,
  ActionIcon,
  Text,
  Stack,
  Progress,
  Tooltip,
  ScrollArea,
} from "@mantine/core";
import {
  Eye,
  Trash2,
  MapPin,
  VideoOff,
  Copy,
  Settings,
  Globe,
} from "lucide-react";
import { CameraType } from "../../../types/types";
import {
  fetchNui,
  isEnvBrowser,
  useNuiEvent,
} from "../../../hooks/useNuiEvents";
import { ApiCameras } from "../../../Api/Cameras";
import { Loading } from "../../Loading";
import { STATUS_CONFIG, batteryColor, handleView } from "./utils";
import { CamPanel } from "./CamPanel";

export function CameraList() {
  const [loaded, setLoaded] = useState(false);
  const [search, setSearch] = useState("");
  const [statusFilter, setStatus] = useState<string | null>(null);
  const [cameras, setCameras] = useState<CameraType[]>([]);
  const [selected, setSelected] = useState<CameraType | null>(null);

  useNuiEvent("updateCamera", (data: CameraType) => {
    setCameras((prev) => {
      const idx = prev.findIndex((c) => c.identifier === data.identifier);
      if (idx !== -1) {
        const copy = [...prev];
        copy[idx] = data;
        return copy;
      }
      return prev;
    });
  });

  const filtered = useMemo(
    () =>
      cameras
        .filter((c) => {
          const q = search.toLowerCase();
          const matchQ =
            !q ||
            [c.label, c.location, c.owner].some((s) =>
              s.toLowerCase().includes(q),
            );
          const matchSt = !statusFilter || c.status === statusFilter;
          return matchQ && matchSt;
        })
        .sort((a, b) => (a.label ?? "").localeCompare(b.label ?? "")),
    [cameras, search, statusFilter],
  );

  const handleDelete = async (identifier: string) => {
    await fetchNui("av_cameras", "deleteAdminCamera", identifier);
    setCameras((c) => c.filter((x) => x.identifier !== identifier));
  };

  const fetchCameras = async () => {
    const cams = await fetchNui("av_cameras", "getAdminCameras", false);
    setTimeout(() => {
      setLoaded(true);
    }, 250);
    if (isEnvBrowser()) {
      setCameras(ApiCameras);
      return;
    }
    setCameras(cams);
  };

  useEffect(() => {
    fetchCameras();
  }, []);

  if (!loaded) return <Loading />;

  const rows = filtered.map((cam) => {
    const status = STATUS_CONFIG[cam.status ?? "unassigned"];

    return (
      <Table.Tr key={cam.identifier}>
        <Table.Td>
          <Stack gap={2}>
            <Text size="sm" fw={500} truncate maw={200}>
              {cam.label}
            </Text>
            <Group gap={4}>
              <MapPin size={11} color="var(--text-secondary)" />
              <Text size="xs" c="dimmed">
                {cam.location}
              </Text>
            </Group>
          </Stack>
        </Table.Td>
        <Table.Td>
          <Group gap={6}>
            <Tooltip
              label="Copy owner ID"
              withArrow
              fz="xs"
              radius="md"
              bg="var(--tooltip)"
              color="var(--text)"
            >
              <ActionIcon
                size="xs"
                variant="transparent"
                onClick={() => {
                  fetchNui("av_laptop", "copy", cam.owner);
                }}
              >
                <Copy size={12} color="cyan" strokeWidth={2.25} />
              </ActionIcon>
            </Tooltip>
            <Text size="xs" maw={150} truncate>
              {cam.owner}
            </Text>
          </Group>
        </Table.Td>
        <Table.Td>
          <Badge size="sm" color={status.color} variant="light">
            {status.label}
          </Badge>
        </Table.Td>
        <Table.Td>{cam.type === "vehicle" ? "Vehicle" : "Camera"}</Table.Td>

        <Table.Td>
          <Group gap={8} wrap="nowrap">
            <Progress
              value={cam.battery}
              color={batteryColor(cam.battery)}
              size="xs"
              w={48}
            />
            <Text size="xs" fw={500} c={batteryColor(cam.battery)}>
              {cam.battery}%
            </Text>
          </Group>
        </Table.Td>
        <Table.Td
          data-actions-cell
          style={{ whiteSpace: "nowrap", width: "1%" }}
        >
          <Group gap={6} justify="flex-end" wrap="nowrap">
            <Tooltip
              label="View camera"
              withArrow
              fz="xs"
              radius="md"
              bg="var(--tooltip)"
              color="var(--text)"
            >
              <ActionIcon
                variant="transparent"
                c="cyan"
                onClick={() => handleView(cam)}
                aria-label="View"
              >
                <Eye size={15} />
              </ActionIcon>
            </Tooltip>
            {cam.type !== "vehicle" && (
              <>
                <Tooltip
                  label="Ping camera on map"
                  withArrow
                  fz="xs"
                  radius="md"
                  bg="var(--tooltip)"
                  color="var(--text)"
                >
                  <ActionIcon
                    variant="transparent"
                    c="violet"
                    onClick={() =>
                      fetchNui("av_laptop", "setGPS", {
                        x: cam.coords.coords.x,
                        y: cam.coords.coords.y,
                      })
                    }
                    aria-label="Ping"
                  >
                    <MapPin size={15} />
                  </ActionIcon>
                </Tooltip>
                <Tooltip
                  label="Teleport to camera"
                  withArrow
                  fz="xs"
                  radius="md"
                  bg="var(--tooltip)"
                  color="var(--text)"
                >
                  <ActionIcon
                    variant="transparent"
                    c="pink"
                    onClick={() =>
                      fetchNui("av_laptop", "teleport", {
                        x: cam.coords.coords.x,
                        y: cam.coords.coords.y,
                        z: cam.coords.coords.z,
                      })
                    }
                    aria-label="Teleport"
                  >
                    <Globe size={15} />
                  </ActionIcon>
                </Tooltip>
              </>
            )}
            <Tooltip
              label="Edit settings"
              withArrow
              fz="xs"
              radius="md"
              bg="var(--tooltip)"
              color="var(--text)"
            >
              <ActionIcon
                variant="transparent"
                c="yellow"
                onClick={() => setSelected(cam)}
                aria-label="Settings"
              >
                <Settings size={15} />
              </ActionIcon>
            </Tooltip>
            <Tooltip
              label="Delete camera (2 clicks)"
              withArrow
              fz="xs"
              radius="md"
              bg="var(--tooltip)"
              color="var(--text)"
            >
              <ActionIcon
                variant="transparent"
                c="red"
                onDoubleClick={() => handleDelete(cam.identifier)}
                aria-label="Delete"
              >
                <Trash2 size={15} />
              </ActionIcon>
            </Tooltip>
          </Group>
        </Table.Td>
      </Table.Tr>
    );
  });

  return (
    <Stack gap="md" p="xs">
      {selected && (
        <CamPanel camera={selected} onClose={() => setSelected(null)} />
      )}
      <Group gap="sm">
        <Text fz="xs" c="var(--text-main)">
          List of all cameras installed on server and owned by players.
        </Text>
        <Group ml="auto">
          <TextInput
            classNames={{
              input: "input",
            }}
            size="xs"
            placeholder="Search label, location, owner..."
            value={search}
            onChange={(e) => setSearch(e.currentTarget.value)}
            style={{ flex: 1, maxWidth: 320 }}
          />
          <Select
            classNames={{
              input: "input",
              dropdown: "dropdown",
              option: "option",
            }}
            size="xs"
            placeholder="All statuses"
            value={statusFilter}
            onChange={setStatus}
            clearable
            w={160}
            data={[
              { value: "live", label: "Live" },
              { value: "offline", label: "Offline" },
              { value: "unassigned", label: "Unassigned" },
              { value: "support-needed", label: "Support needed" },
            ]}
          />
        </Group>
      </Group>
      <ScrollArea h={480} type="hover" scrollbarSize={6}>
        <Table
          striped
          highlightOnHover
          withTableBorder
          withColumnBorders={false}
          stripedColor="var(--bg-card)"
        >
          <Table.Thead>
            <Table.Tr>
              <Table.Th>Label / location</Table.Th>
              <Table.Th>Owner</Table.Th>
              <Table.Th>Status</Table.Th>
              <Table.Th>Type</Table.Th>
              <Table.Th>Battery</Table.Th>
              <Table.Th
                style={{
                  whiteSpace: "nowrap",
                  width: "1%",
                }}
              >
                Actions
              </Table.Th>
            </Table.Tr>
          </Table.Thead>
          <Table.Tbody>
            {rows.length > 0 ? (
              rows
            ) : (
              <Table.Tr>
                <Table.Td colSpan={6}>
                  <Stack align="center" py="xl" gap="xs">
                    <VideoOff size={24} color="var(--text-dim)" />
                    <Text size="sm" c="dimmed">
                      No cameras match your filters.
                    </Text>
                  </Stack>
                </Table.Td>
              </Table.Tr>
            )}
          </Table.Tbody>
        </Table>
      </ScrollArea>
    </Stack>
  );
}
