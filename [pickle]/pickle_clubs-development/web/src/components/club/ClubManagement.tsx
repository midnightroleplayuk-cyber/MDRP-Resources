import { useCallback, useEffect, useMemo, useRef, useState } from "react";
import { AppControls } from "../../App";
import { fetchNui } from "../../providers/nui/fetchNui";
import { useNuiEvent } from "../../providers/nui/useNui";
import { Button } from "../ui/button";
import { useLocale } from "../../providers/locale/Locale";
import { MapPin, Move, Navigation } from "lucide-react";

type Vec3 = { x: number; y: number; z: number };
type ViewMode = "clubsRoot" | "clubDetail" | "entityDetail";

type ClubJob = { name: string; primary: boolean };

type BartenderEntity = {
  type: "bartender";
  bartender: {
    coords?: Vec3;
    heading?: number;
    blip?: {
      name?: string;
      color?: number;
      sprite?: number;
      scale?: number;
      visible?: boolean;
    };
  };
};

type BouncerEntity = {
  type: "bouncer";
  bouncer: {
    ped: string;
    coords?: Vec3;
    heading?: number;
    vipMode?: boolean;
  };
};

type ClubEntryEntity = {
  type: "club_entry";
  bouncer: {
    ped: string;
    coords?: Vec3;
    heading?: number;
  };
  eject: {
    coords?: Vec3;
    heading?: number;
  };
};

type SocietyEntity = {
  type: "society";
  society: {
    coords?: Vec3;
    heading?: number;
  };
};

type ClubEntity = BartenderEntity | BouncerEntity | ClubEntryEntity | SocietyEntity | Record<string, unknown>;

type DrinkMenuItem = { name: string; flavors: string[]; alcohol: number; price: number; item: string };
type DrinkMenu = Record<string, DrinkMenuItem>;
type ClubFlavor = { label: string; color: [number, number, number]; isAlcohol?: boolean };
type FlavorMap = Record<string, ClubFlavor>;
type PedConfig = { model: string };
type PedMap = Record<string, PedConfig>;

interface ClubSummary {
  id: number;
  label: string;
  description?: string;
  coords?: Vec3;
  jobs?: ClubJob[];
  entities?: Record<string, ClubEntity>;
  drink_menu?: DrinkMenu;
  blip?: ClubBlip;
}

interface ClubManagementData {
  clubs?: ClubSummary[];
  flavors?: FlavorMap;
  peds?: PedMap;
  defaultDrinks?: DrinkMenu;
}

interface ClubBlip {
  name: string;
  color: number;
  sprite: number;
  scale: number;
  visible: boolean;
}

interface ClubEditorState {
  label: string;
  description: string;
  coords: Vec3;
  jobs: ClubJob[];
  drink_menu: DrinkMenu;
  blip: ClubBlip;
}

interface EntityEditorState {
  type: "bartender" | "bouncer" | "club_entry" | "society";
  bartender: {
    coords: Vec3;
    heading: number;
  };
  bouncer: {
    ped: string;
    coords: Vec3;
    heading: number;
    vipMode: boolean;
  };
  clubEntry: {
    ped: string;
    bouncerCoords: Vec3;
    bouncerHeading: number;
    ejectCoords: Vec3;
    ejectHeading: number;
  };
  society: {
    coords: Vec3;
    heading: number;
  };
}

const DEFAULT_VEC3: Vec3 = { x: 0, y: 0, z: 0 };

function toVec3(value: unknown, fallback: Vec3 = DEFAULT_VEC3): Vec3 {
  if (!value || typeof value !== "object") return fallback;
  const obj = value as { x?: number; y?: number; z?: number };
  if (typeof obj.x !== "number" || typeof obj.y !== "number" || typeof obj.z !== "number") {
    return fallback;
  }
  return { x: obj.x, y: obj.y, z: obj.z };
}

function formatCoords(coords?: Vec3): string {
  if (!coords) return "—";
  return `(${coords.x.toFixed(2)}, ${coords.y.toFixed(2)}, ${coords.z.toFixed(2)})`;
}

function formatHeading(heading?: number): string {
  if (typeof heading !== "number") return "—";
  return heading.toFixed(2);
}

function normalizeClubs(raw: ClubSummary[]): ClubSummary[] {
  return (raw || []).map((club) => ({
    id: club.id,
    label: club.label || `Club #${club.id}`,
    description: club.description || "",
    coords: toVec3(club.coords, DEFAULT_VEC3),
    jobs: Array.isArray(club.jobs) ? club.jobs : [],
    entities: club.entities || {},
    drink_menu: club.drink_menu && typeof club.drink_menu === "object" ? club.drink_menu : {},
    blip: club.blip,
  }));
}

function createClubDraft(club?: ClubSummary, defaults?: DrinkMenu): ClubEditorState {
  const jobs = Array.isArray(club?.jobs) ? club.jobs : [];
  const hasDrinks = club?.drink_menu && typeof club.drink_menu === "object" && Object.keys(club.drink_menu).length > 0;
  const drink_menu: DrinkMenu = hasDrinks
    ? (club.drink_menu as DrinkMenu)
    : (defaults && Object.keys(defaults).length > 0 ? { ...defaults } : {});
  const blip = club?.blip;
  return {
    label: club?.label || "",
    description: club?.description || "",
    coords: toVec3(club?.coords, DEFAULT_VEC3),
    jobs: jobs.length ? jobs : [],
    drink_menu,
    blip: {
      name: blip?.name || club?.label || "",
      color: blip?.color ?? 5,
      sprite: blip?.sprite ?? 614,
      scale: blip?.scale ?? 0.8,
      visible: blip?.visible !== false,
    },
  };
}

function createEmptyEntityDraft(): EntityEditorState {
  return {
    type: "bartender",
    bartender: {
      coords: { ...DEFAULT_VEC3 },
      heading: 0,
    },
    bouncer: {
      ped: "bouncer_1",
      coords: { ...DEFAULT_VEC3 },
      heading: 0,
      vipMode: false,
    },
    clubEntry: {
      ped: "bouncer_1",
      bouncerCoords: { ...DEFAULT_VEC3 },
      bouncerHeading: 0,
      ejectCoords: { ...DEFAULT_VEC3 },
      ejectHeading: 0,
    },
    society: {
      coords: { ...DEFAULT_VEC3 },
      heading: 0,
    },
  };
}

