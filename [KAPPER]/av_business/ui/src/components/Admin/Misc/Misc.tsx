import { useEffect, useState } from "react";
import {
  Stack,
  Button,
  Group,
  Text,
  Grid,
  Switch,
  Card,
  NumberInput,
  Flex,
  Tooltip,
  Box,
  Divider,
} from "@mantine/core";
import { useAtomValue } from "jotai";
import { Lang } from "../../../reducers/atoms";
import { fetchNui, isEnvBrowser } from "../../../hooks/useNuiEvents";
import { ApiGeneral, ApiActivities } from "../../../API/admin_settings";
import { GeneralType, ActivitiesType } from "../types";
import global from "../../../global.module.css";
import classes from "./style.module.css";
import { Loading } from "../../Loading";

const SettingCard = ({ title, tooltip, children, span = 3 }: any) => (
  <Grid.Col span={span}>
    <Card className={classes.card}>
      <Flex direction="column" gap="sm">
        <Group>
          <Text fz="sm" c="var(--text-dim)">
            {title}
          </Text>
          <Tooltip
            label={tooltip}
            fz="xs"
            color="var(--tooltip)"
            lts={1}
            multiline
            maw={220}
            withArrow
            position="top-start"
          >
            <Box className={classes.tooltip} bg="var(--tooltip)">
              <Text fz={10} c="var(--text-dim)">
                ?
              </Text>
            </Box>
          </Tooltip>
        </Group>
        {children}
      </Flex>
    </Card>
  </Grid.Col>
);

