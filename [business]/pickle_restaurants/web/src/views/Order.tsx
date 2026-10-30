import { useState } from "react";
import Panel from "@/components/Panel";
import { Button } from "@/components/ui/button";
import { _L } from "@/lib/locale";
import { Check } from "lucide-react";
import { OrderBuilder, arr, type Cat } from "@/components/OrderBuilder";

// The self-service kiosk order screen. Reuses the register's OrderBuilder (catalog
// + modifier picker + cart) in "kiosk" mode — no customer picker, the customer pays
// for their own order — then shows a confirmation with the ticket number. The order
// itself becomes an ordinary kitchen ticket that staff fulfil at the register.
export default function Order({ data, onClose }: { data: any; onClose: () => void }) {
  const id = data?.restaurantId;
  const catalog: Cat[] = arr<Cat>(data?.catalog);
  const [placed, setPlaced] = useState<number | null>(null);

  return (
    <Panel
      title={_L("order.title")}
      subtitle={_L("order.subtitle", data?.label || "")}
      onClose={onClose}
      width="max-w-4xl"
    >
      {placed !== null ? (
        <div className="flex min-h-0 flex-1 flex-col items-center justify-center gap-4 py-10 text-center">
          <div className="grid h-16 w-16 place-items-center rounded-full bg-primary/15 text-primary">
            <Check className="h-8 w-8" />
          </div>
          <div>
            <div className="text-lg font-semibold">{_L("order.placed_title")}</div>
            <div className="mt-1 max-w-sm text-sm text-muted-foreground">{_L("order.placed_desc", placed)}</div>
          </div>
          <div className="flex gap-2">
            <Button variant="outline" onClick={() => setPlaced(null)}>{_L("order.another")}</Button>
            <Button onClick={onClose}>{_L("order.done")}</Button>
          </div>
        </div>
      ) : (
        <OrderBuilder id={id} catalog={catalog} mode="kiosk" onOrdered={(t) => setPlaced(t ?? 0)} />
      )}
    </Panel>
  );
}
