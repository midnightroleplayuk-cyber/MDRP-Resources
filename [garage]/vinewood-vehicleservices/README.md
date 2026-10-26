# vinewood-vehicleservices

Motor insurance from NPC broker offices, MOT testing by the mechanic job, and vehicle
tax (VED) with SORN, for Qbox,
QBCore and ESX. Works on its own, and plugs into **vinewood-mdt** (see `INTEGRATION.md`).

Requires `ox_lib` and `oxmysql`. `ox_target` and `ox_inventory` are used when running.
Tables are created on start; `sql/install.sql` is there if you prefer to run it yourself.

## Insurance
- Broker peds and blips from `Config.Insurance.brokers` (ox_target, or [E] text UI).
- The menu lists the player's registered vehicles with current insurance and MOT status.
- Cover: Third Party Only, Third Party Fire & Theft, Comprehensive. Terms: 7/14/30 days.
- Premium = (base + vehicle value x cover rate) x cover multiplier x points loading x term.
  Vehicle value comes from qbx_core / QBCore shared vehicles / ESX `vehicles` table.
- Comprehensive can add **any driver**. Any cover can name up to 3 drivers, who must be
  stood with the policyholder when it's bought.
- Points loading and refusing disqualified drivers use `Config.GetLicence` - point it at
  your citydriving export.
- Buying cover for an insured vehicle replaces the old policy with a part refund.
  Policies can be cancelled at a broker for `cancelRefund` of the unused premium.
- If the vehicle changes keeper, the policy shows as **void** (`voidOnKeeperChange`).

## MOT
- Testers carry out MOTs via ox_target on any vehicle or `/mot` next to it, at an
  approved garage (see *Mechanic scripts* below for where and who).
- Basic checks the game can see: headlamps, tyres, windscreen, doors, body and engine
  health, plate. The tester then ticks brakes, steering, seatbelts, horn, exhaust and
  mirrors, and can add advisories.
- Any defect fails. Brakes, steering, tyres and serious body damage are **dangerous** -
  a dangerous fail overrides a still-valid MOT.
- Passing within `carryOverDays` of expiry keeps the old expiry date (like a real MOT).
- The tester enters the customer's server ID to charge the fee. Tester gets
  `testerCommission`; the rest goes to `Config.MOT.society` if you set it.
- The vehicle, plate, garage and tester's job are all checked server-side.

- `/motstations` lists every approved MOT station, nearest first, with the road, distance
  in miles and how many authorised testers are on duty (stations with testers on duty
  are listed first). Click one to set a waypoint.
- The odometer is recorded on every test (jg-vehiclemileage, converted to miles, or your
  own `Config.MOT.GetMileage`). A lower reading than the last test is added as an advisory.

## Vehicle tax (VED) and SORN
- Tax with `/tax` anywhere (like GOV.UK) or at a broker. Set `Config.Tax.online = false`
  to make it broker-only.
- Like the real thing, a vehicle needs insurance and a current MOT before it can be taxed
  (`requireInsurance`, `requireMOT`).
- Bands by vehicle value (A-D, D being the expensive car supplement), 7 or 30 days.
- Taxing an already-taxed vehicle adds on from the current end date.
- SORN declares a vehicle off the road. SORN or cancelling tax refunds unused full days.
- Tax and SORN end when the vehicle changes keeper (`endsOnKeeperChange`).
- In the MDT: a VED row, plus "Untaxed" and "SORN vehicle on the road" ANPR hits.

## Mechanic scripts
`Config.MOT.provider = 'auto'` picks this up for you.

**jg-mechanic**
- Every `owned` location in jg-mechanic's `Config.MechanicLocations` becomes an MOT
  station (its size plus `locationPadding`). No coordinates to copy over.
- Framework jobs (`UseFrameworkJobs = true`): the tester's active job must match that
  location's `job`.
- Built-in jobs: the tester must be an employee of that location in jg's employee table
  (`employeesTable` / column names in config). This table is checked on start; if it
  isn't found, it falls back to matching the location's `job` and prints a warning.
- jg servicing: a vehicle due a service gets a "due a service" advisory (not a fail).
- The console prints how many locations were imported on start.

