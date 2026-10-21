--RSVX_SAFE

--Player-Owned Safes for FiveM

--rsvx_safe is a player-owned safe system for FiveM that allows players to purchase, place and manage their own secure storage anywhere in the world. Players can buy a safe from a designated dealer, preview its placement in real time, store items inside, protect it with a PIN and collect it again when it’s empty.

--Requirements

--The resource requires the following dependencies:

--* ox_lib
--* ox_inventory
--* ox_target
--* oxmysql
--* One supported framework: qbx_core, qb-core or es_extended

--The framework is detected automatically.

--Installation

--1. Place the rsvx_safe folder into your server’s resources directory.
--2. Open install/items.lua and copy the safe item definition into ox_inventory/data/items.lua.
--3. Add the resource to your server configuration, ensuring it starts after all required dependencies:

--ensure ox_lib
--ensure ox_inventory
--ensure ox_target
--ensure oxmysql
--ensure rsvx_safe

--4. Restart your server or start the resource.

--Optional administrator permissions

--To allow members of the group.admin ACE group to access any safe, add the following to your server configuration:

--add_ace group.admin rsvx_safe.admin allow

--The rsvx_safes database table is created automatically on the resource’s first start.

--The safe uses the built-in GTA V prop prop_ld_int_safe_01, so no additional models or streamed assets are required. The inventory icon is also provided by the resource.

--How It Works

--1. Purchase a Safe

--Players can visit the Safe Dealer, marked on the map, and interact with the dealer using ox_target to purchase a safe.

--The purchase price, payment account and dealer location can all be configured in config.lua.

--2. Place Your Safe

--Once purchased, players can use the safe item from their inventory to enter placement mode.

--* Preview the safe’s position in real time.
--* Aim at a suitable surface to position the safe.
--* Use the Left and Right Arrow Keys to rotate it.
--* Press E to confirm placement.
--* Press Backspace to cancel.

--The safe item is only consumed once the server has successfully accepted the placement.

--3. Secure and Access Your Safe

--The owner can always access their own safe. Other players must enter the correct PIN set by the owner.

--If no PIN has been configured, only the owner can open the safe.

--Incorrect PIN attempts trigger a temporary lockout to help prevent repeated guessing. The number of permitted attempts and the lockout duration can be adjusted in config.lua.

--4. Store Items

--Safes provide dedicated inventory storage using ox_inventory. Slot capacity and maximum weight can be configured to suit your server’s economy and gameplay.

--5. Collect Your Safe

--Only the owner can collect their safe, and the safe must be completely empty.

--Once collected, the safe is returned to the owner’s inventory for future placement.

--6. Persistent Storage

--Safes are saved in the database and remain in the world between sessions and server restarts.

--To help manage performance, safes are loaded for players when they come within 80 metres of their location.

--Configuration

--All primary settings can be adjusted in config.lua.

--Setting	Description
--Price	Purchase cost of a safe
--Account	Account used to pay for the safe
--MaxPerPlayer	Maximum number of safes per player
--Slots	Number of inventory slots per safe
--MaxWeight	Maximum storage weight
--PlaceDistance	Maximum placement distance
--MinDistance	Minimum required distance for placement
--PinAttempts	Number of permitted incorrect PIN attempts
--LockoutSeconds	Duration of the PIN lockout
--Shop	Dealer location, ped settings, blip visibility and blip appearance

--Security and Technical Notes

--PIN Storage

--PINs are currently stored as plain text in the rsvx_safes.pin database column. They are intended as a convenient in-game sharing mechanism rather than high-security credentials.

--Players should never reuse PINs from their personal accounts or other real-world services.

--Inventory Storage

--Safe contents are managed by ox_inventory and stored in its existing ox_inventory database table. Each safe uses a unique inventory name in the following format:

--rsvx_safe_<id>

--Server-Side Validation

--Access to safes is checked server-side. However, as with other ox_inventory stashes, a modified client may attempt to interact with a stash directly.

--Servers running strict anti-cheat configurations should apply their usual ox_inventory stash protections and verify that unauthorised access attempts are blocked.

--⸻

--RSVX_SAFE provides a straightforward, persistent storage system for FiveM roleplay servers, giving players the freedom to own, position and secure their belongings while allowing server owners to customise storage capacity, pricing and access settings.