-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
-- TEMPORARY showcase seed — injects active dispatch calls on resource start.
-- Disable via ServerConfig.ShowcaseDispatchSeed.enabled = false, or delete this file.
ServerConfig = ServerConfig or {}
ServerConfig.ShowcaseDispatchSeed = {
    enabled = false,
}

local function seedShowcaseDispatches()
    local cfg = ServerConfig.ShowcaseDispatchSeed
    if not cfg or not cfg.enabled then return end

    if not Modules.awaitFullyReady(15000) then
        lib.print.error('[showcase_seed] MDT not ready — skipped dispatch seed')
        return
    end

    -- Skip if something already populated the board (e.g. PersistDispatch restore).
    local existing = exports[GetCurrentResourceName()]:GetActiveDispatches()
    if type(existing) == 'table' and #existing > 0 then
        lib.print.info(('[showcase_seed] %d active dispatch(s) already present — skipped'):format(#existing))
        return
    end

    local calls = {
        {
            type = 'robbery',
            code = '10-90',
            title = 'Jewelry store hold-up',
            description = 'Caller reports two suspects still inside Vangelico.',
            location = 'Portola Dr, Rockford Hills',
            priority = 5,
            radio = 2,
            pinned = true,
            created_offset_minutes = 3,
            coords = { x = -630.0, y = -230.0, z = 38.0 },
            responders = {
                showcase_sam5 = { name = 'Rosa Diaz', callsign = '1-SAM-5', status = 'enroute' },
                showcase_david7 = { name = 'Derek Shaw', callsign = '1-DAVID-7', status = 'enroute' },
                showcase_305 = { name = 'Ava Chen', callsign = '305', status = 'arrived' },
            },
        },
        {
            type = 'robbery',
            code = '10-31',
            title = 'Armed robbery in progress',
            description = 'Two masked subjects, one armed with a handgun.',
            location = 'Vinewood Blvd, Las Lagunas Blvd',
            priority = 5,
            radio = 2,
            pinned = true,
            created_offset_minutes = 5,
            coords = { x = -1220.0, y = -900.0, z = 12.0 },
            responders = {
                showcase_sam5b = { name = 'Rosa Diaz', callsign = '1-SAM-5', status = 'arrived' },
                showcase_112 = { name = 'Mason Reyes', callsign = '112', status = 'arrived' },
                showcase_204 = { name = 'Cole Whitaker', callsign = '204', status = 'enroute' },
            },
        },
        {
            type = 'robbery',
            code = '10-31',
            title = 'Paleto Bay bank alarm',
            description = 'Motion sensors triggered in the vault corridor.',
            location = 'Paleto Blvd, Paleto Bay',
            priority = 4,
            radio = 3,
            pinned = true,
            created_offset_minutes = 8,
            coords = { x = -105.0, y = 6470.0, z = 31.0 },
            responders = {
                showcase_baker2 = { name = 'Casey Lee', callsign = '1-BAKER-2', status = 'enroute' },
            },
        },
        {
            type = 'traffic_stop',
            code = '10-50',
            title = 'Multi-vehicle collision',
            description = 'Three-car pileup blocking two lanes, injuries reported.',
            location = 'Great Ocean Hwy, Chumash',
            priority = 4,
            created_offset_minutes = 25,
            coords = { x = -3190.0, y = 1100.0, z = 20.0 },
            responders = {
                showcase_edward3 = { name = 'Ethan Brooks', callsign = '1-EDWARD-3', status = 'arrived' },
            },
        },
        {
            type = 'traffic_stop',
            code = '10-38',
            title = 'Street racing reported',
            description = 'Multiple vehicles drag racing eastbound on the freeway.',
            location = 'La Puerta Fwy, Los Santos',
            priority = 3,
            created_offset_minutes = 12,
            coords = { x = -950.0, y = -2700.0, z = 14.0 },
            responders = {
                showcase_adam12 = { name = 'John Smith', callsign = '1-ADAM-12', status = 'enroute' },
                showcase_charlie4 = { name = 'Nina Ortiz', callsign = '1-CHARLIE-4', status = 'enroute' },
            },
        },
        {
            type = 'robbery',
            code = '10-90',
            title = 'Store alarm tripped',
            description = 'Silent alarm at 24/7 on Innocence Blvd.',
            location = 'Innocence Blvd, Strawberry',
            priority = 3,
            created_offset_minutes = 42,
            coords = { x = 25.0, y = -1345.0, z = 29.0 },
            responders = {},
        },
        {
            type = 'traffic_stop',
            code = '10-11',
            title = 'Reckless driver',
            description = 'Silver sedan weaving through traffic at high speed.',
            location = 'Route 68, Grand Senora Desert',
            priority = 2,
            created_offset_minutes = 18,
            coords = { x = 1200.0, y = 2200.0, z = 50.0 },
            responders = {
                showcase_lincoln9 = { name = 'Mike Tran', callsign = '1-LINCOLN-9', status = 'enroute' },
            },
        },
        {
            type = 'robbery',
            code = '10-31',
            title = 'ATM skimming device',
            description = 'Bank security flagged tampered ATM at branch entrance.',
            location = 'Hawick Ave, Alta',
            priority = 2,
            created_offset_minutes = 55,
            coords = { x = 310.0, y = -280.0, z = 54.0 },
            responders = {},
        },
        {
            type = 'traffic_stop',
            code = '10-11',
            title = 'Suspected DUI',
            description = 'Pickup truck swerving across center line near the docks.',
            location = 'Elysian Island, Terminal',
            priority = 2,
            created_offset_minutes = 31,
            coords = { x = 850.0, y = -3200.0, z = 6.0 },
            responders = {
                showcase_lincoln9b = { name = 'Mike Tran', callsign = '1-LINCOLN-9', status = 'arrived' },
            },
        },
    }

    local resource = GetCurrentResourceName()
    local created = 0
    for i = 1, #calls do
        calls[i].silent = true -- avoid 9x alert spam; clients resync once below
        local ok = exports[resource]:CreateDispatch(calls[i])
        if ok then created = created + 1 end
    end

    -- Pull the seeded board onto already-connected officers (and anyone who refreshed early).
    TriggerClientEvent('wasabi_mdt:client:syncDispatches', -1)

    lib.print.warn(('[showcase_seed] Injected %d showcase dispatches — disable ServerConfig.ShowcaseDispatchSeed before release'):format(created))
end

CreateThread(seedShowcaseDispatches)
