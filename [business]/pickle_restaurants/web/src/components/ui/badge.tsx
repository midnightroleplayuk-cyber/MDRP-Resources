import * as React from "react";
import { cn } from "@/lib/utils";

// Register-tape stamp: mono, uppercase, square-ish. Counts, ticket numbers and
// status tags all read as machine-printed labels.
export function Badge({
  className,
  variant = "default",
  ...props
}: React.HTMLAttributes<HTMLDivElement> & { variant?: "default" | "secondary" | "outline" | "destructive" }) {
  const variants: Record<string, string> = {
    default: "bg-primary/15 text-primary border-primary/30",
    secondary: "bg-secondary text-secondary-foreground border-transparent",
    outline: "text-foreground border-border",
    destructive: "bg-destructive/15 text-destructive border-destructive/30",
  };
  return (
    <div
      className={cn(
        "inline-flex items-center rounded-sm border px-1.5 py-0.5 font-mono text-[10px] font-semibold uppercase tracking-wider tabular-nums",
        variants[variant],
        className
      )}
      {...props}
    />
  );
}
