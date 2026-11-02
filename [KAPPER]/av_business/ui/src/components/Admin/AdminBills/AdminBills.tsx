import { useEffect, useState } from "react";
import {
  Stack,
  Button,
  Group,
  Text,
  Grid,
  NumberInput,
  Switch,
  Divider,
  ScrollAreaAutosize,
  Select,
  Box,
  Badge,
  SegmentedControl,
} from "@mantine/core";
import { useAtomValue } from "jotai";
import { Lang } from "../../../reducers/atoms";
import { fetchNui, isEnvBrowser } from "../../../hooks/useNuiEvents";
import { SelectType } from "../../../types/types";
import { Loading } from "../../Loading";
import { BillCfgEntry, ApiCfg, BillsConfig, RentState, TaxState } from "./api";
import global from "../../../global.module.css";
import classes from "./style.module.css";

const UtilityCard = ({
  label,
  cfg,
  onChange,
  lang,
}: {
  label: string;
  cfg: BillCfgEntry;
  onChange: (v: Partial<BillCfgEntry>) => void;
  lang: any;
}) => (
  <Grid.Col span={4}>
    <Box className={classes.card}>
      <Stack gap="sm">
        <Group justify="space-between">
          <Text fz="sm" c="var(--text-dim)">
            {label}
          </Text>
          <Switch
            color="var(--accent)"
            size="xs"
            checked={cfg.enabled}
            onChange={(e) => onChange({ enabled: e.currentTarget.checked })}
          />
        </Group>
        <NumberInput
          classNames={global}
          size="xs"
          label={lang.bills_cost_per_craft}
          min={0}
          value={cfg.perCraftCost}
          onChange={(v) => onChange({ perCraftCost: Number(v) || 0 })}
          disabled={!cfg.enabled}
        />
        <NumberInput
          classNames={global}
          size="xs"
          label={lang.bills_interval_days}
          min={1}
          value={cfg.intervalDays}
          onChange={(v) => onChange({ intervalDays: Number(v) || 7 })}
          disabled={!cfg.enabled}
        />
      </Stack>
    </Box>
  </Grid.Col>
);

