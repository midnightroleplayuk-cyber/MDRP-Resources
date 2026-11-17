# RSVX_Garage

Emergency services garage for Qbox. Vehicles come out with the mods, extras and livery you set for them, and each vehicle can be locked to a minimum job grade. Selecting a vehicle in the garage shows a live preview of it in a bay. Garages are set up in game.

## Requirements

- qbx_core
- ox_lib
- oxmysql
- ox_target
- qbx_vehiclekeys (optional, keys are handed out if it is running)

## Install

1. Name the resource folder `RSVX_Garage`.
2. Add `ensure RSVX_Garage` after the requirements.
3. Run `/garageadmin` in game (admins only, see `config.lua`).

## Setting up a garage

1. Stand where the attendant should be and run `/garageadmin`, then **New garage** and **Use where I'm standing**.
2. Add the jobs that can use it, each with a minimum grade.
3. Close the panel, park or stand in a bay, reopen it and **Add bay where I am**. Unsaved changes are kept while you move.
4. Add vehicles. Either type the settings in, or set a vehicle up how you want it, sit in it and use **Copy from the vehicle I'm sitting in**.
5. Save.

Garages are stored in the `rsvx_garages` database table, which is created automatically on first start.
