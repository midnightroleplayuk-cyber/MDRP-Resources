import { useState } from "react";
import { fetchNui } from "@/lib/nui";
import { useAutoSave, type SaveStatus } from "@/lib/autosave";
import { Button } from "@/components/ui/button";
import { Field, TextField, NumberField, Toggle, Select } from "@/components/form";
import { Input } from "@/components/ui/input";
import ItemPicker, { type Item } from "@/components/ItemPicker";
import { Badge } from "@/components/ui/badge";
import { ThemeEditor } from "@/components/Branding";
import { type ThemeConfig } from "@/lib/theme";
import { cn } from "@/lib/utils";
import { _L } from "@/lib/locale";
import {
  Settings2, Coins, Users, DollarSign, MapPin, Plus, Trash2, Check, Loader2, RotateCcw, Palette, PersonStanding, Utensils, Flame,
  Package, Lock, Briefcase, CalendarClock, ChevronDown, ChevronRight, Truck, MapPinned, Pencil, Cookie,
} from "lucide-react";

// Every permission there is, in the order the server declares them (core's
// PERMISSIONS). Used by the Jobs group's "what a new grade gets" editor — the
// per-RESTAURANT rank editor lives in the management panel and renders the list the
// server sends it, so this copy is only ever for the server-wide DEFAULT.
const PERMISSIONS = [
  "cook", "sell", "manage_menu", "manage_props", "manage_employees", "view_finances", "manage_balance", "manage_stock",
  "manage_payroll",
];

// Raw permission key → locale key for its human-readable label, so the chips read as
// English instead of bare snake_case keys.
const PERM_LABEL: Record<string, string> = {
  cook: "settings.perm_cook",
  sell: "settings.perm_sell",
  manage_menu: "settings.perm_manage_menu",
  manage_props: "settings.perm_manage_props",
  manage_employees: "settings.perm_manage_employees",
  view_finances: "settings.perm_view_finances",
  manage_balance: "settings.perm_manage_balance",
  manage_stock: "settings.perm_manage_stock",
  manage_payroll: "settings.perm_manage_payroll",
};

// One installed add-on pack, as modules/dlc reports it. Everything here is
// READ-ONLY: a pack's content lives in the pack's own resource, so there is nothing
// on this screen to save.
export type Dlc = {
  id: string; name?: string; description?: string; version?: string;
  author?: string; resource?: string;
  foods?: { key?: string; label?: string }[];
  tools?: { key?: string; label?: string }[];
  ingredients?: { key?: string; label?: string }[];
};

type Props = {
  settings: Record<string, any>; items: Item[]; groups: string[]; onSaved: () => void;
  dlcs?: Dlc[];
  /** The annotated ingredient list, purely so the cost editor can put a NAME and a
   *  picture to a per-face cost key (`restaurant_toy:lardboy`). Such a key is not an
   *  item, so the item picker can neither resolve nor safely edit it. */
  ingredients?: any[];
  /** Each installed DLC pack's DEFAULT costs. The editor lists a row for every one
   *  (a pack's items have to be priceable) but only stores those changed away from
   *  the default. */
  dlcCosts?: Record<string, number>;
  appTheme?: ThemeConfig | null; onAppTheme?: (t: ThemeConfig) => void;
  phoneTheme?: ThemeConfig | null; onPhoneTheme?: (t: ThemeConfig) => void;
  /** Whether a real framework job system is present. False = WE are the framework, and
   *  the Jobs group's authored list is the one restaurants pick from. */
  jobsAvailable?: boolean;
  /** Supplier depots, RAW, straight off `buildAdminData`. They are NOT part of
   *  `settings.supply_runs` as far as this panel is concerned: the gizmo owns the
   *  points and the server merges the stored list back into any settings write, so the
   *  scalar editor here can never clobber a bay that was just placed. */
  supplyDepots?: any[];
  /** Baking containers the recipes declare: { model, label, slots }. Derived server-side
   *  so the tray editor lists the containers that exist rather than taking a typed model
   *  name; `slots` is the recipe's output_count. Nothing here is written back. */
  bakeContainers?: { model: string; label?: string; slots?: number }[];
  /** Reload `admin:getData` — the depot editor needs it after a placement/removal,
   *  which changes a list this component doesn't own. */
  refresh?: () => void;
};

// Drinks + Assembly editors moved to the Menu tab (foods live together there).
// LAZY getter (memoized): `_L()` must resolve at render time, not at module import —
// a module-scope `_L()` runs before loadLocale() and would freeze to the raw key.
let _groups: { key: string; label: string; icon: any }[] | null = null;
const GROUPS = () => (_groups ??= [
  { key: "general", label: _L("settings.group_general"), icon: Settings2 },
  { key: "appearance", label: _L("settings.group_appearance"), icon: Palette },
  { key: "economy", label: _L("settings.group_economy"), icon: Coins },
  { key: "pricing", label: _L("settings.group_pricing"), icon: DollarSign },
  // JOBS replaces the retired "Roles" group: permissions and pay are per RANK of a
  // restaurant's job now (edited in the boss panel), so the only role-ish thing left
  // server-wide is the job LIST (standalone) and what a fresh grade starts with.
  { key: "jobs", label: _L("settings.group_jobs"), icon: Briefcase },
  { key: "reservations", label: _L("settings.group_reservations"), icon: CalendarClock },
  { key: "eating", label: _L("settings.group_eating"), icon: Utensils },
  { key: "npc_customers", label: _L("settings.group_npc"), icon: PersonStanding },
  { key: "kitchen_fires", label: _L("settings.group_fires"), icon: Flame },
  { key: "bake_slots", label: _L("settings.group_bake"), icon: Cookie },
  { key: "supply", label: _L("settings.group_supply"), icon: Truck },
  { key: "blip", label: _L("settings.group_blip"), icon: MapPin },
  { key: "dlc", label: _L("settings.group_dlc"), icon: Package },
]);

export default function Settings({ settings, items, groups, dlcs, ingredients, dlcCosts, onSaved, appTheme, onAppTheme, phoneTheme, onPhoneTheme, jobsAvailable, supplyDepots, bakeContainers, refresh }: Props) {
  const [group, setGroup] = useState("general");

  return (
    <div className="flex min-h-0 flex-1 gap-4">
      {/* group nav */}
      <div className="w-44 shrink-0 space-y-1 overflow-y-auto pr-1 pb-4">
        {GROUPS().map((g) => {
          const Icon = g.icon;
          return (
            <button
              key={g.key}
              onClick={() => setGroup(g.key)}
              className={cn(
                "flex w-full items-center gap-2 rounded-md px-3 py-2 text-left text-sm transition-colors",
                group === g.key ? "bg-primary/15 text-primary" : "hover:bg-accent"
              )}
            >
              <Icon className="h-4 w-4 shrink-0" />
              {g.label}
            </button>
          );
        })}
      </div>

      {/* group form */}
      <div className="min-w-0 flex-1 overflow-y-auto pr-1 pb-4">
        {group === "general" && <General settings={settings} onSaved={onSaved} />}
        {group === "appearance" && <Appearance appTheme={appTheme} onAppTheme={onAppTheme} phoneTheme={phoneTheme} onPhoneTheme={onPhoneTheme} />}
        {group === "economy" && <Economy settings={settings} onSaved={onSaved} />}
        {group === "pricing" && <Pricing settings={settings} items={items} ingredients={ingredients} dlcCosts={dlcCosts} onSaved={onSaved} />}
        {group === "jobs" && <Jobs settings={settings} jobsAvailable={jobsAvailable} onSaved={onSaved} />}
        {group === "reservations" && <Reservations settings={settings} onSaved={onSaved} />}
        {group === "eating" && <Eating settings={settings} onSaved={onSaved} />}
        {group === "npc_customers" && <NpcCustomers settings={settings} onSaved={onSaved} />}
        {group === "kitchen_fires" && <KitchenFires settings={settings} items={items} onSaved={onSaved} />}
        {group === "bake_slots" && <BakeTrays settings={settings} containers={bakeContainers} onSaved={onSaved} />}
        {group === "supply" && <SupplyRuns settings={settings} depots={supplyDepots} onSaved={onSaved} refresh={refresh} />}
        {group === "blip" && <Blip settings={settings} onSaved={onSaved} />}
        {group === "dlc" && <DlcPacks dlcs={dlcs} />}
      </div>
    </div>
  );
}

