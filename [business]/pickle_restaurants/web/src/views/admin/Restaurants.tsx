import { useEffect, useLayoutEffect, useRef, useState } from "react";
import { fetchNui, setPeek } from "@/lib/nui";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { Field, NumberField, Toggle } from "@/components/form";
import { Tabs, TabsList, TabsTrigger, TabsContent } from "@/components/ui/tabs";
import Branding, { ThemeEditor, NameEditor } from "@/components/Branding";
import { Card, CardContent } from "@/components/ui/card";
import { useAutoSave } from "@/lib/autosave";
import { applyTheme, type ThemeConfig } from "@/lib/theme";
import { money } from "@/lib/utils";
import { _L } from "@/lib/locale";
import {
  Plus, Trash2, Pencil, MapPin, ChevronRight, ChevronDown, ArrowLeft, CupSoda, Flame, Sandwich, CookingPot, UserCog, Receipt, Armchair, Image as ImageIcon, Tags, X, Building2, Sparkles, Monitor, Users, DoorOpen, Map as MapIcon, RotateCcw, Check, Loader2, Briefcase, TriangleAlert,
} from "lucide-react";

// LAZY getter (memoized): `_L()` resolves at render, not at module import — a
// module-scope `_L()` runs before loadLocale() and would freeze to the raw key.
let _stations: { key: string; label: string; icon: any; physicalOnly?: boolean }[] | null = null;
const STATIONS = () => (_stations ??= [
  { key: "soda_machine", label: _L("admin.station_soda_machine"), icon: CupSoda },
  { key: "fryer", label: _L("admin.station_fryer"), icon: Flame },
  { key: "stovetop", label: _L("admin.station_stovetop"), icon: CookingPot },
  { key: "kitchen_prep", label: _L("admin.station_kitchen_prep"), icon: Sandwich },
  // Self-service order kiosk — a physical customer terminal, no virtual variant.
  { key: "kiosk", label: _L("admin.station_kiosk"), icon: Monitor, physicalOnly: true },
  // Free-standing floor kiosk (the _02 body) — same terminal, ground-placed.
  { key: "kiosk_ground", label: _L("admin.station_kiosk_ground"), icon: Monitor, physicalOnly: true },
  // Customer info SCREENS — wall boards driven by a render target (menu / orders).
  { key: "menu_screen", label: _L("admin.station_menu_screen"), icon: Monitor, physicalOnly: true },
  { key: "orders_screen", label: _L("admin.station_orders_screen"), icon: Monitor, physicalOnly: true },
]);

// Human name for a placed prop, so a chip reads "Fryer #12" instead of just "#12".
// Virtual points resolve through their target station; counters/seats are named
// directly. Falls back to the raw type for anything unmapped.
function propLabel(p: any): string {
  if (p.prop_type === "counter") return _L("admin.counter");
  if (p.prop_type === "virtual_register") return _L("admin.virtual_register");
  if (p.prop_type === "seat") return _L("admin.seat_one");
  if (p.prop_type === "delivery_door") return _L("admin.door_one");
  const key = p.prop_type === "virtual_point" ? p.target : p.prop_type;
  return STATIONS().find((s) => s.key === key)?.label || key || _L("admin.prop_one");
}

// One placed prop: a named chip with Edit (reposition) + Remove. Hovering beams
// the prop's point in the world (the panel is centred, so the world shows around
// it) — highlight is force-cleared on unmount so a closed panel leaves no beam.
function PropChip({ p, act, restaurantId, section, virtual }:
  { p: any; act: (e: string, d: any) => void; restaurantId: number; section: string; virtual?: boolean }) {
  const hi = (on: boolean) => { fetchNui("admin:highlightProp", { propId: p.id, on }); setPeek(on); };
  useEffect(() => () => { fetchNui("admin:highlightProp", { propId: p.id, on: false }); setPeek(false); }, [p.id]);
  return (
    <Badge
      variant="outline"
      className="gap-1.5"
      onMouseEnter={() => hi(true)}
      onMouseLeave={() => hi(false)}
    >
      {virtual && <Sparkles className="h-3 w-3 text-primary" />}
      <span>{propLabel(p)} <span className="opacity-45 tabular-nums">#{p.id}</span></span>
      <button title={_L("admin.reposition")} onClick={() => { hi(false); fetchNui("admin:editProp", { propId: p.id, restaurantId, section }); }}>
        <Pencil className="h-3 w-3" />
      </button>
      <button title={_L("admin.remove")} onClick={() => { hi(false); act("admin:removeProp", { propId: p.id }); }}>
        <Trash2 className="h-3 w-3" />
      </button>
    </Badge>
  );
}

type Focus = { restaurant?: number; section?: string };
type BlipCfg = { enabled?: boolean; sprite?: number; color?: number; scale?: number };
/** One framework job with its grade ladder, as the server's `jobs` list reports it. */
export type Job = { name: string; label?: string; grades?: { grade: number; label?: string; isboss?: boolean }[] };
type JobCfg = { job: string | null; jobLabel: string | null };
type Props = { restaurants: any[]; players: any[]; groups: string[]; refresh: () => void; focus?: Focus; appTheme?: ThemeConfig | null; onDetailChange?: (open: boolean) => void; renderTargets?: { key: string; w: number; h: number }[]; defaultBlip?: BlipCfg; jobs?: Job[]; jobsAvailable?: boolean };

