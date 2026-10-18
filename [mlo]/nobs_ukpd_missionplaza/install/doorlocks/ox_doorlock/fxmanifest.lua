-- optional helper resource: nobs_ukpd_missionplaza_doorlock (ox_doorlock interlocks only)
fx_version 'cerulean'
game 'gta5'
author 'NO BS SCRIPTS'
dependency 'ox_doorlock'
server_script 'interlock_ox.lua'
-- Cfx escrow: this optional helper ships open (readable Lua).
escrow_ignore { '*.lua', '**/*.lua' }
