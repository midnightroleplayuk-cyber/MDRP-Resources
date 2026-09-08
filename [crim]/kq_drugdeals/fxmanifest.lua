fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'

author 'KuzQuality | Kuzkay'
description 'Drug Deals system by KuzQuality.com'
version '1.3.0'

data_file 'DLC_ITYP_REQUEST' 'stream/kq_drugdeals.ytyp'

ui_page 'nui/dist/nui.html'

shared_scripts {
    'config.lua',
    'shared/settings.lua',
    'shared/utils.lua',
    'shared/locale.lua',
    'shared/drugs/pricing.lua',
    'shared/editable/phoneIntegrations.lua',

    'syncObject/shared.lua',
    'syncObject/utils/helpers.lua',
    'syncObject/utils/hasher.lua',
}

client_scripts {
    'client/utils.lua',
    'client/helpers.lua',
    'client/editable/editable.lua',

    'client/core/main.lua',
    'client/core/drugs.lua',
    'client/core/peds.lua',
    'client/core/handover.lua',
    'client/core/nui.lua',
    'client/core/cleanup.lua',

    'client/street/state.lua',
    'client/street/peds.lua',
    'client/street/approach.lua',
    'client/street/outcomes.lua',
    'client/street/witness.lua',
    'client/street/deal.lua',

    'client/corner/main.lua',
    'client/corner/deal.lua',

    'syncObject/cache.lua',
    'syncObject/client.lua',
    'client/classes/deaddrop.lua',
    'client/classes/dropmarking.lua',
    'client/classes/deliveryped.lua',
    'client/classes/orgped.lua',

    'client/app/phone.lua',
    'client/app/delivery.lua',

    'client/police/app.lua',

    'client/org/sell.lua',
    'client/org/fixer.lua',
    'client/org/favours.lua',

    'client/admin/zones.lua',
    'client/admin/freecam.lua',
    'client/admin/editor.lua',
    'client/admin/setup.lua',
}

server_scripts {
    'server/utils.lua',
    'server/editable/editable.lua',
    'server/editable/sql.lua',
    'server/editable/setup.lua',
    'server/editable/init.lua',

    'server/core/sync.lua',
    'server/core/drugs.lua',
    'server/core/payouts.lua',
    'server/core/market.lua',
    'server/core/police.lua',
    'server/core/props.lua',

    'server/street/hotspots.lua',
    'server/street/deal.lua',

    'server/corner/main.lua',

    'syncObject/server.lua',
    'server/classes/deaddrop.lua',
    'server/classes/dropmarking.lua',
    'server/classes/deliveryped.lua',
    'server/classes/orgped.lua',

    'server/app/locations.lua',
    'server/app/threads.lua',
    'server/app/contacts.lua',
    'server/app/delivery.lua',

    'server/police/sting.lua',
    'server/police/heat.lua',

    'server/org/unlocks.lua',
    'server/org/limits.lua',
    'server/org/standings.lua',
    'server/org/contacts.lua',
    'server/org/sell.lua',
    'server/org/fixer.lua',
    'server/org/favours.lua',

    'server/admin/panel.lua',
    'server/admin/setup.lua',
    'server/admin/forcemsg.lua',
    'server/admin/contacts.lua',

    'server/core/main.lua',
    'server/core/exports.lua',
}

files {
    'locales/*.json',

    'shared/settings.lua',
    'shared/locale.lua',
    'syncObject/shared.lua',

    'nui/dist/nui.html',
    'nui/dist/app.js',
    'nui/dist/app.css',
    'nui/dist/assets/**.*',
    'nui/dist/assets/peds/*.webp',
    'nui/dist/assets/sounds/*.mp3',
}

escrow_ignore {
    'config.lua',

    'client/editable/**.*',
    'server/editable/**.*',
    'shared/editable/**.*',
    'locales/*.json',
}

dependencies {
    'kq_link',
}

dependency '/assetpacks'