import { useEffect, useRef, useState } from "react";
import { Text, Group, Switch } from "@mantine/core";
import { MapContainer, Marker, useMap, Polyline, Tooltip } from "react-leaflet";
import L from "leaflet";
import "leaflet/dist/leaflet.css";
import { fetchNui } from "../../../hooks/useNuiEvents";

interface CheckpointType {
  coords: { x: number; y: number };
}

interface RunPoint {
  x: number;
  y: number;
  s: number;
}

interface Properties {
  checkpoints: CheckpointType[];
  handleIndex?: (index: number | null) => void;
  myCoords?: { x: number; y: number };
  runLine?: RunPoint[];
  crashes?: { x: number; y: number }[];
}

const createCustomIcon = (color: string, index: number | string) => {
  return L.divIcon({
    className: "custom-icon",
    html: `<div style="background-color: ${
      color ?? "#5f3dc4"
    }; text-align: center; 
        justify-content: center; align-items: center;display: flex;
        width: 21px; height: 21px; border-radius: 50%; border: 2px solid white;
        text-align: center;color:white;font-size:10px;font-weight:700">${index}</div>
    `,
  });
};

const crashIcon = L.divIcon({
  className: "custom-icon",
  html: `<div style="background-color:#fa5252;width:16px;height:16px;border-radius:50%;
      border:2px solid white;display:flex;align-items:center;justify-content:center;
      color:white;font-size:11px;font-weight:800">!</div>`,
});

const InitialViewSetter = ({
  checkpoints,
}: {
  checkpoints: CheckpointType[];
}) => {
  const map = useMap();
  const hasCenteredRef = useRef(false);

  useEffect(() => {
    if (hasCenteredRef.current) {
      return;
    }

    const initialCenter: [number, number] = [
      checkpoints[0]?.coords.y ?? -60,
      checkpoints[0]?.coords.x ?? -5,
    ];

    map.setView(initialCenter, 3);
    hasCenteredRef.current = true;
  }, [map]);

  return null;
};

interface MapProperties {
  handleIndex?: (index: number | null) => void;
}

const MapInitializer = ({ handleIndex }: MapProperties) => {
  const map = useMap();
  const mapInitializedRef = useRef(false);
  const imageOverlayRef = useRef<L.ImageOverlay | null>(null);

  useEffect(() => {
    if (mapInitializedRef.current) return;

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

    map.options.minZoom = 1.5;
    map.options.maxZoom = 5.5;
    map.options.touchZoom = false;
    map.options.zoom = 3;
    map.options.preferCanvas = true;
    map.options.center = [0, -1024];
    map.options.scrollWheelZoom = true;
    map.options.crs = customcrs;
    map.attributionControl.setPrefix("");
    map.options.doubleClickZoom = false;
    map.options.dragging = false;
    map.addEventListener("click", () => {
      handleIndex && handleIndex(null);
    });
    const sw = map.unproject([0, 1024], 3 - 1);
    const ne = map.unproject([1024, 0], 3 - 1);
    const mapbounds = new L.LatLngBounds(sw, ne);
    map.setMaxBounds(mapbounds);

    const overlay = L.imageOverlay("./map.jpeg", mapbounds);
    overlay.addTo(map);
    imageOverlayRef.current = overlay;

    mapInitializedRef.current = true;
  }, [map]);

  return null;
};