export default function Restaurants({ restaurants, players, groups, refresh, focus, appTheme, onDetailChange, renderTargets, defaultBlip, jobs, jobsAvailable }: Props) {
  // After a placement reopen, `focus.restaurant` drops us straight back into that
  // restaurant (and `focus.section` scrolls to its stations/seating).
  const [selectedId, setSelectedId] = useState<number | null>(focus?.restaurant ?? null);
  // Optimistic per-restaurant theme edits. The theme editor auto-saves to the DB,
  // but the open-payload `restaurants` array stays stale; we mirror the live seed
  // here so leaving and reopening a detail re-applies the CURRENT theme (not the
  // one the panel opened with). Survives detail unmount — this component stays up.
  const [themeEdits, setThemeEdits] = useState<Record<number, ThemeConfig>>({});
  // Same optimistic mirror for renames — the rename auto-saves without refreshing
  // the panel (a refresh would remount the field mid-typing), so the detail header
  // and the list row read the live label from here.
  const [nameEdits, setNameEdits] = useState<Record<number, string>>({});
  // And the same for the map blip — null is a MEANINGFUL value here ("follow the
  // server default"), so presence is tested with `in`, never truthiness.
  const [blipEdits, setBlipEdits] = useState<Record<number, BlipCfg | null>>({});
  // And for the assigned JOB — same reason (the Job card auto-saves without refreshing
  // the panel), and `null` is meaningful here too ("unassigned"), so presence is `in`.
  const [jobEdits, setJobEdits] = useState<Record<number, JobCfg>>({});
  const withEdits = (r: any) => (r && (themeEdits[r.id] || nameEdits[r.id] || r.id in blipEdits || r.id in jobEdits)
    ? {
        ...r,
        theme: themeEdits[r.id] || r.theme,
        label: nameEdits[r.id] || r.label,
        job: r.id in jobEdits ? jobEdits[r.id].job : r.job,
        jobLabel: r.id in jobEdits ? jobEdits[r.id].jobLabel : r.jobLabel,
        jobMissing: r.id in jobEdits ? (jobEdits[r.id].job ? undefined : true) : r.jobMissing,
        // The internal key is re-derived from the label server-side; mirror the
        // same slug so the header's codename doesn't read stale until a refetch.
        name: nameEdits[r.id] ? (restSlug(nameEdits[r.id]) || r.name) : r.name,
        blip: r.id in blipEdits ? blipEdits[r.id] : r.blip,
      }
    : r);
  const selected = withEdits(restaurants.find((r) => r.id === selectedId) || null);

  // Tell the shell whether a single restaurant's detail is open, so it can drop the
  // top-level admin tab strip (Restaurants / Recipes / Settings) while you're inside
  // one restaurant — the detail has its own back button + header, and the two levels
  // of tabs stacked together are what read as confusing.
  const isDetail = !!selected;
  useEffect(() => {
    onDetailChange?.(isDetail);
    return () => onDetailChange?.(false);
  }, [isDetail]);

  const act = async (event: string, payload: any) => { await fetchNui(event, payload); await refresh(); };

  if (selected) {
    return (
      <Detail
        r={selected}
        players={players}
        groups={groups}
        act={act}
        onBack={() => setSelectedId(null)}
        focusSection={selected.id === focus?.restaurant ? focus?.section : undefined}
        appTheme={appTheme}
        onThemeChange={(t) => setThemeEdits((m) => ({ ...m, [selected.id]: t }))}
        onNameChange={(l) => setNameEdits((m) => ({ ...m, [selected.id]: l }))}
        renderTargets={renderTargets}
        defaultBlip={defaultBlip}
        onBlipChange={(b) => setBlipEdits((m) => ({ ...m, [selected.id]: b }))}
        jobs={jobs}
        jobsAvailable={jobsAvailable}
        onJobChange={(j) => setJobEdits((m) => ({ ...m, [selected.id]: j }))}
      />
    );
  }
  return <List restaurants={restaurants.map(withEdits)} act={act} onOpen={setSelectedId} />;
}

// internal key is derived from the display label — admins never type a raw slug
const restSlug = (s: string) => (s || "").toLowerCase().replace(/[^a-z0-9]+/g, "_").replace(/^_+|_+$/g, "");

