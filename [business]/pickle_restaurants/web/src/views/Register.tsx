import { useEffect, useState } from "react";
import { useNuiEvent } from "@/lib/nui";
import Panel from "@/components/Panel";
import { Tabs, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { money, cn } from "@/lib/utils";
import { _L } from "@/lib/locale";
import { ShoppingCart, ClipboardList } from "lucide-react";
import { OrderBuilder, arr, type Cat, type Near, type Ticket } from "@/components/OrderBuilder";
import { Tickets } from "@/components/RegisterTickets";

export default function Register({ data, onClose }: { data: any; onClose: () => void }) {
  const id = data?.restaurantId;
  // Catalog + nearby come from the initial open payload (they don't churn while
  // the panel is up).
  const catalog: Cat[] = arr<Cat>(data?.catalog);
  const nearby: Near[] = arr<Near>(data?.nearby);

  // The ticket list is LIVE: seeded from the open payload, then kept in sync by
  // the server's `orders` broadcast (fired on any create/cancel/complete, from
  // any cashier). This is the only thing that mutates while the panel is open, so
  // updating just this state — never the whole panel — is flicker-free and can't
  // race a full re-render. Re-seed if the panel is reopened with fresh `data`.
  const [tickets, setTickets] = useState<Ticket[]>(() => arr<Ticket>(data?.tickets));
  useEffect(() => { setTickets(arr<Ticket>(data?.tickets)); }, [data]);
  useNuiEvent("orders", (d) => setTickets(arr<Ticket>(d?.orders)));

  const [tab, setTab] = useState<"new" | "tickets">("new");

  return (
    <Panel
      title={_L("register.title")}
      subtitle={_L("register.subtitle_pos", data?.label || "", money(data?.balance), data?.commission ?? 0)}
      onClose={onClose}
      width="max-w-4xl"
    >
      <Tabs value={tab} onValueChange={(v) => setTab(v as "new" | "tickets")} className="flex min-h-0 flex-1 flex-col">
        <TabsList className="shrink-0">
          <TabsTrigger value="new"><ShoppingCart className="h-4 w-4" /> {_L("register.new_order")}</TabsTrigger>
          <TabsTrigger value="tickets"><ClipboardList className="h-4 w-4" /> {_L("register.tickets", tickets.length)}</TabsTrigger>
        </TabsList>

        {/* Both panes stay MOUNTED and toggle via CSS (not TabsContent, which unmounts
            the inactive tab) so the in-progress cart survives a hop to Tickets and back. */}
        <div className={cn("mt-3 min-h-0 flex-1 animate-fade-in", tab !== "new" && "hidden")}>
          <OrderBuilder id={id} catalog={catalog} nearby={nearby} mode="register" />
        </div>

        {/* not overflow-scrolled here — Tickets owns its own scroll so the meal
            picker can overlay (and dim) just the ticket area, not the whole panel */}
        <div className={cn("mt-3 min-h-0 flex-1 animate-fade-in", tab !== "tickets" && "hidden")}>
          <Tickets id={id} tickets={tickets} />
        </div>
      </Tabs>
    </Panel>
  );
}
