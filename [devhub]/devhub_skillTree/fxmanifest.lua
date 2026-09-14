fx_version 'cerulean'
games {'gta5'}
lua54 'yes'

author 'DEVHUB (devhub.gg)'
description 'DEVHUB SKILL TREE'
version '3.2.0'

client_scripts {
    'configs/sh.*.lua',
    'configs/c.*.lua',
    'escrowed/**/sh.*.lua',
    'escrowed/**/c.*.lua',
}
server_scripts {
    'configs/sh.*.lua',
    'configs/s.*.lua',
    'escrowed/**/sh.*.lua',
    'escrowed/**/s.*.lua',
}

ui_page "html/index.html"

dependencies { 
    'devhub_lib', 
}

files {
    'html/**/*',
}

escrow_ignore {
    'configs/*.lua',
    'docs/*.md',
    'backups'
}

provide 'dh_skillTree'
dependency '/assetpacks'