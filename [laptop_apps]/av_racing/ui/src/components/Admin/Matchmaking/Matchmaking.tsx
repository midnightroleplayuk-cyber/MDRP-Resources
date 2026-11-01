import { useEffect, useState, useCallback } from "react";
import {
  Box,
  Text,
  Group,
  Stack,
  Switch,
  NumberInput,
  Select,
  Tooltip,
  Button,
} from "@mantine/core";
import { useRecoilValue } from "recoil";
import { Lang } from "../../../reducers/atoms";
import { fetchNui, isEnvBrowser } from "../../../hooks/useNuiEvents";
import { Loading } from "../../Loading";
import global from "../../../global.module.css";
import classes from "./style.module.css";

interface SelectOption {
  value: string;
  label: string;
}

interface MMConfig {
  enabled: boolean;
  maxRacers: number;
  tickInterval: number;
  queueUpdateInterval: number;
  trackCacheSeconds: number;
  fillMinCore: number;
  inviteSeconds: number;
  startsIn: number;
  noShowCooldown: number;
  bracket: {
    initial: number;
    widenEvery: number;
    widenBy: number;
    max: number;
  };
  voting: { enabled: boolean; candidates: number; seconds: number };
  race: {
    moneyAccount: string;
    moneypot: number[];
    phasing: string | boolean;
    laps: number[];
    reversed: boolean;
  };
}

const PHASING_OFF = "off";

const MOCK_CFG: MMConfig = {
  enabled: true,
  maxRacers: 30,
  tickInterval: 5,
  queueUpdateInterval: 3,
  trackCacheSeconds: 60,
  fillMinCore: 1,
  inviteSeconds: 45,
  startsIn: 10,
  noShowCooldown: 10,
  bracket: { initial: 150, widenEvery: 30, widenBy: 100, max: 2000 },
  voting: { enabled: true, candidates: 3, seconds: 20 },
  race: {
    moneyAccount: "cosmo",
    moneypot: [25, 100],
    phasing: "racers",
    laps: [1, 3],
    reversed: false,
  },
};
const MOCK_ACCOUNTS: SelectOption[] = [
  { value: "cash", label: "Cash" },
  { value: "cosmo", label: "Cosmo" },
];
const MOCK_PHASING: SelectOption[] = [
  { value: "10", label: "First 10 seconds" },
  { value: "30", label: "First 30 seconds" },
  { value: "racers", label: "Full Race - Racers Only" },
  { value: "npc", label: "Full Race - Locals Only" },
  { value: PHASING_OFF, label: "No phasing" },
];