/** Section frame with a title and an auto-save status hint (no Save button — edits
 * persist automatically, debounced). */
function Section({
  title, description, status, readOnly, children,
}: {
  title: string; description?: string; status?: SaveStatus;
  // A section with nothing to save (the DLC inventory). Without this it would
  // advertise "changes save automatically" over a screen that has no inputs.
  readOnly?: boolean;
  children: React.ReactNode;
}) {
  return (
    <div className="space-y-4">
      <div className="flex items-start justify-between gap-3">
        <div>
          <h3 className="text-sm font-semibold">{title}</h3>
          {description && <p className="text-xs text-muted-foreground">{description}</p>}
        </div>
        {!readOnly && <SaveStatusHint status={status} />}
      </div>
      {children}
    </div>
  );
}

function SaveStatusHint({ status }: { status?: SaveStatus }) {
  if (!status || status === "idle") return <span className="text-xs text-muted-foreground/60">{_L("settings.auto_saves")}</span>;
  return (
    <span className="flex shrink-0 items-center gap-1 text-xs text-muted-foreground">
      {status === "saving"
        ? <><Loader2 className="h-3 w-3 animate-spin" /> {_L("settings.saving")}</>
        : <><Check className="h-3 w-3 text-primary" /> {_L("settings.saved")}</>}
    </span>
  );
}

// Batched save: the whole group's keys go up together, so an auto-save writes once
// (one sync + one in-game "Settings saved." notification), not per field.
const saveSettings = (obj: Record<string, any>) => fetchNui("admin:saveSettings", { settings: obj });

function General({ settings, onSaved }: { settings: any; onSaved: () => void }) {
  const [cmd, setCmd] = useState(settings.admin_command ?? "restaurants");
  const [expire, setExpire] = useState(Number(settings.cooked_expire_seconds ?? 0));
  const status = useAutoSave(
    () => saveSettings({ admin_command: cmd, cooked_expire_seconds: Math.max(0, Math.floor(expire || 0)) }).then(onSaved),
    [cmd, expire]
  );
  return (
    <Section title={_L("settings.general_title")} description={_L("settings.general_desc")} status={status}>
      <TextField label={_L("settings.admin_command")} hint={_L("settings.admin_command_hint")} value={cmd} onChange={setCmd} />
      <NumberField
        label={_L("settings.cooked_expiry")}
        hint={_L("settings.cooked_expiry_hint")}
        value={expire} min={0} step={10} onChange={setExpire}
      />
      <ResetRecipes onSaved={onSaved} />
    </Section>
  );
}

/** The admin panel's OWN look — a franchise-independent theme that skins
 * /restaurants itself (list, settings, menu editor). Separate from any single
 * restaurant's theme; saved as the `app_theme` setting. Previews live and keeps
 * the parent's copy in sync so opening a restaurant detail and closing it again
 * returns to the CURRENT panel theme. */
function Appearance({
  appTheme, onAppTheme, phoneTheme, onPhoneTheme,
}: {
  appTheme?: ThemeConfig | null; onAppTheme?: (t: ThemeConfig) => void;
  phoneTheme?: ThemeConfig | null; onPhoneTheme?: (t: ThemeConfig) => void;
}) {
  return (
    <div className="space-y-3">
      <ThemeEditor
        id={0}
        theme={appTheme}
        event="admin:setAppTheme"
        onChange={onAppTheme}
        heading={_L("theme.app_title")}
        blurb={_L("theme.app_hint")}
      />
      {/* The phone app's ONE global skin — `scoped` so it previews on its own swatch
          instead of hijacking this panel (which keeps its own menu theme). */}
      <ThemeEditor
        id={0}
        theme={phoneTheme}
        event="admin:setPhoneTheme"
        onChange={onPhoneTheme}
        heading={_L("theme.phone_title")}
        blurb={_L("theme.phone_hint")}
        scoped
      />
    </div>
  );
}

/** Destructive maintenance action: wipe every recipe and reseed the built-in
 * defaults. Two-step confirm (no accidental resets); refreshes the panel after. */
function ResetRecipes({ onSaved }: { onSaved: () => void }) {
  const [confirm, setConfirm] = useState(false);
  const [busy, setBusy] = useState(false);
  const reset = async () => {
    setBusy(true);
    await fetchNui("admin:resetRecipes");
    setBusy(false);
    setConfirm(false);
    onSaved();
  };
  return (
    <div className="mt-2 rounded-lg border border-destructive/40 bg-destructive/5 p-3">
      <div className="flex items-center justify-between gap-3">
        <div>
          <div className="text-sm font-medium">{_L("settings.reset_recipes")}</div>
          <p className="text-xs text-muted-foreground">{_L("settings.reset_recipes_desc")}</p>
        </div>
        {!confirm && (
          <Button variant="destructive" size="sm" className="shrink-0" onClick={() => setConfirm(true)}>
            <RotateCcw className="h-4 w-4" /> {_L("settings.reset_recipes_btn")}
          </Button>
        )}
      </div>
      {confirm && (
        <div className="mt-3 flex items-center justify-between gap-2">
          <span className="text-xs text-destructive">{_L("settings.reset_recipes_confirm")}</span>
          <div className="flex shrink-0 gap-2">
            <Button variant="ghost" size="sm" disabled={busy} onClick={() => setConfirm(false)}>{_L("settings.reset_recipes_cancel")}</Button>
            <Button variant="destructive" size="sm" disabled={busy} onClick={reset}>
              {busy ? <Loader2 className="h-4 w-4 animate-spin" /> : <RotateCcw className="h-4 w-4" />} {_L("settings.reset_recipes_confirm_btn")}
            </Button>
          </div>
        </div>
      )}
    </div>
  );
}

function Economy({ settings, onSaved }: { settings: any; onSaved: () => void }) {
  const [currency, setCurrency] = useState(settings.currency ?? "money");
  const [starting, setStarting] = useState(Number(settings.starting_balance ?? 0));
  const [commission, setCommission] = useState(Number(settings.default_commission ?? 10));
  const [margin, setMargin] = useState(Number(settings.profit_margin ?? 40));
  // Paying the staff. `payroll_interval_minutes` = 0 means wages are only ever paid
  // when a boss presses Run Payroll; anything higher runs one automatically per
  // restaurant on that cadence. `tip_split` decides how a tip pool is divided among
  // the roster: evenly, or weighted by grade (grade + 1 shares).
  const [payrollInterval, setPayrollInterval] = useState(Number(settings.payroll_interval_minutes ?? 0));
  const [tipSplit, setTipSplit] = useState<string>(settings.tip_split === "grade" ? "grade" : "even");
  const status = useAutoSave(
    () => saveSettings({
      currency, starting_balance: starting, default_commission: commission,
      profit_margin: Math.max(0, Math.floor(margin || 0)),
      payroll_interval_minutes: Math.max(0, Math.floor(payrollInterval || 0)),
      tip_split: tipSplit,
    }).then(onSaved),
    [currency, starting, commission, margin, payrollInterval, tipSplit]
  );
  return (
    <Section title={_L("settings.economy_title")} description={_L("settings.economy_desc")} status={status}>
      <div className="grid grid-cols-2 gap-3">
        <Select
          label={_L("settings.currency")}
          value={currency}
          onChange={setCurrency}
          options={[{ value: "money", label: _L("settings.currency_cash") }, { value: "dirty", label: _L("settings.currency_dirty") }]}
        />
        <NumberField label={_L("settings.starting_balance")} value={starting} min={0} onChange={setStarting} />
        <NumberField label={_L("settings.default_commission")} value={commission} min={0} onChange={setCommission} />
        <NumberField label={_L("settings.profit_margin")} hint={_L("settings.profit_margin_hint")} value={margin} min={0} onChange={setMargin} />
        <NumberField label={_L("settings.payroll_interval")} hint={_L("settings.payroll_interval_hint")} value={payrollInterval} min={0} step={5} onChange={setPayrollInterval} />
        <Select
          label={_L("settings.tip_split")}
          hint={_L("settings.tip_split_hint")}
          value={tipSplit}
          onChange={setTipSplit}
          options={[{ value: "even", label: _L("settings.tip_split_even") }, { value: "grade", label: _L("settings.tip_split_grade") }]}
        />
      </div>
    </Section>
  );
}

