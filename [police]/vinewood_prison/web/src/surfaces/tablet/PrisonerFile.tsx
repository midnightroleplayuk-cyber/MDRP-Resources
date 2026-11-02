import { ReactNode, useCallback, useEffect, useState } from 'react';
import { call } from '../../lib/nui';
import { duration, money, originLabel, ukDate } from '../../lib/format';
import { Button, ConfirmButton, Empty, Field, Summary, Tag, statusTag } from '../../components/ui';
import type { PrisonerFile, TabletConfig, TabletWing } from '../../types';
import { ExtraActions, ExtraSections } from './PrisonerExtras';

const RESTRICTION_LABELS: Record<string, string> = {
  privileges: 'Loss of privileges',
  canteen: 'Canteen stopped',
  earnings: 'Earnings stopped',
};

function Action({ title, children }: { title: string; children: ReactNode }) {
  return (
    <details className="action">
      <summary>{title}</summary>
      <div className="action__body">{children}</div>
    </details>
  );
}

export default function PrisonerFileView({ id, can, wings, categories, config, onBack, onError }: {
  id: number; can: (n: string) => boolean; wings: TabletWing[]; categories: string[]; config: TabletConfig;
  onBack: () => void; onError: (e: string) => void;
}) {
  const [file, setFile] = useState<PrisonerFile | null>(null);
  const [form, setForm] = useState<Record<string, string>>({});
  const set = (k: string, v: string) => setForm((f) => ({ ...f, [k]: v }));
  const cur = config.currency ?? '£';

  const load = useCallback(async () => {
    const res = await call<{ prisoner: PrisonerFile }>('tablet:prisoner', id);
    if (res.ok) setFile(res.prisoner); else { onError(res.error); onBack(); }
  }, [id]);

  useEffect(() => { load(); }, [load]);

  if (!file) return <p className="muted">Loading record…</p>;
  const s = file.sentence;
  const b = file.behaviour;
  const d = file.discipline;
  const acct = file.account;

  const act = async (name: string, ...args: unknown[]) => {
    const res = await call<{ prisoner?: PrisonerFile }>(name, ...args);
    if (!res.ok) { onError(res.error); return false; }
    setForm({});
    if (res.prisoner) setFile(res.prisoner); else onBack();
    return true;
  };

  const freeCells = wings.flatMap((w) => w.cells
    .filter((c) => c.id !== file.cellId && c.occupants.length < c.capacity && w.type === 'standard')
    .map((c) => ({ id: c.id, label: `${c.label} (${w.name})` })));

  const received = file.status !== 'pending';
  const levels = config.iep?.levels ?? [];

  return (
    <>
      <button className="back" onClick={onBack}>Back to the roll</button>
      <div className="file">
        <div>
          <div className="idcard">
            <div className="idcard__no">{file.prisonNo}</div>
            <div className="idcard__meta">
              <span className="idcard__name">{file.name}</span>
              {statusTag(file.status)}
              {file.segregated && <Tag tone="red">Segregation</Tag>}
              <Tag>Category {file.category}</Tag>
              {b && <Tag tone={b.privileges.level === 'enhanced' ? 'green' : b.privileges.level === 'basic' ? 'yellow' : 'blue'}>{file.iepLabel}</Tag>}
              {!file.online && <Tag>Offline</Tag>}
            </div>
          </div>
          <Summary rows={[
            ['Cell', file.cell ?? 'Not allocated'],
            ['Received', ukDate(file.receivedAt)],
            ['Sentence', s ? (s.remand ? 'Remanded in custody' : duration(s.term)) : ''],
            ['Served', s ? duration(s.served) : ''],
            ['Release in', s && !s.remand ? (s.remaining === 0 ? 'Due now' : duration(s.remaining)) : ''],
            ['Committed by', s?.origin ? `${originLabel(s.origin)}${s.ref ? `, case ${s.ref}` : ''}` : ''],
            ['Offences', s?.offences?.length ? s.offences.map((o) => o.title ?? o.code).join(', ') : ''],
            ['Segregation', d?.segregation ? `${d.segregation.reason}${d.segregation.endAt ? `, until ${ukDate(d.segregation.endAt * 1000)}` : ', no end time'}` : ''],
          ]} />

          <ExtraSections file={file} />

          {d && d.restrictions.length > 0 && (
            <>
              <h2>Active punishments</h2>
              <table className="table">
                <thead><tr><th>Punishment</th><th>Until</th><th>Reason</th></tr></thead>
                <tbody>
                  {d.restrictions.map((r, i) => (
                    <tr key={i}><td>{RESTRICTION_LABELS[r.kind] ?? r.kind}{r.kind === 'earnings' ? ` (${r.value}%)` : ''}</td><td>{ukDate(r.untilAt * 1000)}</td><td>{r.reason}</td></tr>
                  ))}
                </tbody>
              </table>
            </>
          )}

          {b && (
            <>
              <h2>Behaviour</h2>
              <p className="lede">Score over the last {b.windowHours} hours: <strong>{b.score > 0 ? `+${b.score}` : b.score}</strong>. Privileges as {b.privileges.label}: spend limit {money(b.privileges.spendLimit, cur)}, wages ×{b.privileges.wageMultiplier}.</p>
              {b.entries.length === 0 ? <Empty>No entries yet.</Empty> : (
                <table className="table">
                  <thead><tr><th>When</th><th>Entry</th><th className="num">Points</th><th>By</th></tr></thead>
                  <tbody>
                    {b.entries.map((e, i) => (
                      <tr key={i}>
                        <td>{ukDate(e.created_at * 1000)}</td>
                        <td>{e.kind === 'warning' ? <Tag tone="yellow">Warning</Tag> : e.kind === 'positive' ? <Tag tone="green">Positive</Tag> : <Tag tone="red">Negative</Tag>} {e.note}</td>
                        <td className="num">{e.points > 0 ? `+${e.points}` : e.points}</td>
                        <td>{e.officer}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              )}
            </>
          )}

          {d && d.adjudications.length > 0 && (
            <>
              <h2>Adjudications</h2>
              <table className="table">
                <thead><tr><th>Raised</th><th>Charge</th><th>Outcome</th></tr></thead>
                <tbody>
                  {d.adjudications.map((a) => (
                    <tr key={a.id}>
                      <td>{ukDate(a.raised_at * 1000)}</td>
                      <td>{a.charge_code} {a.charge_text}</td>
                      <td>{a.status === 'open' ? <Tag tone="yellow">Awaiting hearing</Tag> : a.status === 'proven' ? <Tag tone="red">Proven</Tag> : <Tag>{a.status.replace('_', ' ')}</Tag>}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </>
          )}

          {acct && (
            <>
              <h2>Account</h2>
              <Summary rows={[['Spends', money(acct.spends, cur)], ['Private cash', money(acct.private, cur)]]} />
              {acct.transactions.length > 0 && (
                <table className="table">
                  <thead><tr><th>When</th><th>What</th><th>Account</th><th className="num">Amount</th></tr></thead>
                  <tbody>
                    {acct.transactions.map((t, i) => (
                      <tr key={i}>
                        <td>{ukDate(t.created_at * 1000)}</td><td>{t.kind.replace(/_/g, ' ')}{t.ref ? `: ${t.ref}` : ''}</td>
                        <td>{t.wallet === 'private' ? 'Private cash' : 'Spends'}</td><td className="num">{money(t.amount, cur)}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              )}
            </>
          )}

          {(file.work || file.education) && (
            <>
              <h2>Work and education</h2>
              <Summary rows={[
                ['Job', file.work?.job ? `${file.work.job.label}${file.work.job.status === 'applied' ? ' (applied)' : ''}` : 'None'],
                ['Course', file.education?.enrolment ? `${file.education.enrolment.label}, lesson ${file.education.enrolment.lesson} of ${file.education.enrolment.lessons}` : 'None'],
                ['Qualifications', file.education?.qualifications.length ? file.education.qualifications.map((q) => q.label).join(', ') : 'None'],
                ['Skills', file.work?.skills.length ? file.work.skills.map((sk) => `${sk.label} level ${sk.level}`).join(', ') : ''],
                ['Activity', file.stats ? [file.stats.fitness && `${file.stats.fitness} gym sessions`, file.stats.books && `${file.stats.books} books read`].filter(Boolean).join(', ') : ''],
              ]} />
            </>
          )}

          {file.searches && file.searches.length > 0 && (
            <>
              <h2>Searches</h2>
              <table className="table">
                <thead><tr><th>When</th><th>Search</th><th>Found</th><th>By</th></tr></thead>
                <tbody>
                  {file.searches.map((sr, i) => (
                    <tr key={i}>
                      <td>{ukDate(sr.created_at * 1000)}</td><td>{sr.kind === 'rubdown' ? 'Rub-down' : sr.kind === 'full' ? 'Full search' : `Cell ${sr.target}`}</td>
                      <td>{sr.finds.length ? sr.finds.map((f) => `${f.count}x ${f.label}`).join(', ') : <span className="muted">Nothing</span>}</td><td>{sr.officer}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </>
          )}

          {file.intel && file.intel.length > 0 && (
            <>
              <h2>Intelligence</h2>
              <table className="table">
                <thead><tr><th>When</th><th>Grade</th><th>Report</th></tr></thead>
                <tbody>
                  {file.intel.map((r) => (
                    <tr key={r.id}><td>{ukDate(r.created_at * 1000)}</td><td className="mono">{r.source_grade}{r.intel_grade}{r.handling}</td><td><strong>{r.category}</strong> {r.body}</td></tr>
                  ))}
                </tbody>
              </table>
            </>
          )}

          <h2>Property</h2>
          {file.property.length === 0 ? <Empty>No property recorded.</Empty> : (
            <table className="table">
              <thead><tr><th>Bag</th><th className="num">Items</th><th>Stored by</th><th>Stored</th><th>Returned</th></tr></thead>
              <tbody>
                {file.property.map((bag) => (
                  <tr key={bag.bag_no}>
                    <td className="mono">{bag.bag_no}</td><td className="num">{bag.item_count}</td><td>{bag.stored_by}</td>
                    <td>{ukDate(bag.stored_at)}</td><td>{bag.returned_at ? ukDate(bag.returned_at) : <span className="muted">Held</span>}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}

          <h2>History</h2>
          {file.history.length === 0 ? <Empty>No history yet.</Empty> : (
            <table className="table">
              <thead><tr><th>When</th><th>What</th><th>By</th></tr></thead>
              <tbody>
                {file.history.map((h, i) => <tr key={i}><td>{ukDate(h.created_at)}</td><td>{h.action}</td><td>{h.actor}</td></tr>)}
              </tbody>
            </table>
          )}
        </div>

        <aside className="actions">
          <ExtraActions file={file} can={can} config={config} act={act} Action={Action} />

          {can('behaviour.add') && b && received && (
            <Action title="Add a behaviour entry">
              <Field label="Type">
                <div className="radios">
                  {[['positive', 'Positive'], ['negative', 'Negative'], ['warning', 'Warning']].map(([k, l]) => (
                    <button key={k} type="button" className={`radio${form.kind === k ? ' is-on' : ''}`} onClick={() => set('kind', k)}>{l}</button>
                  ))}
                </div>
              </Field>
              {form.kind && form.kind !== 'warning' && (
                <Field label="Points">
                  <div className="radios">
                    {Array.from({ length: config.iep?.maxPoints ?? 3 }, (_, i) => String(i + 1)).map((n) => (
                      <button key={n} type="button" className={`radio${form.points === n ? ' is-on' : ''}`} onClick={() => set('points', n)}>{n}</button>
                    ))}
                  </div>
                </Field>
              )}
              <Field label="What happened" id="b-note"><input id="b-note" className="input" value={form.note ?? ''} onChange={(e) => set('note', e.target.value)} /></Field>
              <Button disabled={!form.kind || !form.note?.trim() || (form.kind !== 'warning' && !form.points)}
                onClick={() => act('behaviour:add', file.id, form.kind, Number(form.points ?? 0), form.note.trim())}>Add entry</Button>
            </Action>
          )}

          {can('iep.review') && b && received && (
            <Action title="Incentive level review">
              <Field label="New level">
                <div className="radios">
                  {levels.map((l) => (
                    <button key={l} type="button" className={`radio${(form.level ?? file.iep) === l ? ' is-on' : ''}`} onClick={() => set('level', l)}>{config.iep?.labels[l] ?? l}</button>
                  ))}
                </div>
              </Field>
              <Field label="Reason" id="iep-r"><input id="iep-r" className="input" value={form.iepReason ?? ''} onChange={(e) => set('iepReason', e.target.value)} /></Field>
              <Button disabled={!form.level || form.level === file.iep || !form.iepReason?.trim()} onClick={() => act('iep:set', file.id, form.level, form.iepReason.trim())}>Change level</Button>
            </Action>
          )}

          {can('adjudication.charge') && config.discipline && received && (
            <Action title="Place on report">
              <Field label="Charge" id="ch">
                <select id="ch" className="select" value={form.charge ?? ''} onChange={(e) => set('charge', e.target.value)}>
                  <option value="">Choose a charge</option>
                  {config.discipline.charges.map((c) => <option key={c.code} value={c.code}>{c.code} {c.text}</option>)}
                </select>
              </Field>
              <Field label="What happened" hint="Time, place and what you saw" id="ch-d">
                <textarea id="ch-d" className="textarea" value={form.chargeDetails ?? ''} onChange={(e) => set('chargeDetails', e.target.value)} />
              </Field>
              <Button disabled={!form.charge || !form.chargeDetails?.trim()} onClick={() => act('discipline:charge', file.id, form.charge, form.chargeDetails.trim())}>Raise charge</Button>
            </Action>
          )}

          {can('segregation.place') && config.discipline && received && (
            <Action title={file.segregated ? 'End segregation' : 'Segregation'}>
              {file.segregated ? (
                <>
                  <Field label="Reason" id="seg-e"><input id="seg-e" className="input" value={form.segEnd ?? ''} onChange={(e) => set('segEnd', e.target.value)} /></Field>
                  <Button onClick={() => act('seg:end', file.id, form.segEnd?.trim() || 'Reviewed')}>Return to normal location</Button>
                </>
              ) : (
                <>
                  <Field label="Minutes" hint={`Up to ${config.discipline.segMax}. 0 means until ended.`} id="seg-m">
                    <input id="seg-m" className="input input--short" inputMode="numeric" value={form.segMins ?? ''} onChange={(e) => set('segMins', e.target.value.replace(/\D/g, ''))} />
                  </Field>
                  <Field label="Reason" id="seg-r"><input id="seg-r" className="input" value={form.segReason ?? ''} onChange={(e) => set('segReason', e.target.value)} /></Field>
                  <Button disabled={!form.segReason?.trim()} onClick={() => act('seg:place', file.id, Number(form.segMins || 0), form.segReason.trim())}>Move to segregation</Button>
                </>
              )}
            </Action>
          )}

          {can('industries.manage') && config.jobs && received && (
            <Action title={file.work?.job ? 'Change or end job' : 'Give a job'}>
              <Field label="Job" id="job">
                <select id="job" className="select" value={form.job ?? ''} onChange={(e) => set('job', e.target.value)}>
                  <option value="">Choose a job</option>
                  {config.jobs.filter((j) => j.key !== file.work?.job?.key).map((j) => <option key={j.key} value={j.key}>{j.label}</option>)}
                </select>
              </Field>
              <div className="toolbar">
                <Button disabled={!form.job} onClick={() => act('industries:assign', file.id, form.job)}>Give job</Button>
                {file.work?.job && <Button variant="secondary" onClick={() => act('industries:remove', file.id, 'Removed by staff')}>Remove from {file.work.job.label}</Button>}
              </div>
            </Action>
          )}

          {can('cell.allocate') && received && !file.segregated && (
            <Action title="Move cell">
              <Field label="New cell" id="cell">
                <select id="cell" className="select" value={form.cell ?? ''} onChange={(e) => set('cell', e.target.value)}>
                  <option value="">Choose a cell</option>
                  {freeCells.map((c) => <option key={c.id} value={c.id}>{c.label}</option>)}
                </select>
              </Field>
              <Button disabled={!form.cell} onClick={() => act('tablet:move', file.id, Number(form.cell))}>Move to cell</Button>
            </Action>
          )}

          {can('category.set') && (
            <Action title="Security category">
              <div className="radios">
                {categories.map((c) => (
                  <button key={c} className={`radio${file.category === c ? ' is-on' : ''}`} onClick={() => c !== file.category && act('tablet:category', file.id, c)}>{c}</button>
                ))}
              </div>
            </Action>
          )}

          {can('sentence.adjust') && s && !s.remand && (
            <Action title="Change release date">
              <Field label="Minutes" hint="Positive adds time, negative takes time off" id="mins">
                <input id="mins" className="input input--short" inputMode="numeric" value={form.mins ?? ''} onChange={(e) => set('mins', e.target.value.replace(/[^0-9-]/g, ''))} />
              </Field>
              <Field label="Reason" id="adj-reason"><input id="adj-reason" className="input" value={form.adjReason ?? ''} onChange={(e) => set('adjReason', e.target.value)} /></Field>
              <Button disabled={!Number(form.mins) || !form.adjReason?.trim()} onClick={() => act('tablet:adjust', file.id, Number(form.mins), form.adjReason.trim())}>Change release date</Button>
            </Action>
          )}

          {can('account.adjust') && acct && (
            <Action title="Account adjustment">
              <Field label="Account">
                <div className="radios">
                  {[['spends', 'Spends'], ['private', 'Private cash']].map(([k, l]) => (
                    <button key={k} type="button" className={`radio${(form.wallet ?? 'spends') === k ? ' is-on' : ''}`} onClick={() => set('wallet', k)}>{l}</button>
                  ))}
                </div>
              </Field>
              <Field label="Amount" hint="Negative takes money out" id="acc-a">
                <input id="acc-a" className="input input--short" inputMode="numeric" value={form.amount ?? ''} onChange={(e) => set('amount', e.target.value.replace(/[^0-9-]/g, ''))} />
              </Field>
              <Field label="Reason" id="acc-r"><input id="acc-r" className="input" value={form.accReason ?? ''} onChange={(e) => set('accReason', e.target.value)} /></Field>
              <Button disabled={!Number(form.amount) || !form.accReason?.trim()} onClick={() => act('accounts:adjust', file.id, form.wallet ?? 'spends', Number(form.amount), form.accReason.trim())}>Make adjustment</Button>
            </Action>
          )}

          {can('release.authorise') && received && (
            <Action title="Release">
              <p className="muted">Discharges now. Property, clothing and any account balance are returned and the justice record is updated.</p>
              <Field label="Reason" id="rel-reason"><input id="rel-reason" className="input" value={form.relReason ?? ''} onChange={(e) => set('relReason', e.target.value)} /></Field>
              <ConfirmButton disabled={!form.relReason?.trim()} confirmLabel="Confirm release" onConfirm={() => act('tablet:release', file.id, form.relReason.trim())}>Release prisoner</ConfirmButton>
            </Action>
          )}
        </aside>
      </div>
    </>
  );
}
