import { useEffect, useState } from "react";
import { Flex, Text, Group } from "@mantine/core";
import {
  MapContainer,
  Marker,
  Tooltip,
  useMap,
  Polygon,
  useMapEvents,
} from "react-leaflet";
import L from "leaflet";
import { fetchNui, isEnvBrowser } from "../../hooks/useNuiEvents";
import { ZoneInfo, LabInfo } from "../../types/types";
import { Loading } from "../Loading";
import "leaflet/dist/leaflet.css";
import "./territories.css";
import { useRecoilValue } from "recoil";
import { Lang } from "../../reducers/atoms";

const createCustomIcon = (color: string) => {
  return L.divIcon({
    className: "custom-icon",
    html: `<div style="background-color: ${
      color ? color : "red"
    }; width: 20px; height: 20px; border-radius: 50%; border: 2px solid white;"></div>`,
  });
};

export const Territories = () => {
  const { app: lang }: any = useRecoilValue(Lang);
  const [loaded, setLoaded] = useState(isEnvBrowser());
  const [allZones, setAllZones] = useState<ZoneInfo[]>([]);
  const [coordinates, setCoordinates] = useState<string[]>([]);
  const [debugPoints, setDebugPoints] = useState<[number, number][]>([]);
  const [myCoords, setMyCoords] = useState({ x: 0, y: 0 });
  const [allLabs, setAllLabs] = useState<LabInfo[]>([]);

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_drugs", "getProgression");
      if (resp) {
        setAllZones(resp.zones);
        setMyCoords(resp.myCoords);
        setAllLabs(resp.labs);
      }
      setTimeout(() => {
        setLoaded(true);
      }, 100);
    };
    fetchData();
  }, []);
  if (!loaded) return <Loading />;
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
    map.options.maxZoom = 4.5;
    map.options.touchZoom = false;
    map.options.zoom = 3;
    map.options.preferCanvas = true;
    map.options.center = [0, -1024];
    map.options.scrollWheelZoom = true;
    map.options.crs = customcrs;
    map.attributionControl.setPrefix("");
    map.options.doubleClickZoom = false;
    map.options.dragging = false;

    useEffect(() => {
      const sw = map.unproject([0, 1024], 3 - 1);
      const ne = map.unproject([1024, 0], 3 - 1);
      const mapbounds = new L.LatLngBounds(sw, ne);
      map.setMaxBounds(mapbounds);
      map.setView([-60, -5], 3);
      L.imageOverlay(
        "https://r2.fivemanage.com/QmVAYSlqeAlD4IxVbdvu5/map.jpeg",
        //"https://r2.fivemanage.com/QmVAYSlqeAlD4IxVbdvu5/images/zones.jpg",
        mapbounds
      ).addTo(map);
    }, [map]);

    return null;
  };
  const MapEvents = () => {
    useMapEvents({
      contextmenu: (e) => {
        const { lat, lng } = e.latlng;
        const newCoordinate = `{${lat.toFixed(2)},${lng.toFixed(2)}},`;
        setCoordinates([...coordinates, newCoordinate]);
        setDebugPoints([...debugPoints, [lat, lng]]);
      },
      dblclick: (e) => {
        const fullString = coordinates.join("\n");
        fetchNui("av_laptop", "copy", fullString);
        setCoordinates([]);
        setDebugPoints([]);
      },
    });
    return null;
  };
  return (
    <MapContainer style={{ height: "100%", width: "100%" }}>
      <MapComponent />
      <Marker
        position={[myCoords.y, myCoords.x]}
        icon={createCustomIcon("blue")}
      >
        <Tooltip
          direction="top"
          offset={[0, -10]}
          opacity={1}
          permanent={false}
        >
          <span>{lang.you}</span>
        </Tooltip>
      </Marker>
      {allLabs.map((lab, index) => (
        <Marker
          key={index}
          position={[lab.y, lab.x]}
          icon={createCustomIcon(lab.color)}
          eventHandlers={{
            click: () => {
              fetchNui("av_drugs", "setGPS", lab);
            },
          }}
        >
          <Tooltip
            direction="top"
            offset={[0, -10]}
            opacity={1}
            permanent={false}
          >
            <span>{lang.laboratory}</span>
          </Tooltip>
        </Marker>
      ))}
      {allZones.map((zone) => (
        <Polygon
          positions={zone.polygon}
          pathOptions={{
            color: "rgba(255,255,255,0.25)",
            fillColor: zone.color,
            fillOpacity: zone.color == "gray" ? 0.3 : 0.5,
            weight: 2,
          }}
        >
          <Tooltip
            className="custom-tooltip"
            direction="top"
            offset={[0, -10]}
            opacity={1}
            permanent={false}
          >
            <Flex direction="column">
              <Group display="flex" w="100%" gap={3}>
                <Text fz="xs" fw={600} truncate>
                  {zone.label}
                </Text>
              </Group>
              <Group display="flex" w="100%" gap={3}>
                <Text fz="xs" fw={600} truncate>
                  {`${lang.top_title}:`}
                </Text>
                <Text fz="xs" truncate>
                  {`${zone.drug} - ${zone.strain}`}
                </Text>
              </Group>
            </Flex>
          </Tooltip>
        </Polygon>
      ))}
      {coordinates[0] && (
        <Polygon
          positions={debugPoints}
          pathOptions={{
            color: "yellow",
            fillColor: "yellow",
            fillOpacity: 0.3,
            weight: 2,
          }}
        />
      )}
      {/* <MapEvents /> */}
    </MapContainer>
  );
};
