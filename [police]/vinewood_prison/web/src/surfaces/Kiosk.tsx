import { useMemo, useState } from 'react';
import { call } from '../lib/nui';
import { duration, money, ukDate } from '../lib/format';
import { Button, Empty, ErrorBanner, Frame, NavItem, Summary, Tag } from '../components/ui';
import type { AccountSummary, Restriction, UiConfig } from '../types';

type KioskData = {
  me: { name: string; prisonNo: string; cell?: string; category: string; iep: string; remand: boolean; remaining?: number | null; segregated: boolean };
  regime?: { label: string; locked: boolean } | null;
  account: AccountSummary;
  canteen: {
    items: { item: string; label: string; price: number; max: number }[];
    limit: number; spent: number;
    pending?: { id: number; items: { item: string; label: string; qty: number; price: number }[]; total: number; status: string } | null;
    banned?: { untilAt: number; reason: string } | null;
  };
  behaviour: { kind: string; points: number; note: string; created_at: number }[];
  restrictions: Restriction[];
  currency: string;
  sections?: {
    work?: {
      current?: { key: string; label: string; status: string } | null;
      jobs: { key: string; label: string; eligible: boolean; reason?: string; level: number; xp: number; requires?: string }[];
    };
    parole?: { eligible: boolean; reason?: string; wait?: number; last?: { status: string; reason?: string } | null };
    visits?: { next?: { label: string; startsIn: number } | null; allowance: number; npc: boolean; upcoming: { visitor_name: string; type: string; session_label: string; status: string }[] };
    phone?: { pin: string; credit: number; costPerMinute: number; creditItems: number[]; max: number; contacts: { id: number; name: string; number: string; legal: boolean | number; status: string }[] };
    health?: { categories: string[]; requests: { category: string; status: string; appointment?: string; created_at: number }[]; medication: { name: string; dose: string; rounds: string }[] };
    education?: {
      enrolment?: { course: string; label: string; lesson: number; lessons: number } | null;
      qualifications: { course: string; label: string; awardedAt: number }[];
      courses: { key: string; label: string; lessons: number; passed: boolean }[];
    };
  };
};

const REASONS: Record<string, string> = {
  iep_too_low: 'Needs a higher incentive level',
  category_not_allowed: 'Not open to your category',
  needs_qualification: 'Needs a qualification',
  job_full: 'No spaces',
};

type Tab = 'home' | 'work' | 'contact' | 'health' | 'canteen' | 'account';

