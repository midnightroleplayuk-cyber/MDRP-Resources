fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'op-clothing'
author 'OTHERPLANET'
description 'Advanced clothing, barber & tattoo system for FiveM'
version '1.0.4'

shared_scripts {
    '@ox_lib/init.lua',

    'config/MainConfig.lua',
    'config/CustomPeds.lua',
    'config/Categories.lua',
    'config/Pricing.lua',
    'config/Tattoos.lua',
    'config/ShopTemplates.lua',

    'framework/shared.lua',

    'shared/constants.lua',
    'shared/config.lua',
    'shared/thumbnails_map.lua',
    'shared/clothing_hash.lua',
    'shared/shops_registry.lua',
    'shared/custom_peds.lua',
    'shared/appearance.lua',
    'shared/hair_fades.lua',
    'shared/compat/convert.lua',
    'shared/compat/bridge.lua',
    'shared/adapters/framework.lua',
}

client_scripts {
    'framework/client/shared.lua',
   -- 'framework/client/esx.lua',
    'framework/client/qb.lua',
    'framework/client/qbox.lua',

    'integrations/client/utils/sendNotify.lua',
    'integrations/client/utils/targets.lua',

    'client/utils.lua',
    'client/custom_peds.lua',
    'client/appearance.lua',
    'client/clothing_hash.lua',
    'client/camera.lua',
    'client/menu.lua',
    'client/tattoos.lua',
    'client/charcreator.lua',
    'client/thumbnails.lua',
    'client/gallery.lua',
    'client/shops.lua',
    'client/shops_admin.lua',
    'client/job_lockers.lua',
    'client/job_lockers_admin.lua',
    'client/commands.lua',
    'client/debug.lua',
    'client/compat/exports.lua',
    'client/compat/legacy_exports.lua',
    'client/compat/events.lua',
    'client/main.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',

    'framework/server/shared.lua',
  --  'framework/server/esx.lua',
    'framework/server/qb.lua',
    'framework/server/qbox.lua',

    'server/persistence.lua',
    'server/shops.lua',
    'server/shops_admin.lua',
    'server/job_lockers_admin.lua',
    'server/job_lockers.lua',
    'server/thumbnails.lua',
    'server/admin.lua',
    'server/custom_peds.lua',
    'server/migration.lua',
    'server/compat/legacy_exports.lua',
    'server/greenscreen.js',
    'server/main.lua',
    'server/versioncheck.lua',
}

ui_page 'web/build/index.html'

files {
    'web/build/index.html',
    'web/build/**/*',
    'thumbnails/**',
    'web/logos/**',
    'locales/*.json',
    'data/shops_store.json',
    'data/admin_items.json',
    'data/custom_peds.json',
    'data/job_lockers_store.json',
}

dependencies {
    'ox_lib',
}

-- Legacy clothing substitutes (FiveM `provides`).
-- Other resources keep calling exports['qb-clothing'], exports['illenium-appearance'], etc.
-- Do NOT start the original resources alongside op-clothing.
provides {
    'illenium-appearance',
    'fivem-appearance',
    'skinchanger',
  -- 'esx_skin',
    'qb-clothing',
    'rcore_clothing',
}

escrow_ignore {
    'config/**',
    'framework/**',
    'integrations/**',
}
dependency '/assetpacks'