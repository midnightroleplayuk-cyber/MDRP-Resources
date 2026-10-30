import { useMemo, useState } from "react";
import { Search, MapPin, Clock, Repeat, ChevronRight, Store } from "lucide-react";
import { usePhone } from "../store";
import { Screen, ItemImg, Rating, PromoTag, Empty, Pill } from "../ui";
import { cn } from "../../lib/utils";
import { _L } from "../../lib/locale";

// A rough ETA so the feed reads like a delivery app, derived from distance.
function eta(dist?: number) {
  if (dist == null) return "—";
  const mins = Math.max(5, Math.round(dist / 60) + 8);
  return _L("phone.home.eta", mins, mins + 10);
}

function RestaurantCard({ r, onOpen }: { r: any; onOpen: () => void }) {
  return (
    <button
      onClick={r.open ? onOpen : undefined}
      className={cn(
        "pf-elev block w-full overflow-hidden rounded-3xl border border-border bg-card text-left transition-transform",
        r.open ? "active:scale-[0.985]" : "opacity-70"
      )}
    >
      <div className="relative h-36 w-full bg-muted">
        <ItemImg src={r.brand} alt={r.label} className="h-full w-full" />
        <div className="absolute inset-x-0 bottom-0 h-20 bg-gradient-to-t from-black/70 via-black/25 to-transparent" />
        {r.promo && (
          <div className="absolute left-2.5 top-2.5">
            <PromoTag label={_L("phone.promo.percent_off", r.promo.percent)} />
          </div>
        )}
        <div className="absolute right-2.5 top-2.5 flex items-center gap-1 rounded-full bg-black/65 px-2 py-0.5 text-[0.6rem] font-bold uppercase tracking-wide text-white">
          <span className={cn("h-1.5 w-1.5 rounded-full", r.open ? "bg-ok" : "bg-white/50")} />
          {r.open ? _L("phone.home.open") : _L("phone.home.closed")}
        </div>
        <div className="absolute bottom-2.5 left-3.5 right-3.5 text-white">
          <span className="font-display text-xl font-extrabold leading-tight drop-shadow-md">{r.label}</span>
        </div>
      </div>
      <div className="flex items-center gap-3 px-3.5 py-2.5 text-muted-foreground">
        <Rating value={r.rating} count={r.reviews} />
        <span className="inline-flex items-center gap-1 text-[0.72rem] font-medium">
          <Clock className="h-3 w-3" /> {eta(r.dist)}
        </span>
        {r.dist != null && (
          <span className="ml-auto inline-flex items-center gap-1 text-[0.72rem] font-medium">
            <MapPin className="h-3 w-3" />{" "}
            {r.dist < 1000
              ? _L("phone.home.dist_m", r.dist)
              : _L("phone.home.dist_km", (r.dist / 1000).toFixed(1))}
          </span>
        )}
      </div>
    </button>
  );
}

export default function Home() {
  const { home, go, currency } = usePhone();
  const [q, setQ] = useState("");
  const [onlyOpen, setOnlyOpen] = useState(false);
  const [onlyPromo, setOnlyPromo] = useState(false);

  const restaurants: any[] = home?.restaurants || [];
  const favorites: any[] = home?.favorites || [];

  const filtered = useMemo(() => {
    return restaurants.filter((r) => {
      if (q && !(r.label || "").toLowerCase().includes(q.toLowerCase())) return false;
      if (onlyOpen && !r.open) return false;
      if (onlyPromo && !r.promo) return false;
      return true;
    });
  }, [restaurants, q, onlyOpen, onlyPromo]);

  return (
    <Screen className="pb-24">
      {/* header — a floating card inset from the rounded frame edges, aligned
          with the feed cards below (mx-4 ≡ the sections' px-4) */}
      <div className="pf-elev mx-4 mt-2 rounded-3xl border border-border bg-card px-4 pb-3.5 pt-3.5">
        <div className="flex items-center gap-1 text-[0.7rem] font-semibold uppercase tracking-wide text-muted-foreground">
          <MapPin className="h-3.5 w-3.5 text-brand" /> {_L("phone.home.deliver_to")}
        </div>
        <h1 className="mt-0.5 font-display text-2xl font-extrabold leading-tight">
          {_L("phone.home.greeting", home?.name?.split(" ")[0] || _L("phone.home.greeting_fallback"))}
        </h1>
        <div className="mt-3 flex items-center gap-2 rounded-full border border-border bg-background px-3.5 py-2.5">
          <Search className="h-4 w-4 text-muted-foreground" />
          <input
            value={q}
            onChange={(e) => setQ(e.target.value)}
            placeholder={_L("phone.home.search")}
            className="w-full bg-transparent text-sm outline-none placeholder:text-muted-foreground"
          />
        </div>
        <div className="mt-2.5 flex gap-2">
          <Pill active={onlyOpen} onClick={() => setOnlyOpen((v) => !v)}>
            {_L("phone.home.filter_open")}
          </Pill>
          <Pill active={onlyPromo} onClick={() => setOnlyPromo((v) => !v)}>
            {_L("phone.home.filter_deals")}
          </Pill>
        </div>
      </div>

      {/* order again */}
      {favorites.length > 0 && (
        <section className="mt-4">
          <div className="mb-2 flex items-center justify-between px-4">
            <h2 className="font-display text-base font-bold">{_L("phone.home.order_again")}</h2>
            <Repeat className="h-4 w-4 text-muted-foreground" />
          </div>
          <div className="pf-rail px-4">
            {favorites.map((f) => (
              <button
                key={f.id}
                onClick={() => go("restaurant", { rid: f.restaurant_id, reorder: f })}
                className="pf-elev w-40 shrink-0 rounded-2xl border border-border bg-card p-3 text-left transition-transform active:scale-95"
              >
                <div className="truncate font-semibold leading-tight">{f.label}</div>
                <div className="mt-0.5 truncate text-[0.72rem] text-muted-foreground">
                  {f.restaurant}
                </div>
                <div className="mt-2 inline-flex items-center gap-1 text-[0.72rem] font-semibold text-brand">
                  {_L("phone.home.reorder")} <ChevronRight className="h-3 w-3" />
                </div>
              </button>
            ))}
          </div>
        </section>
      )}

      {/* feed */}
      <section className="mt-4 space-y-3 px-4">
        <h2 className="font-display text-base font-bold">
          {q ? _L("phone.home.results") : _L("phone.home.nearby")}
        </h2>
        {filtered.length === 0 ? (
          <Empty
            icon={<Store className="h-8 w-8" />}
            title={_L("phone.home.empty_title")}
            hint={_L("phone.home.empty_hint")}
          />
        ) : (
          filtered.map((r) => (
            <RestaurantCard key={r.id} r={r} onOpen={() => go("restaurant", { rid: r.id })} />
          ))
        )}
      </section>
    </Screen>
  );
}
