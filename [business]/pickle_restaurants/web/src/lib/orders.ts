// How a ticket reached the kitchen, shared by every surface that shows one: the POS
// (fullscreen + in-world DUI), the kitchen's corner Tickets widget and the phone KDS.
// The classification is the SERVER's (`OrderChannel` in core/server.lua, projected as
// `channel` by GetOpenOrders) — never re-derived per view, so the three can't disagree.
//
// `npc` is orthogonal: it says the customer is an AI, not how the order arrived. An NPC
// can place a delivery, so it must not overwrite the channel (it used to, which is why
// NPC deliveries read as "Walk-in" everywhere).
import { Truck, ShoppingBag, Utensils, Footprints, Bot, type LucideIcon } from "lucide-react";
import { _L } from "./locale";

export type Channel = "delivery" | "pickup" | "dine_in" | "walk_in";

export type ChannelTicket = { channel?: string; orderType?: string; npc?: boolean };

/** The ticket's channel, falling back to the legacy `orderType` on an older payload. */
export function orderChannel(t: ChannelTicket): Channel {
  const c = t.channel || t.orderType;
  if (c === "delivery") return "delivery";
  if (c === "dine_in") return "dine_in";
  if (c === "pickup") return "pickup";
  return "walk_in";
}

const ICONS: Record<Channel, LucideIcon> = {
  delivery: Truck,
  pickup: ShoppingBag,
  dine_in: Utensils,
  walk_in: Footprints,
};

/** Icon for the channel — or the AI-customer bot, which only wins on a walk-in. */
export function channelIcon(t: ChannelTicket): LucideIcon {
  const c = orderChannel(t);
  if (t.npc && c === "walk_in") return Bot;
  return ICONS[c];
}

/** Resolved at call time, never at module scope — the locale table arrives after import. */
export function channelLabel(t: ChannelTicket): string {
  const c = orderChannel(t);
  if (t.npc && c === "walk_in") return _L("order.channel_npc");
  return _L("order.channel_" + c);
}

/** A delivery is handed over at the customer's door by its claimed driver, never at the counter. */
export const isDelivery = (t: ChannelTicket) => orderChannel(t) === "delivery";
