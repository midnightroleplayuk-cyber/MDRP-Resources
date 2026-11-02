import { useCallback, useEffect, useState } from 'react';
import { call } from '../../lib/nui';
import { ConfirmButton, Empty, Tag } from '../../components/ui';

type Gang = { id: number; name: string; influence: number; members: { name: string; prisonNo?: string; rank: string }[]; relations: { name: string; stance: string }[]; territories: string[] };
type Territory = { id: number; label: string; gang?: string; contested?: string };

export default function Gangs({ prisonId, can, onError }: { prisonId: number; can: (n: string) => boolean; onError: (e: string) => void }) {
  const [data, setData] = useState<{ gangs: Gang[]; territories: Territory[] } | null>(null);
  const load = useCallback(async () => {
    const res = await call<{ gangs: Gang[]; territories: Territory[] }>('gangs:list', prisonId);
    if (res.ok) setData(res); else onError(res.error);
  }, [prisonId]);
  useEffect(() => { load(); }, [load]);
  if (!data) return <p className="muted">Loading…</p>;

  return (
    <>
      <h1>Gangs</h1>
      {data.territories.length > 0 && (
        <>
          <h2>Territory</h2>
          <table className="table">
            <tbody>
              {data.territories.map((t) => (
                <tr key={t.id}><td>{t.label}</td><td>{t.gang ? <Tag tone="red">{t.gang}</Tag> : <span className="muted">Nobody</span>}</td><td>{t.contested && <Tag tone="yellow">Contested by {t.contested}</Tag>}</td></tr>
              ))}
            </tbody>
          </table>
        </>
      )}
      <h2>Known gangs</h2>
      {data.gangs.length === 0 ? <Empty>No gangs known.</Empty> : data.gangs.map((g) => (
        <section key={g.id} className="wing">
          <div className="wing__head">
            <h2>{g.name}</h2>
            <span className="muted">Influence {g.influence}. {g.members.length} members.</span>
            <span className="toolbar__grow" />
            {can('gangs.manage') && <ConfirmButton small confirmLabel="Confirm break-up" onConfirm={async () => { const r = await call('gangs:disband', g.id); if (!r.ok) onError(r.error); load(); }}>Break up</ConfirmButton>}
          </div>
          <p>{g.members.map((m) => `${m.name}${m.prisonNo ? ` (${m.prisonNo})` : ''}${m.rank === 'leader' ? ', leader' : ''}`).join('; ')}</p>
          {(g.relations.length > 0 || g.territories.length > 0) && (
            <p className="muted">
              {g.relations.map((r) => `${r.stance === 'ally' ? 'Allied with' : 'Rivals of'} ${r.name}`).join('. ')}
              {g.territories.length > 0 && `${g.relations.length ? '. ' : ''}Runs ${g.territories.join(', ')}`}
            </p>
          )}
        </section>
      ))}
    </>
  );
}
