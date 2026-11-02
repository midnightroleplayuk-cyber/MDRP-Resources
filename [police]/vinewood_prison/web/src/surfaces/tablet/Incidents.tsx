import { useCallback, useEffect, useState } from 'react';
import { call } from '../../lib/nui';
import { ukDate } from '../../lib/format';
import { Button, ConfirmButton, Empty, Field, Tag } from '../../components/ui';
import type { TabletConfig, TabletWing } from '../../types';

type Incident = {
  id: number; type: string; priority: number; location: string; raised_by: string; note?: string; status: string;
  involved: { name: string; prisonNo: string }[]; attending: string[]; created_at: number; closed_by?: string; report?: string;
};
type Lock = { scope: string; wings: number[]; reason: string; by: string; since: number } | null;

export default function Incidents({ prisonId, can, config, wings, onError }: {
  prisonId: number; can: (n: string) => boolean; config: TabletConfig; wings: TabletWing[]; onError: (e: string) => void;
}) {
  const [tab, setTab] = useState<'open' | 'closed'>('open');
  const [rows, setRows] = useState<Incident[]>([]);
  const [lock, setLock] = useState<Lock>(null);
  const [closing, setClosing] = useState<number | null>(null);
  const [report, setReport] = useState('');
  const [ld, setLd] = useState({ scope: 'wing', wing: '', reason: '' });
  const label = (t: string) => config.incidents?.types.find((x) => x.key === t)?.label ?? t.replace(/_/g, ' ');

  const load = useCallback(async () => {
    const res = await call<{ rows: Incident[]; lockdown: Lock }>('incidents:list', prisonId, tab);
    if (res.ok) { setRows(res.rows); setLock(res.lockdown); } else onError(res.error);
  }, [prisonId, tab]);
  useEffect(() => { load(); const t = setInterval(load, 10000); return () => clearInterval(t); }, [load]);

  const act = async (name: string, ...args: unknown[]) => {
    const res = await call(name, ...args);
    if (!res.ok) onError(res.error);
    load();
    return res.ok;
  };

  const wingName = (id: number) => wings.find((w) => w.id === id)?.name ?? `Wing ${id}`;

  return (
    <>
      {lock && (
        <div className="lockdown" role="alert">
          <div>
            <h2>{lock.scope === 'prison' ? 'Prison lockdown' : `Lockdown: ${lock.wings.map(wingName).join(', ')}`}</h2>
            <p>{lock.reason}. Started by {lock.by}, {ukDate(lock.since * 1000)}.</p>
          </div>
          {(can('lockdown.prison') || (lock.scope !== 'prison' && can('lockdown.wing'))) && (
            <ConfirmButton confirmLabel="Confirm lift" onConfirm={() => act('lockdown:lift', prisonId)}>Lift lockdown</ConfirmButton>
          )}
        </div>
      )}

      <div className="toolbar">
        <h1 className="toolbar__grow">Incidents</h1>
        <div className="radios">
          <button className={`radio${tab === 'open' ? ' is-on' : ''}`} onClick={() => setTab('open')}>Open</button>
          <button className={`radio${tab === 'closed' ? ' is-on' : ''}`} onClick={() => setTab('closed')}>Closed</button>
        </div>
      </div>

      {rows.length === 0 ? <Empty>{tab === 'open' ? 'No open incidents.' : 'No closed incidents yet.'}</Empty> : (
        <table className="table">
          <thead><tr><th>When</th><th>Incident</th><th>Where</th><th>Involved</th><th /></tr></thead>
          <tbody>
            {rows.map((r) => (
              <tr key={r.id}>
                <td>{ukDate(r.created_at * 1000)}</td>
                <td>
                  {r.priority === 1 ? <Tag tone="red">{label(r.type)}</Tag> : r.priority === 2 ? <Tag tone="yellow">{label(r.type)}</Tag> : <Tag>{label(r.type)}</Tag>}
                  {r.note && <div>{r.note}</div>}
                  <div className="muted">Raised by {r.raised_by}{r.attending.length ? `. Attending: ${r.attending.join(', ')}` : ''}</div>
                  {r.report && <div className="muted">Report: {r.report}</div>}
                </td>
                <td>{r.location}</td>
                <td>{r.involved.map((p) => `${p.name} (${p.prisonNo})`).join(', ')}</td>
                <td>
                  {tab === 'open' && can('incident.manage') && (closing === r.id ? (
                    <div className="close-form">
                      <textarea className="textarea" placeholder="What happened and what was done" value={report} onChange={(e) => setReport(e.target.value)} />
                      <div className="row-actions">
                        <Button small disabled={!report.trim()} onClick={async () => { if (await act('incidents:close', r.id, report.trim())) { setClosing(null); setReport(''); } }}>Close incident</Button>
                        <Button small variant="link" onClick={() => setClosing(null)}>Cancel</Button>
                      </div>
                    </div>
                  ) : (
                    <div className="row-actions">
                      <Button small variant="secondary" onClick={() => act('incidents:attend', r.id)}>Attending</Button>
                      <Button small variant="secondary" onClick={() => setClosing(r.id)}>Close</Button>
                    </div>
                  ))}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      )}

      {(can('lockdown.wing') || can('lockdown.prison')) && !(lock && lock.scope === 'prison') && (
        <>
          <h2>Lock down</h2>
          <p className="lede">Locks every door in scope, tells prisoners to return to their cells, and returns anyone still out after a minute. The regime will not unlock cells until it is lifted.</p>
          <div className="toolbar" style={{ alignItems: 'flex-end' }}>
            <Field label="Scope">
              <div className="radios">
                {can('lockdown.wing') && <button className={`radio${ld.scope === 'wing' ? ' is-on' : ''}`} onClick={() => setLd({ ...ld, scope: 'wing' })}>One wing</button>}
                {can('lockdown.prison') && <button className={`radio${ld.scope === 'prison' ? ' is-on' : ''}`} onClick={() => setLd({ ...ld, scope: 'prison' })}>Whole prison</button>}
              </div>
            </Field>
            {ld.scope === 'wing' && (
              <Field label="Wing" id="ld-w">
                <select id="ld-w" className="select" value={ld.wing} onChange={(e) => setLd({ ...ld, wing: e.target.value })}>
                  <option value="">Choose</option>
                  {wings.map((w) => <option key={w.id} value={w.id}>{w.name}</option>)}
                </select>
              </Field>
            )}
            <Field label="Reason" id="ld-r"><input id="ld-r" className="input" value={ld.reason} onChange={(e) => setLd({ ...ld, reason: e.target.value })} /></Field>
            <div className="field">
              <ConfirmButton disabled={!ld.reason.trim() || (ld.scope === 'wing' && !ld.wing)} confirmLabel="Confirm lockdown"
                onConfirm={() => { act('lockdown:start', prisonId, ld.scope, ld.wing ? Number(ld.wing) : null, ld.reason.trim()); setLd({ scope: ld.scope, wing: '', reason: '' }); }}>Start lockdown</ConfirmButton>
            </div>
          </div>
        </>
      )}
    </>
  );
}
