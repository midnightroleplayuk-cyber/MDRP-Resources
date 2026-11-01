import { Box, Group, Select, Text } from "@mantine/core";
import { useEffect, useState } from "react";
import { Overview } from "./Tabs/Overview";
import { Members } from "./Tabs/Members";
import { Peds } from "./Tabs/Peds";
import global from "../../../../global.module.css";
import { Settings } from "./Tabs/Settings";
import { Properties } from "./Tabs/Properties";
import { useRecoilValue } from "recoil";
import { Lang } from "../../../../reducers/atoms";
import { Graffiti } from "./Tabs/Graffiti";

interface Properties {
  gang: string | null;
  fetchData: () => void;
}

export const Content = ({ gang, fetchData }: Properties) => {
  const lang: any = useRecoilValue(Lang);
  const [tab, setTab] = useState("overview");
  const allTabs = [
    { value: "overview", label: lang.overview },
    { value: "members", label: lang.members },
    { value: "peds", label: lang.peds },
    { value: "properties", label: lang.properties },
    { value: "graffiti", label: lang.graffiti },
    { value: "settings", label: lang.settings },
  ];

  useEffect(() => {
    setTab("overview");
  }, [gang]);

  return (
    <>
      {gang ? (
        <>
          <Box p="sm">
            <Group>
              <Select
                classNames={global}
                ml="auto"
                size="xs"
                value={tab}
                data={allTabs}
                allowDeselect={false}
                onChange={(e) => {
                  if (!e) return;
                  setTab(e);
                }}
              />
            </Group>
            {tab == "overview" && <Overview gang={gang} />}
            {tab == "members" && <Members gang={gang} />}
            {tab == "peds" && <Peds gang={gang} />}
            {tab == "settings" && (
              <Settings gang={gang} refreshData={fetchData} />
            )}
            {tab == "properties" && <Properties gang={gang} />}
            {tab == "graffiti" && <Graffiti gang={gang} />}
          </Box>
        </>
      ) : (
        <Box
          h={355}
          style={{
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
          }}
        >
          <Text fz="xs" c="dimmed" ta="center">
            No Gangs...
          </Text>
        </Box>
      )}
    </>
  );
};
