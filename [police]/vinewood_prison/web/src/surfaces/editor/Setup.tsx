import { useEffect, useState } from 'react';
import { call } from '../../lib/nui';
import { Button, Tag } from '../../components/ui';
import type { Estate } from '../../types';

export type GoTo = { tab: 'prison' | 'wings' | 'cells' | 'doors' | 'zones'; zoneType?: string };

type Step = {
  title: string;
  why: string;
  done: boolean;
  progress?: string;
  go: GoTo;
  action: string;
};

export default function Setup({ estate, prisonId, onGo }: { estate: Estate; prisonId: number | null; onGo: (g: GoTo) => void }) {
  const [server, setServer] = useState<string[] | null>(null);
  useEffect(() => { call<{ issues: string[] }>('setup:check').then((r) => setServer(r.ok ? r.issues : [])); }, [estate]);

  const prison = estate.prisons.find((p) => p.id === prisonId) ?? null;
  const on = (m: string) => !estate.modules || estate.modules[m] !== false;
  const wings = estate.wings.filter((w) => w.prison_id === prisonId);
  const standardWings = wings.filter((w) => w.type === 'standard');
  const segWings = wings.filter((w) => w.type === 'segregation');
  const cells = estate.cells.filter((c) => c.prison_id === prisonId);
  const standardCells = cells.filter((c) => standardWings.some((w) => w.id === c.wing_id));
  const segCells = cells.filter((c) => segWings.some((w) => w.id === c.wing_id));
  const withDoor = standardCells.filter((c) => c.door_id);
  const zones = estate.zones.filter((z) => z.prison_id === prisonId);
  const count = (t: string) => zones.filter((z) => z.type === t).length;
  const has = (t: string) => count(t) > 0;
  const points = prison?.boundary?.points?.length ?? 0;
  const plural = (n: number, one: string, many: string) => `${n} ${n === 1 ? one : many}`;

  const essentials: Step[] = [
    { title: 'Create the prison', why: 'Gives it a name and a short code that other scripts use.', done: !!prison, go: { tab: 'prison' }, action: 'Prison details' },
    { title: 'Add a standard wing', why: 'Wings hold cells. New prisoners are only placed on standard wings.', done: standardWings.length > 0, progress: plural(standardWings.length, 'standard wing', 'standard wings'), go: { tab: 'wings' }, action: 'Wings' },
    { title: 'Place cells on it', why: 'Where prisoners are put and return to. Stand in each cell and press E.', done: standardCells.length > 0, progress: plural(standardCells.length, 'cell', 'cells'), go: { tab: 'cells' }, action: 'Cells' },
    { title: 'Reception desk', why: 'Staff receive new prisoners here: property, clothing, cell.', done: has('reception'), go: { tab: 'zones', zoneType: 'reception' }, action: 'Place reception desk' },
    { title: 'Discharge point', why: 'Where released prisoners walk out and collect any property left behind.', done: has('discharge'), go: { tab: 'zones', zoneType: 'discharge' }, action: 'Place discharge point' },
  ];

  const recommended: Step[] = [
    { title: 'Draw the boundary', why: 'The fence line. Without it, anyone more than 250 m from their cell counts as escaped.', done: points >= 3, progress: plural(points, 'corner', 'corners'), go: { tab: 'prison' }, action: 'Boundary' },
    { title: 'Add cell doors', why: 'So cells lock at lock-up and staff can lock and unlock them.', done: standardCells.length > 0 && withDoor.length === standardCells.length, progress: `${withDoor.length} of ${standardCells.length} cells have a door`, go: { tab: 'doors' }, action: 'Doors' },
    { title: 'Segregation wing with a cell', why: 'Needed for segregation and the cellular confinement punishment.', done: segCells.length > 0, progress: segWings.length ? plural(segCells.length, 'segregation cell', 'segregation cells') : 'No segregation wing yet', go: { tab: segWings.length ? 'cells' : 'wings' }, action: segWings.length ? 'Cells' : 'Wings' },
  ];
  if (on('kiosk')) recommended.push({ title: 'Prisoner kiosk', why: 'Prisoners check their sentence, order canteen, apply for jobs and courses.', done: has('kiosk'), go: { tab: 'zones', zoneType: 'kiosk' }, action: 'Place kiosk' });
  recommended.push({ title: 'Holding area', why: 'Where new arrivals wait for an officer. Without it they wait at the reception desk.', done: has('holding'), go: { tab: 'zones', zoneType: 'holding' }, action: 'Place holding area' });

  const optional: Step[] = [];
  const opt = (module: string, title: string, why: string, done: boolean, go: GoTo, action: string, progress?: string) => {
    if (on(module)) optional.push({ title, why, done, go, action, progress });
  };
  opt('industries', 'Workstations', 'Where prisoners do their jobs. Place at least one for each job you use.', has('workstation'), { tab: 'zones', zoneType: 'workstation' }, 'Place workstations', `${count('workstation')} placed`);
  opt('education', 'Classroom', 'Prisoners attend lessons for qualifications.', has('education'), { tab: 'zones', zoneType: 'education' }, 'Place classroom');
  opt('activities', 'Gym, library or showers', 'Things for prisoners to do when unlocked.', has('gym') || has('library') || has('shower'), { tab: 'zones', zoneType: 'gym' }, 'Place gym');
  opt('phone', 'Phones', 'Prisoners call approved contacts.', has('phone'), { tab: 'zones', zoneType: 'phone' }, 'Place phones', `${count('phone')} placed`);
  opt('healthcare', 'Medication hatch', 'Prisoners collect medication at medication rounds.', has('meds_hatch'), { tab: 'zones', zoneType: 'meds_hatch' }, 'Place hatch');
  const visitTypes = ['visits_booking', 'visits_checkin', 'visits_table'];
  opt('visits', 'Visits: booking, check-in and tables', 'Visitors book, check in and sit across a table from the prisoner. Needs all three.',
    visitTypes.every(has), { tab: 'zones', zoneType: visitTypes.find((t) => !has(t)) ?? 'visits_table' }, 'Place visits points',
    `${visitTypes.filter(has).length} of 3 placed, ${plural(count('visits_table'), 'table', 'tables')}`);
  opt('accounts', 'Finance desk', 'Outside the wire. Visitors pay money into a prisoner\u2019s account.', has('finance'), { tab: 'zones', zoneType: 'finance' }, 'Place finance desk');
  opt('security', 'Evidence store', 'Where items seized in searches are kept.', has('evidence'), { tab: 'zones', zoneType: 'evidence' }, 'Place evidence store');
  opt('cctv', 'CCTV cameras', 'Staff watch them from the tablet.', has('cctv'), { tab: 'zones', zoneType: 'cctv' }, 'Place cameras', `${count('cctv')} placed`);
  opt('ai', 'AI officer posts', 'Where AI officers stand when no staff are on duty.', has('officer_post'), { tab: 'zones', zoneType: 'officer_post' }, 'Place posts');
  opt('gangs', 'Gang territories', 'Areas such as the yard that gangs fight over.', has('territory'), { tab: 'zones', zoneType: 'territory' }, 'Place territories');

  const essentialsDone = essentials.filter((s) => s.done).length;
  const ready = essentialsDone === essentials.length;

  const list = (steps: Step[]) => (
    <ol className="checklist">
      {steps.map((s) => (
        <li key={s.title} className={s.done ? 'is-done' : ''}>
          <span className="checklist__mark" aria-hidden="true">{s.done ? '✓' : ''}</span>
          <div className="checklist__body">
            <div className="checklist__title">{s.title} {s.progress && <span className="muted">({s.progress})</span>}</div>
            <div className="checklist__why">{s.why}</div>
          </div>
          <div className="checklist__go">
            {s.done ? <Tag tone="green">Done</Tag> : <Button small variant="secondary" onClick={() => onGo(s.go)}>{s.action}</Button>}
          </div>
        </li>
      ))}
    </ol>
  );

  // Server checks: leave out per-prison lines this page already covers (they start with the prison code)
  const serverOnly = (server ?? []).filter((i) => !/^[A-Z0-9_]+: /.test(i));

  return (
    <div className="setup">
      <h1>Setup checklist</h1>
      {ready ? (
        <div className="received received--small" role="status"><h1>Ready to receive prisoners</h1></div>
      ) : (
        <div className="due">
          <p><strong>{essentialsDone} of {essentials.length} essentials done.</strong> Finish the first list and the prison can take prisoners. Work top to bottom: each step needs the one before it.</p>
        </div>
      )}

      <h2>1. Must have</h2>
      {list(essentials)}

      <h2>2. Strongly recommended</h2>
      <p className="lede">The prison runs without these, but not well.</p>
      {list(recommended)}

      {optional.length > 0 && (
        <>
          <h2>3. Features you have switched on</h2>
          <p className="lede">Each needs its points placed before it does anything. Turn off features you don't want in <span className="mono">config/modules.lua</span>.</p>
          {list(optional)}
        </>
      )}

      <h2>{optional.length > 0 ? '4' : '3'}. Server checks</h2>
      {server === null ? <p className="muted">Checking…</p>
        : serverOnly.length === 0 ? <p><Tag tone="green">Items and resources all found</Tag></p>
        : <ul className="plain">{serverOnly.map((i) => <li key={i}>{i}</li>)}</ul>}
    </div>
  );
}
