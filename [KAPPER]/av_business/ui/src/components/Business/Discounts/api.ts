export interface DiscountType {
  code: string;
  job: string;
  discount: number;
  description: string;
  type: "percentage" | "amount";
  generated: number;
  employee: string;
  limit?: number;
  expires?: number;
  redeemed: number;
  enabled: boolean;
}

export const ApiCoupon: DiscountType = {
  code: "",
  description: "",
  employee: "",
  discount: 1,
  enabled: true,
  generated: 0,
  job: "",
  redeemed: 0,
  type: "amount",
};

export const ApiDiscounts: DiscountType[] = [
  {
    code: "WELCOME10",
    job: "restaurant",
    discount: 10,
    description: "Welcome discount for new customers",
    type: "percentage",
    generated: 1706822400,
    employee: "Admin",
    limit: 100,
    expires: 1738368000,
    redeemed: 45,
    enabled: true,
  },
  {
    code: "BURGER5",
    job: "restaurant",
    discount: 5,
    description: "$5 off any burger combo",
    type: "amount",
    generated: 1706822400,
    employee: "John Doe",
    limit: 50,
    expires: 1710000000,
    redeemed: 12,
    enabled: true,
  },
  {
    code: "TACO20",
    job: "mexican_grill",
    discount: 20,
    description: "Taco Tuesday Special",
    type: "percentage",
    generated: 1706822400,
    employee: "Maria G.",
    limit: 200,
    redeemed: 150,
    enabled: true,
  },
  {
    code: "LUNCHBOX",
    job: "restaurant",
    discount: 3,
    description: "Fixed discount for office lunch orders",
    type: "amount",
    generated: 1706822400,
    employee: "Steve Smith",
    redeemed: 88,
    enabled: true,
  },
  {
    code: "WEEKEND15",
    job: "restaurant",
    discount: 15,
    description: "Weekend family bundle discount",
    type: "percentage",
    generated: 1706822400,
    employee: "Admin",
    limit: 30,

    expires: 1709424000,
    redeemed: 5,
    enabled: true,
  },
  {
    code: "PIZZA_PARTY",
    job: "pizzeria",
    discount: 15,
    description: "$15 off orders over $50",
    type: "amount",
    generated: 1706822400,
    employee: "Chef Mario",
    limit: 10,

    expires: 1708128000,
    redeemed: 2,
    enabled: false,
  },
  {
    code: "HAPPYHOUR",
    job: "bar_grill",
    discount: 50,
    description: "Half off appetizers",
    type: "percentage",
    generated: 1706822400,
    employee: "Bartender Bob",

    redeemed: 540,
    enabled: true,
  },
  {
    code: "COFFEE2",
    job: "cafe",
    discount: 2,
    description: "$2 off morning coffee",
    type: "amount",
    generated: 1706822400,
    employee: "Alice W.",

    redeemed: 310,
    enabled: true,
  },
  {
    code: "SWEETDESSERT",
    job: "restaurant",
    discount: 100,
    description: "Free dessert coupon (Value $10)",
    type: "amount",
    generated: 1706822400,
    employee: "Admin",
    limit: 20,

    redeemed: 18,
    enabled: true,
  },
  {
    code: "VETERAN",
    job: "restaurant",
    discount: 25,
    description: "Veteran appreciation discount",
    type: "percentage",
    generated: 1706822400,
    employee: "Manager",

    redeemed: 45,
    enabled: true,
  },
  {
    code: "NIGHTOWL",
    job: "diner",
    discount: 10,
    description: "Late night dining discount",
    type: "percentage",
    generated: 1706822400,
    employee: "Sarah L.",

    redeemed: 120,
    enabled: true,
  },
  {
    code: "STUDENT5",
    job: "restaurant",
    discount: 5,
    description: "Student ID discount",
    type: "amount",
    generated: 1706822400,
    employee: "Admin",

    redeemed: 230,
    enabled: true,
  },
  {
    code: "BIRTHDAY_GIFT",
    job: "restaurant",
    discount: 15,
    description: "Special birthday discount",
    type: "amount",
    generated: 1706822400,
    employee: "Admin",
    limit: 1,

    redeemed: 0,
    enabled: true,
  },
  {
    code: "HEALTHY10",
    job: "salad_bar",
    discount: 10,
    description: "10% off all salads",
    type: "percentage",
    generated: 1706822400,
    employee: "Kelly R.",

    redeemed: 67,
    enabled: true,
  },
  {
    code: "STEAK_NIGHT",
    job: "steakhouse",
    discount: 20,
    description: "$20 off premium cuts",
    type: "amount",
    generated: 1706822400,
    employee: "Admin",
    limit: 15,

    expires: 1712188800,
    redeemed: 10,
    enabled: true,
  },
  {
    code: "EARLYBIRD",
    job: "restaurant",
    discount: 15,
    description: "Discount for dining before 5 PM",
    type: "percentage",
    generated: 1706822400,
    employee: "Chef Mario",

    redeemed: 400,
    enabled: true,
  },
  {
    code: "FAMILYSET",
    job: "restaurant",
    discount: 12,
    description: "Discount on family platter",
    type: "amount",
    generated: 1706822400,
    employee: "Admin",
    limit: 50,

    redeemed: 22,
    enabled: true,
  },
  {
    code: "LOCAL_HERO",
    job: "restaurant",
    discount: 20,
    description: "Discount for first responders",
    type: "percentage",
    generated: 1706822400,
    employee: "Manager",

    redeemed: 15,
    enabled: true,
  },
  {
    code: "WINTER24",
    job: "cafe",
    discount: 5,
    description: "Winter seasonal beverage discount",
    type: "amount",
    generated: 1706822400,
    employee: "Alice W.",
    expires: 1709251200,

    redeemed: 98,
    enabled: true,
  },
  {
    code: "PROMO_FB",
    job: "restaurant",
    discount: 10,
    description: "Facebook referral code",
    type: "percentage",
    generated: 1706822400,
    employee: "Admin",
    limit: 500,
    redeemed: 342,
    enabled: true,
  },
  {
    code: "STAFF_MEAL",
    job: "restaurant",
    discount: 50,
    description: "Employee meal discount",
    type: "percentage",
    generated: 1706822400,
    employee: "Admin",

    redeemed: 1200,
    enabled: true,
  },
  {
    code: "VIP_ONLY",
    job: "steakhouse",
    discount: 50,
    description: "Exclusive VIP Member discount",
    type: "amount",
    generated: 1706822400,
    employee: "Manager",
    limit: 5,

    redeemed: 1,
    enabled: true,
  },
  {
    code: "KIDS_EAT_FREE",
    job: "restaurant",
    discount: 12,
    description: "Equivalent price of kids meal",
    type: "amount",
    generated: 1706822400,
    employee: "Admin",

    redeemed: 89,
    enabled: true,
  },
  {
    code: "PASTA_MON",
    job: "pizzeria",
    discount: 15,
    description: "Pasta Monday deal",
    type: "percentage",
    generated: 1706822400,
    employee: "Chef Mario",

    redeemed: 56,
    enabled: true,
  },
  {
    code: "OFFICE20",
    job: "restaurant",
    discount: 20,
    description: "$20 off corporate orders",
    type: "amount",
    generated: 1706822400,
    employee: "John Doe",
    limit: 10,

    redeemed: 8,
    enabled: true,
  },
  {
    code: "BRUNCH_TIME",
    job: "cafe",
    discount: 10,
    description: "Brunch hours special",
    type: "percentage",
    generated: 1706822400,
    employee: "Alice W.",

    redeemed: 145,
    enabled: true,
  },
  {
    code: "DESSERT_LOVER",
    job: "restaurant",
    discount: 5,
    description: "$5 off any dessert",
    type: "amount",
    generated: 1706822400,
    employee: "Sarah L.",

    redeemed: 32,
    enabled: true,
  },
  {
    code: "FIRST_APP",
    job: "restaurant",
    discount: 25,
    description: "First order via mobile app",
    type: "percentage",
    generated: 1706822400,
    employee: "Admin",
    limit: 1000,

    redeemed: 670,
    enabled: true,
  },
  {
    code: "SUSHI_LUNCH",
    job: "sushi_bar",
    discount: 10,
    description: "$10 off lunch sets",
    type: "amount",
    generated: 1706822400,
    employee: "Manager",

    expires: 1715385600,
    redeemed: 44,
    enabled: true,
  },
  {
    code: "GOODBYE2024",
    job: "restaurant",
    discount: 24,
    description: "End of year special",
    type: "percentage",
    generated: 1706822400,
    employee: "Admin",
    limit: 50,

    expires: 1735603200,
    redeemed: 0,
    enabled: false,
  },
];

