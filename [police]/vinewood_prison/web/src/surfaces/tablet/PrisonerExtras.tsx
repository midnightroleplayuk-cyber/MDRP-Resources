// Phase 5 sections and actions for the prisoner file
import { useState } from 'react';
import { duration, ukDate } from '../../lib/format';
import { Button, Field, Summary, Tag } from '../../components/ui';
import type { PrisonerFile, TabletConfig } from '../../types';

export function ExtraSections({ file }: { file: PrisonerFile }) {
  return (
    <>
      {file.movement && (
        <div className="due">
          <p><strong>{file.movement.status === 'out' ? 'Out of the prison' : 'Movement planned'}</strong>: {file.movement.kind} to {file.movement.destination_label}{file.movement.escort ? `, escorted by ${file.movement.escort}` : ''}.</p>
        </div>
      )}

      {file.welfare && (
        <>
          <h2>Safer custody plan</h2>
          <div className={`due${file.welfare.dueIn <= 0 ? ' due--late' : ''}`}>
            <p><strong>{file.welfare.dueIn <= 0 ? 'Check overdue' : `Next check in ${duration(file.welfare.dueIn)}`}</strong>. Checks every {file.welfare.interval_minutes} minutes. {file.welfare.reason}</p>
          </div>
          {file.welfare.checks.length > 0 && (
            <table className="table">
              <tbody>{file.welfare.checks.map((c, i) => <tr key={i}><td>{ukDate(c.created_at * 1000)}</td><td>{c.note}</td><td>{c.officer}</td></tr>)}</tbody>
            </table>
          )}
        </>
      )}

      {file.health && (
        <>
          <h2>Healthcare <Tag tone="red">Confidential</Tag></h2>
          <Summary rows={[
            ['Medication', file.health.medication.length ? file.health.medication.map((m) => `${m.name} ${m.dose} (${m.rounds})`).join('; ') : 'None'],
            ['Recent doses', file.health.doses.length ? file.health.doses.map((d) => `${d.name} ${d.status}`).slice(0, 5).join(', ') : ''],
            ['Requests', file.health.requests.length ? file.health.requests.map((r) => `${r.category}: ${r.status}${r.appointment ? ` (${r.appointment})` : ''}`).join('; ') : ''],
          ]} />
          {file.health.notes.length > 0 && (
            <table className="table">
              <tbody>{file.health.notes.map((n, i) => <tr key={i}><td>{ukDate(n.created_at * 1000)}</td><td>{n.note}</td><td>{n.author}</td></tr>)}</tbody>
            </table>
          )}
        </>
      )}

      {(file.visits?.length || file.phone || file.gang) && (
        <>
          <h2>Contact and associations</h2>
          <Summary rows={[
            ['Visits', file.visits?.length ? file.visits.map((v) => `${v.visitor_name} (${v.type}, ${v.status})`).slice(0, 4).join('; ') : 'None'],
            ['Phone contacts', file.phone?.contacts.length ? file.phone.contacts.map((c) => `${c.name} ${c.number}${c.legal ? ' (legal)' : ''}${c.status === 'pending' ? ' pending' : ''}`).join('; ') : ''],
            ['Recent calls', file.phone?.calls.length ? file.phone.calls.slice(0, 4).map((c) => `${c.contact}, ${c.answered ? duration(c.seconds) : 'no answer'}${c.monitored ? ', monitored' : ''}`).join('; ') : ''],
            ['Gang', file.gang ? (file.gang.gang ? `${file.gang.gang} (${file.gang.rank})` : 'None') : ''],
            ['Reputation', file.gang ? String(file.gang.rep) : ''],
          ]} />
        </>
      )}
    </>
  );
}

