export type UiConfig = { prisonDisplayName: string; serviceName: string };

export type Sentence = {
  id: number; origin?: string; ref?: string; offences?: { code?: string; title?: string }[];
  term: number; served: number; releaseAt?: number | null; remaining?: number | null; remand: boolean;
};

export type Prisoner = {
  id: number; name: string; prisonNo: string; prison?: string; prisonId: number;
  cellId?: number | null; cell?: string | null; category: string; iep: string; status: string;
  online: boolean; receivedAt?: number | null; sentence?: Sentence; segregated?: boolean; iepLabel?: string;
};

export type Tx = { wallet: string; kind: string; amount: number; balance: number; ref?: string; actor: string; created_at: number };
export type AccountSummary = { spends: number; private: number; currency: string; transactions: Tx[] };
export type Restriction = { kind: string; value: number; untilAt: number; reason: string };

export type PrisonerFile = Prisoner & {
  iepLabel?: string; segregated?: boolean; segregationEnds?: number | null;
  behaviour?: {
    score: number; windowHours: number;
    privileges: { level: string; label: string; spendLimit: number; wageMultiplier: number };
    entries: { kind: string; points: number; note: string; officer: string; created_at: number }[];
    reviews: { from_level: string; to_level: string; reviewer: string; reason: string; created_at: number }[];
  };
  discipline?: {
    restrictions: Restriction[];
    segregation?: { reason: string; startAt: number; endAt?: number | null; placedBy: string } | null;
    adjudications: { id: number; charge_code: string; charge_text: string; status: string; raised_at: number; heard_at?: number | null }[];
  };
  account?: AccountSummary | null;
  work?: { job?: { key: string; label: string; status: string; since: number } | null; skills: { job: string; label: string; xp: number; level: number }[] };
  education?: { enrolment?: { course: string; label: string; lesson: number; lessons: number } | null; qualifications: { course: string; label: string; awardedAt: number }[] };
  stats?: Record<string, number>;
  searches?: { kind: string; target: string; officer: string; finds: { label: string; count: number }[]; created_at: number }[];
  visits?: { visitor_name: string; type: string; session_label: string; status: string; created_at: number }[];
  phone?: { contacts: { id: number; name: string; number: string; legal: boolean | number; status: string }[]; calls: { contact: string; number: string; legal: number; monitored: number; answered: number; seconds: number; created_at: number }[] } | null;
  gang?: { rep: number; gang?: string | null; rank?: string | null } | null;
  health?: {
    notes: { note: string; author: string; created_at: number }[];
    medication: { id: number; name: string; dose: string; rounds: string; prescribed_by: string; created_at: number }[];
    doses: { status: string; created_at: number; name: string }[];
    requests: { id: number; category: string; details: string; status: string; appointment?: string; outcome?: string; created_at: number }[];
  } | null;
  movement?: { id: number; kind: string; destination_label: string; status: string; escort?: string; out_at?: number } | null;
  welfare?: { id: number; reason: string; interval_minutes: number; opened_by: string; opened_at: number; dueIn: number; checks: { note: string; officer: string; created_at: number }[] } | null;
  intel?: { id: number; category: string; source_grade: number; intel_grade: string; handling: string; body: string; author: string; created_at: number }[] | null;
  property: { bag_no: string; item_count: number; stored_by: string; stored_at: number; returned_at?: number | null }[];
  history: { actor: string; action: string; payload?: string; created_at: number }[];
};

export type Occupant = { id: number; name: string; prisonNo: string; online: boolean };
export type TabletCell = { id: number; label: string; capacity: number; occupants: Occupant[]; doorId?: number | null; locked?: boolean | null };
export type TabletDoor = { id: number; label: string; kind: string; locked: boolean };
export type TabletWing = { id: number; code: string; name: string; type: string; security: string; cells: TabletCell[]; doors: TabletDoor[] };

export type Coords = { x: number; y: number; z: number; w?: number };
export type EPrison = { id: number; code: string; name: string; callerName?: string | null; boundary?: { points: Coords[] } | null };
export type EWing = { id: number; prison_id: number; code: string; name: string; type: string; security: string };
export type ECell = { id: number; wing_id: number; prison_id: number; cell_no: string; capacity: number; coords: Coords; door_id?: number | null; label: string };
export type EDoor = { id: number; prison_id: number; wing_id?: number | null; label: string; kind: string; model: number; coords: Coords; pair?: { model: number; coords: Coords } | null; access_level: number; default_locked: boolean };
export type EZone = { id: number; prison_id: number; type: string; label: string; coords: Coords; radius: number; data?: { job?: string; exercise?: string; cam?: { x: number; y: number; z: number; rx: number; rz: number; fov: number } } };
export type Estate = {
  prisons: EPrison[]; wings: EWing[]; cells: ECell[]; doors: EDoor[]; zones: EZone[];
  zoneTypes: string[]; wingTypes: string[]; doorKinds: string[]; categories: string[];
  jobs?: { key: string; label: string }[]; exercises?: { key: string; label: string }[];
  modules?: Record<string, boolean>;
};

export type PunishmentDef = { enabled: boolean; maxHours?: number; maxMinutes?: number; maxPercent?: number; node?: string };
export type TabletConfig = {
  currency?: string;
  iep?: { levels: string[]; labels: Record<string, string>; maxPoints: number };
  discipline?: { charges: { code: string; text: string }[]; punishments: Record<string, PunishmentDef>; segMax: number };
  regime?: { clock: string };
  jobs?: { key: string; label: string }[];
  intel?: { categories: string[] };
  incidents?: { types: { key: string; label: string }[] };
  cctv?: boolean;
  visits?: boolean;
  gangs?: boolean;
  healthcare?: { categories: string[]; rounds: string[]; intervals: number[] };
  transport?: { destinations: { id: string; label: string; kind: string }[] };
  parole?: { conditions: string[]; passScore: number };
};
