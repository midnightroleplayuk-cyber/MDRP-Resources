import "leaflet/dist/leaflet.css";
import { MapContainer, Marker, useMap } from "react-leaflet";
import L from "leaflet";
import { useEffect, useState } from "react";
import { CameraType, SelectType } from "../../../types/types";
import {
  Stack,
  Box,
  Text,
  ActionIcon,
  Image,
  Menu,
  Group,
  Flex,
  Divider,
  Tooltip,
} from "@mantine/core";
import {
  X,
  MapPin,
  Eye,
  Share,
  Trash2,
  EllipsisVertical,
  SquarePen,
  FolderOutput,
  Group as GroupIcon,
  HardDrive,
} from "lucide-react";
import { isBoss, Lang } from "../../../reducers/atoms";
import { useAtomValue } from "jotai";
import classes from "./map.module.css";

interface Properties {
  filtered: CameraType[];
  myCoords: { x: number; y: number };
  allGroups: SelectType[];
  handleConnection: (camera: CameraType) => void;
  handleRename: (camera: CameraType) => void;
  handleSendToGroup: (cameraGroup: string, targetGroup: string) => void;
  handleShare: (identifier: string) => void;
  handleRemove: (identifier: string) => void;
  handleAccessMemory: (identifier: string) => void;
}

const getStatusColor = (status?: string) => {
  switch (status) {
    case "live":
      return "#22c55e";
    case "offline":
      return "#ef4444";
    case "support-needed":
      return "#f59e0b";
    default:
      return "#8b9bb4";
  }
};

const createPlayerIcon = (color: string) => {
  return L.divIcon({
    className: "player-icon",
    html: `<div style="background-color: ${color}; width: 18px; height: 18px; border-radius: 50%; border: 2px solid white; box-shadow: 0 0 10px rgba(0,0,0,0.5);"></div>`,
    iconSize: [18, 18],
    iconAnchor: [9, 9],
  });
};

const createCameraIcon = (
  status: string | undefined,
  rotation: number,
  isSelected: boolean,
) => {
  const color = getStatusColor(status);
  const scale = isSelected ? "scale(1.3)" : "scale(1)";

  return L.divIcon({
    className: "custom-camera-icon",
    html: `
      <div style="
        transform: rotate(${rotation}deg) ${scale};
        display: flex;
        align-items: center;
        justify-content: center;
        width: 28px;
        height: 28px;
        position: relative;
        transition: all 0.2s ease;
      ">
        <div style="
          width: 14px;
          height: 14px;
          background-color: ${color};
          border-radius: 50%;
          border: 2px solid #1A1B1E;
          box-shadow: 0 0 10px ${color};
          z-index: 2;
        "></div>
        <div style="
          position: absolute;
          top: 0;
          width: 0;
          height: 0;
          border-left: 6px solid transparent;
          border-right: 6px solid transparent;
          border-bottom: 12px solid ${color};
          transform: translateY(-2px);
          opacity: 0.9;
        "></div>
      </div>
    `,
    iconSize: [28, 28],
    iconAnchor: [14, 14],
  });
};

const MapSetup = () => {
  const map = useMap();

  useEffect(() => {
    const customcrs = L.extend({}, L.CRS.Simple, {
      projection: L.Projection.LonLat,
      scale: function (zoom: number) {
        return Math.pow(2, zoom);
      },
      zoom: function (sc: number) {
        return Math.log(sc) / 0.6931471805599453;
      },
      distance: function (pos1: any, pos2: any) {
        var x_difference = pos2.lng - pos1.lng;
        var y_difference = pos2.lat - pos1.lat;
        return Math.sqrt(
          x_difference * x_difference + y_difference * y_difference,
        );
      },
      transformation: new L.Transformation(0.02072, 117.3, -0.0205, 172.8),
      infinite: false,
    });

    map.options.minZoom = 2.5;
    map.options.maxZoom = 5.5;
    map.options.touchZoom = false;
    map.options.preferCanvas = true;
    map.options.crs = customcrs;
    map.attributionControl.setPrefix("");
    map.options.doubleClickZoom = false;
    map.options.dragging = false;

    const sw = map.unproject([0, 1024], 2);
    const ne = map.unproject([1024, 0], 2);
    const mapbounds = new L.LatLngBounds(sw, ne);

    map.setMaxBounds(mapbounds);

    L.imageOverlay(
      "https://r2.fivemanage.com/QmVAYSlqeAlD4IxVbdvu5/map.jpeg",
      mapbounds,
    ).addTo(map);

    const panes = [
      "tilePane",
      "overlayPane",
      "shadowPane",
      "markerPane",
      "tooltipPane",
      "popupPane",
    ];
    panes.forEach((pane) => {
      const el = map.getPane(pane);
      if (el) el.style.zIndex = "2";
    });
  }, [map]);

  return null;
};

