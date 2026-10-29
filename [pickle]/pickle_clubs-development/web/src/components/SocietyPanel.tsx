import { useState, useEffect, useCallback } from "react";
import { useNuiEvent } from "../providers/nui/useNui";
import { fetchNui } from "../providers/nui/fetchNui";

interface Employee {
  source: number;
  name: string;
  grade: number;
  gradeLabel: string;
  online: boolean;
  isSelf?: boolean;
}

interface Grade {
  level: number;
  label: string;
}

interface SocietyData {
  clubId: number;
  clubName: string;
  balance: number;
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

export const SocietyPanel = () => {
  const [data, setData] = useState<SocietyData | null>(null);
  const [visible, setVisible] = useState(false);
  const [animating, setAnimating] = useState(false);
  const [tab, setTab] = useState<"banking" | "employees" | "pricing">("banking");
  const [balance, setBalance] = useState(0);
  const [amount, setAmount] = useState("");
  const [employees, setEmployees] = useState<Employee[]>([]);
  const [grades, setGrades] = useState<Grade[]>([]);
  const [loadingEmployees, setLoadingEmployees] = useState(false);
  const [entryPrice, setEntryPrice] = useState("");
  const [vipPrice, setVipPrice] = useState("");
  const [loadingPricing, setLoadingPricing] = useState(false);

  useNuiEvent("openSocietyPanel", (message: { data: SocietyData }) => {
    setData(message.data);
    setBalance(message.data.balance);
    setTab("banking");
    setAmount("");
    setAnimating(true);
    requestAnimationFrame(() => {
      requestAnimationFrame(() => setVisible(true));
    });
  });

  useNuiEvent("closeSocietyPanel", () => slideOut());

  useNuiEvent("updateSocietyBalance", (message: { balance: number }) => {
    setBalance(message.balance);
  });

  const slideOut = () => {
    setVisible(false);
    setTimeout(() => {
      setData(null);
      setAnimating(false);
      setEmployees([]);
      setGrades([]);
    }, 300);
  };

  const handleClose = useCallback(() => {
    slideOut();
    fetchNui("closeSocietyPanel");
  }, []);

  useEffect(() => {
    if (!data) return;
    const onKeyDown = (e: KeyboardEvent) => {
      if (e.key === "Escape") handleClose();
    };
    window.addEventListener("keydown", onKeyDown);
    return () => window.removeEventListener("keydown", onKeyDown);
  }, [data, handleClose]);

  const handleDeposit = () => {
    const val = parseInt(amount);
    if (!val || val <= 0) return;
    fetchNui("societyDeposit", { amount: val });
    setAmount("");
  };

  const handleWithdraw = () => {
    const val = parseInt(amount);
    if (!val || val <= 0) return;
    fetchNui("societyWithdraw", { amount: val });
    setAmount("");
  };

  const loadEmployees = async () => {
    if (!data) return;
    setLoadingEmployees(true);
    const [emps, gds] = await Promise.all([
      fetchNui<Employee[]>("getEmployees", { clubId: data.clubId }),
      fetchNui<Grade[]>("getJobGrades", { clubId: data.clubId }),
    ]);
    setEmployees(emps || []);
    setGrades(gds || []);
    setLoadingEmployees(false);
  };

  const handleSetGrade = async (targetSource: number, grade: number) => {
    if (!data) return;
    await fetchNui("setEmployeeGrade", { clubId: data.clubId, targetSource, grade });
    loadEmployees();
  };

  const handleFire = async (targetSource: number) => {
    if (!data) return;
    await fetchNui("fireEmployee", { clubId: data.clubId, targetSource });
    loadEmployees();
  };

  const handleHire = async (targetSource: number) => {
    if (!data) return;
    await fetchNui("hirePlayer", { clubId: data.clubId, targetSource });
    loadEmployees();
  };

  const loadPricing = async () => {
    if (!data) return;
    setLoadingPricing(true);
    const settings = await fetchNui<{ entryPrice?: number; vipPrice?: number }>("getEntrySettings", { clubId: data.clubId });
    setEntryPrice(settings?.entryPrice?.toString() || "");
    setVipPrice(settings?.vipPrice?.toString() || "");
    setLoadingPricing(false);
  };

  const savePricing = async () => {
    if (!data) return;
    const settings: Record<string, number> = {};
    if (entryPrice) settings.entryPrice = parseInt(entryPrice);
    if (vipPrice) settings.vipPrice = parseInt(vipPrice);
    await fetchNui("setEntrySettings", { clubId: data.clubId, settings });
  };

  const switchTab = (t: "banking" | "employees" | "pricing") => {
    setTab(t);
    if (t === "employees" && employees.length === 0) {
      loadEmployees();
    }
    if (t === "pricing") {
      loadPricing();
    }
  };

  if (!data && !animating) return null;

  const currency = data?.currency || "USD";
  const countryCode = data?.countryCode || "en-US";

  return (
    <div
      className="fixed top-0 right-0 h-full w-[360px] z-50 pointer-events-auto"
      style={{
        transform: visible ? "translateX(0)" : "translateX(100%)",
        transition: "transform 0.3s ease-in-out",
      }}
    >
      <div className="h-full bg-background/95 border-l border-border flex flex-col shadow-2xl">
        {/* Header */}
        <div className="flex items-center justify-between p-4 border-b border-border">
          <div>
            <h2 className="text-lg font-bold text-primary">Management</h2>
            {data && <div className="text-xs text-muted-foreground">{data.clubName}</div>}
          </div>
          <button onClick={handleClose} className="text-muted-foreground hover:text-primary text-xl leading-none px-1">
            x
          </button>
        </div>

        {/* Tabs */}
        <div className="flex border-b border-border">
          <button
            onClick={() => switchTab("banking")}
            className={`flex-1 py-2 text-sm font-semibold text-center transition-colors ${
              tab === "banking" ? "text-primary border-b-2 border-primary" : "text-muted-foreground hover:text-primary"
            }`}
          >
            Banking
          </button>
          <button
            onClick={() => switchTab("employees")}
            className={`flex-1 py-2 text-sm font-semibold text-center transition-colors ${
              tab === "employees" ? "text-primary border-b-2 border-primary" : "text-muted-foreground hover:text-primary"
            }`}
          >
            Employees
          </button>
          <button
            onClick={() => switchTab("pricing")}
            className={`flex-1 py-2 text-sm font-semibold text-center transition-colors ${
              tab === "pricing" ? "text-primary border-b-2 border-primary" : "text-muted-foreground hover:text-primary"
            }`}
          >
            Pricing
          </button>
        </div>

        {/* Content */}
        <div className="flex-1 overflow-y-auto p-4">
          {tab === "banking" && (
            <div className="space-y-4">
              {/* Balance */}
              <div className="bg-secondary/30 border border-border rounded-lg p-4 text-center">
                <div className="text-xs uppercase tracking-wide text-muted-foreground mb-1">Balance</div>
                <div className="text-2xl font-bold text-primary">{formatCurrency(balance, currency, countryCode)}</div>
              </div>

              {/* Amount Input */}
              <div>
                <input
                  type="number"
                  value={amount}
                  onChange={(e) => setAmount(e.target.value)}
                  placeholder="Enter amount..."
                  min="1"
                  className="w-full h-10 rounded-md border border-border bg-background px-3 text-sm text-foreground placeholder:text-muted-foreground"
                />
              </div>

              {/* Actions */}
              <div className="flex gap-2">
                <button
                  onClick={handleDeposit}
                  disabled={!amount || parseInt(amount) <= 0}
                  className="flex-1 h-10 rounded-md bg-green-600 hover:bg-green-700 disabled:opacity-50 disabled:cursor-not-allowed text-white text-sm font-semibold transition-colors"
                >
                  Deposit
                </button>
                <button
                  onClick={handleWithdraw}
                  disabled={!amount || parseInt(amount) <= 0}
                  className="flex-1 h-10 rounded-md bg-red-600 hover:bg-red-700 disabled:opacity-50 disabled:cursor-not-allowed text-white text-sm font-semibold transition-colors"
                >
                  Withdraw
                </button>
              </div>
            </div>
          )}

          {tab === "employees" && (
            <div className="space-y-3">
              {/* Refresh + Hire */}
              <div className="flex gap-2">
                <button
                  onClick={loadEmployees}
                  disabled={loadingEmployees}
                  className="flex-1 h-8 rounded-md bg-secondary hover:bg-secondary/80 text-xs font-semibold text-foreground transition-colors"
                >
                  {loadingEmployees ? "Loading..." : "Refresh"}
                </button>
              </div>

              {/* Employee List */}
              {employees.length === 0 && !loadingEmployees && (
                <div className="text-sm text-muted-foreground text-center py-6">
                  No employees online
                </div>
              )}
              {employees.map((emp) => (
                <div key={emp.source} className="bg-secondary/30 border border-border rounded-lg p-3 space-y-2">
                  <div className="flex items-center justify-between">
                    <div>
                      <div className="font-semibold text-sm text-primary flex items-center gap-2">
                        {emp.name}
                        {emp.isSelf && (
                          <span className="px-1.5 py-0.5 rounded text-[9px] font-semibold bg-secondary/60 text-muted-foreground uppercase tracking-wider">You</span>
                        )}
                      </div>
                      <div className="text-[10px] text-muted-foreground">{emp.gradeLabel}</div>
                    </div>
                    {!emp.isSelf && (
                      <button
                        onClick={() => handleFire(emp.source)}
                        className="px-2 py-1 rounded text-[10px] font-semibold bg-red-600 hover:bg-red-700 text-white transition-colors"
                      >
                        Fire
                      </button>
                    )}
                  </div>
                  {grades.length > 0 && !emp.isSelf && (
                    <select
                      value={emp.grade}
                      onChange={(e) => handleSetGrade(emp.source, parseInt(e.target.value))}
                      className="w-full h-8 rounded-md border border-border bg-background px-2 text-xs text-foreground"
                    >
                      {grades.map((g) => (
                        <option key={g.level} value={g.level}>
                          {g.label}
                        </option>
                      ))}
                    </select>
                  )}
                </div>
              ))}

              {/* Hire section */}
              <div className="border-t border-border pt-3 mt-3">
                <div className="text-xs font-semibold text-muted-foreground mb-2">Hire Nearby Player</div>
                <HireNearby clubId={data?.clubId} onHire={handleHire} />
              </div>
            </div>
          )}

          {tab === "pricing" && (
            <div className="space-y-4">
              {loadingPricing ? (
                <div className="text-sm text-muted-foreground text-center py-6">Loading...</div>
              ) : (
                <>
                  <div>
                    <div className="text-[10px] text-muted-foreground mb-1">Entry Price</div>
                    <input
                      type="number"
                      value={entryPrice}
                      onChange={(e) => setEntryPrice(e.target.value)}
                      placeholder="Default from config"
                      min="0"
                      className="w-full h-10 rounded-md border border-border bg-background px-3 text-sm text-foreground placeholder:text-muted-foreground"
                    />
                  </div>
                  <div>
                    <div className="text-[10px] text-muted-foreground mb-1">VIP Pass Price</div>
                    <input
                      type="number"
                      value={vipPrice}
                      onChange={(e) => setVipPrice(e.target.value)}
                      placeholder="Default from config"
                      min="0"
                      className="w-full h-10 rounded-md border border-border bg-background px-3 text-sm text-foreground placeholder:text-muted-foreground"
                    />
                  </div>
                  <button
                    onClick={savePricing}
                    className="w-full h-10 rounded-md bg-primary hover:bg-primary/90 text-primary-foreground text-sm font-semibold transition-colors"
                  >
                    Save Prices
                  </button>
                </>
              )}
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

const HireNearby = ({ clubId, onHire }: { clubId?: number; onHire: (source: number) => void }) => {
  const [nearbyPlayers, setNearbyPlayers] = useState<{ source: number; name: string }[]>([]);
  const [loading, setLoading] = useState(false);

  const refresh = async () => {
    if (!clubId) return;
    setLoading(true);
    const players = await fetchNui<{ source: number; name: string }[]>("getNearbyPlayers", { clubId });
    setNearbyPlayers(players || []);
    setLoading(false);
  };

  return (
    <div className="space-y-2">
      <button
        onClick={refresh}
        disabled={loading}
        className="w-full h-8 rounded-md bg-secondary hover:bg-secondary/80 text-xs font-semibold text-foreground transition-colors"
      >
        {loading ? "Scanning..." : "Scan Nearby"}
      </button>
      {nearbyPlayers.map((p) => (
        <div key={p.source} className="flex items-center justify-between bg-secondary/30 border border-border rounded-lg px-3 py-2">
          <span className="text-sm text-foreground">{p.name}</span>
          <button
            onClick={() => onHire(p.source)}
            className="px-2 py-1 rounded text-[10px] font-semibold bg-green-600 hover:bg-green-700 text-white transition-colors"
          >
            Hire
          </button>
        </div>
      ))}
    </div>
  );
};
