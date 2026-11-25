# NDM_Business

One resource for restaurants, clubs and player-owned businesses on Qbox, ox_inventory and oxmysql.

## Build order

1. **Core:** business records, job and rank permissions, safe money movement, audit log.
2. **Shared tools:** placement, targets, staff, payroll, stock, register and management UI.
3. **Businesses:** locations, listings, crafting, billing, market and supply stores.
4. **Clubs:** bartending, drinks, bouncers, entry and passes.
5. **Restaurants:** cooking, dining, kiosks, screens, delivery and phone app.
6. **Cutover:** migrate data one venue type at a time, then retire that Pickle resource.

## Setting up businesses

Everything is set up in game from `/business`. There are no setup commands.

Admins see a **Business setup** button, and the panel opens straight to it when no business
exists yet. From there an admin can:

- create a restaurant, club or business and choose the job its staff are hired into;
- list an unowned business for sale, give it to an online player, or remove its owner;
- see every business's balance and press Manage to open it;
- delete a business, which removes its owner from the job and deletes its locations, stock,
  prices, club passes and bans, order history and ledger. Money in the job's bank account and
  staff in the job are not touched. A business with an open stock order cannot be deleted;
- place and remove supplier depots.

Only admins see a business's Locations tab, so owners and staff cannot place, move or remove
locations. Admin means the `command` ace, for example `group.admin`.

Bosses, owners and staff with management permissions use the same `/business` panel to run
their own business.

## Supply runs

1. An admin places a depot from Business setup.
2. A manager places a stock room, then pays for an order in `/business` under Stock.
3. Staff collect boxes at the depot and load them into one vehicle.
4. Staff drive back, take the boxes out and deliver them to the stock room.
5. Stock is added when the final box is delivered.

Use `/dropbox` to put a carried box back. Prices, box size and items are in
`config/supply.lua`.

## Selling

1. Set sale prices in `/business` under Menu.
2. Staff with `sell` use a placed register and build an order.
3. The customer accepts the total, pays by cash or card and receives the items.
4. Stock is reduced, the business is paid and the cashier earns their rank's commission.

Wages are handled by apex_banking in its Business tab. Invoices are handled by apex_billing.

## Businesses

- Admins list an unowned business for sale in Business setup and place a For sale sign so
  players can buy it.
- Admins can also give a business to an online player for free, or remove its owner.
- Owners can transfer or sell the venue from the Ownership tab.
- Customer shop points sell menu items from stock without staff.
- Crafting stations turn venue stock into new stock using recipes in `config/crafting.lua`.

## Clubs

- Place a Club entry desk, Bar and Throw-out spot from Locations.
- Customers buy Entry or VIP passes at the desk. VIP passes make bar drinks cheaper.
- Staff with `sell` mix drinks at the bar. The customer accepts, pays and drinks immediately.
- Staff with `security` can check passes, revoke them, throw people out and ban them.
- Managers set pass and drink prices and remove bans in the Club tab.
- Settings are in `config/club.lua`.

## Restaurants

1. Place a Stock room, Grill, Fryer, Prep station, Drinks machine and Register from Locations.
2. Order raw ingredients and cups in Stock, then complete the supply run.
3. Grill patties and fry sides. Finished food goes into venue stock.
4. Build burgers at the Prep station from grilled patties and ingredients.
5. Set sale prices in Menu and sell from the Register.

Recipes are in `config/crafting.lua`. A Crafting station can make every recipe.

Any venue can also place:

- **Seat:** aim at the chair's cushion. Players sit there and press E to stand. If they sit
  too high or low, use Move and adjust the height with the arrow keys.
- **Menu board:** shows customers the items with a sale price and whether they are sold out.

## Props

- Custom props are in `NDM_Business_assets`. Start it before this resource. If it is missing,
  prop locations fall back to invisible interaction points and the F8 console names the model.
- Each location in Locations is either an invisible interaction point or a physical prop.
- To change an existing location, pick a new Appearance on its row, press Move and place it.
- The props offered for each location type are in `config/props.lua`.

## Rules

- Keep the Pickle resources running until their replacement has been tested in-game.
- Never run the old and new system on the same venue.
- All database tables use the `ndm_business_` prefix.
- Never trust the client for money, entity IDs, distance or permissions.
- Record every ported or changed Pickle system in `NOTICE.md`.

## Bugs that must not be ported

- Deleting entities from client-supplied network IDs.
- Treating a failed customer charge or society deposit as success.
- Loyalty redemption that can be claimed twice.
- Clocked-in staff keeping access after losing the job or disconnecting.
- Supply run actions with no distance check.