/** JOBS. Two server-wide things live here, and neither is a per-restaurant rank (those
 * are edited by the boss, in the management panel's Ranks tab):
 *  - the job LIST itself, which only WE own on a standalone server (`jobsAvailable`
 *    false). With a framework running, the framework's list wins and this is unused —
 *    the note says so rather than letting an admin author a shadow list that nothing
 *    reads.
 *  - `default_rank_permissions`: what a NON-boss grade is seeded with the moment a job
 *    is assigned to a restaurant, so a fresh assignment is immediately workable. */
type JobRow = { name: string; label: string; grades: { grade: number; label: string; isboss: boolean }[] };

function Jobs({ settings, jobsAvailable, onSaved }: { settings: any; jobsAvailable?: boolean; onSaved: () => void }) {
  const [rows, setRows] = useState<JobRow[]>(
    (Array.isArray(settings.jobs) ? settings.jobs : []).map((j: any) => ({
      name: j.name ?? "",
      label: j.label ?? "",
      grades: (Array.isArray(j.grades) ? j.grades : []).map((g: any) => ({
        grade: Math.max(0, Math.floor(Number(g.grade) || 0)),
        label: g.label ?? "",
        isboss: !!g.isboss,
      })),
    }))
  );
  const [defaults, setDefaults] = useState<Record<string, boolean>>(
    settings.default_rank_permissions && typeof settings.default_rank_permissions === "object"
      ? { ...settings.default_rank_permissions } : {}
  );
  const [open, setOpen] = useState<number | null>(null);

  const status = useAutoSave(() => saveSettings({
    // A job with no name can't be assigned to anything (the admin Job card validates
    // against this list by name), so half-typed rows are simply not stored.
    jobs: rows.filter((j) => j.name.trim()).map((j) => ({
      name: j.name.trim(), label: j.label.trim() || j.name.trim(),
      grades: j.grades.map((g) => ({ grade: g.grade, label: g.label.trim() || String(g.grade), isboss: g.isboss })),
    })),
    default_rank_permissions: defaults,
  }).then(onSaved), [rows, defaults]);

  const setJob = (i: number, patch: Partial<JobRow>) => setRows((l) => l.map((j, idx) => (idx === i ? { ...j, ...patch } : j)));
  const setGrade = (i: number, gi: number, patch: Partial<JobRow["grades"][number]>) =>
    setRows((l) => l.map((j, idx) => (idx === i ? { ...j, grades: j.grades.map((g, gx) => (gx === gi ? { ...g, ...patch } : g)) } : j)));
  const addGrade = (i: number) =>
    setRows((l) => l.map((j, idx) => (idx === i
      ? { ...j, grades: [...j.grades, { grade: j.grades.reduce((m, g) => Math.max(m, g.grade), -1) + 1, label: "", isboss: false }] }
      : j)));

  return (
    <Section title={_L("settings.jobs_title")} description={_L("settings.jobs_desc")} status={status}>
      {jobsAvailable !== false && (
        <p className="rounded-md border border-dashed border-border px-3 py-2 text-xs text-muted-foreground">
          {_L("settings.jobs_framework_note")}
        </p>
      )}

      <div className="space-y-2">
        {rows.length === 0 && <div className="py-2 text-xs text-muted-foreground">{_L("settings.jobs_none")}</div>}
        {rows.map((j, i) => (
          <div key={i} className="rounded-lg border border-border p-3">
            <div className="flex items-end gap-2">
              <TextField label={_L("settings.job_name")} hint={_L("settings.job_name_hint")} className="w-40" value={j.name} onChange={(v) => setJob(i, { name: v })} />
              <TextField label={_L("settings.job_label")} className="flex-1" value={j.label} onChange={(v) => setJob(i, { label: v })} />
              <Button size="icon" variant="ghost" onClick={() => setOpen(open === i ? null : i)}>
                {open === i ? <ChevronDown className="h-4 w-4" /> : <ChevronRight className="h-4 w-4" />}
              </Button>
              <Button size="icon" variant="destructive" onClick={() => setRows((l) => l.filter((_, idx) => idx !== i))}><Trash2 className="h-4 w-4" /></Button>
            </div>
            <div className="mt-1 text-[11px] text-muted-foreground">{_L("settings.job_grade_count", j.grades.length)}</div>

            {open === i && (
              <div className="mt-3 space-y-2 border-t border-border/60 pt-3">
                {j.grades.map((g, gi) => (
                  <div key={gi} className="flex items-end gap-2">
                    <NumberField label={_L("settings.grade")} className="w-20" value={g.grade} min={0} onChange={(v) => setGrade(i, gi, { grade: Math.max(0, Math.floor(v || 0)) })} />
                    <TextField label={_L("settings.label")} className="flex-1" value={g.label} onChange={(v) => setGrade(i, gi, { label: v })} />
                    {/* A boss grade holds every permission at the restaurant, so this
                        flag is the one that hands over the business — not a label. */}
                    <div className="pb-2">
                      <Toggle checked={g.isboss} onChange={(v) => setGrade(i, gi, { isboss: v })} label={_L("settings.job_isboss")} />
                    </div>
                    <Button size="icon" variant="ghost" onClick={() => setJob(i, { grades: j.grades.filter((_, gx) => gx !== gi) })}><Trash2 className="h-4 w-4" /></Button>
                  </div>
                ))}
                <Button size="sm" variant="outline" onClick={() => addGrade(i)}><Plus className="h-4 w-4" /> {_L("settings.job_add_grade")}</Button>
              </div>
            )}
          </div>
        ))}
        <Button variant="outline" size="sm" onClick={() => setRows((l) => [...l, { name: "", label: "", grades: [{ grade: 0, label: "", isboss: false }] }])}>
          <Plus className="h-4 w-4" /> {_L("settings.job_add")}
        </Button>
      </div>

      <Field label={_L("settings.default_rank_perms")} hint={_L("settings.default_rank_perms_hint")} className="mt-4">
        <div className="flex flex-wrap gap-2">
          {PERMISSIONS.map((p) => (
            <button
              key={p}
              onClick={() => setDefaults((m) => ({ ...m, [p]: !m[p] }))}
              className={cn(
                "rounded-full border px-2.5 py-0.5 text-xs transition-colors",
                defaults[p] ? "border-primary/30 bg-primary/15 text-primary" : "border-border text-muted-foreground hover:bg-accent"
              )}
            >
              {_L(PERM_LABEL[p] || "")}
            </button>
          ))}
        </div>
      </Field>
    </Section>
  );
}

/** RESERVATIONS. A reservation holds SPECIFIC seat anchors for one timeslot, so both
 * knobs here are about the slot: which ones exist (canonical ids the server validates
 * a booking against — "now" is special-cased to start the moment it's booked) and how
 * long one stays live before the sweep expires it and frees its seats. */
