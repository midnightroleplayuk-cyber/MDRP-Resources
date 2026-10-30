import * as React from "react";
import { cn } from "@/lib/utils";

export const Input = React.forwardRef<HTMLInputElement, React.InputHTMLAttributes<HTMLInputElement>>(
  ({ className, type, ...props }, ref) => (
    <input
      type={type}
      ref={ref}
      className={cn(
        "flex h-9 w-full rounded-md border border-input bg-muted/50 px-3 py-1 text-sm transition-colors placeholder:text-muted-foreground/70 focus-visible:border-primary/60 focus-visible:bg-muted/80 focus-visible:outline-none disabled:cursor-not-allowed disabled:opacity-50",
        // quantities and prices read as printed digits
        type === "number" && "font-mono text-[13px] tabular-nums",
        className
      )}
      {...props}
    />
  )
);
Input.displayName = "Input";
