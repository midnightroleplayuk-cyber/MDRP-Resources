# uk_aed_cabinet – UK defibrillator cabinet prop for FiveM

A wall-mounted, public-access AED cabinet as a streamable GTA V prop.

## Install

1. Put the `uk_aed_cabinet` folder in your server's `resources` folder.
2. Add `ensure uk_aed_cabinet` to `server.cfg`.
3. Restart the server. Use the model name `uk_aed_cabinet` (hash `` `uk_aed_cabinet` ``) in your scripts, map editor or ymap.

To test it in-game, type `/aedtest`. That spawns one in front of you. The command lives in `client.lua`. If you don't want it, delete `client.lua` and its line in `fxmanifest.lua`.

## What's in it

| File | What it is |
|---|---|
| `stream/uk_aed_cabinet.ydr` | Model with textures embedded, two `default` shaders, box collision |
| `stream/uk_aed_cabinet.ytyp` | Archetype definition (XML format, which FiveM loads directly) |

## Placement notes

- **Size:** about 46 cm wide × 61 cm tall × 28 cm deep (30 cm including the keypad).
- **Origin:** bottom-centre of the back panel. Put the entity's position on the wall at the height you want the bottom edge.
- **Facing:** the front faces the entity's forward direction (+Y). Set the heading so +Y points away from the wall.
- **Archetype flags:** 32 (Static), so the cabinet won't be knocked around. Collision is a single box.

## Credits and licences

- 3D model: ["UK Automated External Defibrillator"](https://sketchfab.com/3d-models/uk-automated-external-defibrillator-997cdb42217f4ef78b65e18e7e506e78) by **Warcub** (https://sketchfab.com/jacobwarrenlee), licensed under [CC BY 4.0](http://creativecommons.org/licenses/by/4.0/).
  Changes: converted to GTA V formats (.ydr/.ytyp), rescaled to real-world size, re-oriented, re-centred, collision added, textures re-encoded to DXT1.
- **Front texture:** this is an Alamy stock photo preview (image EYJ1FD, watermark visible). It came with the original model, but Alamy's licence for it isn't covered by the model's CC BY licence. Before any public release, license the image from Alamy or swap in your own photo.
