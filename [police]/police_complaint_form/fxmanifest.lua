fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'UK Police Complaints & Enquiries'
author 'UK RP Custom Build'
description 'IOPC-aligned front desk system — Qbox + ox_target'
version '1.0.0'

dependencies { 'ox_lib', 'ox_target', 'oxmysql' }

shared_scripts { '@ox_lib/init.lua', 'config.lua' }
client_scripts { 'client/main.lua' }
server_scripts { '@oxmysql/lib/MySQL.lua', 'server/main.lua' }
ui_page 'html/index.html'
files { 'html/**/*' }
