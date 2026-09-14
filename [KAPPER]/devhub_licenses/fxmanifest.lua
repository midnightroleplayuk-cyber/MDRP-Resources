fx_version 'cerulean'
games {'gta5'}
lua54 'yes'

author 'DEVHUB (devhub.gg)'
description 'DEVHUB LICENSE SYSTEM'
version '1.2.1'

client_scripts {
    '@devhub_lib/core/client/c.polyZone.lua',
    'configs/sh.*.lua',
    'configs/c.*.lua',
    'escrowed/**/sh.*.lua',
    'escrowed/client/c.*.lua',
    'escrowed/client/classes/c.*.lua',
    'escrowed/props/c.*.lua',
    'escrowed/client/hideout/c.hideout.state.lua',
    'escrowed/client/hideout/c.hideout.props.lua',
    'escrowed/client/hideout/c.hideout.functions.lua',
    'escrowed/client/hideout/c.hideout.events.lua',
    'escrowed/client/hideout/c.hideout.spawn.lua',
    'escrowed/client/hideout/c.hideout.commands.lua',
    'tests/c.tests.main.lua',
}
server_scripts {
    'configs/sh.*.lua',
    'configs/s.*.lua',
    'escrowed/**/sh.*.lua',
    'escrowed/**/s.*.lua',
    'tests/s.tests.helper.lua',
    'tests/s.tests.exports.lua',
    'tests/s.tests.main.lua',
}

ui_page "html/index.html"

dependencies {
    'devhub_lib',
    'screenshot-basic',
}

files {
    'html/**/*',
}

escrow_ignore {
    'configs/*.lua',
}



dependency '/assetpacks'