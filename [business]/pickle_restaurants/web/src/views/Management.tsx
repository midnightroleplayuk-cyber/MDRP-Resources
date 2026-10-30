import { useEffect, useMemo, useRef, useState } from "react";
import { fetchNui, setPeek } from "@/lib/nui";
import Panel from "@/components/Panel";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent } from "@/components/ui/card";
import { Tabs, TabsList, TabsTrigger, TabsContent } from "@/components/ui/tabs";
import { Field, TextField, NumberField, Toggle } from "@/components/form";
import { type Item } from "@/components/ItemPicker";
import Branding, { ThemeEditor, NameEditor } from "@/components/Branding";
import Thumb from "@/components/Thumb";
import { useAutoSave } from "@/lib/autosave";
import { money, cn, prettyItem } from "@/lib/utils";
import { _L } from "@/lib/locale";
import { UserPlus, Trash2, Pencil, Plus, Minus, MapPin, Banknote, Armchair, Receipt, PackagePlus, ArrowDownToLine, ArrowUpFromLine, Sparkles, Users, Play, Square, Monitor, UtensilsCrossed, TriangleAlert, ScrollText, Tags, ShieldCheck, Coins, Briefcase, Loader2, Check, Truck } from "lucide-react";

// NOTE: station / counter / seat PLACEMENT is deliberately not in this panel — it
// is an admin-only job now (the admin panel's restaurant detail), and the placement
// callbacks are gated on admin server-side. The boss panel keeps Branding, which is
// what `manage_props` still means here.

export default function Management({ data, onClose }: { data: any; onClose: () => void }) {
  const id = data?.restaurantId;
  const perms = data?.perms || {};
  const items: Item[] = data?.items || [];
  const initialTab = data?.supplyRuns?.shop ? "supplies" : firstTab(perms);
  // EMPLOYMENT IS THE FRAMEWORK'S JOB. `job` names it (nil + jobMissing = an admin
  // hasn't assigned one, which disables every employment/pay control here), `roster`
  // is the job's real staff list and `ranks` is the per-GRADE pay & permission config
  // everyone on that grade shares. There are no employee rows and no `roles` array.
  const job = data?.job || null;
  const jobMissing = !!data?.jobMissing;
  const roster: any[] = data?.roster || [];
  const isBoss = !!data?.isBoss;

  // The panel header follows a live rename (the rename save deliberately does NOT
  // refresh the panel — that would remount the field mid-typing), so keep the
  // label in local state seeded from the payload.
  const [label, setLabel] = useState<string>(data?.restaurant?.label || "");
  useEffect(() => { setLabel(data?.restaurant?.label || ""); }, [data?.restaurant?.label]);

  // Ranks live HERE, not inside the Ranks tab: the Payroll tab prices the next wage
  // run off the same numbers, and `management:setRank` deliberately doesn't refresh
  // the panel (it would remount the editor mid-typing) — so the reply's sanitized
  // array is mirrored at this level and both tabs read the live values.
  const [ranks, setRanks] = useState<any[]>(data?.ranks || []);
  useEffect(() => { setRanks(data?.ranks || []); }, [data?.ranks]);

  // SUPPLY RUNS move the shop out of this panel and onto a depot counter, so the tab is
  // only offered where buying actually works: anywhere with runs off, and at the counter
  // with them on (`runs.shop`, which the server verifies against where the player is
  // standing). Opened AT the counter, this panel is the shop and nothing else.
  // SUPPLY RUNS split this tab in two. BUYING moves to a depot counter, so it is offered
  // only where it works: anywhere with runs off, and at the counter with them on
  // (`runs.shop`, which the server verifies against where the player is standing).
  // MOVING stock between the larder and a pocket is not a purchase and stays in the
  // panel. Opened AT the counter this panel is the shop and nothing else, so the tab
  // itself never disappears: only the controls inside it change.
  const runs = data?.supplyRuns;
  const shopOnly = !!runs?.shop;
  const canShop = !runs?.enabled || shopOnly;

  return (
    <Panel title={label || _L("mgmt.title")} subtitle={_L("mgmt.balance", money(data?.restaurant?.balance))} onClose={onClose} width="max-w-4xl">
      <Tabs defaultValue={initialTab} className="flex min-h-0 flex-1 flex-col">
        <TabsList className="shrink-0">
          {/* Ungated: the dashboard is the shift clock + the state of the room, which
              every employee working a register needs, not a management privilege. */}
          {!shopOnly && <TabsTrigger value="dashboard">{_L("mgmt.tab_dashboard")}</TabsTrigger>}
          {!shopOnly && perms.manage_employees && <TabsTrigger value="employees">{_L("mgmt.tab_employees")}</TabsTrigger>}
          {/* Setting what a GRADE earns is boss-only (the server gates setRank on
              ResolvePerms' isBoss) — manage_employees moves people between grades,
              it must not also let a shift lead write their own pay. */}
          {!shopOnly && isBoss && <TabsTrigger value="ranks">{_L("mgmt.tab_ranks")}</TabsTrigger>}
          {!shopOnly && perms.manage_payroll && <TabsTrigger value="payroll">{_L("mgmt.tab_payroll")}</TabsTrigger>}
          {!shopOnly && perms.manage_menu && <TabsTrigger value="menu">{_L("mgmt.tab_menu")}</TabsTrigger>}
          {perms.manage_stock && <TabsTrigger value="supplies">{_L("mgmt.tab_supplies")}</TabsTrigger>}
          {!shopOnly && perms.view_finances && <TabsTrigger value="finances">{_L("mgmt.tab_finances")}</TabsTrigger>}
          {!shopOnly && perms.manage_props && <TabsTrigger value="branding">{_L("mgmt.tab_branding")}</TabsTrigger>}
        </TabsList>

        <TabsContent value="dashboard" className="min-h-0 flex-1 overflow-y-auto pr-1 pb-4">
          <Dashboard id={id} dash={data?.dashboard} perms={perms} balance={data?.restaurant?.balance} runs={runs} />
        </TabsContent>
        {perms.manage_employees && (
          <TabsContent value="employees" className="min-h-0 flex-1 overflow-y-auto pr-1 pb-4">
            <Employees id={id} job={job} jobMissing={jobMissing} roster={roster} nearby={data?.nearby || []} />
          </TabsContent>
        )}
        {isBoss && (
          <TabsContent value="ranks" className="min-h-0 flex-1 overflow-y-auto pr-1 pb-4">
            <Ranks id={id} job={job} jobMissing={jobMissing} ranks={ranks} permissions={data?.permissions || []} onRanks={setRanks} />
          </TabsContent>
        )}
        {perms.manage_payroll && (
          <TabsContent value="payroll" className="min-h-0 flex-1 overflow-y-auto pr-1 pb-4">
            <Payroll id={id} jobMissing={jobMissing} ranks={ranks} roster={roster}
              tipPool={data?.tipPool || 0} history={data?.payroll || []} balance={data?.restaurant?.balance} />
          </TabsContent>
        )}
        {perms.manage_menu && (
          <TabsContent value="menu" className="min-h-0 flex-1 overflow-y-auto pr-1 pb-4">
            <Menu id={id} priceList={data?.priceList || []} stale={data?.stale || []} />
          </TabsContent>
        )}
        {perms.manage_stock && (
          <TabsContent value="supplies" className="min-h-0 flex-1 overflow-y-auto pr-1 pb-4">
            <Supplies id={id} supplies={data?.supplies || []} runs={runs}
              canBuy={canShop} canMove={!shopOnly} balance={data?.restaurant?.balance} />
          </TabsContent>
        )}
        {perms.view_finances && (
          <TabsContent value="finances" className="min-h-0 flex-1 overflow-y-auto pr-1 pb-4">
            <Finances id={id} balance={data?.restaurant?.balance} ledger={data?.ledger || []} canManage={!!perms.manage_balance} />
          </TabsContent>
        )}
        {perms.manage_props && (
          <TabsContent value="branding" className="min-h-0 flex-1 space-y-3 overflow-y-auto pr-1 pb-4">
            {/* Renaming the business is OWNER-only (server gates on ResolvePerms'
                isOwner) — a shift lead with manage_props can restyle the place but
                not rename it, so the card is hidden for staff. */}
            {data?.isOwner && (
              <NameEditor id={id} label={data?.restaurant?.label || ""} event="management:setName" onChange={setLabel} />
            )}
            <ThemeEditor id={id} theme={data?.restaurant?.theme} event="management:setTheme" />
            <Branding id={id} brand={data?.restaurant?.brand_image || ""} brandImages={data?.restaurant?.brand_images || {}} phoneImage={data?.restaurant?.phone_image || ""} event="management:setBrandImage" renderTargets={data?.renderTargets} />
          </TabsContent>
        )}
      </Tabs>
    </Panel>
  );
}