function List({ restaurants, act, onOpen }: { restaurants: any[]; act: (e: string, p: any) => void; onOpen: (id: number) => void }) {
  const [label, setLabel] = useState("");
  return (
    <div className="flex min-h-0 flex-1 flex-col gap-3">
      <div className="flex shrink-0 items-end gap-2 rounded-lg border border-border p-3">
        <Field label={_L("admin.display_label")} className="flex-1"><Input value={label} onChange={(e) => setLabel(e.target.value)} placeholder={_L("admin.display_label_hint")} /></Field>
        <Button onClick={async () => { const name = restSlug(label); if (!name) return; await act("admin:create", { name, label: label.trim() }); setLabel(""); }}>
          <Plus className="h-4 w-4" /> {_L("admin.create")}
        </Button>
      </div>

      <div className="min-h-0 flex-1 space-y-2 overflow-y-auto pr-1 pb-4">
        {restaurants.length === 0 && <div className="py-6 text-center text-sm text-muted-foreground">{_L("admin.no_restaurants")}</div>}
        {restaurants.map((r) => (
          <button
            key={r.id}
            onClick={() => onOpen(r.id)}
            className="flex w-full items-center justify-between gap-3 rounded-lg border border-border/80 bg-card p-3 text-left transition-colors hover:border-primary/50 hover:bg-accent/60"
          >
            <div className="flex min-w-0 items-center gap-3">
              {/* franchise monogram, tinted by ITS theme seed (not the panel's) */}
              <div
                className="grid h-10 w-10 shrink-0 place-items-center rounded-md font-display text-lg font-bold"
                style={{
                  // "#rrggbb29" = the seed at ~16% alpha (no color-mix in CEF)
                  backgroundColor: r.theme?.primary ? r.theme.primary + "29" : "rgb(var(--brand) / 0.16)",
                  color: r.theme?.primary || "rgb(var(--brand))",
                }}
              >
                {(r.label?.trim()[0] || "•").toUpperCase()}
              </div>
              <div className="min-w-0">
                <div className="flex items-center gap-2">
                  <span className="truncate font-semibold">{r.label}</span>
                  <Badge variant="secondary">#{r.id}</Badge>
                  {r.owner ? <Badge>{_L("admin.owned")}</Badge> : <Badge variant="outline">{_L("admin.server_owned")}</Badge>}
                  {/* A restaurant REQUIRES a job now — nobody can be hired, paid or
                      given a permission without one — so an unassigned one is flagged
                      in the list rather than only inside its own settings tab. */}
                  {r.jobMissing && (
                    <Badge variant="destructive" className="gap-1">
                      <TriangleAlert className="h-3 w-3" /> {_L("admin.job_missing_badge")}
                    </Badge>
                  )}
                </div>
                <div className="truncate text-xs text-muted-foreground">
                  {_L("admin.restaurant_summary", money(r.balance), r.propCount, r.hasCounter ? _L("admin.counter_set") : _L("admin.no_counter"))}
                </div>
              </div>
            </div>
            <ChevronRight className="h-4 w-4 shrink-0 text-muted-foreground" />
          </button>
        ))}
      </div>
    </div>
  );
}

