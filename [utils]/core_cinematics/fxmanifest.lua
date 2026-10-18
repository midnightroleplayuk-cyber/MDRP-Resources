fx_version 'cerulean'
game 'gta5'

description 'Core Cinematics - In-Game Cinematic Editor'
version '1.6.0'

lua54 'yes'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/c8recinematics.png',
    'html/transitions.js',
    'html/script.js',
    'html/textdui/text.html',
    'html/imagedui/image.html',
    'locales/*.json',
}

client_scripts {
    'config.lua',
    'client/modules/text_placement.lua',
    'client/modules/drift_smoke.lua',
    'client/modules/anim_providers.lua',
    'client/main.lua',
    'client/modules/world_sync.lua', -- LAST: wraps openUI/closeUI to borrow weather/time from the server's sync
}

server_scripts {
    'config.lua',
    'server/main.lua',
}

escrow_ignore {
    'config.lua',
    'locales/*.json',
}
dependency '/assetpacks'