function Reservations({ settings, onSaved }: { settings: any; onSaved: () => void }) {
  const [slots, setSlots] = useState<string[]>(Array.isArray(settings.reservation_slots) ? settings.reservation_slots.map(String) : []);
  const [hold, setHold] = useState(Number(settings.reservation_hold_minutes ?? 90));
  const status = useAutoSave(() => saveSettings({
    reservation_slots: slots.map((s) => s.trim()).filter(Boolean),
    reservation_hold_minutes: Math.max(5, Math.floor(hold || 0)),
  }).then(onSaved), [slots, hold]);

  return (
    <Section title={_L("settings.reservations_title")} description={_L("settings.reservations_desc")} status={status}>
      <NumberField label={_L("settings.reservation_hold")} hint={_L("settings.reservation_hold_hint")} value={hold} min={5} step={5} onChange={setHold} />
      <Field label={_L("settings.reservation_slots")} hint={_L("settings.reservation_slots_hint")} className="mt-4">
        <div className="space-y-2">
          {slots.length === 0 && <div className="py-2 text-xs text-muted-foreground">{_L("settings.reservation_no_slots")}</div>}
          {slots.map((s, i) => (
            <div key={i} className="flex items-center gap-2">
              <Input className="flex-1 font-mono tabular-nums" value={s} placeholder="19:00"
                onChange={(e) => setSlots((l) => l.map((x, idx) => (idx === i ? e.target.value : x)))} />
              <Button size="icon" variant="destructive" onClick={() => setSlots((l) => l.filter((_, idx) => idx !== i))}><Trash2 className="h-4 w-4" /></Button>
            </div>
          ))}
          <Button variant="outline" size="sm" onClick={() => setSlots((l) => [...l, ""])}><Plus className="h-4 w-4" /> {_L("settings.reservation_add_slot")}</Button>
        </div>
      </Field>
    </Section>
  );
}

// The Settings → ROLES editor is GONE. `default_roles` no longer exists server-side:
// permissions, commission and salary are per RANK of a restaurant's job now, edited by
// the boss in the management panel's Ranks tab (which renders the permission list the
// server sends it). What remains server-wide is the Jobs group above — the standalone
// job list, and `default_rank_permissions` for a freshly assigned job.

/** NPC customers — AI customers that queue at a restaurant's counter, place a real POS
 * ticket, and pay on serve. All values are clamped server-side (NpcConfig) too, so this
 * editor only needs light coercion. `models` is a plain list of GTA ped model names
 * (NOT inventory items), so it's edited as text rows, not an ItemPicker. */
/** Kitchen fires: how long burnt food smoulders before the station catches, how
 *  long putting one out takes, and (optionally) the item you must be carrying to
 *  fight it. The extinguisher is never consumed — leave it unset for bare-handed. */
function KitchenFires({ settings, items, onSaved }: { settings: any; items: Item[]; onSaved: () => void }) {
  const c = settings.kitchen_fires && typeof settings.kitchen_fires === "object" ? settings.kitchen_fires : {};
  const [enabled, setEnabled] = useState(c.enabled !== false);
  const [delay, setDelay] = useState<number>(c.delay_seconds ?? 90);
  const [extinguishMs, setExtinguishMs] = useState<number>(c.extinguish_ms ?? 5000);
  const [reach, setReach] = useState<number>(c.reach ?? 4);
  const [item, setItem] = useState<string>(c.extinguisher_item || "");

  const status = useAutoSave(
    () => saveSettings({
      kitchen_fires: {
        enabled,
        delay_seconds: Math.max(5, Math.floor(delay || 0)),
        extinguish_ms: Math.max(500, Math.floor(extinguishMs || 0)),
        reach: Math.max(1, reach || 0),
        extinguisher_item: item.trim(),
      },
    }).then(onSaved),
    [enabled, delay, extinguishMs, reach, item]
  );

  return (
    <Section title={_L("settings.fires_title")} description={_L("settings.fires_desc")} status={status}>
      <Toggle checked={enabled} onChange={setEnabled} label={_L("settings.fires_enabled")} />
      <div className="grid grid-cols-2 gap-3">
        <NumberField label={_L("settings.fires_delay")} hint={_L("settings.fires_delay_hint")} value={delay} min={5} onChange={setDelay} />
        <NumberField label={_L("settings.fires_extinguish_ms")} value={extinguishMs} min={500} step={250} onChange={setExtinguishMs} />
        <NumberField label={_L("settings.fires_reach")} value={reach} min={1} step={0.5} onChange={setReach} />
      </div>
      <Field label={_L("settings.fires_item")} hint={_L("settings.fires_item_hint")}>
        <ItemPicker items={items} value={item} onChange={setItem} />
      </Field>
    </Section>
  );
}

/**
 * BAKING TRAYS: where the servings sit inside a baking container. A tray's wells are
 * evenly spaced — that is what a tray IS — so this is a PITCH (columns across, plus the
 * centre-to-centre gap on each axis), not a seat per serving. Six seats would be twelve
 * boxes holding four distinct numbers, and twelve chances to typo one.
 * The grid is centred on the container and rows are however many the batch needs, so
 * only the nudge fields are needed for a tray whose wells aren't centred on its origin.
 *
 * The CONTAINERS come from the recipes (`bakeContainers`), never from this map: a tray
 * is authored on a recipe, so typing a model name here would be the one way to author a
 * layout for a tray nothing renders. `slots` is that recipe's output_count, shown so the
 * number of servings the pitch has to seat is on screen while it's being set.
 *
 * A container is authored or it isn't: "Author layout" seeds the pitch to nudge from,
 * "Use tray size" removes the key and hands it back to the client's measured grid.
 */
