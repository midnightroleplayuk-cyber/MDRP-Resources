import { useCallback, useEffect, useMemo, useState } from 'react';
import { call } from '../lib/nui';
import { duration, ukDate } from '../lib/format';
import { Button, Empty, ErrorBanner, Field, Frame, NavItem, Tag, statusTag } from '../components/ui';
import TabletDevice, { DeviceKey } from '../components/TabletDevice';
import PrisonerFileView from './tablet/PrisonerFile';
import RegimeView from './tablet/Regime';
import Adjudications from './tablet/Adjudications';
import Industries from './tablet/Industries';
import IncidentsView from './tablet/Incidents';
import Intelligence from './tablet/Intelligence';
import Cctv from './tablet/Cctv';
import VisitsCalls from './tablet/VisitsCalls';
import Gangs from './tablet/Gangs';
import HealthcareView from './tablet/Healthcare';
import Movements from './tablet/Movements';
import Parole from './tablet/Parole';
import type { Prisoner, TabletConfig, TabletWing, UiConfig } from '../types';

type Initial = {
  me: { name: string; rank: string; nodes: string[] };
  prisons: { id: number; code: string; name: string }[];
  prisonId: number;
  roster: Prisoner[];
  wings: TabletWing[];
  doorLockdown?: boolean;
  categories: string[];
  config: TabletConfig;
  device?: { enabled: boolean; buttons: Record<string, string> };
  startView?: string;
};

const KEY_LABELS: Record<string, string> = {
  roll: 'Roll', regime: 'Regime', incidents: 'Incidents', adjudications: 'Adjudications', industries: 'Industries',
  security: 'Security', cctv: 'CCTV', visits: 'Visits and calls', movements: 'Movements', parole: 'Parole',
  healthcare: 'Healthcare', cells: 'Cells and doors', audit: 'Audit log', alarm: 'Raise a general alarm', none: '',
};

type View = 'roster' | 'regime' | 'incidents' | 'adjudications' | 'industries' | 'security' | 'cctv' | 'visits' | 'gangs' | 'healthcare' | 'movements' | 'parole' | 'cells' | 'audit';

