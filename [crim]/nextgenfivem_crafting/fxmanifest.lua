fx_version 'cerulean'
game 'gta5'
lua54 'yes'
use_experimental_fxv2_oal 'yes'

version '1.4.1'
resource 'crafting'
author 'www.nextgenfivem.com'

dependencies {
    '/onesync'
}

shared_scripts {
    'src/resource/shared/**/*.lua',

    'src/lib/*.lua',
    'src/lib/utils/sh_*.lua',
}

client_scripts {
    'src/lib/utils/cl_*.lua',

    'src/handlers/**/shared.lua',
    'src/handlers/**/client/**/*.lua',

    'src/resource/client/**/*.lua',

    'integrations/*_cl.lua',
}

server_scripts {
    'config.lua',

    'src/handlers/**/*.lua',
    'src/handlers/**/server/**/*.lua',

    'src/lib/utils/sv_*.lua',
    'src/lib/utils/sv_hooks.lua',
    'src/lib/actions/*.lua',

    'src/resource/server/**/*.lua',

    'integrations/*_sv.lua',
}

files {
    'src/ui/dui/dist/**',
    'src/ui/nui/dist/**',

    'frameworks/**/client.lua'
}

ui_page 'src/ui/nui/dist/index.html'

escrow_ignore {
    'config.lua',

    'frameworks/**/*.lua',
    'translations/*.lua',
    'src/inventories/*.lua',
    'src/databases/*.lua',
    'src/resource/shared/const.lua',
    'integrations/*.lua',
}

dependency '/assetpacks'