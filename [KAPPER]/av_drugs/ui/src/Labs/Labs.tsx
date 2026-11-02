import { useState, useEffect } from "react";
import { Box, Grid, Text, Button, Group } from "@mantine/core";
import { fetchNui } from "../hooks/useNuiEvents";
import { Loading } from "../components/Loading";
import { Header } from "./Header";
import { Keys } from "./Keys";
import { Main } from "./Main/Main";
import { LabType, keyHolder } from "../types/types";
import { LabTest } from "../API/labData";
import classes from "./styles.module.css";
import { useRecoilValue } from "recoil";
import { Lang } from "../reducers/atoms";

interface Properties {
  identifier: string | boolean;
}

const Labs = ({ identifier }: Properties) => {
  const { labs: lang }: any = useRecoilValue(Lang);
  const [showWarning, setShowWarning] = useState(false);
  const [data, setData] = useState({ title: "", description: "", event: "" });
  const [labInfo, setLabInfo] = useState<LabType>(LabTest);
  const [upgrades, setUpgrades] = useState({
    maintenance: 1000,
    security: 1000,
    stash: 1000,
  });
  const [loaded, setLoaded] = useState(false);
  const setHolders = (holders: keyHolder[]) => {
    const copy = { ...labInfo, keys: holders };
    setLabInfo(copy);
  };
  const toggleLab = async () => {
    const resp = await fetchNui("av_drugs", "toggleLab", labInfo.identifier);
    const copy = { ...labInfo, canCook: resp };
    setLabInfo(copy);
  };
  const handlePayment = async () => {
    const resp = await fetchNui(
      "av_drugs",
      "payMaintenance",
      labInfo.identifier
    );
    const copy = { ...labInfo, isExpired: resp };
    setLabInfo(copy);
  };
  const handleUpgrade = async (type: string) => {
    const resp = await fetchNui("av_drugs", "buyUpgrade", {
      identifier: labInfo.identifier,
      type,
    });
    if (resp) {
      const copy = { ...labInfo, upgrades: resp };
      setLabInfo(copy);
    }
  };
  const handleNotification = (
    title: string,
    description: string,
    event: string
  ) => {
    setData({
      title,
      description,
      event,
    });
    setShowWarning(true);
  };
  const onPressKey = (e: any) => {
    switch (e.code) {
      case "Escape":
        fetchNui("av_drugs", "close");
        break;
      default:
        break;
    }
  };
  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_drugs", "getLab", identifier);
      if (resp) {
        setLabInfo(resp.lab);
        setUpgrades(resp.upgrades);
      }
      setTimeout(() => {
        setLoaded(true);
      }, 100);
    };
    fetchData();
  }, [identifier]);
  useEffect(() => {
    window.addEventListener("keydown", onPressKey);
  }, []);
  return (
    <Box className={classes.container}>
      <Box className={classes.box}>
        {!loaded ? (
          <Loading />
        ) : (
          <>
            {showWarning && (
              <Box className={classes.transfer}>
                <Box className={classes.transferBox}>
                  <Text fw={700} ta="center" fz="lg">
                    {data.title}
                  </Text>
                  <Box className={classes.divider} />
                  <Text fz="sm" c="gray.5" mt="xs">
                    {data.description}
                  </Text>
                  <Group mt="sm">
                    <Button
                      ml="auto"
                      variant="transparent"
                      color="red"
                      size="sm"
                      onClick={() => {
                        setShowWarning(false);
                      }}
                    >
                      {lang.cancel}
                    </Button>
                    <Button
                      variant="light"
                      size="sm"
                      onClick={() => {
                        setShowWarning(false);
                        fetchNui("av_drugs", data.event, labInfo.identifier);
                      }}
                    >
                      {lang.confirm}
                    </Button>
                  </Group>
                </Box>
              </Box>
            )}
            <Header
              identifier={identifier}
              toggleLab={toggleLab}
              status={labInfo.canCook}
              isOwner={labInfo.isOwner}
              canTransfer={labInfo.canTransfer}
              canDelete={labInfo.canDelete}
              isCop={labInfo.isCop}
              setNotification={handleNotification}
            />
            <Grid>
              <Grid.Col span={3} p="lg">
                <Keys
                  holders={labInfo.keys}
                  setHolders={setHolders}
                  isOwner={labInfo.isOwner}
                  identifier={labInfo.identifier}
                />
              </Grid.Col>
              <Grid.Col span={9} pt="lg">
                <Main
                  lab={labInfo}
                  upgrades={upgrades}
                  handlePayment={handlePayment}
                  handleUpgrade={handleUpgrade}
                />
              </Grid.Col>
            </Grid>
          </>
        )}
      </Box>
    </Box>
  );
};

export default Labs;
