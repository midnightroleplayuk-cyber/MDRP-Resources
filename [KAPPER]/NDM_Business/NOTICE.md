# Notice

NDM_Business is a Modified Work based on these Pickle Mods resources:

- `pickle_restaurants`
- `pickle_clubs`
- `pickle_businesses`

Original work is copyright © 2026 Pickle Mods & Pickle Mods Community Official Maintainers
and is used under the Pickle License, Version 1.0. The full licence is in `LICENSE`.

NDM_Business is not official, endorsed by, or affiliated with Pickle Mods.

It may not be sold or included in a paid pack. Anyone who receives a copy must also receive
the complete source and this licence.

## Third-party credits

- Coaster 3D models by NukePUG: https://forum.cfx.re/t/free-props-destillery/5274460/9
- jQuery Notify Extension: https://www.jqueryscript.net/demo/Simple-Flexible-jQuery-Alert-Notification-Plugin-notify-js/
- Money image by jannoon028 on Freepik: https://www.freepik.com/free-photo/one-hundred-dollars-banknotes-white-background_1012613.htm
- Credit card image by Freepik: https://www.freepik.com/free-vector/realistic-credit-card-design_18895415.htm

Keep these credits for any asset that is brought into this resource.

## Modifications

- 2026-11-24: Created the resource foundation.
- 2026-11-24: Added the core for Qbox, ox_inventory and apex_banking. Its job-rank permissions
  and society-account model are adapted from `pickle_restaurants`, with stricter payment
  checks, automatic reversal of failed transfers, and a venue model shared by all three types.
- 2026-11-24: Added a new management panel for staff, ranks and finances. Hire offers and the
  staff rules are adapted from `pickle_restaurants`; the panel itself is new code.
- 2026-11-24: Added in-world venue locations with a new placement tool and ox_target points.
- 2026-11-24: Added venue stock and supply runs. The carry pose, ingredient prices and
  paid-order concept are adapted from `pickle_restaurants`; the depot-to-vehicle-to-stock-room
  delivery loop is new code.
- 2026-11-24: Added register sales, sale prices and rank commission. The customer-confirmed
  charge and commission rules are adapted from `pickle_restaurants`. Wages are left to
  apex_banking instead of porting Pickle's payroll.
- 2026-11-24: Added business ownership, self-service shops and stock-based crafting. The buy,
  sell-back and transfer rules and crafting flow are adapted from `pickle_businesses`.
- 2026-11-24: Added club passes, bar service, drunk effects and player security. Drink data,
  pass prices and drunk thresholds are adapted from `pickle_clubs`; the bar flow is new code.
- 2026-11-24: Added optional physical props for locations and copied the Pickle restaurant and
  coaster props into `NDM_Business_assets`.
- 2026-11-24: Added restaurant grill, fryer, prep and drinks stations. Ingredient names and the
  raw-to-cooked-to-assembled food chain are adapted from `pickle_restaurants`; the
  stock-based station flow is new code.
- 2026-11-24: Added seats and menu boards. The seat animation and frozen-seat approach are
  adapted from `pickle_restaurants`; the seat tracking and board are new code.
