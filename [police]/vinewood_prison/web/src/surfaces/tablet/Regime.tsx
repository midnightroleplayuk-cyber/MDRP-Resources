import { useCallback, useEffect, useState } from 'react';
import { call } from '../../lib/nui';
import { secondsToClock, ukDate } from '../../lib/format';
import { Button, Empty, Tag } from '../../components/ui';

type Status = {
  phase: { id: string; label: string; locked: boolean };
  next: string; endsIn: number; automated: boolean;
  pending: { cells?: boolean | null; roll: boolean; deadline: number };
  rolls: { id: number; phase: string; expected: number; accounted: number; missing: string; out_of_cell: string; by_name: string; automated: boolean | number; created_at: number }[];
  timeline: { id: string; at: string; label: string; locked: boolean; current: boolean }[];
};

export default function RegimeView({ prisonId, can, onError }: { prisonId: number; can: (n: string) => boolean; onError: (e: string) => void }) {
  const [st, setSt] = useState<Status | null>(null);
  const [fetchedAt, setFetchedAt] = useState(Date.now());
  const [, tick] = useState(0);

  const load = useCallback(async () => {
    const res = await call<Status>('regime:status', prisonId);
    if (res.ok) { setSt(res); setFetchedAt(Date.now()); } else onError(res.error);
  }, [prisonId]);

  useEffect(() => { load(); const t = setInterval(load, 10000); return () => clearInterval(t); }, [load]);
  useEffect(() => { const t = setInterval(() => tick((n) => n + 1), 1000); return () => clearInterval(t); }, []);

  if (!st) return <p className="muted">Loading regime…</p>;
  const elapsed = (Date.now() - fetchedAt) / 1000;
  const run = can('regime.run');
  const cellsDue = st.pending.cells !== undefined && st.pending.cells !== null;

  const cells = async (locked: boolean) => { const r = await call('regime:cells', prisonId, locked); if (!r.ok) onError(r.error); load(); };
  const roll = async () => { const r = await call('regime:roll', prisonId); if (!r.ok) onError(r.error); load(); };

  return (
    <>
      <div className="regime-now">
        <div>
          <p className="regime-now__label">Now</p>
          <h1>{st.phase.label}</h1>
          <p className="lede">{st.phase.locked ? 'Prisoners behind their doors.' : 'Cells unlocked.'} {st.next} in {secondsToClock(st.endsIn - elapsed)}.</p>
        </div>
        <div>{st.automated ? <Tag tone="yellow">Running automatically</Tag> : <Tag tone="blue">Staffed</Tag>}</div>
      </div>

      {(cellsDue || st.pending.roll) && (
        <div className="due">
          <h2>Due now</h2>
          <p>{[cellsDue && (st.pending.cells ? 'Lock-up' : 'Unlock'), st.pending.roll && 'roll check'].filter(Boolean).join(' and ')}.
            {' '}If nobody does it, the system will in {secondsToClock(st.pending.deadline - elapsed)}.</p>
          {run && (
            <div className="toolbar">
              {cellsDue && <Button onClick={() => cells(!!st.pending.cells)}>{st.pending.cells ? 'Lock all cells' : 'Unlock all cells'}</Button>}
              {st.pending.roll && <Button onClick={roll}>Count the roll</Button>}
            </div>
          )}
        </div>
      )}

      {run && (
        <div className="toolbar">
          <Button variant="secondary" onClick={() => cells(true)}>Lock all cells now</Button>
          <Button variant="secondary" onClick={() => cells(false)}>Unlock all cells now</Button>
          <Button variant="secondary" onClick={roll}>Count the roll now</Button>
        </div>
      )}

      <div className="split split--even">
        <div>
          <h2>Today</h2>
          <table className="table">
            <tbody>
              {st.timeline.map((p) => (
                <tr key={p.id} className={p.current ? 'is-selected' : ''}>
                  <td className="mono" style={{ width: 70 }}>{p.at}</td>
                  <td>{p.current ? <strong>{p.label}</strong> : p.label}</td>
                  <td>{p.locked ? <span className="muted">Locked</span> : ''}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
        <div>
          <h2>Roll checks</h2>
          {st.rolls.length === 0 ? <Empty>No roll checks yet.</Empty> : (
            <table className="table">
              <thead><tr><th>When</th><th>Result</th><th>By</th></tr></thead>
              <tbody>
                {st.rolls.map((r) => {
                  const missing: string[] = JSON.parse(r.missing || '[]');
                  const out: string[] = JSON.parse(r.out_of_cell || '[]');
                  return (
                    <tr key={r.id}>
                      <td>{ukDate(r.created_at * 1000)}</td>
                      <td>
                        {missing.length === 0 ? <Tag tone="green">Correct, {r.expected}</Tag> : <Tag tone="red">{r.accounted} of {r.expected}</Tag>}
                        {missing.length > 0 && <div className="muted">Missing: {missing.join(', ')}</div>}
                        {out.length > 0 && <div className="muted">Out of cell: {out.join(', ')}</div>}
                      </td>
                      <td>{r.by_name}</td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          )}
        </div>
      </div>
    </>
  );
}
