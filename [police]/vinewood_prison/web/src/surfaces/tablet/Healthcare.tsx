import { useCallback, useEffect, useState } from 'react';
import { call } from '../../lib/nui';
import { duration, ukDate } from '../../lib/format';
import { Button, Empty, Tag } from '../../components/ui';

type Req = { id: number; name: string; prison_no: string; prisoner_id: number; category: string; details: string; status: string; appointment?: string; created_at: number };
type Med = { id: number; prisoner: string; medicine: string; prison_no: string; dose: string; rounds: string; prisoner_id: number };
type Plan = { id: number; name: string; prison_no: string; prisoner_id: number; reason: string; interval_minutes: number; dueIn: number };

export default function Healthcare({ prisonId, can, onError, onOpen }: { prisonId: number; can: (n: string) => boolean; onError: (e: string) => void; onOpen: (id: number) => void }) {
  const [data, setData] = useState<{ requests: Req[]; meds: Med[]; plans: Plan[]; round?: { phaseId: string } } | null>(null);
  const [edit, setEdit] = useState<Record<number, string>>({});

  const load = useCallback(async () => {
    const res = await call<{ requests: Req[]; meds: Med[]; plans: Plan[]; round?: { phaseId: string } }>('health:list', prisonId);
    if (res.ok) setData(res); else onError(res.error);
  }, [prisonId]);
  useEffect(() => { load(); }, [load]);
  if (!data) return <p className="muted">Loading…</p>;
  const manage = can('healthcare.manage');
  const update = async (id: number, close: boolean) => {
    const r = await call('health:update', id, close ? null : edit[id], close, close ? edit[id] : null);
    if (!r.ok) onError(r.error); else { setEdit((e) => ({ ...e, [id]: '' })); load(); }
  };

  return (
    <>
      <h1>Healthcare</h1>
      {data.round && <p><Tag tone="green">Medication round open</Tag></p>}

      <h2>Requests</h2>
      {data.requests.length === 0 ? <Empty>No open requests.</Empty> : (
        <table className="table">
          <thead><tr><th>Patient</th><th>Request</th><th>Status</th><th /></tr></thead>
          <tbody>
            {data.requests.map((r) => (
              <tr key={r.id}>
                <td><button className="btn btn--link btn--small" onClick={() => onOpen(r.prisoner_id)}>{r.name}</button> <span className="muted mono">{r.prison_no}</span><div className="muted">{ukDate(r.created_at * 1000)}</div></td>
                <td><strong>{r.category}</strong> {r.details}</td>
                <td>{r.status === 'booked' ? <Tag tone="blue">{r.appointment}</Tag> : <Tag tone="yellow">New</Tag>}</td>
                <td>{manage && (
                  <div className="close-form">
                    <input className="input" placeholder={r.status === 'booked' ? 'Outcome' : 'Appointment, e.g. GP after lunch'} value={edit[r.id] ?? ''} onChange={(e) => setEdit({ ...edit, [r.id]: e.target.value })} />
                    <div className="row-actions" style={{ marginTop: 6 }}>
                      {r.status !== 'booked' && <Button small disabled={!edit[r.id]?.trim()} onClick={() => update(r.id, false)}>Book</Button>}
                      <Button small variant="secondary" onClick={() => update(r.id, true)}>Close</Button>
                    </div>
                  </div>
                )}</td>
              </tr>
            ))}
          </tbody>
        </table>
      )}

      <div className="cols">
        <div>
          <h2>Safer custody</h2>
          {data.plans.length === 0 ? <Empty>No open plans.</Empty> : (
            <table className="table">
              <tbody>
                {data.plans.map((p) => (
                  <tr key={p.id}>
                    <td><button className="btn btn--link btn--small" onClick={() => onOpen(p.prisoner_id)}>{p.name}</button></td>
                    <td>Every {p.interval_minutes} min</td>
                    <td>{p.dueIn <= 0 ? <Tag tone="red">Check overdue</Tag> : <span className="muted">Due in {duration(p.dueIn)}</span>}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </div>
        <div>
          <h2>Medication</h2>
          {data.meds.length === 0 ? <Empty>Nobody on medication.</Empty> : (
            <table className="table">
              <tbody>
                {data.meds.map((m) => (
                  <tr key={m.id}><td><button className="btn btn--link btn--small" onClick={() => onOpen(m.prisoner_id)}>{m.prisoner}</button></td><td>{m.medicine} {m.dose}</td><td className="muted">{m.rounds}</td></tr>
                ))}
              </tbody>
            </table>
          )}
        </div>
      </div>
    </>
  );
}