function BakeTrays({
  settings, containers, onSaved,
}: {
  settings: any; containers?: { model: string; label?: string; slots?: number }[]; onSaved: () => void;
}) {
  type Pitch = { cols: number; spread_x: number; spread_y: number; offset_x: number; offset_y: number };
  const stored = settings.bake_slots && typeof settings.bake_slots === "object" ? settings.bake_slots : {};
  const [map, setMap] = useState<Record<string, Pitch>>(() => {
    const out: Record<string, Pitch> = {};
    for (const [model, c] of Object.entries<any>(stored)) {
      // A stored entry only counts as AUTHORED if it carries a real pitch. Anything
      // else — junk, or a shape this editor no longer speaks — reads as not authored,
      // so the card offers "Author layout" instead of presenting a row of zeros as
      // though someone had chosen them. Matches BakeSlotsFor client-side, which drops
      // a spread-less entry for the same reason: it would stack every serving on one
      // point, which is never what an admin meant.
      const sx = Number(c?.spread_x), sy = Number(c?.spread_y);
      if (!c || typeof c !== "object" || (!sx && !sy) || Number.isNaN(sx) || Number.isNaN(sy)) continue;
      out[model] = {
        cols: Number(c.cols) >= 1 ? Math.floor(Number(c.cols)) : 3,
        spread_x: sx || 0, spread_y: sy || 0,
        offset_x: Number(c.offset_x) || 0, offset_y: Number(c.offset_y) || 0,
      };
    }
    return out;
  });

  const status = useAutoSave(() => saveSettings({ bake_slots: map }).then(onSaved), [map]);

  const author = (model: string, slots: number) => setMap((m) => ({
    ...m,
    // a pitch to nudge from, not a measurement: 3 across is what nearly every tray is,
    // and an even gap on both axes is the honest starting guess for one
    [model]: { cols: Math.min(3, slots), spread_x: 0.0625, spread_y: 0.0625, offset_x: 0, offset_y: 0 },
  }));
  const clear = (model: string) => setMap((m) => { const { [model]: _drop, ...rest } = m; return rest; });
  const set = (model: string, patch: Partial<Pitch>) =>
    setMap((m) => ({ ...m, [model]: { ...m[model], ...patch } }));

  const list = containers || [];

  return (
    <Section title={_L("settings.bake_title")} description={_L("settings.bake_desc")} status={status}>
      {list.length === 0 && <p className="text-xs text-muted-foreground">{_L("settings.bake_none")}</p>}
      {list.map((c) => {
        const slots = Math.max(1, Math.floor(c.slots || 1));
        const p = map[c.model];
        const cols = Math.max(1, Math.min(Math.floor(p?.cols || 1), slots));
        return (
          <div key={c.model} className="rounded-md border border-border p-3 space-y-3">
            <div className="flex items-start justify-between gap-3">
              <div className="min-w-0">
                <div className="text-sm font-medium">{c.label || c.model}</div>
                <div className="truncate font-mono text-xs text-muted-foreground">{c.model}</div>
              </div>
              {p
                ? <Button variant="ghost" size="sm" onClick={() => clear(c.model)}>{_L("settings.bake_clear")}</Button>
                : <Button variant="secondary" size="sm" onClick={() => author(c.model, slots)}>{_L("settings.bake_author")}</Button>}
            </div>
            {!p && <p className="text-xs text-muted-foreground">{_L("settings.bake_derived", slots)}</p>}
            {p && (
              <>
                <div className="grid grid-cols-3 gap-3">
                  <NumberField label={_L("settings.bake_cols")} value={p.cols} min={1} step={1}
                    onChange={(v) => set(c.model, { cols: v })} />
                  <NumberField label={_L("settings.bake_spread_x")} value={p.spread_x} step={0.005}
                    onChange={(v) => set(c.model, { spread_x: v })} />
                  <NumberField label={_L("settings.bake_spread_y")} value={p.spread_y} step={0.005}
                    onChange={(v) => set(c.model, { spread_y: v })} />
                </div>
                <div className="grid grid-cols-3 gap-3">
                  <div />
                  <NumberField label={_L("settings.bake_offset_x")} value={p.offset_x} step={0.005}
                    onChange={(v) => set(c.model, { offset_x: v })} />
                  <NumberField label={_L("settings.bake_offset_y")} value={p.offset_y} step={0.005}
                    onChange={(v) => set(c.model, { offset_y: v })} />
                </div>
                <p className="text-xs text-muted-foreground">
                  {_L("settings.bake_shape", slots, cols, Math.ceil(slots / cols))}
                </p>
              </>
            )}
          </div>
        );
      })}
    </Section>
  );
}

/**
 * SUPPLY RUNS. Two halves that deliberately do NOT share a save path:
 *   • the SCALARS auto-save like every other settings group, and send NO `depots` key
 *     (the server merges the stored list back in);
 *   • the DEPOTS are placed with the gizmo, because a point is placed in the world, not
 *     typed into a form. Placing is also the only way one is CREATED, like a seat: an
 *     "add" button making an empty row would leave a depot that does nothing.
 * Without that split, a debounced scalar write landing after a placement would delete
 * the bay that was just placed.
 */
function SupplyRuns({ settings, depots, onSaved, refresh }: { settings: any; depots?: any[]; onSaved: () => void; refresh?: () => void }) {
  const c = settings.supply_runs && typeof settings.supply_runs === "object" ? settings.supply_runs : {};
  const [enabled, setEnabled] = useState(c.enabled === true);
  const [maxStock, setMaxStock] = useState<number>(Number(c.max_stock ?? 100));
  const [boxesPerCap, setBoxesPerCap] = useState<number>(Number(c.boxes_per_cap ?? 4));
  const [boxModel, setBoxModel] = useState<string>(c.box_model || "hei_prop_heist_box");
  const [truckModel, setTruckModel] = useState<string>(c.truck_model || "phantom");
  const [trailerModel, setTrailerModel] = useState<string>(c.trailer_model || "trailers");
  const [truckGap, setTruckGap] = useState<number>(Number(c.truck_gap ?? 8.5));
  const [claimTtl, setClaimTtl] = useState<number>(Number(c.claim_ttl ?? 900));
  const [advanced, setAdvanced] = useState(false);

  // Units per box is DERIVED (cap over boxes), the same sum the server does, so the two
  // numbers an admin actually sets show what they work out to instead of hiding it.
  const perBox = maxStock > 0 ? Math.max(1, Math.ceil(maxStock / Math.max(1, boxesPerCap))) : 25;

  const status = useAutoSave(
    () => saveSettings({
      supply_runs: {
        enabled,
        max_stock: Math.max(0, Math.floor(maxStock || 0)),
        boxes_per_cap: Math.max(1, Math.floor(boxesPerCap || 1)),
        box_model: boxModel.trim(),
        truck_model: truckModel.trim(),
        trailer_model: trailerModel.trim(),
        truck_gap: Math.max(3, truckGap || 0),
        claim_ttl: Math.max(60, Math.floor(claimTtl || 0)),
        // NO `depots` — see the comment above and the supply_runs sanitizer server-side.
      },
    }).then(onSaved),
    [enabled, maxStock, boxesPerCap, boxModel, truckModel, trailerModel, truckGap, claimTtl]
  );

  const list = depots || [];
  const place = (depot?: string, zone?: string) =>
    fetchNui("admin:placeSupplyZone", { depot, zone, boxModel, trailerModel });

  return (
    <div className="space-y-6">
      <Section title={_L("settings.supply_title")} description={_L("settings.supply_desc")} status={status}>
        <Toggle checked={enabled} onChange={setEnabled} label={_L("settings.supply_enabled")} />
        <p className="text-[11px] text-muted-foreground">{_L("settings.supply_enabled_hint")}</p>
        <div className="grid grid-cols-2 gap-3">
          <NumberField label={_L("settings.supply_max_stock")} hint={_L("settings.supply_max_stock_hint")} value={maxStock} min={0} onChange={setMaxStock} />
          <NumberField label={_L("settings.supply_boxes_per_cap")} hint={_L("settings.supply_boxes_per_cap_hint", perBox)} value={boxesPerCap} min={1} onChange={setBoxesPerCap} />
        </div>
      </Section>

      <Section title={_L("settings.supply_depots")} description={_L("settings.supply_depots_hint")} readOnly>
        <div className="flex justify-end">
          <Button size="sm" variant="outline" onClick={() => place()}>
            <Plus className="h-3.5 w-3.5" /> {_L("admin.place")}
          </Button>
        </div>
        {list.length === 0 && <p className="text-[11px] text-muted-foreground">{_L("settings.supply_no_depots")}</p>}
        {list.map((d: any) => (
          <div key={d.id} className="rounded-lg border border-border p-3">
            <div className="mb-1.5 flex items-center gap-2">
              <Truck className="h-4 w-4 shrink-0 text-muted-foreground" />
              <Input
                className="h-8 flex-1"
                defaultValue={d.label || d.id}
                onBlur={(e) => fetchNui("admin:setDepot", { id: d.id, label: e.target.value }).then(() => refresh?.())}
              />
              <Badge variant="secondary">{_L("settings.supply_bays", String((d.zones || []).length))}</Badge>
              {/* The counter is where orders are placed once runs are on, so a depot
                  without one can be collected from but never bought at. */}
              <Badge variant={d.shop ? "secondary" : "destructive"}>
                {d.shop ? _L("settings.supply_shop") : _L("settings.supply_no_shop")}
              </Badge>
              <Button size="sm" variant="outline" onClick={() => fetchNui("admin:placeSupplyShop", { depot: d.id })}>
                {_L("settings.supply_move_shop")}
              </Button>
              <Button size="sm" variant="outline" onClick={() => place(d.id)}>
                <Plus className="h-3.5 w-3.5" /> {_L("settings.supply_add_zone")}
              </Button>
              <Button variant="ghost" size="sm" onClick={() => fetchNui("admin:removeDepot", { id: d.id }).then(() => refresh?.())}>
                <Trash2 className="h-3.5 w-3.5" />
              </Button>
            </div>
            {(d.zones || []).length === 0 ? (
              <p className="text-[11px] text-muted-foreground">{_L("settings.supply_no_zones")}</p>
            ) : (
              <div className="flex flex-wrap gap-1.5">
                {(d.zones || []).map((z: any) => (
                  <div key={z.id} className="flex items-center gap-1 rounded-md border border-border bg-card px-2 py-1 text-[11px]">
                    <MapPinned className="h-3 w-3 shrink-0 text-muted-foreground" />
                    <span className="font-mono">{z.id}</span>
                    {z.busy && <Badge variant="secondary">{_L("settings.supply_zone_busy")}</Badge>}
                    <button className="ml-1 text-muted-foreground hover:text-foreground" onClick={() => place(d.id, z.id)} title={_L("settings.supply_edit_zone")}>
                      <Pencil className="h-3 w-3" />
                    </button>
                    <button className="text-muted-foreground hover:text-destructive" onClick={() => fetchNui("admin:removeSupplyZone", { depot: d.id, zone: z.id }).then(() => refresh?.())}>
                      <Trash2 className="h-3 w-3" />
                    </button>
                  </div>
                ))}
              </div>
            )}
          </div>
        ))}
      </Section>

      {/* Everything an admin sets once and forgets. Collapsed by default so the two
          numbers that matter aren't buried under model names. */}
      <div className="rounded-lg border border-border">
        <button
          onClick={() => setAdvanced((v) => !v)}
          className="flex w-full items-center gap-2 px-3 py-2 text-sm font-semibold hover:bg-accent"
        >
          <ChevronDown className={cn("h-4 w-4 transition-transform duration-200", advanced && "rotate-180")} />
          {_L("settings.supply_advanced")}
        </button>
        {advanced && (
          <div className="space-y-3 border-t border-border p-3">
            <div className="grid grid-cols-2 gap-3">
              <TextField label={_L("settings.supply_box_model")} hint={_L("settings.supply_box_model_hint")} value={boxModel} onChange={setBoxModel} />
              <NumberField label={_L("settings.supply_truck_gap")} hint={_L("settings.supply_truck_gap_hint")} value={truckGap} min={3} step={0.5} onChange={setTruckGap} />
              <TextField label={_L("settings.supply_truck_model")} value={truckModel} onChange={setTruckModel} />
              <TextField label={_L("settings.supply_trailer_model")} value={trailerModel} onChange={setTrailerModel} />
              <NumberField label={_L("settings.supply_claim_ttl")} hint={_L("settings.supply_claim_ttl_hint")} value={claimTtl} min={60} step={30} onChange={setClaimTtl} />
            </div>
          </div>
        )}
      </div>
    </div>
  );
}

