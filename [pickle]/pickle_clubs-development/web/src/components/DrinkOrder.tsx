import { useState, useEffect, useCallback } from "react";
import { useNuiEvent } from "../providers/nui/useNui";
import { fetchNui } from "../providers/nui/fetchNui";

interface FlavorDetail {
  key: string;
  label: string;
  color: [number, number, number];
}

interface DrinkOption {
  drinkKey: string;
  name: string;
  price: number;
  flavors: FlavorDetail[];
  alcoholPct: number;
  alcoholLabel: string;
}

interface DrinkOrderData {
  stationId: string;
  drinks: DrinkOption[];
  currency: string;
  countryCode: string;
}

const rgbToHex = (r: number, g: number, b: number): string =>
  `#${[r, g, b].map((v) => v.toString(16).padStart(2, "0")).join("")}`;

const isLight = (r: number, g: number, b: number): boolean =>
  0.299 * r + 0.587 * g + 0.114 * b > 160;

const formatPrice = (price: number, currency: string, countryCode: string): string => {
  return price.toLocaleString(countryCode || "en-US", {
    style: "currency",
    currency: currency || "USD",
    minimumFractionDigits: 0,
    maximumFractionDigits: 0,
  });
};

export const DrinkOrder = () => {
  const [data, setData] = useState<DrinkOrderData | null>(null);
  const [visible, setVisible] = useState(false);
  const [animating, setAnimating] = useState(false);

  useNuiEvent("openDrinkOrder", (message: { data: DrinkOrderData }) => {
    setData(message.data);
    setAnimating(true);
    requestAnimationFrame(() => {
      requestAnimationFrame(() => {
        setVisible(true);
      });
    });
  });

  useNuiEvent("closeDrinkOrder", () => {
    slideOut();
  });

  const slideOut = () => {
    setVisible(false);
    setTimeout(() => {
      setData(null);
      setAnimating(false);
    }, 300);
  };

  const handleClose = useCallback(() => {
    slideOut();
    fetchNui("closeDrinkOrder");
  }, []);

  const handleOrder = (drinkKey: string) => {
    fetchNui("orderDrink", { stationId: data?.stationId, drinkKey });
    handleClose();
  };

  useEffect(() => {
    if (!data) return;
    const onKeyDown = (e: KeyboardEvent) => {
      if (e.key === "Escape") {
        handleClose();
      }
    };
    window.addEventListener("keydown", onKeyDown);
    return () => window.removeEventListener("keydown", onKeyDown);
  }, [data, handleClose]);

  if (!data && !animating) return null;

  return (
    <div
      className="fixed top-0 right-0 h-full w-[320px] z-50 pointer-events-auto"
      style={{
        transform: visible ? "translateX(0)" : "translateX(100%)",
        transition: "transform 0.3s ease-in-out",
      }}
    >
      <div className="h-full bg-background/95 border-l border-border flex flex-col shadow-2xl">
        {/* Header */}
        <div className="flex items-center justify-between p-4 border-b border-border">
          <h2 className="text-lg font-bold text-primary">Order a Drink</h2>
          <button
            onClick={handleClose}
            className="text-muted-foreground hover:text-primary text-xl leading-none px-1"
          >
            x
          </button>
        </div>

        {/* Drink List */}
        <div className="flex-1 overflow-y-auto p-3 space-y-2">
          {data && data.drinks.length === 0 && (
            <div className="text-sm text-muted-foreground text-center py-8">
              No drinks available
            </div>
          )}
          {data && data.drinks.map((drink) => (
            <button
              key={drink.drinkKey}
              onClick={() => handleOrder(drink.drinkKey)}
              className="w-full text-left bg-secondary/30 border border-border rounded-lg p-3 hover:bg-secondary/60 transition-colors cursor-pointer"
            >
              {/* Name + Price */}
              <div className="flex items-center justify-between mb-2">
                <span className="font-semibold text-primary text-sm">
                  {drink.name}
                </span>
                {drink.price > 0 && (
                  <span className="text-xs font-bold text-foreground">
                    {formatPrice(drink.price, data.currency, data.countryCode)}
                  </span>
                )}
                {drink.price === 0 && (
                  <span className="text-xs font-bold text-green-400">Free</span>
                )}
              </div>

              {/* Flavors */}
              {drink.flavors.length > 0 && (
                <div className="mb-2">
                  <div className="flex flex-wrap gap-1">
                    {drink.flavors.map((f) => {
                      const hex = rgbToHex(...f.color);
                      const textColor = isLight(...f.color) ? "#111" : "#fff";
                      return (
                        <span
                          key={f.key}
                          className="px-2 py-0.5 rounded-full text-[10px] font-semibold"
                          style={{ backgroundColor: hex, color: textColor }}
                        >
                          {f.label}
                        </span>
                      );
                    })}
                  </div>
                </div>
              )}

              {/* Alcohol */}
              {drink.alcoholPct > 0 && (
                <div className="flex items-center justify-between">
                  <span className="text-[10px] uppercase tracking-wide text-muted-foreground">
                    {drink.alcoholLabel}
                  </span>
                  <span className="text-xs font-bold text-foreground">
                    {drink.alcoholPct}%
                  </span>
                </div>
              )}
            </button>
          ))}
        </div>
      </div>
    </div>
  );
};