// The Dashboard is ungated, so it is always a valid landing tab.
function firstTab(_perms: any) {
  return "dashboard";
}
// (Shop mode overrides this: the depot counter opens straight on Supplies, since that
// is the only tab it renders.)

// ─── Dashboard ───────────────────────────────────────────────────────────────

// h:mm:ss in the receipt voice (mono, tabular) — a shift is read at a glance, so
// seconds matter more than a rounded "2h 14m".
function fmtClock(seconds: number) {
  const s = Math.max(0, Math.floor(seconds));
  const h = Math.floor(s / 3600);
  const m = Math.floor((s % 3600) / 60);
  return `${h}:${String(m).padStart(2, "0")}:${String(s % 60).padStart(2, "0")}`;
}

// One headline number.
function Stat({ icon: Icon, label, value, sub, tone }: {
  icon: any; label: string; value: string; sub?: string; tone?: "brand" | "warn";
}) {
  return (
    <Card>
      <CardContent className="flex items-start gap-2.5 p-3">
        <Icon className={cn("mt-0.5 h-4 w-4 shrink-0",
          tone === "warn" ? "text-destructive" : tone === "brand" ? "text-primary" : "text-muted-foreground")} />
        <div className="min-w-0">
          <div className="text-[10px] font-medium uppercase tracking-wide text-muted-foreground">{label}</div>
          <div className="font-mono text-lg font-bold tabular-nums leading-tight">{value}</div>
          {sub && <div className="truncate text-[11px] text-muted-foreground">{sub}</div>}
        </div>
      </CardContent>
    </Card>
  );
}