function Detail({ r, players, groups, act, onBack, focusSection, appTheme, onThemeChange, onNameChange, renderTargets, defaultBlip, onBlipChange, jobs, jobsAvailable, onJobChange }: { r: any; players: any[]; groups: string[]; act: (e: string, p: any) => void; onBack: () => void; focusSection?: string; appTheme?: ThemeConfig | null; onThemeChange?: (t: ThemeConfig) => void; onNameChange?: (label: string) => void; renderTargets?: { key: string; w: number; h: number }[]; defaultBlip?: BlipCfg; onBlipChange?: (b: BlipCfg | null) => void; jobs?: Job[]; jobsAvailable?: boolean; onJobChange?: (j: JobCfg) => void }) {
  const props: any[] = r.props || [];
  const byType = (t: string) => props.filter((p) => p.prop_type === t);
  const [confirmDelete, setConfirmDelete] = useState(false);
  // Per-station placement mode: physical world prop vs. virtual point (opens the
  // station inside the kitchen shell). Toggled per row, drives the Place button.
  const [modes, setModes] = useState<Record<string, "physical" | "virtual">>({});
  const setMode = (k: string, m: "physical" | "virtual") => setModes((prev) => ({ ...prev, [k]: m }));
  const stationsRef = useRef<HTMLDivElement>(null);
  const seatingRef = useRef<HTMLDivElement>(null);
  const countersRef = useRef<HTMLDivElement>(null);

  // Scroll the just-used section into view when reopened from a placement flow.
  // Virtual placement lives in the stations card now, so "virtual" lands there.
  useEffect(() => {
    if (!focusSection) return;
    const el = focusSection === "seating" ? seatingRef.current
      : focusSection === "counters" ? countersRef.current
      : stationsRef.current;
    const t = setTimeout(() => el?.scrollIntoView({ behavior: "smooth", block: "start" }), 60);
    return () => clearTimeout(t);
  }, [focusSection]);

  // The admin panel keeps its OWN app theme throughout — opening a restaurant does
  // NOT reskin /restaurants to that franchise's colors (a restaurant's theme only
  // skins ITS OWN in-game panels). App already stamps the app theme on every admin
  // `setView`; we re-assert it here on mount and after every in-detail refresh so
  // nothing (e.g. a stale layout effect) can snap it to a restaurant seed. The
  // restaurant's ThemeEditor runs `scoped` so its edits preview in a contained chip
  // rather than hijacking this panel. useLayoutEffect stamps before paint (no flash).
  useLayoutEffect(() => { applyTheme(appTheme); }, [r, appTheme]);

  return (
    <div className="flex min-h-0 flex-1 flex-col gap-3">
      {/* header */}
      <div className="flex shrink-0 items-center justify-between gap-3">
        <div className="flex items-center gap-2">
          <Button variant="ghost" size="icon" onClick={onBack}><ArrowLeft className="h-4 w-4" /></Button>
          <div>
            <div className="flex items-center gap-2">
              <h3 className="font-display text-base font-bold tracking-tight">{r.label}</h3>
              {/* the row id identifies a restaurant here — its internal `name` slug is
                  a codename and is never printed in the UI */}
              <Badge variant="secondary">#{r.id}</Badge>
            </div>
            <p className="text-xs text-muted-foreground">{_L("admin.balance", money(r.balance))}</p>
          </div>
        </div>
        {confirmDelete ? (
          <div className="flex items-center gap-2">
            <span className="text-xs text-muted-foreground">{_L("admin.delete_confirm", r.label)}</span>
            <Button variant="ghost" size="sm" onClick={() => setConfirmDelete(false)}>{_L("admin.cancel")}</Button>
            <Button variant="destructive" size="sm" onClick={() => { act("admin:delete", { id: r.id }); onBack(); }}>
              <Trash2 className="h-4 w-4" /> {_L("admin.confirm")}
            </Button>
          </div>
        ) : (
          <Button variant="destructive" size="sm" onClick={() => setConfirmDelete(true)}>
            <Trash2 className="h-4 w-4" /> {_L("admin.delete")}
          </Button>
        )}
      </div>

      <Tabs defaultValue="overview" className="flex min-h-0 flex-1 flex-col">
        <TabsList className="shrink-0">
          <TabsTrigger value="overview">{_L("admin.tab_overview")}</TabsTrigger>
          <TabsTrigger value="settings">{_L("admin.tab_settings")}</TabsTrigger>
        </TabsList>

        <TabsContent value="overview" className="min-h-0 flex-1 space-y-3 overflow-y-auto pr-1 pb-4">
        {/* ownership + NPC customer spawn point */}
        <div className="grid grid-cols-2 gap-3">
          <div className="rounded-lg border border-border p-3">
            <div className="mb-2 flex items-center gap-2 text-sm font-semibold"><UserCog className="h-4 w-4 text-primary" /> {_L("admin.ownership")}</div>
            <div className="mb-2 text-xs text-muted-foreground">
              {r.owner ? <>{_L("admin.owned_by", "")}<span className="font-mono">{r.owner}</span></> : _L("admin.currently_server_owned")}
            </div>
            <select
              className="h-9 w-full rounded-md border border-input bg-muted/50 px-2 text-sm transition-colors focus-visible:border-primary/60 focus-visible:outline-none"
              value=""
              onChange={(e) => {
                const v = e.target.value;
                if (v === "") return;
                act("admin:setOwner", { id: r.id, target: v === "__server__" ? false : Number(v) });
                e.target.value = "";
              }}
            >
              <option value="" disabled>{_L("admin.change_owner")}</option>
              <option value="__server__">{_L("admin.set_server_owned")}</option>
              {players.map((p: any) => <option key={p.id} value={p.id}>{p.name} [{p.id}]</option>)}
            </select>
          </div>
          {/* NPC customer spawn point — where AI customers appear before walking up to
              queue. Without it they spawn a fixed distance back and can get stuck. */}
          <div className="rounded-lg border border-border p-3">
            <div className="mb-2 flex items-center gap-2 text-sm font-semibold"><Users className="h-4 w-4 text-primary" /> {_L("admin.npc_spawn")}</div>
            <div className="flex items-center justify-between gap-2">
              <span className="text-xs text-muted-foreground">{r.hasNpcSpawn ? _L("admin.npc_spawn_placed") : _L("admin.no_npc_spawn")}</span>
              <Button size="sm" variant="outline" onClick={() => fetchNui("admin:placeNpcSpawn", { id: r.id })}>
                <MapPin className="h-3.5 w-3.5" /> {r.hasNpcSpawn ? _L("admin.reposition") : _L("admin.place")}
              </Button>
            </div>
          </div>
        </div>

        {/* stations — each type places EITHER a physical world prop or a virtual
            point (an invisible anchor that opens the station inside the kitchen
            shell). The per-row toggle picks the mode; the shell control up top is
            the prerequisite for virtual points (one shell per restaurant). */}
        <div ref={stationsRef} className="rounded-lg border border-border p-3">
          <div className="mb-2 flex items-center justify-between gap-2">
            <div className="text-sm font-semibold">{_L("admin.stations")}</div>
            {/* NOT gated on a counter any more: with none placed, the flow runs the
                register placement first and rolls straight into the shell (see
                StartShellPlacement) — a greyed-out button just left the admin
                guessing what the missing prerequisite was. */}
            <Button size="sm" variant="outline" onClick={() => fetchNui("admin:placeShell", { id: r.id })}>
              <Building2 className="h-3.5 w-3.5" /> {r.hasShell ? _L("admin.adjust_shell") : _L("admin.place_shell")}
            </Button>
          </div>
          <p className="mb-3 text-[11px] text-muted-foreground">
            {!r.hasCounter ? _L("admin.shell_needs_counter") : r.hasShell ? _L("admin.shell_placed") : _L("admin.no_shell")}
          </p>
          <div className="space-y-3">
            {/* REGISTER — the same row shape as every other station, and it leads the
                list because it's what a restaurant needs first (the first physical
                one anchors the map blip, the kitchen shell and the NPC queue). It is
                NOT a STATIONS() entry: physical/virtual here mean their own prop
                types (`counter` / `virtual_register`) with their own placement
                callbacks, not the generic prop/virtual_point pair the rows below
                share — a virtual register opens the fullscreen NUI register rather
                than fading the player into the shell. */}
            {(() => {
              const physical = byType("counter");
              const virtual = byType("virtual_register");
              const isVirtual = (modes.__register || "physical") === "virtual";
              return (
                <div ref={countersRef}>
                  <div className="mb-1.5 flex items-center justify-between gap-2">
                    <div className="flex items-center gap-2 text-sm">
                      <Receipt className="h-4 w-4 text-muted-foreground" />
                      {_L("admin.counters")}
                      <Badge variant="secondary">{physical.length + virtual.length}</Badge>
                    </div>
                    <div className="flex items-center gap-1.5">
                      <div className="flex rounded-md border border-border p-0.5 text-[11px]">
                        <button
                          className={`rounded px-2 py-0.5 transition-colors ${!isVirtual ? "bg-primary text-primary-foreground" : "text-muted-foreground hover:text-foreground"}`}
                          onClick={() => setMode("__register", "physical")}
                        >{_L("admin.mode_physical")}</button>
                        <button
                          className={`rounded px-2 py-0.5 transition-colors ${isVirtual ? "bg-primary text-primary-foreground" : "text-muted-foreground hover:text-foreground"}`}
                          onClick={() => setMode("__register", "virtual")}
                        >{_L("admin.mode_virtual")}</button>
                      </div>
                      <Button
                        size="sm"
                        variant="outline"
                        onClick={() => fetchNui(isVirtual ? "admin:setVirtualRegister" : "admin:setCounter", { id: r.id })}
                      >
                        {isVirtual ? <Sparkles className="h-3.5 w-3.5" /> : <Plus className="h-3.5 w-3.5" />} {_L("admin.place")}
                      </Button>
                    </div>
                  </div>
                  {physical.length + virtual.length > 0 ? (
                    <div className="flex flex-wrap gap-1.5">
                      {physical.map((p) => (
                        <PropChip key={p.id} p={p} act={act} restaurantId={r.id} section="counters" />
                      ))}
                      {virtual.map((p) => (
                        <PropChip key={p.id} p={p} act={act} restaurantId={r.id} section="counters" virtual />
                      ))}
                    </div>
                  ) : (
                    <p className="text-[11px] text-muted-foreground">{_L("admin.counters_hint")}</p>
                  )}
                </div>
              );
            })()}
            {STATIONS().map((s) => {
              const physical = byType(s.key);
              const virtual = props.filter((p) => p.prop_type === "virtual_point" && p.target === s.key);
              const isVirtual = !s.physicalOnly && (modes[s.key] || "physical") === "virtual";
              const Icon = s.icon;
              return (
                <div key={s.key}>
                  <div className="mb-1.5 flex items-center justify-between gap-2">
                    <div className="flex items-center gap-2 text-sm">
                      <Icon className="h-4 w-4 text-muted-foreground" />
                      {s.label}
                      <Badge variant="secondary">{physical.length + virtual.length}</Badge>
                    </div>
                    <div className="flex items-center gap-1.5">
                      {/* physical | virtual placement toggle */}
                      {!s.physicalOnly && (
                      <div className="flex rounded-md border border-border p-0.5 text-[11px]">
                        <button
                          className={`rounded px-2 py-0.5 transition-colors ${!isVirtual ? "bg-primary text-primary-foreground" : "text-muted-foreground hover:text-foreground"}`}
                          onClick={() => setMode(s.key, "physical")}
                        >{_L("admin.mode_physical")}</button>
                        <button
                          className={`rounded px-2 py-0.5 transition-colors ${isVirtual ? "bg-primary text-primary-foreground" : "text-muted-foreground hover:text-foreground"}`}
                          onClick={() => setMode(s.key, "virtual")}
                        >{_L("admin.mode_virtual")}</button>
                      </div>
                      )}
                      <Button
                        size="sm"
                        variant="outline"
                        disabled={isVirtual && !r.hasShell}
                        onClick={() => isVirtual
                          ? fetchNui("admin:placeVirtualPoint", { id: r.id, target: s.key })
                          : fetchNui("admin:placeProp", { id: r.id, prop_type: s.key })}
                      >
                        {isVirtual ? <Sparkles className="h-3.5 w-3.5" /> : <Plus className="h-3.5 w-3.5" />} {_L("admin.place")}
                      </Button>
                    </div>
                  </div>
                  {isVirtual && !r.hasShell && (
                    <p className="mb-1 text-[11px] text-muted-foreground">{_L("admin.virtual_needs_shell")}</p>
                  )}
                  {(physical.length > 0 || virtual.length > 0) && (
                    <div className="flex flex-wrap gap-1.5">
                      {physical.map((p) => (
                        <PropChip key={p.id} p={p} act={act} restaurantId={r.id} section="stations" />
                      ))}
                      {virtual.map((p) => (
                        <PropChip key={p.id} p={p} act={act} restaurantId={r.id} section="stations" virtual />
                      ))}
                    </div>
                  )}
                </div>
              );
            })}
          </div>
          <p className="mt-3 text-[11px] text-muted-foreground">
            {_L("admin.stations_hint")}
          </p>
        </div>

        {/* seating — invisible sit anchors; players sit on existing furniture */}
        <div ref={seatingRef} className="rounded-lg border border-border p-3">
          <div className="mb-1.5 flex items-center justify-between">
            <div className="flex items-center gap-2 text-sm font-semibold">
              <Armchair className="h-4 w-4 text-muted-foreground" /> {_L("admin.seating")}
              <Badge variant="secondary">{byType("seat").length}</Badge>
            </div>
            <Button size="sm" variant="outline" onClick={() => fetchNui("admin:placeSeat", { id: r.id })}>
              <Plus className="h-3.5 w-3.5" /> {_L("admin.place")}
            </Button>
          </div>
          {byType("seat").length > 0 ? (
            <div className="flex flex-wrap gap-1.5">
              {byType("seat").map((p) => (
                <PropChip key={p.id} p={p} act={act} restaurantId={r.id} section="seating" />
              ))}
            </div>
          ) : (
            <p className="text-[11px] text-muted-foreground">
              {_L("admin.seating_hint")}
            </p>
          )}
        </div>

        {/* delivery doors — where NPC delivery orders send a driver. The driver
            knocks and a resident comes out to take the bag; with none placed, NPC
            deliveries fall back to a random point near the restaurant. */}
        <div className="rounded-lg border border-border p-3">
          <div className="mb-1.5 flex items-center justify-between">
            <div className="flex items-center gap-2 text-sm font-semibold">
              <DoorOpen className="h-4 w-4 text-muted-foreground" /> {_L("admin.doors")}
              <Badge variant="secondary">{byType("delivery_door").length}</Badge>
            </div>
            <Button size="sm" variant="outline" onClick={() => fetchNui("admin:placeDeliveryDoor", { id: r.id })}>
              <Plus className="h-3.5 w-3.5" /> {_L("admin.place")}
            </Button>
          </div>
          {byType("delivery_door").length > 0 ? (
            <div className="flex flex-wrap gap-1.5">
              {byType("delivery_door").map((p) => (
                <PropChip key={p.id} p={p} act={act} restaurantId={r.id} section="seating" />
              ))}
            </div>
          ) : (
            <p className="text-[11px] text-muted-foreground">
              {_L("admin.doors_hint")}
            </p>
          )}
        </div>

        </TabsContent>

        {/* per-restaurant settings — branding (per-texture packaging photos, same
            editor as the boss panel). Server-wide settings live in the top-level
            Settings tab; this is scoped to THIS restaurant. */}
        <TabsContent value="settings" className="min-h-0 flex-1 space-y-3 overflow-y-auto pr-1 pb-4">
          {/* Rename — admin-gated server-side; the owner renames their own place
              from the boss panel's Brand tab. Saves WITHOUT `act` on purpose: act
              refreshes the whole panel, which would remount this field mid-typing. */}
          <NameEditor id={r.id} label={r.label || ""} event="admin:setName" onChange={onNameChange} />

          <ThemeEditor id={r.id} theme={r.theme} event="admin:setTheme" onChange={onThemeChange} scoped />

          {/* WHO WORKS HERE. Assigning the job is an admin act (it decides who has
              power over the business), which is why it lives here and not in the boss
              panel — the boss only edits what each GRADE of it may do and earns. */}
          <JobEditor r={r} jobs={jobs} jobsAvailable={jobsAvailable} onChange={onJobChange} />

          <BlipEditor r={r} defaultBlip={defaultBlip} onChange={onBlipChange} />

          {/* recipe access groups — what this restaurant may cook & sell */}
          <div className="rounded-lg border border-border p-3">
            <div className="mb-1 flex items-center gap-2 text-sm font-semibold">
              <Tags className="h-4 w-4 text-primary" /> {_L("admin.groups_title")}
            </div>
            <p className="mb-3 text-[11px] text-muted-foreground">{_L("admin.groups_hint")}</p>
            <GroupsEditor r={r} groups={groups} act={act} />
          </div>

          <div className="rounded-lg border border-border p-3">
            <div className="mb-3 flex items-center gap-2 text-sm font-semibold">
              <ImageIcon className="h-4 w-4 text-primary" /> {_L("admin.branding")}
            </div>
            <Branding
              id={r.id}
              brand={r.brand_image || ""}
              brandImages={r.brand_images || {}}
              phoneImage={r.phone_image || ""}
              event="admin:setBrandImage"
              renderTargets={renderTargets}
            />
          </div>
        </TabsContent>
      </Tabs>
    </div>
  );
}

