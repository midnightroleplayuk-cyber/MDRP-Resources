# hf1_pedblock

A standalone FiveM/Qbox-friendly resource that prevents GTA ambient population
peds from spawning inside configured zones.

It does NOT require Qbox, QB-Core, ESX, ox_lib, or any other framework.

## Features

- Circular/sphere zones
- Box zones with heading
- Cancels GTA population ped creation before the ped is spawned
- Sets ambient ped density to zero while a player is inside the zone
- Sets scenario ped density to zero
- Optionally removes existing ambient peds already inside the zone
- Leaves player peds alone
- Leaves mission entities alone
- Protected NPC model list
- Optional ambient vehicle blocking per zone
- Debug zone drawing
- `/pedblockdebug`

## Installation

1. Put the `hf1_pedblock` folder into your server's resources folder.
   A common location is:

   resources/hf1_pedblock

2. Add this to server.cfg:

   ensure hf1_pedblock

3. Edit `config.lua`.

4. Restart the resource/server.

## Sphere zone

This is easiest for most MLOs:

    {
        name = "my_area",
        type = "sphere",
        coords = vec3(123.456, -456.789, 30.123),
        radius = 35.0,
        blockVehicles = false,
    },

Sphere zones use X/Y distance and intentionally ignore Z, which is useful for
multi-floor interiors where you want one zone to cover the whole building.

## Box zone

Use this when you want a precise rectangular area:

    {
        name = "my_area",
        type = "box",
        coords = vec3(123.456, -456.789, 30.123),
        size = vec3(40.0, 30.0, 12.0),
        heading = 25.0,
        blockVehicles = false,
    },

`size.x` = width
`size.y` = length
`size.z` = height

## Existing NPCs

By default, the resource also removes existing ambient peds inside the zone.

It deliberately does NOT remove:

- players
- mission entities
- models listed in `protectedModels`

If a scripted NPC from another resource disappears, add its model to:

    protectedModels = {
        "s_m_m_bouncer_01",
    },

Or disable existing-ped cleanup:

    removeExistingPeds = false,

The population creation hook will still prevent new GTA ambient population peds
from appearing.

## qbx_density

This resource is designed to work alongside Qbox's density resource because
the zone-specific density values are only applied while the player is inside a
configured zone.

The `populationPedCreating` hook is also used, which cancels population-ped
creation specifically inside the configured zones.

If another resource deliberately creates its own NPC with `CreatePed`, that NPC
is not a GTA population ped and cannot be stopped by `populationPedCreating`.
The existing-ped cleanup and protected-model options are provided for that case.

## Performance

Outside a configured zone the main loop sleeps for 1000ms.

Inside a zone the density natives are applied every frame as required by the
FiveM/GTA natives. Existing-ped cleanup runs on the configurable interval
(default 1500ms).

The debug renderer only runs every frame while debug mode is enabled.

## Important

This resource is intentionally client-side. The population system is local to
each player's game client, so every player who enters the zone gets the
population suppression.

If your pub has a custom NPC spawned by another resource, tell me the resource
name/model and I can adjust the protection logic around it.