export default function Tablet({ initial, ui, onClose }: { initial: Initial; ui: UiConfig; onClose: () => void }) {
  const [view, setView] = useState<View>((initial.startView as View) || 'roster');
  const [prisonId, setPrisonId] = useState(initial.prisonId);
  const [roster, setRoster] = useState<Prisoner[]>(initial.roster);
  const [wings, setWings] = useState<TabletWing[]>(initial.wings);
  const [doorLockdown, setDoorLockdown] = useState(!!initial.doorLockdown);
  const [selected, setSelected] = useState<number | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [toast, setToast] = useState<string | null>(null);
  const [alarmArmed, setAlarmArmed] = useState(false);
  const [poweringOff, setPoweringOff] = useState(false);
  const nodes = useMemo(() => new Set(initial.me.nodes), [initial.me.nodes]);
  const can = (node: string) => nodes.has(node);

  const refresh = useCallback(async (pid = prisonId) => {
    const res = await call<{ roster: Prisoner[]; wings: TabletWing[]; doorLockdown?: boolean }>('tablet:roster', pid);
    if (res.ok) { setRoster(res.roster); setWings(res.wings); setDoorLockdown(!!res.doorLockdown); } else setError(res.error);
  }, [prisonId]);

  useEffect(() => {
    const t = setInterval(() => refresh(), 15000);
    return () => clearInterval(t);
  }, [refresh]);

  const prison = initial.prisons.find((p) => p.id === prisonId);

  useEffect(() => { if (!toast) return; const t = setTimeout(() => setToast(null), 3500); return () => clearTimeout(t); }, [toast]);
  useEffect(() => { if (!alarmArmed) return; const t = setTimeout(() => setAlarmArmed(false), 3000); return () => clearTimeout(t); }, [alarmArmed]);

  const buttons = initial.device?.buttons ?? { p1: 'roll', p2: 'incidents', p3: 'alarm', home: 'roll' };
  const runAction = async (action: string) => {
    if (!action || action === 'none') return;
    if (action === 'alarm') {
      if (!can('alarm.raise')) return setToast('Your rank cannot raise alarms.');
      if (!alarmArmed) { setAlarmArmed(true); return setToast('Press again to raise a general alarm'); }
      setAlarmArmed(false);
      const res = await call('incidents:raise', 'general', 'Raised from tablet');
      if (res.ok) setToast('General alarm raised'); else setError(res.error);
      return;
    }
    setSelected(null);
    setView(action as View);
    if (action === 'roll') refresh();
  };
  const onKey = (key: DeviceKey) => {
    if (key === 'power') { setPoweringOff(true); setTimeout(onClose, 260); return; }
    runAction(buttons[key] ?? '');
  };
  const keyLabels = {
    power: 'Power: close the tablet',
    p1: `P1: ${KEY_LABELS[buttons.p1] ?? buttons.p1}`,
    p2: `P2: ${KEY_LABELS[buttons.p2] ?? buttons.p2}`,
    p3: `P3: ${KEY_LABELS[buttons.p3] ?? buttons.p3}`,
    home: `Home: ${KEY_LABELS[buttons.home] ?? buttons.home}`,
  };
  const inCustody = roster.filter((p) => p.status !== 'pending').length;
  const pending = roster.length - inCustody;

  const nav = (
    <>
      <NavItem active={view === 'roster'} onClick={() => { setView('roster'); setSelected(null); }} count={roster.length}>Roll</NavItem>
      {initial.config.regime && <NavItem active={view === 'regime'} onClick={() => setView('regime')}>Regime</NavItem>}
      {initial.config.incidents && <NavItem active={view === 'incidents'} onClick={() => setView('incidents')}>Incidents</NavItem>}
      {initial.config.discipline && <NavItem active={view === 'adjudications'} onClick={() => setView('adjudications')}>Adjudications</NavItem>}
      {initial.config.jobs && <NavItem active={view === 'industries'} onClick={() => setView('industries')}>Industries</NavItem>}
      {initial.config.intel && <NavItem active={view === 'security'} onClick={() => setView('security')}>Security</NavItem>}
      {initial.config.visits && <NavItem active={view === 'visits'} onClick={() => setView('visits')}>Visits and calls</NavItem>}
      {initial.config.gangs && can('intel.read') && <NavItem active={view === 'gangs'} onClick={() => setView('gangs')}>Gangs</NavItem>}
      {initial.config.healthcare && can('healthcare.view') && <NavItem active={view === 'healthcare'} onClick={() => setView('healthcare')}>Healthcare</NavItem>}
      {initial.config.transport && <NavItem active={view === 'movements'} onClick={() => setView('movements')}>Movements</NavItem>}
      {initial.config.parole && can('parole.review') && <NavItem active={view === 'parole'} onClick={() => setView('parole')}>Parole</NavItem>}
      {initial.config.cctv && can('cctv.view') && <NavItem active={view === 'cctv'} onClick={() => setView('cctv')}>CCTV</NavItem>}
      <NavItem active={view === 'cells'} onClick={() => setView('cells')}>Cells and doors</NavItem>
      {can('audit.view') && <NavItem active={view === 'audit'} onClick={() => setView('audit')}>Audit log</NavItem>}
      <div className="sidenav__spacer" />
      <div className="sidenav__meta">{initial.me.name}<br />{initial.me.rank}</div>
    </>
  );

  const device = initial.device?.enabled !== false;
  const screen = (
    <Frame embedded={device} title={prison?.name ?? ui.prisonDisplayName} service={ui.serviceName} subtitle={`Roll ${inCustody}${pending ? `, ${pending} at reception` : ''}`} nav={nav} onClose={onClose}>
      <ErrorBanner code={error} onDismiss={() => setError(null)} />
      {toast && <div className={`toast${alarmArmed ? ' toast--alarm' : ''}`} role="status">{toast}</div>}
      {initial.prisons.length > 1 && view !== 'audit' && (
        <div className="toolbar">
          <Field label="Prison" id="prison">
            <select id="prison" className="select" value={prisonId} onChange={(e) => { const id = Number(e.target.value); setPrisonId(id); setSelected(null); refresh(id); }}>
              {initial.prisons.map((p) => <option key={p.id} value={p.id}>{p.name}</option>)}
            </select>
          </Field>
        </div>
      )}
      {view === 'roster' && selected == null && <Roster roster={roster} onOpen={setSelected} onRefresh={() => refresh()} />}
      {view === 'roster' && selected != null && (
        <PrisonerFileView id={selected} can={can} wings={wings} categories={initial.categories} config={initial.config}
          onBack={() => { setSelected(null); refresh(); }} onError={setError} />
      )}
      {view === 'regime' && <RegimeView prisonId={prisonId} can={can} onError={setError} />}
      {view === 'adjudications' && <Adjudications prisonId={prisonId} can={can} config={initial.config} onError={setError} onOpen={(id) => { setView('roster'); setSelected(id); }} />}
      {view === 'industries' && <Industries prisonId={prisonId} can={can} onError={setError} onOpen={(id) => { setView('roster'); setSelected(id); }} />}
      {view === 'incidents' && <IncidentsView prisonId={prisonId} can={can} config={initial.config} wings={wings} onError={setError} />}
      {view === 'security' && <Intelligence prisonId={prisonId} can={can} config={initial.config} roster={roster} onError={setError} />}
      {view === 'visits' && <VisitsCalls prisonId={prisonId} can={can} onError={setError} />}
      {view === 'gangs' && <Gangs prisonId={prisonId} can={can} onError={setError} />}
      {view === 'healthcare' && <HealthcareView prisonId={prisonId} can={can} onError={setError} onOpen={(id) => { setView('roster'); setSelected(id); }} />}
      {view === 'movements' && <Movements prisonId={prisonId} can={can} roster={roster} onError={setError} />}
      {view === 'parole' && <Parole prisonId={prisonId} config={initial.config} onError={setError} />}
      {view === 'cctv' && <Cctv prisonId={prisonId} onError={setError} />}
      {view === 'cells' && <Cells wings={wings} can={can} prisonId={prisonId} doorLockdown={doorLockdown} onError={setError} onChanged={() => refresh()} onOpen={(id) => { setView('roster'); setSelected(id); }} />}
      {view === 'audit' && <Audit onError={setError} />}
    </Frame>
  );
  if (!device) return screen;
  return <TabletDevice onKey={onKey} labels={keyLabels} poweringOff={poweringOff}>{screen}</TabletDevice>;
}