function NpcCustomers({ settings, onSaved }: { settings: any; onSaved: () => void }) {
  const c = settings.npc_customers && typeof settings.npc_customers === "object" ? settings.npc_customers : {};
  const [enabled, setEnabled] = useState(c.enabled !== false);
  const [requireStaff, setRequireStaff] = useState(c.require_staff !== false);
  const [staffRadius, setStaffRadius] = useState(Number(c.staff_radius ?? 30));
  const [interval, setInterval] = useState(Number(c.spawn_interval ?? 45));
  const [maxQueue, setMaxQueue] = useState(Number(c.max_queue ?? 4));
  const [patience, setPatience] = useState(Number(c.patience_seconds ?? 240));
  const [minItems, setMinItems] = useState(Number(c.min_items ?? 1));
  const [maxItems, setMaxItems] = useState(Number(c.max_items ?? 2));
  const [tipChance, setTipChance] = useState(Number(c.tip_chance ?? 25));
  const [tipMax, setTipMax] = useState(Number(c.tip_max_percent ?? 15));
  // What a walk-in will pay, as a ceiling over the recommended price. Without one an
  // NPC agrees to any price, which turns the menu into a money printer.
  const [maxMarkup, setMaxMarkup] = useState(Number(c.max_markup ?? 100));
  const [unpricedMax, setUnpricedMax] = useState(Number(c.unpriced_max ?? 100));
  const [counterOffset, setCounterOffset] = useState(Number(c.counter_offset ?? 1.0));
  const [queueSpacing, setQueueSpacing] = useState(Number(c.queue_spacing ?? 0.85));
  const [spawnDistance, setSpawnDistance] = useState(Number(c.spawn_distance ?? 6.0));
  const [models, setModels] = useState<string[]>(Array.isArray(c.models) ? c.models : []);

  const intv = (v: number, lo = 0) => Math.max(lo, Math.floor(v || 0));
  const status = useAutoSave(
    () => saveSettings({
      npc_customers: {
        enabled, require_staff: requireStaff,
        staff_radius: Math.max(3, staffRadius || 0),
        spawn_interval: intv(interval, 5), max_queue: intv(maxQueue, 1),
        patience_seconds: intv(patience, 15),
        min_items: intv(minItems, 1), max_items: intv(maxItems, 1),
        tip_chance: intv(tipChance), tip_max_percent: intv(tipMax),
        max_markup: intv(maxMarkup), unpriced_max: intv(unpricedMax),
        counter_offset: counterOffset || 0, queue_spacing: queueSpacing || 0,
        spawn_distance: spawnDistance || 0,
        models: models.map((m) => m.trim()).filter(Boolean),
      },
    }).then(onSaved),
    [enabled, requireStaff, staffRadius, interval, maxQueue, patience, minItems, maxItems,
     tipChance, tipMax, maxMarkup, unpricedMax, counterOffset, queueSpacing, spawnDistance, models]
  );

  const updateModel = (i: number, v: string) => setModels((l) => l.map((m, idx) => (idx === i ? v : m)));

  return (
    <Section title={_L("settings.npc_title")} description={_L("settings.npc_desc")} status={status}>
      <div className="space-y-3">
        <Toggle checked={enabled} onChange={setEnabled} label={_L("settings.npc_enabled")} />
        <Toggle checked={requireStaff} onChange={setRequireStaff} label={_L("settings.npc_require_staff")} />
      </div>

      <div className="grid grid-cols-2 gap-3">
        <NumberField label={_L("settings.npc_spawn_interval")} hint={_L("settings.npc_spawn_interval_hint")} value={interval} min={5} onChange={setInterval} />
        <NumberField label={_L("settings.npc_max_queue")} value={maxQueue} min={1} onChange={setMaxQueue} />
        <NumberField label={_L("settings.npc_patience")} hint={_L("settings.npc_patience_hint")} value={patience} min={15} onChange={setPatience} />
        <NumberField label={_L("settings.npc_staff_radius")} hint={_L("settings.npc_staff_radius_hint")} value={staffRadius} min={3} onChange={setStaffRadius} />
        <NumberField label={_L("settings.npc_min_items")} value={minItems} min={1} onChange={setMinItems} />
        <NumberField label={_L("settings.npc_max_items")} value={maxItems} min={1} onChange={setMaxItems} />
        <NumberField label={_L("settings.npc_tip_chance")} hint={_L("settings.npc_tip_chance_hint")} value={tipChance} min={0} onChange={setTipChance} />
        <NumberField label={_L("settings.npc_tip_max")} hint={_L("settings.npc_tip_max_hint")} value={tipMax} min={0} onChange={setTipMax} />
      </div>

      <div className="mt-2">
        <h4 className="mb-2 text-xs font-semibold text-muted-foreground">{_L("settings.npc_pricing")}</h4>
        <p className="mb-2 text-xs text-muted-foreground">{_L("settings.npc_pricing_hint")}</p>
        <div className="grid grid-cols-2 gap-3">
          <NumberField label={_L("settings.npc_max_markup")} hint={_L("settings.npc_max_markup_hint")} value={maxMarkup} min={0} onChange={setMaxMarkup} />
          <NumberField label={_L("settings.npc_unpriced_max")} hint={_L("settings.npc_unpriced_max_hint")} value={unpricedMax} min={0} onChange={setUnpricedMax} />
        </div>
      </div>

      <div className="mt-2">
        <h4 className="mb-2 text-xs font-semibold text-muted-foreground">{_L("settings.npc_layout")}</h4>
        <div className="grid grid-cols-3 gap-3">
          <NumberField label={_L("settings.npc_counter_offset")} value={counterOffset} min={0} step={0.05} onChange={setCounterOffset} />
          <NumberField label={_L("settings.npc_queue_spacing")} value={queueSpacing} min={0.3} step={0.05} onChange={setQueueSpacing} />
          <NumberField label={_L("settings.npc_spawn_distance")} value={spawnDistance} min={1} step={0.5} onChange={setSpawnDistance} />
        </div>
        <p className="mt-1 text-xs text-muted-foreground">{_L("settings.npc_layout_hint")}</p>
      </div>

      <div className="mt-2">
        <h4 className="mb-2 text-xs font-semibold text-muted-foreground">{_L("settings.npc_models")}</h4>
        <p className="mb-2 text-xs text-muted-foreground">{_L("settings.npc_models_hint")}</p>
        <div className="space-y-2">
          {models.length === 0 && <div className="py-2 text-xs text-muted-foreground">{_L("settings.npc_no_models")}</div>}
          {models.map((m, i) => (
            <div key={i} className="flex items-center gap-2">
              <Input className="flex-1" value={m} placeholder="a_m_y_business_01" onChange={(e) => updateModel(i, e.target.value)} />
              <Button size="icon" variant="destructive" onClick={() => setModels((l) => l.filter((_, idx) => idx !== i))}><Trash2 className="h-4 w-4" /></Button>
            </div>
          ))}
          <Button variant="outline" size="sm" onClick={() => setModels((l) => [...l, ""])}><Plus className="h-4 w-4" /> {_L("settings.npc_add_model")}</Button>
        </div>
      </div>
    </Section>
  );
}