export const MapZone = ({
  checkpoints,
  handleIndex,
  runLine,
  crashes,
}: Properties) => {
  const [showMe, setShowMe] = useState(true);
  const [showCheckpoints, setShowCheckpoints] = useState(true);
  const [myCoords, setMyCoords] = useState({ x: 0, y: 0 });

  const handleBlip = (state: boolean) => {
    setShowMe(state);
  };
  const eventHandlers = (index: number) => ({
    click: () => {
      handleIndex && handleIndex(index);
    },
  });

  const getColor = (index: number) => {
    if (index === 0) {
      return "#12b886";
    }
    if (index === checkpoints.length - 1) {
      return "#fa5252";
    }
    return "#5f3dc4";
  };

  const polylinePositions = checkpoints.map(
    (checkpoint) =>
      [checkpoint.coords.y, checkpoint.coords.x] as [number, number],
  );

  useEffect(() => {
    const fetchCoords = async () => {
      const resp = await fetchNui("av_racing", "myCoords");
      if (resp) {
        setMyCoords(resp);
      }
    };
    fetchCoords();
    const interval = setInterval(fetchCoords, 30000);
    return () => clearInterval(interval);
  }, []);

  const runSegments = (() => {
    if (!runLine || runLine.length < 2)
      return [] as { pos: [number, number][]; color: string }[];
    const speeds = runLine.map((p) => p.s);
    const min = Math.min(...speeds);
    const max = Math.max(...speeds);
    const span = Math.max(1, max - min);
    const step = Math.max(1, Math.floor(runLine.length / 250));
    const segs: { pos: [number, number][]; color: string }[] = [];
    for (let i = step; i < runLine.length; i += step) {
      const a = runLine[i - step];
      const b = runLine[i];
      const t = ((a.s + b.s) / 2 - min) / span;
      const hue = Math.round(t * 120);
      segs.push({
        pos: [
          [a.y, a.x],
          [b.y, b.x],
        ],
        color: `hsl(${hue}, 90%, 50%)`,
      });
    }
    return segs;
  })();

  return (
    <>
      <Group
        style={{
          position: "absolute",
          backgroundColor: "rgba(10,10,10,0.55",
          display: "flex",
          right: 0,
          marginTop: "10px",
          marginRight: "30px",
          zIndex: 1000,
          borderRadius: 10,
        }}
        p="md"
      >
        <Switch
          label="Show myself"
          size="xs"
          c="gray.1"
          color="cyan.3"
          checked={showMe}
          onChange={(e) => {
            handleBlip(e.target.checked);
          }}
        />
        <Switch
          label="Checkpoints"
          size="xs"
          c="gray.1"
          color="cyan.3"
          checked={showCheckpoints}
          onChange={(e) => {
            setShowCheckpoints(e.target.checked);
          }}
        />
      </Group>
      <MapContainer style={{ height: "100%", width: "100%" }}>
        <MapInitializer handleIndex={handleIndex} />
        <InitialViewSetter checkpoints={checkpoints} />{" "}
        {runSegments.map((sg, i) => (
          <Polyline
            key={`run-${i}`}
            positions={sg.pos}
            pathOptions={{ color: sg.color, weight: 4, opacity: 0.9 }}
          />
        ))}
        {crashes?.map((c, i) => (
          <Marker key={`crash-${i}`} position={[c.y, c.x]} icon={crashIcon}>
            <Tooltip
              className="tooltip"
              direction="top"
              offset={[0, -8]}
              opacity={1}
            >
              <Text fz="xs" fw={600}>
                Collision
              </Text>
            </Tooltip>
          </Marker>
        ))}
        {showCheckpoints &&
          checkpoints.map((checkpoint, index) => (
            <Marker
              key={index}
              position={[checkpoint.coords.y, checkpoint.coords.x]}
              icon={createCustomIcon(getColor(index), index + 1)}
              eventHandlers={eventHandlers(index)}
            >
              <Tooltip
                className="tooltip"
                direction="top"
                offset={[0, -10]}
                opacity={1}
                sticky
              >
                <Text fz="xs" truncate fw={600}>
                  {`Checkpoint ${index + 1}`}
                </Text>
              </Tooltip>
            </Marker>
          ))}
        {showMe && (
          <Marker
            position={[myCoords?.y ?? 0.0, myCoords?.x ?? 0.0]}
            icon={createCustomIcon("orange", "")}
          >
            <Tooltip
              className="tooltip"
              direction="top"
              offset={[0, -10]}
              opacity={1}
              sticky
            >
              <Text fz="xs" truncate fw={600}>
                {`You`}
              </Text>
            </Tooltip>
          </Marker>
        )}
        {showCheckpoints && checkpoints.length > 1 && (
          <Polyline
            pathOptions={{ color: "violet", weight: 3.25 }}
            positions={polylinePositions}
          />
        )}
      </MapContainer>
    </>
  );
};
