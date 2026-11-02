import { useEffect, useMemo, useState } from 'react';
import { call, local, on } from '../lib/nui';
import { Button, ConfirmButton, Empty, ErrorBanner, Field, Frame, NavItem, Tag } from '../components/ui';
import type { Coords, Estate, UiConfig } from '../types';
import Setup, { GoTo } from './editor/Setup';

type Tab = 'setup' | 'prison' | 'wings' | 'cells' | 'doors' | 'zones' | 'presets';
const ZONE_HELP: Record<string, string> = {
  reception: 'Reception desk. Staff open the reception screen here.',
  holding: 'Where new arrivals wait for an officer. Falls back to the reception desk.',
  discharge: 'Where released prisoners appear and collect left-behind property.',
  kiosk: 'Prisoner kiosk: sentence, account and canteen orders.',
  finance: 'Finance desk outside the wire. Visitors pay money into a prisoner\'s private cash.',
  workstation: 'Where a job\'s tasks are done. Only prisoners working that job can use it.',
  education: 'Classroom. Prisoners on a course attend lessons here during work phases.',
  gym: 'Gym equipment. Leave the exercise blank to offer all of them.',
  library: 'Library. Prisoners sit and read.',
  shower: 'Shower.',
  hiding_spot: 'A place prisoners can hide things. Staff can search it.',
  market: 'Black market spot. Prisoners trade here with canteen goods.',
  evidence: 'Evidence store. Seized items go here.',
  cctv: 'CCTV camera. Line up the view with your camera, then capture it.',
  visits_booking: 'Visitor centre outside. Visitors book visits here.',
  visits_checkin: 'Visits entrance. Visitors check in here and leave from here.',
  visits_table: "Seats on the real chairs: the prisoner's seat, then one or more visitor seats. Sit in each to check it before saving.",
  phone: 'Prison phone on a landing.',
  meds_hatch: 'Medication hatch for medication rounds.',
  territory: 'An area gangs can take over, such as the yard. Set the radius to cover it.',
  officer_post: 'Where an AI officer stands when the prison runs itself.',
  inmate_spot: 'Where an ambient AI prisoner hangs about when cells are unlocked.',
};

export default function Editor({ initial, ui, onClose }: { initial: { estate: Estate; overlay: boolean }; ui: UiConfig; onClose: () => void }) {
  const [estate, setEstate] = useState<Estate>(initial.estate);
  const [prisonId, setPrisonId] = useState<number | null>(initial.estate.prisons[0]?.id ?? null);
  const [tab, setTab] = useState<Tab>('setup');
  const [zoneType, setZoneType] = useState<string | null>(null);
  const go = (g: GoTo) => { setZoneType(g.zoneType ?? null); setTab(g.tab); };
  const [overlay, setOverlay] = useState(initial.overlay);
  const [error, setError] = useState<string | null>(null);
  const [notice, setNotice] = useState<string | null>(null);

  const prison = estate.prisons.find((p) => p.id === prisonId) ?? null;

  // World tools tell us to reload when they come back
  useEffect(() => on('estateRefresh', async () => {
    const res = await call<{ estate: Estate }>('editor:open');
    if (res.ok) setEstate(res.estate);
  }), []);

  const save = async (name: string, ...args: unknown[]) => {
    const res = await call<{ estate: Estate }>(name, ...args);
    if (!res.ok) { setError(res.error); return false; }
    setEstate(res.estate);
    setError(null);
    return true;
  };

  const toggleOverlay = async () => {
    const res = await local<{ overlay: boolean }>('overlay', !overlay);
    if (res.ok) setOverlay(res.overlay);
  };

  const teleport = (c: Coords) => local('teleport', c);

  const nav = (
    <>
      <NavItem active={tab === 'setup'} onClick={() => setTab('setup')}>Setup checklist</NavItem>
      <NavItem active={tab === 'prison'} onClick={() => setTab('prison')}>Prison and boundary</NavItem>
      {prison && (
        <>
          <NavItem active={tab === 'wings'} onClick={() => setTab('wings')} count={estate.wings.filter((w) => w.prison_id === prisonId).length}>Wings</NavItem>
          <NavItem active={tab === 'cells'} onClick={() => setTab('cells')} count={estate.cells.filter((c) => c.prison_id === prisonId).length}>Cells</NavItem>
          <NavItem active={tab === 'doors'} onClick={() => setTab('doors')} count={estate.doors.filter((d) => d.prison_id === prisonId).length}>Doors</NavItem>
          <NavItem active={tab === 'zones'} onClick={() => setTab('zones')} count={estate.zones.filter((z) => z.prison_id === prisonId).length}>Desks and points</NavItem>
          <NavItem active={tab === 'presets'} onClick={() => setTab('presets')}>Presets</NavItem>
        </>
      )}
      <div className="sidenav__spacer" />
      <div className="sidenav__meta">
        <label className="check"><input type="checkbox" checked={overlay} onChange={toggleOverlay} /> Show markers in the world</label>
      </div>
    </>
  );

  return (
    <Frame wide title="Prison editor" service={ui.serviceName} subtitle={prison ? `${prison.name} (${prison.code})` : 'No prison selected'} nav={nav} onClose={onClose}>
      <ErrorBanner code={error} onDismiss={() => setError(null)} />
      {notice && <p><Tag tone="green">{notice}</Tag></p>}
      {estate.prisons.length > 1 && (
        <div className="toolbar">
          <Field label="Editing" id="ep">
            <select id="ep" className="select" value={prisonId ?? ''} onChange={(e) => setPrisonId(Number(e.target.value))}>
              {estate.prisons.map((p) => <option key={p.id} value={p.id}>{p.name} ({p.code})</option>)}
            </select>
          </Field>
        </div>
      )}
      {tab === 'setup' && <Setup estate={estate} prisonId={prisonId} onGo={go} />}
      {tab === 'prison' && <PrisonTab estate={estate} prison={prison} save={save} onCreated={(id) => setPrisonId(id)} />}
      {tab === 'wings' && prison && <WingsTab estate={estate} prisonId={prison.id} save={save} />}
      {tab === 'cells' && prison && <CellsTab estate={estate} prisonId={prison.id} save={save} teleport={teleport} />}
      {tab === 'doors' && prison && <DoorsTab estate={estate} prisonId={prison.id} save={save} teleport={teleport} />}
      {tab === 'zones' && prison && <ZonesTab estate={estate} prisonId={prison.id} save={save} teleport={teleport} startType={zoneType} />}
      {tab === 'presets' && prison && <PresetsTab prisonId={prison.id} save={save} onError={setError} onNotice={setNotice} />}
    </Frame>
  );
}