const AdminBills = ({ allJobs }: { allJobs: SelectType[] }) => {
  const daLang: any = useAtomValue(Lang);
  const lang = daLang.admin;
  const [section, setSection] = useState("config");
  const [cfg, setCfg] = useState<BillsConfig>(ApiCfg);
  const [loaded, setLoaded] = useState(false);
  const [selectedJob, setSelectedJob] = useState<string | null>(null);
  const [rent, setRent] = useState<RentState>({
    enabled: false,
    amount: 0,
    interval: 7,
  });
  const [tax, setTax] = useState<TaxState>({ rate: 0, interval: 7 });
  const [loadingRent, setLoadingRent] = useState(false);
  const [savingRent, setSavingRent] = useState(false);
  const [savingTax, setSavingTax] = useState(false);

  useEffect(() => {
    const load = async () => {
      const resp = await fetchNui("av_business", "getSettings", "bills");
      if (resp && resp.gas) setCfg(resp);
      else if (isEnvBrowser()) setCfg(ApiCfg);
      setTimeout(() => setLoaded(true), 100);
    };
    load();
  }, []);

  useEffect(() => {
    if (!selectedJob) return;
    const loadRent = async () => {
      setLoadingRent(true);
      const resp = await fetchNui("av_business", "getAdminBills", selectedJob);
      if (resp) {
        setRent({
          enabled: resp.rent_enabled === 1,
          amount: resp.rent_amount || 0,
          interval: resp.rent_interval || 7,
        });
        setTax({
          rate: resp.tax_rate || 0,
          interval: resp.tax_interval || 7,
        });
      }
      setLoadingRent(false);
    };
    loadRent();
  }, [selectedJob]);

  const updateUtility = (
    key: "gas" | "electricity" | "water",
    v: Partial<BillCfgEntry>,
  ) => setCfg((prev) => ({ ...prev, [key]: { ...prev[key], ...v } }));

  const saveConfig = () =>
    fetchNui("av_business", "updateSettings", { settings: cfg, type: "bills" });

  const saveRent = async () => {
    if (!selectedJob) return;
    setSavingRent(true);
    await fetchNui("av_business", "setRent", { job: selectedJob, ...rent });
    setSavingRent(false);
  };

  const saveTax = async () => {
    if (!selectedJob) return;
    setSavingTax(true);
    await fetchNui("av_business", "setTax", {
      job: selectedJob,
      rate: tax.rate,
    });
    setSavingTax(false);
  };

  if (!loaded) return <Loading />;

  const jobLabel =
    allJobs.find((j) => j.value === selectedJob)?.label ?? selectedJob;

  return (
    <Stack gap="xs">
      <Group justify="space-between" align="center">
        <SegmentedControl
          size="xs"
          value={section}
          onChange={setSection}
          styles={{
            root: {
              backgroundColor: "var(--bg-card)",
              border: "solid 1px var(--border)",
              width: "fit-content",
            },
            indicator: { backgroundColor: "var(--accent)" },
          }}
          classNames={{
            label: classes.segLabel,
            indicator: classes.segIndicator,
          }}
          data={[
            { value: "config", label: lang.bills_utility_config },
            { value: "rent", label: lang.bills_rent },
            { value: "tax", label: lang.bills_tax },
          ]}
        />
        {section === "config" && (
          <Button className={global.button} size="xs" onClick={saveConfig}>
            {lang.save_changes}
          </Button>
        )}
      </Group>

      <ScrollAreaAutosize h={590} type="hover" scrollbars="y" scrollbarSize={5}>
        {section === "config" && (
          <Stack gap="sm">
            <Text fz="xs" c="var(--text-dim)">
              {lang.bills_maintenance}
            </Text>
            <Grid gap="xs">
              <Grid.Col span={4}>
                <Box className={classes.card}>
                  <NumberInput
                    classNames={global}
                    size="xs"
                    label={lang.bills_dirt_per_action}
                    min={0}
                    max={100}
                    step={0.1}
                    decimalScale={1}
                    value={cfg.dirtPerAction}
                    onChange={(v) =>
                      setCfg((p) => ({ ...p, dirtPerAction: Number(v) || 0 }))
                    }
                  />
                </Box>
              </Grid.Col>
              <Grid.Col span={4}>
                <Box className={classes.card}>
                  <NumberInput
                    classNames={global}
                    size="xs"
                    label={lang.bills_clean_per_item}
                    min={1}
                    max={100}
                    value={cfg.cleanPerItem}
                    onChange={(v) =>
                      setCfg((p) => ({ ...p, cleanPerItem: Number(v) || 20 }))
                    }
                  />
                </Box>
              </Grid.Col>
            </Grid>
            <Divider opacity={0.12} />
            <Text fz="xs" c="var(--text-dim)">
              {lang.bills_utility_bills}
            </Text>
            <Grid gap="xs">
              <UtilityCard
                label={lang.bills_gas}
                cfg={cfg.gas}
                onChange={(v) => updateUtility("gas", v)}
                lang={lang}
              />
              <UtilityCard
                label={lang.bills_electricity}
                cfg={cfg.electricity}
                onChange={(v) => updateUtility("electricity", v)}
                lang={lang}
              />
              <UtilityCard
                label={lang.bills_water}
                cfg={cfg.water}
                onChange={(v) => updateUtility("water", v)}
                lang={lang}
              />
            </Grid>
          </Stack>
        )}
        {section === "rent" && (
          <Stack gap="sm">
            <Text fz="xs" c="var(--text-dim)">
              {lang.bills_rent_desc}
            </Text>

            <Select
              classNames={global}
              size="xs"
              placeholder={lang.bills_select_business}
              data={allJobs}
              value={selectedJob}
              onChange={setSelectedJob}
              searchable
              clearable
            />
            {selectedJob && !loadingRent && (
              <Box
                className={`${classes.rentCard} ${rent.enabled ? classes.rentCardActive : ""}`}
              >
                <Stack gap="sm">
                  <Group justify="space-between">
                    <Text fz="sm" c="var(--text-dim)">
                      Rent for&nbsp;
                      <Text span c="var(--text-main)" fw={500}>
                        {jobLabel}
                      </Text>
                    </Text>
                    <Group gap="xs">
                      <Badge
                        size="xs"
                        variant="light"
                        color={rent.enabled ? "violet" : "gray"}
                      >
                        {rent.enabled ? lang.active : lang.disabled}
                      </Badge>
                      <Switch
                        color="var(--accent)"
                        size="xs"
                        checked={rent.enabled}
                        onChange={(e) =>
                          setRent((p) => ({
                            ...p,
                            enabled: e.currentTarget.checked,
                          }))
                        }
                      />
                    </Group>
                  </Group>
                  <Grid gap="xs">
                    <Grid.Col span={6}>
                      <NumberInput
                        classNames={global}
                        size="xs"
                        label={lang.bills_rent_amount}
                        min={0}
                        disabled={!rent.enabled}
                        value={rent.amount}
                        onChange={(v) =>
                          setRent((p) => ({ ...p, amount: Number(v) || 0 }))
                        }
                      />
                    </Grid.Col>
                    <Grid.Col span={6}>
                      <NumberInput
                        classNames={global}
                        size="xs"
                        label={lang.bills_interval_days}
                        min={1}
                        disabled={!rent.enabled}
                        value={rent.interval}
                        onChange={(v) =>
                          setRent((p) => ({ ...p, interval: Number(v) || 7 }))
                        }
                      />
                    </Grid.Col>
                  </Grid>
                  <Group justify="flex-end">
                    <Button
                      className={global.button}
                      size="xs"
                      loading={savingRent}
                      onClick={saveRent}
                    >
                      {lang.bills_save_rent}
                    </Button>
                  </Group>
                </Stack>
              </Box>
            )}
            {selectedJob && loadingRent && <Loading />}
            {!selectedJob && (
              <Text
                fz="xs"
                c="var(--text-dim)"
                ta="center"
                opacity={0.5}
                py="xl"
              >
                {lang.bills_select_hint}
              </Text>
            )}
          </Stack>
        )}
        {section === "tax" && (
          <Stack gap="sm">
            <Text fz="xs" c="var(--text-dim)">
              {lang.bills_tax_desc}
            </Text>

            <Select
              classNames={global}
              size="xs"
              placeholder={lang.bills_select_business}
              data={allJobs}
              value={selectedJob}
              onChange={setSelectedJob}
              searchable
              clearable
            />
            {selectedJob && !loadingRent && (
              <Box className={classes.rentCard}>
                <Stack gap="sm">
                  <Text fz="sm" c="var(--text-dim)">
                    Tax for&nbsp;
                    <Text span c="var(--text-main)" fw={500}>
                      {jobLabel}
                    </Text>
                  </Text>
                  <NumberInput
                    classNames={global}
                    size="xs"
                    label={lang.bills_tax_rate}
                    min={0}
                    max={100}
                    step={1}
                    value={tax.rate}
                    onChange={(v) =>
                      setTax((p) => ({ ...p, rate: Number(v) || 0 }))
                    }
                  />
                  <Group justify="flex-end">
                    <Button
                      className={global.button}
                      size="xs"
                      loading={savingTax}
                      onClick={saveTax}
                    >
                      {lang.bills_save_tax}
                    </Button>
                  </Group>
                </Stack>
              </Box>
            )}
            {selectedJob && loadingRent && <Loading />}
            {!selectedJob && (
              <Text
                fz="xs"
                c="var(--text-dim)"
                ta="center"
                opacity={0.5}
                py="xl"
              >
                {lang.bills_select_hint} tax
              </Text>
            )}
          </Stack>
        )}
      </ScrollAreaAutosize>
    </Stack>
  );
};

export default AdminBills;
