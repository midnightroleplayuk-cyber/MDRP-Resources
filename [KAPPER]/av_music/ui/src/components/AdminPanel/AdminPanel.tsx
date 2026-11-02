import { useState, useCallback, useEffect, useRef } from "react";
import { Box, Text, Loader, SegmentedControl } from "@mantine/core";
import {
  X,
  Trash2,
  RefreshCw,
  Plus,
  MapPinPlus,
  Radio,
  MapPin,
  Building2,
  Pencil,
} from "lucide-react";
import { useAtom, useAtomValue } from "jotai";
import { adminOpenAtom, Lang } from "../../reducers/atoms";
import { useNuiEvent, fetchNui, isEnvBrowser } from "../../hooks/useNuiEvents";
import classes from "./style.module.css";

interface LiveEntry {
  src: number;
  playerName: string;
  name: string;
  url: string;
}

interface ZoneEntry {
  id: string;
  label: string;
  allowedJob: string;
  radius: number;
  volume: number;
  muffle?: boolean;
}

interface JobEntry {
  label: string;
  value: string;
}

interface WhitelistEntry {
  identifier: string;
  label: string;
}

const DEFAULT_WL_FORM = { identifier: "", label: "" };

const DEFAULT_FORM = {
  label: "",
  allowedJob: "",
  volume: 75,
  radius: 20,
  muffle: false,
};

