fx_version 'cerulean'
lua54 'yes'
game 'gta5'
name 'lation_chopshop'
author 'iamlation'
version '3.1.0'
description 'An advanced chop shop resource for FiveM'

ui_page 'web/build/index.html'

shared_scripts {
    '@ox_lib/init.lua',
    'lua/shared/locale.lua',
    'lua/shared/runtime.lua',
    'lua/shared/normalize.lua',
    'lua/shared/parts.lua',
    'lua/shared/locations.lua',
    'lua/shared/session.lua',
    'lua/shared/vehicle_classes.lua',
}

client_scripts {
    'lua/client/runtime.lua',
    'lua/client/nui.lua',
    'lua/bridge/client.lua',
    'lua/client/utils/ui.lua',
    'lua/client/utils/statebags.lua',
    'lua/client/utils/hooks.lua',
    'lua/client/utils/camera.lua',
    'lua/client/utils/audio.lua',
    'lua/client/drill.lua',
    'lua/client/wheels.lua',
    'lua/client/enginebay.lua',
    'lua/client/prep.lua',
    'lua/client/parts.lua',
    'lua/client/contract.lua',
    'lua/client/main.lua',
    'lua/client/shops.lua',
    'lua/client/xp.lua',
    'lua/client/utils/interact.lua',
    'lua/config/icons.lua',
    'lua/config/animations.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'lua/server/database/migrations.lua',
    'lua/server/database/init.lua',
    'lua/server/database/runtime.lua',
    'lua/bridge/server.lua',
    'lua/server/utils/perms.lua',
    'lua/server/utils/logging.lua',
    'lua/server/utils/vehicles.lua',
    'lua/server/utils/hooks.lua',
    'lua/server/contracts.lua',
    'lua/server/admin.lua',
    'lua/server/main.lua',
    'lua/server/shops.lua',
    'lua/server/version.lua',
    'lua/server/xp.lua',
}

files {
    'locales/*.json',
    'web/build/**/*',
    'audio/data/chopshop_wheel_sounds.dat54.rel',
    'audio/audiodirectory/chopshop_wheel.awc',
}

data_file 'AUDIO_WAVEPACK' 'audio/audiodirectory'
data_file 'AUDIO_SOUNDDATA' 'audio/data/chopshop_wheel_sounds.dat'

dependencies {
    'oxmysql',
    'ox_lib',
}

ox_libs {
    'locale',
    'math',
}

escrow_ignore {
    'lua/bridge/*.lua',
    'lua/client/utils/*.lua',
    'lua/server/utils/hooks.lua',
    'lua/server/utils/logging.lua',
    'lua/server/utils/perms.lua',
    'lua/server/utils/vehicles.lua',
    'locales/*.json',
    'lua/config/*.lua',
}
dependency '/assetpacks'