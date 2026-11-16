# apex_phone integrations

The phone can read from, and act through, the scripts your server already runs:

| Category | App | What it connects |
|---|---|---|
| `garage` | Garage | your garage resource (vehicle list, state, GPS, locate, delivery) |
| `bank` | Wallet | your banking resource (IBAN, frozen state, statement, logging of the phone's transfers) |
| `society` | Bills, job apps, Eats | company / job accounts (where company money goes) |
| `housing` | Home | your housing resource (my properties, keyed properties, GPS, lock, keys) |
| `billing` | Bills | bills from your billing resource, shown and paid in the app |
| `dispatch` | Services | police / EMS requests also sent to your dispatch or MDT |

You can use one of the resources supported out of the box, write your own adapter in `integrations/custom.lua`, or let another resource register itself at runtime.

**The phone always works on its own.** If nothing is configured, or the chosen resource is stopped, missing, or throws an error, the app falls back to the phone's built-in behaviour. A broken integration never breaks an app:

- a resource that is not started is simply not used;
- a function that errors is replaced by the built-in behaviour for that call;
- a function a provider does not offer (for example no statement) is answered by the built-in behaviour;
- the provider is resolved again whenever any resource starts or stops, so you never need to restart the phone.

When a fallback happens, the server console prints **one** warning that explains why (it is not repeated on every call).

---

## 1. Configuration (`config.lua`)

The settings live in the `Config.Integrations` section of `config.lua`:

```lua
Config.Integrations = {
    garage  = 'auto',
    bank    = 'auto',
    housing = 'auto',
    billing = 'auto',
    debug   = false,
}
Config.Integrations.society      = 'auto'
Config.Integrations.apartments   = 'auto'
Config.Integrations.dispatch     = 'auto'
Config.Integrations.dispatchJobs = {
    police    = { 'police', 'sheriff' },
    ambulance = { 'ambulance' },
}
Config.Integrations.dispatchOnly = false
Config.Integrations.dispatchCode = '911'
```

| Key | Accepted values | Default | Controls |
|---|---|---|---|
| `garage` | `'auto'`, `'builtin'`, `'custom'`, `'<id>'` | `'auto'` | Garage app |
| `bank` | `'auto'`, `'builtin'`, `'custom'`, `'<id>'` | `'auto'` | Wallet app |
| `society` | `'auto'`, `'builtin'`, `'custom'`, `'<id>'` | `'auto'` | company accounts: bills paid to a society, the billing module of the job apps, fines sent with the `CreateBill` export, Eats restaurant payouts |
| `housing` | `'auto'`, `'builtin'`, `'custom'`, `'<id>'` | `'auto'` | Home app |
| `apartments` | `'auto'`, `false`, `'qb-apartments'`, `'qbx_apartments'` | `'auto'` | starter apartments added to the Home app list (see [Housing](#housing-home-app)) |
| `billing` | `'auto'`, `'builtin'`, `'custom'`, `'<id>'` | `'auto'` | external bills in the Bills app |
| `dispatch` | `'auto'`, `'builtin'`, `'custom'`, `'<id>'` | `'auto'` | alerts sent from the Services app |
| `dispatchJobs` | table: service job (or service id) = list of job names | `police = { 'police', 'sheriff' }`, `ambulance = { 'ambulance' }` | which services are sent to the dispatch, and to which jobs |
| `dispatchOnly` | `true`, `false` | `false` | `true`: when the dispatch took the alert, the agents' phones are not notified |
| `dispatchCode` | string | `'911'` | code shown on the dispatch alert |
| `debug` | `true`, `false` | `false` | extra console lines from the integration layer |

What each value means:

| Value | Meaning |
|---|---|
| `'auto'` | Picks a provider automatically (order in [section 2](#2-how-auto-picks-a-provider)). |
| `'builtin'` | Always the phone's own behaviour ([section 3](#3-what-builtin-does)). |
| `'custom'` | Only a provider registered at runtime by another resource, or your adapter in `integrations/custom.lua`. If neither exists: `'builtin'` plus one warning. |
| `'<resource id>'` | Forces one supported resource, for example `garage = 'jg-advancedgarages'`. The name of a provider registered at runtime also works here. If the resource is not started, the phone uses `'builtin'` until it starts. An unknown id also falls back to `'builtin'` with a warning. |
| `false` | `apartments` only: do not show apartments. |

Notes:
- `society`: if you forced the older `Config.SocietyProvider` (top of `config.lua`) to one resource or to `'none'` and left `society` on `'auto'`, the phone keeps your old choice (`'builtin'`).
- `dispatchJobs`: if the key is missing from an older config, the phone uses `police = { 'police' }, ambulance = { 'ambulance' }`.

---

## 2. How 'auto' picks a provider

For each category, the first match wins:

1. a provider registered at runtime by another resource (`RegisterIntegration`; if there are several, the first by name, alphabetically);
2. your adapter in `integrations/custom.lua`, when that category is filled in;
3. the first supported resource that is started, in the order of the tables in [section 4](#4-supported-resources);
4. otherwise `'builtin'`.

Dedicated resources are checked before framework defaults (`qb-garages`, `esx_garage`, `qb-houses`, `esx_property`...), because many servers leave the default running next to the script they really use.

Only **one** provider is active per category. If two supported resources are started, the one higher in the table is used. To use the other one, set its id explicitly.

---

## 3. What 'builtin' does

| Category | Built-in behaviour |
|---|---|
| `garage` | Reads the framework vehicles table (`player_vehicles` on QBCore/QBox, `owned_vehicles` on ESX) and uses `Config.Garages` for the GPS. |
| `bank` | Uses the framework bank money. When `apex_banking` is started it also shows the IBAN, savings, frozen state and statement. |
| `society` | The society account resource chosen by `Config.SocietyProvider` (qb-banking, qb-management, Renewed-Banking or esx_addonaccount), as before. |
| `housing` | Uses `qb-houses`. Without it (and without apartments), the Home app says there is no housing system. |
| `billing` | The phone's own bills (`apex_phone_bills`). |
| `dispatch` | Only the phone's own Services notifications. |

The phone's own bills always stay in the Bills app, whatever billing provider is active. Bills issued in the app with a supported billing resource active stay phone bills (only a custom adapter with `create` can send them elsewhere).

---

## 4. Supported resources

**Verified**: the adapter was written against the resource's real source code. **Best effort**: the resource is encrypted or paid, so the adapter was written from the vendor's public documentation and has not been run against the real resource.

Tables are in `'auto'` order, top to bottom.

### Garage (Garage app)

List, state (in the garage / out / impounded), fuel, engine, body, GPS to the garage, Locate, Delivery. The adapters only **read** another resource's tables, with one exception: Delivery (below) writes the single "out" column of the vehicle it delivers. Locate always tries the vehicle's live position first, then what the garage resource knows.

| id | Status | What works |
|---|---|---|
| `apex_garage` | Verified | `in_garage`, `garage_id`, `nickname`, mileage. Impounds from `GetOpenImpounds`.<br>Locations from `GetConfiguredGarages`, created garages and private garages. Job and gang vehicles excluded. |
| `jg-advancedgarages` | Verified | `in_garage`, `impound` (wins), `garage_id`, `nickname`.<br>Coordinates from `getAllGarages` (v3 and v4), then `config/config.lua`, then `player_priv_garages`. |
| `cd_garage` | Best effort | `in_garage` 0 out, 1 in, 2 impound.<br>Label and coordinates from `GetGarageLocations` (v6); impound lot from `GetVehicleImpoundData`. |
| `okokGarage` | Best effort | QBCore: `state` column. ESX: `stored`, plus `impoundTime`.<br>Coordinates from its `config.lua`. |
| `qs-advancedgarages` | Best effort | `garage` (`'OUT'` when out; QBCore keeps `state`), job vehicles excluded.<br>Impound lots and coordinates from `player_garages`. |
| `vms_garagesv2` | Best effort | `garage` empty = out, `impound_date` = impounded, company and gang vehicles excluded.<br>Label and coordinates from `getGarageInfo`. |
| `codem-garagesv2` | Best effort | `GetPlayerVehicles`, `GetGarages`, `GetImpounds`, `GetImpoundData`. |
| `codem-garage` | Best effort | mGarage 1.3: `stored` (ESX) or `state` (QBCore), `parking`.<br>Coordinates from its `config.lua`. |
| `op-garages` | Best effort | Inverted `stored`/`state` (0 = in the garage), `isTowedOut`.<br>Labels and coordinates from `getGarageByIndex` / `getImpoundByIndex`. |
| `kartik-garages` | Best effort | `GetPlayerVehicles`, `GetGarage`; Locate uses `GetParkedVehicle`. |
| `tgiann-realparking` | Best effort | `GetPlayerVehicleDetails`, `GetGarageList`. Impounded cars point to the nearest impound. |
| `tgiann-garage` | Best effort | `stored`, `garageNumber`. No coordinates (its garages are client-only). |
| `ak47_garage` | Best effort | `stored` 0/1/2, `garage`, `customname`, `GetGarageById`; Locate uses `GetVehicleLocation`. |
| `ak47_qb_garage` | Best effort | QBCore `state` plus `depotprice`. |
| `zerio-garage` | Best effort | `stored`/`state`, `nickname`, labels from `GetGarages` / `GetImpounds`. |
| `renzu_garage` | Verified | `stored`/`state`, `impound`, `garage_id`/`garage`, nicknames from `GlobalState`.<br>Coordinates from its `conf/` files; Locate uses `park_coord`. |
| `rhd_garage` | Verified | `state`/`stored`; 0 and not in the world = insurance lot, 2 = police impound.<br>Coordinates from its `Garage` export. |
| `lunar_garage` | Verified | `stored`; out while the car exists in the world, else impounded.<br>GPS to the nearest garage or impound of the vehicle type. |
| `MojiaGarages` | Verified | `state` plus `depotprice` (depot); Locate uses the saved parking position. |
| `t1ger_garage` | Verified | `state`, `garage` (name plus vehicle type), `'impound'`, `seized`. |
| `esx_advancedgarage` | Verified | `stored` only: the resource does not tell "out" from "at the pound". |
| `qbx_garages` | Verified | `qbx_vehicles:GetPlayerVehicles` and `qbx_garages:GetGarages` (label plus access point). |
| `qb-garages` | Verified | Framework table plus `getAllGarages`. `state` 0 with a `depotprice` counts as impounded (depot), GPS to the depot. |
| `esx_garage` | Verified | ESX default, 2.0.0 and 1.x: `stored`, `parking`, `pound`, `custom_name`.<br>Labels and coordinates from `getGarages` / `getImpounds`. |

#### Delivery ("Request Delivery", `Config.GarageDelivery`)

A vehicle that is **in a garage** (never one that is out or impounded, never a boat or an aircraft) can be delivered to the player: the phone marks it out in the active garage resource, charges the fee, and the **server** creates it on the nearest free road (OneSync required), with its mods, fuel, the keys (server and client side of every key resource that is started) and a GPS waypoint. Every step that fails is undone in reverse order (vehicle deleted, money refunded, garage state restored), and the app always says what happened.

The "out" write is **one conditional UPDATE** on the framework vehicles table that also checks the values the phone just read, so a garage taking the same car out at the same moment can never produce two copies. It always includes the framework column (`owned_vehicles.stored = 0` on ESX, `player_vehicles.state = 0` on QBCore/QBox), plus:

| id | Also written |
|---|---|
| `apex_garage` | `in_garage = 0`, and the car is registered with `RegisterVehicleOutside` (its anti-dupe map) |
| `jg-advancedgarages`, `cd_garage` | `in_garage = 0` |
| `qs-advancedgarages` | `garage = 'OUT'` |
| `vms_garagesv2` | `garage = NULL` |
| `op-garages` | `stored`/`state = 1` instead of the framework column (1 means out there) |
| `tgiann-garage`, `ak47_garage`, `lunar_garage` | `stored = 0` |
| `t1ger_garage` | `state = 0` (also on ESX) |
| `qbx_garages` | the `vehicleid` state bag on the new vehicle |
| every other | the framework column only |

Only columns that exist are written. If none of them changes (a garage that keeps its state where the phone cannot see it), the delivery is refused and the console says so once; give `takeOut` / `putBack` in your adapter ([Garage](#garage-required-list)) for that garage. Other resources can listen to the server event `apex_phone:vehicleDelivered` (src, { cid, plate, netId, model, provider, price }). Console command `phonedelivery` prints whether delivery is on (and why not), the key resources fed and the last delivery.

### Bank (Wallet app)

In every supported bank the **personal balance is the framework bank money** (one exception: `tgg-banking`, see its row). The phone keeps moving money through the framework; the bank adds the IBAN, frozen state and statement, and records the phone's transfers in its own statement. Nothing appears twice: when the bank stores the movement and the phone can read its statement, the phone does not keep its own copy. When a bank has no statement the phone can read, the Wallet keeps showing the phone's own transfer lines.

| id | Status | What works |
|---|---|---|
| `apex_banking` | Verified | Handled by `builtin`: IBAN, savings, frozen state, statement. |
| `Renewed-Banking` | Verified | IBAN (citizenid), frozen state, statement from `getAccountTransactions` or `player_transactions`.<br>Transfers recorded with `handleTransaction`. Players that Renewed-Banking has not loaded (offline) keep the phone's own line: the phone never writes Renewed's tables. |
| `okokBanking` | Best effort | IBAN from `users.iban` (ESX) or `charinfo.account` (QBCore). Statement from `GetPlayerTransactions` (v2) or `okokbanking_transactions` (v1). Transfers recorded with `AddTransaction` (v2).<br>Only chosen when `wasabi_banking` and `lwk_bank` are not started (both can stand in for okokBanking). |
| `tgg-banking` | Best effort | IBAN, frozen state and balance from `GetPersonalAccountByPlayerId`. Transfers logged in its statement with `AddTransaction`. No public statement export, so the Wallet shows the phone's own lines.<br>The balance shown is tgg's account balance; it has not been confirmed that it always equals the framework bank money. |
| `ps-banking` | Verified | Statement from `ps_banking_transactions`. ps-banking already logs online players itself, so the phone only adds rows for offline players. |
| `qb-banking` | Verified | Version 2.x only (the 2024 rewrite). Account number from `charinfo.account`, statement from `bank_statements`, transfers recorded with `CreateBankStatement`. |
| `pefcl` | Verified | Account number and statement from `pefcl_accounts` / `pefcl_transactions`. Needs pefcl's framework bridge (qb-pefcl / pefcl-esx), which already logs every bank change of an online player, so the phone adds no second line. |
| `fd_banking` | Best effort | IBAN and frozen state from `getPersonalAccount`. No public statement export. |
| `qs-banking` | Best effort | The phone's transfers are added to the player's feed with `AddTransaction`. No public account export. |
| `kartik-banking` | Best effort | Account number and status from `GetAccountDataByOwner`; transfers logged with `LogBankTransaction`. |
| `wasabi_banking` | Best effort | IBAN from `GetAccountsByPlayer`, frozen state from `IsAccountFrozen`; transfers logged with `Transaction`. |
| `crm-banking` | Best effort | IBAN from `getPlayerAccounts`, frozen state from `isAccountFrozen`; transfers logged with `addTransaction`. |
| `snipe-banking` | Best effort | Frozen state from `IsAccountFrozenForIdentifier`; transfers logged with `CreatePersonalTransactions`. |
| `nfs-banking` | Best effort | IBAN and frozen state of the main card (`getPlayerMainCardIban` / `getCardByIban`); transfers logged with `registerTransaction`. |
| `esx_banking` | Verified | ESX only. Statement from the `banking` table; transfers logged with `logTransaction` (online) or written to the same table (offline). esx_banking has no IBAN.<br>Only chosen when the `logTransaction` export exists (the official esx_banking); other resources with the same name stay on `builtin`. |

### Society (company accounts)

Where the money goes when a bill issued on behalf of a company is paid (Bills app, the billing module of the job apps, fines sent with the `CreateBill` export), and where Eats restaurant payouts go.

| id | Status | What works |
|---|---|---|
| `apex_bossmenu` | Verified | Treasury exports (`GetTreasury`, `AddTreasury`, `RemoveTreasury`); every payment is also written to the treasury history. |
| `Renewed-Banking` | Verified | Job accounts (the society store of qbx_core). Payments appear in the account history. |
| `qb-banking` | Verified | Version 2.x job accounts. qb-banking writes the statement itself. |
| `qb-management` | Verified | Only the versions that still hold money (2.1.x and older, detected by their money exports). Newer versions keep the money in qb-banking. |
| `okokBanking` | Best effort | Societies found in `okokbanking_societies`. If okokBanking keeps societies in another resource, `builtin` is used. Not chosen when `wasabi_banking` or `lwk_bank` is started. |
| `tgg-banking` | Best effort | Society accounts must exist in tgg-banking (created by an admin). Payments appear in its history. |
| `fd_banking` | Best effort | `GetAccount`, `AddMoney`, `RemoveMoney`. |
| `qs-banking` | Best effort | `GetSocietyMoney`, `AddSocietyMoney`, `RemoveSocietyMoney`. |
| `kartik-banking` | Best effort | `GetAccountMoney`, `AddAccountMoney`, `RemoveAccountMoney`. |
| `wasabi_banking` | Best effort | `GetAccountBalance`, `AddMoney`, `RemoveMoney` (society accounts). |
| `tgiann-bank` | Best effort | `GetJobAccountBalance`, `AddJobMoney`, `RemoveJobMoney`. |
| `crm-banking` | Best effort | Society money exports; payments appear in the society history. |
| `snipe-banking` | Best effort | Account money exports; payments appear in the job history. |
| `esx_addonaccount` | Verified | `society_<job>`, or the account registered in esx_society. |

Not supported: `qbx_management` and `ps-banking` hold no company money (on Qbox it lives in Renewed-Banking).

Money safety for societies:
- a withdrawal is refused when the account does not hold enough money, even in resources that would go negative;
- if the job has no account in the active resource, the phone uses `'builtin'` for that payment;
- if the other resource throws an error while moving the money, the phone does **not** try a second place (it could pay twice): a society bill is then paid to the person who issued it.

### Housing (Home app)

The phone checks that the property is in the player's own list before any lock or key action, and that the player is the owner before giving or removing keys. When a property cannot be locked or shared from the phone, the app says so instead of failing silently.

| id | Status | What works |
|---|---|---|
| `ps-housing` | Verified | List: yes, including apartments and MLO properties.<br>Lock: MLO doors through `ox_doorlock`, or through the `qb-doorlock` copy that ps-housing ships (shells and apartments have no lock in ps-housing).<br>Keys: yes (`UpdateHas_access`), MLO door access included. |
| `kartik-properties` | Best effort | List: owned, rented and keyed. Lock: yes. Keys: yes. |
| `tk_housing` | Best effort | List: owned and keyed. Lock: yes. Keys: yes. |
| `nolag_properties` | Best effort | List: yes. Lock: yes. Keys: yes (its own permission checks). |
| `bcs_housing` | Best effort | List: yes. Lock: IPL and shell homes. Keys: yes. |
| `vms_housing` | Best effort | List: owned, rented and keyed. Lock and keys: no server API. |
| `qs-housing` | Best effort | List: yes. Lock and keys: no public API. |
| `RxHousing` | Best effort | List: owned and keyed. Lock: no lock export. Keys: yes. |
| `origen_housing` | Best effort | List: owned properties. No lock, no keys. |
| `ak47_qb_housing` | Best effort | List: owned properties. No lock, no keys. |
| `ak47_housing` | Best effort | List: owned properties. No lock, no keys. |
| `loaf_housing` | Best effort | List: owned properties. No lock, no keys. |
| `qbx_properties` | Verified | List: yes (apartments included). Lock: no lock concept. Keys: yes. |
| `qb-houses` | Verified | Handled by `builtin`. |
| `esx_property` | Verified | List: yes, with the real lock state and the garage (also the old 1.x version). Lock and keys: no server API. |

**Apartments.** `qb-apartments` and `qbx_apartments` (both Verified) are not a housing system of their own: their apartments are **added** to the list of whatever housing provider is active, including `builtin`, with GPS to the building door. They have no keys and no lock. Set `Config.Integrations.apartments = false` to hide them, or force one of the two ids.

### Billing (Bills app)

Bills from these resources (police fines, mechanics and so on) appear **next to** the phone's own bills and can be paid from the app. Payment comes from the bank (except `peleg-billing`, see its row). Resources with a pay export are paid through it, so their own fees, VAT and society payouts apply; the phone locks the bill while the call runs. Resources paid through their table use an atomic claim of the row. Either way a double tap can never pay twice. The money goes to the society account, or to the issuer when there is no society.

| id | Status | What works |
|---|---|---|
| `wasabi_billing` | Best effort | Exports only (`GetInvoicesByIdentifier`, `PayInvoiceByReference`, `CancelInvoice`).<br>Checked first because it also provides `okokBilling` / `esx_billing`. |
| `apex_billing` | Verified | Exports `ListReceivedFor`, `PayInvoice`, `DeclineInvoice`, `CancelInvoice`. Its own fees, VAT and society payout apply.<br>If `apex_billing` and `esx_billing` both run, `'auto'` picks `apex_billing`; set `billing = 'esx_billing'` to use the other. |
| `elevate_billing` | Verified | Same as `apex_billing`. |
| `bs_billing` | Verified | Exports `GetBillHistoryBySource`, `PayBill`, `GetIssuedBillHistoryBySource`, `CancelBill`. |
| `peleg-billing` | Verified | Exports `GetBillsByCid`, `PayBill`. Charges the account written on the bill (cash or bank). |
| `okokBilling` | Best effort | Table `okokbilling`. Paying charges the value plus fees. |
| `qs-billing` | Best effort | Table `qs_billing`. Paying charges the value plus fees. |
| `esx_billing` | Verified | Table `billing`. Not used while `billing_ui` is running (same table name, different columns). |
| `jim-payments` | Verified | Only when the `phone_invoices` table exists (jim-payments writes bills there only for qb-phone). |
| `qb-phone` | Verified | Table `phone_invoices`. Detected on QBCore/QBox whenever the table exists, even without qb-phone running. |

Not supported: codem-billing (no public read/pay API), billing_ui (undocumented table with an in-memory cache), brutal_billing.

### Dispatch (Services app)

When a player calls a service from the **Services** app, the request still reaches the phones of the on-duty agents as before. When the service's job is listed in `dispatchJobs`, the request **also** becomes an alert in your dispatch or MDT, with the caller's name, number, message and GPS position.

- The keys of `dispatchJobs` are the `job` of each entry in `Config.Services` (or its `id`); the values are the jobs your dispatch sends the alert to. Services not listed (mechanic, taxi...) stay phone only. Add `mechanic = { 'mechanic' }` to send them too.
- With a dispatch active, agents of the other mapped jobs (for example `sheriff` for `police`) also count for "nobody on duty".
- The position is the one sent by the phone, or the player's position on the server when the phone sent none or it is more than 150 m away.
- If the dispatch fails or refuses the alert, the phones are always notified (one console warning). With `dispatchOnly = true`, the phones are notified only in that case.
- Systems that receive the alert through an event (not an export) cannot confirm delivery, so the phone treats the alert as taken.

| id | Status | What works |
|---|---|---|
| `apex_mdt` | Verified | `CreateCall`. Police and EMS calls (mode from apex_mdt's `Config.jobs`). |
| `ps-dispatch` | Verified | 3.x: `SendTargetedAlert` (added to the call list). 2.x: `ps-dispatch:server:notify`. Jobs can be job names or QBCore job types (`leo`, `ems`). |
| `cd_dispatch` | Best effort | `cd_dispatch:AddNotification` (server method from the docs). |
| `qs-dispatch` | Best effort | `qs-dispatch:server:CreateDispatchCall`. |
| `rcore_dispatch` | Best effort | `rcore_dispatch:server:sendAlert`. |
| `core_dispatch` | Best effort | Server export `sendAlert`. |
| `tk_dispatch` | Best effort | Server export `addCall` (with the phone number field). |
| `linden_outlawalert` | Verified | `wf-alerts:svNotify` (ESX). |
| `lb-tablet` | Best effort | `AddDispatch`, caller and number as fields. |
| `kartik-mdt` | Best effort | V2 `CreateCall`. |
| `origen_police` | Best effort | Server export `SendAlert` (first mapped job). |
| `wasabi_mdt` | Best effort | `CreateDispatch`. Police services only. |
| `redutzu-mdt` | Best effort | `addDispatchToMDT`. Police services only. |
| `ND_MDT` | Verified | `createDispatch`. Police services only. |

---

## 5. Your own adapter (`integrations/custom.lua`)

This file is **never encrypted**. Fill in only the categories you need and leave the others as `nil`. With `'auto'`, a filled-in adapter wins over the supported resources. With `'custom'`, only your adapter (or a registered provider) is used.

Every function runs on the **server**. Most receive:
- `src`: the player's server id;
- `cid`: the character id the phone uses (the citizenid on QBCore/QBox, the identifier on ESX).

If one of your functions errors, the phone prints one warning and uses its built-in behaviour for that call. A supported adapter in `server/integrations/<category>.lua` is a good starting point: copy it into `custom.lua`, adapt it there and set the category to `'custom'`.

### Garage (required: `list`)

```lua
Custom.garage = {
    -- every vehicle of the player
    list = function(src, cid)
        local rows = MySQL.query.await('SELECT plate, model, garage, state, fuel FROM my_vehicles WHERE owner = ?', { cid }) or {}
        local out = {}
        for _, r in ipairs(rows) do
            out[#out + 1] = {
                plate  = r.plate,                 -- required
                model  = r.model,                 -- spawn name, e.g. 'sultanrs'
                label  = nil,                     -- optional display name ('Sultan RS')
                garage = r.garage,                -- garage id or name shown in the app
                state  = r.state,                 -- 'garage' | 'out' | 'impound' (also 1 / 0 / 2 or true / false)
                fuel   = r.fuel,                  -- 0-100 (optional)
                engine = nil, body = nil,         -- 0-1000 (optional)
                coords = nil,                     -- { x = , y = , z = } of the garage, for the GPS button
            }
        end
        return out
    end,
    -- optional: engine/body/mileage for the detail screen (else the values from list are used)
    detail = function(src, cid, plate) return { engine = 1000, body = 1000, mileage = 1200 } end,
    -- optional: where the vehicle is when the player cannot see it ({ x, y, z } or nil)
    track = function(src, cid, plate) return nil end,
    -- optional (delivery): mark the vehicle OUT of your garage. Return true ONLY when it was in the garage and is now
    -- out (one conditional UPDATE, so two requests can never both win). If the spawn then fails, putBack is called.
    takeOut = function(src, cid, plate)
        return (MySQL.update.await('UPDATE my_vehicles SET state = 0 WHERE owner = ? AND plate = ? AND state = 1', { cid, plate }) or 0) == 1
    end,
    putBack = function(src, cid, plate)
        return (MySQL.update.await('UPDATE my_vehicles SET state = 1 WHERE owner = ? AND plate = ? AND state = 0', { cid, plate }) or 0) == 1
    end,
}
```

Without `takeOut`, delivery writes the framework column (`stored` / `state`), see [Delivery](#delivery-request-delivery-configgaragedelivery).

### Bank (all functions optional: give the ones your bank has)

```lua
Custom.bank = {
    -- balance shown in the Wallet (nil = the framework bank money)
    balance = function(src, cid) return exports['my_bank']:GetBalance(cid) end,
    -- account data: iban/account number, savings, frozen, noAccount (true = "open an account at the bank")
    info = function(src, cid) return { iban = 'MB123456', savings = 0, frozen = false } end,
    -- statement rows, newest first: amount is SIGNED (negative = money out), created in ms or seconds
    history = function(src, cid)
        return { { id = 1, description = 'Salary', amount = 1500, created = os.time() } }
    end,
    -- the bank moves the money itself. Return true, or false + 'funds' | 'target' | 'frozen' | 'amount'.
    -- Return nil to let the phone move the framework bank money (then `record` is called for both sides).
    transfer = function(src, cid, toCid, amount, note, toNumber)
        return nil
    end,
    -- the phone moved framework money: store the movement in your bank's statement. Return true when stored
    -- (with `history` too, the phone then does not keep its own copy, so nothing shows twice)
    record = function(cid, description, amount, src) return false end,
}
```

### Society (required: `add`; give `remove` and `balance` too)

`job` is the job name (`'police'`, `'mechanic'`...). The phone only passes whole amounts greater than 0. A missing `remove` or `balance` is answered by the built-in behaviour.

```lua
Custom.society = {
    balance = function(job) return exports['my_bank']:GetSocietyBalance(job) end,              -- number, or nil = unknown
    add     = function(job, amount, reason) return exports['my_bank']:AddSocietyMoney(job, amount, reason) == true end,
    remove  = function(job, amount, reason) return exports['my_bank']:RemoveSocietyMoney(job, amount, reason) == true end,
}
```

Rules for `add` / `remove`:
- return `true` only when the money really moved;
- return `false, 'noaccount'` when the job has no account in your system: the phone then uses its built-in behaviour;
- any other `false` is final (the phone does not try elsewhere);
- `remove` must refuse when the account does not hold enough money. Never move the money twice.

### Housing (required: `list`)

```lua
Custom.housing = {
    -- houses the player OWNS or has a KEY to
    list = function(src, cid)
        return {
            {
                id = 'house_12',                         -- required, unique, used by lock/giveKey/removeKey
                label = '12 Grove Street',
                owner = true,                            -- true = the player owns it
                ownerCid = nil,                          -- for keyed houses: the owner's cid (name is looked up)
                coords = { x = 0.0, y = 0.0, z = 0.0 },  -- door, for the GPS button
                garage = nil,                            -- { x, y, z } of the house garage (optional)
                locked = true,                           -- nil = the phone remembers what it last set
                tier = 1,                                -- 1 apartment, 3 house, 5 mansion (only the icon text)
                keyholders = { { cid = 'ABC123' } },     -- only for owned houses (names/numbers are filled in)
                -- lockable = false,                     -- optional: this one cannot be locked from the phone
                -- keys = false,                         -- optional: keys cannot be given/removed for this one
            },
        }
    end,
    -- lock or unlock (locked = true/false). Return true, or false + 'nokey'
    lock = function(src, cid, houseId, locked) return true end,
    -- give a key to an ONLINE player (targetSrc) / remove a key (targetCid). Return true or false + reason
    giveKey = function(src, cid, houseId, targetSrc, targetCid) return false end,
    removeKey = function(src, cid, houseId, targetCid) return false end,
}
```

Before calling `lock`, `giveKey` or `removeKey`, the phone checks that the house is in the player's own list, and for keys that the player is the owner. Your functions only need to do the action.

### Billing (required: `list`)

```lua
Custom.billing = {
    -- bills the player RECEIVED (pending and history)
    list = function(src, cid)
        return { { id = 7, sender_name = 'LSPD', society = 'police', amount = 250, reason = 'Speeding',
                   status = 'pending', created = os.time() } }   -- status: pending | paid | refused | cancelled
    end,
    -- pay bill `billId` (your own id). Return true, or false + 'funds' | 'invalid'
    pay = function(src, cid, billId) return false, 'invalid' end,
    -- a player issued a bill in the app (already validated: amount, cap, society rank, cooldown).
    -- Return true, false + reason, or nil to keep it as a phone bill. opts = { society, senderName, toSrc }
    create = function(src, cid, toCid, amount, reason, opts) return nil end,
    -- bills the player SENT: { id, toCid, amount, reason, status, created }
    sent = function(src, cid) return {} end,
    refuse = function(src, cid, billId) return false end,
    cancel = function(src, cid, billId) return false end,
}
```

### Dispatch (required: `alert`)

```lua
-- data = { id, service, label, job, jobs = { 'police', 'sheriff' }, caller, phone, cid, message,
--          coords = { x, y, z }, street?, code }
Custom.dispatch = {
    alert = function(src, data)
        TriggerEvent('my_dispatch:server:newCall', {
            title = data.label, message = data.message, caller = data.caller, phone = data.phone,
            coords = data.coords, jobs = data.jobs, code = data.code,
        })
        return true   -- true = your dispatch took the alert
    end,
}
```

`alert` is only called for services listed in `dispatchJobs`. With `dispatchOnly = true`, the phones are notified only when `alert` returns `false` or errors.

---

## 6. Registering from another resource

A garage, bank, housing, billing, society or dispatch script can plug itself in, without editing the phone:

```lua
-- server side of YOUR resource
local function registerWithPhone()
    exports.apex_phone:RegisterIntegration('garage', {
        list = function(src, cid)
            return MyGarage.GetVehiclesForPhone(cid)   -- same shape as Custom.garage.list
        end,
    }, 'my_garage')                                    -- name optional (defaults to your resource name)
end

CreateThread(function()
    if GetResourceState('apex_phone') == 'started' then registerWithPhone() end
end)
-- registrations live in the phone's memory: register again when the phone (re)starts
AddEventHandler('onResourceStart', function(res)
    if res == 'apex_phone' then registerWithPhone() end
end)
```

| Export | Returns |
|---|---|
| `exports.apex_phone:RegisterIntegration(category, impl, name?)` | `true`, or `false` + `'category'` (unknown category) / `'impl'` (the required function is missing) |
| `exports.apex_phone:UnregisterIntegration(category, name?)` | `true` when something was removed |
| `exports.apex_phone:GetIntegration(category)` | the active provider id: `'builtin'`, `'custom'`, `'registered:<name>'` or a supported id |

- `category` is one of `'garage'`, `'bank'`, `'society'`, `'housing'`, `'billing'`, `'dispatch'`, `'number'` (1.1.8). The required function is the same as in `custom.lua` (`list`, `add`, `alert`, `assign`...; for `bank`, any one function).
- The provider is removed automatically when your resource stops.
- With `'auto'` or `'custom'`, a registered provider wins over `integrations/custom.lua`. With `Config.Integrations.garage = 'my_garage'`, that name is forced.
- **Function references:** the functions you pass reach the phone as cross-resource function references (they are tables, not Lua functions, on the phone's side). The phone handles that for you. Arguments and return values cross the resource boundary, so return plain data (tables, strings, numbers, booleans).
- If one of your functions errors, the phone prints one warning and uses its built-in behaviour for that call.

---

## 7. Console command and debug

Run `phoneintegrations` in the server console (or in game as an admin). It prints:

- the active provider of each category, with `(best effort)` next to best-effort ones;
- for each category: the configured value, the supported resources (`*` = started, `?` = best effort), the providers registered at runtime (with the resource that registered them) and whether `integrations/custom.lua` is filled in.

The same one-line summary is printed about 3 seconds after the phone starts, and a line is printed whenever the active provider of a category changes (for example `garage -> jg-advancedgarages`).

`Config.Integrations.debug = true` prints extra lines from the integration layer (currently every society payment and its result). Leave it `false` in production.

---

## 8. Troubleshooting

**The app still shows the phone's own data.**
Run `phoneintegrations`. It shows what is active. A warning line printed earlier explains any fallback: a resource that is not started, an unknown id, `'custom'` with nothing filled in, or a function that threw.

**Which provider is active?**
`phoneintegrations` in the console, or `exports.apex_phone:GetIntegration('<category>')` from another resource.

---

## 9. Another phone system next to the phone: numbers, SIM cards, serials ("IMEI"), billing (1.1.8)

Everything below works in the escrowed build: `integrations/custom.lua`, `config.lua`, `server/framework.lua` and the
locales stay editable, the exports and events are public.

**Keeping existing numbers.** A new phone account takes its number from, in this order: your `number` adapter, the
framework's character data (`charinfo.phone` on QBCore/QBox, `users.phone_number` on ESX), a random number in
`Config.NumberFormat`. So a server that already stores numbers on the character keeps them without doing anything. For
numbers kept somewhere else:

```lua
-- integrations/custom.lua
Custom.number = {
    assign = function(cid, src)   -- called once, when the character sets the phone up
        return MySQL.scalar.await('SELECT phone FROM my_phone_numbers WHERE owner = ? LIMIT 1', { cid })   -- '555-0123' or nil
    end,
}
```

A number another phone account already has is refused (console warning) and the phone falls back to its own choice.
`Config.SyncNumberToCharInfo = true` writes the final number back to the framework's character data.

**Changing a number later** (a SIM swap in your system, an admin tool):
`exports['apex_phone']:SetNumber(citizenidOrSrc, '555-0123', 'my_system')` → `true, nil, oldNumber` or
`false, 'format' | 'same' | 'noaccount' | 'taken' | 'db'`. It is the same code path as `/phonenumber`: the account, the
active eSIM line, the framework character data and the state bag of an online player are updated, the phone refreshes,
and `apex_phone:numberChanged` fires. Works for offline characters too (the account and line change; the player's
framework data follows the next time the number is synced).

**Events to keep your side in sync** (server, `AddEventHandler`):
`apex_phone:accountCreated` (cid, number, src) · `apex_phone:numberChanged` (cid, old, new, by) ·
`apex_phone:callStarted` (callId, callerSrc, calleeSrc) · `apex_phone:callAnswered` (callId) · `apex_phone:callEnded`
(callId, reason) · `apex_phone:messageSent` (message) · `apex_phone:billPaid` / `apex_phone:billRefused` (src, bill).
Lookups: `GetNumber(cid)`, `GetCitizenId(number)`, `GetSourceByNumber(number)`, `GetPlayerLines(src)` (eSIM lines).

**Persistent device serial ("IMEI").** With `Config.StolenPhones.enabled = true` or `Config.PhysicalSim.enabled = true`
every phone item gets `apex_serial` (`APX-XXXX-XXXX-XXXX`), `apex_owner` and `apex_number` in its item metadata the first
time someone uses it (ox_inventory, qb-inventory and the inventories with per-slot metadata). The serial follows the
item through stashes, trades and thefts. Read it with `exports['apex_phone']:GetDeviceSerial(src)` (the device the player
is using) or list a character's devices with `GetDeviceLocations(citizenid)` (`{ item, label, serial, x, y, z, open }`
for every device held by an online player); any inventory export that reads metadata sees the same `apex_serial`.
Without a metadata inventory there are no serials (nothing to attach them to).

**Physical SIM cards.** `Config.PhysicalSim.enabled = true` (see the README): the number lives on a `sim_card` item
(`iccid`, `number` in its metadata) that moves between phones. Exports: `GetPlayerSim(src)` → `{ serial, item, iccid,
number }` of the SIM in the active phone, `GetSimInDevice(serial)` → `{ iccid, number }`, `GiveSimCard(src, number)` →
creates a card with that number (or a new one) in the player's inventory; a number that already belongs to that character
but is not in his hands is RE-ISSUED on a new card for free (the old card is cancelled), a number he already has is refused
(`'notlost'`), somebody else's number is refused (`'taken'`). `RecoverSimCard(src, number)` (1.3.0) → `number | nil, err`
does the same re-issue through the player path (`Config.PhysicalSim.recover`, price charged). Server events:
`apex_phone:simInserted`, `apex_phone:simEjected` and `apex_phone:simRecovered (src, number, oldIccid, newIccid)`.
Together with `SetNumber` this is enough to mirror a SIM database: create the card with your number, and when your
system moves a number, call `SetNumber`.

**Billing.** `Custom.billing` (section 5) shows your bills in the Bills app and lets the phone pay / refuse / cancel them
through your functions (`list`, `pay`, `create`, `sent`, `refuse`, `cancel`); the phone's own bills stay next to them.
To push a bill into the phone from your side: `exports['apex_phone']:CreateBill(citizenidOrNumber, { senderName, amount,
reason, society })`, then listen to `apex_phone:billPaid` / `apex_phone:billRefused`.

**Not possible without the source:** changing how the phone stores its own data (tables `apex_phone_*`) or replacing the
call/SMS engine; the escrowed build exposes the hooks above instead.

**Two supported resources are running and the wrong one is used.**
Only one provider is active per category, the first in the table. Set the one you want explicitly, for example `housing = 'ps-housing'` or `billing = 'esx_billing'`.

**A supported resource is detected but you want the phone's own behaviour.**
Set that category to `'builtin'`.

**Company money goes to the wrong account.**
Look at the `society` line of `phoneintegrations`, or set `society` to the id you want. If you use the older `Config.SocietyProvider`, see the note in [section 1](#1-configuration-configlua).

**Can money be lost or paid twice?**
- Bank: the personal balance stays the framework bank money; supported banks only add information and log the phone's movements. Only your own `transfer` function can move money in another system.
- Bills: every external bill is locked or claimed atomically before it is charged, so a double tap can never pay twice. If charging fails, the bill is put back.
- Society: withdrawals are refused without enough money; an error inside another resource is never retried elsewhere.
- Garage: the adapters only read; Delivery writes one conditional "out" update for a vehicle the server proved is the player's and in a garage, before any money moves, and puts it back if anything after it fails. Housing: lock and key actions run only after the phone's ownership checks.
- Dispatch: if the dispatch fails or refuses, the agents' phones are notified.

**What does "Best effort" mean in practice?**
The resource is encrypted or paid, so its adapter follows the vendor's public documentation and has not been run against the real resource. If a vendor changed its database or exports, the phone falls back to `'builtin'` and prints one warning. Copy that adapter from `server/integrations/<category>.lua` into `integrations/custom.lua`, adapt it there and set the category to `'custom'`.

**My resource is not in the tables.**
Write an adapter in `integrations/custom.lua` ([section 5](#5-your-own-adapter-integrationscustomlua)), or have your resource call `RegisterIntegration` ([section 6](#6-registering-from-another-resource)).
