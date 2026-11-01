import { useCallback, useEffect, useMemo, useRef, useState } from "react";
import { Box, Text, Group, Stack, Select } from "@mantine/core";
import { useRecoilValue } from "recoil";
import { Lang, Classes } from "../../../../reducers/atoms";
import {
  fetchNui,
  useNuiEvent,
  isEnvBrowser,
} from "../../../../hooks/useNuiEvents";
import global from "../../../../global.module.css";
import classes from "./style.module.css";

interface QueueState {
  enabled: boolean;
  inRace?: boolean;
  inQueue: boolean;
  invite?: (Invite & { answered?: boolean }) | null;
  vote?:
    | (VoteStart & { counts?: Record<string, number>; myVote?: string | null })
    | null;
  class?: string;
  waited?: number;
  queued?: number;
  minRacers?: number;
  maxRacers?: number;
  needed?: number;
  bracket?: number;
  elo?: number;
  cooldown?: number;
}

interface Invite {
  seconds: number;
  class: string;
  racers: number;
  minRacers: number;
}

interface VoteTrack {
  identifier: string;
  name: string;
  type?: string;
  distance?: string;
  checkpoints?: number;
}

interface VoteStart {
  seconds: number;
  tracks: VoteTrack[];
}

const fmtWait = (s: number) => {
  const m = Math.floor(s / 60);
  const sec = (s % 60).toString().padStart(2, "0");
  return `${m}:${sec}`;
};

const prefLabel = (c?: string, lang?: any) => {
  if (c === "fill") return lang?.fill_any ?? "Fill any lobby";
  if (c === "all") return lang?.open_class ?? "Open class";
  return c ? `${lang?.mm_class_required ?? "Class"} ${c.toUpperCase()}` : "-";
};

