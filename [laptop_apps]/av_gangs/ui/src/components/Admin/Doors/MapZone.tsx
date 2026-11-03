import "leaflet/dist/leaflet.css";
import { MapContainer, Marker, useMap } from "react-leaflet";
import L from "leaflet";
import { useEffect, useState } from "react";
import { DoorType } from "../../../types/types";

interface Properties {
  myCoords: { x: number; y: number };
  zones: DoorType[];
  setSelected: (zone: DoorType) => void;
}

const createCustomIcon = (color: string, size: number) => {
  return L.divIcon({
    className: "custom-icon",
    html: `<div style="background-color: ${
      color ? color : "red"
    }; width: ${size}px; height: ${size}px; border-radius: 50%; border: 2px solid white;"></div>`,
  });
};

export const MapZone = ({ myCoords, zones, setSelected }: Properties) => {
  const [loaded, setLoaded] = useState(false);
  const eventHandlers = (zone: DoorType) => ({
    click: () => {
      setSelected(zone);
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
        mapbounds
      ).addTo(map);
    }, [map]);

    return null;
  };
  return (
    <MapContainer style={{ height: "100%", width: "100%" }}>
      <MapComponent />
      <Marker
        position={[myCoords.y + 5.0, myCoords.x - 5.0]}
        icon={createCustomIcon("#fd7e14", 15)}
        zIndexOffset={999}
      />
      {zones.map((zone) => (
        <Marker
          position={[zone.y, zone.x]}
          icon={createCustomIcon(zone.onUse ? `#f03e3e` : `#5c940d`, 15)}
          eventHandlers={eventHandlers(zone)}
        />
      ))}
    </MapContainer>
  );
};