export const AdminPanel = () => {
  const [open, setOpen] = useAtom(adminOpenAtom);
  const lang: any = useAtomValue(Lang);
  const [tab, setTab] = useState("lives");
  const standaloneRef = useRef(false);
  const [lives, setLives] = useState<LiveEntry[]>([]);
  const [livesLoading, setLivesLoading] = useState(false);
  const [whitelist, setWhitelist] = useState<WhitelistEntry[]>([]);
  const [wlLoading, setWlLoading] = useState(false);
  const [showWlForm, setShowWlForm] = useState(false);
  const [wlForm, setWlForm] = useState({ ...DEFAULT_WL_FORM });
  const [livesSubTab, setLivesSubTab] = useState<"streams" | "whitelist">(
    "streams",
  );
  const [zones, setZones] = useState<ZoneEntry[]>([]);
  const [zonesLoading, setZonesLoading] = useState(false);
  const [jobs, setJobs] = useState<JobEntry[]>([]);
  const [showForm, setShowForm] = useState(false);
  const [placing, setPlacing] = useState(false);
  const [panelOpacity, setPanelOpacity] = useState(1);
  const [form, setForm] = useState({ ...DEFAULT_FORM });
  const [editingZone, setEditingZone] = useState<ZoneEntry | null>(null);
  const [editForm, setEditForm] = useState({ ...DEFAULT_FORM });

  const fetchLives = useCallback(async () => {
    setLivesLoading(true);
    try {
      if (isEnvBrowser()) {
        setLives([
          {
            src: 1,
            playerName: "Pedro_Gomez",
            name: "Lofi Radio",
            url: "https://youtube.com/watch?v=abc",
          },
          {
            src: 2,
            playerName: "Maria_Lopez",
            name: "Trap Station",
            url: "https://youtube.com/watch?v=xyz",
          },
        ]);
        return;
      }
      const result = await fetchNui<LiveEntry[]>(
        "av_music",
        "adminGetLives",
        {},
      );
      setLives(result ?? []);
    } finally {
      setLivesLoading(false);
    }
  }, []);

  const fetchZones = useCallback(async () => {
    setZonesLoading(true);
    try {
      if (isEnvBrowser()) {
        setZones([
          {
            id: "abc123def456",
            label: "Club Maze",
            allowedJob: "police",
            radius: 25,
            volume: 0.75,
          },
          {
            id: "xyz789uvw012",
            label: "Restaurant Row",
            allowedJob: "",
            radius: 15,
            volume: 0.5,
          },
        ]);
        setJobs([
          { label: "Police", value: "police" },
          { label: "Ambulance", value: "ambulance" },
        ]);
        return;
      }
      const [z, j] = await Promise.all([
        fetchNui<ZoneEntry[]>("av_music", "adminGetZones", {}),
        fetchNui<JobEntry[]>("av_music", "adminGetJobs", {}),
      ]);
      setZones(z ?? []);
      setJobs(j ?? []);
    } finally {
      setZonesLoading(false);
    }
  }, []);

  const fetchWhitelist = useCallback(async () => {
    setWlLoading(true);
    try {
      if (isEnvBrowser()) {
        setWhitelist([{ identifier: "char1:abc123", label: "Test Player" }]);
        return;
      }
      const result = await fetchNui<WhitelistEntry[]>(
        "av_music",
        "adminGetLiveWhitelist",
        {},
      );
      setWhitelist(result ?? []);
    } finally {
      setWlLoading(false);
    }
  }, []);

  const close = useCallback(async () => {
    setOpen(false);
    setShowForm(false);
    setPlacing(false);
    await fetchNui("av_music", "adminClose", {
      standalone: standaloneRef.current,
    });
  }, [setOpen]);

  useNuiEvent<{ tab?: string; standalone?: boolean }>(
    "adminOpen",
    useCallback(
      (data) => {
        setOpen(true);
        setTab(data?.tab ?? "lives");
        standaloneRef.current = data?.standalone ?? false;
      },
      [setOpen],
    ),
  );

  useNuiEvent<{ opacity: number }>(
    "adminOpacity",
    useCallback((data) => {
      setPanelOpacity(data?.opacity ?? 1);
    }, []),
  );

  useNuiEvent<{ zone?: ZoneEntry; cancelled?: boolean }>(
    "adminZonePlaced",
    useCallback(
      (data) => {
        setPlacing(false);
        if (data?.zone) {
          setShowForm(false);
          setForm({ ...DEFAULT_FORM });
          fetchZones();
        }
      },
      [fetchZones],
    ),
  );

  useEffect(() => {
    if (!open) return;
    if (tab === "lives") {
      fetchLives();
      fetchWhitelist();
      setLivesSubTab("streams");
    } else fetchZones();
  }, [open, tab]);

  const handleKill = async (src: number) => {
    await fetchNui("av_music", "adminKillLive", { src });
    setLives((prev) => prev.filter((l) => l.src !== src));
  };

  const handleDeleteZone = async (id: string) => {
    await fetchNui("av_music", "adminDeleteZone", { id });
    setZones((prev) => prev.filter((z) => z.id !== id));
  };

  const handleAddWhitelist = async () => {
    if (!wlForm.identifier.trim()) return;
    await fetchNui("av_music", "adminAddLiveWhitelist", {
      identifier: wlForm.identifier.trim(),
      label: wlForm.label.trim() || wlForm.identifier.trim(),
    });
    setWlForm({ ...DEFAULT_WL_FORM });
    setShowWlForm(false);
    fetchWhitelist();
  };

  const handleRemoveWhitelist = async (identifier: string) => {
    await fetchNui("av_music", "adminRemoveLiveWhitelist", { identifier });
    setWhitelist((prev) => prev.filter((e) => e.identifier !== identifier));
  };

  const handleEditZone = (zone: ZoneEntry) => {
    setEditingZone(zone);
    setEditForm({
      label: zone.label,
      allowedJob: zone.allowedJob || "",
      volume: Math.round((zone.volume ?? 0) * 100),
      radius: zone.radius,
      muffle: zone.muffle ?? false,
    });
    setShowForm(false);
    setPlacing(false);
  };

  const handleSaveEdit = async () => {
    if (!editingZone) return;
    const res = await fetchNui<{ ok: boolean; zone: ZoneEntry }>(
      "av_music",
      "adminUpdateZone",
      {
        id: editingZone.id,
        label: editForm.label,
        allowedJob: editForm.allowedJob,
        volume: editForm.volume / 100,
        radius: editForm.radius,
        muffle: editForm.muffle,
      },
    );
    if (res?.ok && res?.zone) {
      setZones((prev) =>
        prev.map((z) => (z.id === res.zone.id ? res.zone : z)),
      );
      setEditingZone(null);
    }
  };

  const handleStartPlacement = () => {
    if (!form.label.trim() || placing) return;
    setPlacing(true);
    fetchNui("av_music", "adminStartPolyZone", {
      ...form,
      standalone: standaloneRef.current,
    });
  };

  useEffect(() => {
    if (!open) return;
    const onKey = (e: KeyboardEvent) => {
      if (e.key === "Escape") close();
    };
    window.addEventListener("keydown", onKey);
    return () => window.removeEventListener("keydown", onKey);
  }, [open, close]);

  if (!open) return null;

  const canPlace = form.label.trim().length > 0 && !placing;

  return (
    <Box className={classes.wrapper}>
      <Box
        className={classes.panel}
        style={{ opacity: panelOpacity, transition: "opacity 0.25s ease" }}
      >
        <Box className={classes.navbar}>
          <Text className={classes.brand}>AV Music</Text>
          <Text className={classes.brandSub}>
            {lang["admin_title"] ?? "Admin Panel"}
          </Text>
          <Box className={classes.navSpacer} />
          <Box className={classes.navTabs}>
            <button
              className={`${classes.navTab} ${tab === "lives" ? classes.navTabActive : ""}`}
              onClick={() => setTab("lives")}
            >
              {lang["admin_tab_lives"] ?? "Lives"}
            </button>
            <button
              className={`${classes.navTab} ${tab === "zones" ? classes.navTabActive : ""}`}
              onClick={() => setTab("zones")}
            >
              {lang["admin_tab_zones"] ?? "Zones"}
            </button>
          </Box>
          <button className={classes.closeBtn} onClick={close}>
            <X size={15} />
          </button>
        </Box>
        {tab === "lives" ? (
          <>
            <Box className={classes.segmentedWrap}>
              <SegmentedControl
                value={livesSubTab}
                onChange={(v) => setLivesSubTab(v as "streams" | "whitelist")}
                data={[
                  {
                    label: lang["admin_seg_streams"] ?? "Live Streams",
                    value: "streams",
                  },
                  {
                    label: lang["admin_seg_whitelist"] ?? "Radio Whitelist",
                    value: "whitelist",
                  },
                ]}
                classNames={{
                  root: classes.segRoot,
                  indicator: classes.segIndicator,
                  label: classes.segLabel,
                }}
              />
            </Box>

            {livesSubTab === "streams" ? (
              <>
                <Box className={classes.contentHeader}>
                  <Text className={classes.contentDesc}>
                    {lang["admin_lives_desc_short"] ??
                      "Monitor and moderate active live streams."}
                  </Text>
                  <Box className={classes.contentActions}>
                    <button className={classes.refreshBtn} onClick={fetchLives}>
                      <RefreshCw size={11} />
                      {lang["admin_refresh"] ?? "Refresh"}
                    </button>
                  </Box>
                </Box>
                <Box className={`${classes.tableHead} ${classes.livesGrid}`}>
                  <Text className={classes.thCell}>
                    {lang["admin_col_player"] ?? "Player"}
                  </Text>
                  <Text className={classes.thCell}>
                    {lang["admin_col_stream"] ?? "Stream"}
                  </Text>
                  <Text className={classes.thCell}>
                    {lang["admin_col_url"] ?? "URL"}
                  </Text>
                  <Text className={classes.thCell}>
                    {lang["admin_col_actions"] ?? "Actions"}
                  </Text>
                </Box>
                <Box className={classes.tableWrap}>
                  {livesLoading ? (
                    <Box className={classes.centerBox}>
                      <Loader size="sm" color="gray" />
                    </Box>
                  ) : lives.length === 0 ? (
                    <Box className={classes.centerBox}>
                      <Radio size={26} />
                      <Text className={classes.emptyText}>
                        {lang["admin_no_lives"] ?? "No active live streams"}
                      </Text>
                    </Box>
                  ) : (
                    lives.map((live) => (
                      <Box
                        key={live.src}
                        className={`${classes.tableRow} ${classes.livesGrid}`}
                      >
                        <Text className={classes.tdCell}>
                          {live.playerName}
                        </Text>
                        <Text className={classes.tdCell}>{live.name}</Text>
                        <Text
                          className={`${classes.tdCell} ${classes.tdMuted}`}
                        >
                          {live.url}
                        </Text>
                        <button
                          className={classes.killBtn}
                          onClick={() => handleKill(live.src)}
                        >
                          {lang["admin_kill"] ?? "Kill"}
                        </button>
                      </Box>
                    ))
                  )}
                </Box>
              </>
            ) : (
              <>
                <Box className={classes.contentHeader}>
                  <Text className={classes.contentDesc}>
                    {lang["admin_wl_desc"] ??
                      "Players allowed to publish live radio stations."}
                  </Text>
                  <Box className={classes.contentActions}>
                    <button
                      className={classes.refreshBtn}
                      onClick={fetchWhitelist}
                    >
                      <RefreshCw size={11} />
                      {lang["admin_refresh"] ?? "Refresh"}
                    </button>
                    <button
                      className={classes.addBtn}
                      onClick={() => {
                        setShowWlForm((s) => !s);
                        setWlForm({ ...DEFAULT_WL_FORM });
                      }}
                    >
                      <Plus size={13} />
                      {showWlForm
                        ? (lang["admin_cancel"] ?? "Cancel")
                        : (lang["admin_wl_add"] ?? "Add Player")}
                    </button>
                  </Box>
                </Box>
                {showWlForm && (
                  <Box className={classes.inlineForm}>
                    <Box className={classes.formField}>
                      <Text className={classes.formLabel}>
                        {lang["admin_wl_identifier_label"] ?? "IDENTIFIER"}
                      </Text>
                      <input
                        className={classes.formInput}
                        placeholder={
                          lang["admin_wl_identifier_ph"] ?? "citizen:abc123..."
                        }
                        value={wlForm.identifier}
                        onChange={(e) =>
                          setWlForm((f) => ({
                            ...f,
                            identifier: e.target.value,
                          }))
                        }
                      />
                    </Box>
                    <Box className={classes.formField}>
                      <Text className={classes.formLabel}>
                        {lang["admin_wl_label_label"] ?? "LABEL"}
                      </Text>
                      <input
                        className={classes.formInput}
                        placeholder={
                          lang["admin_wl_label_ph"] ?? "Player name / note"
                        }
                        value={wlForm.label}
                        onChange={(e) =>
                          setWlForm((f) => ({ ...f, label: e.target.value }))
                        }
                      />
                    </Box>
                    <button
                      className={classes.placeBtn}
                      disabled={!wlForm.identifier.trim()}
                      onClick={handleAddWhitelist}
                    >
                      <Plus size={13} />
                      {lang["admin_add"] ?? "Add"}
                    </button>
                  </Box>
                )}
                <Box className={classes.tableWrap}>
                  {wlLoading ? (
                    <Box className={classes.centerBox}>
                      <Loader size="sm" color="gray" />
                    </Box>
                  ) : whitelist.length === 0 ? (
                    <Box className={classes.centerBox}>
                      <Text className={classes.emptyText}>
                        {lang["admin_wl_no_entries"] ??
                          "No players whitelisted yet."}
                      </Text>
                    </Box>
                  ) : (
                    <Box px="xs" mt="xs">
                      {whitelist.map((e) => (
                        <Box key={e.identifier} className={classes.wlRow}>
                          <Box className={classes.wlRowInfo}>
                            <Text className={classes.wlRowLabel}>
                              {e.label}
                            </Text>
                            <Text className={classes.wlRowId}>
                              {e.identifier}
                            </Text>
                          </Box>
                          <button
                            className={classes.iconBtn}
                            onClick={() => handleRemoveWhitelist(e.identifier)}
                          >
                            <Trash2 size={13} />
                          </button>
                        </Box>
                      ))}
                    </Box>
                  )}
                </Box>
              </>
            )}
          </>
        ) : (
          <>
            <Box className={classes.contentHeader}>
              <Text className={classes.contentDesc}>
                {lang["admin_zones_desc"] ??
                  "Create restricted-access zones tied to player jobs."}
              </Text>
              <Box className={classes.contentActions}>
                <button className={classes.refreshBtn} onClick={fetchZones}>
                  <RefreshCw size={11} />
                  {lang["admin_refresh"] ?? "Refresh"}
                </button>
                <button
                  className={classes.addBtn}
                  onClick={() => {
                    setShowForm((s) => !s);
                    setForm({ ...DEFAULT_FORM });
                  }}
                >
                  <Plus size={13} />
                  {showForm
                    ? (lang["admin_cancel"] ?? "Cancel")
                    : (lang["admin_add_zone"] ?? "Add Zone")}
                </button>
              </Box>
            </Box>
            {editingZone && (
              <Box className={classes.inlineForm}>
                <Box className={classes.formFields}>
                  <Box className={classes.formField}>
                    <Text className={classes.formLabel}>
                      {lang["admin_form_label"] ?? "Label"}
                    </Text>
                    <input
                      className={classes.formInput}
                      value={editForm.label}
                      onChange={(e) =>
                        setEditForm((f) => ({ ...f, label: e.target.value }))
                      }
                    />
                  </Box>
                  <Box className={classes.formField}>
                    <Text className={classes.formLabel}>
                      {lang["admin_form_job"] ?? "Required Job"}
                    </Text>
                    <select
                      className={classes.formSelect}
                      value={editForm.allowedJob}
                      onChange={(e) =>
                        setEditForm((f) => ({
                          ...f,
                          allowedJob: e.target.value,
                        }))
                      }
                    >
                      <option value="">
                        {lang["admin_form_job_all"] ?? "All players"}
                      </option>
                      {jobs.map((j) => (
                        <option key={j.value} value={j.value}>
                          {j.label}
                        </option>
                      ))}
                    </select>
                  </Box>
                  <Box className={classes.formField}>
                    <Text className={classes.formLabel}>
                      {lang["admin_form_volume"] ?? "Volume (%)"}
                    </Text>
                    <input
                      type="number"
                      min={10}
                      max={100}
                      className={classes.formInput}
                      value={editForm.volume}
                      onChange={(e) =>
                        setEditForm((f) => ({
                          ...f,
                          volume: Number(e.target.value),
                        }))
                      }
                    />
                  </Box>
                  <Box className={classes.formField}>
                    <Text className={classes.formLabel}>
                      {lang["admin_form_radius"] ?? "Radius (m)"}
                    </Text>
                    <input
                      type="number"
                      min={5}
                      max={300}
                      className={classes.formInput}
                      value={editForm.radius}
                      onChange={(e) =>
                        setEditForm((f) => ({
                          ...f,
                          radius: Number(e.target.value),
                        }))
                      }
                    />
                  </Box>
                  <Box className={classes.formField}>
                    <Text className={classes.formLabel}>
                      {lang["admin_form_muffle_short"] ?? "Indoor"}
                    </Text>
                    <select
                      className={classes.formSelect}
                      value={editForm.muffle ? "yes" : "no"}
                      onChange={(e) =>
                        setEditForm((f) => ({
                          ...f,
                          muffle: e.target.value === "yes",
                        }))
                      }
                    >
                      <option value="no">
                        {lang["admin_form_muffle_no"] ?? "No"}
                      </option>
                      <option value="yes">
                        {lang["admin_form_muffle_yes"] ?? "Yes"}
                      </option>
                    </select>
                  </Box>
                </Box>
                <Box className={classes.placeBtnRow} style={{ gap: 8 }}>
                  <button
                    className={classes.cancelEditBtn}
                    onClick={() => setEditingZone(null)}
                  >
                    {lang["admin_cancel"] ?? "Cancel"}
                  </button>
                  <button
                    className={classes.placeBtn}
                    disabled={!editForm.label.trim()}
                    onClick={handleSaveEdit}
                  >
                    {lang["admin_save_changes"] ?? "Save Changes"}
                  </button>
                </Box>
              </Box>
            )}
            {showForm && (
              <Box className={classes.inlineForm}>
                <Box className={classes.formFields}>
                  <Box className={classes.formField}>
                    <Text className={classes.formLabel}>
                      {lang["admin_form_label"] ?? "Label"}
                    </Text>
                    <input
                      className={classes.formInput}
                      placeholder="Club Maze, Restaurant..."
                      value={form.label}
                      onChange={(e) =>
                        setForm((f) => ({ ...f, label: e.target.value }))
                      }
                    />
                  </Box>
                  <Box className={classes.formField}>
                    <Text className={classes.formLabel}>
                      {lang["admin_form_job"] ?? "Required Job"}
                    </Text>
                    <select
                      className={classes.formSelect}
                      value={form.allowedJob}
                      onChange={(e) =>
                        setForm((f) => ({ ...f, allowedJob: e.target.value }))
                      }
                    >
                      <option value="">
                        {lang["admin_form_job_all"] ?? "All players"}
                      </option>
                      {jobs.map((j) => (
                        <option key={j.value} value={j.value}>
                          {j.label}
                        </option>
                      ))}
                    </select>
                  </Box>
                  <Box className={classes.formField}>
                    <Text className={classes.formLabel}>
                      {lang["admin_form_volume"] ?? "Volume (%)"}
                    </Text>
                    <input
                      type="number"
                      min={10}
                      max={100}
                      className={classes.formInput}
                      value={form.volume}
                      onChange={(e) =>
                        setForm((f) => ({
                          ...f,
                          volume: Number(e.target.value),
                        }))
                      }
                    />
                  </Box>
                  <Box className={classes.formField}>
                    <Text className={classes.formLabel}>
                      {lang["admin_form_radius"] ?? "Radius (m)"}
                    </Text>
                    <input
                      type="number"
                      min={5}
                      max={300}
                      className={classes.formInput}
                      value={form.radius}
                      onChange={(e) =>
                        setForm((f) => ({
                          ...f,
                          radius: Number(e.target.value),
                        }))
                      }
                    />
                  </Box>
                  <Box className={classes.formField}>
                    <Text className={classes.formLabel}>
                      {lang["admin_form_muffle_short"] ?? "Indoor"}
                    </Text>
                    <select
                      className={classes.formSelect}
                      value={form.muffle ? "yes" : "no"}
                      onChange={(e) =>
                        setForm((f) => ({
                          ...f,
                          muffle: e.target.value === "yes",
                        }))
                      }
                    >
                      <option value="no">
                        {lang["admin_form_muffle_no"] ?? "No"}
                      </option>
                      <option value="yes">
                        {lang["admin_form_muffle_yes"] ?? "Yes"}
                      </option>
                    </select>
                  </Box>
                </Box>
                <Box className={classes.placeBtnRow}>
                  <button
                    className={classes.placeBtn}
                    disabled={!canPlace}
                    onClick={handleStartPlacement}
                  >
                    <MapPinPlus size={13} />
                    {placing
                      ? (lang["admin_placing"] ?? "Placing...")
                      : (lang["admin_start_placement"] ?? "Start Placement")}
                  </button>
                </Box>
              </Box>
            )}
            <Box className={`${classes.tableHead} ${classes.zonesGrid}`}>
              <Text className={classes.thCell}>
                {lang["admin_col_label"] ?? "Label"}
              </Text>
              <Text className={classes.thCell}>
                {lang["admin_col_id"] ?? "Identifier"}
              </Text>
              <Text className={classes.thCell}>
                {lang["admin_col_job"] ?? "Job"}
              </Text>
              <Text className={classes.thCell}>
                {lang["admin_col_volume"] ?? "Volume"}
            
              </Text>
              <Text className={classes.thCell}>
                {lang["admin_col_actions"] ?? "Actions"}
              </Text>
            </Box>
            <Box className={classes.tableWrap}>
              {zonesLoading ? (
                <Box className={classes.centerBox}>
                  <Loader size="sm" color="gray" />
                </Box>
              ) : zones.length === 0 ? (
                <Box className={classes.centerBox}>
                  <MapPin size={26} />
                  <Text className={classes.emptyText}>
                    {lang["admin_no_zones"] ?? "No zones configured yet."}
                  </Text>
                </Box>
              ) : (
                zones.map((zone) => (
                  <Box
                    key={zone.id}
                    className={`${classes.tableRow} ${classes.zonesGrid}`}
                  >
                    <Text className={classes.tdCell}>{zone.label}</Text>
                    <Text className={`${classes.tdCell} ${classes.tdMuted}`}>
                      {zone.id}
                    </Text>
                    <Text className={classes.tdCell}>
                      {zone.allowedJob || "—"}
                    </Text>
                    <Text className={classes.tdCell}>
                      {Math.round((zone.volume ?? 0) * 100)}%
                    </Text>
                    <Box
                      className={classes.tdCell}
                      style={{ display: "flex", gap: 6 }}
                    >
                      <button
                        className={classes.iconBtn}
                        onClick={() => handleEditZone(zone)}
                        title={lang["admin_edit"] ?? "Edit"}
                      >
                        <Pencil size={12} />
                      </button>
                      <button
                        className={classes.killBtn}
                        onClick={() => handleDeleteZone(zone.id)}
                        title={lang["admin_delete"] ?? "Delete"}
                      >
                        <Trash2 size={12} />
                      </button>
                    </Box>
                  </Box>
                ))
              )}
            </Box>
          </>
        )}
      </Box>
    </Box>
  );
};