export function ExtraActions({ file, can, config, act, Action }: {
  file: PrisonerFile; can: (n: string) => boolean; config: TabletConfig;
  act: (name: string, ...args: unknown[]) => Promise<boolean>;
  Action: (p: { title: string; children: React.ReactNode }) => JSX.Element;
}) {
  const [f, setF] = useState<Record<string, string>>({});
  const set = (k: string, v: string) => setF((x) => ({ ...x, [k]: v }));
  const [rounds, setRounds] = useState<string[]>([]);
  const hc = config.healthcare;

  return (
    <>
      {can('transport.manage') && config.transport && !file.movement && file.status === 'in_custody' && (
        <Action title="Plan a movement">
          <Field label="Where to">
            <select className="select" value={f.dest ?? ''} onChange={(e) => set('dest', e.target.value)}>
              <option value="">Choose</option>
              {config.transport.destinations.map((d) => <option key={d.id} value={`${d.kind}:${d.id}`}>{d.label}</option>)}
            </select>
          </Field>
          <Field label="Note" id="mv-n"><input id="mv-n" className="input" value={f.mvnote ?? ''} onChange={(e) => set('mvnote', e.target.value)} /></Field>
          <Button disabled={!f.dest} onClick={() => { const [kind, id] = f.dest.split(':'); act('transport:create', file.id, kind, id, f.mvnote); }}>Plan movement</Button>
          <p className="muted" style={{ marginTop: 8 }}>Transfers to another prison are planned from the Movements page.</p>
        </Action>
      )}

      {file.welfare && (
        <Action title="Record a welfare check">
          <p className="muted">You need to be close to them.</p>
          <Field label="What you saw" id="wc"><input id="wc" className="input" value={f.check ?? ''} onChange={(e) => set('check', e.target.value)} /></Field>
          <Button onClick={async () => { if (await act('welfare:check', file.id, f.check?.trim() || 'Seen, no concerns')) set('check', ''); }}>Record check</Button>
        </Action>
      )}

      {can('welfare.manage') && hc && (
        <Action title={file.welfare ? 'Close safer custody plan' : 'Open safer custody plan'}>
          {file.welfare ? (
            <Button variant="secondary" onClick={() => act('welfare:close', file.id)}>Close plan</Button>
          ) : (
            <>
              <Field label="Checks every">
                <div className="radios">{hc.intervals.map((n) => <button key={n} className={`radio${f.interval === String(n) ? ' is-on' : ''}`} onClick={() => set('interval', String(n))}>{n} min</button>)}</div>
              </Field>
              <Field label="Reason" id="wr"><input id="wr" className="input" value={f.wreason ?? ''} onChange={(e) => set('wreason', e.target.value)} /></Field>
              <Button disabled={!f.interval || !f.wreason?.trim()} onClick={() => act('welfare:open', file.id, f.wreason.trim(), Number(f.interval))}>Open plan</Button>
            </>
          )}
        </Action>
      )}

      {can('healthcare.manage') && hc && (
        <>
          <Action title="Add a medical note">
            <Field label="Note" id="mn"><textarea id="mn" className="textarea" value={f.note ?? ''} onChange={(e) => set('note', e.target.value)} /></Field>
            <Button disabled={!f.note?.trim()} onClick={async () => { if (await act('health:note', file.id, f.note.trim())) set('note', ''); }}>Save note</Button>
          </Action>
          <Action title="Prescribe medication">
            <Field label="Medicine" id="pm"><input id="pm" className="input" value={f.med ?? ''} onChange={(e) => set('med', e.target.value)} /></Field>
            <Field label="Dose" id="pd"><input id="pd" className="input" value={f.dose ?? ''} onChange={(e) => set('dose', e.target.value)} /></Field>
            <Field label="Given at">
              <div className="radios">{hc.rounds.map((r) => <button key={r} className={`radio${rounds.includes(r) ? ' is-on' : ''}`} onClick={() => setRounds((x) => x.includes(r) ? x.filter((y) => y !== r) : [...x, r])}>{r}</button>)}</div>
            </Field>
            <Button disabled={!f.med?.trim() || !f.dose?.trim() || rounds.length === 0} onClick={async () => { if (await act('health:prescribe', file.id, f.med.trim(), f.dose.trim(), rounds)) { set('med', ''); set('dose', ''); setRounds([]); } }}>Prescribe</Button>
            {file.health && file.health.medication.length > 0 && (
              <div style={{ marginTop: 12 }}>
                {file.health.medication.map((m) => <div key={m.id} className="toolbar"><span className="toolbar__grow">{m.name} {m.dose}</span><Button small variant="secondary" onClick={() => act('health:stop', file.id, m.id)}>Stop</Button></div>)}
              </div>
            )}
          </Action>
        </>
      )}
    </>
  );
}
