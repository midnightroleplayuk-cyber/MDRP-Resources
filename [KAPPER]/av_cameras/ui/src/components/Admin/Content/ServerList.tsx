import { useState, useMemo, useEffect, useRef } from "react";
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
  Button,
  Image,
  Paper,
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
import { CameraType, SelectType } from "../../../types/types";
import {
  fetchNui,
  isEnvBrowser,
  useNuiEvent,
} from "../../../hooks/useNuiEvents";
import { ApiCameras } from "../../../Api/Cameras";
import { DUMMY_CAMERA, STATUS_CONFIG, batteryColor } from "./utils";
import { Loading } from "../../Loading";
import { CamPanel } from "./CamPanel";
import { ApiGroups } from "../../../Api/Groups";
import { useMouse } from "@mantine/hooks";

interface ThumbnailPreviewProps {
  src: string;
  x: number;
  y: number;
}

function ThumbnailPreview({ src, x, y }: ThumbnailPreviewProps) {
  return (
    <Paper
      shadow="md"
      radius="md"
      withBorder
      style={{
        position: "absolute",
        top: y,
        left: x + 12,
        zIndex: 9999,
        pointerEvents: "none",
        overflow: "hidden",
        width: 200,
        transform: "translateY(-50%)",
        border: "1px solid var(--border)",
        background: "var(--bg-card)",
      }}
    >
      <Image
        src={src}
        alt="Camera thumbnail"
        fit="cover"
        h={120}
        fallbackSrc="https://placehold.co/200x120?text=No+preview"
      />
    </Paper>
  );
}

export function ServerList() {
  const [loaded, setLoaded] = useState(false);
  const [search, setSearch] = useState("");
  const [statusFilter, setStatus] = useState<string | null>(null);
  const [groupFilter, setGroup] = useState<string | null>(null);
  const [cameras, setCameras] = useState<CameraType[]>([]);
  const [allGroups, setAllGroups] = useState<SelectType[]>([]);
  const [selected, setSelected] = useState<CameraType | null>(null);
  const [creator, setCreator] = useState(false);
  const { ref: mouseRef, x, y } = useMouse();
  const [thumbnail, setThumbnail] = useState<{
    src: string;
    x: number;
    y: number;
  } | null>(null);

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

  useNuiEvent("refreshServer", () => {
    fetchCameras();
  });

  const onView = (cam: CameraType) => {
    fetchNui("av_cameras", "connectCamera", cam);
  };

  const onDelete = async (cam: CameraType) => {
    await fetchNui("av_cameras", "deleteAdminCamera", cam.identifier);
    const updated = cameras.filter((c) => c.identifier !== cam.identifier);
    setCameras(updated);
  };

  const filtered = useMemo(
    () =>
      cameras
        .filter((c) => {
          const q = search.toLowerCase();
          const matchQ =
            !q ||
            [c.label, c.location, c.group_id].some((s) =>
              s?.toLowerCase().includes(q),
            );
          const matchSt = !statusFilter || c.status === statusFilter;
          const matchGr = !groupFilter || c.group_id === groupFilter;
          return matchQ && matchSt && matchGr;
        })
        .sort((a, b) => (a.label ?? "").localeCompare(b.label ?? "")),
    [cameras, search, statusFilter, groupFilter],
  );

  const fetchCameras = async () => {
    const resp = await fetchNui("av_cameras", "getAdminCameras", true);
    if (resp) {
      const sortedCameras: CameraType[] = (resp.cameras || []).sort(
        (a: CameraType, b: CameraType) =>
          (a.label ?? "").localeCompare(b.label ?? ""),
      );
      setCameras(sortedCameras);
      const sortedGroups: SelectType[] = (resp.groups || []).sort(
        (a: SelectType, b: SelectType) => a.label.localeCompare(b.label),
      );
      setAllGroups(sortedGroups);
    } else {
      if (isEnvBrowser()) {
        setCameras(ApiCameras);
        setAllGroups(ApiGroups);
      }
    }
    setTimeout(() => {
      setLoaded(true);
    }, 250);
  };

  useEffect(() => {
    fetchCameras();
  }, []);

  if (!loaded) return <Loading />;

  const rows = filtered.map((cam) => {
    const status = STATUS_CONFIG[cam.status ?? "unassigned"];

    return (
      <Table.Tr
        key={cam.identifier}
        onMouseMove={(e) => {
          const target = e.target as HTMLElement;
          if (target.closest("[data-actions-cell]")) {
            setThumbnail(null);
            return;
          }
          if (cam.thumbnail) {
            setThumbnail({ src: cam.thumbnail, x, y });
          }
        }}
        onMouseLeave={() => setThumbnail(null)}
      >
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
        <Table.Td>{cam.group_id}</Table.Td>
        <Table.Td>
          <Badge size="sm" color={status.color} variant="light">
            {status.label}
          </Badge>
        </Table.Td>
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
                onClick={() => onView(cam)}
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
                onDoubleClick={() => onDelete(cam)}
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
    <Stack gap="md" p="xs" style={{ position: "relative" }} ref={mouseRef}>
      {thumbnail && <ThumbnailPreview src={thumbnail.src} x={x} y={y} />}

      {selected && (
        <CamPanel
          camera={selected}
          onClose={() => {
            setSelected(null);
            setCreator(false);
          }}
          isServer={true}
          isCreator={creator}
          allGroups={allGroups}
        />
      )}
      <Group gap="sm">
        <Text fz="xs" c="var(--text-main)">
          List of all cameras installed on server by admins.
        </Text>
        <Group ml="auto" gap="xs" wrap="nowrap">
          <Button
            size="xs"
            variant="outline"
            color="var(--accent)"
            onClick={() => {
              setCreator(true);
              setSelected(DUMMY_CAMERA);
            }}
          >
            Create Camera
          </Button>
          <TextInput
            classNames={{ input: "input" }}
            w={100}
            size="xs"
            placeholder="Search..."
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
            placeholder="Filter by group"
            value={groupFilter}
            onChange={setGroup}
            clearable
            w={160}
            data={allGroups}
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
              <Table.Th>Group</Table.Th>
              <Table.Th>Status</Table.Th>
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
                <Table.Td colSpan={5}>
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
