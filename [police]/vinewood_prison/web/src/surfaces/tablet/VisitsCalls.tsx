import { useCallback, useEffect, useState } from 'react';
import { call } from '../../lib/nui';
import { duration, ukDate } from '../../lib/format';
import { Button, Empty, Tag } from '../../components/ui';

type Visit = { id: number; name: string; prison_no: string; visitor_name: string; type: string; session_label: string; status: string; created_at: number };
type Ban = { identifier: string; until_at: number; reason: string };
type Contact = { id: number; prisoner: string; prison_no: string; name: string; number: string; legal: number };
type Call = { id: number; prisoner: string; prison_no: string; contact: string; number: string; legal: number; monitored: number; answered: number; seconds: number; created_at: number };

const STATUS: Record<string, 'green' | 'yellow' | 'blue' | 'red' | 'grey'> = { approved: 'blue', booked: 'yellow', in_progress: 'green', completed: 'grey', refused: 'red', terminated: 'red', cancelled: 'grey', missed: 'grey' };

export default function VisitsCalls({ prisonId, can, onError }: { prisonId: number; can: (n: string) => boolean; onError: (e: string) => void }) {
  const [tab, setTab] = useState<'visits' | 'phone'>('visits');
  const [visits, setVisits] = useState<{ rows: Visit[]; bans: Ban[]; next?: { label: string; startsIn: number } } | null>(null);
  const [phone, setPhone] = useState<{ pending: Contact[]; calls: Call[] } | null>(null);

  const load = useCallback(async () => {
    if (tab === 'visits') {
      const res = await call<{ rows: Visit[]; bans: Ban[]; next?: { label: string; startsIn: number } }>('visits:list', prisonId);
      if (res.ok) setVisits(res); else onError(res.error);
    } else if (can('phone.manage')) {
      const res = await call<{ pending: Contact[]; calls: Call[] }>('phone:pending', prisonId);
      if (res.ok) setPhone(res); else onError(res.error);
    }
  }, [tab, prisonId]);
  useEffect(() => { load(); }, [load]);

  const act = async (name: string, ...args: unknown[]) => { const r = await call(name, ...args); if (!r.ok) onError(r.error); load(); };

  return (
    <>
      <div className="toolbar">
        <h1 className="toolbar__grow">Visits and calls</h1>
        <div className="radios">
          <button className={`radio${tab === 'visits' ? ' is-on' : ''}`} onClick={() => setTab('visits')}>Visits</button>
          {can('phone.manage') && <button className={`radio${tab === 'phone' ? ' is-on' : ''}`} onClick={() => setTab('phone')}>Phone</button>}
        </div>
      </div>

      {tab === 'visits' && visits && (
        <>
          {visits.next && <p className="lede">Next visiting session: {visits.next.label}{visits.next.startsIn > 0 ? `, in ${duration(visits.next.startsIn)}` : ', running now'}.</p>}
          {visits.rows.length === 0 ? <Empty>No visits booked.</Empty> : (
            <table className="table">
              <thead><tr><th>Prisoner</th><th>Visitor</th><th>Session</th><th>Status</th><th /></tr></thead>
              <tbody>
                {visits.rows.map((v) => (
                  <tr key={v.id}>
                    <td>{v.name} <span className="muted mono">{v.prison_no}</span></td>
                    <td>{v.visitor_name} {v.type !== 'social' && <Tag>{v.type === 'npc' ? 'Family' : 'Legal'}</Tag>}</td>
                    <td>{v.session_label}</td>
                    <td><Tag tone={STATUS[v.status] ?? 'grey'}>{v.status.replace('_', ' ')}</Tag></td>
                    <td><div className="row-actions">
                      {can('visits.manage') && v.status === 'booked' && <Button small onClick={() => act('visits:decide', v.id, true)}>Approve</Button>}
                      {can('visits.manage') && (v.status === 'booked' || v.status === 'approved') && <Button small variant="secondary" onClick={() => act('visits:decide', v.id, false)}>Cancel</Button>}
                      {can('visits.manage') && v.status === 'in_progress' && <Button small variant="secondary" onClick={() => act('visits:end', v.id)}>End visit</Button>}
                    </div></td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
          {visits.bans.length > 0 && (
            <>
              <h2>Banned visitors</h2>
              <table className="table">
                <tbody>
                  {visits.bans.map((b) => (
                    <tr key={b.identifier}><td className="mono">{b.identifier}</td><td>{b.reason}</td><td>Until {ukDate(b.until_at * 1000)}</td>
                      <td className="num">{can('visits.manage') && <Button small variant="secondary" onClick={() => act('visits:unban', b.identifier)}>Lift ban</Button>}</td></tr>
                  ))}
                </tbody>
              </table>
            </>
          )}
        </>
      )}

      {tab === 'phone' && phone && (
        <>
          <h2>Contacts waiting for approval</h2>
          {phone.pending.length === 0 ? <Empty>None.</Empty> : (
            <table className="table">
              <tbody>
                {phone.pending.map((c) => (
                  <tr key={c.id}>
                    <td>{c.prisoner} <span className="muted mono">{c.prison_no}</span></td>
                    <td>{c.name} <span className="mono">{c.number}</span> {c.legal ? <Tag tone="blue">Legal</Tag> : null}</td>
                    <td><div className="row-actions">
                      <Button small onClick={() => act('phone:decide', c.id, true)}>Approve</Button>
                      <Button small variant="secondary" onClick={() => act('phone:decide', c.id, false)}>Refuse</Button>
                    </div></td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
          <h2>Call log</h2>
          {phone.calls.length === 0 ? <Empty>No calls yet.</Empty> : (
            <table className="table">
              <thead><tr><th>When</th><th>Prisoner</th><th>Called</th><th>Length</th><th /></tr></thead>
              <tbody>
                {phone.calls.map((c) => (
                  <tr key={c.id}>
                    <td>{ukDate(c.created_at * 1000)}</td><td>{c.prisoner}</td>
                    <td>{c.contact} <span className="mono muted">{c.number}</span></td>
                    <td>{c.answered ? duration(c.seconds) : <span className="muted">No answer</span>}</td>
                    <td>{c.legal ? <Tag tone="blue">Legal</Tag> : c.monitored ? <Tag tone="yellow">Monitored</Tag> : null}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </>
      )}
    </>
  );
}
