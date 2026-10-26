fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'vinewood-vehicleservices'
author 'Vinewood Studios'
description 'Vehicle services: motor insurance (NPC brokers), MOT testing (mechanic job) and vehicle tax/SORN, with vinewood-mdt integration'
version '1.5.1'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'shared.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'bridge/server.lua',
    'bridge/mechanic.lua',
    'server/fleet.lua',
    'server/schema.lua',
    'server/data.lua',
    'server/insurance.lua',
    'server/mot.lua',
    'server/tax.lua',
    'server/newvehicle.lua',
    'server/police.lua'
}

client_scripts {
    'client/util.lua',
    'client/broker.lua',
    'client/mot.lua',
    'client/tax.lua',
    'client/police.lua'
}

dependencies {
    'ox_lib',
    'oxmysql'
}

-- Files left open for buyers to edit; everything else is encrypted by escrow.
escrow_ignore {
    'config.lua',
    'bridge/*.lua'
}

dependency '/assetpacks'