function Roster({ roster, onOpen, onRefresh }: { roster: Prisoner[]; onOpen: (id: number) => void; onRefresh: () => void }) {
  const [query, setQuery] = useState('');
  const shown = roster.filter((p) => {
    const q = query.trim().toLowerCase();
    return !q || p.name.toLowerCase().includes(q) || p.prisonNo.toLowerCase().includes(q) || (p.cell ?? '').toLowerCase().includes(q);
  });
  return (
    <>
      <div className="toolbar">
        <h1 className="toolbar__grow">Roll</h1>
        <input className="input" style={{ maxWidth: 260 }} placeholder="Search name, number or cell" value={query} onChange={(e) => setQuery(e.target.value)} />
        <Button variant="secondary" onClick={onRefresh}>Refresh</Button>
      </div>
      {shown.length === 0 ? <Empty>{roster.length ? 'Nobody matches that search.' : 'Nobody is in custody.'}</Empty> : (
        <table className="table">
          <thead>
            <tr><th>Cell</th><th>Prison no.</th><th>Name</th><th>Cat.</th><th>Status</th><th className="num">Release in</th></tr>
          </thead>
          <tbody>
            {shown.map((p) => (
              <tr key={p.id} className="is-clickable" onClick={() => onOpen(p.id)}>
                <td className="mono">{p.cell ?? '—'}</td>
                <td className="mono">{p.prisonNo}</td>
                <td>{p.name} {!p.online && <Tag>Offline</Tag>}</td>
                <td>{p.category}</td>
                <td>{statusTag(p.status)} {p.segregated && <Tag tone="red">Segregation</Tag>}</td>
                <td className="num">{p.sentence?.remand ? <Tag>Remand</Tag> : p.sentence?.remaining === 0 ? 'Due now' : duration(p.sentence?.remaining)}</td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </>
  );
}

function Cells({ wings, can, prisonId, doorLockdown, onError, onChanged, onOpen }: {
  wings: TabletWing[]; can: (n: string) => boolean; prisonId: number; doorLockdown: boolean;
  onError: (e: string) => void; onChanged: () => void; onOpen: (id: number) => void;
}) {
  const remote = can('door.remote');
  const canLockdown = can('lockdown.prison');
  const [confirming, setConfirming] = useState(false);
  const setLockdown = async (on: boolean) => {
    setConfirming(false);
    const res = await call('doors:lockdown', prisonId, on);
    if (!res.ok) onError(res.error); else onChanged();
  };
  const door = async (id: number, locked: boolean) => {
    const res = await call('doors:remote', id, locked);
    if (!res.ok) onError(res.error); else onChanged();
  };
  const wingDoors = async (id: number, locked: boolean) => {
    const res = await call('doors:wing', id, locked);
    if (!res.ok) onError(res.error); else onChanged();
  };

  return (
    <>
      <h1>Cells and doors</h1>
      {doorLockdown ? (
        <div className="lockdown-banner" role="alert">
          <div>
            <strong>Door lockdown</strong>
            <span>Every door is locked and held. {canLockdown ? 'You can still open a single door.' : 'Only a Duty Governor or above can open a door.'}</span>
          </div>
          {canLockdown && <Button variant="secondary" onClick={() => setLockdown(false)}>Lift door lockdown</Button>}
        </div>
      ) : canLockdown && (
        <div className="toolbar">
          {confirming ? (
            <>
              <span className="toolbar__grow"><strong>Lock and hold every door in the prison?</strong> Cells, gates, normal and perimeter doors. Nobody below Duty Governor can open one until it is lifted.</span>
              <Button variant="warning" onClick={() => setLockdown(true)}>Yes, lock every door</Button>
              <Button variant="link" onClick={() => setConfirming(false)}>Cancel</Button>
            </>
          ) : (
            <>
              <span className="toolbar__grow" />
              <Button variant="warning" onClick={() => setConfirming(true)}>Door lockdown</Button>
            </>
          )}
        </div>
      )}
      {!remote && <p className="lede">Opening doors from the tablet needs Supervising Officer or above. Below that, use the door itself with a keycard of the right level.</p>}
      {wings.length === 0 && <Empty>No doors or wings have been set up. An administrator can add them with the editor.</Empty>}
      {wings.map((w) => {
        const linked = new Set(w.cells.map((c) => c.doorId).filter(Boolean));
        const other = w.doors.filter((d) => !linked.has(d.id));
        const occupied = w.cells.reduce((n, c) => n + c.occupants.length, 0);
        const capacity = w.cells.reduce((n, c) => n + c.capacity, 0);
        return (
          <section className="wing" key={w.id}>
            <div className="wing__head">
              <h2>{w.name}</h2>
              {w.id === 0
                ? <span className="muted">Normal doors, gates and perimeter doors that aren't on a wing.</span>
                : <span className="muted">Holds category {w.security} and below. {occupied} of {capacity} spaces in use.</span>}
              <span className="toolbar__grow" />
              {remote && w.id !== 0 && <Button variant="secondary" small onClick={() => wingDoors(w.id, true)}>Lock all doors</Button>}
              {remote && w.id !== 0 && !doorLockdown && <Button variant="secondary" small onClick={() => wingDoors(w.id, false)}>Unlock all doors</Button>}
            </div>
            <table className="table">
              <thead><tr><th>Cell</th><th>Occupants</th><th>Door</th><th /></tr></thead>
              <tbody>
                {w.cells.map((c) => (
                  <tr key={c.id}>
                    <td className="mono">{c.label}</td>
                    <td>
                      {c.occupants.length === 0 ? <span className="muted">Empty</span> : c.occupants.map((o, i) => (
                        <span key={o.id}>{i > 0 && ', '}<button className="btn btn--link btn--small" onClick={() => onOpen(o.id)}>{o.name}</button></span>
                      ))}
                      <span className="muted"> ({c.occupants.length}/{c.capacity})</span>
                    </td>
                    <td>{c.doorId == null ? <span className="muted">No door linked</span> : c.locked ? <Tag tone="red">Locked</Tag> : <Tag tone="green">Unlocked</Tag>}</td>
                    <td className="num">
                      {remote && c.doorId != null && (
                        <Button variant="secondary" small onClick={() => door(c.doorId!, !c.locked)}>{c.locked ? 'Unlock' : 'Lock'}</Button>
                      )}
                    </td>
                  </tr>
                ))}
                {other.map((d) => (
                  <tr key={`d${d.id}`}>
                    <td>{d.label}</td>
                    <td className="muted">{d.kind === 'gate' ? 'Wing gate' : d.kind === 'perimeter' ? 'Perimeter door' : d.kind === 'cell' ? 'Cell door' : 'Door'}</td>
                    <td>{d.locked ? <Tag tone="red">Locked</Tag> : <Tag tone="green">Unlocked</Tag>}</td>
                    <td className="num">{remote && <Button variant="secondary" small onClick={() => door(d.id, !d.locked)}>{d.locked ? 'Unlock' : 'Lock'}</Button>}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </section>
        );
      })}
    </>
  );
}

type AuditRow = { id: number; actor: string; action: string; target?: string; payload?: string; created_at: number };

function Audit({ onError }: { onError: (e: string) => void }) {
  const [rows, setRows] = useState<AuditRow[]>([]);
  const [page, setPage] = useState(0);
  const [search, setSearch] = useState('');

  const load = useCallback(async (p: number, q: string) => {
    const res = await call<{ rows: AuditRow[] }>('tablet:audit', p, q);
    if (res.ok) { setRows(res.rows); setPage(p); } else onError(res.error);
  }, []);

  useEffect(() => { load(0, ''); }, [load]);

  return (
    <>
      <div className="toolbar">
        <h1 className="toolbar__grow">Audit log</h1>
        <input className="input" style={{ maxWidth: 260 }} placeholder="Action, prison no. or name" value={search}
          onChange={(e) => setSearch(e.target.value)} onKeyDown={(e) => e.key === 'Enter' && load(0, search)} />
        <Button variant="secondary" onClick={() => load(0, search)}>Search</Button>
      </div>
      {rows.length === 0 ? <Empty>No entries.</Empty> : (
        <table className="table">
          <thead><tr><th>When</th><th>Action</th><th>By</th><th>Target</th><th>Details</th></tr></thead>
          <tbody>
            {rows.map((r) => (
              <tr key={r.id}>
                <td>{ukDate(r.created_at)}</td><td>{r.action}</td><td>{r.actor}</td>
                <td className="mono">{r.target}</td>
                <td className="muted" style={{ fontSize: 14, wordBreak: 'break-word' }}>{r.payload}</td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
      <div className="toolbar" style={{ marginTop: 16 }}>
        <Button variant="secondary" small disabled={page === 0} onClick={() => load(page - 1, search)}>Newer</Button>
        <span className="muted">Page {page + 1}</span>
        <Button variant="secondary" small disabled={rows.length < 25} onClick={() => load(page + 1, search)}>Older</Button>
      </div>
    </>
  );
}
