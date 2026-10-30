import { useEffect, useRef, useState } from "react";
import { Send, MessageCircle } from "lucide-react";
import { fetchNui, useNuiEvent } from "../lib/nui";
import { cn } from "../lib/utils";
import { _L } from "../lib/locale";
import { Sheet } from "./ui";

// ─── delivery chat ────────────────────────────────────────────────────────────
// One thread per in-progress delivery, shared by the customer (Orders tracking) and
// the driver holding the run (Work ticket sheet). Both sides render the SAME sheet —
// the server tells each caller which side it is, and "mine" is decided by that role
// rather than by name, so two players with the same character name can't blur.
//
// The thread is server-transient (it dies with the ticket), so there's no history to
// page and no read receipts to sync: seed once on open, then append off the push.

export type ChatMsg = { role: "customer" | "driver"; name?: string; text: string; at?: number };

function timeOf(at?: number) {
  if (!at) return "";
  const d = new Date(at * 1000);
  return `${d.getHours()}:${String(d.getMinutes()).padStart(2, "0")}`;
}

export function ChatSheet({
  rid,
  orderId,
  title,
  onClose,
}: {
  rid: number;
  orderId: number;
  title: string;
  onClose: () => void;
}) {
  const [msgs, setMsgs] = useState<ChatMsg[]>([]);
  const [role, setRole] = useState<"customer" | "driver" | null>(null);
  const [text, setText] = useState("");
  const [err, setErr] = useState<string | null>(null);
  const [sending, setSending] = useState(false);
  const endRef = useRef<HTMLDivElement | null>(null);

  useEffect(() => {
    fetchNui("phone:chatHistory", { id: rid, orderId }).then((d) => {
      if (d?.ok) {
        setMsgs(d.messages || []);
        setRole(d.role || null);
      } else setErr(d?.error || _L("phone.chat.unavailable"));
    });
  }, [rid, orderId]);

  // Every message — including our own — arrives via this push, so there's exactly one
  // path that appends to the thread and no optimistic echo to reconcile.
  useNuiEvent("chat", (d) => {
    if (d.orderId !== orderId || !d.message) return;
    setMsgs((m) => [...m, d.message]);
  });

  // Pin to the newest message on open and on every arrival.
  useEffect(() => {
    endRef.current?.scrollIntoView({ block: "end" });
  }, [msgs.length]);

  const send = async () => {
    const body = text.trim();
    if (!body || sending) return;
    setSending(true);
    const res = await fetchNui("phone:chatSend", { id: rid, orderId, text: body });
    setSending(false);
    if (res?.ok) {
      setText("");
      setErr(null);
    } else setErr(res?.error || _L("phone.chat.send_failed"));
  };

  return (
    <Sheet onClose={onClose}>
      <>
        <div className="pf-grab" />
        <div className="flex items-center gap-2 px-4 pb-2 pt-1">
          <span className="grid h-9 w-9 place-items-center rounded-full bg-muted">
            <MessageCircle className="h-4 w-4" />
          </span>
          <div className="min-w-0 flex-1">
            <div className="font-display font-extrabold leading-tight">{title}</div>
            <div className="text-[0.68rem] text-muted-foreground">
              {role === "driver" ? _L("phone.chat.with_customer") : _L("phone.chat.with_driver")}
            </div>
          </div>
        </div>

        <div className="min-h-0 flex-1 space-y-2 overflow-y-auto px-4 py-2">
          {msgs.length === 0 && !err && (
            <p className="py-6 text-center text-[0.76rem] text-muted-foreground">
              {role === "driver"
                ? _L("phone.chat.empty_driver")
                : _L("phone.chat.empty_customer")}
            </p>
          )}
          {msgs.map((m, i) => {
            const mine = role != null && m.role === role;
            return (
              <div key={i} className={cn("flex", mine ? "justify-end" : "justify-start")}>
                <div
                  className={cn(
                    "max-w-[80%] rounded-2xl px-3 py-2 text-sm",
                    mine ? "bg-brand text-brand-ink" : "bg-muted"
                  )}
                >
                  {!mine && m.name && (
                    <div className="text-[0.62rem] font-bold uppercase tracking-wide opacity-70">{m.name}</div>
                  )}
                  <div className="whitespace-pre-wrap break-words">{m.text}</div>
                  {m.at && (
                    <div className={cn("mt-0.5 text-right font-mono text-[0.58rem]", mine ? "opacity-70" : "text-muted-foreground")}>
                      {timeOf(m.at)}
                    </div>
                  )}
                </div>
              </div>
            );
          })}
          <div ref={endRef} />
        </div>

        {err && <div className="px-4 pb-1 text-[0.7rem] text-destructive">{err}</div>}

        <div
          className="flex items-center gap-2 border-t border-border p-3"
          style={{ paddingBottom: "calc(0.75rem + var(--pf-bottom))" }}
        >
          <input
            value={text}
            onChange={(e) => setText(e.target.value)}
            onKeyDown={(e) => {
              if (e.key === "Enter") send();
            }}
            maxLength={200}
            placeholder={_L("phone.chat.placeholder")}
            className="min-w-0 flex-1 rounded-full border border-border bg-card px-4 py-2.5 text-sm outline-none placeholder:text-muted-foreground"
          />
          <button
            onClick={send}
            disabled={!text.trim() || sending}
            aria-label={_L("phone.chat.send")}
            className="grid h-11 w-11 shrink-0 place-items-center rounded-full bg-brand text-brand-ink disabled:opacity-40"
          >
            <Send className="h-4 w-4" />
          </button>
        </div>
      </>
    </Sheet>
  );
}

// The button both screens use to open the thread, with an unread dot. Unread is
// tracked by the CALLER (it owns whether the sheet is open), so this stays dumb.
export function ChatButton({
  unread,
  onClick,
  className,
  label,
}: {
  unread?: boolean;
  onClick: () => void;
  className?: string;
  label?: string;
}) {
  return (
    <button
      onClick={onClick}
      className={cn(
        "relative flex items-center justify-center gap-1.5 rounded-full bg-muted px-3 py-2.5 text-sm font-bold",
        className
      )}
    >
      <MessageCircle className="h-4 w-4" /> {label ?? _L("phone.chat.button")}
      {unread && <span className="absolute right-2 top-2 h-2 w-2 rounded-full bg-brand" />}
    </button>
  );
}

// The kitchen queue shows MANY tickets at once, so it needs unread tracked per order
// rather than as a single flag. `openId` is whichever thread is on screen — messages
// for it are read by definition, and opening a thread clears its dot.
export function useChatUnreadSet(openId: number | null) {
  const [ids, setIds] = useState<Set<number>>(new Set());
  useNuiEvent("chat", (d) => {
    if (d.orderId == null || d.orderId === openId) return;
    setIds((s) => (s.has(d.orderId) ? s : new Set(s).add(d.orderId)));
  });
  useEffect(() => {
    if (openId == null) return;
    setIds((s) => {
      if (!s.has(openId)) return s;
      const n = new Set(s);
      n.delete(openId);
      return n;
    });
  }, [openId]);
  return ids;
}

// Counts messages arriving for `orderId` while the sheet is CLOSED, so both screens
// get an unread dot without each re-implementing the listener.
export function useChatUnread(orderId: number | null, open: boolean) {
  const [unread, setUnread] = useState(false);
  useNuiEvent("chat", (d) => {
    if (orderId == null || d.orderId !== orderId) return;
    if (!open) setUnread(true);
  });
  useEffect(() => {
    if (open) setUnread(false);
  }, [open]);
  return unread;
}
