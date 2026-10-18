# hf1_propdev

Developer raycast/prop inspector for Qbox/FiveM, using **ox_lib** for notifications, the entity action menu, and clipboard copying.

## Features

- `/propdev` toggles the developer ray for authorized players only.
- Server-side identifier allowlist and optional ACE permission support.
- Camera-centre ray/laser targets props, vehicles and peds.
- Displays archetype/model name (where FiveM exposes it), decimal model hash, hexadecimal hash, entity handle, coordinates, rotation, network ID/owner and entity state.
- Prints details to F8 when moving onto a different entity.
- Press **E** by default while targeting an entity to open an ox_lib context menu.
- One-click clipboard actions for model/prop name, decimal hash, hex hash, entity handle, coords, rotation, heading, network ID, and a ready-to-paste Lua object snippet.

## Dependencies

- `ox_lib`
- A current FiveM artifact is recommended for `GetEntityArchetypeName` support.
- Designed for Qbox servers, but authorization is standalone and does not require qbx_core exports.

## Installation

1. Extract the `hf1_propdev` folder into your resources directory.
2. Edit `config.lua` and add the identifiers allowed to use `/propdev`.
3. Ensure ox_lib starts before this resource:

```cfg
ensure ox_lib
ensure hf1_propdev
```

Example identifier configuration:

```lua
Config.AllowedIdentifiers = {
    'license:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
    'discord:123456789012345678'
}
```

Alternatively enable ACE support in `config.lua` and configure, for example:

```cfg
add_ace group.admin propdev.use allow
```

## Usage

Run `/propdev`, aim the centre of the camera at an entity, then press **E** to open the copy menu. Run `/propdev` again to disable it.

The decimal "model number" and model hash are the same GTA model hash value represented as a signed/decimal integer. The menu also exposes its hexadecimal representation separately.

Change `Config.MenuControl` and `Config.MenuControlLabel` if you want a different menu key.


## v1.2.0 raycast fix
- Laser now follows the exact gameplay-camera LOS endpoint instead of snapping to a fallback entity hit.
- Shape tests wait for completion instead of treating pending async results as misses.
- Added a narrow capsule fallback for static/local MLO props whose collision may otherwise return as world geometry with no entity handle.
- Configure the fallback with `Config.UseCapsuleFallback` and `Config.RaycastRadius`.


## v1.3.0 stability change
- Laser rendering is fully decoupled from asynchronous shape tests and always follows the exact gameplay-camera centre ray.
- Entity selection is latched. Temporary raycast/MLO streaming misses do not clear or redraw the info panel.
- The panel only changes after a different valid entity is positively acquired, or when Prop Dev is toggled off.
- Heading is cached with the entity snapshot so the ox_lib copy menu does not re-query a potentially stale MLO handle.


## v1.3.2 persistent laser
- Visible beam is rendered every frame independently of entity detection.
- Beam begins just beyond the camera near-plane and uses a tiny multi-line thickness to prevent GTA depth/TAA from making a stationary one-pixel line disappear.
- `Config.LaserStartOffset` and `Config.LaserThickness` can be adjusted without changing raycast accuracy.

## v1.3.2 laser behaviour
The visible laser is a single fixed-length DrawLine on the exact gameplay-camera forward vector. It is rendered every frame while PropDev is enabled and is never shortened, offset, or redirected by entity/collision results.


## v1.3.5 stable single-line laser
- Restored one standard GTA `DrawLine` only; no ribbon, cross, or multi-line beam.
- The visual endpoint now comes from a synchronous centre-camera LOS probe each rendered frame.
- The last valid visual endpoint is retained through transient LOS misses so the line remains visible while stationary.
- MLO/entity selection still uses the separate asynchronous LOS + capsule path, preserving custom interior prop detection.


## v1.4.0 persistent crosshair
- Removed the world-space laser renderer entirely.
- Added a small HUD-space centre dot with four short crosshair ticks.
- The marker is drawn every render frame while PropDev is enabled, so it stays visible while stationary and cannot be hidden by world depth/geometry.
- Prop/MLO detection is unchanged and still uses the exact centre-camera ray plus the existing capsule fallback.
- Crosshair colour, gap, length, thickness and centre-dot size are configurable in `config.lua`.


## v1.4.1 centre-dot indicator
- Removed all four crosshair arms.
- PropDev now displays only a persistent centre dot.
- Centre dot defaults to bright green (`0, 255, 0, 255`).
- Prop/entity detection and the latched information panel are unchanged.


## v1.4.2 circular centre dot
- Replaced the square centre indicator with a small filled circular bright-green dot.
- The circle is drawn in HUD space every frame and remains independent of prop detection.
- No changes to raycast detection, permissions, info panel or ox_lib copy menu.


## v1.4.3 true circular centre dot
- Corrected HUD aspect-ratio distortion so the bright-green centre indicator is circular in screen pixels.
- Uses the active screen resolution, so the dot remains round across common aspect ratios including 16:9 and ultrawide.
- Prop/entity detection and all other PropDev behaviour are unchanged.
