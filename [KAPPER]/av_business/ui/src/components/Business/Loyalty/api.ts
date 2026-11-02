export interface LoyaltyPromoType {
  id: number;
  job?: string;
  name: string;
  image?: string | null;
  required_visits: number;
  discount: number;
  discount_type: "percentage" | "amount";
  max_prints?: number | null;
  visit_cooldown: number;
  active: boolean | number;
  created_at: number;
  total_printed?: number;
  total_redeemed?: number;
}

export const ApiLoyaltyPromo: Omit<LoyaltyPromoType, "id" | "created_at"> = {
  name: "",
  image: null,
  required_visits: 10,
  discount: 10,
  discount_type: "percentage",
  max_prints: null,
  visit_cooldown: 3600,
  active: true,
};

export const ApiLoyaltyPromos: LoyaltyPromoType[] = [
  {
    id: 1,
    name: "VIP Coffee Card",
    image: null,
    required_visits: 10,
    discount: 15,
    discount_type: "percentage",
    max_prints: 100,
    visit_cooldown: 3600,
    active: true,
    created_at: Math.floor(Date.now() / 1000) - 86400 * 5,
    total_printed: 23,
    total_redeemed: 4,
  },
  {
    id: 2,
    name: "Burger Loyalty Card",
    image: null,
    required_visits: 5,
    discount: 5,
    discount_type: "amount",
    max_prints: null,
    visit_cooldown: 1800,
    active: false,
    created_at: Math.floor(Date.now() / 1000) - 86400 * 10,
    total_printed: 50,
    total_redeemed: 50,
  },
  {
    id: 3,
    name: "Loyal Customer Card",
    image: null,
    required_visits: 20,
    discount: 25,
    discount_type: "percentage",
    max_prints: null,
    visit_cooldown: 7200,
    active: true,
    created_at: Math.floor(Date.now() / 1000) - 86400 * 2,
    total_printed: 8,
    total_redeemed: 0,
  },
];
