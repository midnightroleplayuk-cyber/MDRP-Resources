import * as React from "react";
import { cn } from "@/lib/utils";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Check, X } from "lucide-react";
import { _L } from "@/lib/locale";

/** Labelled field wrapper — keeps every control aligned and consistently spaced. */
export function Field({
  label,
  hint,
  className,
  children,
}: {
  label: string;
  hint?: string;
  className?: string;
  children: React.ReactNode;
}) {
  // Intentionally a div (not a <label>): some children are comboboxes built
  // from <button>s, and wrapping those in a <label> hijacks their clicks.
  return (
    <div className={cn("block", className)}>
      <span className="tape mb-1 block">{label}</span>
      {children}
      {hint && <span className="mt-1 block text-[11px] text-muted-foreground">{hint}</span>}
    </div>
  );
}

export function TextField({
  label, hint, value, onChange, placeholder, className,
}: {
  label: string; hint?: string; value: string; onChange: (v: string) => void; placeholder?: string; className?: string;
}) {
  return (
    <Field label={label} hint={hint} className={className}>
      <Input value={value ?? ""} placeholder={placeholder} onChange={(e) => onChange(e.target.value)} />
    </Field>
  );
}

export function NumberField({
  label, hint, value, onChange, min, step, className,
}: {
  label: string; hint?: string; value: number; onChange: (v: number) => void; min?: number; step?: number; className?: string;
}) {
  return (
    <Field label={label} hint={hint} className={className}>
      <Input
        type="number"
        min={min}
        step={step}
        value={Number.isFinite(value) ? value : 0}
        onChange={(e) => onChange(Number(e.target.value))}
      />
    </Field>
  );
}

/** Small accessible toggle switch. */
export function Toggle({
  checked, onChange, label,
}: {
  checked: boolean; onChange: (v: boolean) => void; label?: string;
}) {
  return (
    <button
      type="button"
      onClick={() => onChange(!checked)}
      className="flex items-center gap-2 text-sm"
    >
      <span
        className={cn(
          "relative inline-flex h-5 w-9 shrink-0 items-center rounded-full border transition-colors",
          checked ? "border-primary/50 bg-primary" : "border-border bg-muted"
        )}
      >
        <span
          className={cn(
            "inline-block h-3.5 w-3.5 transform rounded-full shadow transition-transform",
            checked ? "translate-x-[18px] bg-[rgb(var(--brand-ink))]" : "translate-x-1 bg-[rgb(var(--ink-mute))]"
          )}
        />
      </span>
      {label && <span>{label}</span>}
    </button>
  );
}

/**
 * Access-group dropdown, reused across every food editor so groups are shared.
 * Lists "All restaurants" (blank = available everywhere), every group already in
 * use, plus an "Add new group…" option that reveals an inline input. A freshly
 * typed group is selected immediately and joins the suggestions on the next
 * refresh (groups exist by being used, not managed).
 */
const ADD_NEW = "__add_new__";
export function GroupField({
  label, hint, value, onChange, groups, className,
}: {
  label: string; hint?: string; value: string; onChange: (v: string) => void; groups: string[]; className?: string;
}) {
  const [adding, setAdding] = React.useState(false);
  const [draft, setDraft] = React.useState("");

  // the currently-selected group is always offered even if it isn't (yet) in the
  // shared suggestion list (e.g. just-typed, or the only user of that group)
  const options = React.useMemo(() => {
    const set = new Set(groups.filter(Boolean));
    if (value) set.add(value);
    return Array.from(set).sort((a, b) => a.localeCompare(b));
  }, [groups, value]);

  const commit = () => {
    const v = draft.trim();
    if (v) onChange(v);
    setAdding(false);
    setDraft("");
  };

  if (adding) {
    return (
      <Field label={label} hint={hint} className={className}>
        <div className="flex items-center gap-2">
          <Input
            autoFocus
            value={draft}
            placeholder={_L("group.new_placeholder")}
            onChange={(e) => setDraft(e.target.value)}
            onKeyDown={(e) => {
              if (e.key === "Enter") { e.preventDefault(); commit(); }
              if (e.key === "Escape") { setAdding(false); setDraft(""); }
            }}
          />
          <Button size="icon" variant="outline" onClick={commit}><Check className="h-4 w-4" /></Button>
          <Button size="icon" variant="ghost" onClick={() => { setAdding(false); setDraft(""); }}><X className="h-4 w-4" /></Button>
        </div>
      </Field>
    );
  }

  return (
    <Field label={label} hint={hint} className={className}>
      <select
        value={value || ""}
        onChange={(e) => {
          const v = e.target.value;
          if (v === ADD_NEW) { setDraft(""); setAdding(true); }
          else onChange(v);
        }}
        className="h-9 w-full rounded-md border border-input bg-muted/50 px-2 text-sm transition-colors focus-visible:border-primary/60 focus-visible:outline-none"
      >
        <option value="">{_L("group.all")}</option>
        {options.map((g) => (
          <option key={g} value={g}>{g}</option>
        ))}
        <option value={ADD_NEW}>{_L("group.add_new")}</option>
      </select>
    </Field>
  );
}

export function Select({
  label, hint, value, onChange, options, className,
}: {
  label: string; hint?: string; value: string; onChange: (v: string) => void;
  options: { value: string; label: string }[]; className?: string;
}) {
  return (
    <Field label={label} hint={hint} className={className}>
      <select
        value={value}
        onChange={(e) => onChange(e.target.value)}
        className="h-9 w-full rounded-md border border-input bg-muted/50 px-2 text-sm transition-colors focus-visible:border-primary/60 focus-visible:outline-none"
      >
        {options.map((o) => (
          <option key={o.value} value={o.value}>{o.label}</option>
        ))}
      </select>
    </Field>
  );
}
