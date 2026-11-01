import "leaflet/dist/leaflet.css";
import {
  MapContainer,
  Marker,
  Polygon,
  Tooltip,
  useMap,
  useMapEvents,
} from "react-leaflet";
import L from "leaflet";
import { Text, Flex } from "@mantine/core";
import { useEffect, useState } from "react";
import { isEnvBrowser } from "../../../hooks/useNuiEvents";
import { ZoneType } from "../../../types/types";
import classes from "./style.module.css";
import "./map.css";
import { GraffitiType } from "../../Admin/Graffitis/types";

interface Properties {
  myCoords: { x: number; y: number };
  zones: ZoneType[];
  graffitis: GraffitiType[];
}

const createCustomIcon = (color: string) => {
  return L.divIcon({
    className: "custom-icon",
    html: `<div style="background-color: ${
      color ? color : "red"
    }; width: 18px; height: 18px; border-radius: 50%; border: 2px solid white;"></div>`,
  });
};

export const Territories = ({ myCoords, zones, graffitis }: Properties) => {
  const [loaded, setLoaded] = useState(false);

  const MapComponent = () => {
    const map = useMap();
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
    map.options.zoom = 3;
    map.options.preferCanvas = true;
    map.options.center = [0, -1024];
    map.options.scrollWheelZoom = true;
    map.options.crs = customcrs;
    map.attributionControl.setPrefix("");
    map.options.doubleClickZoom = false;
    map.options.dragging = false;
    if (!loaded) {
      map.setView([myCoords.y, myCoords.x], 3);
      setLoaded(true);
    }
    useEffect(() => {
      const sw = map.unproject([0, 1024], 3 - 1);
      const ne = map.unproject([1024, 0], 3 - 1);
      const mapbounds = new L.LatLngBounds(sw, ne);
      map.setMaxBounds(mapbounds);
      L.imageOverlay(
        "https://r2.fivemanage.com/QmVAYSlqeAlD4IxVbdvu5/map.jpeg",
        //"https://r2.fivemanage.com/QmVAYSlqeAlD4IxVbdvu5/images/zones.jpg",
        mapbounds,
      ).addTo(map);
    }, []);

    return null;
  };
  return (
    <>
      <MapContainer
        className={isEnvBrowser() ? "" : classes.map}
        style={{
          height: isEnvBrowser() ? "55vh" : undefined,
        }}
      >
        <MapComponent />
        <Marker
          position={[myCoords.y, myCoords.x]}
          icon={createCustomIcon("#c92a2a")}
        />
        {graffitis.map((graffiti) => (
          <Marker
            key={graffiti.identifier}
            position={[graffiti.coords.y, graffiti.coords.x]}
            icon={createCustomIcon("#6a9c12ff")}
            zIndexOffset={1000}
          >
            <Tooltip
              className="tooltip"
              direction="top"
              offset={[0, -10]}
              opacity={1}
              permanent={false}
              sticky
            >
              <Flex direction="column" ta="center">
                <Text fz="sm" fw={600} truncate>
                  Graffiti
                </Text>
                <Text fz="xs" tt="capitalize">{`${
                  graffiti.label ?? graffiti.gang
                }`}</Text>
              </Flex>
            </Tooltip>
          </Marker>
        ))}
        {zones.map((zone) => (
          <Polygon
            positions={zone.polygon}
            pathOptions={{
              color: "rgba(255,255,255,0.25)",
              fillColor: zone.color,
              fillOpacity: zone.color == "gray" ? 0.3 : 0.5,
              weight: 10,
            }}
          >
            <Tooltip
              className="tooltip"
              direction="top"
              offset={[0, -10]}
              opacity={1}
              permanent={false}
              sticky
            >
              <Flex direction="column" ta="center">
                <Text fz="sm" fw={600} truncate>
                  {zone.label}
                </Text>
                <Text fz="xs">{`${zone.gang}`}</Text>
              </Flex>
            </Tooltip>
          </Polygon>
        ))}
      </MapContainer>
    </>
  );
};
