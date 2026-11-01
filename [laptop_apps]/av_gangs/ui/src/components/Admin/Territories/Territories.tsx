import { useEffect, useState } from "react";
import { Grid } from "@mantine/core";
import { Loading } from "../../Loading";
import { fetchNui, isEnvBrowser } from "../../../hooks/useNuiEvents";
import { ZoneType } from "../../../types/types";
import { ApiTerritories } from "../../../api/Territories";
import { Map } from "./Map";
import { ApiZoneData } from "../../../api/Leaderboard";
import { Zones } from "./Zones";
import { ZoneDataType } from "./types";
import { ZonePanel } from "./ZonePanel";

const Territories = () => {
  const [loaded, setLoaded] = useState(false);
  const [zones, setZones] = useState<ZoneType[]>([]);
  const [zoneData, setZoneData] = useState<ZoneDataType[]>([]);
  const [currentZone, setCurrentZone] = useState<ZoneDataType | null>(null);

  const fetchData = async () => {
    setLoaded(false);
    const resp = await fetchNui("av_gangs", "admin:getTerritories");
    if (resp) {
      setZones(resp.territories);
      setZoneData(resp.zones);
    } else {
      if (isEnvBrowser()) {
        setZones(ApiTerritories);
        setZoneData(ApiZoneData);
      }
    }
    setTimeout(() => {
      setLoaded(true);
    }, 100);
  };

  const handleCurrent = async (name: string) => {
    const zoneData = await fetchNui("av_gangs", "getZoneGangs", name);
    setCurrentZone(zoneData);
  };

  const handleSave = async (zone: ZoneDataType) => {
    await fetchNui("av_gangs", "updateZone", zone);
    setCurrentZone(null);
    fetchData();
  };

  const handleWipe = (zoneName: string) => {
    setZones((prevZones) => prevZones.filter((zone) => zone.name !== zoneName));
    setZoneData((prevZoneData) =>
      prevZoneData.map((data) => {
        if (data.zoneName === zoneName) {
          return { ...data, gangsData: [] };
        }
        return data;
      }),
    );
    setCurrentZone(null);
    fetchNui("av_gangs", "wipeZone", zoneName);
  };
  useEffect(() => {
    fetchData();
  }, []);

  if (!loaded) return <Loading />;
  return (
    <>
      {currentZone && (
        <ZonePanel
          zoneData={currentZone}
          closeModal={() => {
            setCurrentZone(null);
          }}
          handleSave={handleSave}
          handleWipe={handleWipe}
        />
      )}
      <Grid h={200} gutter={0} p="xs">
        <Grid.Col span={3}>
          <Zones zoneData={zoneData} handleCurrent={handleCurrent} />
        </Grid.Col>
        <Grid.Col span="auto" h={300}>
          <Map zones={zones} handleCurrent={handleCurrent} />
        </Grid.Col>
      </Grid>
    </>
  );
};

export default Territories;