function createEntityDraft(club: ClubSummary, entityId?: string): EntityEditorState {
  const base = createEmptyEntityDraft();
  if (!entityId || !club.entities || !club.entities[entityId]) {
    const center = toVec3(club.coords, DEFAULT_VEC3);
    base.bartender.coords = { ...center };
    base.bouncer.coords = { ...center };
    base.clubEntry.bouncerCoords = { ...center };
    base.clubEntry.ejectCoords = { ...center };
    base.society.coords = { ...center };
    return base;
  }

  const entity = club.entities[entityId] as Record<string, unknown>;
  const entityType =
    entity.type === "bartender" || entity.type === "bouncer" || entity.type === "club_entry" || entity.type === "society"
      ? entity.type
      : "bartender";
  base.type = entityType;

  if (entityType === "bartender") {
    const bartender = (entity.bartender || {}) as Record<string, unknown>;
    base.bartender.coords = toVec3(bartender.coords, toVec3(club.coords, DEFAULT_VEC3));
    base.bartender.heading = typeof bartender.heading === "number" ? bartender.heading : 0;
  } else if (entityType === "bouncer") {
    const bouncer = (entity.bouncer || {}) as Record<string, unknown>;
    base.bouncer.ped = typeof bouncer.ped === "string" ? bouncer.ped : "bouncer_1";
    base.bouncer.coords = toVec3(bouncer.coords, toVec3(club.coords, DEFAULT_VEC3));
    base.bouncer.heading = typeof bouncer.heading === "number" ? bouncer.heading : 0;
    base.bouncer.vipMode = bouncer.vipMode === true;
  } else if (entityType === "club_entry") {
    const bouncer = (entity.bouncer || {}) as Record<string, unknown>;
    const eject = (entity.eject || {}) as Record<string, unknown>;
    base.clubEntry.ped = typeof bouncer.ped === "string" ? bouncer.ped : "bouncer_1";
    base.clubEntry.bouncerCoords = toVec3(bouncer.coords, toVec3(club.coords, DEFAULT_VEC3));
    base.clubEntry.bouncerHeading = typeof bouncer.heading === "number" ? bouncer.heading : 0;
    base.clubEntry.ejectCoords = toVec3(eject.coords, toVec3(club.coords, DEFAULT_VEC3));
    base.clubEntry.ejectHeading = typeof eject.heading === "number" ? eject.heading : 0;
  } else if (entityType === "society") {
    const society = (entity.society || {}) as Record<string, unknown>;
    base.society.coords = toVec3(society.coords, toVec3(club.coords, DEFAULT_VEC3));
    base.society.heading = typeof society.heading === "number" ? society.heading : 0;
  }
  return base;
}

function getEntityEntries(club?: ClubSummary): { id: string; type: string }[] {
  if (!club || !club.entities) return [];
  return Object.entries(club.entities)
    .map(([id, entity]) => ({
      id,
      type: (entity as { type?: string }).type || "unknown",
    }))
    .sort((a, b) => a.id.localeCompare(b.id));
}

function NumericInput({
  value,
  onChange,
  step = "0.01",
}: {
  value: number;
  onChange: (value: number) => void;
  step?: string;
}) {
  return (
    <input
      type="number"
      step={step}
      value={Number.isFinite(value) ? value : 0}
      onChange={(e) => onChange(Number(e.target.value))}
      className="w-full h-9 rounded-md border border-border bg-background px-2 text-sm"
    />
  );
}

function ReadOnlyTransform({
  label,
  coords,
  heading,
}: {
  label: string;
  coords?: Vec3;
  heading?: number;
}) {
  return (
    <div className="rounded-md border border-border bg-background px-2 py-2 text-xs">
      <div className="font-semibold">{label}</div>
      <div className="text-muted-foreground">Coords: {formatCoords(coords)}</div>
      <div className="text-muted-foreground">Heading: {formatHeading(heading)}</div>
    </div>
  );
}

function generateDrinkId(): string {
  return `d_${Date.now().toString(36)}_${Math.random().toString(36).slice(2, 6)}`;
}

function emptyDrink(): DrinkMenuItem {
  return { name: "", flavors: [], alcohol: 5, price: 0, item: "" };
}

