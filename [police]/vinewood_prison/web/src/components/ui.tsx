import { ReactNode, useState } from 'react';
import { errorText } from '../lib/format';

export function Frame({ title, service, subtitle, nav, onClose, children, wide, flush, embedded }: {
  title: string; service: string; subtitle?: string; nav?: ReactNode; onClose: () => void; children: ReactNode; wide?: boolean; flush?: boolean; embedded?: boolean;
}) {
  return (
    <section className={`frame${wide ? ' frame--wide' : ''}${embedded ? ' frame--embedded' : ''}`} role="dialog" aria-label={title}>
      <header className="masthead">
        <div className="masthead__brand">
          <span className="masthead__service">{service}</span>
          <span className="masthead__prison">{title}</span>
        </div>
        {subtitle && <span className="masthead__who">{subtitle}</span>}
        {!embedded && <button className="masthead__close" onClick={onClose}>Close</button>}
      </header>
      <div className="frame__body">
        {nav && <nav className="sidenav">{nav}</nav>}
        <main className={`content${flush ? ' content--flush' : ''}`}>{children}</main>
      </div>
    </section>
  );
}

export function NavItem({ active, onClick, children, count }: { active: boolean; onClick: () => void; children: ReactNode; count?: number }) {
  return (
    <button className={`sidenav__item${active ? ' is-active' : ''}`} aria-current={active ? 'page' : undefined} onClick={onClick}>
      <span>{children}</span>
      {count != null && <span className="sidenav__count">{count}</span>}
    </button>
  );
}

type Variant = 'primary' | 'secondary' | 'warning' | 'link';
export function Button({ variant = 'primary', children, onClick, disabled, type = 'button', small }: {
  variant?: Variant; children: ReactNode; onClick?: () => void; disabled?: boolean; type?: 'button' | 'submit'; small?: boolean;
}) {
  return (
    <button type={type} className={`btn btn--${variant}${small ? ' btn--small' : ''}`} onClick={onClick} disabled={disabled}>
      {children}
    </button>
  );
}

// Two-step confirm for destructive actions
export function ConfirmButton({ children, confirmLabel, onConfirm, small, disabled }: {
  children: ReactNode; confirmLabel: string; onConfirm: () => void; small?: boolean; disabled?: boolean;
}) {
  const [armed, setArmed] = useState(false);
  if (!armed) {
    return small
      ? <button className="btn btn--danger-link btn--small" disabled={disabled} onClick={() => setArmed(true)}>{children}</button>
      : <Button variant="warning" disabled={disabled} onClick={() => setArmed(true)}>{children}</Button>;
  }
  return (
    <span className="confirm">
      <Button variant="warning" small={small} onClick={() => { setArmed(false); onConfirm(); }}>{confirmLabel}</Button>
      <Button variant="link" small={small} onClick={() => setArmed(false)}>Cancel</Button>
    </span>
  );
}

export function Tag({ tone = 'grey', children }: { tone?: 'grey' | 'blue' | 'green' | 'red' | 'yellow'; children: ReactNode }) {
  return <strong className={`tag tag--${tone}`}>{children}</strong>;
}

export function Field({ label, hint, children, id }: { label: string; hint?: string; children: ReactNode; id?: string }) {
  return (
    <div className="field">
      <label className="field__label" htmlFor={id}>{label}</label>
      {hint && <p className="field__hint">{hint}</p>}
      {children}
    </div>
  );
}

export function Summary({ rows }: { rows: [string, ReactNode][] }) {
  return (
    <dl className="summary">
      {rows.filter(([, v]) => v !== null && v !== undefined && v !== '').map(([k, v]) => (
        <div className="summary__row" key={k}>
          <dt>{k}</dt>
          <dd>{v}</dd>
        </div>
      ))}
    </dl>
  );
}

export function ErrorBanner({ code, onDismiss }: { code: string | null; onDismiss: () => void }) {
  if (!code) return null;
  return (
    <div className="error-banner" role="alert">
      <p>{errorText(code)}</p>
      <button className="error-banner__x" onClick={onDismiss} aria-label="Dismiss">Dismiss</button>
    </div>
  );
}

export function Empty({ children }: { children: ReactNode }) {
  return <p className="empty">{children}</p>;
}

export function statusTag(status: string) {
  switch (status) {
    case 'in_custody': return <Tag tone="blue">In custody</Tag>;
    case 'pending': return <Tag tone="yellow">Awaiting reception</Tag>;
    case 'release_pending': return <Tag tone="green">Due for release</Tag>;
    case 'ual': return <Tag tone="red">Unlawfully at large</Tag>;
    default: return <Tag>{status.replace(/_/g, ' ')}</Tag>;
  }
}