// EATING. Two things live here: the fallback effect for a food that doesn't state
// its own, and the catalogue of eat/drink ANIMATIONS every food picks from (Menu →
// a food → "When eaten"). Clips are handed straight to the client, so an entry with
// no dict/clip is dropped server-side.
type AnimRow = { id: string; label: string; dict: string; clip: string; prop: string; ms: number };

function Eating({ settings, onSaved }: { settings: any; onSaved: () => void }) {
  const c = settings.consume ?? {};
  const [hunger, setHunger] = useState(Number(c.hunger ?? 25));
  const [thirst, setThirst] = useState(Number(c.thirst ?? 0));
  const [anim, setAnim] = useState<string>(c.anim ?? "");
  // The default number of mouthfuls a serving takes, for a food that doesn't state
  // its own. 0 = the built-in default (3, or 4 for a drink — sipping reads slower).
  const [bites, setBites] = useState(Number(c.bites ?? 0));
  const [rows, setRows] = useState<AnimRow[]>(
    (Array.isArray(settings.consume_anims) ? settings.consume_anims : []).map((a: any) => ({
      id: a.id ?? "", label: a.label ?? "", dict: a.dict ?? "", clip: a.clip ?? "",
      prop: a.prop ?? "", ms: Number(a.ms ?? 3000),
    }))
  );
  const status = useAutoSave(
    () => saveSettings({
      // `bites` rides in the same block and MUST be sent: this group is saved
      // whole, so omitting it would wipe an authored default the first time
      // anything else on this screen changed. null = "use the built-in default".
      consume: { hunger: clampPct(hunger), thirst: clampPct(thirst), anim,
                 bites: bites > 0 ? Math.min(20, Math.floor(bites)) : null },
      consume_anims: rows.filter((r) => r.id && r.dict && r.clip),
    }).then(onSaved),
    [hunger, thirst, anim, bites, rows]
  );
  const set = (i: number, patch: Partial<AnimRow>) =>
    setRows(rows.map((r, idx) => (idx === i ? { ...r, ...patch } : r)));

  return (
    <Section title={_L("settings.eating_title")} description={_L("settings.eating_desc")} status={status}>
      <div className="grid grid-cols-4 gap-3">
        <NumberField label={_L("settings.eat_hunger")} hint={_L("settings.eat_needs_hint")} value={hunger} min={0} onChange={(v) => setHunger(clampPct(v))} />
        <NumberField label={_L("settings.eat_thirst")} value={thirst} min={0} onChange={(v) => setThirst(clampPct(v))} />
        <NumberField label={_L("settings.eat_bites")} hint={_L("settings.eat_bites_hint")} value={bites} min={0} onChange={(v) => setBites(Math.max(0, Math.min(20, Math.floor(v))))} />
        <Select label={_L("settings.eat_anim")} value={anim} onChange={setAnim}
          options={[{ value: "", label: _L("settings.eat_anim_none") },
                    ...rows.filter((r) => r.id).map((r) => ({ value: r.id, label: r.label || r.id }))]} />
      </div>

      <Field label={_L("settings.eat_anims")} hint={_L("settings.eat_anims_hint")} className="mt-4">
        <div className="space-y-2">
          {rows.map((r, i) => (
            <div key={i} className="rounded-md border border-border/60 p-2">
              <div className="flex items-end gap-2">
                <TextField label={_L("settings.eat_anim_id")} className="w-32" value={r.id} onChange={(v) => set(i, { id: v })} />
                <TextField label={_L("settings.eat_anim_label")} className="flex-1" value={r.label} onChange={(v) => set(i, { label: v })} />
                <NumberField label={_L("settings.eat_anim_ms")} className="w-24" value={r.ms} min={500} onChange={(v) => set(i, { ms: v })} />
                <Button size="icon" variant="ghost" onClick={() => setRows(rows.filter((_, idx) => idx !== i))}><Trash2 className="h-4 w-4" /></Button>
              </div>
              <div className="mt-2 flex items-end gap-2">
                <TextField label={_L("settings.eat_anim_dict")} className="flex-1" value={r.dict} onChange={(v) => set(i, { dict: v })} />
                <TextField label={_L("settings.eat_anim_clip")} className="flex-1" value={r.clip} onChange={(v) => set(i, { clip: v })} />
                <TextField label={_L("settings.eat_anim_prop")} className="flex-1" value={r.prop} onChange={(v) => set(i, { prop: v })} />
              </div>
            </div>
          ))}
          <Button size="sm" variant="outline"
            onClick={() => setRows([...rows, { id: "", label: "", dict: "", clip: "", prop: "", ms: 3000 }])}>
            <Plus className="h-4 w-4" /> {_L("settings.eat_add_anim")}
          </Button>
        </div>
      </Field>
    </Section>
  );
}

const clampPct = (v: number) => Math.max(0, Math.min(100, Math.floor(Number(v) || 0)));

function Blip({ settings, onSaved }: { settings: any; onSaved: () => void }) {
  const b = settings.blip ?? {};
  const [enabled, setEnabled] = useState(b.enabled !== false);
  const [sprite, setSprite] = useState(Number(b.sprite ?? 93));
  const [color, setColor] = useState(Number(b.color ?? 1));
  const [scale, setScale] = useState(Number(b.scale ?? 0.8));
  const status = useAutoSave(
    () => saveSettings({ blip: { enabled, sprite, color, scale } }).then(onSaved),
    [enabled, sprite, color, scale]
  );
  return (
    <Section title={_L("settings.blip_title")} description={_L("settings.blip_desc")} status={status}>
      <Toggle checked={enabled} onChange={setEnabled} label={_L("settings.blip_show")} />
      <div className="grid grid-cols-3 gap-3">
        <NumberField label={_L("settings.blip_sprite")} value={sprite} min={0} onChange={setSprite} />
        <NumberField label={_L("settings.blip_colour")} value={color} min={0} onChange={setColor} />
        <NumberField label={_L("settings.blip_scale")} value={scale} min={0} step={0.1} onChange={setScale} />
      </div>
    </Section>
  );
}