/**
 * The restaurant's access-group chips: remove with the chip's ×, add from a real
 * DROPDOWN of every group already in use — with the typed text offered as a "create
 * new" row so a brand-new group is still one action away. This deliberately does NOT
 * use `<input list>` + `<datalist>`: FiveM's CEF never renders the datalist popup, so
 * that control read as a plain text box with no visible choices at all.
 * Each add/remove saves immediately — a chip edit is a discrete action, no debounce.
 */
function GroupsEditor({ r, groups, act }: { r: any; groups: string[]; act: (e: string, p: any) => void }) {
  const [draft, setDraft] = useState("");
  const [open, setOpen] = useState(false);
  const box = useRef<HTMLDivElement>(null);
  const current: string[] = r.groups || [];
  const save = (next: string[]) => act("admin:setGroups", { id: r.id, groups: next });
  const add = (g: string) => {
    const name = g.trim();
    if (!name || current.includes(name)) { setDraft(""); setOpen(false); return; }
    save([...current, name]);
    setDraft("");
    setOpen(false);
  };

  // Click-away closes the menu (there's no portal/overlay layer in this panel).
  useEffect(() => {
    if (!open) return;
    const onDown = (e: MouseEvent) => {
      if (box.current && !box.current.contains(e.target as Node)) setOpen(false);
    };
    document.addEventListener("mousedown", onDown);
    return () => document.removeEventListener("mousedown", onDown);
  }, [open]);

  const q = draft.trim().toLowerCase();
  const suggestions = groups
    .filter((g) => !current.includes(g))
    .filter((g) => !q || g.toLowerCase().includes(q));
  // Offer to create what was typed only when it isn't already an exact option.
  const canCreate = !!draft.trim()
    && !current.some((g) => g.toLowerCase() === q)
    && !groups.some((g) => g.toLowerCase() === q);

  return (
    <div className="space-y-2">
      <div className="flex flex-wrap items-center gap-1.5">
        {current.length === 0 && <span className="text-xs text-muted-foreground">{_L("admin.groups_none")}</span>}
        {current.map((g) => (
          <Badge key={g} variant="secondary" className="gap-1.5">
            {g}
            <button onClick={() => save(current.filter((x) => x !== g))}><X className="h-3 w-3" /></button>
          </Badge>
        ))}
      </div>
      <div ref={box} className="relative max-w-72">
        <div className="flex items-center gap-2">
          <Input
            className="h-8 flex-1"
            placeholder={_L("admin.groups_placeholder")}
            value={draft}
            onFocus={() => setOpen(true)}
            onChange={(e) => { setDraft(e.target.value); setOpen(true); }}
            onKeyDown={(e) => {
              if (e.key === "Enter") add(draft);
              else if (e.key === "Escape") setOpen(false);
            }}
          />
          <Button size="sm" variant="outline" className="shrink-0 px-2" onClick={() => setOpen((v) => !v)}>
            <ChevronDown className="h-3.5 w-3.5" />
          </Button>
          <Button size="sm" variant="outline" className="shrink-0" onClick={() => add(draft)} disabled={!draft.trim()}>
            <Plus className="h-3.5 w-3.5" /> {_L("admin.groups_add")}
          </Button>
        </div>
        {open && (suggestions.length > 0 || canCreate) && (
          <div className="absolute left-0 right-0 z-20 mt-1 max-h-52 overflow-y-auto rounded-md border border-border bg-popover shadow-md">
            {suggestions.map((g) => (
              <button key={g} className="block w-full px-3 py-2 text-left text-sm hover:bg-accent" onClick={() => add(g)}>
                {g}
              </button>
            ))}
            {canCreate && (
              <>
                {suggestions.length > 0 && <div className="my-1 border-t border-border" />}
                <button className="flex w-full items-center gap-1.5 px-3 py-2 text-left text-sm hover:bg-accent"
                  onClick={() => add(draft)}>
                  <Plus className="h-3.5 w-3.5 text-muted-foreground" /> {_L("admin.groups_create", draft.trim())}
                </button>
              </>
            )}
          </div>
        )}
      </div>
    </div>
  );
}

