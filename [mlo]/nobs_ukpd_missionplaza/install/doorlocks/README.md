# Doorlock data

These files are NOT loaded by the station: copy what you need into your doorlock resource. Paths below are inside
this folder (`install/doorlocks/`). Every entry uses placeholder jobs (`police`, and `firearms` for the armouries):
set your own job names and grades before you use them.

Door names stay the same in every update, so doorlock entries you imported earlier keep working.

## ox_doorlock

1. Import `ox_doorlock/nobs_ukpd_custody.sql` and `ox_doorlock/nobs_ukpd_d13_access.sql` into ox_doorlock's database
   (table `ox_doorlock`) and set your jobs and grades in `groups`.
2. Custody interlocks (never both doors of a pair unlocked: airlock outer door and cage gate, cell hall response door
   and custody staff entry): copy the `ox_doorlock` folder to your resources as `nobs_ukpd_missionplaza_doorlock`
   and ensure it after ox_doorlock. Its own `ox_doorlock/fxmanifest.lua` and `ox_doorlock/interlock_ox.lua` do the
   rest.
3. Vehicle gates and automatic doors: see below.

## qb-doorlock

Copy `qb-doorlock/nobs_ukpd_custody.lua` and `qb-doorlock/nobs_ukpd_d13_access.lua` into qb-doorlock/configs. The
custody interlock is at the end of the custody file and runs inside qb-doorlock.

## Other doorlocks

`neutral/` lists every door as JSON, CSV and Lua: model, hash, world pivot and heading of each leaf, job, lock policy
and interlock group. `neutral/doors_all.json` holds all of them.

## Vehicle gates (public entrance, police yard exit)

The 4 gate leaves (`nobs_ukpd_mp_swing_leaf`, 2 per gate, hinged at the model origin) are swung by the station
itself. They follow your doorlock: **locked = the gate closes (never onto a car or a person in its swing) and stays
shut; unlocked = it opens automatically for nearby players again.**

ox_doorlock:
1. Keep `controller = 'builtin'` in `config.lua`, section 1 (`'ox_doorlock'` does the same).
2. Import `ox_doorlock/nobs_ukpd_gates.sql` (or add the doors from `ox_doorlock/nobs_ukpd_gates.json` by hand):
   `nobs_mp_gate_exit` (police yard exit: starts locked, relocks 15 s after it is unlocked) and
   `nobs_mp_gate_entrance` (public entrance: starts unlocked). Both are double doors with the exact leaf model hash,
   hinge coordinates and closed headings and `maxDistance` 10 m, so a driver can lock and unlock them from the car. A
   door you make at a gate with ox_doorlock's own editor works too (matched within 2 m of the gate centre or a hinge).
3. Set your police job name(s) and grades in `groups` and restart ox_doorlock.
Entries imported from an earlier version also work; re-importing is optional (it replaces only the two gate doors, so
set `groups` again afterwards).

qb-doorlock: set `controller = 'qb-doorlock',` in `config.lua` and copy `qb-doorlock/nobs_ukpd_gates.lua` into
qb-doorlock/configs (qb-doorlock then swings the leaves itself). Any other doorlock or your own script: keep
`'builtin'` and call `TriggerEvent('nobs_ukpd:setGateLocked', 'exit', true)` (or the export `setGateLocked`; groups
`entrance`, `exit`) from a server script. Lock settings: `MPGateConfig.locks` in `config.lua`.

## Automatic doors (front entrance sliders, garage rollers)

These four leaves are moved by the station itself, so a doorlock cannot move them. With ox_doorlock running, any
ox_doorlock door within 1.5 m of an automatic door controls it: **locked = the door closes (also when it is open at
that moment) and stays shut; unlocked = automatic again.** It never closes onto someone standing in the doorway.
1. Import `ox_doorlock/nobs_ukpd_autodoors.sql` (or add the entries from `ox_doorlock/nobs_ukpd_autodoors.json`), or
   make the doors with ox_doorlock's own editor by aiming at them; both work. The shipped entries start unlocked.
2. Set your police job name(s) in `groups` and restart ox_doorlock.
Other doorlocks or your own scripts: from a server script,
`TriggerEvent('nobs_ukpd:setAutoDoorLocked', 'garage_bay1', true)` (or the export `setAutoDoorLocked`). Ids:
`entrance` (both sliders; `entrance_left` and `entrance_right` lock the pair too, as the sliders open together),
`garage_bay1`, `garage_bay2`. Settings: `MPManagedDoorLocks` and the opening distances `MPManagedDoors.entrance` /
`MPManagedDoors.garage` in `config.lua`, section 2.

Each garage roller also carries an exterior skin (`nobs_ukpd_d48_roller_skin`, no collision) that moves with it, so
the door is lit from the yard and from inside the garage at night. The roller leaf itself (the model and coordinates
in the doorlock entries) does not change, so doorlock entries keep working.

## Doors locked while open

GTA swings its own doors shut when a doorlock locks them while they stand open. The station's door models are custom,
and GTA's close of a locked custom leaf works in one swing direction only, so the station acts as the door closer for
every station door that your doorlock (any that uses GTA's door system: ox_doorlock, qb-doorlock, ...) has locked
while it stands open:

- GTA gets the first go: a door GTA is swinging shut properly keeps its own swing.
- If the door stops, creeps or stays open instead - also when you lock it while it is still swinging shut - the
  station takes over within about 0.1 s and swings it shut smoothly (about 1.2 s from wide open) at its own speed, the
  same in either direction, and the lock then holds it. A door that swings through the closed position is caught
  there. A door left slightly ajar is finished off too. There is no instant snap.
- The closing door stops and holds only while a person (also someone lying in the doorway) is within about 0.3 m of
  the part of the swing still to cover, or a vehicle is in it, and carries on once the way is clear. Standing beside
  the door, past the end of the leaf or on the far side of the closed door does not hold it.
- It lets go of a door the moment the door is unlocked, and never touches an unlocked door.
- `setr nobs_mp_door_debug 1` (server console or server.cfg) prints each step to the F8 console, if you ever need to
  report a door that does not close.

The doors are found from the door objects your doorlock registered, so doors made with ox_doorlock's editor work too.
The vehicle gates are handled separately (see above).
