fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'apex_strategy'
author 'Apex Scripts'
description 'Quadro de estratégia para a polícia, quadro branco e mapa táctico, com o ecrã desenhado na própria prop.'
version '1.1.0'

shared_scripts {
    'shared/config.lua',
    -- Os locales entram antes do locale.lua para o L() os encontrar.
    -- Acrescentar uma língua é criar o ficheiro e declará-lo aqui.
    'locales/en.lua',
    'locales/pt.lua',
    'shared/locale.lua',
    'shared/utils.lua',
    'shared/framework.lua',
    'shared/integrations.lua',
}

client_scripts {
    'client/net.lua',
    'client/hud.lua',
    'client/notify.lua',
    'client/screen.lua',
    'client/place.lua',
    'client/calibrate.lua',
    'client/boards.lua',
    'client/nui.lua',
    'client/interact.lua',
    'client/anim.lua',
    'client/main.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/net.lua',
    'server/database.lua',
    'server/main.lua',
    'server/auth.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/board.html',
    'html/css/style.css',
    'html/js/board.js',
    'html/js/app.js',
    'html/js/dui.js',
    'stream/apx_whiteboard1.ytyp',
    'stream/apx_whiteboard2.ytyp',
}

-- Os .ytyp definem os archetypes dos quadros (apx_whiteboard1/2,
-- feitos no Apex Prop Studio). Sem o DLC_ITYP_REQUEST o modelo
-- existe no stream mas o CreateObject não o conhece.
data_file 'DLC_ITYP_REQUEST' 'stream/apx_whiteboard1.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/apx_whiteboard2.ytyp'

-- stream/apex_strategy_sf_*.gfx são cópias renomeadas do
-- television_scaleform (o mesmo .gfx que o apex_obd usa na TV do
-- dyno). Renomeados para não colidirem com o apex_obd nem com o
-- tv_scaleform, que já ocupam esses nomes. A pasta stream/ é
-- apanhada automaticamente, não se declara em files.
--
-- ATENÇÃO: ficheiros novos em stream/ só ficam registados depois de
-- um restart COMPLETO do servidor. Enquanto isso não acontecer o
-- script cai sozinho para os scaleforms do apex_obd.
dependencies {
    '/assetpacks',
}

-- -----------------------------------------------------------
-- ESCROW build: the config, every locale, the shared bridges, the
-- SQL bootstrap, the streamed assets (scaleforms + whiteboard props;
-- the .ytyp are data_files and MUST stay readable) and the WHOLE
-- interface (HTML/CSS/JS) stay open and editable. Only the game
-- logic in client/ and server/ is protected. Every file is listed
-- one by one on purpose: directory globs have silently left files
-- protected before.
escrow_ignore {
    'shared/config.lua',
    'shared/framework.lua',
    'shared/integrations.lua',
    'shared/locale.lua',
    'shared/utils.lua',
    'locales/en.lua',
    'locales/pt.lua',
    'html/index.html',
    'html/board.html',
    'html/css/style.css',
    'html/js/app.js',
    'html/js/board.js',
    'html/js/dui.js',
    'stream/apex_strategy_sf_1.gfx',
    'stream/apex_strategy_sf_2.gfx',
    'stream/apex_strategy_sf_3.gfx',
    'stream/apex_strategy_sf_4.gfx',
    'stream/apx_whiteboard1.ydr',
    'stream/apx_whiteboard1.ytyp',
    'stream/apx_whiteboard2.ydr',
    'stream/apx_whiteboard2.ytyp',
    'sql/install.sql',
    'README.md',
}
dependency '/assetpacks'