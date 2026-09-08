fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'

author 'KuzQuality | Kuzkay'
description 'Outfit bag script by KuzQuality'
version '2.2.1'

ui_page 'html/index.html'

provide 'kq_outfitbag'

dependencies {
    '/onesync'
}

files {
    'html/js/jquery.js',
    'html/fonts/barlow.ttf',
    'html/img/*.png',
    'html/index.html',
    'html/sounds/*.mp3',
}

server_scripts {
    'locale.lua',
    'config.lua',
    'server/editable/esx.lua',
    'server/editable/qb.lua',
    'server/editable/editable.lua',
    'server/utils.lua',
    'server/server.lua',
}

client_scripts {
    'locale.lua',
    'config.lua',
    'client/editable/settings.lua',
    'client/editable/esx.lua',
    'client/editable/qb.lua',
    'client/cache.lua',
    'client/utils.lua',
    'client/functions.lua',
    'client/fixed.lua',
    'client/nui.lua',
    'client/preview.lua',
    'client/main.lua',
    'client/editable/editable.lua',
    'client/editable/target.lua',
    'client/animations.lua',
    'client/skin.lua',
    'client/management.lua',
}

escrow_ignore {
    'config.lua',
    'locale.lua',
    'html/sounds/*.mp3',
    'html/fonts/barlow.ttf',
    'html/img/*.png',
    'html/index.html',
    'client/editable/*.lua',
    'server/editable/*.lua',
}

dependency '/assetpacks'