/**
 * The FRAMEWORK JOB this restaurant employs through. Everything about employment hangs
 * off it: staff are whoever holds the job, and permissions / commission / salary are
 * per GRADE of it (edited by the boss in the management panel's Ranks tab). A
 * restaurant with none can employ nobody, so the card says so loudly instead of just
 * reading empty. Assigning one SEEDS the ranks from the job's grade ladder server-side.
 *
 * Shaped like BlipEditor: auto-saves debounced (no save buttons in this app) and
 * WITHOUT `act` — a panel refresh would remount the card mid-change — so the parent
 * mirrors the live value through `onChange`.
 *
 * `jobsAvailable = false` means there is no framework job system: the list is then the
 * admin's OWN `jobs` setting (Settings → Jobs), and saying so is the difference between
 * "author some jobs first" and an empty picker that reads as broken.
 */
function JobEditor({ r, jobs, jobsAvailable, onChange }: {
  r: any; jobs?: Job[]; jobsAvailable?: boolean; onChange?: (j: JobCfg) => void;
}) {
  const list = jobs || [];
  const [job, setJob] = useState<string>(r.job || "");
  // The label the picker knows for the chosen name, so the mirrored value the list row
  // reads is complete without waiting for the server's reply.
  const labelFor = (name: string) => list.find((j) => j.name === name)?.label || name || null;
  const status = useAutoSave(() => {
    onChange?.({ job: job || null, jobLabel: job ? labelFor(job) : null });
    // "" clears it server-side; the ranks are deliberately left behind so re-assigning
    // the same job restores the pay the boss configured.
    return fetchNui("admin:setJob", { id: r.id, job });
  }, [job]);

  const chosen = list.find((j) => j.name === job);
  const grades = chosen?.grades || [];

  return (
    <Card>
      <CardContent className="pt-4">
        <div className="mb-1 flex items-center justify-between gap-2">
          <h3 className="flex items-center gap-2 text-sm font-semibold">
            <Briefcase className="h-4 w-4 text-primary" /> {_L("admin.job_title")}
          </h3>
          <span className="flex shrink-0 items-center gap-1 text-xs text-muted-foreground">
            {status === "saving" ? (
              <><Loader2 className="h-3 w-3 animate-spin" /> {_L("theme.saving")}</>
            ) : status === "saved" ? (
              <><Check className="h-3 w-3 text-primary" /> {_L("theme.saved")}</>
            ) : null}
          </span>
        </div>
        <p className="mb-3 text-[11px] text-muted-foreground">{_L("admin.job_hint")}</p>

        {list.length === 0 ? (
          <p className="rounded-md border border-dashed border-border px-3 py-2 text-[11px] text-muted-foreground">
            {jobsAvailable === false ? _L("admin.job_none_standalone") : _L("admin.job_none_framework")}
          </p>
        ) : (
          <Field label={_L("admin.job_field")}>
            <select
              value={job}
              onChange={(e) => setJob(e.target.value)}
              className="h-9 w-full rounded-md border border-input bg-muted/50 px-2 text-sm transition-colors focus-visible:border-primary/60 focus-visible:outline-none"
            >
              {/* Unassigning is a real choice (a restaurant being decommissioned), and
                  the ranks survive it — re-assigning the same job restores the pay. */}
              <option value="">{_L("admin.job_unassigned")}</option>
              {list.map((j) => (
                <option key={j.name} value={j.name}>{j.label || j.name}</option>
              ))}
            </select>
          </Field>
        )}

        {!job ? (
          <p className="mt-2 flex items-center gap-1.5 text-[11px] text-destructive">
            <TriangleAlert className="h-3.5 w-3.5" /> {_L("admin.job_missing_hint")}
          </p>
        ) : (
          <div className="mt-2 flex flex-wrap items-center gap-1.5">
            <span className="tape text-muted-foreground">{_L("admin.job_grades")}</span>
            {grades.length === 0 ? (
              <span className="text-[11px] text-muted-foreground">{_L("admin.job_no_grades")}</span>
            ) : (
              grades.map((g) => (
                <Badge key={g.grade} variant={g.isboss ? "default" : "outline"} className="gap-1">
                  <span className="font-mono tabular-nums opacity-60">{g.grade}</span>
                  {g.label || String(g.grade)}
                </Badge>
              ))
            )}
          </div>
        )}
      </CardContent>
    </Card>
  );
}

