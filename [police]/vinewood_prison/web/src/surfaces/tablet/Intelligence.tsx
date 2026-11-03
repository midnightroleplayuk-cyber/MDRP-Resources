import { useCallback, useEffect, useState } from 'react';
import { call } from '../../lib/nui';
import { ukDate } from '../../lib/format';
import { Button, Empty, Field, Tag } from '../../components/ui';
import type { Prisoner, TabletConfig } from '../../types';

type Report = { id: number; category: string; source_grade: number; intel_grade: string; handling: string; body: string; author: string; created_at: number; name?: string; prison_no?: string };
type Search = { id: number; kind: string; target: string; officer: string; finds: { label: string; count: number }[]; created_at: number };

const SOURCE = ['', '1 Reliable', '2 Untested', '3 Not reliable'];
const GRADE: Record<string, string> = { A: 'A Known directly', B: 'B Known indirectly, corroborated', C: 'C Known indirectly', D: 'D Not known', E: 'E Suspected false' };

export default function Intelligence({ prisonId, can, config, roster, onError }: {
  prisonId: number; can: (n: string) => boolean; config: TabletConfig; roster: Prisoner[]; onError: (e: string) => void;
}) {
  const [tab, setTab] = useState<'reports' | 'searches' | 'new'>(can('intel.read') ? 'reports' : 'searches');
  const [reports, setReports] = useState<Report[]>([]);
  const [searches, setSearches] = useState<Search[]>([]);
  const [form, setForm] = useState({ prisonerId: '', category: '', source: '', grade: '', handling: 'P', body: '' });
  const [sent, setSent] = useState(false);

  const load = useCallback(async () => {
    if (tab === 'reports' && can('intel.read')) {
      const res = await call<{ rows: Report[] }>('intel:list', prisonId, 0);
      if (res.ok) setReports(res.rows); else onError(res.error);
    }
    if (tab === 'searches') {
      const res = await call<{ rows: Search[] }>('intel:searches', prisonId);
      if (res.ok) setSearches(res.rows); else onError(res.error);
    }
  }, [tab, prisonId]);
  useEffect(() => { load(); }, [load]);

  const submit = async () => {
    const res = await call('intel:submit', prisonId, { ...form, prisonerId: form.prisonerId ? Number(form.prisonerId) : null, source: Number(form.source) });
    if (!res.ok) return onError(res.error);
    setForm({ prisonerId: '', category: '', source: '', grade: '', handling: 'P', body: '' });
    setSent(true);
  };

  return (
    <>
      <div className="toolbar">
        <h1 className="toolbar__grow">Security</h1>
        <div className="radios">
          {can('intel.read') && <button className={`radio${tab === 'reports' ? ' is-on' : ''}`} onClick={() => setTab('reports')}>Intelligence</button>}
          <button className={`radio${tab === 'searches' ? ' is-on' : ''}`} onClick={() => setTab('searches')}>Searches</button>
          {can('intel.submit') && <button className={`radio${tab === 'new' ? ' is-on' : ''}`} onClick={() => { setTab('new'); setSent(false); }}>Submit a report</button>}
        </div>
      </div>

      {tab === 'reports' && (reports.length === 0 ? <Empty>No intelligence reports.</Empty> : (
        <table className="table">
          <thead><tr><th>When</th><th>Grade</th><th>Subject</th><th>Report</th><th>By</th></tr></thead>
          <tbody>
            {reports.map((r) => (
              <tr key={r.id}>
                <td>{ukDate(r.created_at * 1000)}</td>
                <td className="mono">{r.source_grade}{r.intel_grade}{r.handling} {r.handling === 'C' && <Tag tone="red">Confidential</Tag>}</td>
                <td>{r.name ? <>{r.name} <span className="muted mono">{r.prison_no}</span></> : <span className="muted">None</span>}</td>
                <td><strong>{r.category}</strong> {r.body}</td>
                <td>{r.author}</td>
              </tr>
            ))}
          </tbody>
        </table>
      ))}

      {tab === 'searches' && (searches.length === 0 ? <Empty>No searches recorded.</Empty> : (
        <table className="table">
          <thead><tr><th>When</th><th>Search</th><th>Found</th><th>By</th></tr></thead>
          <tbody>
            {searches.map((s) => (
              <tr key={s.id}>
                <td>{ukDate(s.created_at * 1000)}</td>
                <td>{s.kind === 'cell' ? `Cell ${s.target}` : s.kind === 'area' ? s.target : `${s.kind === 'full' ? 'Full search' : 'Rub-down'} of ${s.target}`}</td>
                <td>{s.finds.length ? <Tag tone="red">{s.finds.map((f) => `${f.count}x ${f.label}`).join(', ')}</Tag> : <span className="muted">Nothing</span>}</td>
                <td>{s.officer}</td>
              </tr>
            ))}
          </tbody>
        </table>
      ))}

      {tab === 'new' && (sent ? (
        <div className="received received--small" role="status"><h1>Report submitted</h1></div>
      ) : (
        <div style={{ maxWidth: 560 }}>
          <Field label="About" hint="Optional" id="i-p">
            <select id="i-p" className="select" value={form.prisonerId} onChange={(e) => setForm({ ...form, prisonerId: e.target.value })}>
              <option value="">No one in particular</option>
              {roster.map((p) => <option key={p.id} value={p.id}>{p.name} ({p.prisonNo})</option>)}
            </select>
          </Field>
          <Field label="Category" id="i-c">
            <select id="i-c" className="select" value={form.category} onChange={(e) => setForm({ ...form, category: e.target.value })}>
              <option value="">Choose</option>
              {(config.intel?.categories ?? []).map((c) => <option key={c} value={c}>{c}</option>)}
            </select>
          </Field>
          <Field label="Source">
            <div className="radios">{[1, 2, 3].map((n) => <button key={n} className={`radio${form.source === String(n) ? ' is-on' : ''}`} onClick={() => setForm({ ...form, source: String(n) })}>{SOURCE[n]}</button>)}</div>
          </Field>
          <Field label="Intelligence">
            <select className="select" value={form.grade} onChange={(e) => setForm({ ...form, grade: e.target.value })}>
              <option value="">Choose</option>
              {Object.entries(GRADE).map(([k, v]) => <option key={k} value={k}>{v}</option>)}
            </select>
          </Field>
          <Field label="Handling">
            <div className="radios">
              <button className={`radio${form.handling === 'P' ? ' is-on' : ''}`} onClick={() => setForm({ ...form, handling: 'P' })}>Can be shared</button>
              <button className={`radio${form.handling === 'C' ? ' is-on' : ''}`} onClick={() => setForm({ ...form, handling: 'C' })}>Confidential</button>
            </div>
          </Field>
          <Field label="Report" hint="What you saw or heard, when and where" id="i-b">
            <textarea id="i-b" className="textarea" value={form.body} onChange={(e) => setForm({ ...form, body: e.target.value })} />
          </Field>
          <Button disabled={!form.category || !form.source || !form.grade || !form.body.trim()} onClick={submit}>Submit report</Button>
        </div>
      ))}
    </>
  );
}
