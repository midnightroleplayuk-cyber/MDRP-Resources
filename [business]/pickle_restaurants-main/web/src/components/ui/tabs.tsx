import * as React from "react";
import { cn } from "@/lib/utils";

type TabsCtx = { value: string; setValue: (v: string) => void };
const Ctx = React.createContext<TabsCtx | null>(null);

export function Tabs({
  value,
  onValueChange,
  defaultValue,
  className,
  children,
}: {
  value?: string;
  onValueChange?: (v: string) => void;
  defaultValue?: string;
  className?: string;
  children: React.ReactNode;
}) {
  const [internal, setInternal] = React.useState(defaultValue || "");
  const val = value ?? internal;
  const setValue = (v: string) => {
    setInternal(v);
    onValueChange?.(v);
  };
  return (
    <Ctx.Provider value={{ value: val, setValue }}>
      <div className={className}>{children}</div>
    </Ctx.Provider>
  );
}

// Underlined tab rail — labels sit on a shared baseline rule, the active one
// carries a brand underline (an order-ticket rail rather than pill chips).
export function TabsList({ className, children }: { className?: string; children: React.ReactNode }) {
  return (
    <div className={cn("flex items-end gap-1 border-b border-border/80", className)}>
      {children}
    </div>
  );
}

export function TabsTrigger({ value, children }: { value: string; children: React.ReactNode }) {
  const ctx = React.useContext(Ctx)!;
  const active = ctx.value === value;
  return (
    <button
      onClick={() => ctx.setValue(value)}
      className={cn(
        "relative -mb-px inline-flex items-center justify-center gap-1.5 whitespace-nowrap rounded-t-md px-3 pb-2 pt-1.5 text-sm font-medium transition-colors",
        active ? "text-foreground" : "text-muted-foreground hover:bg-accent/60 hover:text-foreground"
      )}
    >
      {children}
      <span
        className={cn(
          "pointer-events-none absolute inset-x-2 bottom-0 h-0.5 rounded-full transition-colors",
          active ? "bg-primary" : "bg-transparent"
        )}
      />
    </button>
  );
}

export function TabsContent({ value, className, children }: { value: string; className?: string; children: React.ReactNode }) {
  const ctx = React.useContext(Ctx)!;
  if (ctx.value !== value) return null;
  return <div className={cn("mt-3 animate-fade-in", className)}>{children}</div>;
}