/**
 * This restaurant's own MAP BLIP — sprite / colour / scale / shown-at-all, sitting
 * on the same anchor everything else pins to (the first register placed, or the
 * first prop with none). A restaurant is created with the column EMPTY, meaning
 * "follow the server-wide Settings → Map Blip default", which the server resolves
 * when it builds the sync — so "Use server default" is a real reset, not a blank
 * blip, and this card is only ever how a restaurant comes to DIFFER from that
 * default. (Creation used to seed a copy of the default here, which shadowed the
 * setting permanently — see ReleaseCopiedBlips in modules/admin/server.lua.) Auto-saves debounced (this app has
 * no save buttons) and saves WITHOUT `act`: a panel refresh would remount the
 * fields mid-edit, so the parent mirrors the live value through `onChange`.
 */
function BlipEditor({ r, defaultBlip, onChange }: { r: any; defaultBlip?: BlipCfg; onChange?: (b: BlipCfg | null) => void }) {
  const fallback: BlipCfg = { enabled: true, sprite: 93, color: 1, scale: 0.8, ...(defaultBlip || {}) };
  const seed = (r.blip || fallback) as BlipCfg;
  // `own` is what the column holds: false = following the server default. The
  // fields stay editable while following and show the default's numbers, so a
  // first edit is one gesture (touching anything claims the override).
  const [own, setOwn] = useState(!!r.blip);
  const [cfg, setCfg] = useState<BlipCfg>({
    enabled: seed.enabled !== false,
    sprite: Number(seed.sprite ?? 93),
    color: Number(seed.color ?? 1),
    scale: Number(seed.scale ?? 0.8),
  });

  const status = useAutoSave(() => {
    const blip = own ? cfg : null;
    onChange?.(blip);
    return fetchNui("admin:setBlip", { id: r.id, blip });
  }, [own, cfg]);

  // Any field edit claims the override; the reset button hands it back and pulls
  // the default's numbers into the fields so what's shown is what's live.
  const set = (patch: BlipCfg) => { setOwn(true); setCfg((c) => ({ ...c, ...patch })); };
  const reset = () => {
    setOwn(false);
    setCfg({ enabled: fallback.enabled !== false, sprite: Number(fallback.sprite ?? 93), color: Number(fallback.color ?? 1), scale: Number(fallback.scale ?? 0.8) });
  };

  return (
    <Card>
      <CardContent className="pt-4">
        <div className="mb-1 flex items-center justify-between gap-2">
          <h3 className="flex items-center gap-2 text-sm font-semibold">
            <MapIcon className="h-4 w-4 text-primary" /> {_L("admin.blip_title")}
          </h3>
          <span className="flex shrink-0 items-center gap-1 text-xs text-muted-foreground">
            {status === "saving" ? (
              <><Loader2 className="h-3 w-3 animate-spin" /> {_L("theme.saving")}</>
            ) : status === "saved" ? (
              <><Check className="h-3 w-3 text-primary" /> {_L("theme.saved")}</>
            ) : (
              own ? _L("admin.blip_custom") : _L("admin.blip_following")
            )}
          </span>
        </div>
        <p className="mb-3 text-[11px] text-muted-foreground">{_L("admin.blip_hint")}</p>

        <div className="mb-3 flex items-center justify-between gap-2">
          <Toggle checked={cfg.enabled !== false} onChange={(v) => set({ enabled: v })} label={_L("admin.blip_show")} />
          {own && (
            <Button variant="ghost" size="sm" onClick={reset}>
              <RotateCcw className="h-3.5 w-3.5" /> {_L("admin.blip_reset")}
            </Button>
          )}
        </div>

        <div className="grid grid-cols-3 gap-3">
          <NumberField label={_L("admin.blip_sprite")} value={Number(cfg.sprite)} min={1} onChange={(v) => set({ sprite: v })} />
          <NumberField label={_L("admin.blip_colour")} value={Number(cfg.color)} min={0} onChange={(v) => set({ color: v })} />
          <NumberField label={_L("admin.blip_scale")} value={Number(cfg.scale)} min={0.1} step={0.1} onChange={(v) => set({ scale: v })} />
        </div>
      </CardContent>
    </Card>
  );
}
