import { useState } from "react";
import { useNuiEvent } from "../providers/nui/useNui";

interface FlavorDetail {
  key: string;
  label: string;
  color: [number, number, number];
}

interface OrderDisplayData {
  orderName?: string;
  orderId?: string;
  flavors?: string[];
  flavorDetails?: FlavorDetail[];
  alcoholPct?: number;
  timeRemaining?: number;
  active: boolean;
  isPlayerOrder?: boolean;
  orderPlayerName?: string;
}

interface OrderDisplayMessage {
  type: string;
  data: OrderDisplayData;
}

const formatTime = (seconds: number): string => {
  const mins = Math.floor(seconds / 60);
  const secs = seconds % 60;
  return `${mins.toString().padStart(2, "0")}:${secs.toString().padStart(2, "0")}`;
};

const rgbToHex = (r: number, g: number, b: number): string =>
  `#${[r, g, b].map((v) => v.toString(16).padStart(2, "0")).join("")}`;

const isLight = (r: number, g: number, b: number): boolean =>
  0.299 * r + 0.587 * g + 0.114 * b > 160;

export const OrderDisplay = () => {
  const [orderData, setOrderData] = useState<OrderDisplayData | null>(null);

  useNuiEvent("updateOrderDisplay", (message: OrderDisplayMessage) => {
    const { data } = message;
    if (data.active) {
      setOrderData(data);
    } else {
      setOrderData(null);
    }
  });

  if (!orderData || !orderData.active) {
    return null;
  }

  const { orderName, flavorDetails, alcoholPct, timeRemaining, isPlayerOrder, orderPlayerName } =
    orderData;

  return (
    <div className="fixed top-1/2 -translate-y-1/2 right-[20px] pointer-events-none z-50">
      <div className="bg-background/95 border border-border rounded-lg p-4 min-w-[260px] shadow-lg flex flex-col gap-3">
        {/* Header */}
        <div>
          {isPlayerOrder && (
            <div className="text-xs font-medium text-muted-foreground mb-0.5">
              Player order{orderPlayerName ? ` — ${orderPlayerName}` : ""}
            </div>
          )}
          <div className="font-bold text-lg text-primary leading-tight">
            {orderName ?? "Unknown Order"}
          </div>
        </div>

        {/* Required flavors */}
        {flavorDetails && flavorDetails.length > 0 && (
          <div>
            <div className="text-xs font-semibold uppercase tracking-wide text-muted-foreground mb-1.5">
              Flavors
            </div>
            <div className="flex flex-wrap gap-1.5">
              {flavorDetails.map((f) => {
                const hex = rgbToHex(...f.color);
                const textColor = isLight(...f.color) ? "#111" : "#fff";
                return (
                  <span
                    key={f.key}
                    className="px-2.5 py-0.5 rounded-full text-xs font-semibold"
                    style={{ backgroundColor: hex, color: textColor }}
                  >
                    {f.label}
                  </span>
                );
              })}
            </div>
          </div>
        )}

        {/* Alcohol strength */}
        {alcoholPct !== undefined && (
          <div className="flex items-center justify-between">
            <span className="text-xs font-semibold uppercase tracking-wide text-muted-foreground">
              Alcohol
            </span>
            <span className="text-sm font-bold text-foreground">{alcoholPct}%</span>
          </div>
        )}

        {/* Timer */}
        {timeRemaining !== undefined && (
          <div className="text-sm text-muted-foreground border-t border-border pt-2">
            {formatTime(timeRemaining)} remaining
          </div>
        )}
      </div>
    </div>
  );
};