const Matchmaking = () => {
  const lang: any = useRecoilValue(Lang);
  const [cfg, setCfg] = useState<MMConfig | null>(
    isEnvBrowser() ? MOCK_CFG : null,
  );
  const [minRacers, setMinRacers] = useState<number>(isEnvBrowser() ? 2 : 0);
  const [accounts, setAccounts] = useState<SelectOption[]>(
    isEnvBrowser() ? MOCK_ACCOUNTS : [],
  );
  const [phasingOpts, setPhasingOpts] = useState<SelectOption[]>(
    isEnvBrowser() ? MOCK_PHASING : [],
  );
  const [loaded, setLoaded] = useState(isEnvBrowser());

  useEffect(() => {
    if (isEnvBrowser()) return;
    fetchNui<any>("av_racing", "getMatchmakingConfig").then((resp) => {
      if (resp && resp.settings) {
        setCfg(resp.settings);
        setMinRacers(resp.minRacers ?? 0);
        setAccounts(resp.moneyAccounts ?? []);
        setPhasingOpts([
          ...(resp.phasingOptions ?? []),
          { value: PHASING_OFF, label: lang?.mm_no_phasing ?? "No phasing" },
        ]);
      }
      setLoaded(true);
    });
  }, []);

  const set = useCallback(
    (field: keyof MMConfig, value: any) =>
      setCfg((p) => (p ? { ...p, [field]: value } : p)),
    [],
  );
  const setNested = useCallback(
    (group: "bracket" | "voting" | "race", field: string, value: any) =>
      setCfg((p) =>
        p ? { ...p, [group]: { ...(p as any)[group], [field]: value } } : p,
      ),
    [],
  );
  const setRange = useCallback(
    (group: "race", field: "moneypot" | "laps", idx: 0 | 1, value: any) =>
      setCfg((p) => {
        if (!p) return p;
        const arr = [...(p.race[field] as number[])];
        arr[idx] = Number(value) || 0;
        return { ...p, race: { ...p.race, [field]: arr } };
      }),
    [],
  );

  const handleSave = useCallback(() => {
    if (!cfg) return;
    const payload: MMConfig = {
      ...cfg,
      race: {
        ...cfg.race,
        phasing: cfg.race.phasing === PHASING_OFF ? false : cfg.race.phasing,
      },
    };
    fetchNui("av_racing", "updateMatchmakingConfig", payload);
  }, [cfg]);

  if (!loaded) return <Loading />;
  if (!cfg)
    return (
      <Box className={classes.wrapper}>
        <Text className={classes.muted}>
          {lang?.mm_config_missing ??
            "Matchmaking config unavailable (are you an admin?)"}
        </Text>
      </Box>
    );

  const num = (v: number | string) =>
    typeof v === "number" ? v : Number(v) || 0;

  const label = (text: string, tip: string) => (
    <Group gap={6} align="center" className={classes.labelRow}>
      <Text className={classes.fieldLabel}>{text}</Text>
      <Tooltip label={tip} color="var(--tooltip)" withArrow w={250} multiline>
        <Text className={classes.help}>?</Text>
      </Tooltip>
    </Group>
  );

  return (
    <Stack className={classes.wrapper} p="md">
      <Group>
        <Switch
          ml="auto"
          size="xs"
          checked={cfg.enabled}
          onChange={(e) => set("enabled", e.currentTarget.checked)}
          label={
            cfg.enabled
              ? (lang?.enabled ?? "Enabled")
              : (lang?.disabled ?? "Disabled")
          }
        />
        <Button
          size="xs"
          color="var(--accent)"
          variant="outline"
          onClick={handleSave}
        >
          {lang.save_changes}
        </Button>
      </Group>
      <Box className={classes.group}>
        <Text className={classes.section}>
        {lang?.mm_sec_general ?? "GENERAL"}
      </Text>
      <div className={classes.grid}>
        <Box>
          {label(
            lang?.mm_max_racers ?? "MAX RACERS",
            "Hard cap of racers allowed in a single matchmaking lobby.",
          )}
          <NumberInput
            size="xs"
            value={cfg.maxRacers}
            min={2}
            onChange={(v) => set("maxRacers", num(v))}
            classNames={global}
          />
        </Box>
        <Box>
          {label(
            lang?.mm_min_racers ?? "MIN RACERS (read-only)",
            "Minimum racers needed to lock a lobby. This config can be found in server/editable/_elo.lua > Config.MinEloRacers",
          )}
          <NumberInput
            size="xs"
            value={minRacers}
            disabled
            classNames={global}
          />
        </Box>
        <Box>
          {label(
            lang?.mm_fill_core ?? "FILL MIN CORE",
            "How many racers must explicitly pick a class before wildcards ('fill any lobby') top it up. 1 = as soon as anyone wants that class.",
          )}
          <NumberInput
            size="xs"
            value={cfg.fillMinCore}
            min={1}
            onChange={(v) => set("fillMinCore", num(v))}
            classNames={global}
          />
        </Box>
        <Box>
          {label(
            lang?.mm_tick ?? "TICK INTERVAL (s)",
            "Seconds between matchmaking attempts (how often the server tries to form lobbies).",
          )}
          <NumberInput
            size="xs"
            value={cfg.tickInterval}
            min={1}
            onChange={(v) => set("tickInterval", num(v))}
            classNames={global}
          />
        </Box>
        <Box>
          {label(
            lang?.mm_queue_update ?? "QUEUE UPDATE (s)",
            "Seconds between the live queue-count updates pushed to waiting racers.",
          )}
          <NumberInput
            size="xs"
            value={cfg.queueUpdateInterval}
            min={1}
            onChange={(v) => set("queueUpdateInterval", num(v))}
            classNames={global}
          />
        </Box>
        <Box>
          {label(
            lang?.mm_track_cache ?? "TRACK CACHE (s)",
            "How long the list of ranked-eligible tracks is cached before re-reading the database.",
          )}
          <NumberInput
            size="xs"
            value={cfg.trackCacheSeconds}
            min={0}
            onChange={(v) => set("trackCacheSeconds", num(v))}
            classNames={global}
          />
        </Box>
      </div>
      </Box>
      <Box className={classes.group}>
        <Text className={classes.section}>
        {lang?.mm_sec_bracket ?? "ELO BRACKET"}
      </Text>
      <div className={classes.grid}>
        <Box>
          {label(
            lang?.mm_br_initial ?? "INITIAL ±",
            "ELO range accepted the moment a racer queues.",
          )}
          <NumberInput
            size="xs"
            value={cfg.bracket.initial}
            min={0}
            onChange={(v) => setNested("bracket", "initial", num(v))}
            classNames={global}
          />
        </Box>
        <Box>
          {label(
            lang?.mm_br_every ?? "WIDEN EVERY (s)",
            "Every N seconds a racer waits, the accepted ELO range grows.",
          )}
          <NumberInput
            size="xs"
            value={cfg.bracket.widenEvery}
            min={1}
            onChange={(v) => setNested("bracket", "widenEvery", num(v))}
            classNames={global}
          />
        </Box>
        <Box>
          {label(
            lang?.mm_br_by ?? "WIDEN BY ±",
            "How much the accepted ELO range grows on each widen step.",
          )}
          <NumberInput
            size="xs"
            value={cfg.bracket.widenBy}
            min={0}
            onChange={(v) => setNested("bracket", "widenBy", num(v))}
            classNames={global}
          />
        </Box>
        <Box>
          {label(
            lang?.mm_br_max ?? "MAX ±",
            "The ELO range never widens past this. A very high value effectively means 'match anyone'.",
          )}
          <NumberInput
            size="xs"
            value={cfg.bracket.max}
            min={0}
            onChange={(v) => setNested("bracket", "max", num(v))}
            classNames={global}
          />
        </Box>
      </div>
      </Box>
      <Box className={classes.group}>
        <Text className={classes.section}>
        {lang?.mm_sec_flow ?? "INVITE & VOTE"}
      </Text>
      <div className={classes.grid}>
        <Box>
          {label(
            lang?.mm_invite_secs ?? "INVITE SECONDS",
            "How long a racer has to accept a match invite before it expires.",
          )}
          <NumberInput
            size="xs"
            value={cfg.inviteSeconds}
            min={5}
            onChange={(v) => set("inviteSeconds", num(v))}
            classNames={global}
          />
        </Box>
        <Box>
          {label(
            lang?.mm_starts_in ?? "STARTS IN (min)",
            "Minutes until the race starts once the lobby is locked (time for racers to reach the start and check in).",
          )}
          <NumberInput
            size="xs"
            value={cfg.startsIn}
            min={1}
            onChange={(v) => set("startsIn", num(v))}
            classNames={global}
          />
        </Box>
        <Box>
          {label(
            lang?.mm_cooldown_min ?? "NO-SHOW COOLDOWN (min)",
            "Minutes a racer is locked out of the queue if they accept a match but never check in.",
          )}
          <NumberInput
            size="xs"
            value={cfg.noShowCooldown}
            min={0}
            onChange={(v) => set("noShowCooldown", num(v))}
            classNames={global}
          />
        </Box>
        <Box className={classes.switchBox}>
          {label(
            lang?.mm_vote_enabled ?? "TRACK VOTING",
            "When on, racers vote on which track to race. When off, a random eligible track is picked.",
          )}
          <Switch
            checked={cfg.voting.enabled}
            onChange={(e) =>
              setNested("voting", "enabled", e.currentTarget.checked)
            }
          />
        </Box>
        <Box>
          {label(
            lang?.mm_vote_candidates ?? "VOTE CANDIDATES",
            "How many tracks are put to the vote each time.",
          )}
          <NumberInput
            size="xs"
            value={cfg.voting.candidates}
            min={2}
            onChange={(v) => setNested("voting", "candidates", num(v))}
            classNames={global}
          />
        </Box>
        <Box>
          {label(
            lang?.mm_vote_seconds ?? "VOTE SECONDS",
            "How long racers have to cast their track vote.",
          )}
          <NumberInput
            size="xs"
            value={cfg.voting.seconds}
            min={5}
            onChange={(v) => setNested("voting", "seconds", num(v))}
            classNames={global}
          />
        </Box>
      </div>
      </Box>
      <Box className={classes.group}>
        <Text className={classes.section}>
        {lang?.mm_sec_race ?? "GENERATED RACE"}
      </Text>
      <div className={classes.grid}>
        <Box>
          {label(
            lang?.mm_money_account ?? "MONEY ACCOUNT",
            "Account the prize pot is paid from. Must be one of your configured money accounts.",
          )}
          <Select
            classNames={global}
            size="xs"
            data={accounts}
            value={cfg.race.moneyAccount}
            allowDeselect={false}
            onChange={(v) => v && setNested("race", "moneyAccount", v)}
          />
        </Box>
        <Box>
          {label(
            lang?.mm_phasing ?? "PHASING",
            "Collision phasing used for the ranked race.",
          )}
          <Select
            classNames={global}
            size="xs"
            data={phasingOpts}
            value={
              cfg.race.phasing === false
                ? PHASING_OFF
                : String(cfg.race.phasing)
            }
            allowDeselect={false}
            onChange={(v) => v && setNested("race", "phasing", v)}
          />
        </Box>
        <Box>
          {label(
            lang?.mm_pot_min ?? "PRIZE POT MIN",
            "Lower bound of the server-funded prize pot (a random amount in this range is used).",
          )}
          <NumberInput
            size="xs"
            value={cfg.race.moneypot[0]}
            min={0}
            onChange={(v) => setRange("race", "moneypot", 0, v)}
            classNames={global}
          />
        </Box>
        <Box>
          {label(
            lang?.mm_pot_max ?? "PRIZE POT MAX",
            "Upper bound of the prize pot.",
          )}
          <NumberInput
            size="xs"
            value={cfg.race.moneypot[1]}
            min={0}
            onChange={(v) => setRange("race", "moneypot", 1, v)}
            classNames={global}
          />
        </Box>
        <Box>
          {label(
            lang?.mm_laps_min ?? "LAPS MIN",
            "Fewest laps rolled for circuit tracks (drag tracks always stay at 0).",
          )}
          <NumberInput
            size="xs"
            value={cfg.race.laps[0]}
            min={1}
            onChange={(v) => setRange("race", "laps", 0, v)}
            classNames={global}
          />
        </Box>
        <Box>
          {label(
            lang?.mm_laps_max ?? "LAPS MAX",
            "Most laps rolled for circuit tracks.",
          )}
          <NumberInput
            size="xs"
            value={cfg.race.laps[1]}
            min={1}
            onChange={(v) => setRange("race", "laps", 1, v)}
            classNames={global}
          />
        </Box>
        <Box className={classes.switchBox}>
          {label(
            lang?.mm_reversed ?? "REVERSED",
            "if enabled, reverse mode will be randomly enabled for the event",
          )}
          <Switch
            checked={cfg.race.reversed}
            onChange={(e) =>
              setNested("race", "reversed", e.currentTarget.checked)
            }
          />
        </Box>
      </div>
      </Box>
    </Stack>
  );
};

export default Matchmaking;
