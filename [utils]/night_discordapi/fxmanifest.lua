-- Resource Metadata
fx_version 'cerulean'
games {'gta5'}

author 'Nights Software'
description 'API to fetch data from Discord'
version '2.3.0'
lua54 'yes'

server_only 'yes'

server_scripts {
    'config/config.lua', 
    'server/*.lua'
}

server_exports {
    'IsUserPartOfThisGuild',
    'IsUserPartOfAnyOfTheseGuilds',
    'IsUserPartOfAllOfTheseGuilds',
    'GetDiscordUser',
    'GetDiscordMember',
    'GetDiscordMemberRoles',
    'GetDiscordMemberRoleIds',
    'IsMemberPartOfThisRole',
    'IsMemberPartOfAnyOfTheseRoles',
    'IsMemberPartOfAllOfTheseRoles',
    'GetDiscordGuild',
    'GetConfiguredRoles',
    'GetConfiguredGuilds',
    'GetCacheStats'
}

escrow_ignore {'config/config.lua'}
dependency '/assetpacks'