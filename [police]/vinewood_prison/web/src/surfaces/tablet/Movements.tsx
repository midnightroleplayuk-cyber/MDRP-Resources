import { useCallback, useEffect, useState } from 'react';
import { call } from '../../lib/nui';
import { ukDate } from '../../lib/format';
import { Button, Empty, Field, Tag } from '../../components/ui';
import type { Prisoner } from '../../types';

type Row = { id: number; name: string; prison_no: string; kind: string; destination_label: string; status: string; planned_by: string; escort?: string; created_at: number; out_at?: number; note?: string };

export default function Movements({ prisonId, can, roster, onError }: { prisonId: number; can: (n: string) => boolean; roster: Prisoner[]; onError: (e: string) => void }) {
  const [data, setData] = useState<{ rows: Row[]; prisons: { id: number; name: string }[]; automated: boolean } | null>(null);
  const [form, setForm] = useState({ prisoner: '', prison: '' });

  const load = useCallback(async () => {
    const res = await call<{ rows: Row[]; prisons: { id: number; name: string }[]; automated: boolean }>('transport:list', prisonId);
    if (res.ok) setData(res); else onError(res.error);
  }, [prisonId]);
  useEffect(() => { load(); const t = setInterval(load, 10000); return () => clearInterval(t); }, [load]);
  const act = async (name: string, ...args: unknown[]) => { const r = await call(name, ...args); if (!r.ok) onError(r.error); load(); };
  if (!data) return <p className="muted">Loading…</p>;

  return (
    <>
      <h1>Movements</h1>
      <p className="lede">Start an escort standing with the prisoner, and complete it at reception (for transfers, at the receiving prison). <span className="mono">/prisoncuff</span>, <span className="mono">/prisonescort</span> and <span className="mono">/prisonvan</span> help with the physical escort.</p>
      {data.rows.length === 0 ? <Empty>No movements today.</Empty> : (
        <table className="table">
          <thead><tr><th>Prisoner</th><th>Movement</th><th>Status</th><th /></tr></thead>
          <tbody>
            {data.rows.map((m) => (
              <tr key={m.id}>
                <td>{m.name} <span className="muted mono">{m.prison_no}</span></td>
                <td>{m.kind} to {m.destination_label}{m.note && <div className="muted">{m.note}</div>}</td>
                <td>{m.status === 'out' ? <Tag tone="yellow">Out since {ukDate((m.out_at ?? 0) * 1000)}</Tag> : m.status === 'planned' ? <Tag tone="blue">Planned</Tag> : m.status === 'escaped' ? <Tag tone="red">Escaped</Tag> : <Tag>{m.status}</Tag>}
                  {m.escort && <div className="muted">Escort: {m.escort}</div>}</td>
                <td><div className="row-actions">
                  {m.status === 'planned' && can('transport.escort') && <Button small onClick={() => act('transport:start', m.id)}>Start escort</Button>}
                  {m.status === 'planned' && m.kind === 'transfer' && can('transport.manage') && <Button small variant="secondary" onClick={() => act('transport:contractor', m.id)}>Send with contractor</Button>}
                  {m.status === 'planned' && can('transport.manage') && <Button small variant="link" onClick={() => act('transport:cancel', m.id)}>Cancel</Button>}
                  {m.status === 'out' && m.escort !== 'Contractor' && can('transport.escort') && <Button small onClick={() => act('transport:complete', m.id)}>Complete at reception</Button>}
                </div></td>
              </tr>
            ))}
          </tbody>
        </table>
      )}

      {can('transport.manage') && data.prisons.length > 0 && (
        <>
          <h2>Transfer to another prison</h2>
          <div className="toolbar" style={{ alignItems: 'flex-end' }}>
            <Field label="Prisoner">
              <select className="select" value={form.prisoner} onChange={(e) => setForm({ ...form, prisoner: e.target.value })}>
                <option value="">Choose</option>
                {roster.filter((p) => p.status === 'in_custody').map((p) => <option key={p.id} value={p.id}>{p.name} ({p.prisonNo})</option>)}
              </select>
            </Field>
            <Field label="To">
              <select className="select" value={form.prison} onChange={(e) => setForm({ ...form, prison: e.target.value })}>
                <option value="">Choose</option>
                {data.prisons.map((p) => <option key={p.id} value={p.id}>{p.name}</option>)}
              </select>
            </Field>
            <div className="field"><Button disabled={!form.prisoner || !form.prison} onClick={() => { act('transport:create', Number(form.prisoner), 'transfer', form.prison); setForm({ prisoner: '', prison: '' }); }}>Plan transfer</Button></div>
          </div>
        </>
      )}
    </>
  );
}
