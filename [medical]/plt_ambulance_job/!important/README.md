This script auto-detects what resource you are using in the bridge folders. If you are adding your own system, follow the format below!

1. Navigate to the applicable bridge folder and create your new lua.
2. Once you have the new lua properly setup, navigate to server/init.lua and add the following line;

    if GetResourceState('SCRIPT_NAME_HERE') == 'started' then
        Utils.rawPrint('^2[plt_ambulance_job] BRIDGE_FOLDER: SCRIPT_NAME_HERE^7')

If you do not do these steps, the prints that print in your console to list the scripts you're using, will be wrong.

plt_ambulance_job
|-- client
|   `-- bridge
|       |-- framework
|       |   |-- esx.lua
|       |   |-- qb.lua
|       |   `-- qbx.lua
|       |-- inventory
|       |   |-- esx.lua
|       |   |-- origen.lua
|       |   |-- ox.lua
|       |   |-- ps.lua
|       |   |-- qb.lua
|       |   `-- qs.lua
|       |-- keys
|       |   |-- cd.lua
|       |   |-- mm.lua
|       |   |-- okok.lua
|       |   |-- qb.lua
|       |   |-- qbx.lua
|       |   `-- wasabi.lua
|       |-- progressbar
|       |   |-- ox.lua
|       |   `-- qb.lua
|       `-- target
|           |-- ox.lua
|           `-- qb.lua
`-- server
    `-- bridge
        |-- billing
        |   |-- pluto.lua
        |   `-- wasabi.lua
        |-- framework
        |   |-- esx.lua
        |   |-- qb.lua
        |   `-- qbx.lua
        `-- inventory
            |-- origen.lua
            |-- ox.lua
            |-- ps.lua
            |-- qb.lua
            `-- qs.lua

