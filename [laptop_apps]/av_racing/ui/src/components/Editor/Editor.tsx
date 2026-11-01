import { useEffect, useState } from "react";
import {
  Group,
  Text,
  Box,
  TextInput,
  Textarea,
  Tooltip,
  ScrollArea,
  Select,
  Flex,
} from "@mantine/core";
import {
  Map as IconMapPin,
  Trash as IconTrash,
  Check as IconCheck,
  X as IconX,
  ArrowRightLeft as IconSwitchHorizontal,
} from "lucide-react";
import { fetchNui, isEnvBrowser } from "../../hooks/useNuiEvents";
import { SelectType } from "../../types/types";
import { MapZone } from "../MainApp/Map/Map";
import { ApiTrack } from "../../Api/Track";
import { ApiCategories } from "../../Api/Categories";
import { Loading } from "../Loading";
import { useRecoilState, useRecoilValue } from "recoil";
import { CreatorData, Lang } from "../../reducers/atoms";
import { formatString } from "../../hooks/formatString";
import classes from "./style.module.css";
import global from "../../global.module.css";

const iconStyle = { width: "16px", height: "16px" };

export const Editor = () => {
  const lang: any = useRecoilValue(Lang);
  const [isNew, setIsNew] = useState(false);
  const [track, setTrack] = useRecoilState(CreatorData);
  const [errorType, setErrorType] = useState("");
  const [categories, setCategories] = useState<SelectType[]>([]);
  const [loaded, setLoaded] = useState(isEnvBrowser());
  const [selected, setSelected] = useState<null | number>(null);
  const [minRanked, setMinRanked] = useState(50);
  const [allModels, setAllModels] = useState([
    { value: "xm_prop_base_tripod_lampa", label: "xm_prop_base_tripod_lampa" },
    { value: "prop_rub_pile_04", label: "prop_rub_pile_04" },
    { value: "prop_dock_bouy_3", label: "prop_dock_bouy_3" },
    { value: "prop_dock_bouy_2", label: "prop_dock_bouy_2" },
  ]);

  const handleEdits = (field: string, value: any) => {
    setTrack((prev) => ({ ...prev, [field]: value }));
  };

  const handleIndex = (index: number | null) => {
    setSelected(index);
  };

  const handleReplace = (index: number) => {
    fetchNui("av_racing", "replaceCheckpoint", index + 1);
  };

  const handleSave = () => {
    if (!track.name) {
      setErrorType("name");
      setTimeout(() => {
        setErrorType("");
      }, 250);
      return;
    }
    if (!track.type) {
      setErrorType("type");
      setTimeout(() => {
        setErrorType("");
      }, 250);
      return;
    }
    fetchNui("av_racing", "saveTrack", track);
  };

  const handleWaypoint = (index: number) => {
    const checkpoint = track.checkpoints ? track.checkpoints[index] : undefined;
    if (!checkpoint) return;
    fetchNui("av_laptop", "setGPS", {
      x: checkpoint.coords.x,
      y: checkpoint.coords.y,
    });
  };

  const handleDelete = (index: number) => {
    const currentCheckpoints = track.checkpoints || [];
    const newCheckpoints = [...currentCheckpoints];
    newCheckpoints.splice(index, 1);
    setTrack((prevTrack) => ({
      ...prevTrack,
      checkpoints: newCheckpoints,
    }));
    fetchNui("av_racing", "updateCheckpoints", selected);
    setSelected(null);
  };
  const handleModelChange = (modelValue: string | null) => {
    if (selected === null || !track.checkpoints) return;
    const currentCheckpoints = [...track.checkpoints];
    currentCheckpoints[selected] = {
      ...currentCheckpoints[selected],
      model: modelValue || undefined,
    };
    setTrack((prevTrack) => ({
      ...prevTrack,
      checkpoints: currentCheckpoints,
    }));
    fetchNui("av_racing", "replaceModel", {
      index: selected + 1,
      model: modelValue,
    });
  };

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_racing", "getCreator");
      if (resp) {
        setTrack(resp.track ?? ApiTrack);
        setCategories(resp.categories ?? ApiCategories);
        setMinRanked(resp.ranked);
        setIsNew(resp.isNew);
        if (resp.models) setAllModels(resp.models);
      }
      setTimeout(() => {
        setLoaded(true);
      }, 100);
    };
    fetchData();
  }, []);

  return (
    <Box className={classes.container}>
      <Box className={classes.box}>
        {!loaded ? (
          <Loading />
        ) : (
          <>
            <Box className={classes.header}>
              <Text className={classes.title}>
                {lang.track_editor ?? "TRACK EDITOR"}
              </Text>
              <Group gap="sm">
                <Tooltip
                  label={lang.dclick_to_cancel ?? "Double click to cancel"}
                  color="var(--tooltip)"
                  fz="xs"
                  withArrow
                >
                  <button
                    className={classes.cancelBtn}
                    onDoubleClick={() => {
                      fetchNui("av_racing", "cancelProcess");
                    }}
                  >
                    {lang.cancel_process ?? "CANCEL"}
                  </button>
                </Tooltip>
                <button
                  className={classes.outlineBtn}
                  onClick={() => {
                    fetchNui("av_racing", "toggleEditor", track);
                  }}
                >
                  {lang.hide_menu ?? "HIDE MENU"}
                </button>
                <button className={classes.submitBtn} onClick={handleSave}>
                  {lang.save_changes ?? "SAVE CHANGES"}
                </button>
              </Group>
            </Box>
            <Flex className={classes.contentArea}>
              <Box className={classes.leftColumn}>
                <ScrollArea
                  h="100%"
                  type="hover"
                  offsetScrollbars
                  scrollbarSize={4}
                >
                  <Flex direction="column" gap="md" pr="xs">
                    <TextInput
                      classNames={global}
                      label={lang.track_name ?? "Name"}
                      value={track?.name}
                      placeholder="My awesome circuit"
                      size="sm"
                      disabled={!isNew}
                      maxLength={25}
                      error={errorType == "name"}
                      styles={{
                        input: {
                          borderColor:
                            errorType == "name" ? "var(--danger)" : undefined,
                        },
                      }}
                      onChange={(e) => {
                        handleEdits("name", e.currentTarget.value);
                      }}
                    />
                    <Textarea
                      classNames={global}
                      label={lang.description ?? "Description"}
                      value={track?.description}
                      placeholder={
                        lang.short_description ?? "Short description..."
                      }
                      size="sm"
                      maxLength={50}
                      onChange={(e) => {
                        handleEdits("description", e.currentTarget.value);
                      }}
                    />
                    <Select
                      classNames={global}
                      value={track.type ?? categories[0]?.value}
                      label={lang.type ?? "Type"}
                      data={categories}
                      error={errorType == "type"}
                      styles={{
                        input: {
                          borderColor:
                            errorType == "type" ? "var(--danger)" : undefined,
                        },
                      }}
                      onChange={(e) => {
                        if (!e) return;
                        handleEdits("type", e);
                      }}
                    />
                    <Box className={classes.infoCard}>
                      <Flex justify="space-between" align="center">
                        <Text className={classes.infoLabel}>
                          {lang.ranked_ready ?? "RANKED READY"}
                        </Text>
                        <Group gap={6}>
                          {track?.checkpoints &&
                          track.checkpoints.length > minRanked ? (
                            <IconCheck size={16} color="var(--success)" />
                          ) : (
                            <IconX size={16} color="var(--danger)" />
                          )}
                        </Group>
                      </Flex>
                      <Text fz="12px" c="var(--text-dim)">
                        {formatString(
                          lang.ranked_requeriment,
                          String(minRanked),
                        )}
                      </Text>
                    </Box>
                    <Box className={classes.infoCard}>
                      <Flex justify="space-between" align="center">
                        <Box>
                          <Text className={classes.infoLabel}>
                            {lang.checkpoint ?? "CHECKPOINT"}
                          </Text>
                          <Text className={classes.infoValue}>
                            {selected !== null
                              ? `#${selected + 1}`
                              : (lang.checkpoint_placeholder ??
                                "None Selected")}
                          </Text>
                        </Box>
                        {selected !== null && (
                          <Box className={classes.checkpointActions}>
                            <Tooltip
                              label={lang.set_waypoint ?? "Set Waypoint"}
                              color="var(--tooltip)"
                              fz="xs"
                              withArrow
                            >
                              <button
                                className={`${classes.actionBtn} ${classes.actionBtnPrimary}`}
                                onClick={() => handleWaypoint(selected)}
                              >
                                <IconMapPin style={iconStyle} />
                              </button>
                            </Tooltip>
                            <Tooltip
                              label={lang.replace_checkpoint ?? "Replace"}
                              color="var(--tooltip)"
                              fz="xs"
                              withArrow
                            >
                              <button
                                className={`${classes.actionBtn} ${classes.actionBtnWarning}`}
                                onClick={() => handleReplace(selected)}
                              >
                                <IconSwitchHorizontal style={iconStyle} />
                              </button>
                            </Tooltip>
                            <Tooltip
                              label={
                                lang.delete_checkpoint ??
                                "Delete (Double Click)"
                              }
                              color="var(--tooltip)"
                              fz="xs"
                              withArrow
                            >
                              <button
                                className={`${classes.actionBtn} ${classes.actionBtnDanger}`}
                                onDoubleClick={() => handleDelete(selected)}
                              >
                                <IconTrash style={iconStyle} />
                              </button>
                            </Tooltip>
                          </Box>
                        )}
                      </Flex>
                      {selected !== null && track?.checkpoints?.[selected] && (
                        <Box
                          mt="xs"
                          pt="xs"
                          style={{ borderTop: "1px solid var(--border-color)" }}
                        >
                          <Select
                            classNames={global}
                            size="xs"
                            label="Custom Model"
                            placeholder="Default Model"
                            clearable
                            searchable
                            data={allModels}
                            value={
                              String(track.checkpoints[selected].model) || null
                            }
                            onChange={handleModelChange}
                            styles={{
                              input: {
                                backgroundColor: "var(--bg-main)",
                                borderColor: "var(--border-color)",
                                color: "var(--text-main)",
                              },
                              label: {
                                color: "var(--text-dim)",
                                fontSize: "10px",
                                fontWeight: 700,
                                textTransform: "uppercase",
                                marginBottom: "4px",
                                letterSpacing: "0.5px",
                              },
                            }}
                          />
                        </Box>
                      )}
                    </Box>
                  </Flex>
                </ScrollArea>
              </Box>
              <Box className={classes.mapColumn}>
                <MapZone
                  checkpoints={track?.checkpoints ?? []}
                  handleIndex={handleIndex}
                />
              </Box>
            </Flex>
          </>
        )}
      </Box>
    </Box>
  );
};