const MapView = ({
  filtered,
  myCoords = { x: 0, y: 0 },
  allGroups,
  handleConnection,
  handleRename,
  handleSendToGroup,
  handleShare,
  handleRemove,
  handleAccessMemory,
}: Properties) => {
  const lang: any = useAtomValue(Lang);
  const [index, setIndex] = useState(9999);
  const selectedCamera = index !== 9999 ? filtered[index] : null;
  const boss = useAtomValue(isBoss);

  const labels: any = {
    connected: lang.connected,
    live: lang.live,
    offline: lang.offline,
    hacked: lang.hacked,
    unassigned: lang.unassigned,
    "support-needed": lang.support_needed,
  };

  const getAvailableGroups = (camera: CameraType) =>
    allGroups.filter((g) => {
      if (g.value === camera.group_id) return false;
      if (g.type === "server" || g.server) return false;
      if (g.type === "business" && !boss) return false;
      return true;
    });

  return (
    <Stack className={classes.mapWrapper} gap={0}>
      {selectedCamera && (
        <Box className={classes.cameraOverlay}>
          <Box className={classes.overlayHeader}>
            <Text className={classes.cameraLabel}>{selectedCamera.label}</Text>
            <Group gap={4}>
              <Menu
                classNames={{
                  dropdown: "dropdown",
                  item: "item",
                }}
                shadow="md"
                width={200}
                position="bottom-end"
                withinPortal
                zIndex={9999}
              >
                <Menu.Target>
                  <ActionIcon
                    variant="subtle"
                    color="gray"
                    size="sm"
                    disabled={selectedCamera.status === "offline"}
                    bg={"transparent"}
                  >
                    <EllipsisVertical size={16} />
                  </ActionIcon>
                </Menu.Target>
                <Menu.Dropdown>
                  {selectedCamera.type !== "server" && selectedCamera.owned && (
                    <>
                      <Menu.Item
                        leftSection={<SquarePen size={14} />}
                        onClick={() => handleRename(selectedCamera)}
                      >
                        {lang.rename}
                      </Menu.Item>
                      <Menu.Item
                        leftSection={<Share size={14} />}
                        onClick={() => handleShare(selectedCamera.identifier)}
                      >
                        {lang.share}
                      </Menu.Item>
                    </>
                  )}
                  {selectedCamera.owned &&
                    getAvailableGroups(selectedCamera).length > 0 && (
                      <Menu.Sub openDelay={120} closeDelay={150}>
                        <Menu.Sub.Target>
                          <Menu.Sub.Item
                            leftSection={<FolderOutput size={14} />}
                          >
                            {lang.send_to_group}
                          </Menu.Sub.Item>
                        </Menu.Sub.Target>
                        <Menu.Sub.Dropdown
                          miw={120}
                          mah={255}
                          style={{ overflowY: "auto" }}
                        >
                          {getAvailableGroups(selectedCamera).map(
                            (targetGroup) => (
                              <Menu.Item
                                key={targetGroup.value}
                                fz="xs"
                                onClick={() =>
                                  handleSendToGroup(
                                    selectedCamera.identifier,
                                    targetGroup.value,
                                  )
                                }
                              >
                                {targetGroup.label}
                              </Menu.Item>
                            ),
                          )}
                        </Menu.Sub.Dropdown>
                      </Menu.Sub>
                    )}
                  <Menu.Item
                    leftSection={<HardDrive size={14} />}
                    color="var(--accent)"
                    onClick={() =>
                      handleAccessMemory(selectedCamera.identifier)
                    }
                  >
                    {lang.access_memory}
                  </Menu.Item>
                  {selectedCamera.type !== "server" && selectedCamera.owned && (
                    <>
                      <Divider />
                      {selectedCamera.group_id && (
                        <Menu.Item
                          leftSection={<GroupIcon size={14} />}
                          color="red"
                          onClick={() =>
                            handleSendToGroup(selectedCamera.identifier, "none")
                          }
                        >
                          {lang.remove_from_group}
                        </Menu.Item>
                      )}
                      <Menu.Item
                        leftSection={<Trash2 size={14} />}
                        color="red"
                        onClick={() => handleRemove(selectedCamera.identifier)}
                      >
                        {lang.delete}
                      </Menu.Item>
                    </>
                  )}
                </Menu.Dropdown>
              </Menu>
              <ActionIcon
                variant="subtle"
                color="gray"
                onClick={() => setIndex(9999)}
                size="sm"
              >
                <X size={16} />
              </ActionIcon>
            </Group>
          </Box>

          <Box className={classes.overlayContent}>
            <Image
              src={selectedCamera.thumbnail}
              alt={selectedCamera.label}
              fallbackSrc="./thumbnail.jpg"
              className={classes.cameraThumbnail}
            />
            <Flex className={classes.infoRow}>
              <Text fz="xs" className={classes.locationText}>
                <MapPin size={14} />
                {selectedCamera.location}
              </Text>
              <Text
                className={classes.statusBadge}
                style={{
                  backgroundColor: `${getStatusColor(selectedCamera.status)}20`,
                  color: getStatusColor(selectedCamera.status),
                  border: `1px solid ${getStatusColor(selectedCamera.status)}40`,
                }}
              >
                {selectedCamera.status
                  ? labels[selectedCamera.status] || lang.unknown
                  : lang.unknown}
              </Text>
            </Flex>
            <Flex className={classes.infoRow}>
              <Text fz="xs" className={classes.batteryLabel}>
                {lang.battery}
              </Text>
              <Text
                fz="xs"
                c={selectedCamera.battery > 20 ? "#22c55e" : "#ef4444"}
                fw={600}
              >
                {selectedCamera.battery}%
              </Text>
            </Flex>
          </Box>

          <Group className={classes.actionsRow}>
            <Tooltip
              label={lang.view_camera}
              withArrow
              fz="xs"
              radius="md"
              bg="var(--tooltip)"
              color="var(--text)"
            >
              <ActionIcon
                variant="transparent"
                c="violet"
                onClick={() => handleConnection(selectedCamera)}
                title={lang.view}
                size="sm"
              >
                <Eye size={14} />
              </ActionIcon>
            </Tooltip>
            {selectedCamera.type !== "server" && selectedCamera.owned && (
              <>
                <Tooltip
                  label={lang.rename_camera}
                  withArrow
                  fz="xs"
                  radius="md"
                  bg="var(--tooltip)"
                  color="var(--text)"
                >
                  <ActionIcon
                    variant="transparent"
                    c="teal"
                    onClick={() => handleRename(selectedCamera)}
                    title={lang.rename}
                    size="sm"
                  >
                    <SquarePen size={14} />
                  </ActionIcon>
                </Tooltip>
                <Tooltip
                  label={lang.share_camera}
                  withArrow
                  fz="xs"
                  radius="md"
                  bg="var(--tooltip)"
                  color="var(--text)"
                >
                  <ActionIcon
                    variant="transparent"
                    c="blue"
                    onClick={() => handleShare(selectedCamera.identifier)}
                    title={lang.share}
                    size="sm"
                  >
                    <Share size={14} />
                  </ActionIcon>
                </Tooltip>
                <Tooltip
                  label={lang.delete_camera}
                  withArrow
                  fz="xs"
                  radius="md"
                  bg="var(--tooltip)"
                  color="var(--text)"
                >
                  <ActionIcon
                    variant="transparent"
                    c="red"
                    onClick={() => handleRemove(selectedCamera.identifier)}
                    title={lang.delete}
                    size="sm"
                  >
                    <Trash2 size={14} />
                  </ActionIcon>
                </Tooltip>
              </>
            )}
          </Group>
        </Box>
      )}
      <MapContainer
        className={classes.mapContainer}
        center={[0, 0]}
        zoom={3}
        scrollWheelZoom={true}
      >
        <MapSetup />
        <Marker
          position={[myCoords.y + 5.25, myCoords.x - 5.25]}
          icon={createPlayerIcon(`var(--accent)`)}
        />
        {filtered.map(
          (camera, i) =>
            camera.type !== "vehicle" &&
            camera.coords?.coords?.y &&
            camera.coords?.coords?.x && (
              <Marker
                key={i}
                position={[camera.coords.coords.y, camera.coords.coords.x]}
                icon={createCameraIcon(
                  camera.status,
                  camera.coords?.rotation?.z || 0,
                  index === i,
                )}
                eventHandlers={{
                  click: () => setIndex(i),
                }}
              />
            ),
        )}
      </MapContainer>
    </Stack>
  );
};

export default MapView;
