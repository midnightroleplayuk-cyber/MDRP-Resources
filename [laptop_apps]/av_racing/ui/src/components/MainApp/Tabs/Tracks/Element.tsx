import { Box, Group, Tooltip, Flex } from "@mantine/core";
import {
  Star,
  Route,
  MapPin,
  FileText,
  Play,
  Edit,
  Trophy,
} from "lucide-react";
import { TrackType } from "../../../../types/types";
import { useCallback, useMemo } from "react";
import { fetchNui } from "../../../../hooks/useNuiEvents";
import classes from "./style.module.css";

const ActionButton = ({
  label,
  onClick,
  icon: Icon,
  color = "var(--text-dim)",
}: {
  label: string;
  onClick: () => void;
  icon: React.ElementType;
  color?: string;
}) => (
  <Tooltip label={label} color="var(--tooltip)" fz="xs" withArrow>
    <button className={classes.actionBtn} onClick={onClick} style={{ color }}>
      <Icon size={16} />
    </button>
  </Tooltip>
);

interface Properties {
  lang: any;
  track: TrackType;
  handleFavorite: (identifier: string) => void;
  handleDetails: (identifier: string, edit?: boolean) => void;
  isFav: boolean;
  createEvents: boolean;
  editTracks: boolean;
  handleEvent: (track: string) => void;
}

export const Element = ({
  lang,
  track,
  handleFavorite,
  isFav,
  createEvents,
  editTracks,
  handleDetails,
  handleEvent,
}: Properties) => {
  const handleFavoriteClick = useCallback(() => {
    handleFavorite(track.identifier);
  }, [handleFavorite, track.identifier]);

  const actionButtons = useMemo(
    () => [
      {
        label: lang.details || "Details",
        icon: FileText,
        color: "var(--text-main)",
        onClick: () => {
          handleDetails(track.identifier);
        },
      },
      {
        label: lang.create_event || "Create Event",
        icon: Play,
        color: "var(--accent)",
        onClick: () => {
          handleEvent(track.identifier);
        },
        disabled: !createEvents,
      },
      {
        label: lang.edit_track || "Edit Track",
        icon: Edit,
        color: "var(--text-dim)",
        onClick: () => {
          fetchNui("av_racing", "editCircuit", track.identifier);
        },
        disabled: !editTracks,
      },
    ],
    [
      lang,
      createEvents,
      editTracks,
      handleDetails,
      handleEvent,
      track.identifier,
    ],
  );

  return (
    <Box className={classes.card}>
      <Box className={classes.cardHeader}>
        <Flex direction="column">
          <Tooltip label={track.name} color="var(--tooltip)" fz="xs" withArrow>
            <h3 className={classes.cardTitle}>{track.name}</h3>
          </Tooltip>
          <Tooltip
            label={track.description}
            color="var(--tooltip)"
            fz="xs"
            withArrow
          >
            <p className={classes.cardDesc}>{track.description}</p>
          </Tooltip>
        </Flex>
        <Group gap="xs" wrap="nowrap">
          <div className={classes.badge}>{track.type}</div>
          <button
            className={classes.actionBtn}
            onClick={handleFavoriteClick}
            style={{ padding: 2 }}
          >
            <Star
              size={16}
              color={isFav ? "var(--warning)" : "var(--text-dim)"}
              fill={isFav ? "var(--warning)" : "transparent"}
            />
          </button>
        </Group>
      </Box>

      <Box className={classes.cardFooter}>
        <div className={classes.statGroup}>
          <Tooltip
            label={lang.distance}
            color="var(--tooltip)"
            fz="xs"
            withArrow
          >
            <div className={classes.statItem}>
              <Route size={14} color="var(--accent)" />
              <span>{`${track?.distance ?? 0} ${lang.distance_unit}`}</span>
            </div>
          </Tooltip>

          <Tooltip
            label={lang.checkpoints}
            color="var(--tooltip)"
            fz="xs"
            withArrow
          >
            <div className={classes.statItem}>
              <MapPin size={14} color="var(--accent)" />
              <span>{track.checkpointTotal ?? 0}</span>
            </div>
          </Tooltip>

          {track.isRanked && (
            <Tooltip
              label={lang.ranked}
              color="var(--tooltip)"
              fz="xs"
              withArrow
            >
              <div className={classes.statItem}>
                <Trophy size={14} color="var(--warning)" />
              </div>
            </Tooltip>
          )}
        </div>

        <div className={classes.btnGroup}>
          {actionButtons.map(
            ({ label, onClick, icon, color, disabled }) =>
              !disabled && (
                <ActionButton
                  key={label}
                  label={label}
                  onClick={onClick}
                  icon={icon}
                  color={color}
                />
              ),
          )}
        </div>
      </Box>
    </Box>
  );
};
