import { useEffect, useState } from "react";
import {
  Box,
  Text,
  Group,
  Stack,
  SimpleGrid,
  Card,
  Grid,
  Avatar,
  Rating,
  Tooltip,
} from "@mantine/core";
import { AreaChart } from "@mantine/charts";
import {
  IconReceipt2,
  IconCash,
  IconUsers,
  IconWallet,
  IconChartAreaLine,
  IconTrophy,
  IconHeart,
  IconMessageStar,
  IconHelpCircle,
} from "@tabler/icons-react";
import { useAtomValue } from "jotai";
import { Lang, MyPermissions } from "../../../reducers/atoms";
import { fetchNui, isEnvBrowser } from "../../../hooks/useNuiEvents";
import { ApiBusiness } from "../../../API/business";
import { BusinessType } from "../../../types/types";
import { Loading } from "../../Loading";
import { useViewportSize } from "@mantine/hooks";
import { formatString } from "../../../hooks/formatString";
import classes from "./style.module.css";

const Overview = () => {
  const [loaded, setLoaded] = useState(false);
  const [business, setBusiness] = useState<BusinessType>(ApiBusiness);
  const extraPermissions = business.permissions;
  const myPermissions = useAtomValue(MyPermissions);
  const daLang: any = useAtomValue(Lang);
  const lang = daLang.overview;
  const { height } = useViewportSize();

  const getRatingComment = (stars: number): string => {
    if (stars >= 4.5) {
      return lang.ratedByCustomers["5"];
    } else if (stars >= 4.0) {
      return lang.ratedByCustomers["4"];
    } else if (stars >= 3.0) {
      return lang.ratedByCustomers["3"];
    } else if (stars >= 2.0) {
      return lang.ratedByCustomers["2"];
    } else if (stars >= 1.0) {
      return lang.ratedByCustomers["1"];
    } else {
      return lang.ratedByCustomers["0"];
    }
  };

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_business", "overview");
      if (resp) {
        setBusiness(resp);
      } else {
        if (!isEnvBrowser)
          console.log(
            "Something went wrong while trying to fetch this business, please verify your server console (txAdmin) for possible error prints.",
          );
      }
      setLoaded(true);
    };
    fetchData();
  }, []);
  if (!loaded) return <Loading />;
  return (
    <Stack gap="xl" className={classes.container}>
      <SimpleGrid cols={4} spacing="lg">
        {extraPermissions.isRestaurant && (
          <Card radius="md" p="lg" className={classes.kpiCard}>
            <IconReceipt2 className={classes.kpiIconBg} />
            <Group gap={6} mb="xs">
              <IconReceipt2 size={16} color="var(--text-dim)" />
              <Text fz="sm" fw={600} c="var(--text-dim)">
                {lang.todayOrders}
              </Text>
            </Group>
            <Text fz="xl" fw={700} c="var(--text-main)">
              {business.todayOrders}
            </Text>
          </Card>
        )}
        <Card radius="md" p="lg" className={classes.kpiCard}>
          <IconCash className={classes.kpiIconBg} />
          <Group gap={6} mb="xs">
            <IconCash size={16} color="var(--success)" />
            <Text fz="sm" fw={600} c="var(--text-dim)">
              {lang.todayIncome}
            </Text>
          </Group>
          <Text fz="xl" fw={700} c="var(--success)">
            {`${daLang.money_symbol}${business.todayIncome.toLocaleString("en-US")}`}
          </Text>
        </Card>
        <Card radius="md" p="lg" className={classes.kpiCard}>
          <IconUsers className={classes.kpiIconBg} />
          <Group gap={6} mb="xs">
            <IconUsers size={16} color="var(--text-dim)" />
            <Text fz="sm" fw={600} c="var(--text-dim)">
              {lang.activeEmployees}
            </Text>
          </Group>
          <Text fz="xl" fw={700} c="var(--text-main)">
            {business.employees ?? `N/A`}
          </Text>
        </Card>
        {(myPermissions.bank || myPermissions.isBoss) && (
          <Card radius="md" p="lg" className={classes.kpiCard}>
            <IconWallet className={classes.kpiIconBg} />
            <Group gap={6} mb="xs">
              <IconWallet size={16} color="var(--cyan)" />
              <Text fz="sm" fw={600} c="var(--text-dim)">
                {lang.availableFunds}
              </Text>
            </Group>
            <Text fz="xl" fw={700} c="var(--cyan)">
              {`${daLang.money_symbol}${business.funds ? business.funds.toLocaleString("en-US") : 0}`}
            </Text>
          </Card>
        )}
      </SimpleGrid>
      <Grid gap="lg" style={{ flex: 1 }}>
        <Grid.Col span={8} style={{ display: "flex", flexDirection: "column" }}>
          <Card radius="md" p="md" className={classes.panelCardFull}>
            <Group mb="lg" align="center" gap={8}>
              <IconChartAreaLine size={20} color="var(--accent)" />
              <Text fz="lg" fw={600} c="var(--text-main)">
                {lang.weekOverview}
              </Text>
            </Group>
            <AreaChart
              h={height > 700 ? 350 : 250}
              data={business.chart}
              dataKey="date"
              withDots={false}
              series={business.chartElements}
              curveType="linear"
              tickLine="none"
              gridAxis="x"
              pr="lg"
              fillOpacity={0.055}
            />
          </Card>
        </Grid.Col>
        <Grid.Col span={4}>
          <Stack gap="lg" style={{ height: "100%" }}>
            <Card radius="md" p="lg" className={classes.panelCard}>
              <Group justify="space-between" mb="md">
                <Group gap={8}>
                  <IconTrophy size={18} color="var(--yellow)" />
                  <Text fz="md" fw={600} c="var(--text-main)">
                    {lang.employeeOfMonth.title}
                  </Text>
                </Group>
                <Tooltip
                  multiline
                  label={
                    <Text fz="xs" c="var(--text-display)">
                      {lang.employeeOfMonth.month_explanation}
                    </Text>
                  }
                  maw={300}
                  color="var(--tooltip)"
                >
                  <IconHelpCircle size={16} />
                </Tooltip>
              </Group>
              <Group wrap="nowrap" align="center">
                <Avatar
                  size="lg"
                  radius="xl"
                  color="gray"
                  src={
                    business.topEmployee?.image
                      ? business.topEmployee.image
                      : "./user_default.png"
                  }
                />
                <Box>
                  <Text fz="md" fw={700} c="var(--text-main)">
                    {business.topEmployee.name
                      ? business.topEmployee.name
                      : `N/A`}
                  </Text>
                  <Text fz="xs" c="var(--text-dim)" fw={500}>
                    {formatString(
                      lang.employeeOfMonth.description,
                      String(business.topEmployee.activities),
                    )}
                  </Text>
                </Box>
              </Group>
            </Card>
            {extraPermissions.isRestaurant && (
              <Card radius="md" p="lg" className={classes.panelCard}>
                <Group gap={8} mb="md">
                  <IconHeart size={18} color="var(--danger)" />
                  <Text fz="md" fw={600} c="var(--text-main)">
                    {lang.customersFavorite.title}
                  </Text>
                </Group>
                <Box>
                  <Text fz="md" fw={700} c="var(--text-main)">
                    {business.todayDish.label ?? `N/A`}
                  </Text>
                  <Text fz="xs" c="var(--text-dim)" fw={500}>
                    {lang.customersFavorite.description}
                  </Text>
                </Box>
              </Card>
            )}
            <Card
              radius="md"
              p="lg"
              className={classes.panelCard}
              style={{ flex: 1 }}
            >
              <Group gap={8} mb="md">
                <IconMessageStar size={18} color="var(--cyan)" />
                <Text fz="md" fw={600} c="var(--text-main)">
                  {lang.ratedByCustomers.title}
                </Text>
              </Group>
              <Box>
                <Group gap="xs" align="center" mb={4}>
                  <Rating
                    value={business.stars}
                    fractions={2}
                    readOnly
                    size="sm"
                  />
                  <Text fz="md" fw={700} c="var(--yellow)">
                    {business.stars.toFixed(1)}
                  </Text>
                </Group>
                <Text fz="xs" c="var(--text-dim)" fw={500}>
                  {getRatingComment(business.stars)}
                </Text>
              </Box>
            </Card>
          </Stack>
        </Grid.Col>
      </Grid>
    </Stack>
  );
};

export default Overview;
