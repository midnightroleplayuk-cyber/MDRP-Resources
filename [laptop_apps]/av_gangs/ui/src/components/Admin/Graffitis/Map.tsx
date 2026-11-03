import "leaflet/dist/leaflet.css";
import { MapContainer, Marker, Tooltip, useMap } from "react-leaflet";
import L from "leaflet";
import { Text } from "@mantine/core";
import { useEffect, useState } from "react";
import { GraffitiType } from "./types";
import "./style.css";

interface Properties {
  graffitis: GraffitiType[];
  handleCurrent: (graffiti: GraffitiType | null) => void;
  current: string | null;
}

const createCustomIcon = (color: string, size: number) => {
  return L.divIcon({
    className: "custom-icon",
    html: `<div style="background-color: ${
      color ? color : "red"
    }; width: ${size}px; height: ${size}px; border-radius: 50%; border: 2px solid white;"></div>`,
  });
};

export const Map = ({ graffitis, handleCurrent, current }: Properties) => {
  const [loaded, setLoaded] = useState(false);
  const eventHandlers = (graffiti: GraffitiType) => ({
    click: () => {
      handleCurrent(graffiti);
    },
  });
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
          x_difference * x_difference + y_difference * y_difference
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
      handleCurrent(null);
    });
    if (!loaded) {
      setLoaded(true);
      map.setView([-60, -5], 3);
    }
    useEffect(() => {
      const sw = map.unproject([0, 1024], 3 - 1);
      const ne = map.unproject([1024, 0], 3 - 1);
      const mapbounds = new L.LatLngBounds(sw, ne);
      map.setMaxBounds(mapbounds);
      L.imageOverlay(
        "https://r2.fivemanage.com/QmVAYSlqeAlD4IxVbdvu5/map.jpeg",
        //"https://r2.fivemanage.com/QmVAYSlqeAlD4IxVbdvu5/images/zones.jpg",
        mapbounds
      ).addTo(map);
    }, [map]);

    return null;
  };
  return (
    <MapContainer
      style={{
        height: "543px",
      }}
    >
      <MapComponent />
      {graffitis.map((graffiti) => (
        <Marker
          key={graffiti.identifier}
          icon={createCustomIcon(
            graffiti.color ? graffiti.color : "#fd7e14",
            15
          )}
          position={[graffiti.coords.y, graffiti.coords.x]}
          eventHandlers={eventHandlers(graffiti)}
        >
          <Tooltip
            className="tooltip"
            direction="top"
            offset={[0, -10]}
            opacity={1}
            sticky
          >
            <Text fz="xs" truncate>
              {`${graffiti.gang}`}
            </Text>
          </Tooltip>
        </Marker>
      ))}
    </MapContainer>
  );
};
