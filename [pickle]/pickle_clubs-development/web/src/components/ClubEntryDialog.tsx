import { useState, useEffect, useCallback } from "react";
import { useNuiEvent } from "../providers/nui/useNui";
import { fetchNui } from "../providers/nui/fetchNui";

interface EntryDialogData {
  clubId: number;
  clubName: string;
  entryPrice: number;
  vipPrice: number;
  vipEnabled: boolean;
  hasPass: boolean;
  hasVip: boolean;
  speech: string;
  currency: string;
  countryCode: string;
}

const formatCurrency = (value: number, currency: string, countryCode: string): string =>
  value.toLocaleString(countryCode || "en-US", {
    style: "currency",
    currency: currency || "USD",
    minimumFractionDigits: 0,
    maximumFractionDigits: 0,
  });

export const ClubEntryDialog = () => {
  const [data, setData] = useState<EntryDialogData | null>(null);
  const [visible, setVisible] = useState(false);
  const [animating, setAnimating] = useState(false);
  const [feedback, setFeedback] = useState<string | null>(null);

  useNuiEvent("openClubEntryDialog", (message: { data: EntryDialogData }) => {
    setData(message.data);
    setFeedback(null);
    setAnimating(true);
    requestAnimationFrame(() => {
      requestAnimationFrame(() => setVisible(true));
    });
  });

  useNuiEvent("closeClubEntryDialog", () => {
    slideOut();
  });

  const slideOut = () => {
    setVisible(false);
    setTimeout(() => {
      setData(null);
      setAnimating(false);
      setFeedback(null);
    }, 300);
  };

  const handleClose = useCallback(() => {
    slideOut();
    fetchNui("closeClubEntryDialog");
  }, []);

  const handlePay = async (passType: "standard" | "vip") => {
    const result = await fetchNui<{ success: boolean; message?: string }>("payClubEntry", {
      clubId: data?.clubId,
      passType,
    });
    if (result?.success) {
      setFeedback(passType === "vip" ? "Welcome VIP! Enjoy the club!" : "Thanks! Enjoy the club!");
      setTimeout(() => {
        slideOut();
        fetchNui("closeClubEntryDialog");
      }, 1500);
    } else {
      setFeedback(result?.message || "Payment failed");
      setTimeout(() => setFeedback(null), 2000);
    }
  };

  const handleDecline = () => {
    handleClose();
  };

  useEffect(() => {
    if (!data) return;
    const onKeyDown = (e: KeyboardEvent) => {
      if (e.key === "Escape") handleClose();
    };
    window.addEventListener("keydown", onKeyDown);
    return () => window.removeEventListener("keydown", onKeyDown);
  }, [data, handleClose]);

  if (!data && !animating) return null;

  const currency = data?.currency || "USD";
  const countryCode = data?.countryCode || "en-US";

  return (
    <div
      className="fixed bottom-0 left-0 w-full z-50 pointer-events-auto"
      style={{
        transform: visible ? "translateY(0)" : "translateY(100%)",
        transition: "transform 0.3s ease-in-out",
      }}
    >
      <div className="bg-background/95 border-t border-border shadow-2xl">
        <div className="max-w-3xl mx-auto p-6">
          {/* Speech bubble */}
          <div className="mb-5">
            <div className="text-xs uppercase tracking-wide text-muted-foreground mb-1">
              {data?.clubName || "Bouncer"}
            </div>
            <div className="text-lg text-primary font-medium">
              {feedback || data?.speech || "Welcome to the club."}
            </div>
          </div>

          {/* Actions */}
          {!feedback && data && (
            <div className="flex flex-wrap gap-3">
              {/* Standard entry */}
              {!data.hasPass && (
                <button
                  onClick={() => handlePay("standard")}
                  className="flex-1 min-w-[200px] rounded-lg border border-border bg-secondary/40 hover:bg-secondary/70 p-4 text-left transition-colors"
                >
                  <div className="font-semibold text-sm text-primary">
                    Buy Entry: {formatCurrency(data.entryPrice, currency, countryCode)}
                  </div>
                  <div className="text-xs text-muted-foreground mt-0.5">
                    Grants access into the club.
                  </div>
                </button>
              )}

              {/* VIP upgrade */}
              {data.vipEnabled && !data.hasVip && (
                <button
                  onClick={() => handlePay("vip")}
                  className="flex-1 min-w-[200px] rounded-lg border border-yellow-500/50 bg-yellow-500/10 hover:bg-yellow-500/20 p-4 text-left transition-colors"
                >
                  <div className="font-semibold text-sm text-yellow-400">
                    Buy VIP Pass: {formatCurrency(data.vipPrice, currency, countryCode)}
                  </div>
                  <div className="text-xs text-muted-foreground mt-0.5">
                    Grants access into the club and exclusive VIP areas.
                  </div>
                </button>
              )}

              {/* Decline */}
              <button
                onClick={handleDecline}
                className="flex-1 min-w-[200px] rounded-lg border border-border bg-secondary/20 hover:bg-secondary/40 p-4 text-left transition-colors"
              >
                <div className="font-semibold text-sm text-muted-foreground">Leave</div>
                <div className="text-xs text-muted-foreground mt-0.5">Walk away</div>
              </button>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};