export interface PromoType {
  id?: number;
  job?: string;
  label: string;
  description: string;
  type: "percentage" | "amount";
  discount: number;
  starts_at: number;
  ends_at?: number | null;
  enabled: boolean;
}

export const ApiPromo: PromoType = {
  label: "",
  description: "",
  type: "percentage",
  discount: 10,
  starts_at: 0,
  ends_at: null,
  enabled: true,
};

export const ApiPromos: PromoType[] = [
  {
    id: 1,
    label: "Happy Hour",
    description: "Half price on all drinks",
    type: "percentage",
    discount: 50,
    starts_at: Math.floor(Date.now() / 1000) - 3600,
    ends_at: Math.floor(Date.now() / 1000) + 3600,
    enabled: true,
  },
  {
    id: 2,
    label: "Weekend Special",
    description: "$5 off any order",
    type: "amount",
    discount: 5,
    starts_at: Math.floor(Date.now() / 1000) + 86400,
    ends_at: Math.floor(Date.now() / 1000) + 86400 * 3,
    enabled: true,
  },
  {
    id: 3,
    label: "Summer Sale",
    description: "20% off all items",
    type: "percentage",
    discount: 20,
    starts_at: Math.floor(Date.now() / 1000) - 86400 * 10,
    ends_at: Math.floor(Date.now() / 1000) - 86400,
    enabled: false,
  },
];