type Save = (name: string, ...args: unknown[]) => Promise<boolean>;

function PrisonTab({ estate, prison, save, onCreated }: { estate: Estate; prison: Estate['prisons'][0] | null; save: Save; onCreated: (id: number) => void }) {
  const [code, setCode] = useState(prison?.code ?? '');
  const [name, setName] = useState(prison?.name ?? '');
  const [caller, setCaller] = useState(prison?.callerName ?? '');
  const [creating, setCreating] = useState(!prison);
  useEffect(() => { if (!creating) { setCode(prison?.code ?? ''); setName(prison?.name ?? ''); setCaller(prison?.callerName ?? ''); } }, [prison?.id, creating]);

  const submit = async () => {
    const before = new Set(estate.prisons.map((p) => p.id));
    const ok = await save('editor:prison:save', { id: creating ? undefined : prison?.id, code, name, callerName: caller });
    if (ok && creating) {
      const res = await call<{ estate: Estate }>('editor:open');
      if (res.ok) { const created = res.estate.prisons.find((p) => !before.has(p.id)); if (created) onCreated(created.id); }
      setCreating(false);
    }
  };

  const points = prison?.boundary?.points?.length ?? 0;
  return (
    <div className="split">
      <div>
        <h1>{creating ? 'New prison' : 'Prison and boundary'}</h1>
        {prison && !creating && (
          <>
            <h2>Boundary</h2>
            <p className="lede">The fence line. Leaving it counts as an escape (or a return to the cell, depending on your escape setting). {points < 3 ? 'Until it has 3 corners, a 250 m radius around each cell is used instead.' : ''}</p>
            <p><strong>{points}</strong> {points === 1 ? 'corner' : 'corners'} placed.</p>
            <div className="toolbar">
              <Button onClick={() => local('drawBoundary', prison.id)}>{points ? 'Edit boundary in the world' : 'Draw boundary in the world'}</Button>
              <ConfirmButton disabled={!points} confirmLabel="Clear boundary" onConfirm={() => save('editor:boundary:clear', prison.id)}>Clear</ConfirmButton>
            </div>
            <div className="keys">
              <p><strong>In draw mode</strong></p>
              <dl>
                <dt>E</dt><dd>Add a corner where you're aiming, or pick up and drop the corner you're aiming at. Aim at a blue + on an edge to insert a corner there.</dd>
                <dt>R</dt><dd>Delete the corner you're aiming at</dd>
                <dt>Z</dt><dd>Undo the last corner</dd>
                <dt>G</dt><dd>Fly on or off. WASD, Space up, Ctrl down, Shift faster, Alt slower.</dd>
                <dt>Enter</dt><dd>Save</dd>
                <dt>Backspace</dt><dd>Cancel without saving</dd>
              </dl>
            </div>
          </>
        )}
      </div>
      <div className="panel">
        <h3>{creating ? 'Create prison' : 'Prison details'}</h3>
        <Field label="Name" id="pn"><input id="pn" className="input" value={name} onChange={(e) => setName(e.target.value)} /></Field>
        <Field label="Code" hint="Short code used by other scripts, e.g. VINEWOOD" id="pc">
          <input id="pc" className="input input--short" value={code} onChange={(e) => setCode(e.target.value.toUpperCase().replace(/[^A-Z0-9_]/g, ''))} />
        </Field>
        {!creating && (
          <Field label="Phone caller name" hint={`Shown on the phone of anyone a prisoner calls. Leave blank to use "${name || 'the prison name'}".`} id="pcn">
            <input id="pcn" className="input" maxLength={32} placeholder={name} value={caller} onChange={(e) => setCaller(e.target.value)} />
          </Field>
        )}
        <div className="toolbar">
          <Button disabled={!name.trim() || !code} onClick={submit}>{creating ? 'Create prison' : 'Save changes'}</Button>
          {prison && !creating && <Button variant="link" onClick={() => { setCreating(true); setCode(''); setName(''); }}>New prison</Button>}
          {creating && prison && <Button variant="link" onClick={() => setCreating(false)}>Cancel</Button>}
        </div>
        {prison && !creating && (
          <ConfirmButton small confirmLabel="Delete prison and everything in it" onConfirm={() => save('editor:delete', 'prison', prison.id)}>Delete prison</ConfirmButton>
        )}
      </div>
    </div>
  );
}

