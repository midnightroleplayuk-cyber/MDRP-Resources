# Mission Plaza UK Police Station - NO BS SCRIPTS

A British police station at Mission Plaza (Hawick), Los Santos: interior MLO, exterior shell and site works, vehicle
gates, entrance and garage doors, armoury display and map fixes, all in ONE resource: `nobs_ukpd_missionplaza`.
Version 1.2.0 (2026-10-08).

## What is in the folder

| Item | What it is |
|---|---|
| `fxmanifest.lua` | the resource manifest |
| `config.lua` | every setting, in four sections: vehicle gates, automatic doors, armoury display, ambient radio |
| `README.md` | this guide |
| `stream/` | the map files: `stream/mlo/` (interior), `stream/exterior/`, `stream/branding/` (your logo textures) and `stream/vanilla/` (edited GTA files) |
| `scripts/` | `scripts/client/` and `scripts/server/` (protected by Cfx asset escrow) and `scripts/data/` (generated data - do not edit) |
| `install/` | not loaded by the server: `install/docs/` (guides), `install/doorlocks/` (doorlock data), `install/branding_kit/` (logo templates) |

## Install

1. Download the resource from your Cfx account (portal.cfx.re, granted assets). Use the account that owns your
   server's license key: the station only starts on a server whose key belongs to the purchasing account.
2. Copy the whole `nobs_ukpd_missionplaza` folder into your server `resources` folder, including the small hidden file
   `.fxap`. Some FTP programs skip files whose name starts with a dot or damage them in text mode. Upload in
   binary mode and check that `.fxap` is there.
3. Add `ensure nobs_ukpd_missionplaza` to server.cfg (all lines: `install/docs/server.cfg.example`). Game build
   3258 or newer, on a current recommended server artifact.
4. Restart the server and watch the server console and F8. A good start shows no yellow or red lines from
   `nobs_ukpd_missionplaza`. A yellow line that names `config.lua` means a mistake in your settings: see "Settings"
   below. A note that one of the station's texture dictionaries is large (about 30 MiB) is expected.

Full steps, settings and doorlock notes: `install/docs/INSTALL.md`.

## Updating from 1.1.x

Version 1.2.0 has a new folder layout and ONE settings file (this also applies to 1.0.0). Before you delete
anything, back up all four 1.1.x settings files: `config.lua`, `managed_doors_config.lua`,
`armoury_display_config.lua` and `site_config.lua`, plus your edited branding `.ytd` and any Vertex Hub merged
files. Then delete the old `nobs_ukpd_missionplaza` folder (or the folder you renamed it to) completely, including
`.fxap`, copy the new one (your server.cfg lines stay as they are) and set your settings again in the new
`config.lua`. Step by step, and where each old setting
went: `install/docs/INSTALL.md`, "Updating".

## Settings

Every setting is in `config.lua`:

1. Vehicle gates: who drives them (the station itself, ox_doorlock or qb-doorlock), the police gate policy
   (`restrictedOpenForAll`, an optional job check), locks, opening distance and speed.
2. Automatic doors (front entrance sliders, garage rollers): lock mode and opening distances.
3. Armoury weapon display: on by default; `setr nobs_ukpd_armoury_display 0` in server.cfg turns it off for everyone.
4. Ambient radio: the GTA radio emitter switched off inside the station (`MPDisabledEmitters`).

After editing `config.lua`, restart the resource and check the server console and F8. A yellow warning that names
`config.lua` means the file has a mistake (a missing comma, quote or bracket: the station then runs on its default
settings until you fix it) or still holds an old 1.1.x list, which is ignored.

## Your own badge and logo

Every texture a server usually rebrands is in one open texture dictionary,
`stream/branding/nobs_ukpd_branding.ytd`: the force crest (in colour, and white for the navy feature walls), the big
lobby logo, the press-room backdrop, the POLICE STATION name plate and the entrance plaque. Steps and sizes:
`install/docs/BRANDING.md`. PNG templates: `install/branding_kit/`.

## Map clashes (Vertex Hub)

The station changes 78 GTA map files (the Mission Plaza tile, nearby road tiles, LOD and lodlights
maps). They are kept together in `stream/vanilla/` and are not encrypted. If another resource on your server streams
a file with the same name, merge the two copies with Vertex Hub and keep the merged file in one resource only. The
full list is in `install/docs/VANILLA_FILES.md`.

## Doorlocks and sit scripts

Ready data for ox_doorlock, qb-doorlock and a neutral door list: `install/doorlocks/README.md` (not loaded by the
station). Chair models for sit scripts: `install/docs/CHAIRS.md`. Changes per version: `install/docs/CHANGELOG.md`.

## Open and protected files

Protected by Cfx asset escrow:
the 356 station models in `stream/mlo/` and `stream/exterior/` and the 8 scripts in `scripts/client/` and
`scripts/server/`.
Everything else is open (not encrypted), so map tools such as Vertex Hub can read every texture dictionary, map
placement, collision and archetype file in `stream/`. No framework is required.

## Support

Contact NO BS SCRIPTS where you bought the station. Please include your server artifact and game build and the
console lines that mention `nobs_ukpd_missionplaza`; for a door that does not close, also the F8 output with
`setr nobs_mp_door_debug 1`.
