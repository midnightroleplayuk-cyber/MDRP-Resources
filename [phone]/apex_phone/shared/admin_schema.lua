-- ------------------------------------------------------------
-- PAINEL ADMIN: definicoes do telemovel que o painel pode mudar (lista branca, 2026-10-03)
-- Cada linha e um caminho dentro de Config. O servidor so aceita estes caminhos, valida o tipo e os
-- limites, guarda em apex_phone_admin ('settings') e aplica no Config do servidor e de todos os clientes
-- (GlobalState 'apex_phone:settings'). Os textos sao a fonte em portugues: a NUI traduz.
--   type: bool | int | num | text | select      group: separador do painel
--   restart = true: so vale para quem entrar depois (o valor e lido no arranque)
-- ------------------------------------------------------------
AdminSchema = {
    groups = {
        { id = 'general',   label = 'General',          icon = 'gear' },
        { id = 'calls',     label = 'Calls',            icon = 'phone' },
        { id = 'number',    label = 'Number',           icon = 'sim' },
        { id = 'sim',       label = 'eSIM',             icon = 'sim' },   -- eSIM (2026-10-04, server/sim.lua)
        { id = 'psim',      label = 'Physical SIM',     icon = 'sim' },   -- PSIM: SIM cards in inventory (2026-10-05, server/psim.lua)
        { id = 'social',    label = 'Social',           icon = 'users' },
        { id = 'radio',     label = 'Radio',            icon = 'mic' },   -- RADIO: radio app (2026-10-05, server/radio.lua)
        { id = 'cshare',    label = 'Contact Sharing',  icon = 'personCircle' },   -- CSHARE: contact cards nearby (2026-10-05, server/contactshare.lua)
        { id = 'recording', label = 'Recordings',       icon = 'mic' },   -- MEDIA (ronda 2): limites de gravação por telemóvel (server/recording.lua lê-os a cada uso)
        { id = 'limits',    label = 'Limits',           icon = 'gauge' },
    },
    settings = {
        { path = 'Recording.enabled', group = 'recording', type = 'bool', label = 'Record video in the Camera' },
        -- REC3 (12 nov): quem pode gravar, qualidade, teto de um vídeo, ritmo do envio e vídeos nas redes. O server/recording.lua
        -- lê tudo a cada uso (vale logo) e volta a limitar cada valor (o painel só garante o tipo e o intervalo)
        { path = 'Recording.permission.mode', group = 'recording', type = 'select', label = 'Who can record video', options = { 'all', 'ace', 'job', 'ace_or_job' },
          labels = { all = 'Everyone', ace = 'ACE permission only', job = 'Listed jobs only', ace_or_job = 'ACE permission or one of the listed jobs' } },
        { path = 'Recording.permission.ace', group = 'recording', type = 'text', label = 'ACE permission required to record video', max = 64 },
        { path = 'Recording.permission.jobs', group = 'recording', type = 'text', label = 'Jobs allowed to record video (comma-separated; job:grade = that grade and above)', max = 300 },
        { path = 'Recording.quality', group = 'recording', type = 'select', label = 'Video quality', options = { 'standard', 'high', 'ultra' },
          labels = { standard = 'Standard 640p', high = 'High 720p', ultra = 'Maximum 1080p' } },
        { path = 'Recording.video.fps', group = 'recording', type = 'int', label = 'Video frames per second (0 = use the quality preset, 10 to 30)', min = 0, max = 30 },
        { path = 'Recording.video.height', group = 'recording', type = 'int', label = 'Video height in pixels (0 = use the quality preset, 240 to 1080)', min = 0, max = 1080, step = 20 },
        { path = 'Recording.video.kbps', group = 'recording', type = 'int', label = 'Video bitrate in kbit/s (0 = use the quality preset)', min = 0, max = 8000, step = 50 },
        { path = 'Recording.video.codec', group = 'recording', type = 'select', label = 'Video format (VP9: better image quality, higher CPU usage while recording)', options = { 'auto', 'vp8', 'vp9' },
          labels = { auto = 'Use quality preset', vp8 = 'VP8', vp9 = 'VP9' } },
        { path = 'Recording.video.maxMB', group = 'recording', type = 'num', label = 'Maximum video size in MB (also limited by MySQL max_allowed_packet)', min = 1, max = 18, step = 0.5 },
        { path = 'Recording.video.audio', group = 'recording', type = 'bool', label = 'Record video with microphone audio' },
        { path = 'Recording.default.videoSeconds', group = 'recording', type = 'int', label = 'Video recording duration in seconds (phone without a specific model)', min = 3, max = 120 },
        { path = 'Recording.models.pearfold.videoSeconds', group = 'recording', type = 'int', label = 'Video recording duration on PearPhone Fold (seconds)', min = 3, max = 120 },
        { path = 'Recording.models.pear18.videoSeconds', group = 'recording', type = 'int', label = 'Video recording duration on PearPhone 18 Pro Max (seconds)', min = 3, max = 120 },
        { path = 'Recording.models.s26.videoSeconds', group = 'recording', type = 'int', label = 'Video recording duration on NOVA S26 Ultra (seconds)', min = 3, max = 120 },
        { path = 'Recording.models.novaflip.videoSeconds', group = 'recording', type = 'int', label = 'Video recording duration on NOVA Fold8 (seconds)', min = 3, max = 120 },
        { path = 'Recording.default.audioSeconds', group = 'recording', type = 'int', label = 'Voice recording duration in seconds (phone without a specific model)', min = 5, max = 1800 },
        { path = 'Recording.models.pearfold.audioSeconds', group = 'recording', type = 'int', label = 'Voice recording duration on PearPhone Fold (seconds)', min = 5, max = 1800 },
        { path = 'Recording.models.pear18.audioSeconds', group = 'recording', type = 'int', label = 'Voice recording duration on PearPhone 18 Pro Max (seconds)', min = 5, max = 1800 },
        { path = 'Recording.models.s26.audioSeconds', group = 'recording', type = 'int', label = 'Voice recording duration on NOVA S26 Ultra (seconds)', min = 5, max = 1800 },
        { path = 'Recording.models.novaflip.audioSeconds', group = 'recording', type = 'int', label = 'Voice recording duration on NOVA Fold8 (seconds)', min = 5, max = 1800 },
        { path = 'Recording.storage.maxVideosPerPlayer', group = 'recording', type = 'int', label = 'Videos stored per player (0 = unlimited)', min = 0, max = 200 },
        { path = 'Recording.storage.maxVideoMBPerPlayer', group = 'recording', type = 'int', label = 'Video storage per player in MB (0 = unlimited)', min = 0, max = 4096 },
        { path = 'Recording.storage.keepDays', group = 'recording', type = 'int', label = 'Days before non-favourite videos are deleted (0 = never)', min = 0, max = 3650 },
        { path = 'Recording.upload.share', group = 'recording', type = 'num', label = 'Video upload rate (fraction of rateLimiter_netEventSize_rate; default is 0.45)', min = 0.1, max = 0.8, step = 0.05 },
        -- contrato com o agente SOCIAL: vídeos da galeria publicados nas redes (o SOCIAL lê estas chaves com valores por omissão)
        { path = 'Recording.social.enabled', group = 'recording', type = 'bool', label = 'Post videos to social networks' },
        { path = 'Recording.social.instashot', group = 'recording', type = 'bool', label = 'Videos on Instashot' },
        { path = 'Recording.social.stories', group = 'recording', type = 'bool', label = 'Videos in Instashot Stories' },
        { path = 'Recording.social.reels', group = 'recording', type = 'bool', label = 'Videos on Reels' },
        { path = 'Recording.social.twix', group = 'recording', type = 'bool', label = 'Videos on Twix' },
        { path = 'Recording.social.recado', group = 'recording', type = 'bool', label = 'Videos on Recado' },
        { path = 'Recording.social.maxSeconds', group = 'recording', type = 'int', label = 'Maximum duration of a posted video (seconds; 0 = use the phone limit)', min = 0, max = 120 },
        { path = 'Recording.social.maxMB', group = 'recording', type = 'num', label = 'Maximum size of a posted video (MB)', min = 0.5, max = 18, step = 0.5 },
        { path = 'DefaultLanguage', group = 'general', type = 'select', label = 'Language for new accounts',
          options = { 'en', 'pt', 'es', 'fr', 'de', 'it', 'nl', 'pl', 'sv', 'da', 'tr', 'ru', 'ja', 'ko', 'zh-Hans', 'zh-Hant' } },
        { path = 'DefaultTheme', group = 'general', type = 'select', label = 'Theme for new accounts', options = { 'light', 'dark', 'auto' } },
        { path = 'Scale', group = 'general', type = 'num', label = 'Phone size on screen', min = 0.4, max = 1.2, step = 0.01 },
        { path = 'AllowWalking', group = 'general', type = 'bool', label = 'Allow walking with the phone open' },
        { path = 'CameraWalk', group = 'general', type = 'bool', label = 'Allow walking with the Camera open' },
        { path = 'ShowCursor', group = 'general', type = 'bool', label = 'Show the mouse cursor' },
        { path = 'BlockWhenDead', group = 'general', type = 'bool', label = 'Lock the phone when dead' },
        { path = 'RequireItem', group = 'general', type = 'bool', label = 'Require the phone item in the inventory' },
        { path = 'PeekSeconds', group = 'general', type = 'int', label = 'Notification preview duration in seconds', min = 1, max = 15 },
        { path = 'AutoMails', group = 'general', type = 'bool', label = 'Automatic server emails' },

        { path = 'AutoOpenOnCall', group = 'calls', type = 'bool', label = 'Open the phone when receiving a call' },
        { path = 'CallTimeout', group = 'calls', type = 'int', label = 'Seconds to ring before a call is marked as unanswered', min = 5, max = 120 },
        { path = 'UseVoice', group = 'calls', type = 'bool', label = 'Voice calls' },
        { path = 'ServiceCooldown', group = 'calls', type = 'int', label = 'Seconds between service requests', min = 0, max = 3600 },

        { path = 'NumberPrefix', group = 'number', type = 'text', label = 'Prefix displayed before the phone number', max = 8 },
        { path = 'AllowSimSwap', group = 'number', type = 'bool', label = 'Allow SIM swapping' },
        { path = 'SyncNumberToCharInfo', group = 'number', type = 'bool', label = 'Write the phone number to the framework' },

        -- eSIM: Config.Sim (server/sim.lua lê-o a cada uso; mudar aqui vale logo e os telemóveis ligados recebem 'sim:changed')
        { path = 'Sim.required', group = 'sim', type = 'bool', label = 'Require an eSIM to have a phone number' },
        { path = 'Sim.maxLines', group = 'sim', type = 'int', label = 'Phone numbers per device', min = 1, max = 3 },
        { path = 'Sim.allowRemove', group = 'sim', type = 'bool', label = 'Allow phone lines to be removed' },
        { path = 'Sim.scanSeconds', group = 'sim', type = 'num', label = 'QR code scanning time in seconds', min = 0.8, max = 5, step = 0.1 },

        -- PSIM: Config.PhysicalSim (server/psim.lua). Ligar/desligar so vale depois de reiniciar o apex_phone (decide-se no
        -- arranque, depois de o painel carregar); as outras duas leem-se a cada uso
        { path = 'PhysicalSim.enabled', group = 'psim', type = 'bool', label = 'Physical SIM: the phone number is stored on a SIM card (restart apex_phone)', restart = true },
        { path = 'PhysicalSim.starterSim', group = 'psim', type = 'select', label = 'SIM for new accounts', options = { 'auto', 'item', 'none' },
          labels = { auto = 'Number already on the phone', item = 'SIM card in inventory', none = 'No number until a SIM card is obtained' } },
        { path = 'PhysicalSim.esimCards', group = 'psim', type = 'select', label = 'eSIM cards with physical SIM', options = { 'slot', 'off' },
          labels = { slot = 'Insert the number into the empty slot', off = 'Disabled' } },
        -- 1.3.0: contactos no cartao e recuperacao de um numero perdido (lidos a cada uso)
        { path = 'PhysicalSim.contactsOnSim', group = 'psim', type = 'bool', label = 'Contacts stored on the SIM card' },
        { path = 'PhysicalSim.recover.enabled', group = 'psim', type = 'bool', label = 'Recover a lost number (new card with the same number)' },
        { path = 'PhysicalSim.recover.price', group = 'psim', type = 'num', label = 'Recovery cost (bank)', min = 0, max = 1000000, step = 10 },
        { path = 'PhysicalSim.recover.blockOld', group = 'psim', type = 'bool', label = 'Permanently deactivate the old SIM card' },

        { path = 'Social.instashot', group = 'social', type = 'bool', label = 'Instashot' },
        { path = 'Social.twix', group = 'social', type = 'bool', label = 'Tweeter' },
        { path = 'Social.reels', group = 'social', type = 'bool', label = 'Reels' },
        { path = 'Social.darkchat', group = 'social', type = 'bool', label = 'Dark Chat' },
        { path = 'Onion.enabled', group = 'social', type = 'bool', label = 'Anonymous marketplace (Onion)' },
        { path = 'Onion.crypto', group = 'social', type = 'bool', label = 'Crypto wallet' },
        { path = 'Marketplace.transferItems', group = 'social', type = 'bool', label = 'Marketplace delivers items' },
        { path = 'AI.enabled', group = 'social', type = 'bool', label = 'Vera Chat assistant' },
        { path = 'Browser.enabled', group = 'social', type = 'bool', label = 'Browser' },

        -- RADIO: Config.Radio (server/radio.lua le-o a cada uso; desligar ou mudar um requisito desliga logo quem deixar de o cumprir)
        { path = 'Radio.enabled', group = 'radio', type = 'bool', label = 'Radio app' },
        { path = 'Radio.requireEarbuds', group = 'radio', type = 'bool', label = 'Require earbuds to be worn' },
        { path = 'Radio.requireItem', group = 'radio', type = 'text', label = 'Required item (blank = none)', max = 40 },
        { path = 'Radio.showMembers', group = 'radio', type = 'select', label = 'Who is on the channel', options = { 'names', 'numbers', 'count', 'none' },
          labels = { names = 'Names', numbers = 'Phone numbers', count = 'Number of people only', none = 'Hidden' } },   -- RADIO2: rotulos
        { path = 'Radio.disableWhenDead', group = 'radio', type = 'bool', label = 'Turn off the radio when dead' },
        { path = 'Radio.allowInVehicle', group = 'radio', type = 'bool', label = 'Allow radio use inside vehicles' },
        { path = 'Radio.keepOnWhenPhoneClosed', group = 'radio', type = 'bool', label = 'Keep the radio on when the phone is put away' },
        { path = 'Radio.privateChannels', group = 'radio', type = 'bool', label = 'Password-protected private channels' },
        { path = 'Radio.maxMembersPerChannel', group = 'radio', type = 'int', label = 'People per channel (0 = unlimited)', min = 0, max = 200 },
        -- RADIO2: modo de falar e animacao (o cliente le-os a cada uso; mudar o modo com o radio ligado aplica-se em 1 s).
        -- labels: nome mostrado de cada opcao (o valor guardado continua a ser a opcao; a NUI traduz o texto)
        { path = 'Radio.talkMode', group = 'radio', type = 'select', label = 'Talk mode', options = { 'ptt', 'toggle', 'open' },
          labels = { ptt = 'Hold to talk', toggle = 'Press to toggle on/off', open = 'Open microphone' } },
        { path = 'Radio.allowPlayerMode', group = 'radio', type = 'bool', label = 'Allow each player to choose their talk mode' },
        { path = 'Radio.animation.enabled', group = 'radio', type = 'bool', label = 'Talking animation' },
        { path = 'Radio.animation.whenPhoneOpen', group = 'radio', type = 'bool', label = 'Animation while holding the phone' },
        { path = 'Radio.animation.inVehicle', group = 'radio', type = 'bool', label = 'Animation inside vehicles' },

        -- CSHARE: Config.ContactShare (server/contactshare.lua e client/contactshare.lua leem-no a cada uso: vale logo; as
        -- opcoes do ox_target/qb-target refazem-se em 5 s)
        { path = 'ContactShare.enabled', group = 'cshare', type = 'bool', label = 'Contact sharing' },
        { path = 'ContactShare.target', group = 'cshare', type = 'bool', label = '"Share contact" options in ox_target / qb-target' },
        { path = 'ContactShare.distance', group = 'cshare', type = 'num', label = 'Distance in metres for phone contact sharing to appear', min = 1, max = 15, step = 0.5 },

        { path = 'MaxPhotos', group = 'limits', type = 'int', label = 'Photos per player', min = 10, max = 500 },
        { path = 'DarkChatTTL', group = 'limits', type = 'int', label = 'Minutes before Dark Chat messages are deleted (0 = never)', min = 0, max = 10080 },
        { path = 'Notifications.keepDays', group = 'limits', type = 'int', label = 'Days notifications are kept', min = 1, max = 90 },
        { path = 'Notifications.maxPerPlayer', group = 'limits', type = 'int', label = 'Notifications stored per player', min = 20, max = 1000 },
    },
}

-- caminho 'A.b' -> valor atual em Config (nil se nao existir)
function AdminSchemaGet(path)
    local t = Config
    for part in tostring(path):gmatch('[^%.]+') do
        if type(t) ~= 'table' then return nil end
        t = t[part]
    end
    return t
end

-- escreve em Config pelo caminho (cria as tabelas intermedias que faltem)
function AdminSchemaSet(path, value)
    local parts = {}
    for part in tostring(path):gmatch('[^%.]+') do parts[#parts + 1] = part end
    local t = Config
    for i = 1, #parts - 1 do
        if type(t[parts[i]]) ~= 'table' then t[parts[i]] = {} end
        t = t[parts[i]]
    end
    t[parts[#parts]] = value
end

-- linha do esquema por caminho
function AdminSchemaFind(path)
    for _, s in ipairs(AdminSchema.settings) do if s.path == path then return s end end
    return nil
end
