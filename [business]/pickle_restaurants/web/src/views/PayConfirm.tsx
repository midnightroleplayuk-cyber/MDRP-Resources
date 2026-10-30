import { useEffect, useRef, useState } from "react";
import { fetchNui } from "@/lib/nui";
import { money, cn } from "@/lib/utils";
import { _L } from "@/lib/locale";
import { Check, X } from "lucide-react";
import { groupLines, arr, type Line } from "@/components/OrderBuilder";

// One "+cheese / no lettuce" caption for a line's mods.
const modText = (mods?: { label: string; removed?: boolean }[]) =>
  (mods || []).map((m) => _L(m.removed ? "payconfirm.mod_removed" : "payconfirm.mod_added", m.label)).join("  ·  ");

// The customer-facing charge prompt, printed as the restaurant's thermal
// receipt (perforated edges, mono body, the franchise theme rides the payload).
// The server awaits our answer; a 30s countdown auto-declines so the cashier's
// register can never hang. Answering once is enough — `answered` guards the
// double-fire when the countdown and a button race.
export default function PayConfirm({ data }: { data: any }) {
  const total: number = data?.total ?? 0;
  const lines: Line[] = arr<Line>(data?.lines);
  const [left, setLeft] = useState(30);
  const answered = useRef(false);

  const answer = (accept: boolean) => {
    if (answered.current) return;
    answered.current = true;
    fetchNui("sales:payChoice", { accept });
  };

  useEffect(() => {
    const t = window.setInterval(() => {
      setLeft((s) => {
        if (s <= 1) { answer(false); return 0; }
        return s - 1;
      });
    }, 1000);
    return () => window.clearInterval(t);
  }, []);

  return (
    <div className="fixed inset-0 flex items-center justify-center">
      <div className="w-full max-w-sm animate-print drop-shadow-2xl">
        <div className="tear-t" />
        <div className="receipt px-5 py-4">
          {/* header — printed like the top of a register tape */}
          <div className="text-center">
            <div className="font-display text-lg font-bold leading-tight tracking-tight">
              {data?.restaurant || ""}
            </div>
            <div className="mt-0.5 font-mono text-[10px] font-semibold uppercase tracking-[0.2em] text-muted-foreground">
              {_L("payconfirm.stamp")}
            </div>
            {data?.cashier && (
              <div className="mt-0.5 font-mono text-[10px] text-muted-foreground">
                {_L("payconfirm.from", data.cashier)}
              </div>
            )}
          </div>

          <div className="receipt-rule my-3" />

          {/* line items — mono, right-aligned prices */}
          <div className="space-y-1 font-mono text-xs">
            {groupLines(lines).map((b, i) => {
              if (b.type === "item") {
                const l = b.line;
                return (
                  <div key={i}>
                    <div className="flex items-start justify-between gap-2">
                      <span className="min-w-0">{l.qty}× {l.label}</span>
                      <span className="shrink-0 tabular-nums">{money(l.price * l.qty)}</span>
                    </div>
                    {l.mods && l.mods.length > 0 && (
                      <div className="pl-4 text-[10px] leading-snug text-muted-foreground">{modText(l.mods)}</div>
                    )}
                  </div>
                );
              }
              return null;
            })}
          </div>

          <div className="receipt-rule my-3" />

          <div className="flex items-center justify-between font-mono text-sm font-bold">
            <span className="uppercase tracking-widest">{_L("payconfirm.total")}</span>
            <span className="tabular-nums">{money(total)}</span>
          </div>

          {/* WHICH WALLET. The register can now charge cash or card, and approving a
              charge without being told which account it comes out of is approving the
              wrong thing half the time. */}
          <div className="mt-1 flex items-center justify-between font-mono text-[11px] uppercase tracking-widest text-muted-foreground">
            <span>{_L("register.payment")}</span>
            <span>{_L(data?.payment === "bank" ? "register.pay_card" : "register.pay_cash")}</span>
          </div>

          <div className="receipt-rule my-3" />

          {/* answer — the countdown prints like a register timer */}
          <div className="flex items-center gap-2">
            <span
              className={cn(
                "font-mono text-[11px] font-semibold tabular-nums",
                left <= 10 ? "text-destructive" : "text-muted-foreground"
              )}
            >
              {_L("payconfirm.expires", left)}
            </span>
            <div className="ml-auto flex gap-2">
              <button
                onClick={() => answer(false)}
                className="inline-flex items-center gap-1.5 rounded-md border border-border px-3 py-1.5 text-xs font-semibold text-foreground transition-colors hover:border-destructive hover:text-destructive"
              >
                <X className="h-3.5 w-3.5" /> {_L("payconfirm.decline")}
              </button>
              <button
                onClick={() => answer(true)}
                className="inline-flex items-center gap-1.5 rounded-md bg-primary px-3 py-1.5 text-xs font-semibold text-primary-foreground shadow-sm transition-colors hover:bg-[rgb(var(--brand-hover))]"
              >
                <Check className="h-3.5 w-3.5" /> {_L("payconfirm.accept", money(total))}
              </button>
            </div>
          </div>
        </div>
        <div className="tear-b" />
      </div>
    </div>
  );
}
