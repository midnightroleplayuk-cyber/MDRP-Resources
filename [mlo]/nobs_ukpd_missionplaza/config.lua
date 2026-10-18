--[[ NO BS SCRIPTS - Mission Plaza UK police station: SETTINGS

Every setting of this resource is in this one file. It is loaded on the server AND on every client, before the
station's scripts, so keep it to plain values (and the optional MPGateConfig.canOpen function below). Do not call
client-only natives such as PlayerPedId() at the top level of this file.

If this file has a mistake (a missing comma, quote or bracket), the server console or F8 shows an error for
config.lua and a yellow warning, and the station runs with its default settings until you fix it. After every edit,
restart the resource and check both consoles. The map itself never depends on this file.

The generated data the scripts read (gate and door positions, the frozen-prop list, the armoury layouts) is in
scripts/data/. Every update replaces it: do not edit it, keep your changes in this file.

Updating: every new version replaces this file too. Back up this file before you update, then set your changes again
in the new file (install/docs/INSTALL.md, "Updating").

server.cfg switches (no edit needed here):
  setr nobs_ukpd_armoury_display 0   armoury weapon display off for everyone (on by default)
  setr nobs_mp_door_debug 1          door closer steps in the F8 console (only when reporting a door problem)
]]

---------------------------------------------------------------------------------------------------- 1. VEHICLE GATES
MPGateConfig = {
    enabled = true,                -- false: this resource never moves the vehicle gates

    -- Who drives the vehicle gates (public entrance and police yard exit, two leaves each):
    --   'builtin'     (default) this resource swings them and follows their lock (see locks below):
    --                 locked = the gate closes (never onto a car or a person in its swing) and stays shut;
    --                 unlocked = it opens automatically again.
    --   'ox_doorlock' the same as 'builtin'. Import install/doorlocks/ox_doorlock/nobs_ukpd_gates.sql into
    --                 ox_doorlock and set your police group there.
    --   'qb-doorlock' this resource never touches the gates; copy install/doorlocks/qb-doorlock/nobs_ukpd_gates.lua
    --                 into qb-doorlock/configs.
    --   'none'        nothing moves them (they stay closed unless another script drives them).
    controller = 'builtin',

    -- POLICE GATE POLICY. true (default): the police (exit) gate and barrier open for ANY nearby player, on foot or
    -- in any vehicle. false: they open only for a player in an emergency-class vehicle. Job check: canOpen below.
    restrictedOpenForAll = true,

    -- Gate locks:
    --   mode = 'auto'  (default) a locked ox_doorlock door within matchDistance metres of a gate's centre or of one
    --                  of its hinges locks that gate (the shipped entries, or a door made with ox's own editor by
    --                  aiming at a gate leaf). Other doorlocks or your own scripts, from a SERVER script:
    --                  TriggerEvent('nobs_ukpd:setGateLocked', 'entrance' or 'exit', true / false)
    --                  or this resource's export setGateLocked(group, locked).
    --   mode = 'event' only the event / export locks a gate.
    --   mode = 'none'  gates ignore locks.
    locks = { mode = 'auto', matchDistance = 2.0 },

    -- Opening distance (metres from the gate's trigger point) and speed (open ratio per second) of each gate:
    --   entrance: trigger at the gate centre; 12 m = opens for a car 12 m from the gate on either side; full swing
    --             in about 2.9 s.
    --   exit:     trigger 8 m inside the yard; 16 m reaches about 8 m into the street (most passing emergency
    --             traffic does not open it) and 24 m into the yard; full swing in about 1.25 s. At 8 m or less it
    --             no longer opens for cars arriving from the street. Its leaves swing into the yard: check in game
    --             that a car leaving at your usual speed meets fully open leaves.
    timing = {
        entrance = { range = 12.0, speed = 0.35 },
        exit     = { range = 16.0, speed = 0.8 },
    },
}

-- Optional job check for the gates (runs on each player's client). Return true (open), false (keep closed) or nil
-- (use the policy above). gate.group ('entrance' or 'exit'), gate.id, gate.use and gate.restricted describe the
-- leaf. An error inside it is reported once in F8 and the policy above is used. Example:
-- MPGateConfig.canOpen = function(gate, ped)
--     if gate.restricted then return IsMyPoliceJob(ped) end   -- IsMyPoliceJob = your framework's job check
-- end
-- Define it here only: this file runs on the server too, but canOpen is only ever called on the client.
-- The pedestrian, staff-fence and maintenance gates are ordinary doors: lock them with your doorlock resource.

----------------------------------------------------------------------- 2. AUTOMATIC DOORS (entrance sliders, garage)
-- The front entrance sliders and the two garage roller doors are moved by this resource, so a doorlock cannot move
-- them itself. A locked door closes here instead and stays shut.
MPManagedDoorLocks = {
    -- 'auto'  (default) a locked ox_doorlock door within matchDistance metres of an automatic door locks it: the
    --         door closes (also when it is open, never onto someone in the doorway) and stays shut; unlocked =
    --         automatic again. Import install/doorlocks/ox_doorlock/nobs_ukpd_autodoors.sql, or make the door with
    --         ox's own editor by aiming at it. Other doorlocks or your own scripts, from a SERVER script:
    --         TriggerEvent('nobs_ukpd:setAutoDoorLocked', id, true / false)
    --         or the export setAutoDoorLocked(id, locked); ids: entrance (both sliders; entrance_left and
    --         entrance_right lock the pair too), garage_bay1, garage_bay2.
    -- 'event' only the event / export locks a door.
    -- 'none'  never lock: always automatic.
    mode = 'auto',
    matchDistance = 1.5,
}

-- When the doors open, in metres from the door's centre point: along = either side of the doorway's centre line,
-- across = in front of / behind the door. openAlong / openAcross = how far a person or vehicle may be from an OPEN
-- door and still hold it open (a little more than along / across, so it does not flutter). The garage values keep
-- the garage side door next to bay 1 from lifting the roller; vehicles in the opening still open it.
MPManagedDoors = {
    entrance = { along = 1.4, across = 1.6, openAlong = 1.6, openAcross = 1.9 },
    garage   = { along = 3.5, across = 6,   openAlong = 3.7, openAcross = 7 },
}

-------------------------------------------------------------------------------------------- 3. ARMOURY WEAPON DISPLAY
-- Local, frozen, collision-free weapon models on the armoury racks and tables (nothing can be picked up; nothing is
-- networked). On for everyone unless server.cfg has setr nobs_ukpd_armoury_display 0. Each player can switch it off
-- on their own screen with /ukpd_armoury off (on | toggle | status).
ArmouryDisplay = {
    convar = 'nobs_ukpd_armoury_display',  -- the server.cfg switch above
    command = 'ukpd_armoury',              -- the player command above
    maxObjects = 70,                       -- most weapon objects at once, across both armouries

    -- Advanced (leave as they are unless support asks you to change them)
    pollInsideMs = 750,        -- how often it checks the player's room inside the station (ms)
    pollOutsideMs = 1000,      -- and anywhere else (ms)
    convarEveryPolls = 5,      -- re-read the server.cfg switch every N checks
    exitMargin = 1.5,          -- metres an armoury's zone grows before its weapons are removed again
    loadTimeoutMs = 8000,      -- give up waiting for a weapon model after this (ms); it is then skipped
    spawnBatch = 8,            -- objects created per frame while an armoury is filled
    releaseAssets = true,      -- free the weapon models once an armoury is filled
    defaultComponents = false, -- false = weapons stored unloaded (no magazine); only the listed attachments
    lodDist = nil,             -- nil keeps GTA's own draw distance of each weapon model
    rotationMode = 'auto',     -- auto | euler | quat | quatc
    debugHosts = false,        -- support only
}

------------------------------------------------------------------------------------------------------ 4. AMBIENT RADIO
-- GTA plays background radio from fixed "static emitters". The restaurant that stood on this site left one inside the
-- station (East Los FM, all day, heard through the walls). Every emitter listed here is switched off while this
-- resource runs and back on when it stops. Add a name to silence it as well; MPDisabledEmitters = {} plays them all.
MPDisabledEmitters = { 'se_restaurants_hollywood_28' }
