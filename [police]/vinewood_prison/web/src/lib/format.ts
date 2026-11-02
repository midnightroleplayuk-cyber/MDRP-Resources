export function duration(seconds?: number | null) {
  if (seconds == null) return '';
  const s = Math.max(0, Math.floor(seconds));
  const d = Math.floor(s / 86400);
  const h = Math.floor((s % 86400) / 3600);
  const m = Math.floor((s % 3600) / 60);
  const parts: string[] = [];
  if (d) parts.push(`${d}d`);
  if (h) parts.push(`${h}h`);
  if (m || !parts.length) parts.push(`${m}m`);
  return parts.join(' ');
}

// oxmysql returns timestamps as milliseconds
export function ukDate(value?: number | string | null) {
  if (value == null || value === '') return '';
  const date = new Date(typeof value === 'number' ? value : Date.parse(value));
  if (isNaN(date.getTime())) return '';
  return date.toLocaleString('en-GB', {
    day: '2-digit', month: '2-digit', year: 'numeric', hour: '2-digit', minute: '2-digit',
  });
}

const ERRORS: Record<string, string> = {
  no_permission: 'Your rank does not allow this.',
  rate_limited: 'Too many requests. Wait a moment and try again.',
  too_far: 'Move closer and try again.',
  not_at_desk: 'The prisoner must be at the reception desk.',
  not_found: 'That record no longer exists. Refresh and try again.',
  no_cell: 'No cell with space matches this category. Add cells in the editor or choose a cell manually.',
  cell_unavailable: 'That cell is full or its wing does not hold this category.',
  cell_full: 'That cell is full.',
  term_too_short: 'The sentence is shorter than the minimum allowed.',
  reason_required: 'Enter a reason.',
  bad_value: 'Check the values you entered.',
  code_taken: 'That prison code is already in use.',
  cell_exists: 'A cell with that number already exists on this wing.',
  pick_door_first: 'Pick a door in the world first.',
  prison_occupied: 'Prisoners are still held here. Release or move them first.',
  preset_not_found: 'No preset with that name in data/presets.',
  preset_invalid: 'The preset file could not be read.',
  not_received: 'This person has not been through reception yet.',
  blocked: 'Another resource blocked this action.',
  busy: 'This record is being processed. Try again in a moment.',
  server_error: 'Something went wrong on the server. Check the server console.',
  no_response: 'The server did not respond.',
  not_ready: 'The prison system is still starting.',
  no_prison: 'No prison has been set up. Create one with the editor.',
  insufficient_funds: 'There is not enough money in the account.',
  canteen_banned: 'Canteen is stopped as a punishment.',
  order_pending: 'There is already an order waiting. Cancel it to order again.',
  over_spend_limit: 'That goes over the spending limit for this period.',
  empty_order: 'Add something to the order first.',
  no_seg_cell: 'There is no free cell on a segregation wing. Add one in the editor.',
  segregated: 'They are in segregation. End segregation first.',
  not_segregated: 'They are not in segregation.',
  prisoner_not_found: 'No prisoner with that number is held here.',
  not_in_custody: 'They are no longer in custody.',
  iep_too_low: 'Their incentive level is too low for this.',
  category_not_allowed: 'This job is not open to their security category.',
  needs_qualification: 'This job needs a qualification first. Enrol on the course at the kiosk.',
  job_full: 'There are no spaces left on this job.',
  already_employed: 'Already working or waiting on an application. Leave that job first.',
  not_employed: 'Not working in a job.',
  already_enrolled: 'Already on a course. Withdraw first to change.',
  already_qualified: 'Already holds this qualification.',
  not_enrolled: 'Not on a course.',
  choose_job: 'Choose the job this workstation belongs to.',
  set_camera_view: 'Line up the view in the world and press "Use my current view" first.',
  no_task: 'That finished too quickly. Try again.',
  lockdown: 'The prison is locked down.',
  too_many_contacts: 'The contact list is full. Remove someone first.',
  too_many_requests: 'You already have three open requests.',
  no_visits_left: 'No visits left for today.',
  plan_open: 'A safer custody plan is already open.',
  movement_open: 'They already have a movement planned.',
  needs_visitor_seat: 'Add at least one visitor seat.',
  door_lockdown: 'Door lockdown is on. Only a Duty Governor or above can open doors until it is lifted.',
  not_at_reception: 'Bring them to reception first.',
  offline: 'They need to be online for this.',
  not_eligible: 'Not eligible for parole.',
  not_yet: 'Not eligible yet.',
  parole_pending: 'An application is already being considered.',
  parole_refused_recently: 'Refused recently. Try again later.',
  term_too_short_parole: 'The sentence is too short for parole.',
};

export function money(amount: number | undefined | null, currency = '£') {
  const n = Math.floor(amount ?? 0);
  return `${n < 0 ? '-' : ''}${currency}${Math.abs(n)}`;
}

export function secondsToClock(s: number) {
  const v = Math.max(0, Math.floor(s));
  const m = Math.floor(v / 60);
  const sec = v % 60;
  return m >= 60 ? duration(v) : `${m}:${String(sec).padStart(2, '0')}`;
}

export function errorText(code?: string) {
  if (!code) return ERRORS.server_error;
  return ERRORS[code] ?? code.replace(/_/g, ' ');
}

const ORIGINS: Record<string, string> = {
  vinewood_moj: 'the court',
  manual: 'the reception desk',
  api: 'another resource',
};

export function originLabel(origin?: string) {
  if (!origin) return '';
  return ORIGINS[origin] ?? origin;
}
