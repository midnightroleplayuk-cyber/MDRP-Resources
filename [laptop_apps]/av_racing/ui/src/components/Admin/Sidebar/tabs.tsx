import {
  UsersRound,
  Radio,
  Trophy,
  Map,
  Award,
  CalendarDays,
  Swords,
} from "lucide-react";
import { ReactNode } from "react";

export interface AdminTab {
  value: string;
  label: string;
  icon: ReactNode;
  desc?: string;
}

const ICON_PROPS = { size: 18, strokeWidth: 1.7 };

export const getTabs = (lang: any): AdminTab[] => [
  {
    value: "crews",
    label: lang.crews_tab ?? "CREWS",
    icon: <UsersRound {...ICON_PROPS} />,
    desc: lang.desc_crews ?? "Manage racing crews and their members",
  },
  {
    value: "live",
    label: lang.live_tab ?? "LIVE",
    icon: <Radio {...ICON_PROPS} />,
    desc: lang.desc_live ?? "Races running right now",
  },
  {
    value: "results",
    label: lang.results_tab ?? "RESULTS",
    icon: <Trophy {...ICON_PROPS} />,
    desc: lang.desc_results ?? "Finished races and their standings",
  },
  {
    value: "tracks",
    label: lang.tracks_tab ?? "TRACKS",
    icon: <Map {...ICON_PROPS} />,
    desc: lang.desc_tracks ?? "Circuits, records and checkpoints",
  },
  {
    value: "season",
    label: lang.season_tab ?? "SEASON",
    icon: <Award {...ICON_PROPS} />,
    desc: lang.desc_season ?? "Season standings and rewards",
  },
  {
    value: "events",
    label: lang.events_tab ?? "EVENTS",
    icon: <CalendarDays {...ICON_PROPS} />,
    desc: lang.desc_events ?? "Scheduled and automatic events",
  },
  {
    value: "matchmaking",
    label: lang.matchmaking_tab ?? "MATCHMAKING",
    icon: <Swords {...ICON_PROPS} />,
    desc: lang.desc_matchmaking ?? "Ranked queue and lobby settings",
  },
];