function WingsTab({ estate, prisonId, save }: { estate: Estate; prisonId: number; save: Save }) {
  const blank = { id: undefined as number | undefined, code: '', name: '', type: 'standard', security: 'C' };
  const [form, setForm] = useState(blank);
  const wings = estate.wings.filter((w) => w.prison_id === prisonId);
  return (
    <div className="split">
      <div>
        <h1>Wings</h1>
        <p className="lede">A wing rated B holds categories B, C and D. Only standard wings take automatic allocations.</p>
        {wings.length === 0 ? <Empty>No wings yet. Add the first one.</Empty> : (
          <table className="table">
            <thead><tr><th>Code</th><th>Name</th><th>Type</th><th>Holds</th><th /></tr></thead>
            <tbody>
              {wings.map((w) => (
                <tr key={w.id} className={form.id === w.id ? 'is-selected' : ''}>
                  <td className="mono">{w.code}</td><td>{w.name}</td><td>{w.type}</td><td>{w.security} and below</td>
                  <td><div className="row-actions">
                    <Button variant="secondary" small onClick={() => setForm({ id: w.id, code: w.code, name: w.name, type: w.type, security: w.security })}>Edit</Button>
                    <ConfirmButton small confirmLabel="Delete" onConfirm={() => save('editor:delete', 'wing', w.id)}>Delete</ConfirmButton>
                  </div></td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>
      <div className={`panel${form.id ? ' panel--editing' : ''}`} key={`wing-${form.id ?? 'new'}`}>
        <h3>{form.id ? 'Edit wing' : 'Add a wing'}</h3>
        <Field label="Code" hint="Used in cell labels, e.g. A gives A-1-01" id="wc">
          <input id="wc" className="input input--short" value={form.code} onChange={(e) => setForm({ ...form, code: e.target.value.toUpperCase() })} />
        </Field>
        <Field label="Name" id="wn"><input id="wn" className="input" value={form.name} onChange={(e) => setForm({ ...form, name: e.target.value })} /></Field>
        <Field label="Type" id="wt">
          <select id="wt" className="select" value={form.type} onChange={(e) => setForm({ ...form, type: e.target.value })}>
            {estate.wingTypes.map((t) => <option key={t} value={t}>{t}</option>)}
          </select>
        </Field>
        <Field label="Highest category held">
          <div className="radios">
            {estate.categories.map((c) => <button key={c} type="button" className={`radio${form.security === c ? ' is-on' : ''}`} onClick={() => setForm({ ...form, security: c })}>{c}</button>)}
          </div>
        </Field>
        <div className="toolbar">
          <Button disabled={!form.code || !form.name.trim()} onClick={async () => { if (await save('editor:wing:save', { ...form, prison_id: prisonId })) setForm(blank); }}>{form.id ? 'Save wing' : 'Add wing'}</Button>
          {form.id && <Button variant="link" onClick={() => setForm(blank)}>Cancel</Button>}
        </div>
      </div>
    </div>
  );
}

function nextCellNo(estate: Estate, wingId: number) {
  const nums = estate.cells.filter((c) => c.wing_id === wingId).map((c) => c.cell_no).sort();
  const last = nums.pop();
  const m = last?.match(/^(.*?)(\d+)$/);
  return m ? `${m[1]}${String(Number(m[2]) + 1).padStart(m[2].length, '0')}` : '1-01';
}

function WorldTip({ children }: { children: React.ReactNode }) {
  return <p className="muted" style={{ marginTop: 10 }}>{children}</p>;
}

function CellsTab({ estate, prisonId, save, teleport }: { estate: Estate; prisonId: number; save: Save; teleport: (c: Coords) => void }) {
  const wings = estate.wings.filter((w) => w.prison_id === prisonId);
  const [place, setPlace] = useState({ wing_id: wings[0]?.id ?? 0, start: '', capacity: 1 });
  const [edit, setEdit] = useState<{ id: number; wing_id: number; cell_no: string; capacity: number; door_id: number | ''; useMyPosition: boolean } | null>(null);
  const [wingFilter, setWingFilter] = useState<number | 0>(0);
  const cells = estate.cells.filter((c) => c.prison_id === prisonId && (!wingFilter || c.wing_id === wingFilter));
  const doors = estate.doors.filter((d) => d.prison_id === prisonId);
  const usedDoors = useMemo(() => new Set(estate.cells.map((c) => c.door_id).filter(Boolean)), [estate.cells]);
  const placeWing = wings.find((w) => w.id === place.wing_id);
  const startNo = place.start || nextCellNo(estate, place.wing_id);

  if (wings.length === 0) return <Empty>Add a wing before placing cells.</Empty>;

  return (
    <div className="split">
      <div>
        <div className="toolbar">
          <h1 className="toolbar__grow">Cells</h1>
          <select className="select" style={{ maxWidth: 220 }} value={wingFilter} onChange={(e) => setWingFilter(Number(e.target.value))}>
            <option value={0}>All wings</option>
            {wings.map((w) => <option key={w.id} value={w.id}>{w.name}</option>)}
          </select>
        </div>
        {cells.length === 0 ? <Empty>No cells yet. Use Place cells in the world.</Empty> : (
          <table className="table">
            <thead><tr><th>Cell</th><th className="num">Beds</th><th>Door</th><th /></tr></thead>
            <tbody>
              {cells.map((c) => (
                <tr key={c.id} className={edit?.id === c.id ? 'is-selected' : ''}>
                  <td className="mono">{c.label}</td>
                  <td className="num">{c.capacity}</td>
                  <td>{c.door_id ? doors.find((d) => d.id === c.door_id)?.label ?? '?' : <span className="muted">None</span>}</td>
                  <td><div className="row-actions">
                    <Button variant="link" small onClick={() => teleport(c.coords)}>Go to</Button>
                    <Button variant="secondary" small onClick={() => setEdit({ id: c.id, wing_id: c.wing_id, cell_no: c.cell_no, capacity: c.capacity, door_id: c.door_id ?? '', useMyPosition: false })}>Edit</Button>
                    <ConfirmButton small confirmLabel="Delete" onConfirm={() => save('editor:delete', 'cell', c.id)}>Delete</ConfirmButton>
                  </div></td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>

      {edit ? (
        <div className="panel panel--editing" key={`cell-${edit.id}`}>
          <h3>Edit cell {estate.cells.find((c) => c.id === edit.id)?.label}</h3>
          <Field label="Wing" id="cw">
            <select id="cw" className="select" value={edit.wing_id} onChange={(e) => setEdit({ ...edit, wing_id: Number(e.target.value) })}>
              {wings.map((w) => <option key={w.id} value={w.id}>{w.name}</option>)}
            </select>
          </Field>
          <Field label="Cell number" id="cn"><input id="cn" className="input input--short" value={edit.cell_no} onChange={(e) => setEdit({ ...edit, cell_no: e.target.value })} /></Field>
          <Field label="Beds" id="cc"><input id="cc" className="input input--short" inputMode="numeric" value={edit.capacity} onChange={(e) => setEdit({ ...edit, capacity: Number(e.target.value.replace(/\D/g, '')) || 1 })} /></Field>
          <Field label="Cell door" hint="Doors added next to a cell are linked automatically" id="cd">
            <select id="cd" className="select" value={edit.door_id} onChange={(e) => setEdit({ ...edit, door_id: e.target.value ? Number(e.target.value) : '' })}>
              <option value="">No door</option>
              {doors.filter((d) => !usedDoors.has(d.id) || d.id === edit.door_id).map((d) => <option key={d.id} value={d.id}>{d.label}</option>)}
            </select>
          </Field>
          <div className="field"><label className="check"><input type="checkbox" checked={edit.useMyPosition} onChange={(e) => setEdit({ ...edit, useMyPosition: e.target.checked })} /> Move the cell to where I'm standing</label></div>
          <div className="toolbar">
            <Button disabled={!edit.cell_no.trim()} onClick={async () => { if (await save('editor:cell:save', { ...edit, door_id: edit.door_id || null })) setEdit(null); }}>Save cell</Button>
            <Button variant="link" onClick={() => setEdit(null)}>Cancel</Button>
          </div>
        </div>
      ) : (
        <div className="panel">
          <h3>Place cells in the world</h3>
          <Field label="Wing" id="pw">
            <select id="pw" className="select" value={place.wing_id} onChange={(e) => setPlace({ ...place, wing_id: Number(e.target.value), start: '' })}>
              {wings.map((w) => <option key={w.id} value={w.id}>{w.name}</option>)}
            </select>
          </Field>
          <Field label="First cell number" hint="Numbers count up as you place, e.g. 1-01, 1-02" id="ps">
            <input id="ps" className="input input--short" value={startNo} onChange={(e) => setPlace({ ...place, start: e.target.value })} />
          </Field>
          <Field label="Beds per cell" id="pc">
            <input id="pc" className="input input--short" inputMode="numeric" value={place.capacity} onChange={(e) => setPlace({ ...place, capacity: Number(e.target.value.replace(/\D/g, '')) || 1 })} />
          </Field>
          <Button disabled={!startNo.trim() || !placeWing} onClick={() => local('placeCells', { wingId: place.wing_id, wingCode: placeWing?.code, wingName: placeWing?.name, startNo: startNo.trim(), capacity: place.capacity })}>Place cells in the world</Button>
          <WorldTip>Walk or fly (G) from cell to cell. Stand where the prisoner should appear, face the way they should face and press E. Z undoes, Backspace comes back here.</WorldTip>
        </div>
      )}
    </div>
  );
}

type Picked = { model: number; coords: Coords; pair?: { model: number; coords: Coords } } | null;

const KIND_LABELS: Record<string, string> = { cell: 'Cell door', gate: 'Wing gate', door: 'Normal door', perimeter: 'Perimeter' };

function DoorsTab({ estate, prisonId, save, teleport }: { estate: Estate; prisonId: number; save: Save; teleport: (c: Coords) => void }) {
  const wings = estate.wings.filter((w) => w.prison_id === prisonId);
  const [form, setForm] = useState<{ id: number; label: string; kind: string; wing_id: number | ''; access_level: number; default_locked: boolean } | null>(null);
  const [picked, setPicked] = useState<Picked>(null);
  const [add, setAdd] = useState({ leaves: 1, kind: 'auto', wingId: '' as number | '' | 'none', level: 0, locked: true, label: '' });
  const doors = estate.doors.filter((d) => d.prison_id === prisonId);
  const startAdding = () => local('addDoors', prisonId, {
    leaves: add.leaves, kind: add.kind, wingId: add.wingId || null, level: add.level || null, locked: add.locked, label: add.label.trim() || null,
  });

  useEffect(() => on('doorPicked', (data: Picked) => { if (data) setPicked(data); }), []);

  return (
    <div className="split">
      <div>
        <h1>Doors</h1>
        {doors.length === 0 ? <Empty>No doors yet.</Empty> : (
          <table className="table">
            <thead><tr><th>Door</th><th>Kind</th><th>Wing</th><th className="num">Level</th><th>Starts</th><th /></tr></thead>
            <tbody>
              {doors.map((d) => (
                <tr key={d.id} className={form?.id === d.id ? 'is-selected' : ''}>
                  <td>{d.label}{d.pair && <span className="muted"> (double)</span>}</td><td>{KIND_LABELS[d.kind] ?? d.kind}</td>
                  <td>{wings.find((w) => w.id === d.wing_id)?.name ?? <span className="muted">None</span>}</td>
                  <td className="num">{d.access_level}</td>
                  <td>{d.default_locked ? 'Locked' : <span className="muted">Unlocked</span>}</td>
                  <td><div className="row-actions">
                    <Button variant="link" small onClick={() => teleport(d.coords)}>Go to</Button>
                    {d.pair && <Button variant="link" small onClick={() => save('editor:door:save', { id: d.id, prison_id: prisonId, label: d.label, kind: d.kind, wing_id: d.wing_id ?? null, access_level: d.access_level, default_locked: d.default_locked, single: true })}>Make single</Button>}
                    <Button variant="secondary" small onClick={() => { setPicked(null); setForm({ id: d.id, label: d.label, kind: d.kind, wing_id: d.wing_id ?? '', access_level: d.access_level, default_locked: d.default_locked }); }}>Edit</Button>
                    <ConfirmButton small confirmLabel="Delete" onConfirm={() => save('editor:delete', 'door', d.id)}>Delete</ConfirmButton>
                  </div></td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>
      {form ? (
        <div className="panel panel--editing" key={`door-${form.id}`}>
          <h3>Edit door</h3>
          {(() => {
            const current = doors.find((d) => d.id === form.id);
            const isDouble = picked ? !!picked.pair : !!current?.pair;
            return (
              <>
                <p><Tag tone={isDouble ? 'yellow' : 'grey'}>{isDouble ? 'Double door' : 'Single door'}</Tag></p>
                {picked && <div className="picked">{picked.pair ? 'Double door' : 'Door'} re-picked. It replaces the current one when you save.</div>}
                {current?.pair && !picked && (
                  <div className="field">
                    <p className="muted">Saved as two halves by mistake? Make it single. The other half becomes free to add as its own door.</p>
                    <Button variant="secondary" onClick={async () => {
                      const ok = await save('editor:door:save', { ...form, wing_id: form.wing_id || null, prison_id: prisonId, single: true });
                      if (ok) { setForm(null); setPicked(null); }
                    }}>Make single door</Button>
                  </div>
                )}
                <div className="field toolbar">
                  <Button variant="secondary" onClick={() => local('pickDoor', 1)}>Re-pick as single</Button>
                  <Button variant="secondary" onClick={() => local('pickDoor', 2)}>Re-pick as double</Button>
                </div>
              </>
            );
          })()}
          <Field label="Label" id="dl"><input id="dl" className="input" value={form.label} onChange={(e) => setForm({ ...form, label: e.target.value })} /></Field>
          <Field label="Kind" hint="Perimeter doors need remote door permission to open" id="dk">
            <select id="dk" className="select" value={form.kind} onChange={(e) => setForm({ ...form, kind: e.target.value })}>
              {estate.doorKinds.map((k) => <option key={k} value={k}>{KIND_LABELS[k] ?? k}</option>)}
            </select>
          </Field>
          <Field label="Wing" id="dw">
            <select id="dw" className="select" value={form.wing_id} onChange={(e) => setForm({ ...form, wing_id: e.target.value ? Number(e.target.value) : '' })}>
              <option value="">None</option>
              {wings.map((w) => <option key={w.id} value={w.id}>{w.name}</option>)}
            </select>
          </Field>
          <Field label="Keycard level">
            <div className="radios">{[1, 2, 3, 4, 5].map((n) => <button key={n} type="button" className={`radio${form.access_level === n ? ' is-on' : ''}`} onClick={() => setForm({ ...form, access_level: n })}>{n}</button>)}</div>
          </Field>
          <Field label="When the server starts">
            <div className="radios">
              <button type="button" className={`radio${form.default_locked ? ' is-on' : ''}`} onClick={() => setForm({ ...form, default_locked: true })}>Locked</button>
              <button type="button" className={`radio${!form.default_locked ? ' is-on' : ''}`} onClick={() => setForm({ ...form, default_locked: false })}>Unlocked</button>
            </div>
          </Field>
          <div className="toolbar">
            <Button disabled={!form.label.trim()} onClick={async () => {
              const ok = await save('editor:door:save', { ...form, wing_id: form.wing_id || null, prison_id: prisonId, model: picked?.model, coords: picked?.coords, pair: picked?.pair });
              if (ok) { setForm(null); setPicked(null); }
            }}>Save door</Button>
            <Button variant="link" onClick={() => { setForm(null); setPicked(null); }}>Cancel</Button>
          </div>
        </div>
      ) : (
        <div className="panel">
          <h3>Add doors in the world</h3>
          <Field label="Doors" hint="Single: each door you save is its own door. Double: pick both halves of one doorway. Q switches while placing.">
            <div className="radios">
              {[[1, 'Single'], [2, 'Double']].map(([n, l]) => (
                <button key={n} type="button" className={`radio${add.leaves === n ? ' is-on' : ''}`} onClick={() => setAdd({ ...add, leaves: n as number })}>{l}</button>
              ))}
            </div>
          </Field>
          <Field label="Type" hint="Auto works it out from where each door is. Normal doors are offices, stores and staff rooms: not part of a wing, so wing lock-all and the regime leave them alone. Switch with 1 to 5 while placing.">
            <div className="radios">
              {[['auto', 'Auto'], ['cell', 'Cell door'], ['gate', 'Wing gate'], ['door', 'Normal door'], ['perimeter', 'Perimeter']].map(([k, l]) => (
                <button key={k} type="button" className={`radio${add.kind === k ? ' is-on' : ''}`} onClick={() => setAdd({ ...add, kind: k })}>{l}</button>
              ))}
            </div>
          </Field>
          <Field label="Wing" id="aw">
            <select id="aw" className="select" value={add.wingId} onChange={(e) => setAdd({ ...add, wingId: e.target.value === 'none' ? 'none' : e.target.value ? Number(e.target.value) : '' })}>
              <option value="">{add.kind === 'door' || add.kind === 'perimeter' ? 'No wing' : 'Auto (nearest wing)'}</option>
              {add.kind !== 'door' && add.kind !== 'perimeter' && <option value="none">No wing</option>}
              {wings.map((w) => <option key={w.id} value={w.id}>{w.name}</option>)}
            </select>
          </Field>
          <Field label="Keycard level" hint="Auto: cell doors 1, gates and normal doors 2, perimeter 3">
            <div className="radios">
              {[0, 1, 2, 3, 4, 5].map((n) => <button key={n} type="button" className={`radio${add.level === n ? ' is-on' : ''}`} onClick={() => setAdd({ ...add, level: n })}>{n === 0 ? 'Auto' : n}</button>)}
            </div>
          </Field>
          <Field label="Name" hint="Optional. Blank names doors for you (A-1-01 door, A wing gate). A name like Kitchen door numbers the rest: Kitchen door 2, 3…" id="an">
            <input id="an" className="input" value={add.label} onChange={(e) => setAdd({ ...add, label: e.target.value })} />
          </Field>
          <Field label="When the server starts" hint="The state the doors are in until someone changes them. Cell doors then follow the regime.">
            <div className="radios">
              <button type="button" className={`radio${add.locked ? ' is-on' : ''}`} onClick={() => setAdd({ ...add, locked: true })}>Locked</button>
              <button type="button" className={`radio${!add.locked ? ' is-on' : ''}`} onClick={() => setAdd({ ...add, locked: false })}>Unlocked</button>
            </div>
          </Field>
          <Button onClick={startAdding}>Add doors in the world</Button>
          <WorldTip>{add.leaves === 1
            ? 'Walk up to a door (or aim at it) and it lights up with the name it will get. E or Enter saves it, then walk to the next. Z undoes, Backspace comes back here.'
            : 'Walk up to a double doorway. E on one half, then E on the other: it saves as soon as both are picked. Z undoes, Backspace comes back here.'} Keys 1 to 5 switch type while placing.</WorldTip>
        </div>
      )}
    </div>
  );
}

const DEFAULT_LABELS: Record<string, string> = {
  reception: 'Reception desk', holding: 'Holding area', discharge: 'Discharge', kiosk: 'Kiosk', finance: 'Finance desk',
  workstation: 'Workstation', education: 'Classroom', gym: 'Gym', library: 'Library', shower: 'Showers',
  hiding_spot: 'Hiding spot', market: 'Market', evidence: 'Evidence store', cctv: 'Camera',
  visits_booking: 'Visitor centre', visits_checkin: 'Visits entrance', visits_table: 'Visits table', phone: 'Phone',
  meds_hatch: 'Medication hatch', territory: 'Yard', officer_post: 'Officer post', inmate_spot: 'Landing',
};

function ZonesTab({ estate, prisonId, save, teleport, startType }: { estate: Estate; prisonId: number; save: Save; teleport: (c: Coords) => void; startType?: string | null }) {
  const blank = { type: startType || 'reception', label: DEFAULT_LABELS[startType || 'reception'] ?? '', radius: 1.5, job: '', exercise: '' };
  const [form, setForm] = useState(blank);
  useEffect(() => { if (startType) setForm({ ...blank, type: startType, label: DEFAULT_LABELS[startType] ?? '' }); }, [startType]);
  const [edit, setEdit] = useState<{ id: number; type: string; label: string; radius: number; useMyPosition: boolean; job: string; exercise: string; cam?: unknown } | null>(null);
  const zones = estate.zones.filter((z) => z.prison_id === prisonId);
  const missing = ['reception', 'discharge', 'kiosk'].filter((t) => !zones.some((z) => z.type === t));
  const ready = form.label.trim() && (form.type !== 'workstation' || form.job);

  const go = () => {
    if (form.type === 'cctv') local('placeCameras', { prisonId, label: form.label.trim() });
    else if (form.type === 'visits_table') local('placeVisitTables', { prisonId, label: form.label.trim() });
    else local('placePoints', { prisonId, type: form.type, label: form.label.trim(), radius: form.radius, job: form.job || null, exercise: form.exercise || null });
  };

  return (
    <div className="split">
      <div>
        <h1>Desks and points</h1>
        {missing.length > 0 && <p><Tag tone="yellow">Still needed: {missing.join(', ')}</Tag></p>}
        {zones.length === 0 ? <Empty>No desks or points yet.</Empty> : (
          <table className="table">
            <thead><tr><th>Label</th><th>Type</th><th className="num">Radius</th><th /></tr></thead>
            <tbody>
              {zones.map((z) => (
                <tr key={z.id} className={edit?.id === z.id ? 'is-selected' : ''}>
                  <td>{z.label}</td><td>{z.type}{z.data?.job ? `: ${estate.jobs?.find((j) => j.key === z.data?.job)?.label ?? z.data.job}` : ''}{z.data?.exercise ? `: ${z.data.exercise}` : ''}</td><td className="num">{z.radius} m</td>
                  <td><div className="row-actions">
                    <Button variant="link" small onClick={() => teleport(z.coords)}>Go to</Button>
                    <Button variant="secondary" small onClick={() => setEdit({ id: z.id, type: z.type, label: z.label, radius: z.radius, useMyPosition: false, job: z.data?.job ?? '', exercise: z.data?.exercise ?? '', cam: z.data?.cam })}>Edit</Button>
                    <ConfirmButton small confirmLabel="Delete" onConfirm={() => save('editor:delete', 'zone', z.id)}>Delete</ConfirmButton>
                  </div></td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>

      {edit ? (
        <div className="panel panel--editing" key={`zone-${edit.id}`}>
          <h3>Edit {edit.type}</h3>
          <Field label="Label" id="ezl"><input id="ezl" className="input" value={edit.label} onChange={(e) => setEdit({ ...edit, label: e.target.value })} /></Field>
          <Field label="Radius in metres" id="ezr"><input id="ezr" className="input input--short" inputMode="decimal" value={edit.radius} onChange={(e) => setEdit({ ...edit, radius: Number(e.target.value.replace(/[^0-9.]/g, '')) || 0 })} /></Field>
          {edit.type !== 'cctv' && <div className="field"><label className="check"><input type="checkbox" checked={edit.useMyPosition} onChange={(e) => setEdit({ ...edit, useMyPosition: e.target.checked })} /> Move it to where I'm standing</label></div>}
          {edit.type === 'cctv' && <p className="muted">To move a camera, delete it and place it again.</p>}
          <div className="toolbar">
            <Button disabled={!edit.label.trim()} onClick={async () => { if (await save('editor:zone:save', { ...edit, prison_id: prisonId })) setEdit(null); }}>Save</Button>
            <Button variant="link" onClick={() => setEdit(null)}>Cancel</Button>
          </div>
        </div>
      ) : (
        <div className="panel">
          <h3>Place in the world</h3>
          <Field label="Type" hint={ZONE_HELP[form.type]} id="zt">
            <select id="zt" className="select" value={form.type} onChange={(e) => {
              const t = e.target.value;
              const isDefault = !form.label || Object.values(DEFAULT_LABELS).includes(form.label);
              setForm({ ...form, type: t, label: isDefault ? (DEFAULT_LABELS[t] ?? '') : form.label });
            }}>
              {estate.zoneTypes.map((t) => <option key={t} value={t}>{t}</option>)}
            </select>
          </Field>
          {form.type === 'workstation' && (
            <Field label="Job" id="zj">
              <select id="zj" className="select" value={form.job} onChange={(e) => setForm({ ...form, job: e.target.value })}>
                <option value="">Choose a job</option>
                {(estate.jobs ?? []).map((j) => <option key={j.key} value={j.key}>{j.label}</option>)}
              </select>
            </Field>
          )}
          {form.type === 'gym' && (
            <Field label="Exercise" id="zx">
              <select id="zx" className="select" value={form.exercise} onChange={(e) => setForm({ ...form, exercise: e.target.value })}>
                <option value="">Any exercise</option>
                {(estate.exercises ?? []).map((x) => <option key={x.key} value={x.key}>{x.label}</option>)}
              </select>
            </Field>
          )}
          <Field label="Label" hint="Shown to players. Placing more than one numbers them: Phone, Phone 2…" id="zl"><input id="zl" className="input" value={form.label} onChange={(e) => setForm({ ...form, label: e.target.value })} /></Field>
          {form.type !== 'cctv' && (
            <Field label="Radius in metres" hint="Scroll to change it while placing" id="zr">
              <input id="zr" className="input input--short" inputMode="decimal" value={form.radius} onChange={(e) => setForm({ ...form, radius: Number(e.target.value.replace(/[^0-9.]/g, '')) || 0 })} />
            </Field>
          )}
          <Button disabled={!ready} onClick={go}>{form.type === 'cctv' ? 'Place cameras' : form.type === 'visits_table' ? 'Place visits tables' : 'Place in the world'}</Button>
          <WorldTip>{form.type === 'visits_table'
            ? 'At each table: stand at the prisoner\'s chair facing the table, press F to sit and check it (WASD moves the seat, arrows adjust height and turn), E to save. Then the same at each visitor chair. Enter saves the table and starts the next. Z undoes, Backspace comes back here.'
            : form.type === 'cctv'
            ? 'A free camera: fly to the ceiling with WASD, Space and Ctrl, aim with the mouse, scroll to zoom, F previews the CCTV look, E saves the view. Place as many as you like; Backspace comes back here.'
            : 'Walk or fly (G) to each spot and press E. Seats, posts, holding and discharge use where you stand and the way you face; everything else goes where you aim. Z undoes, Backspace comes back here.'}</WorldTip>
        </div>
      )}
    </div>
  );
}

function PresetsTab({ prisonId, save, onError, onNotice }: { prisonId: number; save: Save; onError: (e: string) => void; onNotice: (n: string) => void }) {
  const [name, setName] = useState('');
  const [code, setCode] = useState('');
  const [list, setList] = useState<string[]>([]);
  useEffect(() => { call<{ presets: string[] }>('editor:preset:list').then((r) => { if (r.ok) setList(r.presets); }); }, []);
  return (
    <div className="split">
      <div>
        <h1>Presets</h1>
        <p className="lede">A preset is the whole layout of a prison: wings, cells, doors, desks and boundary. Export one to ship it with an MLO, then import it on another server.</p>
        <h2>Export this prison</h2>
        <p>Saves to <span className="mono">data/presets/&lt;code&gt;.json</span> inside the resource.</p>
        <Button onClick={async () => {
          const res = await call<{ path: string }>('editor:preset:export', prisonId);
          if (res.ok) onNotice(`Saved ${res.path}`); else onError(res.error);
        }}>Export preset</Button>
      </div>
      <div className="panel">
        <h3>Import a preset</h3>
        <Field label="Preset" hint="Exported presets are listed. Others: type the file name without .json" id="pf">
          {list.length > 0 && (
            <div className="radios" style={{ marginBottom: 8 }}>{list.map((n) => <button key={n} className={`radio${name === n ? ' is-on' : ''}`} onClick={() => setName(n)}>{n}</button>)}</div>
          )}
          <input id="pf" className="input" value={name} onChange={(e) => setName(e.target.value)} />
        </Field>
        <Field label="New prison code" hint="Leave blank to use the code in the file" id="pcode">
          <input id="pcode" className="input input--short" value={code} onChange={(e) => setCode(e.target.value.toUpperCase().replace(/[^A-Z0-9_]/g, ''))} />
        </Field>
        <Button disabled={!name.trim()} onClick={async () => { if (await save('editor:preset:import', name.trim(), code)) onNotice('Preset imported'); }}>Import preset</Button>
      </div>
    </div>
  );
}
