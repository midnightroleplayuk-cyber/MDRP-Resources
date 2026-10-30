import { useEffect, useMemo, useRef, useState } from "react";
import { cn } from "@/lib/utils";
import { _L } from "@/lib/locale";
import { Truncate } from "@/components/ui/truncate";
import Thumb from "@/components/Thumb";
import { Check, ChevronsUpDown, Search, TriangleAlert } from "lucide-react";

export type Item = { name: string; label: string; image?: string };

/**
 * Searchable item selector. Instead of typing a raw codename, the user picks
 * from the server's live item catalogue. If `value` is set to something that
 * isn't in the catalogue the control renders in an error state so it's obvious
 * what needs fixing.
 *
 * `allowFree`: a value outside the catalogue is a legitimate KITCHEN item
 * (a tray-only intermediate like `raw_pizza`) — render it neutrally instead of
 * as a missing-item error, and let free text from the search box be committed.
 */
export default function ItemPicker({
  items,
  value,
  onChange,
  placeholder = _L("itempicker.select_placeholder"),
  className,
  allowEmpty = false,
  allowFree = false,
}: {
  items: Item[];
  value: string;
  onChange: (name: string) => void;
  placeholder?: string;
  className?: string;
  allowEmpty?: boolean;
  allowFree?: boolean;
}) {
  const [open, setOpen] = useState(false);
  const [query, setQuery] = useState("");
  const rootRef = useRef<HTMLDivElement>(null);
  const inputRef = useRef<HTMLInputElement>(null);

  const selected = useMemo(() => items.find((i) => i.name === value), [items, value]);
  const free = !!value && !selected && allowFree; // a kitchen-only (non-inventory) item
  const missing = !!value && !selected && !allowFree;

  const filtered = useMemo(() => {
    const q = query.trim().toLowerCase();
    const list = q
      ? items.filter((i) => i.label.toLowerCase().includes(q) || i.name.toLowerCase().includes(q))
      : items;
    return list.slice(0, 80);
  }, [items, query]);

  useEffect(() => {
    if (!open) return;
    const onDown = (e: MouseEvent) => {
      if (rootRef.current && !rootRef.current.contains(e.target as Node)) setOpen(false);
    };
    window.addEventListener("mousedown", onDown);
    inputRef.current?.focus();
    return () => window.removeEventListener("mousedown", onDown);
  }, [open]);

  return (
    <div ref={rootRef} className={cn("relative", className)}>
      <button
        type="button"
        onClick={() => setOpen((o) => !o)}
        className={cn(
          "flex h-9 w-full items-center justify-between gap-2 rounded-md border bg-muted/50 px-3 text-left text-sm transition-colors focus-visible:border-primary/60 focus-visible:outline-none",
          missing ? "border-destructive text-destructive" : "border-input"
        )}
      >
        <span className="flex min-w-0 items-center gap-1.5 truncate">
          {missing && <TriangleAlert className="h-3.5 w-3.5 shrink-0" />}
          {/* the picked item's own picture, so a filled field is identifiable without
              reading it — a codename and a label look alike, the art doesn't */}
          {selected && <Thumb src={selected.image} alt={selected.label} className="h-5 w-5 shrink-0" />}
          {selected ? (
            <Truncate>{selected.label}</Truncate>
          ) : value ? (
            <Truncate className="font-mono text-xs">{value}</Truncate>
          ) : (
            <span className="text-muted-foreground">{placeholder}</span>
          )}
          {free && (
            <span className="shrink-0 rounded border border-border bg-secondary px-1 py-px text-[9px] font-semibold uppercase tracking-wide text-muted-foreground">
              {_L("itempicker.kitchen_item")}
            </span>
          )}
        </span>
        <ChevronsUpDown className="h-3.5 w-3.5 shrink-0 opacity-50" />
      </button>

      {open && (
        <div className="absolute z-50 mt-1 w-full overflow-hidden rounded-md border border-border bg-popover shadow-xl">
          <div className="flex items-center gap-2 border-b border-border px-2.5">
            <Search className="h-3.5 w-3.5 text-muted-foreground" />
            <input
              ref={inputRef}
              value={query}
              onChange={(e) => setQuery(e.target.value)}
              placeholder={_L("itempicker.search_placeholder")}
              className="h-9 w-full bg-transparent text-sm outline-none placeholder:text-muted-foreground"
            />
          </div>
          <div className="max-h-56 overflow-y-auto py-1">
            {allowEmpty && (
              <Option
                label={_L("itempicker.none")}
                sub=""
                hasImage={false}
                active={!value}
                onClick={() => { onChange(""); setOpen(false); setQuery(""); }}
              />
            )}
            {/* free-text commit: use whatever was typed as a kitchen-only codename */}
            {allowFree && query.trim() && !items.some((i) => i.name === query.trim()) && (
              <Option
                label={_L("itempicker.free_use", query.trim())}
                sub={_L("itempicker.kitchen_item")}
                hasImage={false}
                active={query.trim() === value}
                onClick={() => { onChange(query.trim()); setOpen(false); setQuery(""); }}
              />
            )}
            {filtered.length === 0 && !(allowFree && query.trim()) && (
              <div className="px-3 py-3 text-center text-xs text-muted-foreground">{_L("itempicker.no_match", query)}</div>
            )}
            {filtered.map((i) => (
              <Option
                key={i.name}
                label={i.label}
                sub={i.name}
                image={i.image}
                active={i.name === value}
                onClick={() => { onChange(i.name); setOpen(false); setQuery(""); }}
              />
            ))}
          </div>
        </div>
      )}
    </div>
  );
}

// A catalogue row. `image` is absent for the synthetic rows (None / free-text
// commit), which have no item behind them — those keep the plain text layout, with
// the thumbnail's width reserved so the list stays aligned.
function Option({ label, sub, image, hasImage, active, onClick }: {
  label: string; sub: string; image?: string; hasImage?: boolean; active: boolean; onClick: () => void;
}) {
  return (
    <button
      type="button"
      onClick={onClick}
      className={cn(
        "flex w-full items-center gap-2 px-3 py-1.5 text-left text-sm hover:bg-accent",
        active && "bg-accent/60"
      )}
    >
      {hasImage !== false && <Thumb src={image} alt={label} className="h-7 w-7 shrink-0" />}
      <span className="flex min-w-0 flex-1 flex-col">
        <Truncate>{label}</Truncate>
        {sub && <Truncate className="font-mono text-[10px] text-muted-foreground">{sub}</Truncate>}
      </span>
      {active && <Check className="h-3.5 w-3.5 shrink-0 text-primary" />}
    </button>
  );
}
