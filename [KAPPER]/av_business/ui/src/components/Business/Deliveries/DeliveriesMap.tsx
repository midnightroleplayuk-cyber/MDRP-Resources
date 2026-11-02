import "leaflet/dist/leaflet.css";
import { MapContainer, Marker, Tooltip, useMap } from "react-leaflet";
import L from "leaflet";
import { Text, Stack } from "@mantine/core";
import { useEffect, useRef } from "react";
import { DeliveryType } from "../../../types/types";
import { formatTimestamp } from "../../../hooks/formatTime";
import "./style.module.css";
import classes from "./style.module.css";

interface Properties {
  orders: DeliveryType[];
  setSelected: (identifier: string) => void;
  myCoords: { x: number; y: number };
  myIdentifier: string;
  daLang: any;
}

const createCustomIcon = (color: string) => {
  return L.divIcon({
    className: "custom-icon",
    html: `<div style="background-color: ${
      color ? color : "red"
    }; width: 20px; height: 20px; border-radius: 50%; border: 2px solid white;"></div>`,
  });
};

const InitialViewSetter = () => {
  const map = useMap();
  const hasCenteredRef = useRef(false);

  useEffect(() => {
    if (hasCenteredRef.current) {
      return;
    }

    const initialCenter: [number, number] = [-60, -5];

    map.setView(initialCenter, 3);
    hasCenteredRef.current = true;
  }, [map]);

  return null;
};

interface MapProperties {
  setSelected?: (index: string) => void;
}

const MapInitializer = ({ setSelected }: MapProperties) => {
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
      setSelected && setSelected("");
    });
    const sw = map.unproject([0, 1024], 3 - 1);
    const ne = map.unproject([1024, 0], 3 - 1);
    const mapbounds = new L.LatLngBounds(sw, ne);
    map.setMaxBounds(mapbounds);

    const overlay = L.imageOverlay(
      "./map.jpeg",
      mapbounds,
    );
    overlay.addTo(map);
    imageOverlayRef.current = overlay;

    mapInitializedRef.current = true;
  }, [map]);

  return null;
};

export const DeliveriesMap = ({
  orders,
  setSelected,
  myCoords,
  myIdentifier,
  daLang,
}: Properties) => {
  const lang = daLang.deliveries;
  const eventHandlers = (identifier: string) => ({
    click: () => {
      setSelected(identifier);
    },
  });

  return (
    <MapContainer style={{ height: "100%", width: "100%" }}>
      <MapInitializer setSelected={setSelected} />
      <InitialViewSetter />
      <Marker
        position={[myCoords.y, myCoords.x]}
        icon={createCustomIcon("var(--accent)")}
      ></Marker>
      {orders.map((zone) => (
        <Marker
          position={[zone.coords.y, zone.coords.x]}
          riseOnHover
          eventHandlers={eventHandlers(zone.identifier)}
          icon={createCustomIcon(
            zone.claimedIdentifier == myIdentifier
              ? "var(--cyan)"
              : "var(--yellow)",
          )}
        >
          <Tooltip
            className={classes.tooltip}
            direction="top"
            offset={[0, -10]}
            opacity={1}
            permanent={false}
          >
            <Stack gap="xs">
              <Text fz="xs" fw={600} truncate>
                {`${lang.order} ${zone.name}`}
              </Text>
              <Text fz="xs" fw={600} truncate>
                {`${lang.created} ${formatTimestamp(zone.generated)}`}
              </Text>
              <Text fz="xs" fw={600} truncate>
                {`${lang.claimed_by} ${zone.claimed ? zone.claimed : `N/A`}`}
              </Text>
            </Stack>
          </Tooltip>
        </Marker>
      ))}
    </MapContainer>
  );
};
