import { useCallback, useEffect, useState } from 'react';
import { call } from '../../lib/nui';
import { ukDate } from '../../lib/format';
import { Button, Empty, Field, Tag } from '../../components/ui';

type Person = { id: number; prisonerId: number; name: string; prisonNo: string; since: number; level: number };
type Job = { key: string; label: string; slots: number; minIep: string; requires?: string; categories?: string[]; employed: Person[]; applied: Person[] };
type Order = { id: number; job: string; label: string; target: number; done: number; status: string; created_by: string; created_at: number };
type Status = { jobs: Job[]; orders: Order[] };

export default function Industries({ prisonId, can, onError, onOpen }: {
  prisonId: number; can: (n: string) => boolean; onError: (e: string) => void; onOpen: (id: number) => void;
}) {
  const [st, setSt] = useState<Status | null>(null);
  const [order, setOrder] = useState({ job: '', label: '', target: '' });
  const manage = can('industries.manage');

  const load = useCallback(async () => {
    const res = await call<Status>('industries:status', prisonId);
    if (res.ok) setSt(res); else onError(res.error);
  }, [prisonId]);
  useEffect(() => { load(); }, [load]);

  const act = async (name: string, ...args: unknown[]) => {
    const res = await call<Status>(name, ...args);
    if (res.ok) setSt(res); else onError(res.error);
  };

  if (!st) return <p className="muted">Loading industries…</p>;
  const applications = st.jobs.flatMap((j) => j.applied.map((a) => ({ ...a, job: j.label })));
  const label = (key: string) => st.jobs.find((j) => j.key === key)?.label ?? key;

  return (
    <>
      <h1>Industries</h1>

      <h2>Applications</h2>
      {applications.length === 0 ? <Empty>No applications waiting.</Empty> : (
        <table className="table">
          <thead><tr><th>Prisoner</th><th>Job</th><th>Applied</th><th /></tr></thead>
          <tbody>
            {applications.map((a) => (
              <tr key={a.id}>
                <td><button className="btn btn--link btn--small" onClick={() => onOpen(a.prisonerId)}>{a.name}</button> <span className="muted mono">{a.prisonNo}</span></td>
                <td>{a.job}</td>
                <td>{ukDate(a.since * 1000)}</td>
                <td><div className="row-actions">
                  {manage && <Button small onClick={() => act('industries:approve', a.id)}>Approve</Button>}
                  {manage && <Button small variant="secondary" onClick={() => act('industries:reject', a.id, 'Not suitable at this time')}>Turn down</Button>}
                </div></td>
              </tr>
            ))}
          </tbody>
        </table>
      )}

      <h2>Work orders</h2>
      {st.orders.length === 0 ? <Empty>No work orders. Daily orders appear at the start of each regime day.</Empty> : (
        <table className="table">
          <thead><tr><th>Order</th><th>Job</th><th>Progress</th><th>Set by</th></tr></thead>
          <tbody>
            {st.orders.map((o) => (
              <tr key={o.id}>
                <td>{o.label}</td>
                <td>{label(o.job)}</td>
                <td>
                  {o.status === 'complete' ? <Tag tone="green">Done, {o.target}</Tag> : (
                    <span className="progress" aria-label={`${o.done} of ${o.target}`}>
                      <span className="progress__bar" style={{ width: `${Math.min(100, (o.done / o.target) * 100)}%` }} />
                      <span className="progress__text">{o.done} of {o.target}</span>
                    </span>
                  )}
                </td>
                <td>{o.created_by}</td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
      {manage && (
        <div className="toolbar" style={{ alignItems: 'flex-end' }}>
          <Field label="Job" id="o-job">
            <select id="o-job" className="select" value={order.job} onChange={(e) => setOrder({ ...order, job: e.target.value })}>
              <option value="">Choose</option>
              {st.jobs.map((j) => <option key={j.key} value={j.key}>{j.label}</option>)}
            </select>
          </Field>
          <Field label="Order" id="o-label"><input id="o-label" className="input" value={order.label} onChange={(e) => setOrder({ ...order, label: e.target.value })} /></Field>
          <Field label="Units" id="o-target"><input id="o-target" className="input input--short" inputMode="numeric" value={order.target} onChange={(e) => setOrder({ ...order, target: e.target.value.replace(/\D/g, '') })} /></Field>
          <div className="field"><Button disabled={!order.job || !order.label.trim() || !Number(order.target)} onClick={() => { act('industries:order', prisonId, order.job, order.label.trim(), Number(order.target)); setOrder({ job: '', label: '', target: '' }); }}>Add order</Button></div>
        </div>
      )}

      <h2>Jobs</h2>
      <table className="table">
        <thead><tr><th>Job</th><th className="num">Spaces</th><th>Working</th><th>Needs</th></tr></thead>
        <tbody>
          {st.jobs.map((j) => (
            <tr key={j.key}>
              <td><strong>{j.label}</strong></td>
              <td className="num">{j.employed.length} of {j.slots}</td>
              <td>{j.employed.length === 0 ? <span className="muted">Nobody</span> : j.employed.map((e, i) => (
                <span key={e.id}>{i > 0 && ', '}<button className="btn btn--link btn--small" onClick={() => onOpen(e.prisonerId)}>{e.name}</button> <span className="muted">L{e.level}</span></span>
              ))}</td>
              <td className="muted">{[j.minIep !== 'basic' && `${j.minIep.charAt(0).toUpperCase()}${j.minIep.slice(1)} or above`, j.categories && `category ${j.categories.join('/')}`, j.requires && 'a qualification'].filter(Boolean).join(', ') || 'Nothing'}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </>
  );
}