export default function Kiosk({ initial, ui, onClose }: { initial: KioskData; ui: UiConfig; onClose: () => void }) {
  const [data, setData] = useState<KioskData>(initial);
  const [tab, setTab] = useState<Tab>('home');
  const [basket, setBasket] = useState<Record<string, number>>({});
  const [error, setError] = useState<string | null>(null);
  const [placed, setPlaced] = useState(false);
  const [contact, setContact] = useState({ name: '', number: '', legal: false });
  const [req, setReq] = useState({ category: '', details: '' });
  const [sentReq, setSentReq] = useState(false);
  const cur = data.currency;
  const c = data.canteen;

  const total = useMemo(() => c.items.reduce((n, i) => n + (basket[i.item] ?? 0) * i.price, 0), [basket, c.items]);
  const balance = data.account.spends + data.account.private;
  const left = Math.max(0, c.limit - c.spent);

  const qty = (item: string, delta: number, max: number) =>
    setBasket((b) => ({ ...b, [item]: Math.max(0, Math.min(max, (b[item] ?? 0) + delta)) }));

  const order = async () => {
    const res = await call<KioskData>('kiosk:order', basket);
    if (!res.ok) return setError(res.error);
    setData(res); setBasket({}); setPlaced(true); setError(null);
  };
  const cancel = async (id: number) => {
    const res = await call<KioskData>('kiosk:cancel', id);
    if (!res.ok) return setError(res.error);
    setData(res); setPlaced(false);
  };

  const kioskAct = async (name: string, ...args: unknown[]) => {
    const res = await call<KioskData>(name, ...args);
    if (!res.ok) return setError(res.error);
    setData(res); setError(null);
  };

  const nav = (
    <>
      <NavItem active={tab === 'home'} onClick={() => setTab('home')}>My sentence</NavItem>
      {(data.sections?.work || data.sections?.education) && <NavItem active={tab === 'work'} onClick={() => setTab('work')}>Work and education</NavItem>}
      {(data.sections?.visits || data.sections?.phone) && <NavItem active={tab === 'contact'} onClick={() => setTab('contact')}>Visits and phone</NavItem>}
      {data.sections?.health && <NavItem active={tab === 'health'} onClick={() => setTab('health')}>Healthcare</NavItem>}
      <NavItem active={tab === 'canteen'} onClick={() => setTab('canteen')}>Canteen</NavItem>
      <NavItem active={tab === 'account'} onClick={() => setTab('account')}>My account</NavItem>
      <div className="sidenav__spacer" />
      <div className="sidenav__meta">{data.me.name}<br /><span className="mono">{data.me.prisonNo}</span></div>
    </>
  );

  return (
    <Frame title={ui.prisonDisplayName} service="Prisoner kiosk" subtitle={data.regime ? data.regime.label : undefined} nav={nav} onClose={onClose}>
      <ErrorBanner code={error} onDismiss={() => setError(null)} />

      {tab === 'home' && (
        <>
          <div className="idcard">
            <div className="idcard__no">{data.me.prisonNo}</div>
            <div className="idcard__meta">
              <span className="idcard__name">{data.me.name}</span>
              <Tag tone="blue">{data.me.iep}</Tag>
              <Tag>Category {data.me.category}</Tag>
            </div>
          </div>
          <Summary rows={[
            ['Cell', data.me.cell ?? ''],
            ['Release', data.me.remand ? 'On remand, waiting for court' : data.me.remaining === 0 ? 'Due now' : `In ${duration(data.me.remaining)}`],
            ['Spends', money(data.account.spends, cur)],
            ['Private cash', money(data.account.private, cur)],
          ]} />
          {data.restrictions.length > 0 && (
            <>
              <h2>Punishments in force</h2>
              <ul className="plain">
                {data.restrictions.map((r, i) => <li key={i}>{r.reason}, until {ukDate(r.untilAt * 1000)}</li>)}
              </ul>
            </>
          )}
          {data.sections?.parole && !data.me.remand && (
            <>
              <h2>Early release</h2>
              {data.sections.parole.last?.status === 'pending' ? <p className="lede">Your parole application is being considered.</p>
                : data.sections.parole.eligible ? (
                  <>
                    <p className="lede">You can apply for release on licence. Your behaviour, incentive level, adjudications, work and education are all taken into account.</p>
                    <Button onClick={() => kioskAct('kiosk:parole')}>Apply for parole</Button>
                  </>
                ) : (
                  <p className="lede">
                    {data.sections.parole.reason === 'not_yet' && data.sections.parole.wait ? `You can apply in ${duration(data.sections.parole.wait)} of time served.`
                      : data.sections.parole.reason === 'parole_refused_recently' ? `You were refused${data.sections.parole.last?.reason ? `: ${data.sections.parole.last.reason}` : ''}. You can apply again in ${duration(data.sections.parole.wait ?? 0)}.`
                      : 'Your sentence is not eligible for early release.'}
                  </p>
                )}
            </>
          )}

          <h2>Recent entries on your record</h2>
          {data.behaviour.length === 0 ? <Empty>Nothing recorded.</Empty> : (
            <table className="table">
              <tbody>
                {data.behaviour.map((b, i) => (
                  <tr key={i}>
                    <td style={{ width: 150 }}>{ukDate(b.created_at * 1000)}</td>
                    <td>{b.kind === 'positive' ? <Tag tone="green">Positive</Tag> : b.kind === 'warning' ? <Tag tone="yellow">Warning</Tag> : <Tag tone="red">Negative</Tag>} {b.note}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </>
      )}

      {tab === 'work' && (
        <>
          {data.sections?.work && (
            <>
              <h1>Work</h1>
              {data.sections.work.current ? (
                <p className="lede">
                  {data.sections.work.current.status === 'applied'
                    ? `You have applied for ${data.sections.work.current.label}. Staff will decide soon.`
                    : `You work in ${data.sections.work.current.label}. Go to its workstations during work periods.`}
                  {' '}<Button variant="link" small onClick={() => kioskAct('kiosk:leaveJob')}>{data.sections.work.current.status === 'applied' ? 'Withdraw application' : 'Leave this job'}</Button>
                </p>
              ) : <p className="lede">Apply for a job. You are paid for each task, and you level up as you work.</p>}
              <div className="cards">
                {data.sections.work.jobs.map((j) => {
                  const mine = data.sections?.work?.current?.key === j.key;
                  return (
                    <div key={j.key} className={`card${!j.eligible && !mine ? ' card--off' : ''}`}>
                      <h3>{j.label}</h3>
                      <span>{j.xp > 0 ? `Your level ${j.level} (${j.xp} xp)` : 'No experience yet'}</span>
                      {j.requires && <span className="muted">Needs {j.requires}</span>}
                      <div className="card__foot">
                        {mine ? <Tag tone="green">{data.sections?.work?.current?.status === 'applied' ? 'Applied' : 'Your job'}</Tag>
                          : j.eligible && !data.sections?.work?.current ? <Button small onClick={() => kioskAct('kiosk:apply', j.key)}>Apply</Button>
                          : !j.eligible && j.reason !== 'needs_qualification' ? <span className="muted">{REASONS[j.reason ?? ''] ?? 'Not available'}</span> : null}
                      </div>
                    </div>
                  );
                })}
              </div>
            </>
          )}

          {data.sections?.education && (
            <>
              <h1>Education</h1>
              {data.sections.education.enrolment ? (
                <p className="lede">
                  You are on {data.sections.education.enrolment.label}: {data.sections.education.enrolment.lesson} of {data.sections.education.enrolment.lessons} lessons done.
                  Go to the classroom during work periods. <Button variant="link" small onClick={() => kioskAct('kiosk:withdraw')}>Withdraw</Button>
                </p>
              ) : <p className="lede">Choose a course. Lessons are paid, and some jobs need a qualification.</p>}
              <div className="cards">
                {data.sections.education.courses.map((c) => (
                  <div key={c.key} className={`card${c.passed ? ' card--off' : ''}`}>
                    <h3>{c.label}</h3>
                    <span>{c.lessons} lessons</span>
                    <div className="card__foot">
                      {c.passed ? <Tag tone="green">Passed</Tag>
                        : data.sections?.education?.enrolment?.course === c.key ? <Tag tone="blue">Enrolled</Tag>
                        : !data.sections?.education?.enrolment ? <Button small onClick={() => kioskAct('kiosk:enrol', c.key)}>Enrol</Button> : null}
                    </div>
                  </div>
                ))}
              </div>
            </>
          )}
        </>
      )}

      {tab === 'contact' && (
        <>
          {data.sections?.visits && (
            <>
              <h1>Visits</h1>
              <p className="lede">
                {data.sections.visits.next ? `Next visiting session: ${data.sections.visits.next.label}${data.sections.visits.next.startsIn > 0 ? `, in ${duration(data.sections.visits.next.startsIn)}` : ', now'}. ` : ''}
                You can have {data.sections.visits.allowance} social {data.sections.visits.allowance === 1 ? 'visit' : 'visits'} a day. Family and friends book at the visitor centre with your prison number.
              </p>
              {data.sections.visits.upcoming.length > 0 && (
                <table className="table">
                  <tbody>{data.sections.visits.upcoming.map((v, i) => <tr key={i}><td>{v.visitor_name}</td><td>{v.session_label}</td><td><Tag tone={v.status === 'approved' ? 'blue' : 'yellow'}>{v.status === 'booked' ? 'Waiting for approval' : v.status === 'approved' ? 'Booked' : 'Happening now'}</Tag></td></tr>)}</tbody>
                </table>
              )}
              {data.sections.visits.npc && <div className="toolbar" style={{ marginTop: 12 }}><Button variant="secondary" onClick={() => kioskAct('kiosk:npcVisit')}>Book a family visit</Button></div>}
            </>
          )}

          {data.sections?.phone && (
            <>
              <h1>Phone</h1>
              <Summary rows={[
                ['Your PIN', <span className="mono" key="pin">{data.sections.phone.pin}</span>],
                ['Credit', `${money(data.sections.phone.credit, cur)} (${money(data.sections.phone.costPerMinute, cur)} a minute)`],
              ]} />
              <div className="toolbar">
                {data.sections.phone.creditItems.map((n) => <Button key={n} variant="secondary" small disabled={balance < n} onClick={() => kioskAct('kiosk:buyCredit', n)}>Add {money(n, cur)}</Button>)}
              </div>
              <h2>Contacts</h2>
              {data.sections.phone.contacts.length === 0 ? <Empty>No contacts yet. You can only call approved numbers.</Empty> : (
                <table className="table">
                  <tbody>
                    {data.sections.phone.contacts.map((c) => (
                      <tr key={c.id}>
                        <td>{c.name} {c.legal ? <Tag tone="blue">Legal</Tag> : null}</td><td className="mono">{c.number}</td>
                        <td>{c.status === 'approved' ? <Tag tone="green">Approved</Tag> : c.status === 'pending' ? <Tag tone="yellow">Waiting</Tag> : <Tag tone="red">Refused</Tag>}</td>
                        <td className="num"><Button variant="link" small onClick={() => kioskAct('kiosk:removeContact', c.id)}>Remove</Button></td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              )}
              {data.sections.phone.contacts.length < data.sections.phone.max && (
                <div className="toolbar" style={{ alignItems: 'flex-end', marginTop: 12 }}>
                  <label className="field" style={{ margin: 0 }}><span className="field__label">Name</span><input className="input" value={contact.name} onChange={(e) => setContact({ ...contact, name: e.target.value })} /></label>
                  <label className="field" style={{ margin: 0 }}><span className="field__label">Number</span><input className="input input--short" value={contact.number} onChange={(e) => setContact({ ...contact, number: e.target.value })} /></label>
                  <label className="check"><input type="checkbox" checked={contact.legal} onChange={(e) => setContact({ ...contact, legal: e.target.checked })} /> Solicitor</label>
                  <Button disabled={!contact.name.trim() || contact.number.trim().length < 3} onClick={() => { kioskAct('kiosk:addContact', contact.name.trim(), contact.number.trim(), contact.legal); setContact({ name: '', number: '', legal: false }); }}>Add contact</Button>
                </div>
              )}
            </>
          )}
        </>
      )}

      {tab === 'health' && data.sections?.health && (
        <>
          <h1>Healthcare</h1>
          {data.sections.health.medication.length > 0 && (
            <>
              <h2>Your medication</h2>
              <p className="lede">Collect it from the hatch at each medication round.</p>
              <table className="table"><tbody>{data.sections.health.medication.map((m, i) => <tr key={i}><td>{m.name}</td><td>{m.dose}</td><td className="muted">{m.rounds.replace(',', ', ')}</td></tr>)}</tbody></table>
            </>
          )}
          <h2>Ask to see someone</h2>
          {sentReq ? <div className="received received--small" role="status"><h1>Request sent to healthcare</h1></div> : (
            <>
              <div className="radios" style={{ marginBottom: 12 }}>
                {data.sections.health.categories.map((c) => <button key={c} className={`radio${req.category === c ? ' is-on' : ''}`} onClick={() => setReq({ ...req, category: c })}>{c}</button>)}
              </div>
              <textarea className="textarea" placeholder="What is wrong?" value={req.details} onChange={(e) => setReq({ ...req, details: e.target.value })} />
              <div className="toolbar" style={{ marginTop: 12 }}>
                <Button disabled={!req.category || !req.details.trim()} onClick={async () => {
                  const res = await call<KioskData>('kiosk:health', req.category, req.details.trim());
                  if (!res.ok) return setError(res.error);
                  setData(res); setReq({ category: '', details: '' }); setSentReq(true);
                }}>Send request</Button>
              </div>
            </>
          )}
          {data.sections.health.requests.length > 0 && (
            <table className="table">
              <tbody>{data.sections.health.requests.map((r, i) => <tr key={i}><td>{ukDate(r.created_at * 1000)}</td><td>{r.category}</td><td>{r.status === 'booked' ? `Booked: ${r.appointment}` : r.status}</td></tr>)}</tbody>
            </table>
          )}
        </>
      )}

      {tab === 'canteen' && (
        <>
          <h1>Canteen</h1>
          {c.banned ? (
            <p className="lede">Canteen is stopped until {ukDate(c.banned.untilAt * 1000)}: {c.banned.reason}.</p>
          ) : c.pending ? (
            <>
              {placed && <div className="received received--small" role="status"><h1>Order placed</h1></div>}
              <p className="lede">{c.pending.status === 'due' ? 'Your order missed its delivery round. It will be handed to you as soon as you are available.' : 'Your order is delivered with the next canteen round.'}</p>
              <table className="table">
                <thead><tr><th>Item</th><th className="num">Qty</th><th className="num">Cost</th></tr></thead>
                <tbody>
                  {c.pending.items.map((l) => <tr key={l.item}><td>{l.label}</td><td className="num">{l.qty}</td><td className="num">{money(l.qty * l.price, cur)}</td></tr>)}
                  <tr><td><strong>Total</strong></td><td /><td className="num"><strong>{money(c.pending.total, cur)}</strong></td></tr>
                </tbody>
              </table>
              {c.pending.status === 'pending' && <Button variant="secondary" onClick={() => cancel(c.pending!.id)}>Cancel order and get a refund</Button>}
            </>
          ) : (
            <>
              <p className="lede">You can spend {money(left, cur)} more this period ({money(c.spent, cur)} of {money(c.limit, cur)} used). Your balance is {money(balance, cur)}.</p>
              {c.items.length === 0 ? <Empty>Nothing is available at your incentive level.</Empty> : (
                <table className="table">
                  <thead><tr><th>Item</th><th className="num">Price</th><th className="num">Quantity</th></tr></thead>
                  <tbody>
                    {c.items.map((i) => (
                      <tr key={i.item}>
                        <td>{i.label} <span className="muted">(max {i.max})</span></td>
                        <td className="num">{money(i.price, cur)}</td>
                        <td className="num">
                          <span className="stepper">
                            <button aria-label={`One less ${i.label}`} onClick={() => qty(i.item, -1, i.max)}>−</button>
                            <span className="mono">{basket[i.item] ?? 0}</span>
                            <button aria-label={`One more ${i.label}`} onClick={() => qty(i.item, 1, i.max)}>+</button>
                          </span>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              )}
              <div className="toolbar" style={{ marginTop: 16 }}>
                <span className="toolbar__grow">Total <strong>{money(total, cur)}</strong>{total > left && <span className="warn"> over your limit</span>}{total > balance && <span className="warn"> more than your balance</span>}</span>
                <Button disabled={total === 0 || total > left || total > balance} onClick={order}>Place order</Button>
              </div>
            </>
          )}
        </>
      )}

      {tab === 'account' && (
        <>
          <h1>My account</h1>
          <Summary rows={[['Spends', money(data.account.spends, cur)], ['Private cash', money(data.account.private, cur)]]} />
          <p className="lede">Spends is what you earn here. Private cash is money paid in by family and friends. Canteen uses spends first.</p>
          {data.account.transactions.length === 0 ? <Empty>No transactions yet.</Empty> : (
            <table className="table">
              <thead><tr><th>When</th><th>What</th><th className="num">Amount</th><th className="num">Balance</th></tr></thead>
              <tbody>
                {data.account.transactions.map((t, i) => (
                  <tr key={i}>
                    <td>{ukDate(t.created_at * 1000)}</td>
                    <td>{t.kind.replace(/_/g, ' ')}{t.ref ? `: ${t.ref}` : ''} <span className="muted">({t.wallet === 'private' ? 'private cash' : 'spends'})</span></td>
                    <td className="num">{money(t.amount, cur)}</td>
                    <td className="num">{money(t.balance, cur)}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </>
      )}
    </Frame>
  );
}