/** Installed DLC packs. Purely an inventory: a pack's content is read out of the
 * pack's own resource at runtime and never stored in this server's settings, so
 * there is nothing here to edit and no Save. What each pack ADDS shows up in the
 * Food & Drinks / Ingredients tabs alongside everything else, marked and locked.
 * Stop the pack's resource and its rows disappear from those tabs on the spot. */
function DlcPacks({ dlcs }: { dlcs?: Dlc[] }) {
  const list = Array.isArray(dlcs) ? dlcs : [];
  return (
    <Section title={_L("settings.dlc_title")} description={_L("settings.dlc_desc")} readOnly>
      {list.length === 0 ? (
        <div className="rounded-lg border border-dashed border-border p-6 text-center">
          <Package className="mx-auto h-6 w-6 text-muted-foreground/50" />
          <div className="mt-2 text-sm text-muted-foreground">{_L("settings.dlc_none")}</div>
          <p className="mt-1 text-xs text-muted-foreground/70">{_L("settings.dlc_none_hint")}</p>
        </div>
      ) : (
        <div className="space-y-3">
          {list.map((d) => <DlcCard key={d.id} dlc={d} />)}
        </div>
      )}
    </Section>
  );
}

function DlcCard({ dlc }: { dlc: Dlc }) {
  // Only the buckets a pack actually fills are shown — a toys pack adds
  // ingredients and nothing else, and three headings with two empty lists reads
  // like something failed to load.
  const buckets: { label: string; rows: { key?: string; label?: string }[] }[] = [
    { label: _L("settings.dlc_foods"), rows: dlc.foods ?? [] },
    { label: _L("settings.dlc_tools"), rows: dlc.tools ?? [] },
    { label: _L("settings.dlc_ingredients"), rows: dlc.ingredients ?? [] },
  ].filter((b) => b.rows.length > 0);

  return (
    <div className="rounded-lg border border-border bg-card p-3">
      <div className="flex items-start justify-between gap-3">
        <div className="min-w-0">
          <div className="flex items-center gap-2">
            <Package className="h-4 w-4 shrink-0 text-primary" />
            <span className="truncate text-sm font-semibold">{dlc.name || dlc.id}</span>
            {dlc.version && (
              <span className="shrink-0 rounded-full border border-border px-1.5 py-0.5 font-mono text-[10px] tabular-nums text-muted-foreground">
                v{dlc.version}
              </span>
            )}
          </div>
          {dlc.description && <p className="mt-1 text-xs text-muted-foreground">{dlc.description}</p>}
        </div>
        {dlc.author && <span className="shrink-0 text-xs text-muted-foreground/70">{_L("settings.dlc_by", dlc.author)}</span>}
      </div>

      <div className="mt-2 flex items-center gap-1.5 text-[11px] text-muted-foreground/70">
        <Lock className="h-3 w-3" />
        <span>{_L("settings.dlc_readonly")}</span>
        {dlc.resource && <span className="ml-auto font-mono">{dlc.resource}</span>}
      </div>

      {buckets.length > 0 && (
        <div className="mt-3 space-y-2 border-t border-border/60 pt-3">
          {buckets.map((b) => (
            <div key={b.label}>
              <div className="tape text-[10px] text-muted-foreground">{b.label}</div>
              <div className="mt-1 flex flex-wrap gap-1.5">
                {b.rows.map((r, i) => (
                  <span key={`${r.key}-${i}`} className="rounded-full border border-border bg-accent/40 px-2 py-0.5 text-xs">
                    {r.label || r.key}
                  </span>
                ))}
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}

/** Ingredient cost map (raw item -> cost). Drives restock spend and the default
 * menu price. Stored as an object; edited here as a list of {item, cost} rows. */
function Pricing({ settings, items, ingredients, dlcCosts, onSaved }: {
  settings: any; items: Item[]; ingredients?: any[]; dlcCosts?: Record<string, number>; onSaved: () => void;
}) {
  const initial = settings.ingredient_costs && typeof settings.ingredient_costs === "object" ? settings.ingredient_costs : {};
  // Every DLC-supplied item gets a row too, at the pack's price. This is the ONE
  // screen where a pack's content is priceable — its entry in the menu tabs is
  // read-only — so if it isn't listed here it can't be priced at all.
  const packs = dlcCosts || {};
  const [rows, setRows] = useState<{ item: string; cost: number }[]>(
    Array.from(new Set([...Object.keys(initial), ...Object.keys(packs)]))
      .map((k) => ({ item: k, cost: Number(initial[k] ?? packs[k]) || 0 }))
      .sort((a, b) => a.item.localeCompare(b.item))
  );
  // Rows here are STOCK KEYS, and a multi-faced ingredient's key names a face
  // (`restaurant_toy:lardboy`) rather than an item. The picker can't resolve one —
  // there is no such item — so it would show a codename and, worse, silently rewrite
  // the key if anyone touched it. Faces render as a fixed identity instead: the
  // toy's own name and picture, with only the cost editable.
  const faces: Record<string, { label: string; image?: string }> = {};
  (ingredients || []).forEach((g: any) => {
    (g?.variants || []).forEach((v: any) => {
      if (v?.costKey) faces[v.costKey] = { label: v.label || v.id, image: v.image };
    });
  });
  const update = (i: number, patch: any) => setRows((l) => l.map((r, idx) => (idx === i ? { ...r, ...patch } : r)));
  const add = () => setRows((l) => [...l, { item: "", cost: 0 }]);

  const status = useAutoSave(() => {
    const map: Record<string, number> = {};
    rows.forEach((r) => {
      if (!r.item) return;
      const cost = Math.max(0, Math.floor(r.cost || 0));
      // A pack-supplied row left AT the pack's price isn't stored: the pack keeps
      // owning that number and can change it in an update. Move it and it becomes
      // this server's, and stays this server's until it's deleted here again.
      if (r.item in packs && cost === packs[r.item]) return;
      map[r.item] = cost;
    });
    return saveSettings({ ingredient_costs: map }).then(onSaved);
  }, [rows]);

  return (
    <Section title={_L("settings.pricing_title")} description={_L("settings.pricing_desc")} status={status}>
      <div className="space-y-2">
        {rows.length === 0 && <div className="py-2 text-xs text-muted-foreground">{_L("settings.no_costs")}</div>}
        {rows.map((r, i) => (
          <div key={i} className="flex items-end gap-2">
            {faces[r.item] ? (
              <Field label={_L("settings.ingredient")} className="flex-1">
                <div className="flex h-9 items-center gap-2 rounded-md border border-input bg-muted/40 px-2.5">
                  {faces[r.item].image
                    ? <img src={faces[r.item].image} alt="" className="h-6 w-6 shrink-0 rounded object-cover" />
                    : <Package className="h-4 w-4 shrink-0 text-muted-foreground" />}
                  <span className="truncate text-sm">{faces[r.item].label}</span>
                </div>
              </Field>
            ) : (
              <Field label={_L("settings.ingredient")} className="flex-1">
                <ItemPicker items={items} value={r.item} onChange={(v) => update(i, { item: v })} />
              </Field>
            )}
            <NumberField label={_L("settings.cost_value")} className="w-28" value={r.cost} min={0} onChange={(v) => update(i, { cost: v })} />
            <Button size="icon" variant="destructive" onClick={() => setRows((l) => l.filter((_, idx) => idx !== i))}><Trash2 className="h-4 w-4" /></Button>
          </div>
        ))}
        <Button variant="outline" size="sm" onClick={add}><Plus className="h-4 w-4" /> {_L("settings.add_cost")}</Button>
      </div>
    </Section>
  );
}