const Matchmaking = () => {
  const lang: any = useRecoilValue(Lang);
  const vehClasses = useRecoilValue(Classes);

  const [state, setState] = useState<QueueState>({
    enabled: true,
    inQueue: false,
    queued: 0,
    minRacers: 10,
  });
  const [selected, setSelected] = useState<string>("all");
  const [invite, setInvite] = useState<Invite | null>(null);
  const [inviteLeft, setInviteLeft] = useState(0);
  const [answered, setAnswered] = useState(false);
  const [vote, setVote] = useState<VoteStart | null>(null);
  const [voteLeft, setVoteLeft] = useState(0);
  const [voteCounts, setVoteCounts] = useState<Record<string, number>>({});
  const [myVote, setMyVote] = useState<string | null>(null);
  const [voteResult, setVoteResult] = useState<string | null>(null);
  const timer = useRef<ReturnType<typeof setInterval> | null>(null);

  useEffect(() => {
    if (isEnvBrowser()) return;
    fetchNui<QueueState>("av_racing", "mmGetState").then((resp) => {
      if (!resp) return;
      setState((p) => ({ ...p, ...resp }));
      if (resp.vote) {
        setVote({ seconds: resp.vote.seconds, tracks: resp.vote.tracks });
        setVoteLeft(resp.vote.seconds);
        setVoteCounts(resp.vote.counts ?? {});
        setMyVote(resp.vote.myVote ?? null);
      } else if (resp.invite) {
        setInvite(resp.invite);
        setInviteLeft(resp.invite.seconds);
        setAnswered(resp.invite.answered === true);
      }
    });
  }, []);

  useNuiEvent("mmQueueUpdate", (data: QueueState | null) => {
    if (!data) {
      setState((p) => ({ ...p, inQueue: false, waited: 0 }));
      return;
    }
    setState((p) => ({ ...p, ...data, inQueue: true }));
  });

  useNuiEvent("mmInvite", (data: Invite) => {
    setInvite(data);
    setInviteLeft(data.seconds);
    setAnswered(false);
    setState((p) => ({ ...p, inQueue: false }));
  });

  useNuiEvent("mmCancelled", () => {
    setInvite(null);
    setAnswered(false);
    setVote(null);
    setMyVote(null);
  });

  useNuiEvent("mmMatched", () => {
    setInvite(null);
    setAnswered(false);
    setVote(null);
    setMyVote(null);
    setState((p) => ({ ...p, inQueue: false }));
  });

  useNuiEvent("mmVoteStart", (data: VoteStart) => {
    setInvite(null);
    setAnswered(false);
    setVote(data);
    setVoteLeft(data.seconds);
    setVoteCounts({});
    setMyVote(null);
    setVoteResult(null);
  });

  useNuiEvent("mmVoteUpdate", (counts: Record<string, number>) => {
    setVoteCounts(counts ?? {});
  });

  useNuiEvent("mmVoteResult", (data: { track: string }) => {
    setVoteResult(data?.track ?? null);
    setVote(null);
  });

  useEffect(() => {
    if (!state.inQueue || invite) return;
    const t = setInterval(() => {
      setState((p) => ({ ...p, waited: (p.waited ?? 0) + 1 }));
    }, 1000);
    return () => clearInterval(t);
  }, [state.inQueue, invite]);

  useEffect(() => {
    if (!vote) return;
    const t = setInterval(() => {
      setVoteLeft((v) => (v <= 1 ? 0 : v - 1));
    }, 1000);
    return () => clearInterval(t);
  }, [vote]);

  const castVote = useCallback((trackId: string) => {
    setMyVote(trackId);
    fetchNui("av_racing", "mmVote", { trackId });
  }, []);

  useEffect(() => {
    if (!invite) {
      if (timer.current) clearInterval(timer.current);
      return;
    }
    timer.current = setInterval(() => {
      setInviteLeft((v) => {
        if (v <= 1) {
          if (timer.current) clearInterval(timer.current);
          setInvite(null);
          return 0;
        }
        return v - 1;
      });
    }, 1000);
    return () => {
      if (timer.current) clearInterval(timer.current);
    };
  }, [invite]);

  const [pending, setPending] = useState(false);

  const joinQueue = useCallback(async () => {
    setPending(true);
    const resp = await fetchNui<{ ok: boolean }>("av_racing", "mmJoinQueue", {
      class: selected,
    });
    setPending(false);
    if (resp?.ok) setState((p) => ({ ...p, inQueue: true, waited: 0 }));
  }, [selected]);

  const leaveQueue = useCallback(async () => {
    setPending(true);
    const resp = await fetchNui<{ ok: boolean }>("av_racing", "mmLeaveQueue");
    setPending(false);
    if (resp?.ok) setState((p) => ({ ...p, inQueue: false, waited: 0 }));
  }, []);

  const accept = useCallback(() => {
    fetchNui("av_racing", "mmAccept");
    setAnswered(true);
  }, []);

  const decline = useCallback(() => {
    fetchNui("av_racing", "mmDecline");
    setInvite(null);
    setAnswered(false);
  }, []);

  const classOptions = useMemo(() => {
    const seen = new Set<string>();
    const opts: { value: string; label: string }[] = [];
    for (const c of vehClasses) {
      const value = c?.value;
      if (!value) continue;
      const key = value.toLowerCase();
      if (seen.has(key)) continue;
      seen.add(key);
      const label =
        key === "all"
          ? (lang?.open_class ?? "Open class (any car)")
          : (c.label ?? value);
      opts.push({ value, label });
    }
    if (!seen.has("all")) {
      opts.unshift({
        value: "all",
        label: lang?.open_class ?? "Open class (any car)",
      });
    }
    opts.push({
      value: "fill",
      label: lang?.fill_any ?? "Fill any lobby (fastest match)",
    });
    return opts;
  }, [vehClasses, lang]);

  const min = state.minRacers ?? 10;
  const queued = state.queued ?? 0;
  const pct = Math.min(100, (queued / Math.max(1, min)) * 100);
  const onCooldown = (state.cooldown ?? 0) > 0;
  const inRace = state.inRace === true;

  if (vote) {
    const total = Object.values(voteCounts).reduce((a, b) => a + b, 0);
    return (
      <Box className={classes.wrapper}>
        <Box className={classes.card}>
          <Stack gap={16}>
            <Box>
              <Text className={classes.rankedBadge}>RANKED</Text>
              <Text className={classes.title}>
                {lang?.mm_vote_title ?? "VOTE FOR THE TRACK"}
              </Text>
              <Text className={classes.subtitle}>
                {lang?.mm_vote_sub ??
                  "Most votes wins. Ties are broken at random."}
              </Text>
            </Box>
            <Text className={classes.countdown}>{voteLeft}</Text>
            <Stack gap={8}>
              {vote.tracks.map((t) => {
                const count = voteCounts[t.identifier] ?? 0;
                const pctVotes = total > 0 ? (count / total) * 100 : 0;
                const mine = myVote === t.identifier;
                return (
                  <Box
                    key={t.identifier}
                    className={`${classes.trackCard} ${mine ? classes.trackCardMine : ""}`}
                    onClick={() => castVote(t.identifier)}
                  >
                    <Group justify="space-between" wrap="nowrap">
                      <Box>
                        <Text className={classes.trackName}>{t.name}</Text>
                        <Text className={classes.trackMeta}>
                          {[
                            t.type?.toUpperCase(),
                            t.distance,
                            t.checkpoints
                              ? `${t.checkpoints} ${lang?.checkpoints ?? "CP"}`
                              : null,
                          ]
                            .filter(Boolean)
                            .join(" · ")}
                        </Text>
                      </Box>
                      <Text className={classes.voteCount}>{count}</Text>
                    </Group>
                    <Box className={classes.barWrap}>
                      <Box
                        className={classes.barFill}
                        style={{ width: `${pctVotes}%` }}
                      />
                    </Box>
                  </Box>
                );
              })}
            </Stack>
            <Text className={classes.hint}>
              {myVote
                ? (lang?.mm_voted ?? "Vote cast — waiting for the others...")
                : (lang?.mm_pick_track ?? "Pick a track")}
            </Text>
          </Stack>
        </Box>
      </Box>
    );
  }
  if (invite) {
    return (
      <Box className={classes.wrapper}>
        <Box className={classes.card}>
          <Stack gap={16} align="center">
            <Text className={classes.rankedBadge}>RANKED</Text>
            <Text className={classes.title}>
              {lang?.mm_match_found ?? "MATCH FOUND"}
            </Text>
            <Text className={classes.subtitle}>
              {invite.racers} {lang?.racers ?? "racers"} ·{" "}
              {invite.class === "all"
                ? (lang?.open_class ?? "Open class")
                : `${lang?.mm_class_required ?? "Class"} ${invite.class.toUpperCase()}`}
            </Text>
            <Text className={classes.countdown}>{inviteLeft}</Text>
            {answered ? (
              <Text className={classes.waitingText}>
                {lang?.mm_waiting_others ?? "Waiting for the other racers..."}
              </Text>
            ) : (
              <Group gap={12}>
                <button className={classes.acceptButton} onClick={accept}>
                  {lang?.accept ?? "ACCEPT"}
                </button>
                <button className={classes.declineButton} onClick={decline}>
                  {lang?.decline ?? "DECLINE"}
                </button>
              </Group>
            )}
          </Stack>
        </Box>
      </Box>
    );
  }
  return (
    <Box className={classes.wrapper}>
      <Box className={classes.card}>
        <Stack gap={20}>
          <Box>
            <Text className={classes.rankedBadge}>RANKED</Text>
            <Text className={classes.title}>
              {lang?.matchmaking_tab ?? "MATCHMAKING"}
            </Text>
            <Text className={classes.subtitle}>
              {lang?.mm_description ??
                "Queue up and get matched against racers of a similar skill level."}
            </Text>
          </Box>
          {voteResult && (
            <Text className={classes.hint}>
              {(lang?.mm_vote_won ?? "Track selected:") + " " + voteResult}
            </Text>
          )}
          {!state.enabled ? (
            <Text className={classes.disabledText}>
              {lang?.mm_disabled ?? "Matchmaking is currently disabled"}
            </Text>
          ) : state.inQueue ? (
            <Stack gap={14}>
              <Box className={classes.statRow}>
                <Text className={classes.label}>
                  {lang?.mm_searching ?? "SEARCHING"}
                </Text>
                <Text className={classes.value}>
                  {prefLabel(state.class, lang)}
                </Text>
              </Box>
              <Box className={classes.statRow}>
                <Text className={classes.label}>
                  {lang?.mm_in_queue ?? "IN QUEUE"}
                </Text>
                <Text className={classes.value}>
                  {queued} / {min}
                </Text>
              </Box>
              <Box className={classes.barWrap}>
                <Box className={classes.barFill} style={{ width: `${pct}%` }} />
              </Box>
              <Box className={classes.statRow}>
                <Text className={classes.label}>
                  {lang?.mm_waiting ?? "YOUR WAIT"}
                </Text>
                <Text className={classes.value}>
                  {fmtWait(state.waited ?? 0)}
                </Text>
              </Box>
              <Box className={classes.statRow}>
                <Text className={classes.label}>
                  {lang?.mm_elo_range ?? "ELO RANGE"}
                </Text>
                <Text className={classes.value}>±{state.bracket ?? 0}</Text>
              </Box>
              <Text className={classes.hint}>
                {(state.needed ?? 0) > 0
                  ? `${state.needed} ${lang?.mm_more_needed ?? "more racer(s) needed"}`
                  : (lang?.mm_forming ?? "Forming lobby...")}
              </Text>
              <button
                className={classes.leaveButton}
                onClick={leaveQueue}
                disabled={pending}
              >
                {lang?.mm_leave ?? "LEAVE QUEUE"}
              </button>
            </Stack>
          ) : (
            <Stack gap={14}>
              <Box>
                <Text className={classes.label}>
                  {lang?.mm_class ?? "VEHICLE CLASS"}
                </Text>
                <Select
                  classNames={global}
                  data={classOptions}
                  value={selected}
                  onChange={(v) => setSelected(v ?? "all")}
                  allowDeselect={false}
                  size="xs"
                  styles={{
                    input: {
                      backgroundColor: "var(--bg-main)",
                      border: "1px solid var(--border-color)",
                      color: "var(--text-dim)",
                    },
                  }}
                />
              </Box>
              <Text className={classes.hint}>
                {selected === "fill"
                  ? (lang?.fill_hint ??
                    "You may be placed in any class. The required class is shown before you accept.")
                  : selected === "all"
                    ? (lang?.open_hint ??
                      "Open class race — bring any car you like.")
                    : (lang?.class_hint ??
                      `You'll need a class ${selected.toUpperCase()} car.`)}
              </Text>
              <Box className={classes.statRow}>
                <Text className={classes.label}>
                  {lang?.mm_racers_needed ?? "RACERS NEEDED"}
                </Text>
                <Text className={classes.value}>{min}</Text>
              </Box>
              {onCooldown && (
                <Text className={classes.disabledText}>
                  {lang?.mm_cooldown ?? "You are on matchmaking cooldown"} (
                  {fmtWait(state.cooldown ?? 0)})
                </Text>
              )}
              {inRace && (
                <Text className={classes.disabledText}>
                  {lang?.mm_in_race ??
                    "You can't queue while you are in a race"}
                </Text>
              )}
              <button
                className={classes.primaryButton}
                onClick={joinQueue}
                disabled={onCooldown || inRace || pending}
              >
                {lang?.mm_join ?? "JOIN QUEUE"}
              </button>
            </Stack>
          )}
        </Stack>
      </Box>
    </Box>
  );
};

export default Matchmaking;
