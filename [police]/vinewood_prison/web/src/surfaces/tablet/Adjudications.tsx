import { useCallback, useEffect, useState } from 'react';
import { call } from '../../lib/nui';
import { ukDate } from '../../lib/format';
import { Button, Empty, Field, Tag } from '../../components/ui';
import type { TabletConfig } from '../../types';

type Row = {
  id: number; prisoner_id: number; name: string; prison_no: string; charge_code: string; charge_text: string;
  details: string; raised_by: string; raised_at: number; status: string; plea?: string; heard_by?: string; heard_at?: number;
  punishments?: { type: string; hours?: number; minutes?: number; percent?: number }[] | null;
};

const NAMES: Record<string, string> = {
  caution: 'Caution',
  loss_of_privileges: 'Loss of privileges',
  stoppage_of_earnings: 'Stoppage of earnings',
  canteen_ban: 'Canteen stopped',
  cellular_confinement: 'Cellular confinement',
  additional_days: 'Additional days',
};

function describe(p: NonNullable<Row['punishments']>[number]) {
  const name = NAMES[p.type] ?? p.type;
  if (p.type === 'stoppage_of_earnings') return `${name}, ${p.percent}% for ${p.hours}h`;
  if (p.hours) return `${name}, ${p.hours}h`;
  if (p.minutes) return `${name}, ${p.minutes} min`;
  return name;
}

export default function Adjudications({ prisonId, can, config, onError, onOpen }: {
  prisonId: number; can: (n: string) => boolean; config: TabletConfig; onError: (e: string) => void; onOpen: (id: number) => void;
}) {
  const [tab, setTab] = useState<'open' | 'closed'>('open');
  const [rows, setRows] = useState<Row[]>([]);
  const [hearing, setHearing] = useState<Row | null>(null);

  const load = useCallback(async () => {
    const res = await call<{ rows: Row[] }>('discipline:list', prisonId, tab);
    if (res.ok) setRows(res.rows); else onError(res.error);
  }, [prisonId, tab]);

  useEffect(() => { load(); }, [load]);

  if (hearing) return <Hearing row={hearing} can={can} config={config} onError={onError} onDone={() => { setHearing(null); load(); }} />;

  return (
    <>
      <div className="toolbar">
        <h1 className="toolbar__grow">Adjudications</h1>
        <div className="radios">
          <button className={`radio${tab === 'open' ? ' is-on' : ''}`} onClick={() => setTab('open')}>Awaiting hearing</button>
          <button className={`radio${tab === 'closed' ? ' is-on' : ''}`} onClick={() => setTab('closed')}>Heard</button>
        </div>
      </div>
      {rows.length === 0 ? <Empty>{tab === 'open' ? 'Nobody is on report.' : 'No hearings yet.'}</Empty> : (
        <table className="table">
          <thead><tr><th>Raised</th><th>Prisoner</th><th>Charge</th>{tab === 'open' ? <th>Raised by</th> : <th>Outcome</th>}<th /></tr></thead>
          <tbody>
            {rows.map((r) => (
              <tr key={r.id}>
                <td>{ukDate(r.raised_at * 1000)}</td>
                <td><button className="btn btn--link btn--small" onClick={() => onOpen(r.prisoner_id)}>{r.name}</button> <span className="muted mono">{r.prison_no}</span></td>
                <td>{r.charge_code} {r.charge_text}</td>
                {tab === 'open' ? <td>{r.raised_by}</td> : (
                  <td>
                    {r.status === 'proven' ? <Tag tone="red">Proven</Tag> : <Tag>{r.status.replace('_', ' ')}</Tag>}
                    {r.punishments && r.punishments.length > 0 && <div className="muted">{r.punishments.map(describe).join('; ')}</div>}
                  </td>
                )}
                <td className="num">{tab === 'open' && can('adjudication.hear') && <Button small onClick={() => setHearing(r)}>Hear</Button>}</td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </>
  );
}

function Hearing({ row, can, config, onError, onDone }: { row: Row; can: (n: string) => boolean; config: TabletConfig; onError: (e: string) => void; onDone: () => void }) {
  const [plea, setPlea] = useState('');
  const [finding, setFinding] = useState('');
  const [notes, setNotes] = useState('');
  const [chosen, setChosen] = useState<Record<string, { hours?: string; minutes?: string; percent?: string }>>({});
  const defs = config.discipline?.punishments ?? {};

  const toggle = (k: string) => setChosen((c) => { const n = { ...c }; if (n[k]) delete n[k]; else n[k] = {}; return n; });
  const val = (k: string, f: 'hours' | 'minutes' | 'percent', v: string) => setChosen((c) => ({ ...c, [k]: { ...c[k], [f]: v.replace(/\D/g, '') } }));

  const submit = async () => {
    const punishments = finding === 'proven' ? Object.entries(chosen).map(([type, v]) => ({
      type, hours: Number(v.hours || 0), minutes: Number(v.minutes || 0), percent: Number(v.percent || 0),
    })) : [];
    const res = await call('discipline:hear', row.id, { plea, finding, notes, punishments });
    if (!res.ok) onError(res.error); else onDone();
  };

  return (
    <>
      <button className="back" onClick={onDone}>Back to adjudications</button>
      <h1>Hearing: {row.name}</h1>
      <p className="lede">{row.charge_code} {row.charge_text}. Raised by {row.raised_by} on {ukDate(row.raised_at * 1000)}.</p>
      <blockquote className="quote">{row.details}</blockquote>

      <Field label="Plea">
        <div className="radios">
          {[['guilty', 'Guilty'], ['not_guilty', 'Not guilty']].map(([k, l]) => <button key={k} className={`radio${plea === k ? ' is-on' : ''}`} onClick={() => setPlea(k)}>{l}</button>)}
        </div>
      </Field>
      <Field label="Finding">
        <div className="radios">
          {[['proven', 'Proven'], ['not_proven', 'Not proven'], ['dismissed', 'Dismissed']].map(([k, l]) => <button key={k} className={`radio${finding === k ? ' is-on' : ''}`} onClick={() => setFinding(k)}>{l}</button>)}
        </div>
      </Field>

      {finding === 'proven' && (
        <Field label="Punishments" hint="Choose any that apply">
          <div className="punishments">
            {Object.entries(defs).filter(([, d]) => d.enabled && (!d.node || can(d.node))).map(([k, d]) => (
              <div key={k} className="punishment">
                <label className="check"><input type="checkbox" checked={!!chosen[k]} onChange={() => toggle(k)} /> {NAMES[k] ?? k}</label>
                {chosen[k] && (
                  <div className="punishment__fields">
                    {d.maxHours && <label>Hours (max {d.maxHours}) <input className="input input--short" value={chosen[k].hours ?? ''} onChange={(e) => val(k, 'hours', e.target.value)} /></label>}
                    {d.maxMinutes && <label>Minutes (max {d.maxMinutes}) <input className="input input--short" value={chosen[k].minutes ?? ''} onChange={(e) => val(k, 'minutes', e.target.value)} /></label>}
                    {d.maxPercent && <label>Percent (max {d.maxPercent}) <input className="input input--short" value={chosen[k].percent ?? ''} onChange={(e) => val(k, 'percent', e.target.value)} /></label>}
                  </div>
                )}
              </div>
            ))}
          </div>
        </Field>
      )}

      <Field label="Notes" id="h-notes"><textarea id="h-notes" className="textarea" value={notes} onChange={(e) => setNotes(e.target.value)} /></Field>
      <Button disabled={!plea || !finding} onClick={submit}>Record outcome</Button>
    </>
  );
}