const Misc = () => {
  const daLang: any = useAtomValue(Lang);
  const lang = daLang.admin;
  const [loaded, setLoaded] = useState(false);
  const [general, setGeneral] = useState<GeneralType>(ApiGeneral);
  const [activities, setActivities] = useState<ActivitiesType>(ApiActivities);

  const updateGeneral = <K extends keyof GeneralType>(
    field: K,
    value: GeneralType[K],
  ) => setGeneral((prev) => ({ ...prev, [field]: value }));

  const updateActivity = <K extends keyof ActivitiesType>(
    field: K,
    value: ActivitiesType[K],
  ) => setActivities((prev) => ({ ...prev, [field]: value }));

  const saveGeneral = () =>
    fetchNui("av_business", "updateSettings", {
      settings: general,
      type: "general",
    });

  const saveActivities = () =>
    fetchNui("av_business", "updateSettings", {
      settings: activities,
      type: "activities",
    });

  useEffect(() => {
    const fetchData = async () => {
      const [genResp, actResp] = await Promise.all([
        fetchNui("av_business", "getSettings", "general"),
        fetchNui("av_business", "getSettings", "activities"),
      ]);
      if (genResp) setGeneral(genResp);
      else if (isEnvBrowser()) setGeneral(ApiGeneral);
      if (actResp) setActivities(actResp);
      else if (isEnvBrowser()) setActivities(ApiActivities);
      setTimeout(() => setLoaded(true), 100);
    };
    fetchData();
  }, []);

  if (!loaded) return <Loading />;

  return (
    <Stack gap="xs">
      <Group>
        <Stack gap={2}>
          <Text fz="xs" c="var(--text-dim)" lts={0.55}>
            {lang.misc_general_desc}
          </Text>
        </Stack>
        <Button
          className={global.button}
          size="xs"
          ml="auto"
          onClick={saveGeneral}
        >
          {lang.save_changes}
        </Button>
      </Group>
      <Grid>
        <SettingCard
          title={lang.misc_bank_log_ttl}
          tooltip={lang.misc_bank_log_ttl_tip}
        >
          <NumberInput
            classNames={global}
            size="xs"
            min={1}
            max={365}
            allowDecimal={false}
            allowNegative={false}
            value={general.bankLogs}
            onChange={(e) => updateGeneral("bankLogs", Number(e))}
          />
        </SettingCard>
        <SettingCard
          title={lang.misc_app_ttl}
          tooltip={lang.misc_app_ttl_tip}
        >
          <NumberInput
            classNames={global}
            size="xs"
            min={1}
            max={365}
            allowDecimal={false}
            allowNegative={false}
            value={general.applications}
            onChange={(e) => updateGeneral("applications", Number(e))}
          />
        </SettingCard>
        <SettingCard
          title={lang.misc_max_questions}
          tooltip={lang.misc_max_questions_tip}
        >
          <NumberInput
            classNames={global}
            size="xs"
            min={1}
            max={20}
            allowDecimal={false}
            allowNegative={false}
            value={general.maxQuestions}
            onChange={(e) => updateGeneral("maxQuestions", Number(e))}
          />
        </SettingCard>
        <SettingCard
          title={lang.misc_boss_edit}
          tooltip={lang.misc_boss_edit_tip}
        >
          <Switch
            classNames={global}
            color="var(--accent)"
            size="xs"
            checked={general.bossCanEditItself}
            label={general.bossCanEditItself ? lang.enabled : lang.disabled}
            onChange={(e) =>
              updateGeneral("bossCanEditItself", e.currentTarget.checked)
            }
          />
        </SettingCard>
      </Grid>

      <Divider opacity={0.15} my={2} />
      <Group>
        <Text fz="xs" c="var(--text-dim)" lts={0.55}>
          {lang.misc_activities_desc}
        </Text>
        <Button
          className={global.button}
          size="xs"
          ml="auto"
          onClick={saveActivities}
        >
          {lang.save_changes}
        </Button>
      </Group>
      <Grid>
        <SettingCard
          span={4}
          title={lang.misc_cashier_sales}
          tooltip={lang.misc_cashier_sales_tip}
        >
          <NumberInput
            classNames={global}
            size="xs"
            min={0}
            max={100}
            allowDecimal={false}
            allowNegative={false}
            value={activities.cashierAdds}
            onChange={(e) => updateActivity("cashierAdds", Number(e))}
          />
        </SettingCard>
        <SettingCard
          span={4}
          title={lang.misc_mark_delivered}
          tooltip={lang.misc_mark_delivered_tip}
        >
          <NumberInput
            classNames={global}
            size="xs"
            min={0}
            max={100}
            allowDecimal={false}
            allowNegative={false}
            value={activities.markAsDelivered}
            onChange={(e) => updateActivity("markAsDelivered", Number(e))}
          />
        </SettingCard>
        <SettingCard
          span={4}
          title={lang.misc_buy_supplies}
          tooltip={lang.misc_buy_supplies_tip}
        >
          <NumberInput
            classNames={global}
            size="xs"
            min={0}
            max={100}
            allowDecimal={false}
            allowNegative={false}
            value={activities.buyingSupplies}
            onChange={(e) => updateActivity("buyingSupplies", Number(e))}
          />
        </SettingCard>
        <SettingCard
          span={4}
          title={lang.misc_order_delivery}
          tooltip={lang.misc_order_delivery_tip}
        >
          <NumberInput
            classNames={global}
            size="xs"
            min={0}
            max={100}
            allowDecimal={false}
            allowNegative={false}
            value={activities.orderDelivery}
            onChange={(e) => updateActivity("orderDelivery", Number(e))}
          />
        </SettingCard>
        <SettingCard
          span={4}
          title={lang.misc_pawnshop_sells}
          tooltip={lang.misc_pawnshop_sells_tip}
        >
          <NumberInput
            classNames={global}
            size="xs"
            min={0}
            max={100}
            allowDecimal={false}
            allowNegative={false}
            value={activities.pawnshopSells}
            onChange={(e) => updateActivity("pawnshopSells", Number(e))}
          />
        </SettingCard>
        <SettingCard
          span={4}
          title={lang.misc_pawnshop_buying}
          tooltip={lang.misc_pawnshop_buying_tip}
        >
          <NumberInput
            classNames={global}
            size="xs"
            min={0}
            max={100}
            allowDecimal={false}
            allowNegative={false}
            value={activities.pawnshopBuying}
            onChange={(e) => updateActivity("pawnshopBuying", Number(e))}
          />
        </SettingCard>
      </Grid>
    </Stack>
  );
};

export default Misc;
