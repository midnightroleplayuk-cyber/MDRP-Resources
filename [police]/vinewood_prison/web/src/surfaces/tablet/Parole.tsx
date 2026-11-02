import { useCallback, useEffect, useState } from 'react';
import { call } from '../../lib/nui';
import { ukDate } from '../../lib/format';
import { Button, Empty, Field, Tag } from '../../components/ui';
import type { TabletConfig } from '../../types';

type Row = { id: number; name: string; prison_no: string; status: string; score: number; recommend: boolean; factors: { label: string; points: number }[]; conditions: string[]; reason?: string; decided_by?: string; applied_at: number };

export default function Parole({ prisonId, config, onError }: { prisonId: number; config: TabletConfig; onError: (e: string) => void }) {
  const [rows, setRows] = useState<Row[]>([]);
  const [open, setOpen] = useState<Row | null>(null);
  const [reason, setReason] = useState('');
  const [conds, setConds] = useState<string[]>([]);

  const load = useCallback(async () => {
    const res = await call<{ rows: Row[] }>('parole:list', prisonId);
    if (res.ok) setRows(res.rows); else onError(res.error);
  }, [prisonId]);
  useEffect(() => { load(); }, [load]);

  const decide = async (grant: boolean) => {
    if (!open) return;
    const res = await call('parole:decide', open.id, grant, reason.trim(), grant ? conds : []);
    if (!res.ok) return onError(res.error);
    setOpen(null); setReason(''); setConds([]); load();
  };

  if (open) {
    return (
      <>
        <button className="back" onClick={() => setOpen(null)}>Back to applications</button>
        <h1>Parole review: {open.name}</h1>
        <p className="lede">Score {open.score} against a pass mark of {config.parole?.passScore}. {open.recommend ? 'The scoring recommends release.' : 'The scoring does not recommend release.'}</p>
        <table className="table">
          <tbody>{open.factors.map((f, i) => <tr key={i}><td>{f.label}</td><td className="num">{f.points > 0 ? `+${f.points}` : f.points}</td></tr>)}</tbody>
        </table>
        <Field label="Licence conditions if released">
          <div className="punishments">
            {(config.parole?.conditions ?? []).map((c) => (
              <label key={c} className="check"><input type="checkbox" checked={conds.includes(c)} onChange={() => setConds((x) => x.includes(c) ? x.filter((y) => y !== c) : [...x, c])} /> {c}</label>
            ))}
          </div>
        </Field>
        <Field label="Reasons" id="pr-r"><textarea id="pr-r" className="textarea" value={reason} onChange={(e) => setReason(e.target.value)} /></Field>
        <div className="toolbar">
          <Button disabled={!reason.trim()} onClick={() => decide(true)}>Release on licence</Button>
          <Button variant="warning" disabled={!reason.trim()} onClick={() => decide(false)}>Refuse</Button>
        </div>
      </>
    );
  }

  return (
    <>
      <h1>Parole</h1>
      {rows.length === 0 ? <Empty>No applications.</Empty> : (
        <table className="table">
          <thead><tr><th>Applied</th><th>Prisoner</th><th className="num">Score</th><th>Status</th><th /></tr></thead>
          <tbody>
            {rows.map((r) => (
              <tr key={r.id}>
                <td>{ukDate(r.applied_at * 1000)}</td>
                <td>{r.name} <span className="muted mono">{r.prison_no}</span></td>
                <td className="num">{r.score} {r.status === 'pending' && (r.recommend ? <Tag tone="green">Recommend</Tag> : <Tag tone="yellow">Not yet</Tag>)}</td>
                <td>{r.status === 'pending' ? <Tag tone="blue">Waiting</Tag> : r.status === 'granted' ? <Tag tone="green">Released</Tag> : <Tag tone="red">Refused</Tag>}
                  {r.decided_by && <div className="muted">{r.decided_by}{r.reason ? `: ${r.reason}` : ''}</div>}</td>
                <td className="num">{r.status === 'pending' && <Button small onClick={() => setOpen(r)}>Review</Button>}</td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </>
  );
}
