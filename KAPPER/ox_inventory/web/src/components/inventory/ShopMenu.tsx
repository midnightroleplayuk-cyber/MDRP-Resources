import React, { useEffect, useMemo, useRef, useState } from 'react';
import { useAppDispatch, useAppSelector } from '../../store';
import { selectLeftInventory, selectRightInventory } from '../../store/inventory';
import { Items } from '../../store/items';
import { Locale } from '../../store/locale';
import { getItemUrl, isSlotWithItem } from '../../helpers';
import { SlotWithItem } from '../../typings';
import { buyItem } from '../../thunks/buyItem';

const itemLabel = (name: string) => Items[name]?.label || name;

const accountBalance = (items: any[], name: string) =>
  items.reduce((total, slot) => (isSlotWithItem(slot) && slot.name === name ? total + (slot.count || 0) : total), 0);

const money = (n: number) => n.toLocaleString('en-us');

// Best-effort category from the item name (no category field exists in data).
const categoryOf = (p: SlotWithItem): string => {
  const n = p.name.toLowerCase();
  if (n.startsWith('weapon_') || n.startsWith('ammo') || n.startsWith('at_')) return 'Weapons';
  return 'Items';
};

type Pay = 'money' | 'bank';
type CartLine = { slot: number; count: number };

const ShopMenu: React.FC = () => {
  const dispatch = useAppDispatch();
  const shop = useAppSelector(selectRightInventory);
  const left = useAppSelector(selectLeftInventory);
  const isBusy = useAppSelector((state) => state.inventory.isBusy);

  const products = useMemo(() => shop.items.filter((i) => isSlotWithItem(i)) as SlotWithItem[], [shop.items]);

  const [cat, setCat] = useState('All');
  const [cart, setCart] = useState<CartLine[]>([]);

  const cash = accountBalance(left.items, 'money');

  // Categories present in this shop (only show tabs that have items).
  const categories = useMemo(() => {
    const set = new Set<string>();
    products.forEach((p) => set.add(categoryOf(p)));
    return ['All', ...Array.from(set)];
  }, [products]);

  const visible = useMemo(
    () => (cat === 'All' ? products : products.filter((p) => categoryOf(p) === cat)),
    [products, cat]
  );

  const inCart = (slot: number) => cart.find((c) => c.slot === slot)?.count ?? 0;

  const addToCart = (p: SlotWithItem) => {
    const stock = p.count; // undefined = unlimited
    setCart((c) => {
      const line = c.find((x) => x.slot === p.slot);
      const current = line?.count ?? 0;
      if (stock !== undefined && current >= stock) return c;
      if (line) return c.map((x) => (x.slot === p.slot ? { ...x, count: x.count + 1 } : x));
      return [...c, { slot: p.slot, count: 1 }];
    });
  };

  const setCartQty = (slot: number, count: number) => {
    const p = products.find((x) => x.slot === slot);
    const stock = p?.count;
    const max = stock ?? 9999;
    setCart((c) =>
      count <= 0
        ? c.filter((x) => x.slot !== slot)
        : c.map((x) => (x.slot === slot ? { ...x, count: Math.min(max, count) } : x))
    );
  };

  const removeLine = (slot: number) => setCart((c) => c.filter((x) => x.slot !== slot));

  // Total grouped by currency (money items can be paid via cash or bank).
  const cartProducts = cart
    .map((c) => ({ line: c, p: products.find((x) => x.slot === c.slot) }))
    .filter((x) => x.p) as { line: CartLine; p: SlotWithItem }[];

  const cashTotal = cartProducts
    .filter((x) => (x.p.currency || 'money') === 'money')
    .reduce((t, x) => t + (x.p.price ?? 0) * x.line.count, 0);

  const altTotals = useMemo(() => {
    const m: Record<string, number> = {};
    cartProducts
      .filter((x) => (x.p.currency || 'money') !== 'money')
      .forEach((x) => {
        const cur = x.p.currency as string;
        m[cur] = (m[cur] || 0) + (x.p.price ?? 0) * x.line.count;
      });
    return m;
  }, [cart, products]);

  const cartCount = cart.reduce((t, c) => t + c.count, 0);
  const hasAlt = Object.keys(altTotals).length > 0;

  // Keep the cart list scrolled to the bottom so a newly added line is visible.
  const listRef = useRef<HTMLDivElement>(null);
  const prevLines = useRef(0);
  useEffect(() => {
    if (cart.length > prevLines.current && listRef.current) {
      listRef.current.scrollTop = listRef.current.scrollHeight;
    }
    prevLines.current = cart.length;
  }, [cart.length]);

  // Pay the whole cart. `pay` only applies to money-priced items; alt-currency
  // items always use their own currency.
  //
  // Each cart line must land in its OWN free slot. Previously every line was
  // sent to the same slot, so all lines after the first collided on it and the
  // server rejected them ("unable to stack") — which is why only a single item
  // could ever be bought per checkout. We also buy one line at a time (await)
  // so each request gets the full server callback window and a failure (e.g.
  // not enough money) can't roll the already-bought lines back out of the UI.
  const checkout = async (pay: Pay) => {
    if (isBusy || cart.length === 0) return;

    // Bought items should land in the MAIN inventory, not the quick-use hotbar
    // (slots 1-5). Prefer slots outside the hotbar; only fall back to hotbar
    // slots when the rest of the inventory is full, so a purchase is never
    // blocked just because the pockets are full.
    const HOTBAR_SLOTS = 5;
    const empties = left.items.filter((s) => s && !s.name).map((s) => s.slot);
    const freeSlots: (number | undefined)[] = [
      ...empties.filter((n) => n > HOTBAR_SLOTS),
      ...empties.filter((n) => n <= HOTBAR_SLOTS),
    ];
    const lines = cartProducts;

    setCart([]);

    for (let i = 0; i < lines.length; i++) {
      const toSlot = freeSlots[i];
      if (toSlot === undefined) break; // inventory full — stop here

      const { line, p } = lines[i];
      const isCash = (p.currency || 'money') === 'money';
      await dispatch(
        buyItem({
          fromSlot: p.slot,
          toSlot,
          fromType: shop.type,
          toType: left.type,
          count: line.count,
          currency: isCash ? pay : p.currency,
        })
      );
    }
  };

  return (
    <div className="shop2" style={{ pointerEvents: isBusy ? 'none' : 'auto' }}>
      {/* ── Store panel (top card) — mirrors the POCKETS grid card exactly:
          header (badge + title + wallet) INSIDE the card, then the slot grid. ── */}
      <div className="shop2-store">
        <div className="shop2-store-head">
          <div className="shop2-head-left">
            <div className="inventory-grid-badge">
              <ShopSvg />
            </div>
            <div className="inventory-grid-title-text">
              <p className="inventory-grid-label">{shop.label || 'STORE'}</p>
              <span className="inventory-grid-subtitle">Browse and buy items</span>
            </div>
          </div>
          <div className="shop2-wallet">
            <div className="shop2-chip">
              <span className="shop2-chip-label">Cash</span>
              <span className="shop2-chip-value">${money(cash)}</span>
            </div>
          </div>
        </div>

        {/* Category tabs (only when there's more than one category) */}
        {categories.length > 2 && (
          <div className="shop2-cats">
            {categories.map((c) => (
              <button
                key={c}
                className={`shop2-cat${cat === c ? ' shop2-cat-active' : ''}`}
                onClick={() => setCat(c)}
              >
                {c}
              </button>
            ))}
          </div>
        )}

        {/* Product grid — each product is an inventory-style slot (icon inside,
            price/stock in the corners, name in the bottom label box). */}
        <div className="shop2-grid">
          {visible.length === 0 && <div className="shop2-empty">No items found.</div>}
          {visible.map((p) => {
          const isCash = (p.currency || 'money') === 'money';
          const stock = p.count;
          const out = stock !== undefined && stock <= 0;
          const qty = inCart(p.slot);
          return (
            <button
              key={p.slot}
              className={`shop2-slot${out ? ' shop2-slot-out' : ''}`}
              disabled={out}
              onClick={() => addToCart(p)}
              title={p.metadata?.label || itemLabel(p.name)}
              style={{ backgroundImage: `url(${getItemUrl(p) || 'none'})` }}
            >
              {/* top row: cart qty (left) + price (right) */}
              <div className="shop2-slot-top">
                {qty > 0 ? <span className="shop2-slot-qty">{qty}</span> : <span />}
                <span className={`shop2-slot-price${isCash ? '' : ' shop2-slot-price-alt'}`}>
                  {isCash ? (
                    `$${money(p.price ?? 0)}`
                  ) : (
                    <>
                      <span
                        className="shop2-cur"
                        style={{ backgroundImage: `url(${getItemUrl(p.currency as string) || 'none'})` }}
                      />
                      {money(p.price ?? 0)}
                    </>
                  )}
                </span>
              </div>

              {stock !== undefined && <span className="shop2-slot-stock">{stock} left</span>}

              {/* name strip — slides up from the bottom only on hover */}
              <span className="shop2-slot-name">{p.metadata?.label || itemLabel(p.name)}</span>
            </button>
          );
        })}
        </div>
      </div>

      {/* ── Cart panel (bottom card) — header INSIDE, matching the store card. ── */}
      <div className="shop2-cart">
        <div className="shop2-cart-head">
          <div className="inventory-grid-badge">
            <CartSvg />
          </div>
          <div className="inventory-grid-title-text">
            <p className="inventory-grid-label">Cart</p>
            <span className="inventory-grid-subtitle">{cartCount} item{cartCount === 1 ? '' : 's'}</span>
          </div>
          {cartCount > 0 && <span className="shop2-cart-count">{cartCount}</span>}
        </div>

        <div className="shop2-cart-list" ref={listRef}>
          {cart.length === 0 && <div className="shop2-cart-empty">Click products to add them here.</div>}
          {cartProducts.map(({ line, p }) => {
            const isCash = (p.currency || 'money') === 'money';
            return (
              <div className="shop2-cart-row" key={p.slot}>
                <span className="shop2-cart-img" style={{ backgroundImage: `url(${getItemUrl(p) || 'none'})` }} />
                <div className="shop2-cart-info">
                  <span className="shop2-cart-name">{p.metadata?.label || itemLabel(p.name)}</span>
                  <span className="shop2-cart-each">
                    {isCash ? `$${money(p.price ?? 0)}` : `${money(p.price ?? 0)} ${p.currency}`} ea.
                  </span>
                </div>
                <div className="shop2-stepper">
                  <button onClick={() => setCartQty(p.slot, line.count - 1)}>−</button>
                  <input value={line.count} onChange={(e) => setCartQty(p.slot, parseInt(e.target.value) || 0)} />
                  <button onClick={() => setCartQty(p.slot, line.count + 1)}>+</button>
                </div>
                <span className="shop2-cart-line">
                  {isCash ? `$${money((p.price ?? 0) * line.count)}` : `${money((p.price ?? 0) * line.count)}`}
                </span>
                <button className="shop2-cart-x" onClick={() => removeLine(p.slot)}>
                  ✕
                </button>
              </div>
            );
          })}
        </div>

        <div className="shop2-cart-foot">
          <div className="shop2-total">
            <span className="shop2-total-label">Total</span>
            <span className="shop2-total-value">
              ${money(cashTotal)}
              {hasAlt &&
                Object.entries(altTotals).map(([cur, v]) => (
                  <span className="shop2-total-alt" key={cur}>
                    {' '}
                    + {money(v)} {cur}
                  </span>
                ))}
            </span>
          </div>
          <button className="shop2-pay" disabled={cart.length === 0 || isBusy} onClick={() => checkout('money')}>
            <CartSvg />
            <span>{Locale.ui_pay || 'Pay'}</span>
          </button>
        </div>
      </div>
    </div>
  );
};

/* — inline icons — */
const ShopSvg: React.FC = () => (
  <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round">
    <path d="M4 9h16l-1 11H5z" />
    <path d="M4 9 6 4h12l2 5M9 13v3m6-3v3" />
  </svg>
);
const CartSvg: React.FC = () => (
  <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
    <circle cx="9" cy="20" r="1.4" />
    <circle cx="18" cy="20" r="1.4" />
    <path d="M2 3h3l2.4 12.4a1.5 1.5 0 0 0 1.5 1.2h8.6a1.5 1.5 0 0 0 1.5-1.2L22 7H6" />
  </svg>
);

export default ShopMenu;