**qb-mechanicjob, qbx_mechanicjob, esx_mechanicjob, wasabi_mechanic and similar**
These use framework jobs, so list the job names in `Config.MOT.jobs` and the garages in
`Config.MOT.garages`. A garage can have its own `jobs` table if each shop has its own job.

**Anything else** - `Config.MOT.CanTest(src, garage)` lets you decide who can test.

## New vehicles (jg-dealerships)
New vehicles get free insurance, an MOT and tax for `Config.NewVehicle.days` (30).
The patched `sv-purchase.lua` for jg-dealerships calls this after every purchase,
including direct sales, finance, society purchases and trade-ins. Anything the vehicle
already has is left alone, so it never doubles up.

The MOT shows on the record as a pass by "New vehicle registration" at the dealership.
For any other dealership or vehicle shop, call:
```lua
exports['vinewood-vehicleservices']:IssueNewVehicle(plate, src, { dealership = 'PDM' })
```
Call it after the vehicle is saved to the database - the keeper is read from there.

## Society vehicles (jg-advancedgarages)
**Emergency services** (`Config.Fleet.exemptJobs` - police, ambulance, fire by default)
are Crown vehicles: exempt from insurance, MOT and tax. They show as *Exempt* in the MDT
and `/mid` and never trigger ANPR hits. This covers:
- Owned job garage vehicles registered to those jobs.
- Spawner garage vehicles. They aren't saved anywhere, so they're recognised by model
  while spawned. Models are read from jg-advancedgarages spawner garages for those jobs
  automatically; add others to `Config.Fleet.exemptModels`.

**Other society vehicles** (mechanic, taxi, gangs...) need insurance, MOT and tax like
anyone else. Job bosses (and gang bosses) see their society's vehicles at the broker and
in `/tax`, marked with the society name. Society policies cover any driver and aren't
loaded on the boss's licence points.

No jg-advancedgarages files need editing.

## Police
`/mid [plate]` (or stood by a vehicle) shows MID, MOT and VED for `Config.Police.jobs`.
Handy for servers without vinewood-mdt.

## Exports (server)
```lua
exports['vinewood-vehicleservices']:GetInsurance(plate)
-- { status = 'insured'|'void'|'expired'|'none', policyNo, cover, coverLabel, holder,
--   holderCid, anyDriver, drivers = {{cid,name}}, expires, keeperIsHolder }
exports['vinewood-vehicleservices']:IsInsuredToDrive(plate, citizenid) -- boolean
exports['vinewood-vehicleservices']:GetMOT(plate)
-- { status = 'valid'|'dangerous'|'expired'|'failed'|'none', expires, last, history }
exports['vinewood-vehicleservices']:GetTax(plate)
-- { status = 'taxed'|'sorn'|'untaxed'|'none', ref, band, expires, since, keeperChanged }
exports['vinewood-vehicleservices']:GetVehicleStatus(plate) -- { insurance, mot, tax }
exports['vinewood-vehicleservices']:GetStatusBulk(plates)
-- { [PLATEKEY] = { insured = bool, insurance = status, mot = status, tax = status } }
```

## Events (server)
```lua
AddEventHandler('vinewood-vehicleservices:server:policyIssued', function(policy, src) end)
AddEventHandler('vinewood-vehicleservices:server:policyCancelled', function(policy, src) end)
AddEventHandler('vinewood-vehicleservices:server:motRecorded', function(test, testerSrc) end)
AddEventHandler('vinewood-vehicleservices:server:taxPaid', function(tax, src) end)
AddEventHandler('vinewood-vehicleservices:server:sorn', function(sorn, src) end)
AddEventHandler('vinewood-vehicleservices:server:newVehicleIssued', function(plate, refs, src) end)
```

## Optional items (ox_inventory `data/items.lua`)
```lua
['insurance_certificate'] = { label = 'Certificate of Motor Insurance', weight = 10, stack = false },
['mot_certificate'] = { label = 'MOT Test Certificate', weight = 10, stack = false },
```
Then set `certificateItem` in the Insurance and MOT config.

## Testing tip
Set `Config.DaySeconds = 60` to make a "day" one minute so you can watch policies and
MOTs expire. Put it back to 86400 before going live.

*Vinewood Studios - v1.5.0*
