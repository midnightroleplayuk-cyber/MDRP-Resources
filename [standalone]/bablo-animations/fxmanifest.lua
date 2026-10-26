games {
    "gta5"
}

version "3.3.7"

fx_version "cerulean"

nui_callback_strict_mode "true"

use_experimental_fxv2_oal "yes"

lua54 "yes"

ui_page "src/web/dist/index.html"

data_file 'DLC_ITYP_REQUEST' 'stream/[props]/bablo_animprops.ytyp'

files {
    "src/web/dist/index.html",
    "src/web/dist/**/*",
    "src/web/custom_previews/**/*",
    "controls.json",
    "data/weapons.meta",
    "data/weaponanimations.meta"
}

data_file "WEAPONINFO_FILE_PATCH" "data/weapons.meta"
data_file "WEAPON_ANIMATIONS_FILE" "data/weaponanimations.meta"

shared_scripts {
    "@ox_lib/init.lua",
    "config.lua",
    "src/resource/shared/modules/callbacks.lua",
    "src/resource/shared/**/*.lua",
    "animations/*.lua",
    "animations/creators/*.lua",
    "locales/*.lua"
}

client_scripts {
    "src/interactions/*.lua",
    "src/resource/client/**/*.lua",
    "frameworks/qbox/client.lua",
    'frameworks/custom/client.lua',
    "frameworks/esx/client.lua",
    "frameworks/qbcore/client.lua"
}

server_scripts {
    "webhooks.lua",
    'src/resource/server/**/*.lua',
    'frameworks/qbox/server.lua',
    'frameworks/custom/server.lua',
    'frameworks/esx/server.lua',
    'frameworks/qbcore/server.lua',
}

dependencies {
    "ox_lib"
}

escrow_ignore {
    "config.lua",
    "webhooks.lua",
    "controls.json",
    'frameworks/**/*.lua',
    "animations/*.lua",
    "animations/creators/*.lua",
    "locales/*.lua",
    "src/interactions/*.lua",
    "src/resource/shared/funcs.lua",
    "src/resource/client/modules/*.lua",
    "src/resource/shared/modules/backward_compatibility.lua",
    "src/resource/shared/modules/emote_registration.lua",
    "src/resource/shared/modules/sit_any_chair.lua",
    "stream/**/*",
    "theme.json"
}

dependency '/assetpacks'