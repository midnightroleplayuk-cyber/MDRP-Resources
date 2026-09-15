# Integrations

## QB-Shops

Supported version: official `qbcore-framework/qb-shops` v1.5.0.

### Installation

1. Keep the resource folder name `fa_shoprobbery`.
2. Back up `qb-shops/client/main.lua`.
3. Copy `fa_shoprobbery/integrations/qb-shops/client/main.lua`.
4. Replace `qb-shops/client/main.lua` with the copied file.
5. Restart `fa_shoprobbery` and `qb-shops`, or restart the server.

No config changes or resource-order changes are required.

After startup, check the client console for one integration summary showing how many clerks were matched.

### How it works

The replacement automatically matches each FA clerk to the nearest ped-based QB-Shops location within 2 metres. It removes the duplicate QB-Shops ped and attaches the shop interaction to the FA clerk.

The shop interaction is available only while the clerk is idle. It is disabled when the clerk is surrendering, intimidated, hostile, dead, or disabled, and is attached again after the clerk respawns.

QB-Shops locations without a matching FA clerk continue to work normally.

### Test

1. Confirm there is only one clerk at the store.
2. Confirm the shop opens before a robbery.
3. Intimidate the clerk and confirm the shop interaction is unavailable.
4. Reset the store and confirm the shop interaction works again.

Do not use this replacement with a modified QB-Shops fork without comparing its `client/main.lua` first.
