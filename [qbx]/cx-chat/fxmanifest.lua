fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name        'cx-chat'
description 'Advanced Customizable Chat System with Reactions, Mentions, Minigames & More'
author      'CX Scripts'
version     '1.0.3'

escrow_ignore {
    'config.lua',
    'server/s_logging.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/css/*.css',
    'html/js/*.js',
}

shared_scripts {
    'config.lua',
    'commands.lua',
}

client_scripts {
    'client/c_boot.lua',
    'client/c_chat.lua',
    'client/c_draw.lua',
    'client/c_commands.lua',
    'client/c_minigames.lua',
}

server_scripts {
    'server/s_logging.lua',
    'server/s_antispam.lua',
    'server/s_filter.lua',
    'server/s_commands.lua',
    'server/s_main.lua',
    'server/s_features.lua',
    'server/s_exports.lua',
}
