# NDM_Business

One resource for restaurants, clubs and player-owned businesses on Qbox, ox_inventory and oxmysql.

## Build order

1. **Core:** business records, job and rank permissions, safe money movement, audit log.
2. **Shared tools:** placement, targets, staff, payroll, stock, register and management UI.
3. **Businesses:** locations, listings, crafting, billing, market and supply stores.
4. **Clubs:** bartending, drinks, bouncers, entry and passes.
5. **Restaurants:** cooking, dining, kiosks, screens, delivery and phone app.
6. **Cutover:** migrate data one venue type at a time, then retire that Pickle resource.

## Testing the core

These commands require `group.admin`:

- `/ndmbiz_create <restaurant|club|business> <job> <name>`
- `/ndmbiz_list`
- `/ndmbiz_balance <venue>`
- `/ndmbiz_perms <venue> <player>`

Bosses, venue owners, admins and staff with management permissions can open the panel with
`/business`. Staff with `manage_venue` can place management desks, registers and stock rooms
from its Locations tab.

## Supply runs

1. An admin places a depot with `/ndmbiz_depot_add <name>`.
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

- `/ndmbiz_setprice <venue> <price>` lists an unowned venue. Place a For sale sign so players can buy it.
- `/ndmbiz_owner <venue> <player>` gives a venue to a player for free.
- `/ndmbiz_clearowner <venue>` removes its owner.
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
