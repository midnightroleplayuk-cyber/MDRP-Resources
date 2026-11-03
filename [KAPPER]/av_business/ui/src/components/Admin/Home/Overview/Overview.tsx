import { useEffect, useState, useMemo } from "react";
import { Grid, Flex, Text, Stack, Button } from "@mantine/core";
import { useAtomValue } from "jotai";
import { Lang } from "../../../../reducers/atoms";
import { Loading } from "../../../Loading";
import { fetchNui, isEnvBrowser } from "../../../../hooks/useNuiEvents";
import classes from "./style.module.css";
import global from "../../../../global.module.css";

interface BusinessType {
  todaysOrders: number;
  todaysIncome: number;
  funds: number;
  rating: number;
}

export const Overview = ({ job }: { job: string | null }) => {
  const [loaded, setLoaded] = useState(false);
  const [data, setData] = useState<BusinessType | null>(null);

  const handleReset = async () => {
    await fetchNui("av_business", "resetBusiness", job);
    fetchData();
  };

  const fetchData = async () => {
    setLoaded(false);
    try {
      const resp = await fetchNui<BusinessType>(
        "av_business",
        "adminOverview",
        job,
      );
      if (resp) {
        setData(resp);
      } else if (isEnvBrowser()) {
        setData({
          todaysIncome: 150,
          todaysOrders: 27,
          funds: 25000,
          rating: 2,
        });
      }
    } catch (error) {
      console.error("Error fetching overview data:", error);
    } finally {
      setLoaded(true);
    }
  };

  useEffect(() => {
    if (!job) return;

    fetchData();
  }, [job]);

  const daLang: any = useAtomValue(Lang);
  const lang = daLang.admin;
  const stats = useMemo(
    () => [
      { label: lang.overview_todays_orders, value: data?.todaysOrders },
      {
        label: lang.overview_todays_income,
        value: `$${data?.todaysIncome.toLocaleString("en-US")}`,
      },
      {
        label: lang.overview_available_funds,
        value: `$${data?.funds.toLocaleString("en-US")}`,
      },
      { label: lang.overview_rating, value: data?.rating },
    ],
    [data, lang],
  );

  if (!job) return null;
  if (!loaded) return <Loading />;

  return (
    <Stack>
      <Grid p="sm">
        {stats.map((stat, index) => (
          <Grid.Col key={index} span={3}>
            <Flex className={classes.card} direction="column">
              <Text c="var(--text-dim)" size="sm" fw={500} ta="center">
                {stat.label}
              </Text>
              <Text c="white" size="lg" fw={600} ta="center">
                {stat.value !== undefined ? stat.value.toLocaleString() : "N/A"}
              </Text>
            </Flex>
          </Grid.Col>
        ))}
      </Grid>
      <Flex direction="column" ta="center" gap="xs">
        <Button
          className={global.redButton}
          w={300}
          ml="auto"
          mr="auto"
          size="xs"
          variant="filled"
          onDoubleClick={handleReset}
        >
          {lang.overview_reset}
        </Button>
        <Text fz="xs" c="var(--text-dim)">
          {lang.overview_reset_desc}
        </Text>
      </Flex>
    </Stack>
  );
};