// The register operator's home screen: the shift clock (the SAME shift the phone
// app punches — one ShiftCache server-side, so clocking in here shows up there),
// who else is on, and the state of the room. Polls while the panel sits open so the
// ticket queue and the timer stay honest; any panel refresh replaces the block.
function Dashboard({ id, dash, perms, balance, runs }: any) {
  const [d, setD] = useState<any>(dash);
  const [tick, setTick] = useState(0);
  const [busy, setBusy] = useState(false);
  // A full panel refresh (any other action) brings a fresh dashboard block with it.
  useEffect(() => { if (dash) setD(dash); }, [dash]);

  const refresh = () =>
    fetchNui("management:refresh", { id }).then((r: any) => { if (r?.ok && r.dashboard) setD(r.dashboard); });

  useEffect(() => {
    const s = setInterval(() => setTick((n) => n + 1), 1000);
    const p = setInterval(refresh, 10000);
    return () => { clearInterval(s); clearInterval(p); };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [id]);

  // Anchor the timer to the payload's own server clock the moment it arrives, then
  // run it off the local clock — so it never jumps on a poll and never drifts if the
  // player's machine disagrees with the server about the time of day.
  const anchor = useRef({ base: 0, at: Date.now() });
  useEffect(() => {
    anchor.current = { base: d?.since ? Math.max(0, (d.now || 0) - d.since) : 0, at: Date.now() };
  }, [d]);
  const elapsed = tick >= 0 && d?.clockedIn
    ? anchor.current.base + Math.floor((Date.now() - anchor.current.at) / 1000)
    : 0;

  const clock = async () => {
    if (busy) return;
    setBusy(true);
    await fetchNui(d?.clockedIn ? "management:clockOut" : "management:clockIn", { id });
    await refresh();
    setBusy(false);
  };

  const roster: any[] = d?.roster || [];
  const outOfStock: any[] = d?.outOfStock || [];

  return (
    <div className="space-y-3">
      {/* A GATE MUST EXPLAIN ITSELF. With supply runs on, the Supplies tab is gone from
          this panel because ordering happens at a depot counter. Vanishing silently
          would read as a broken permission, so the dashboard says where to go and what
          is already on its way. */}
      {runs?.enabled && !runs?.shop && perms.manage_stock && (
        <Card>
          <CardContent className="flex items-center gap-3 py-3 text-sm">
            <Truck className="h-4 w-4 shrink-0 text-primary" />
            <span className="text-muted-foreground">{_L("mgmt.supply_at_depot")}</span>
            {(runs.pending || []).length > 0 && (
              <span className="ml-auto shrink-0 font-mono text-xs">
                {_L("mgmt.supply_waiting_count", String((runs.pending || []).length))}
              </span>
            )}
          </CardContent>
        </Card>
      )}
      {/* the shift clock — the one thing on this tab you ACT on */}
      <Card>
        <CardContent className="flex flex-wrap items-center gap-4 p-4">
          {/* ON THE CLOCK ONLY. Off duty this read "Off duty / —", which is a big empty
              readout saying nothing the Clock In button doesn't already say. */}
          {d?.clockedIn && (
            <div className="min-w-[9rem]">
              <div className="text-[10px] font-medium uppercase tracking-wide text-muted-foreground">
                {_L("mgmt.dash_on_clock")}
              </div>
              <div className="font-mono text-3xl font-extrabold tabular-nums leading-tight">
                {fmtClock(elapsed)}
              </div>
            </div>
          )}
          <div className="flex gap-4">
            <div>
              <div className="text-[10px] font-medium uppercase tracking-wide text-muted-foreground">{_L("mgmt.dash_tips")}</div>
              <div className="font-mono text-lg font-bold tabular-nums">{money(d?.tips || 0)}</div>
            </div>
            <div>
              <div className="text-[10px] font-medium uppercase tracking-wide text-muted-foreground">{_L("mgmt.dash_cooked")}</div>
              <div className="font-mono text-lg font-bold tabular-nums">{d?.cooked || 0}</div>
            </div>
          </div>
          <Button
            onClick={clock}
            disabled={busy}
            variant={d?.clockedIn ? "destructive" : "default"}
            className="ml-auto min-w-[10rem] gap-2"
          >
            {d?.clockedIn ? <Square className="h-4 w-4" /> : <Play className="h-4 w-4" />}
            {d?.clockedIn ? _L("mgmt.dash_clock_out") : _L("mgmt.dash_clock_in")}
          </Button>
        </CardContent>
      </Card>

      {/* the state of the room */}
      <div className="grid grid-cols-2 gap-2 md:grid-cols-4">
        <Stat icon={Receipt} tone={(d?.openOrders || 0) > 0 ? "brand" : undefined}
          label={_L("mgmt.dash_open_tickets")} value={String(d?.openOrders ?? 0)}
          sub={perms.view_finances && d?.openValue != null ? _L("mgmt.dash_worth", money(d.openValue)) : undefined} />
        <Stat icon={Users} label={_L("mgmt.dash_on_shift")} value={String(roster.length)}
          sub={_L("mgmt.dash_of_staff", d?.employees ?? 0)} />
        {perms.view_finances ? (
          <Stat icon={Banknote} label={_L("mgmt.dash_today")} value={money(d?.todaySales || 0)}
            sub={_L("mgmt.dash_orders_n", d?.todayOrders ?? 0)} />
        ) : (
          <Stat icon={UtensilsCrossed} label={_L("mgmt.dash_menu")} value={String(d?.menuSize ?? 0)} />
        )}
        {perms.view_finances ? (
          <Stat icon={ScrollText} label={_L("mgmt.dash_balance")} value={money(balance)} />
        ) : (
          <Stat icon={Monitor} label={_L("mgmt.dash_registers")} value={String(d?.registers ?? 0)}
            sub={_L("mgmt.dash_kiosks_n", d?.kiosks ?? 0)} />
        )}
      </div>

      {/* the points of sale this place actually has, so you know what else is live */}
      {perms.view_finances && (
        <div className="grid grid-cols-3 gap-2">
          <Stat icon={Monitor} label={_L("mgmt.dash_registers")} value={String(d?.registers ?? 0)} />
          <Stat icon={Sparkles} label={_L("mgmt.dash_kiosks")} value={String(d?.kiosks ?? 0)} />
          <Stat icon={Armchair} label={_L("mgmt.dash_seats")} value={String(d?.seats ?? 0)} />
        </div>
      )}

      {/* anything that will stop the kitchen mid-service */}
      {perms.manage_stock && outOfStock.length > 0 && (
        <Card>
          <CardContent className="p-3">
            <div className="mb-2 flex items-center gap-1.5 text-xs font-semibold text-destructive">
              <TriangleAlert className="h-4 w-4" /> {_L("mgmt.dash_out_of_stock", outOfStock.length)}
            </div>
            <div className="flex flex-wrap gap-1.5">
              {outOfStock.map((s) => (
                <Badge key={s.item} variant="outline" className="gap-1.5">
                  <Thumb src={s.image} className="h-4 w-4" />
                  {s.label || prettyItem(s.item)}
                </Badge>
              ))}
            </div>
          </CardContent>
        </Card>
      )}

      {/* who's on with you — the tip pool this shift splits into */}
      <Card>
        <CardContent className="p-3">
          <div className="mb-2 text-[10px] font-medium uppercase tracking-wide text-muted-foreground">
            {_L("mgmt.dash_tip_pool")}
          </div>
          {roster.length === 0 ? (
            <div className="text-xs text-muted-foreground">{_L("mgmt.dash_nobody_on")}</div>
          ) : (
            <div className="space-y-1.5">
              {roster.map((m, i) => (
                <div key={i} className="flex items-center justify-between rounded-md border border-border bg-muted/30 px-2.5 py-1.5">
                  <span className="flex items-center gap-2 text-sm">
                    <Users className="h-3.5 w-3.5 text-muted-foreground" />
                    {m.name}
                  </span>
                  <span className="flex items-center gap-3 font-mono text-xs tabular-nums text-muted-foreground">
                    <span>{fmtClock(Math.max(0, (d?.now || 0) - (m.since || 0)))}</span>
                    <span className="text-foreground">{money(m.tips || 0)}</span>
                  </span>
                </div>
              ))}
            </div>
          )}
        </CardContent>
      </Card>
    </div>
  );
}

// ─── employment (the framework job) ──────────────────────────────────────────

// Raw permission key → locale key. The rank editor renders the list the SERVER sends
// (`permissions`), so a key appearing without a label here still shows up — as its raw
// name — rather than silently vanishing from the editor.
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
const permLabel = (p: string) => (PERM_LABEL[p] ? _L(PERM_LABEL[p]) : prettyItem(p));

// A restaurant with no job assigned can employ NOBODY: there is no grade ladder to
// hire into, no rank to pay and no roster to read. Every tab that acts on people says
// so loudly and disables its controls — a hire form that can only fail is worse than
// none, and the fix is an admin's (the Job card in /restaurants), not the boss's.
function JobMissing() {
  return (
    <Card className="border-destructive/40">
      <CardContent className="flex items-start gap-2.5 p-3">
        <TriangleAlert className="mt-0.5 h-4 w-4 shrink-0 text-destructive" />
        <div className="min-w-0">
          <div className="text-sm font-semibold text-destructive">{_L("mgmt.job_missing")}</div>
          <p className="text-[11px] text-muted-foreground">{_L("mgmt.job_missing_hint")}</p>
        </div>
      </CardContent>
    </Card>
  );
}

// Which job this restaurant employs through — printed wherever the roster/ranks are,
// so it's obvious that "staff" means "holders of this job", not a list kept here.
function JobLine({ job }: { job: any }) {
  return (
    <p className="flex items-center gap-1.5 px-1 text-[11px] text-muted-foreground">
      <Briefcase className="h-3.5 w-3.5" /> {_L("mgmt.job_is", job?.label || job?.name || "")}
    </p>
  );
}

// The JOB ROSTER: hire a nearby player onto a grade of the job, move someone between
// grades, or take them off it. There is no per-person commission any more — pay is a
// property of the RANK (the Ranks tab), shared by everyone on that grade.
function Employees({ id, job, jobMissing, roster, nearby }: any) {
  const grades: any[] = job?.grades || [];
  const [target, setTarget] = useState("");
  const [grade, setGrade] = useState<number>(Number(grades[0]?.grade ?? 0));
  // The grade ladder is the framework's and can change under us (a job edited in
  // another resource); keep the hire form pointing at a grade that still exists.
  useEffect(() => {
    if (!grades.some((g) => Number(g.grade) === grade)) setGrade(Number(grades[0]?.grade ?? 0));
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [job]);

  if (jobMissing) return <JobMissing />;

  return (
    <div className="space-y-3">
      <JobLine job={job} />
      <Card>
        <CardContent className="flex items-end gap-2 pt-4">
          <div className="flex-1">
            <label className="mb-1 block text-xs text-muted-foreground">{_L("mgmt.nearby_player")}</label>
            <select className="h-9 w-full rounded-md border border-input bg-muted/50 px-2 text-sm transition-colors focus-visible:border-primary/60 focus-visible:outline-none" value={target} onChange={(e) => setTarget(e.target.value)}>
              <option value="">{_L("mgmt.select")}</option>
              {nearby.map((p: any) => <option key={p.id} value={p.id}>{p.name} [{p.id}]</option>)}
            </select>
          </div>
          <div>
            <label className="mb-1 block text-xs text-muted-foreground">{_L("mgmt.grade")}</label>
            <select className="h-9 rounded-md border border-input bg-muted/50 px-2 text-sm transition-colors focus-visible:border-primary/60 focus-visible:outline-none" value={grade} onChange={(e) => setGrade(Number(e.target.value))}>
              {grades.map((g: any) => <option key={g.grade} value={g.grade}>{g.label}</option>)}
            </select>
          </div>
          {/* `serverId` — hiring writes a JOB onto a loaded player, so the target is a
              source, never a row of ours. The nearby picker is the only handle. */}
          <Button disabled={!target} onClick={() => fetchNui("management:hire", { id, serverId: Number(target), grade })}>
            <UserPlus className="h-4 w-4" /> {_L("mgmt.hire")}
          </Button>
        </CardContent>
      </Card>

      {roster.map((e: any) => (
        <Card key={e.identifier}>
          <CardContent className="flex items-center justify-between gap-2 pt-4">
            <div className="min-w-0">
              <div className="flex items-center gap-2">
                <span className="truncate font-medium">{e.name || e.identifier}</span>
                {e.boss && <Badge>{_L("mgmt.boss_grade")}</Badge>}
              </div>
              <div className="truncate font-mono text-xs text-muted-foreground">{e.identifier}</div>
            </div>
            <div className="flex shrink-0 items-center gap-2">
              <select
                className="h-8 rounded-md border border-input bg-muted/50 px-2 text-xs transition-colors focus-visible:border-primary/60 focus-visible:outline-none"
                value={Number(e.grade ?? 0)}
                onChange={(ev) => fetchNui("management:setGrade", { id, identifier: e.identifier, grade: Number(ev.target.value) })}
              >
                {grades.map((g: any) => <option key={g.grade} value={g.grade}>{g.label}</option>)}
              </select>
              <Button size="sm" variant="destructive" onClick={() => fetchNui("management:fire", { id, identifier: e.identifier })}>
                <Trash2 className="h-4 w-4" />
              </Button>
            </div>
          </CardContent>
        </Card>
      ))}
      {roster.length === 0 && <div className="py-4 text-center text-sm text-muted-foreground">{_L("mgmt.no_roster")}</div>}
    </div>
  );
}

// ─── ranks (pay & permissions per grade) ─────────────────────────────────────
// One row per GRADE of the job, shared by everyone on it. The label is the
// FRAMEWORK's (read-only here) and so is the boss flag; what a boss edits is the
// permission set, the commission cut and the salary.
function Ranks({ id, job, jobMissing, ranks, permissions, onRanks }: {
  id: number; job: any; jobMissing: boolean; ranks: any[]; permissions: string[]; onRanks: (r: any[]) => void;
}) {
  if (jobMissing) return <JobMissing />;
  return (
    <div className="space-y-3">
      <JobLine job={job} />
      <p className="px-1 text-[11px] text-muted-foreground">{_L("mgmt.ranks_hint")}</p>
      {ranks.length === 0 && <div className="py-4 text-center text-sm text-muted-foreground">{_L("mgmt.no_ranks")}</div>}
      {ranks.map((r) => (
        <RankRow key={r.grade} id={id} rank={r} permissions={permissions} onRanks={onRanks} />
      ))}
    </div>
  );
}

function RankRow({ id, rank, permissions, onRanks }: {
  id: number; rank: any; permissions: string[]; onRanks: (r: any[]) => void;
}) {
  // Seeded ONCE: the save deliberately doesn't refresh the panel, and re-seeding from
  // the mirrored array on every reply would fight the field being typed in.
  const [perms, setPerms] = useState<Record<string, boolean>>(() => ({ ...(rank.permissions || {}) }));
  const [commission, setCommission] = useState<number>(Number(rank.commission ?? 0));
  const [salary, setSalary] = useState<number>(Number(rank.salary ?? 0));
  const boss = !!rank.boss;

  const status = useAutoSave(async () => {
    const res = await fetchNui<any>("management:setRank", {
      id, grade: rank.grade,
      permissions: perms,
      commission: Math.max(0, Math.min(100, Math.floor(commission || 0))),
      salary: Math.max(0, Math.floor(salary || 0)),
    });
    // The reply carries the SANITIZED array — mirror it so the Payroll tab prices the
    // next run off what the server actually stored, not what was typed.
    if (res?.ok && Array.isArray(res.ranks)) onRanks(res.ranks);
  }, [perms, commission, salary]);

  return (
    <Card>
      <CardContent className="pt-4">
        <div className="mb-3 flex items-end gap-2">
          <Field label={_L("mgmt.rank_grade")} className="w-56">
            <div className="flex h-9 items-center gap-2 rounded-md border border-input bg-muted/40 px-2.5">
              <span className="font-mono text-xs tabular-nums text-muted-foreground">{rank.grade}</span>
              <span className="truncate text-sm">{rank.label}</span>
              {boss && <Badge className="ml-auto">{_L("mgmt.boss_grade")}</Badge>}
            </div>
          </Field>
          <NumberField label={_L("mgmt.rank_commission")} className="w-28" value={commission} min={0} onChange={setCommission} />
          <NumberField label={_L("mgmt.rank_salary")} className="w-32" value={salary} min={0} onChange={setSalary} />
          <span className="ml-auto flex shrink-0 items-center gap-1 pb-2 text-xs text-muted-foreground">
            {status === "saving" ? (
              <><Loader2 className="h-3 w-3 animate-spin" /> {_L("theme.saving")}</>
            ) : status === "saved" ? (
              <><Check className="h-3 w-3 text-primary" /> {_L("theme.saved")}</>
            ) : null}
          </span>
        </div>
        {/* A boss grade holds EVERYTHING regardless of what's ticked (ResolvePerms
            hands it ALL_PERMS), so say that instead of showing chips that lie. */}
        {boss ? (
          <p className="flex items-center gap-1.5 text-[11px] text-muted-foreground">
            <ShieldCheck className="h-3.5 w-3.5 text-primary" /> {_L("mgmt.rank_boss_note")}
          </p>
        ) : (
          <div className="flex flex-wrap gap-2">
            {permissions.map((p) => (
              <button
                key={p}
                onClick={() => setPerms((m) => ({ ...m, [p]: !m[p] }))}
                className={cn(
                  "rounded-full border px-2.5 py-0.5 text-xs transition-colors",
                  perms[p] ? "border-primary/30 bg-primary/15 text-primary" : "border-border text-muted-foreground hover:bg-accent"
                )}
              >
                {permLabel(p)}
              </button>
            ))}
          </div>
        )}
      </CardContent>
    </Card>
  );
}

// ─── payroll ─────────────────────────────────────────────────────────────────
// Two different pots, one permission (`manage_payroll`). TIPS are staff money the
// restaurant merely holds (unpaid rows — the balance never sees them), split among
// the roster on payout. SALARIES come out of the balance, per rank, and a run is
// ATOMIC: the server refuses the whole thing if the balance can't cover it, which is
// why the button shows the bill before it's pressed.
function Payroll({ id, jobMissing, ranks, roster, tipPool, history, balance }: {
  id: number; jobMissing: boolean; ranks: any[]; roster: any[]; tipPool: number; history: any[]; balance: number;
}) {
  const [busy, setBusy] = useState(false);
  // What the next run costs: every roster member's grade salary. Read off the LIVE
  // mirrored ranks, so editing a salary re-prices the button immediately.
  const bill = useMemo(() => {
    const byGrade: Record<number, number> = {};
    ranks.forEach((r) => { byGrade[Number(r.grade)] = Math.max(0, Math.floor(Number(r.salary) || 0)); });
    return roster.reduce((sum, m) => sum + (byGrade[Number(m.grade ?? 0)] || 0), 0);
  }, [ranks, roster]);

  const run = (event: "management:payTips" | "management:runPayroll") => async () => {
    if (busy) return;
    setBusy(true);
    // Both relays refresh the panel, so the pool / balance / payslip list arrive with
    // the reply — nothing to mirror by hand here.
    await fetchNui(event, { id });
    setBusy(false);
  };

  if (jobMissing) return <JobMissing />;

  return (
    <div className="space-y-3">
      {/* the tip pool */}
      <Card>
        <CardContent className="flex flex-wrap items-center gap-3 pt-4">
          <div className="flex items-center gap-2.5">
            <div className="grid h-9 w-9 place-items-center rounded-md bg-primary/15 text-primary"><Coins className="h-5 w-5" /></div>
            <div>
              <div className="tape">{_L("mgmt.tip_pool_label")}</div>
              <div className="font-mono text-xl font-bold leading-tight tabular-nums">{money(tipPool)}</div>
            </div>
          </div>
          <Button className="ml-auto" disabled={busy || tipPool <= 0} onClick={run("management:payTips")}>
            <Coins className="h-4 w-4" /> {_L("mgmt.pay_tips")}
          </Button>
        </CardContent>
      </Card>
      <p className="px-1 text-[11px] text-muted-foreground">{_L("mgmt.tip_pool_hint")}</p>

      {/* the wage bill */}
      <Card>
        <CardContent className="flex flex-wrap items-center gap-3 pt-4">
          <div className="flex items-center gap-2.5">
            <div className="grid h-9 w-9 place-items-center rounded-md bg-primary/15 text-primary"><Banknote className="h-5 w-5" /></div>
            <div>
              <div className="tape">{_L("mgmt.payroll_bill")}</div>
              <div className="font-mono text-xl font-bold leading-tight tabular-nums">{money(bill)}</div>
              <div className="text-[11px] text-muted-foreground">{_L("mgmt.payroll_of_balance", money(balance), roster.length)}</div>
            </div>
          </div>
          <Button className="ml-auto" disabled={busy || bill <= 0 || bill > (balance || 0)} onClick={run("management:runPayroll")}>
            <Banknote className="h-4 w-4" /> {_L("mgmt.run_payroll")}
          </Button>
        </CardContent>
      </Card>
      <p className="px-1 text-[11px] text-muted-foreground">
        {bill <= 0 ? _L("mgmt.payroll_nobody_owed") : bill > (balance || 0) ? _L("mgmt.payroll_short") : _L("mgmt.payroll_hint")}
      </p>

      {/* what has already been paid — a manager who can't see the ledger still has to
          see this, or they'd pay the same wages twice */}
      <div className="overflow-hidden rounded-lg border border-border bg-card">
        <div className="tape grid grid-cols-5 border-b border-border px-3 py-2">
          <span className="col-span-2">{_L("mgmt.col_who")}</span><span>{_L("mgmt.col_kind")}</span>
          <span>{_L("mgmt.col_amount")}</span><span>{_L("mgmt.col_when")}</span>
        </div>
        {history.map((p: any, i: number) => (
          <div key={i} className="grid grid-cols-5 items-center px-3 py-1.5 text-xs odd:bg-muted/30">
            <span className="col-span-2 truncate">{p.name || p.identifier}</span>
            <span className="text-muted-foreground">{p.kind === "tips" ? _L("mgmt.kind_tips") : _L("mgmt.kind_salary")}</span>
            <span className="font-mono tabular-nums text-ok">{money(p.amount)}</span>
            <span className="truncate font-mono tabular-nums text-muted-foreground">{p.paid_at || ""}</span>
          </div>
        ))}
        {history.length === 0 && <div className="px-3 py-3 text-xs text-muted-foreground">{_L("mgmt.no_payslips")}</div>}
      </div>
    </div>
  );
}

const KIND_LABEL: Record<string, string> = {
  recipe: "register.kind_recipe",
  assembly: "register.kind_assembly",
  craft: "register.kind_craft",
  drink: "register.kind_drink",
  finish: "register.kind_finish",
  condiment: "register.kind_condiment",
};

// The POS price list: one row per sellable the restaurant can access. A price of
// 0 or a disabled toggle means the item is NOT orderable at the register. Edits
// auto-save (debounced per row) — there are no Save buttons anywhere.
function Menu({ id, priceList, stale }: { id: number; priceList: any[]; stale: any[] }) {
  // Filed under GROUP headings, the same way Supplies files the larder and the admin
  // Menu tab files the catalogue: a price list is read by section ("what does the pizza
  // line cost?"), not as one alphabetical wall. Every catalog entry already carries its
  // access group, so this is purely presentational. Ungrouped sorts last.
  const groups = useMemo(() => {
    const by: Record<string, any[]> = {};
    priceList.forEach((e) => { (by[e.group || ""] ||= []).push(e); });
    return Object.keys(by)
      .sort((a, b) => (a === "" ? 1 : b === "" ? -1 : a.localeCompare(b)))
      .map((name) => ({ name, rows: by[name] }));
  }, [priceList]);
  return (
    <div className="space-y-4">
      <p className="text-[11px] text-muted-foreground">{_L("mgmt.price_list_hint")}</p>
      {priceList.length === 0 && <div className="py-4 text-center text-sm text-muted-foreground">{_L("mgmt.no_sellables")}</div>}
      {groups.map((grp) => (
        <div key={grp.name || "__ungrouped__"} className="space-y-2">
          <div className="flex items-center gap-2 px-1 text-xs font-semibold uppercase tracking-wide text-muted-foreground">
            <Tags className="h-3.5 w-3.5" /> {grp.name || _L("menu.ungrouped")}
          </div>
          {grp.rows.map((e: any) => <PriceRow key={e.key} id={id} entry={e} />)}
        </div>
      ))}

      {stale.length > 0 && (
        <div className="mt-4 rounded-lg border border-amber-500/40 p-3">
          <h3 className="mb-2 text-sm font-semibold">{_L("mgmt.price_stale")}</h3>
          {stale.map((s: any) => (
            <div key={s.key} className="flex items-center gap-2 py-1 text-sm">
              {/* a stale row is still a menu entry — it gets its picture like any other,
                  so the owner can see WHAT they're about to delete off the menu */}
              <Thumb src={s.image} alt={s.label} className="h-8 w-8 shrink-0" />
              <span className="min-w-0 flex-1 truncate text-muted-foreground">{s.label} · {money(s.price)}</span>
              <Button size="sm" variant="destructive" onClick={() => fetchNui("management:deleteMenuItem", { id, key: s.key })}>
                <Trash2 className="h-4 w-4" />
              </Button>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}

function PriceRow({ id, entry }: { id: number; entry: any }) {
  const def = Math.max(0, Math.floor(entry.defaultPrice || 0));
  // The price input is an OVERRIDE: empty = fall back to the ingredient-cost
  // default. `priceIsDefault` means there's no per-restaurant row yet.
  const [price, setPrice] = useState<string>(entry.priceIsDefault ? "" : String(entry.price ?? ""));
  const [enabled, setEnabled] = useState<boolean>(!!entry.enabled);
  const first = useRef(true);

  useEffect(() => {
    if (first.current) { first.current = false; return; }
    const t = setTimeout(() => {
      const raw = price.trim();
      const num = raw === "" ? null : Math.max(0, Math.floor(Number(raw) || 0));
      if (num === null && enabled) {
        // pure default (blank price, orderable) — remove any override row
        fetchNui("management:deleteMenuItem", { id, key: entry.key });
      } else {
        fetchNui("management:saveMenuItem", { id, key: entry.key, price: num ?? def, enabled });
      }
    }, 500);
    return () => clearTimeout(t);
  }, [price, enabled]);

  const effPrice = price.trim() === "" ? def : Math.max(0, Math.floor(Number(price) || 0));
  const orderable = enabled && effPrice > 0;
  return (
    <Card>
      <CardContent className="flex items-center gap-3 pt-4 text-sm">
        <Thumb src={entry.image} className="h-10 w-10 shrink-0" />
        <div className="min-w-0 flex-1">
          <div className="flex items-center gap-2">
            <span className="truncate font-medium">{entry.label}</span>
            <Badge variant="secondary">{_L(KIND_LABEL[entry.kind] || "register.kind_recipe")}</Badge>
            {!orderable && <span className="text-[11px] text-muted-foreground">{_L("mgmt.not_orderable")}</span>}
          </div>
          {def > 0 && <div className="text-[11px] text-muted-foreground">{_L("mgmt.price_default_hint", def)}</div>}
        </div>
        <div className="flex shrink-0 items-center gap-3">
          <div className="flex items-center gap-1">
            <span className="text-muted-foreground">$</span>
            <Input type="number" min={0} value={price} placeholder={String(def)} onChange={(e) => setPrice(e.target.value)} className="h-8 w-20" />
          </div>
          <Toggle checked={enabled} onChange={setEnabled} />
        </div>
      </CardContent>
    </Card>
  );
}

// The Supplies tab: buy raw ingredients into the restaurant's shared stock pool
// (paid from the restaurant balance). The kitchen cooks from this stock.
/**
 * THE TWO HALVES OF THIS TAB ANSWER TO DIFFERENT PLACES once supply runs are on.
 * BUYING happens at a depot counter (`canBuy`), because that is where the boxes are.
 * MOVING stock between the larder and your own pockets (`canMove`) stays in the panel,
 * because it is not a purchase and has nothing to do with a depot. With runs off both
 * are true here and the tab is exactly what it always was.
 */
function Supplies({ id, supplies, runs, canBuy, canMove, balance }: { id: number; supplies: any[]; runs?: any; canBuy?: boolean; canMove?: boolean; balance?: number }) {
  // The order being built, as { stock key -> qty }. A CART rather than a buy button per
  // row: restocking is one shopping trip, not eight separate purchases, and the payment
  // method is a decision about the whole basket.
  const [cart, setCart] = useState<Record<string, number>>({});
  const byKey = useMemo(() => {
    const m: Record<string, any> = {};
    supplies.forEach((s) => { m[s.key || s.item] = s; });
    return m;
  }, [supplies]);
  const lines = Object.keys(cart).map((k) => ({ key: k, qty: cart[k], supply: byKey[k] })).filter((l) => l.supply);
  const total = lines.reduce((n, l) => n + (l.supply.cost || 0) * l.qty, 0);
  const units = lines.reduce((n, l) => n + l.qty, 0);

  // THE UI ENFORCES THE SAME TWO CEILINGS THE SERVER DOES. Not because it is a security
  // boundary (BuySupplies re-checks both, and that is what actually decides), but
  // because an order you are allowed to build and never allowed to pay for is a worse
  // answer than a stepper that stops:
  //   • the per-item CAP counts what is in the larder, what is already bought and
  //     waiting at the depot, and what is already in this cart;
  //   • the run CAPACITY is what one rig can haul, across the whole basket.
  const cap = runs?.cap || 0;
  const capacity = runs?.capacity || 0;
  const capacityLeft = capacity > 0 ? Math.max(0, capacity - units) : Infinity;
  // How many more of one key may still be added. Infinity where a ceiling is off, so
  // the callers can just Math.min without special-casing "no limit".
  const roomFor = (key: string) => {
    const s = byKey[key];
    if (!s) return 0;
    const byCap = cap > 0
      ? Math.max(0, cap - (s.stock || 0) - (s.pending || 0) - (cart[key] || 0))
      : Infinity;
    return Math.min(byCap, capacityLeft);
  };

  const addToCart = (key: string, qty: number) => {
    const room = roomFor(key);
    const add = Math.min(qty, room === Infinity ? qty : room);
    if (add <= 0) return;
    setCart((c) => ({ ...c, [key]: (c[key] || 0) + add }));
  };
  // A cart line is clamped against the ceilings MINUS itself: the room calculation
  // already subtracts what this line holds, so its own units have to be handed back
  // before asking how big it may become.
  const setLine = (key: string, qty: number) => {
    const room = roomFor(key);
    const max = room === Infinity ? qty : (cart[key] || 0) + room;
    const next = Math.min(Math.max(0, qty), max);
    setCart((c) => {
      const n = { ...c };
      if (next <= 0) delete n[key]; else n[key] = next;
      return n;
    });
  };

  const checkout = async (payment: "society" | "cash") => {
    const res = await fetchNui<any>("management:buySupplies", {
      id, payment, lines: lines.map((l) => ({ key: l.key, qty: l.qty })),
    });
    if (res && res.ok) setCart({});
  };

  // Filed under the same GROUP headings the admin Menu tab uses — a larder is read
  // by section ("what do I need for the pizza line?"), not as one alphabetical wall.
  // Ungrouped sorts last, exactly as it does there; the server sends the group.
  const groups = useMemo(() => {
    const by: Record<string, any[]> = {};
    supplies.forEach((s) => { (by[s.group || ""] ||= []).push(s); });
    return Object.keys(by)
      .sort((a, b) => (a === "" ? 1 : b === "" ? -1 : a.localeCompare(b)))
      .map((name) => ({ name, rows: by[name] }));
  }, [supplies]);
  return (
    <div className="space-y-4">
      <p className="text-[11px] text-muted-foreground">
        {canBuy ? _L("mgmt.supplies_hint") : _L("mgmt.supply_move_only")}
      </p>
      {/* SUPPLY RUNS: what has been bought and is still sitting at the depot. Only
          rendered when the feature is on, so the tab is unchanged on a server that
          hasn't enabled it. */}
      {runs?.enabled && (runs.pending || []).length > 0 && (
        <Card>
          <CardContent className="py-3">
            <div className="flex items-center gap-2 text-sm font-semibold">
              <Truck className="h-4 w-4 text-primary" /> {_L("mgmt.supply_waiting_title")}
            </div>
            <p className="mb-2 text-[11px] text-muted-foreground">{_L("mgmt.supply_waiting_hint")}</p>
            <div className="space-y-1">
              {(runs.pending || []).map((o: any) => (
                <div key={o.id} className="flex items-center gap-2 text-xs">
                  <span className="truncate">
                    {(o.lines || []).map((l: any) => `${l.qty}x ${l.label}`).join(", ")}
                  </span>
                  <span className="ml-auto shrink-0 font-mono text-muted-foreground">
                    {_L("mgmt.supply_waiting_boxes", String(o.boxes))}
                  </span>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      )}
      {supplies.length === 0 && <div className="py-4 text-center text-sm text-muted-foreground">{_L("mgmt.no_supplies")}</div>}
      {groups.map((grp) => (
        <div key={grp.name || "__ungrouped__"} className="space-y-2">
          <div className="flex items-center gap-2 px-1 text-xs font-semibold uppercase tracking-wide text-muted-foreground">
            <Tags className="h-3.5 w-3.5" /> {grp.name || _L("menu.ungrouped")}
          </div>
          {grp.rows.map((s) => (
            <SupplyRow key={s.key || s.item} id={id} supply={s} cap={cap}
              canBuy={canBuy} canMove={canMove} inCart={cart[s.key || s.item] || 0}
              room={roomFor(s.key || s.item)} onAdd={addToCart} />
          ))}
        </div>
      ))}

      {/* THE ORDER. Sticky at the bottom so the total and the payment choice stay
          visible while scrolling a long larder. */}
      {canBuy && (
        <Card className="sticky bottom-0">
          <CardContent className="py-3">
            <div className="mb-2 flex items-center gap-2 text-sm font-semibold">
              <PackagePlus className="h-4 w-4 text-primary" /> {_L("mgmt.cart_title")}
            </div>
            {lines.length === 0 ? (
              <p className="text-[11px] text-muted-foreground">{_L("mgmt.cart_empty")}</p>
            ) : (
              // THE LIST SCROLLS, THE CARD DOESN'T GROW. It is sticky to the bottom of
              // the tab, so an unbounded line list climbs the screen and eventually
              // covers the larder it is being filled from. Capped here and scrolled
              // internally, the total and the payment buttons stay put however many
              // lines the order has.
              <div className="max-h-40 space-y-1 overflow-y-auto pr-1">
                {lines.map((l) => (
                  <div key={l.key} className="flex items-center gap-2 text-xs">
                    <span className="min-w-0 flex-1 truncate">{l.supply.label}</span>
                    <div className="flex shrink-0 items-center">
                      <Button size="icon" variant="ghost" onClick={() => setLine(l.key, l.qty - 1)}><Minus className="h-3 w-3" /></Button>
                      <span className="w-8 text-center font-mono">{l.qty}</span>
                      <Button size="icon" variant="ghost" disabled={roomFor(l.key) <= 0} onClick={() => setLine(l.key, l.qty + 1)}><Plus className="h-3 w-3" /></Button>
                    </div>
                    <span className="w-16 shrink-0 text-right font-mono">{money((l.supply.cost || 0) * l.qty)}</span>
                    <Button size="icon" variant="ghost" onClick={() => setLine(l.key, 0)} title={_L("mgmt.cart_remove")}>
                      <Trash2 className="h-3 w-3" />
                    </Button>
                  </div>
                ))}
              </div>
            )}
            <div className="mt-2 flex flex-wrap items-center gap-2 border-t border-line pt-2">
              {/* What the basket is, in the units the depot deals in: a box count is
                  what turns "180 units" into "how many trips is this". */}
              {capacity > 0 && (
                <span className={cn("text-xs", capacityLeft <= 0 ? "text-destructive" : "text-muted-foreground")}>
                  {_L("mgmt.cart_load", String(units), String(Math.ceil(units / Math.max(1, runs?.boxUnits || 1))))}
                </span>
              )}
              <span className="text-xs text-muted-foreground">{_L("mgmt.cart_total")}</span>
              <span className="font-mono text-sm font-semibold">{money(total)}</span>
              <span className="ml-auto" />
              {/* Two pockets, one basket: the business account, or the buyer's own
                  cash so an empty account is never a dead end. */}
              <Button size="sm" variant="outline" disabled={lines.length === 0 || (balance || 0) < total} onClick={() => checkout("society")}>
                <Banknote className="h-4 w-4" /> {_L("mgmt.cart_pay_society")}
              </Button>
              <Button size="sm" disabled={lines.length === 0} onClick={() => checkout("cash")}>
                <Coins className="h-4 w-4" /> {_L("mgmt.cart_pay_cash")}
              </Button>
            </div>
          </CardContent>
        </Card>
      )}
    </div>
  );
}

function SupplyRow({ id, supply, cap, canBuy, canMove, inCart, room, onAdd }: { id: number; supply: any; cap?: number; canBuy?: boolean; canMove?: boolean; inCart?: number; room?: number; onAdd?: (key: string, qty: number) => void }) {
  const [qty, setQty] = useState(5);
  const [stock, setStock] = useState<number>(supply.stock || 0);
  const [held, setHeld] = useState<number>(supply.held || 0);
  // Everything addresses the STOCK KEY, which for a multi-faced ingredient names
  // the face (`restaurant_toy:lardboy`) rather than the item — that is what the
  // larder counts and prices. `item` is still sent so an older server that only
  // understands item names keeps working.
  const key = supply.key || supply.item;
  // Units already bought and waiting at the depot. They count against the cap, so the
  // row has to show them or it is lying about how much more can be ordered.
  const [pending, setPending] = useState<number>(supply.pending || 0);
  // The cap readout on the row (null = uncapped). Distinct from the `room` PROP,
  // which is what the CART may still take and drives the stepper.
  const capRoom = cap && cap > 0 ? Math.max(0, cap - stock - pending) : null;
  // Buying moved OUT of the row, so the row no longer updates its own counts after a
  // purchase: the cart's checkout refreshes the whole panel instead. Re-seed from the
  // fresh payload or these would sit on the numbers they mounted with.
  useEffect(() => {
    setStock(supply.stock || 0);
    setHeld(supply.held || 0);
    setPending(supply.pending || 0);
  }, [supply.stock, supply.held, supply.pending]);

  // Rows ADD to the order and the cart pays for it in one go, with one payment
  // decision for the basket.
  //
  // THE STEPPER IS RIGID. `room` is how many more of this key the cart may hold (the
  // per-item cap minus larder + pending + what is already in the basket, and the run
  // capacity across the whole order), so the control simply cannot be driven past it:
  // typing 9999 clamps, the + stops, and Add greys out at zero. The server checks the
  // same thing, but an order you can build and never pay for is a worse answer than a
  // stepper that stops.
  const maxQty = room === undefined ? 1000 : Math.min(1000, room);
  const q = Math.max(1, Math.min(qty, Math.max(1, maxQty)));
  const add = () => onAdd?.(key, q);
  // ADD MAX fills the remaining room in one click, which is what restocking actually
  // is: with a cap on, that is "top this line back up to full" and, once the load is
  // the binding limit, "fill the rest of the truck". It prices what it would add right
  // on the button, because the whole point is committing to a number you didn't type.
  // Safe to be literal about the ceiling (1000 a line uncapped, the server's own clamp)
  // since this adds to the CART: nothing is spent until the basket is paid for.
  const addMax = () => onAdd?.(key, maxQty);
  // Deposit moves the manager's own items INTO the shared pool; withdraw pulls
  // pool stock back OUT into their pockets. Both echo the fresh stock + held
  // counts so the row stays live without re-fetching the whole panel.
  const move = (event: "management:depositStock" | "management:withdrawStock") => async () => {
    const res = await fetchNui<any>(event, { id, key, item: supply.item, qty });
    if (res && res.ok) { setStock(res.stock); setHeld(res.held); }
  };
  return (
    <Card>
      {/* ONE row: the identity column and the controls column are siblings on the
          same line, so the card is as tall as its tallest control — not an info row
          stacked over a button row (which left the thumb/label column half-height). */}
      <CardContent className="flex flex-wrap items-center gap-x-3 gap-y-2 py-3 text-sm">
        <Thumb src={supply.image} className="h-10 w-10 shrink-0" />
        <div className="min-w-0 flex-1 basis-48">
          <div className="flex items-center gap-2">
            <span className="truncate font-medium">{supply.label}</span>
            {!supply.installed && <Badge variant="destructive">{_L("mgmt.not_installed")}</Badge>}
            {/* buyable, but the kitchen can't use it until an admin adds the group */}
            {supply.locked && <Badge variant="outline">{_L("mgmt.group_locked", supply.lockedGroup || "?")}</Badge>}
          </div>
          <div className="text-[11px] text-muted-foreground">
            {_L("mgmt.cost_each", money(supply.cost))} · {_L("mgmt.in_stock", stock)}
            {capRoom !== null && <> · {_L("mgmt.supply_cap", String(cap))}</>}
            {canBuy && (room ?? 1) <= 0 && <> · <span className="text-destructive">{_L("mgmt.cart_no_room")}</span></>}
            {pending > 0 && <> · {_L("mgmt.supply_pending_units", String(pending))}</>}
            {/* A face isn't movable between pocket and larder (the inventory item is
                generic), so "you hold N" would always read 0 and mean nothing. */}
            {supply.movable && <> · {_L("mgmt.you_hold", held)}</>}
          </div>
        </div>
        <div className="flex shrink-0 items-center">
          <Button size="icon" variant="ghost" onClick={() => setQty(Math.max(1, q - 1))}><Minus className="h-3.5 w-3.5" /></Button>
          <Input type="number" min={1} max={maxQty} value={q}
            onChange={(e) => setQty(Math.max(1, Math.min(maxQty, Math.floor(Number(e.target.value) || 1))))}
            className="h-8 w-16 text-center" />
          <Button size="icon" variant="ghost" disabled={q >= maxQty} onClick={() => setQty(Math.min(maxQty, q + 1))}><Plus className="h-3.5 w-3.5" /></Button>
        </div>
        <div className="flex shrink-0 items-center gap-2">
          {canMove && supply.movable && (
            <>
              <Button size="sm" variant="outline" onClick={move("management:depositStock")} disabled={held < qty} title={_L("mgmt.deposit_stock_hint")}>
                <ArrowDownToLine className="h-4 w-4" /> {_L("mgmt.deposit_stock")}
              </Button>
              <Button size="sm" variant="outline" onClick={move("management:withdrawStock")} disabled={stock < qty} title={_L("mgmt.withdraw_stock_hint")}>
                <ArrowUpFromLine className="h-4 w-4" /> {_L("mgmt.withdraw_stock")}
              </Button>
            </>
          )}
          {canBuy && (
            <>
              <Button size="sm" variant="outline" onClick={addMax} disabled={maxQty <= 0}
                title={_L("mgmt.cart_add_max_hint", String(maxQty))}>
                {_L("mgmt.cart_add_max")} · {money(supply.cost * maxQty)}
              </Button>
              <Button size="sm" onClick={add} disabled={(room ?? 1) <= 0}>
                <PackagePlus className="h-4 w-4" /> {_L("mgmt.cart_add")} · {money(supply.cost * q)}
                {(inCart || 0) > 0 && <Badge variant="secondary">{inCart}</Badge>}
              </Button>
            </>
          )}
        </div>
      </CardContent>
    </Card>
  );
}

function Finances({ id, balance, ledger, canManage }: any) {
  const [amount, setAmount] = useState(0);
  return (
    <div className="space-y-3">
      <Card>
        <CardContent className="flex items-center justify-between pt-4">
          <div className="flex items-center gap-2.5">
            <div className="grid h-9 w-9 place-items-center rounded-md bg-primary/15 text-primary"><Banknote className="h-5 w-5" /></div>
            <div>
              <div className="tape">{_L("mgmt.balance_label")}</div>
              <div className="font-mono text-xl font-bold leading-tight tabular-nums">{money(balance)}</div>
            </div>
          </div>
          {canManage && (
            <div className="flex items-center gap-2">
              <Input type="number" className="w-28" value={amount} onChange={(e) => setAmount(Number(e.target.value))} />
              <Button size="sm" onClick={() => fetchNui("management:deposit", { id, amount })}>{_L("mgmt.deposit")}</Button>
              <Button size="sm" variant="outline" onClick={() => fetchNui("management:withdraw", { id, amount })}>{_L("mgmt.withdraw")}</Button>
            </div>
          )}
        </CardContent>
      </Card>
      <div className="overflow-hidden rounded-lg border border-border bg-card">
        <div className="tape grid grid-cols-4 border-b border-border px-3 py-2">
          <span>{_L("mgmt.col_type")}</span><span>{_L("mgmt.col_amount")}</span><span className="col-span-2">{_L("mgmt.col_description")}</span>
        </div>
        {ledger.map((l: any, i: number) => (
          <div key={i} className="grid grid-cols-4 px-3 py-1.5 text-xs odd:bg-muted/30">
            <span className="capitalize">{l.type}</span>
            <span className={cn("font-mono tabular-nums", l.amount < 0 ? "text-destructive" : "text-ok")}>{money(l.amount)}</span>
            <span className="col-span-2 truncate text-muted-foreground">{l.description}</span>
          </div>
        ))}
        {ledger.length === 0 && <div className="px-3 py-3 text-xs text-muted-foreground">{_L("mgmt.no_transactions")}</div>}
      </div>
    </div>
  );
}
