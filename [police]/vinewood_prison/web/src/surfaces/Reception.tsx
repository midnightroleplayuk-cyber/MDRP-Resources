import { useMemo, useState } from 'react';
import { call } from '../lib/nui';
import { duration, originLabel } from '../lib/format';
import { Button, Empty, ErrorBanner, Field, Frame, Tag } from '../components/ui';
import type { UiConfig } from '../types';

type Pending = {
  id: number; name: string; prisonNo: string; category: string; online: boolean; atDesk: boolean;
  term: number; remand: boolean; origin?: string; ref?: string; offences: { title?: string; code?: string }[];
};
type Nearby = { serverId: number; name: string };
type Wing = { id: number; code: string; name: string; type: string; security: string; cells: { id: number; label: string; capacity: number; occupancy: number }[] };
type Desk = {
  prison: { id: number; name: string }; pending: Pending[]; nearby: Nearby[]; wings: Wing[];
  categories: string[]; defaultCategory: string; allowManual: boolean; minTermMinutes: number;
};

type Selection = { kind: 'pending'; item: Pending } | { kind: 'manual'; item: Nearby } | null;

export default function Reception({ initial, ui, onClose }: { initial: Desk; ui: UiConfig; onClose: () => void }) {
  const [desk, setDesk] = useState<Desk>(initial);
  const [sel, setSel] = useState<Selection>(null);
  const [category, setCategory] = useState(initial.defaultCategory);
  const [cellId, setCellId] = useState('');
  const [minutes, setMinutes] = useState('');
  const [remand, setRemand] = useState(false);
  const [offences, setOffences] = useState('');
  const [error, setError] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);
  const [received, setReceived] = useState<{ name: string; prisonNo?: string } | null>(null);

  const cells = useMemo(() => desk.wings
    .filter((w) => w.security <= category)
    .flatMap((w) => w.cells.filter((c) => c.occupancy < c.capacity).map((c) => ({ ...c, wing: w.name }))), [desk.wings, category]);

  const choose = (s: Selection) => {
    setSel(s); setReceived(null); setError(null); setCellId('');
    setCategory(s?.kind === 'pending' ? s.item.category : desk.defaultCategory);
    setMinutes(''); setRemand(false); setOffences('');
  };

  const refresh = async () => {
    const res = await call<Desk>('reception:open');
    if (res.ok) setDesk(res); else setError(res.error);
  };

  const complete = async () => {
    if (!sel) return;
    setBusy(true);
    const cell = cellId ? Number(cellId) : null;
    const res = sel.kind === 'pending'
      ? await call<Desk>('reception:process', sel.item.id, category, cell)
      : await call<Desk>('reception:manual', sel.item.serverId, { termMinutes: Number(minutes), remand, offences, category, cellId: cell });
    setBusy(false);
    if (!res.ok) return setError(res.error);
    setDesk(res);
    setReceived({ name: sel.item.name, prisonNo: sel.kind === 'pending' ? sel.item.prisonNo : undefined });
    setSel(null);
  };

  const manualValid = remand || Number(minutes) >= desk.minTermMinutes;

  return (
    <Frame flush title={desk.prison.name ?? ui.prisonDisplayName} service={`${ui.serviceName}: reception`} onClose={onClose}>
      <div className="desk">
        <div className="desk__queue">
          <h2>Awaiting reception</h2>
          {desk.pending.length === 0 && <Empty><span style={{ padding: '0 20px', display: 'block' }}>Nobody is waiting.</span></Empty>}
          {desk.pending.map((p) => (
            <button key={p.id} className={`queue-item${sel?.kind === 'pending' && sel.item.id === p.id ? ' is-active' : ''}`} onClick={() => choose({ kind: 'pending', item: p })}>
              <span className="queue-item__name">{p.name}</span>
              <span className="queue-item__meta">{p.prisonNo}, {p.remand ? 'remand' : duration(p.term)}</span>
              <span className="queue-item__meta">{p.atDesk ? <Tag tone="green">At the desk</Tag> : p.online ? <Tag tone="yellow">Not at the desk</Tag> : <Tag>Offline</Tag>}</span>
            </button>
          ))}

          {desk.allowManual && (
            <>
              <div className="queue-gap" />
              <h2>People at the desk</h2>
              {desk.nearby.length === 0 && <Empty><span style={{ padding: '0 20px', display: 'block' }}>No one else is near the desk.</span></Empty>}
              {desk.nearby.map((n) => (
                <button key={n.serverId} className={`queue-item${sel?.kind === 'manual' && sel.item.serverId === n.serverId ? ' is-active' : ''}`} onClick={() => choose({ kind: 'manual', item: n })}>
                  <span className="queue-item__name">{n.name}</span>
                  <span className="queue-item__meta">Enter a sentence at the desk</span>
                </button>
              ))}
            </>
          )}
          <div style={{ padding: '16px 20px' }}><Button variant="secondary" small onClick={refresh}>Refresh</Button></div>
        </div>

        <div className="desk__form">
          <ErrorBanner code={error} onDismiss={() => setError(null)} />
          {received && (
            <div className="received" role="status">
              <h1>{received.name} has been received into custody</h1>
              {received.prisonNo && <div className="received__no">{received.prisonNo}</div>}
            </div>
          )}

          {!sel && !received && (
            <>
              <h1>Reception</h1>
              <p className="lede">Choose someone from the list. Property is bagged and stored, clothing is swapped for prison issue, and a cell is allocated.</p>
            </>
          )}

          {sel && (
            <>
              <h1>{sel.item.name}</h1>
              {sel.kind === 'pending' && (
                <p className="lede">
                  {sel.item.remand ? 'Remanded in custody' : `Sentenced to ${duration(sel.item.term)}`}
                  {sel.item.origin ? ` by ${originLabel(sel.item.origin)}` : ''}{sel.item.ref ? `, case ${sel.item.ref}` : ''}.
                  {sel.item.offences.length > 0 && ` Offences: ${sel.item.offences.map((o) => o.title ?? o.code).join(', ')}.`}
                </p>
              )}
              {sel.kind === 'pending' && !sel.item.atDesk && (
                <p><Tag tone="yellow">Bring them to the desk to complete reception</Tag></p>
              )}

              {sel.kind === 'manual' && (
                <>
                  <Field label="Sentence length in minutes" hint={`At least ${desk.minTermMinutes} minutes`} id="mins">
                    <input id="mins" className="input input--short" inputMode="numeric" disabled={remand} value={minutes} onChange={(e) => setMinutes(e.target.value.replace(/\D/g, ''))} />
                  </Field>
                  <div className="field">
                    <label className="check"><input type="checkbox" checked={remand} onChange={(e) => setRemand(e.target.checked)} /> Remand in custody, no sentence yet</label>
                  </div>
                  <Field label="Offences" hint="As written on the warrant" id="offences">
                    <input id="offences" className="input" value={offences} onChange={(e) => setOffences(e.target.value)} />
                  </Field>
                </>
              )}

              <Field label="Security category" hint="A is the highest security">
                <div className="radios">
                  {desk.categories.map((c) => (
                    <button key={c} type="button" className={`radio${category === c ? ' is-on' : ''}`} onClick={() => { setCategory(c); setCellId(''); }}>{c}</button>
                  ))}
                </div>
              </Field>

              <Field label="Cell" hint="Automatic picks the emptiest cell on a wing that holds this category" id="cell">
                <select id="cell" className="select" value={cellId} onChange={(e) => setCellId(e.target.value)}>
                  <option value="">Automatic</option>
                  {cells.map((c) => <option key={c.id} value={c.id}>{c.label}, {c.wing} ({c.occupancy}/{c.capacity})</option>)}
                </select>
              </Field>

              <Button disabled={busy || (sel.kind === 'pending' && !sel.item.atDesk) || (sel.kind === 'manual' && !manualValid)} onClick={complete}>
                {busy ? 'Receiving…' : 'Complete reception'}
              </Button>
            </>
          )}
        </div>
      </div>
    </Frame>
  );
}
