# Sky-Systems Scripts

Thank you for purchasing a Sky-Systems script! We are committed to providing high-quality scripts to enhance your FiveM server experience. Below, you'll find essential links to our documentation and support resources to help you get started.

## Installation

For step-by-step installation instructions, please visit our [Installation Docs](https://docs.sky-systems.net/docs/installation).

## Script-Specific Documentation

For detailed information on configuring and using Fire Job, check out our [Fire Job Documentation](https://docs.sky-systems.net/docs/jobs/firejob/overview).

## Weapon fires

Weapon-triggered Sky fires are disabled by default so you can finish setting up the fire department first.
With `Config.UseJobConfigurator = true`, open `/jobconfig`, select Fire Jobs, then **Fire > Weapon fires**.
Enable weapon fires there and edit the list of weapons that may start them. Changes apply to connected
players immediately; disabling also discards pending ignitions. Existing Sky fires remain active.

With the configurator disabled, edit `config/config.lua`:

```lua
Config.FireSystem.molotovIgnition = {
    enabled = false, -- Set to true when ready.
    weapons = { "WEAPON_MOLOTOV", "WEAPON_FLAREGUN" }
}
```

An empty `weapons = {}` list allows no weapon fires. Use weapon names with detectable projectiles or
impact coordinates; add-on weapons can use the same list. This controls Sky fire creation, not GTA's
native flames, weapon damage, vehicle fires, lighter ignition, or mission fires. The former single
`weapon` option is imported when no `weapons` list is set. Existing `/jobconfig` overrides take precedence
over Lua values; `/jobconfigimport sky_firejob` imports local configuration when needed.

## Vehicle Fires

Vehicle fires are controlled by `Config.VehicleFires` in `config/config.lua`.

- Manual ignition uses `Config.VehicleFires.manualIgnition.item` and is protected by a server-wide cooldown.
- Vehicle fuel fires use the `vehicle_fuel` material, so water does not extinguish them and can cause spread/reaction effects. Foam is the intended extinguishing agent.
- Explosion behavior is configurable through `Config.VehicleFires.explosion`; disable it or change `delaySeconds` to control if and when a burning vehicle explodes.
- External resources can trigger a vehicle fire through:

```lua
exports["sky_firejob"]:CreateVehicleFire({
    netId = vehicleNetId,
    plate = plate,
    coords = { x = coords.x, y = coords.y, z = coords.z },
    source = "my_resource"
}, source, { reason = "external" })
```

or the server event:

```lua
TriggerEvent("sky_firejob:vehicleFires:createFromExternal", payload)
```

`sky_mechanicjob` uses an internal bridge for critical engine damage and heavy frontal impacts when both resources are running.

## Regular Fires

Server resources can create a regular synchronized fire through the public `CreateFire` export:

```lua
local result = exports["sky_firejob"]:CreateFire({
    type = "trash",
    coords = { x = coords.x, y = coords.y, z = coords.z },
    metadata = {
        locationType = "exterior",
        sourceScale = 1.0,
        material = "plastic",
        smokeDensity = 0.8,
        reignitable = true
    }
}, source)

if result.success then
    print(("Created fire #%s"):format(result.fireId))
else
    print(("Could not create fire: %s"):format(result.error))
end
```

The server export returns `{ success = true, fireId, type, label }` on success. Invalid calls return
`{ success = false, error }`, where `error` is `invalid_payload`, `invalid_coords`,
`invalid_fire_type`, or `create_failed`.

## Fire creator permissions

`/skyfiremenu` supports both framework/ACE groups and framework jobs. Configure them in
`Config.CommandPermissions.skyfiremenu`:

```lua
skyfiremenu = {
    groups = { "god", "superadmin", "admin" },
    jobs = { "firefighter" },
},
```

A player may open and use the fire creator when either their group or current job is listed. Job
authorization is checked server-side for the command and every fire creator callback.

## Scenario Hub request signing

Remote Scenario Hub requests are signed server-side with HMAC-SHA256. Before
building the escrow-protected resource, set `HUB_BACKEND_HMAC_SECRET` in
`source/server/scenarios/hub.lua` to the same value as `FIREJOB_HMAC_SECRET` on
the Public API. The secret must contain at least 32 bytes. Keep
`HUB_HMAC_KEY_VERSION` synchronized with `FIREJOB_HMAC_KEY_VERSION`:

```lua
local HUB_BACKEND_HMAC_SECRET = "replace-with-at-least-32-random-characters"
local HUB_HMAC_KEY_VERSION = "1"
```

The server debug log emits structured `[scenarioHub][hmac]` records for an
RFC 4231 implementation self-test, every canonicalized request, and the
corresponding HTTP response. Request logs include the exact ordered canonical
fields, escaped canonical message, byte counts, SHA-256 hashes, nonce, and
generated signature. The HMAC secret and raw request body are never logged.

Hub reads make at most three attempts on connection failures, timeouts, HTTP 408/429 and
server/Cloudflare 5xx responses through Sky Base, with 1/2-second backoff and a fresh signature
per attempt. Each attempt retains its 8-second timeout. Writes are sent once to avoid duplicate
publishes or votes after an uncertain response. Final failures remain visible with debug disabled.

## Support

If you need any assistance or have further questions, join our Discord community for support:

[Sky-Systems Discord](https://discord.gg/sky-systems)

Thank you for choosing Sky-Systems! We hope you enjoy using our scripts on your server.
