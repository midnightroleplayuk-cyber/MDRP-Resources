import { Box, Tooltip } from "@mantine/core";
import {
  Route,
  Flag,
  Car,
  Users,
  UserPlus,
  FileText,
  MapPin,
  MessageSquare,
  UserX,
  Play,
  Trash,
  CheckSquare,
  Flame,
} from "lucide-react";
import { EventType } from "../../../../../types/types";
import { Timer } from "../../../../../hooks/Timer";
import classes from "./style.module.css";

interface Properties {
  joined: boolean;
  isHostAdmin: boolean;
  event: EventType;
  lang: any;
  handleJoin: (event: EventType) => void;
  handleDetails: (event: EventType, joined: boolean) => void;
  handleRoute: (event: EventType, joined: boolean) => void;
  handleQuit: (event: EventType) => void;
  handleStart: (event: EventType) => void;
  handleDelete: (identifier: string) => void;
  handleCheckin: (identifier: string) => void;
  handleChat: (identifier: string) => void;
}

const ActionButton = ({
  label,
  onClick,
  icon: Icon,
  color = "var(--text-main)",
  danger = false,
  doubleClick = false,
}: {
  label: string;
  onClick: () => void;
  icon: React.ElementType;
  color?: string;
  danger?: boolean;
  doubleClick?: boolean;
}) => (
  <Tooltip label={label} color="var(--tooltip)" fz="xs" withArrow>
    <button
      className={`${classes.actionBtn} ${danger ? classes.actionBtnDanger : ""}`}
      onClick={!doubleClick ? onClick : undefined}
      onDoubleClick={doubleClick ? onClick : undefined}
      style={!danger ? { color } : undefined}
    >
      <Icon size={16} />
    </button>
  </Tooltip>
);

const iconMap: Record<string, any> = {
  circuit: Route,
  drift: Flame,
};

export const Element = ({
  event,
  joined,
  isHostAdmin,
  lang,
  handleDelete,
  handleJoin,
  handleQuit,
  handleRoute,
  handleStart,
  handleDetails,
  handleCheckin,
  handleChat,
}: Properties) => {
  const eventType = event.type?.toLowerCase();
  const TypeIcon = eventType && iconMap[eventType] ? iconMap[eventType] : Flag;
  const currentRacers = event.racers ? Object.keys(event.racers).length : 0;

  return (
    <Box className={classes.eventRow}>
      <Box className={classes.eventInfo}>
        <Box className={classes.eventIcon}>
          <TypeIcon size={20} />
        </Box>
        <Box className={classes.eventDetails}>
          <h3>{event.title}</h3>
          <Box className={classes.eventMeta} tt="capitalize">
            <span>
              <Car size={14} /> {event.class}
            </span>
            <span>
              <TypeIcon size={14} /> {event.type}
            </span>
            <span>
              <Users size={14} />
              {currentRacers}
            </span>
          </Box>
        </Box>
      </Box>
      <Box className={classes.eventActions}>
        <Box className={classes.expires}>
          <Box className={classes.expiresLabel}>
            {event.started
              ? (lang.started ?? "STARTED")
              : (lang.starts_in ?? "STARTS IN")}
          </Box>
          <Box
            className={classes.expiresTime}
            c={event.started ? "var(--warning)" : "unset"}
          >
            {event.started ? "---" : <Timer deadline={event.seconds} />}
          </Box>
        </Box>
        <Box className={classes.btnGroup}>
          {!joined && !event.started && (
            <ActionButton
              label={lang.join_event ?? "Join"}
              onClick={() => handleJoin(event)}
              icon={UserPlus}
              color="var(--success)"
            />
          )}
          {joined && !event.started && (
            <ActionButton
              label={lang.checkin ?? "Check-in"}
              onClick={() => handleCheckin(event.identifier)}
              icon={CheckSquare}
              color="var(--accent)"
            />
          )}
          <ActionButton
            label={lang.details ?? "Details"}
            onClick={() => handleDetails(event, joined)}
            icon={FileText}
            color="var(--text-main)"
          />
          {!event.started && (
            <ActionButton
              label={lang.route ?? "Route"}
              onClick={() => handleRoute(event, joined)}
              icon={MapPin}
              color="var(--text-dim)"
            />
          )}
          {joined && (
            <>
              <ActionButton
                label={lang.chat ?? "Chat"}
                onClick={() => handleChat(event.identifier)}
                icon={MessageSquare}
                color="var(--text-main)"
              />
              <ActionButton
                label={lang.quit_event ?? "Quit"}
                onClick={() => handleQuit(event)}
                icon={UserX}
                color="var(--warning)"
              />
            </>
          )}

          {isHostAdmin && (
            <>
              {!event.started && (
                <ActionButton
                  label={lang.start_race ?? "Start"}
                  onClick={() => handleStart(event)}
                  icon={Play}
                  color="var(--accent)"
                />
              )}
              <ActionButton
                label={lang.delete_event ?? "Delete"}
                onClick={() => handleDelete(event.identifier)}
                icon={Trash}
                danger
                doubleClick
              />
            </>
          )}
        </Box>
      </Box>
    </Box>
  );
};
