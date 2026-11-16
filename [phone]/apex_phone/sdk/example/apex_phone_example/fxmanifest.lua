-- Taxi Rank: a complete example app for the Apex Phone, built with the Apex Phone SDK (apex_phone/sdk, docs/SDK.md).
-- Copy this folder to resources/ and add `ensure apex_phone_example` after `ensure apex_phone` in server.cfg.
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Apex Scripts'
description 'Taxi Rank: example app built with the Apex Phone SDK (list from the server, form, settings, live pushes, badge)'
version '1.5.0'

server_script 'server.lua'

-- everything the phone loads into the iframe has to be listed here (the SDK files are copies of apex_phone/sdk)
files {
    'html/index.html',
    'html/app.css',
    'html/app.js',
    'html/apexphone-sdk.js',
    'html/apexphone-ui.css',
    'html/fonts/*.woff2',
}

dependency 'apex_phone'