export function ClubManagement() {
  const locale = useLocale();
  const [visible, setVisible] = useState(false);
  const [hidden, setHidden] = useState(true);
  const [panelHiddenForGizmo, setPanelHiddenForGizmo] = useState(false);
  const [focus, setFocus] = useState(true);
  const [view, setView] = useState<ViewMode>("clubsRoot");
  const [busyAction, setBusyAction] = useState(false);
  const [confirmingDelete, setConfirmingDelete] = useState(false);
  const [clubs, setClubs] = useState<ClubSummary[]>([]);
  const [flavors, setFlavors] = useState<FlavorMap>({});
  const [peds, setPeds] = useState<PedMap>({});
  const [defaultDrinks, setDefaultDrinks] = useState<DrinkMenu>({});
  const [selectedClubId, setSelectedClubId] = useState<number | null>(null);
  const [selectedEntityId, setSelectedEntityId] = useState<string | null>(null);
  const [creatingClub, setCreatingClub] = useState(false);
  const [creatingEntity, setCreatingEntity] = useState(false);
  const [expandedDrinkKey, setExpandedDrinkKey] = useState<string | null>(null);
  const [clubDraft, setClubDraft] = useState<ClubEditorState>(createClubDraft());
  const [entityDraft, setEntityDraft] = useState<EntityEditorState>(createEmptyEntityDraft());
  const [newJobName, setNewJobName] = useState("");
  const openTimerRef = useRef<number | null>(null);
  const closeTimerRef = useRef<number | null>(null);

  const selectedClub = useMemo(
    () => (selectedClubId != null ? clubs.find((c) => c.id === selectedClubId) || null : null),
    [clubs, selectedClubId]
  );

  const entityEntries = useMemo(() => getEntityEntries(selectedClub || undefined), [selectedClub]);

  const clearTimers = useCallback(() => {
    if (openTimerRef.current) {
      window.clearTimeout(openTimerRef.current);
      openTimerRef.current = null;
    }
    if (closeTimerRef.current) {
      window.clearTimeout(closeTimerRef.current);
      closeTimerRef.current = null;
    }
  }, []);

  const resetState = useCallback(() => {
    setClubs([]);
    setView("clubsRoot");
    setSelectedClubId(null);
    setSelectedEntityId(null);
    setCreatingClub(false);
    setCreatingEntity(false);
    setBusyAction(false);
    setClubDraft(createClubDraft());
    setEntityDraft(createEmptyEntityDraft());
  }, []);

  const startOpenTransition = useCallback(() => {
    clearTimers();
    setVisible(true);
    setHidden(true);
    openTimerRef.current = window.setTimeout(() => {
      setHidden(false);
      openTimerRef.current = null;
    }, 25);
  }, [clearTimers]);

  const startCloseTransition = useCallback(() => {
    clearTimers();
    setHidden(true);
    closeTimerRef.current = window.setTimeout(() => {
      setVisible(false);
      resetState();
      closeTimerRef.current = null;
    }, 300);
  }, [clearTimers, resetState]);

  const sendClubAction = useCallback(
    (action: string, data: Record<string, unknown>) => fetchNui("clubManagementAction", { action, data }),
    []
  );

  const withBusyAction = useCallback(
    async (cb: () => Promise<void>) => {
      setBusyAction(true);
      try {
        await cb();
      } finally {
        setBusyAction(false);
      }
    },
    []
  );

  const openCreateClub = () => {
    setCreatingClub(true);
    setSelectedClubId(null);
    setClubDraft(createClubDraft(undefined, defaultDrinks));
    setView("clubDetail");
  };

  const openClubDetail = (clubId: number) => {
    const club = clubs.find((c) => c.id === clubId);
    setCreatingClub(false);
    setSelectedClubId(clubId);
    setClubDraft(createClubDraft(club));
    setSelectedEntityId(null);
    setCreatingEntity(false);
    setEntityDraft(createEmptyEntityDraft());
    setExpandedDrinkKey(null);
    setView("clubDetail");
  };

  const backToClubsRoot = () => {
    setView("clubsRoot");
    setCreatingClub(false);
    setSelectedClubId(null);
    setSelectedEntityId(null);
    setCreatingEntity(false);
    setConfirmingDelete(false);
    setEntityDraft(createEmptyEntityDraft());
  };

  const openCreateEntity = () => {
    if (!selectedClub) return;
    setCreatingEntity(true);
    setSelectedEntityId(null);
    setEntityDraft(createEntityDraft(selectedClub));
    setView("entityDetail");
  };

  const openEntityDetail = (entityId: string) => {
    if (!selectedClub) return;
    setCreatingEntity(false);
    setSelectedEntityId(entityId);
    setEntityDraft(createEntityDraft(selectedClub, entityId));
    setView("entityDetail");
  };

  const backToClubDetail = () => {
    setView("clubDetail");
    setCreatingEntity(false);
    setSelectedEntityId(null);
    setEntityDraft(createEmptyEntityDraft());
  };

  useNuiEvent("openClubManagement", (data: ClubManagementData & { clubId?: number; entityId?: string }) => {
    const nextClubs = normalizeClubs(data.clubs || []);
    setClubs(nextClubs);
    setFlavors(data.flavors && typeof data.flavors === "object" && !Array.isArray(data.flavors) ? data.flavors : {});
    setPeds((data as any).peds && typeof (data as any).peds === "object" ? (data as any).peds : {});
    setDefaultDrinks((data as any).defaultDrinks && typeof (data as any).defaultDrinks === "object" ? (data as any).defaultDrinks : {});
    setCreatingClub(false);
    setClubDraft(createClubDraft());
    setEntityDraft(createEmptyEntityDraft());
    const clubId = data.clubId != null ? Number(data.clubId) : null;
    const entityId = typeof data.entityId === "string" ? data.entityId : null;
    if (clubId != null && entityId != null) {
      const club = nextClubs.find((c) => c.id === clubId);
      if (club && club.entities?.[entityId]) {
        setSelectedClubId(clubId);
        setSelectedEntityId(entityId);
        setCreatingEntity(false);
        setClubDraft(createClubDraft(club));
        setEntityDraft(createEntityDraft(club, entityId));
        setView("entityDetail");
      } else {
        setView("clubsRoot");
        setSelectedClubId(null);
        setSelectedEntityId(null);
      }
    } else {
      setView("clubsRoot");
      setSelectedClubId(null);
      setSelectedEntityId(null);
      setCreatingEntity(false);
    }
    startOpenTransition();
  });

  useNuiEvent("setClubManagementFocus", (data: { toggle?: boolean }) => {
    setFocus(data.toggle !== false);
  });

  useNuiEvent("updateClubManagement", (data: ClubManagementData) => {
    setClubs(normalizeClubs(data.clubs || []));
  });

  useEffect(() => {
    if (view !== "entityDetail" || creatingEntity || selectedClubId == null || selectedEntityId == null) return;
    const club = clubs.find((c) => c.id === selectedClubId);
    if (!club) return;
    setEntityDraft(createEntityDraft(club, selectedEntityId));
  }, [clubs, view, creatingEntity, selectedClubId, selectedEntityId]);

  useNuiEvent("setClubManagementHidden", () => {
    startCloseTransition();
  });

  useNuiEvent("setClubManagementPanelHidden", (data: { hidden?: boolean }) => {
    setPanelHiddenForGizmo(data.hidden === true);
  });

  const handleClose = useCallback(() => {
    fetchNui("closeClubManagement", {});
    startCloseTransition();
  }, [startCloseTransition]);

  const hasBlipPosition = clubDraft.coords.x !== 0 || clubDraft.coords.y !== 0 || clubDraft.coords.z !== 0;
  const canCreateClub = !!clubDraft.label.trim() && hasBlipPosition;

  const saveClub = async () => {
    if (!clubDraft.label.trim()) return;
    if (creatingClub && !hasBlipPosition) return;
    const payload = {
      label: clubDraft.label.trim(),
      description: clubDraft.description,
      coords: clubDraft.coords,
      jobs: clubDraft.jobs,
      drink_menu: clubDraft.drink_menu,
      blip: clubDraft.blip,
    };
    await withBusyAction(async () => {
      if (creatingClub) {
        await sendClubAction("createClub", payload);
        backToClubsRoot();
        return;
      }
      if (selectedClubId == null) return;
      await sendClubAction("updateClub", {
        clubId: selectedClubId,
        ...payload,
      });
    });
  };

  const setClubJobsPrimary = (index: number) => {
    if (selectedClubId == null) return;
    const next = clubDraft.jobs.map((j, i) => ({ ...j, primary: i === index }));
    setClubDraft((prev) => ({ ...prev, jobs: next }));
    sendClubAction("updateClub", { clubId: selectedClubId, jobs: next });
  };

  const addClubJob = (jobName: string) => {
    const next = [...clubDraft.jobs, { name: jobName, primary: clubDraft.jobs.length === 0 }];
    setClubDraft((prev) => ({ ...prev, jobs: next }));
    if (selectedClubId != null) {
      sendClubAction("updateClub", { clubId: selectedClubId, jobs: next });
    }
  };

  const removeClubJob = (index: number) => {
    const next = clubDraft.jobs.filter((_, i) => i !== index);
    const hadPrimary = clubDraft.jobs[index]?.primary;
    if (hadPrimary && next.length > 0 && !next.some((j) => j.primary)) {
      next[0] = { ...next[0], primary: true };
    }
    setClubDraft((prev) => ({ ...prev, jobs: next }));
    if (selectedClubId != null) {
      sendClubAction("updateClub", { clubId: selectedClubId, jobs: next });
    }
  };

  const editClubCoordsWithGizmo = async () => {
    if (selectedClubId == null) return;
    await withBusyAction(async () => {
      await sendClubAction("editClubCoords", { clubId: selectedClubId });
    });
  };

  const deleteClub = async () => {
    if (selectedClubId == null) return;
    await withBusyAction(async () => {
      await sendClubAction("deleteClub", { clubId: selectedClubId });
      backToClubsRoot();
    });
  };

  function buildEntityPayloadFromDraft(draft: EntityEditorState, includeTransform: boolean): ClubEntity | null {
    if (draft.type === "bartender") {
      const base: ClubEntity = {
        type: "bartender",
        bartender: {},
      };
      if (includeTransform) {
        (base as BartenderEntity).bartender.coords = draft.bartender.coords;
        (base as BartenderEntity).bartender.heading = draft.bartender.heading;
      }
      return base;
    }
    if (draft.type === "bouncer") {
      if (!draft.bouncer.ped.trim()) return null;
      const base: ClubEntity = {
        type: "bouncer",
        bouncer: { ped: draft.bouncer.ped.trim(), vipMode: draft.bouncer.vipMode },
      };
      if (includeTransform) {
        (base as BouncerEntity).bouncer.coords = draft.bouncer.coords;
        (base as BouncerEntity).bouncer.heading = draft.bouncer.heading;
      }
      return base;
    }
    if (draft.type === "club_entry") {
      if (!draft.clubEntry.ped.trim()) return null;
      const base: ClubEntity = {
        type: "club_entry",
        bouncer: { ped: draft.clubEntry.ped.trim() },
        eject: {},
      };
      if (includeTransform) {
        (base as ClubEntryEntity).bouncer.coords = draft.clubEntry.bouncerCoords;
        (base as ClubEntryEntity).bouncer.heading = draft.clubEntry.bouncerHeading;
        (base as ClubEntryEntity).eject.coords = draft.clubEntry.ejectCoords;
        (base as ClubEntryEntity).eject.heading = draft.clubEntry.ejectHeading;
      }
      return base;
    }
    if (draft.type === "society") {
      const base: ClubEntity = {
        type: "society",
        society: {},
      };
      if (includeTransform) {
        (base as SocietyEntity).society.coords = draft.society.coords;
        (base as SocietyEntity).society.heading = draft.society.heading;
      }
      return base;
    }
    return null;
  }

  const entityDraftRef = useRef<EntityEditorState>(entityDraft);
  entityDraftRef.current = entityDraft;

  const clubDraftRef = useRef<ClubEditorState>(clubDraft);
  clubDraftRef.current = clubDraft;

  const debouncedEntitySaveRef = useRef<number | null>(null);
  const debouncedClubSaveRef = useRef<number | null>(null);
  const DEBOUNCE_MS = 500;

  const scheduleEntitySave = useCallback(() => {
    if (creatingEntity || selectedClubId == null || selectedEntityId == null) return;
    if (debouncedEntitySaveRef.current != null) {
      window.clearTimeout(debouncedEntitySaveRef.current);
    }
    const draft = structuredClone(entityDraftRef.current);
    debouncedEntitySaveRef.current = window.setTimeout(() => {
      debouncedEntitySaveRef.current = null;

      const payload = buildEntityPayloadFromDraft(draft, true);
      if (payload) {
        sendClubAction("updateClubEntity", {
          clubId: selectedClubId,
          entityId: selectedEntityId,
          entityData: payload,
        });
      }
    }, DEBOUNCE_MS);
  }, [creatingEntity, selectedClubId, selectedEntityId, sendClubAction]);

  const scheduleClubSave = useCallback(() => {
    if (creatingClub || selectedClubId == null) return;
    if (debouncedClubSaveRef.current != null) {
      window.clearTimeout(debouncedClubSaveRef.current);
    }
    const draft = structuredClone(clubDraftRef.current);
    debouncedClubSaveRef.current = window.setTimeout(() => {
      debouncedClubSaveRef.current = null;

      if (!draft.label.trim()) return;
      sendClubAction("updateClub", {
        clubId: selectedClubId,
        label: draft.label.trim(),
        description: draft.description,
        jobs: draft.jobs,
        drink_menu: draft.drink_menu,
        blip: draft.blip,
      });
    }, DEBOUNCE_MS);
  }, [creatingClub, selectedClubId, sendClubAction]);

  const createEntity = async () => {
    if (selectedClubId == null || !creatingEntity) return;
    const payload = buildEntityPayloadFromDraft(entityDraft, false);
    if (!payload) return;
    await withBusyAction(async () => {
      await sendClubAction("createClubEntity", {
        clubId: selectedClubId,
        entityType: entityDraft.type,
        entityData: payload,
        useGizmo: true,
      });
      backToClubDetail();
    });
  };

  const editEntityTransform = async (target: "main" | "bouncer" | "eject") => {
    if (selectedClubId == null || !selectedEntityId) return;
    await withBusyAction(async () => {
      await sendClubAction("editEntityTransform", {
        clubId: selectedClubId,
        entityId: selectedEntityId,
        target,
      });
    });
  };

  const deleteEntity = async () => {
    if (selectedClubId == null || !selectedEntityId) return;
    await withBusyAction(async () => {
      await sendClubAction("deleteClubEntity", {
        clubId: selectedClubId,
        entityId: selectedEntityId,
      });
      backToClubDetail();
    });
  };

  useEffect(() => {
    if (!visible) return;
    const onKeyDown = (event: KeyboardEvent) => {
      if (panelHiddenForGizmo) return;
      const target = event.target as HTMLElement | null;
      const isTyping =
        target instanceof HTMLInputElement ||
        target instanceof HTMLTextAreaElement ||
        target?.isContentEditable;
      if (isTyping) return;
      if (event.key === "g" || event.key === "G") {
        fetchNui("toggleClubManagementFocus", {});
        return;
      }
      if (event.key === "Escape") {
        handleClose();
        return;
      }
    };
    window.addEventListener("keydown", onKeyDown);
    return () => window.removeEventListener("keydown", onKeyDown);
  }, [visible, handleClose, panelHiddenForGizmo]);

  useEffect(() => {
    return () => clearTimers();
  }, [clearTimers]);

  useEffect(() => {
    return () => {
      if (debouncedEntitySaveRef.current != null) {
        window.clearTimeout(debouncedEntitySaveRef.current);
      }
      if (debouncedClubSaveRef.current != null) {
        window.clearTimeout(debouncedClubSaveRef.current);
      }
    };
  }, []);

  if (!visible) return null;

  return (
    <div className="fixed inset-0 z-[100] text-primary">
      {!panelHiddenForGizmo && (
        <AppControls
          controls={[
            { key: "ESC", label: "Exit" },
            { key: "G", label: `Focus ${focus ? "Off" : "On"}` },
          ]}
        />
      )}
      <div
        className={`absolute top-0 right-0 h-full w-[430px] bg-background/95 border-l border-border flex flex-col transition-transform duration-300 ${
          hidden || panelHiddenForGizmo ? "translate-x-full" : "translate-x-0"
        }`}
      >
        <div className="p-3 border-b border-border flex items-center justify-between">
          <div>
            <div className="text-lg font-semibold">Club Management</div>
            <div className="text-xs text-muted-foreground">
              {view === "clubsRoot" && "Clubs"}
              {view === "clubDetail" && "Club Configuration + Entities"}
              {view === "entityDetail" && "Entity Configuration"}
            </div>
          </div>
          <Button variant="outline" size="sm" onClick={handleClose}>
            Close
          </Button>
        </div>

        <div className="flex-1 overflow-auto p-3 space-y-3">
          {view === "clubsRoot" && (
            <div className="space-y-2">
              <div className="flex items-center justify-between">
                <div className="text-sm font-semibold">Clubs</div>
                <Button size="sm" variant="secondary" onClick={openCreateClub} disabled={busyAction}>
                  New Club
                </Button>
              </div>
              <div className="space-y-1 max-h-[70vh] overflow-auto">
                {clubs.length === 0 && (
                  <div className="text-xs text-muted-foreground">No clubs found.</div>
                )}
                {clubs.map((club) => (
                  <button
                    key={club.id}
                    type="button"
                    onClick={() => openClubDetail(club.id)}
                    className="w-full rounded-md px-2 py-2 text-left text-sm bg-secondary hover:bg-secondary/80"
                  >
                    <div className="font-semibold">#{club.id} {club.label}</div>
                    <div className="text-[11px] text-muted-foreground">{formatCoords(club.coords)}</div>
                  </button>
                ))}
              </div>
            </div>
          )}

          {view === "clubDetail" && (
            <div className="space-y-2">
              <Button size="sm" variant="outline" onClick={backToClubsRoot} disabled={busyAction}>
                Back To Clubs
              </Button>
              <div className="rounded-md border border-border bg-secondary/30 p-2 space-y-2">
                <div className="text-sm font-semibold">
                  {creatingClub ? "Create Club" : `Edit Club #${selectedClubId ?? "?"}`}
                </div>
                <input
                  type="text"
                  value={clubDraft.label}
                  onChange={(e) => {
                    setClubDraft((prev) => ({ ...prev, label: e.target.value }));
                    scheduleClubSave();
                  }}
                  className="w-full h-9 rounded-md border border-border bg-background px-2 text-sm"
                  placeholder="Club label"
                />
                <textarea
                  value={clubDraft.description}
                  onChange={(e) => {
                    setClubDraft((prev) => ({ ...prev, description: e.target.value }));
                    scheduleClubSave();
                  }}
                  className="w-full rounded-md border border-border bg-background p-2 text-sm min-h-20"
                  placeholder="Description"
                />
                <div className="space-y-1">
                  <div className="text-xs font-medium text-muted-foreground">Jobs with access (one primary)</div>
                  {clubDraft.jobs.length === 0 && (
                    <div className="text-xs text-muted-foreground">No jobs. Add one below.</div>
                  )}
                  {clubDraft.jobs.map((job, idx) => (
                    <div key={idx} className="flex items-center gap-2 rounded border border-border bg-background px-2 py-1 text-sm">
                      <span className="flex-1 font-mono">{job.name}</span>
                      <label className="flex items-center gap-1 text-xs">
                        <input
                          type="checkbox"
                          checked={job.primary}
                          onChange={() => setClubJobsPrimary(idx)}
                          disabled={busyAction}
                        />
                        Primary
                      </label>
                      <Button
                        type="button"
                        size="sm"
                        variant="ghost"
                        className="h-6 px-1 text-destructive"
                        onClick={() => removeClubJob(idx)}
                        disabled={busyAction}
                      >
                        Remove
                      </Button>
                    </div>
                  ))}
                  <div className="flex gap-2">
                    <input
                      type="text"
                      value={newJobName}
                      onChange={(e) => setNewJobName(e.target.value)}
                      onKeyDown={(e) => {
                        if (e.key === "Enter") {
                          e.preventDefault();
                          const name = newJobName.trim();
                          if (name && !clubDraft.jobs.some((j) => j.name === name)) {
                            addClubJob(name);
                            setNewJobName("");
                          }
                        }
                      }}
                      className="flex-1 h-9 rounded-md border border-border bg-background px-2 text-sm"
                      placeholder="Job name"
                    />
                    <Button
                      type="button"
                      size="sm"
                      variant="secondary"
                      onClick={() => {
                        const name = newJobName.trim();
                        if (name && !clubDraft.jobs.some((j) => j.name === name)) {
                          addClubJob(name);
                          setNewJobName("");
                        }
                      }}
                      disabled={busyAction || !newJobName.trim()}
                    >
                      Add
                    </Button>
                  </div>
                </div>
                <div className="space-y-2">
                  <div className="text-xs font-semibold mb-1">{locale("club_blip")}</div>
                  <div>
                    <div className="text-[10px] text-muted-foreground mb-1">{locale("club_blip_name")}</div>
                    <input
                      type="text"
                      value={clubDraft.blip.name}
                      onChange={(e) => {
                        setClubDraft((prev) => ({ ...prev, blip: { ...prev.blip, name: e.target.value } }));
                        scheduleClubSave();
                      }}
                      className="w-full h-9 rounded-md border border-border bg-background px-2 text-sm"
                      placeholder={locale("club_blip_name")}
                    />
                  </div>
                  <div className="grid grid-cols-2 gap-2">
                    <div>
                      <div className="text-[10px] text-muted-foreground mb-1">{locale("club_blip_sprite")}</div>
                      <NumericInput
                        value={clubDraft.blip.sprite}
                        onChange={(sprite) => {
                          setClubDraft((prev) => ({ ...prev, blip: { ...prev.blip, sprite } }));
                          scheduleClubSave();
                        }}
                        step="1"
                      />
                    </div>
                    <div>
                      <div className="text-[10px] text-muted-foreground mb-1">{locale("club_blip_color")}</div>
                      <NumericInput
                        value={clubDraft.blip.color}
                        onChange={(color) => {
                          setClubDraft((prev) => ({ ...prev, blip: { ...prev.blip, color } }));
                          scheduleClubSave();
                        }}
                        step="1"
                      />
                    </div>
                  </div>
                  <div>
                    <div className="text-[10px] text-muted-foreground mb-1">{locale("club_blip_scale")}</div>
                    <NumericInput
                      value={clubDraft.blip.scale}
                      onChange={(scale) => {
                        setClubDraft((prev) => ({ ...prev, blip: { ...prev.blip, scale } }));
                        scheduleClubSave();
                      }}
                    />
                  </div>
                  <label className="flex items-center gap-2 text-sm">
                    <input
                      type="checkbox"
                      checked={clubDraft.blip.visible}
                      onChange={(e) => {
                        setClubDraft((prev) => ({ ...prev, blip: { ...prev.blip, visible: e.target.checked } }));
                        scheduleClubSave();
                      }}
                    />
                    {locale("club_blip_visible")}
                  </label>
                  <Button
                    size="sm"
                    variant="secondary"
                    className="w-full"
                    onClick={async () => {
                      if (creatingClub) {
                        const coords = await fetchNui<Vec3>("getPlayerCoords");
                        if (coords) {
                          setClubDraft((prev) => ({ ...prev, coords }));
                        }
                      } else {
                        editClubCoordsWithGizmo();
                      }
                    }}
                    disabled={busyAction}
                  >
                    <MapPin className="w-3.5 h-3.5 mr-1" />{locale("club_blip_set_position")}
                    {clubDraft.coords.x !== 0 || clubDraft.coords.y !== 0 || clubDraft.coords.z !== 0 ? (
                      <span className="ml-1 text-[10px] text-muted-foreground">&#x2713;</span>
                    ) : null}
                  </Button>
                </div>
                <div className="space-y-2">
                  <div className="flex items-center justify-between">
                    <div className="text-xs font-semibold">Drink Menu</div>
                    <Button
                      type="button"
                      size="sm"
                      variant="secondary"
                      className="h-6 px-2 text-xs"
                      onClick={() => {
                        const id = generateDrinkId();
                        setClubDraft((prev) => ({
                          ...prev,
                          drink_menu: { ...prev.drink_menu, [id]: emptyDrink() },
                        }));
                        setExpandedDrinkKey(id);
                        scheduleClubSave();
                      }}
                    >
                      + Add Drink
                    </Button>
                  </div>
                  {Object.keys(clubDraft.drink_menu || {}).length === 0 && (
                    <div className="text-xs text-muted-foreground italic">No drinks yet — click &quot;+ Add Drink&quot; to create one.</div>
                  )}
                  <div className="space-y-2 max-h-[400px] overflow-y-auto pr-1">
                    {Object.entries(clubDraft.drink_menu || {}).sort(([, a], [, b]) => (a.name || "").localeCompare(b.name || "")).map(([key, drink]) => {
                      const orderableEntries = Object.entries(flavors).filter(([, f]) => !f.isAlcohol);
                      const updateDrink = (patch: Partial<DrinkMenuItem>) => {
                        setClubDraft((prev) => ({
                          ...prev,
                          drink_menu: { ...prev.drink_menu, [key]: { ...drink, ...patch } },
                        }));
                        scheduleClubSave();
                      };
                      const isExpanded = expandedDrinkKey === key;
                      const deleteDrink = () => {
                        setClubDraft((prev) => {
                          const next = { ...prev.drink_menu };
                          delete next[key];
                          return { ...prev, drink_menu: next };
                        });
                        if (expandedDrinkKey === key) setExpandedDrinkKey(null);
                        scheduleClubSave();
                      };

                      if (!isExpanded) {
                        // Collapsed summary row
                        return (
                          <div
                            key={key}
                            className="rounded-md border border-border bg-secondary/20 px-3 py-2 flex items-center gap-2 cursor-pointer hover:bg-secondary/30 transition-colors"
                            onClick={() => setExpandedDrinkKey(key)}
                          >
                            <div className="flex-1 min-w-0">
                              <div className="text-sm font-medium truncate">
                                {drink.name || <span className="italic text-muted-foreground">Unnamed drink</span>}
                              </div>
                              <div className="flex flex-wrap items-center gap-1.5 mt-1">
                                {drink.flavors.map((fk) => {
                                  const f = flavors[fk];
                                  if (!f) return null;
                                  const [r, g, b] = f.color;
                                  return (
                                    <span
                                      key={fk}
                                      className="text-[10px] px-1.5 py-0.5 rounded-full font-medium"
                                      style={{ backgroundColor: `rgba(${r},${g},${b},0.2)`, color: `rgb(${r},${g},${b})`, border: `1px solid rgba(${r},${g},${b},0.5)` }}
                                    >
                                      {f.label}
                                    </span>
                                  );
                                })}
                                <span className="text-[10px] text-muted-foreground ml-auto shrink-0">
                                  {drink.alcohol}% · ${drink.price}
                                </span>
                              </div>
                            </div>
                            <Button
                              type="button"
                              size="sm"
                              variant="ghost"
                              className="h-7 w-7 p-0 text-muted-foreground hover:text-destructive hover:bg-destructive/10 shrink-0"
                              onClick={(e) => { e.stopPropagation(); deleteDrink(); }}
                            >
                              ✕
                            </Button>
                          </div>
                        );
                      }

                      // Expanded editor
                      return (
                        <div key={key} className="rounded-md border border-primary/40 bg-secondary/20 p-2.5 space-y-2.5">
                          {/* Header row */}
                          <div className="flex items-center justify-between gap-2">
                            <div className="text-xs font-semibold text-muted-foreground truncate">
                              {drink.name || "New drink"}
                            </div>
                            <div className="flex items-center gap-1 shrink-0">
                              <Button
                                type="button"
                                size="sm"
                                variant="ghost"
                                className="h-6 px-2 text-xs text-destructive hover:text-destructive hover:bg-destructive/10"
                                onClick={deleteDrink}
                              >
                                Delete
                              </Button>
                              <Button
                                type="button"
                                size="sm"
                                variant="ghost"
                                className="h-6 px-2 text-xs"
                                onClick={() => setExpandedDrinkKey(null)}
                              >
                                Done
                              </Button>
                            </div>
                          </div>

                          {/* Drink Name */}
                          <div>
                            <div className="text-[10px] font-semibold text-muted-foreground uppercase tracking-wide mb-1">
                              Drink Name
                            </div>
                            <input
                              type="text"
                              value={drink.name}
                              onChange={(e) => updateDrink({ name: e.target.value })}
                              className="w-full h-8 rounded border border-border bg-background px-2 text-sm"
                              placeholder="e.g. Strawberry Daiquiri"
                            />
                          </div>

                          {/* Ingredients */}
                          <div>
                            <div className="text-[10px] font-semibold text-muted-foreground uppercase tracking-wide mb-1">
                              Ingredients
                            </div>
                            {orderableEntries.length === 0 ? (
                              <div className="text-[10px] text-muted-foreground italic">No flavors configured.</div>
                            ) : (
                              <div className="flex flex-wrap gap-1">
                                {orderableEntries.map(([flavorKey, f]) => {
                                  const checked = (drink.flavors ?? []).includes(flavorKey);
                                  const [r, g, b] = f.color;
                                  return (
                                    <label
                                      key={flavorKey}
                                      className="flex items-center gap-1 cursor-pointer text-[10px] px-2 py-1 rounded-full font-medium select-none border transition-colors"
                                      style={{
                                        backgroundColor: checked ? `rgba(${r},${g},${b},0.2)` : "transparent",
                                        borderColor: checked ? `rgba(${r},${g},${b},0.6)` : "var(--border)",
                                        color: checked ? `rgb(${r},${g},${b})` : "var(--muted-foreground)",
                                      }}
                                    >
                                      <input
                                        type="checkbox"
                                        className="sr-only"
                                        checked={checked}
                                        onChange={() => {
                                          const next = checked
                                            ? drink.flavors.filter((x) => x !== flavorKey)
                                            : [...(drink.flavors ?? []), flavorKey].sort();
                                          updateDrink({ flavors: next });
                                        }}
                                      />
                                      {checked && (
                                        <span
                                          className="inline-block w-2 h-2 rounded-full shrink-0"
                                          style={{ backgroundColor: `rgb(${r},${g},${b})` }}
                                        />
                                      )}
                                      {f.label}
                                    </label>
                                  );
                                })}
                              </div>
                            )}
                          </div>

                          {/* Alcohol % + Price */}
                          <div className="grid grid-cols-2 gap-2">
                            <div>
                              <div className="text-[10px] font-semibold text-muted-foreground uppercase tracking-wide mb-1">
                                Alcohol %
                              </div>
                              <div className="relative">
                                <input
                                  type="number"
                                  min={0}
                                  max={100}
                                  step={1}
                                  value={drink.alcohol ?? 5}
                                  onChange={(e) =>
                                    updateDrink({ alcohol: Math.min(100, Math.max(0, parseInt(e.target.value, 10) || 0)) })
                                  }
                                  className="w-full h-8 rounded border border-border bg-background px-2 pr-7 text-sm"
                                />
                                <span className="absolute right-2 top-1/2 -translate-y-1/2 text-[10px] text-muted-foreground pointer-events-none">%</span>
                              </div>
                            </div>
                            <div>
                              <div className="text-[10px] font-semibold text-muted-foreground uppercase tracking-wide mb-1">
                                Price
                              </div>
                              <div className="relative">
                                <span className="absolute left-2 top-1/2 -translate-y-1/2 text-[10px] text-muted-foreground pointer-events-none">$</span>
                                <input
                                  type="number"
                                  min={0}
                                  step={1}
                                  value={drink.price ?? 0}
                                  onChange={(e) =>
                                    updateDrink({ price: Math.max(0, parseInt(e.target.value, 10) || 0) })
                                  }
                                  className="w-full h-8 rounded border border-border bg-background px-2 pl-5 text-sm"
                                />
                              </div>
                            </div>
                          </div>

                          {/* Inventory Item */}
                          <div>
                            <div className="text-[10px] font-semibold text-muted-foreground uppercase tracking-wide mb-1">
                              Inventory Item
                            </div>
                            <input
                              type="text"
                              value={drink.item ?? ""}
                              onChange={(e) => updateDrink({ item: e.target.value })}
                              className="w-full h-8 rounded border border-border bg-background px-2 text-sm font-mono"
                              placeholder="inventory_item_name"
                            />
                          </div>
                        </div>
                      );
                    })}
                  </div>
                </div>
                {creatingClub ? (
                  <Button size="sm" className="w-full" onClick={saveClub} disabled={busyAction || !canCreateClub}>
                    Create Club
                  </Button>
                ) : !confirmingDelete ? (
                  <Button
                    size="sm"
                    variant="destructive"
                    className="w-full"
                    onClick={() => setConfirmingDelete(true)}
                    disabled={busyAction}
                  >
                    Delete Club
                  </Button>
                ) : (
                  <div className="w-full space-y-2 rounded-md border border-destructive p-2">
                    <div className="text-xs text-destructive font-semibold">Are you sure? This cannot be undone.</div>
                    <div className="flex gap-2">
                      <Button
                        size="sm"
                        variant="destructive"
                        className="flex-1"
                        onClick={() => { setConfirmingDelete(false); deleteClub(); }}
                        disabled={busyAction}
                      >
                        Confirm
                      </Button>
                      <Button
                        size="sm"
                        variant="outline"
                        className="flex-1"
                        onClick={() => setConfirmingDelete(false)}
                      >
                        Cancel
                      </Button>
                    </div>
                  </div>
                )}
              </div>

              {!creatingClub && selectedClub && (
                <div className="rounded-md border border-border bg-secondary/30 p-2 space-y-2">
                  <div className="flex items-center justify-between">
                    <div className="text-sm font-semibold">Entities</div>
                    <Button size="sm" variant="secondary" onClick={openCreateEntity} disabled={busyAction}>
                      New Entity
                    </Button>
                  </div>
                  <div className="space-y-1 max-h-[36vh] overflow-auto">
                    {entityEntries.length === 0 && (
                      <div className="text-xs text-muted-foreground">No entities in this club.</div>
                    )}
                    {entityEntries.map((entity) => (
                      <button
                        key={entity.id}
                        type="button"
                        onClick={() => openEntityDetail(entity.id)}
                        className="w-full rounded-md px-2 py-2 text-left text-xs bg-secondary hover:bg-secondary/80"
                      >
                        <div className="font-semibold">{locale("entity_type_" + entity.type)}</div>
                        <div className="text-muted-foreground font-mono text-[10px]">{entity.id}</div>
                      </button>
                    ))}
                  </div>
                </div>
              )}
            </div>
          )}

          {view === "entityDetail" && (
            <div className="space-y-2">
              <Button size="sm" variant="outline" onClick={backToClubDetail} disabled={busyAction}>
                Back To Club
              </Button>
              <div className="rounded-md border border-border bg-secondary/30 p-2 space-y-2">
                <div className="text-sm font-semibold">
                  {creatingEntity ? locale("entity_type_" + entityDraft.type) : locale("entity_type_" + entityDraft.type)}
                </div>
                {creatingEntity && (
                  <select
                    className="w-full h-9 rounded-md border border-border bg-background px-2 text-sm"
                    value={entityDraft.type}
                    onChange={(e) =>
                      setEntityDraft((prev) => ({
                        ...prev,
                        type: e.target.value as EntityEditorState["type"],
                      }))
                    }
                  >
                    <option value="bartender">{locale("entity_type_bartender")}</option>
                    <option value="bouncer">{locale("entity_type_bouncer")}</option>
                    <option value="club_entry">{locale("entity_type_club_entry")}</option>
                    <option value="society">{locale("entity_type_society")}</option>
                  </select>
                )}

                {entityDraft.type === "bartender" && (
                  <div className="space-y-2">
                    {!creatingEntity && (
                      <>
                        <ReadOnlyTransform
                          label="Position"
                          coords={entityDraft.bartender.coords}
                          heading={entityDraft.bartender.heading}
                        />
                        <div className="flex gap-1">
                          <Button
                            size="sm"
                            variant="secondary"
                            onClick={() => editEntityTransform("main")}
                            disabled={busyAction}
                          >
                            <Move className="w-3.5 h-3.5 mr-1" />{locale("entity_move_position")}
                          </Button>
                          <Button
                            size="sm"
                            variant="secondary"
                            onClick={() => fetchNui("teleportToEntity", { clubId: selectedClubId, entityId: selectedEntityId })}
                          >
                            <Navigation className="w-3.5 h-3.5 mr-1" />{locale("entity_teleport")}
                          </Button>
                        </div>
                      </>
                    )}
                  </div>
                )}

                {entityDraft.type === "bouncer" && (
                  <div className="space-y-2">
                    {!creatingEntity && (
                      <>
                        <ReadOnlyTransform
                          label="Position"
                          coords={entityDraft.bouncer.coords}
                          heading={entityDraft.bouncer.heading}
                        />
                        <div className="flex gap-1">
                          <Button
                            size="sm"
                            variant="secondary"
                            onClick={() => editEntityTransform("main")}
                            disabled={busyAction}
                          >
                            <Move className="w-3.5 h-3.5 mr-1" />{locale("entity_move_position")}
                          </Button>
                          <Button
                            size="sm"
                            variant="secondary"
                            onClick={() => fetchNui("teleportToEntity", { clubId: selectedClubId, entityId: selectedEntityId })}
                          >
                            <Navigation className="w-3.5 h-3.5 mr-1" />{locale("entity_teleport")}
                          </Button>
                        </div>
                      </>
                    )}
                    <select
                      value={entityDraft.bouncer.ped}
                      onChange={(e) => {
                        setEntityDraft((prev) => ({
                          ...prev,
                          bouncer: { ...prev.bouncer, ped: e.target.value },
                        }));
                        scheduleEntitySave();
                      }}
                      className="w-full h-9 rounded-md border border-border bg-background px-2 text-sm"
                    >
                      {Object.entries(peds).map(([key, ped]) => (
                        <option key={key} value={key}>{(ped as any).label || key}</option>
                      ))}
                    </select>
                    <label className="flex items-start gap-2 cursor-pointer text-sm">
                      <input
                        type="checkbox"
                        className="mt-0.5 rounded border-border"
                        checked={entityDraft.bouncer.vipMode}
                        onChange={(e) => {
                          setEntityDraft((prev) => ({
                            ...prev,
                            bouncer: { ...prev.bouncer, vipMode: e.target.checked },
                          }));
                          scheduleEntitySave();
                        }}
                      />
                      <span>
                        <span className="font-medium">{locale("entity_bouncer_vip_mode")}</span>
                        <span className="block text-xs text-muted-foreground">{locale("entity_bouncer_vip_mode_desc")}</span>
                      </span>
                    </label>
                  </div>
                )}

                {entityDraft.type === "society" && (
                  <div className="space-y-2">
                    {!creatingEntity && (
                      <>
                        <ReadOnlyTransform
                          label="Position"
                          coords={entityDraft.society.coords}
                          heading={entityDraft.society.heading}
                        />
                        <div className="flex gap-1">
                          <Button
                            size="sm"
                            variant="secondary"
                            onClick={() => editEntityTransform("main")}
                            disabled={busyAction}
                          >
                            <Move className="w-3.5 h-3.5 mr-1" />{locale("entity_move_position")}
                          </Button>
                          <Button
                            size="sm"
                            variant="secondary"
                            onClick={() => fetchNui("teleportToEntity", { clubId: selectedClubId, entityId: selectedEntityId })}
                          >
                            <Navigation className="w-3.5 h-3.5 mr-1" />{locale("entity_teleport")}
                          </Button>
                        </div>
                      </>
                    )}
                    <div className="text-xs text-muted-foreground">
                      Society interaction point for deposit/withdraw. Uses club primary job as society name.
                    </div>
                  </div>
                )}

                {entityDraft.type === "club_entry" && (
                  <div className="space-y-2">
                    {!creatingEntity && (
                      <>
                        <ReadOnlyTransform
                          label="Bouncer Position"
                          coords={entityDraft.clubEntry.bouncerCoords}
                          heading={entityDraft.clubEntry.bouncerHeading}
                        />
                        <Button
                          size="sm"
                          variant="secondary"
                          onClick={() => editEntityTransform("bouncer")}
                          disabled={busyAction}
                        >
                          Move Bouncer (Gizmo)
                        </Button>
                        <ReadOnlyTransform
                          label="Eject Position"
                          coords={entityDraft.clubEntry.ejectCoords}
                          heading={entityDraft.clubEntry.ejectHeading}
                        />
                        <Button
                          size="sm"
                          variant="secondary"
                          onClick={() => editEntityTransform("eject")}
                          disabled={busyAction}
                        >
                          Move Eject (Gizmo)
                        </Button>
                      </>
                    )}
                    <select
                      value={entityDraft.clubEntry.ped}
                      onChange={(e) => {
                        setEntityDraft((prev) => ({
                          ...prev,
                          clubEntry: { ...prev.clubEntry, ped: e.target.value },
                        }));
                        scheduleEntitySave();
                      }}
                      className="w-full h-9 rounded-md border border-border bg-background px-2 text-sm"
                    >
                      {Object.entries(peds).map(([key, ped]) => (
                        <option key={key} value={key}>{(ped as any).label || key}</option>
                      ))}
                    </select>
                  </div>
                )}

                <div className="flex gap-2">
                  {creatingEntity && (
                    <Button size="sm" onClick={createEntity} disabled={busyAction}>
                      Create Entity
                    </Button>
                  )}
                  {!creatingEntity && (
                    <Button size="sm" variant="destructive" onClick={deleteEntity} disabled={busyAction}>
                      Delete Entity
                    </Button>
                  )}
                </div>
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
