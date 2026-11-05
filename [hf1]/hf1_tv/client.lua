local screens, current, pending, dui, txd, renderId = {}, nil, nil, nil, nil, nil
local dict = 'hf1_tv_' .. GetPlayerServerId(PlayerId())
local tex = 'display'
local focused = false
local volumeDialog = nil
local localMuted = false
local lastEffectiveVolume = -1
local function notice(msg, kind)
    lib.notify({title='HF1 TV', description=msg, type=kind or 'inform'})
end
local function keyFor(entity)
    local c = GetEntityCoords(entity)
    return ('%d:%d:%d:%d'):format(GetEntityModel(entity), math.floor(c.x*10+0.5), math.floor(c.y*10+0.5), math.floor(c.z*10+0.5))
end
local function closest()
    local origin = GetEntityCoords(PlayerPedId())
    local best, dist = nil, Config.SearchRadius
    for model in pairs(Config.Models) do
        local e = GetClosestObjectOfType(origin.x,origin.y,origin.z,Config.SearchRadius,model,false,false,false)
        if e ~= 0 and DoesEntityExist(e) then
            local d = #(GetEntityCoords(e)-origin)
            if d < dist then best,dist=e,d end
        end
    end
    return best,dist
end
local function closeFocus()
    if focused then SetNuiFocus(false,false) SetNuiFocusKeepInput(false) focused=false SendNUIMessage({action='hide'}) end
end
local function destroy()
    closeFocus()
    local old = dui
    dui=nil
    current=nil
    renderId=nil
    lastEffectiveVolume=-1
    if old then pcall(DestroyDui,old) end
end
local targetFailure = {}
local function setupTarget(model, name)
    -- Named targets are client-global and may survive a resource restart.
    -- Diagnose each native independently rather than silently treating a false link as a DUI failure.
    local ok, registered = pcall(IsNamedRendertargetRegistered, name)
    if not ok then print(('[hf1_tv] IsNamedRendertargetRegistered error: %s'):format(registered)) return nil end
    if registered == false or registered == 0 then
        local rok, result = pcall(RegisterNamedRendertarget, name, false)
        print(('[hf1_tv] Register target=%s ok=%s result=%s'):format(name, tostring(rok), tostring(result)))
        if not rok then return nil end
    end
    local lok, linked = pcall(IsNamedRendertargetLinked, model)
    if not lok then print(('[hf1_tv] Linked check error: %s'):format(linked)) return nil end
    if linked == false or linked == 0 then
        local linkOK, result = pcall(LinkNamedRendertarget, model)
        local checkOK, after = pcall(IsNamedRendertargetLinked, model)
        print(('[hf1_tv] Link attempt: model=%s target=%s nativeOK=%s result=%s checkOK=%s linked=%s'):format(model, name, tostring(linkOK), tostring(result), tostring(checkOK), tostring(after)))
        if not linkOK or not checkOK or after == false or after == 0 or after == nil then return nil end
    end
    local idOK, id = pcall(GetNamedRendertargetRenderId, name)
    print(('[hf1_tv] Render ID: target=%s nativeOK=%s id=%s'):format(name, tostring(idOK), tostring(id)))
    -- Render IDs are signed 32-bit hashes: negative values are valid. -1 is the invalid sentinel.
    if not idOK or type(id) ~= 'number' or id == -1 or id == 0 then return nil end
    return id
end
local function message(data)
    if dui and IsDuiAvailable(dui) then SendDuiMessage(dui,json.encode(data)) end
end
local function start(entity, key, data)
    destroy()
    if not data or data.kind == 'off' then return end
    local model=GetEntityModel(entity)
    local settings=Config.Models[model]
    if not settings then return end
    local id=setupTarget(model,settings.target)
    if not id then
        local signature = tostring(model)..':'..tostring(settings.target)
        if not targetFailure[signature] or GetGameTimer()-targetFailure[signature]>10000 then
            print(('[hf1_tv] Could not link %s to %s; inspect Link attempt above. If resource was restarted, fully exit and reconnect FiveM before retesting.'):format(settings.target,model))
            targetFailure[signature]=GetGameTimer()
        end
        return
    end
    -- Set the local distance-adjusted gain BEFORE the iframe is allowed to unmute.
    -- Prevents a brief burst at the server-selected (or YouTube default) volume.
    local distance = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(entity))
    local radius = math.max(0.1, Config.PerformanceRadius)
    local full = math.max(0, math.min(radius - 0.01, Config.FullVolumeDistance or 3.0))
    local gain = 0.0
    if distance <= full then gain = 1.0
    elseif distance < radius then gain = ((radius-distance)/(radius-full)) ^ (Config.AudioFadeExponent or 1.0) end
    local initialVolume = localMuted and 0 or math.floor(math.max(0, math.min(100, (tonumber(data.volume) or Config.DefaultVolume) * gain)) + 0.5)
    -- Pass initial playback in the page URL: SendDuiMessage may fire before JS loads.
    local payload = json.encode({action='play',kind=data.kind,url=data.url,volume=data.volume,initialVolume=initialVolume,initialMuted=localMuted or initialVolume==0,started=data.started,now=GetCloudTimeAsInt(),twitchParent=Config.TwitchParent or ''})
    local function urlEncode(str)
        return (str:gsub('[^%w%-_%.~]', function(c) return ('%%%02X'):format(c:byte()) end))
    end
    local page = ('https://cfx-nui-%s/html/player.html#%s'):format(GetCurrentResourceName(),urlEncode(payload))
    local twitchContentType = nil
    if data.kind == 'tiktok' then
        -- Experimental direct top-level TikTok page; unlike an iframe this avoids
        -- X-Frame-Options restrictions, but TikTok may still block CEF playback.
        local host = tostring(data.url):match('^https://([^/:?#]+)')
        host = host and host:lower() or ''
        if host ~= 'tiktok.com' and host ~= 'www.tiktok.com' and host ~= 'm.tiktok.com'
            and host ~= 'vm.tiktok.com' and host ~= 'vt.tiktok.com' then
            print('[hf1_tv] TikTok: unsupported hostname')
            return
        end
        page = data.url
        print('[hf1_tv] TikTok experimental direct DUI: ' .. page)
    end
    if data.kind == 'website' then
        -- A top-level DUI URL avoids iframe/X-Frame-Options blocking for many sites.
        -- Site CSP, login and browser compatibility restrictions still apply.
        page = data.url
    end
    if data.kind == 'twitch' then
        -- Give the hosted page its own top-level DUI document rather than nesting
        -- it in html/player.html. Twitch's iframe now has just one parent.
        local twitchUrl = Config.TwitchPlayerUrl or 'https://hf1-tv-twitch.pages.dev'
        local host, path = tostring(data.url):match('^https://([^/]+)(/[^?#]*)')
        host = host and host:lower() or ''
        if host ~= 'twitch.tv' and host ~= 'www.twitch.tv' and host ~= 'm.twitch.tv' and host ~= 'clips.twitch.tv' then
            print('[hf1_tv] Twitch: invalid hostname')
            return
        end
        local parts = {}
        for part in path:gmatch('[^/]+') do parts[#parts+1] = part end
        local keyName, keyValue
        if host == 'clips.twitch.tv' and parts[1] and parts[1]:match('^[%w_%-]+$') then
            keyName, keyValue = 'clip', parts[1]
        elseif parts[2] == 'clip' and parts[3] and parts[3]:match('^[%w_%-]+$') then
            keyName, keyValue = 'clip', parts[3]
        elseif parts[1] == 'videos' and parts[2] and parts[2]:match('^%d+$') then
            keyName, keyValue = 'video', parts[2]
        elseif parts[1] and parts[1]:match('^[%w_]+$') and #parts[1] >= 2 and #parts[1] <= 25 then
            keyName, keyValue = 'channel', parts[1]
        else
            print('[hf1_tv] Twitch: invalid channel or VOD path')
            return
        end
        twitchContentType = keyName
        local separator = twitchUrl:find('?', 1, true) and '&' or '?'
        page = twitchUrl .. separator .. keyName .. '=' .. urlEncode(keyValue)
            .. '&volume=' .. tostring(initialVolume)
            .. '&muted=' .. tostring(localMuted or initialVolume == 0)
        print('[hf1_tv] Twitch direct DUI: ' .. page)
    end
    print(('[hf1_tv] Starting player kind=%s url=%s'):format(tostring(data.kind),tostring(data.url)))
    local obj=CreateDui(page,Config.DuiWidth,Config.DuiHeight)
    if not obj then return end
    local ready=false
    for i=1,80 do if IsDuiAvailable(obj) then ready=true break end Wait(50) end
    if not ready then DestroyDui(obj) return end
    local handle=GetDuiHandle(obj)
    if not handle or handle=='' then DestroyDui(obj) return end
    txd=CreateRuntimeTxd(dict)
    if not txd or not CreateRuntimeTextureFromDuiHandle(txd,tex,handle) then DestroyDui(obj) return end
    dui=obj
    renderId=id
    current={key=key,entity=entity,model=model,started=data.started,kind=data.kind,url=data.url,volume=data.volume}
    lastEffectiveVolume=initialVolume
    -- Initial state is loaded from the URL fragment; do not race the JS listener.
    -- Experimental two-stage clip click for Pages v0.3.7:
    -- 1) Click the Cloudflare fallback button after it appears (reloads the clip).
    -- 2) Click the Twitch player's centre Play button after its reload.
    -- Synthetic DUI input may not qualify as a trusted user gesture; the second
    -- click may also pause a clip that started on its own. This is a test only.
    if data.kind == 'twitch' and twitchContentType == 'clip' then
        print('[hf1_tv] Clip two-click test scheduled: first at 5200ms, second 3200ms later')
        local clipDui = obj
        local clipKey = key
        CreateThread(function()
            local function stillCurrent()
                return dui == clipDui and current and current.key == clipKey
                    and current.kind == 'twitch' and current.url == data.url
                    and not focused and IsDuiAvailable(clipDui)
            end
            local function clickCentre(attempt)
                if not stillCurrent() then
                    print(('[hf1_tv] Clip click %d cancelled: DUI changed, unavailable or interaction active'):format(attempt))
                    return false
                end
                local cx = math.floor(Config.DuiWidth / 2)
                local cy = math.floor(Config.DuiHeight / 2)
                print(('[hf1_tv] Clip click %d: mouse move (%d,%d)'):format(attempt,cx,cy))
                SendDuiMouseMove(clipDui,cx,cy)
                Wait(160)
                if not stillCurrent() then return false end
                print(('[hf1_tv] Clip click %d: left mouse DOWN'):format(attempt))
                SendDuiMouseDown(clipDui,'left')
                Wait(180)
                -- Always release a mouse-down on the same live DUI even if focus
                -- changed during the wait, to avoid a stuck button state.
                if dui == clipDui and IsDuiAvailable(clipDui) then
                    SendDuiMouseUp(clipDui,'left')
                    print(('[hf1_tv] Clip click %d: left mouse UP'):format(attempt))
                end
                return true
            end
            Wait(5200)
            if not clickCentre(1) then return end
            Wait(3200)
            clickCentre(2)
            print('[hf1_tv] Clip two-click test complete; if still paused, use Interact with screen')
        end)
    end
end
local function sendUpdate(entity, data)
    if not entity or not DoesEntityExist(entity) then return end
    TriggerServerEvent('hf1_tv:update',keyFor(entity),data)
end
local function openVolumeDialog(entity, key, mode)
    if not entity or not DoesEntityExist(entity) then return end
    local data = screens[key]
    if mode == 'existing' and (not data or data.kind == 'off' or data.kind == 'test') then
        notice('TV is not playing', 'error') return
    end
    if focused or volumeDialog then notice('Close the current TV control first', 'error') return end
    volumeDialog = {key=key, entity=entity, mode=mode, data=data}
    SetNuiFocus(true, true)
    SendNUIMessage({action='volumeOpen', value=(mode=='existing' and data and data.volume) or Config.DefaultVolume, mode=mode})
end
-- Accept a bare hostname but always submit an HTTPS URL for server validation.
local function normalizeHttpsUrl(value)
    if type(value) ~= 'string' then return nil end
    value = value:match('^%s*(.-)%s*$')
    if value == '' or value:find('[%c%s]') or value:find('\\') then return nil end
    if value:match('^https?://') then
        if value:match('^http://') then return nil end
    elseif value:find('://', 1, true) then
        return nil
    else
        value = 'https://' .. value
    end
    local host = value:match('^https://([^/:?#]+)')
    if not host or not host:find('%.') or host:find('%.%.',1,true) then return nil end
    return value
end
local function menu(entity)
    if not DoesEntityExist(entity) then return end
    local key=keyFor(entity)
    local options={
        {title='Play a URL',description='YouTube, Twitch, TikTok or MP4/WebM',icon='play',onSelect=function()
            local result=lib.inputDialog('HF1 TV - Play',{
                {type='select',label='Content type',required=true,options={{value='youtube',label='YouTube'},{value='video',label='Direct video (MP4/WebM)'},{value='twitch',label='Twitch'},{value='tiktok',label='TikTok'}}},
                {type='input',label='HTTPS URL',required=true},
                {type='slider',label='Initial volume',description='Choose a precise volume (0–100)',min=0,max=100,step=1,default=Config.DefaultVolume,required=true}
            })
            if not result then return end
            local url=normalizeHttpsUrl(result[2])
            if not url then notice('Enter a valid HTTPS URL or domain','error') return end
            local vol=math.floor(math.max(0,math.min(100,tonumber(result[3]) or Config.DefaultVolume)))
            sendUpdate(entity,{kind=result[1],url=url,volume=vol})
        end},
        {title='Open Website',description='Load an HTTPS website directly on the TV',icon='globe',onSelect=function()
            if not Config.AllowWebsites then notice('Websites are disabled by server configuration','error') return end
            local result=lib.inputDialog('HF1 TV - Website',{{type='input',label='HTTPS website address',required=true,placeholder='https://example.com'}})
            if not result then return end
            local url=normalizeHttpsUrl(result[1])
            if not url then notice('Enter a valid HTTPS URL or domain','error') return end
            sendUpdate(entity,{kind='website',url=url,volume=0})
        end},
        {title='Toggle Mute',description='Mute or unmute this TV on your client',icon='volume-2',onSelect=function()
            if not current or current.key~=key or not dui then notice('Move closer to the active TV','error') return end
            if current.kind=='website' or current.kind=='test' then notice('This content does not support TV volume controls','error') return end
            localMuted=not localMuted
            lastEffectiveVolume=-1
            notice(localMuted and 'TV muted locally' or 'TV unmuted locally','inform')
        end},
        {title='Volume',description='Adjust volume with a numbered slider',icon='sliders-horizontal',onSelect=function()
            openVolumeDialog(entity,key,'existing')
        end},
        {title='Interact with screen',description='Visible preview, mouse clicks and scrolling; ESC to exit',icon='mouse-pointer',onSelect=function()
            local data=screens[key]
            if not data or (data.kind~='website' and data.kind~='twitch' and data.kind~='tiktok') then notice('Start Twitch, TikTok or a website first','error') return end
            if not current or current.key~=key or not dui then notice('Move closer to the active TV','error') return end
            focused=true
            SetNuiFocus(true,true)
            SendNUIMessage({action='focus',url=data.url,website=data.kind=='website',tiktok=data.kind=='tiktok'})
        end},
        {title='Reload Website',description='Reload the current webpage',icon='refresh-cw',onSelect=function()
            if not current or current.key~=key or current.kind~='website' or not dui then notice('Start a website first','error') return end
            SetDuiUrl(dui,current.url)
        end},
        {title='Test pattern',icon='monitor',onSelect=function() sendUpdate(entity,{kind='test'}) end},
        {title='Turn off',icon='power',onSelect=function() sendUpdate(entity,{kind='off'}) end}
    }
    lib.registerContext({id='hf1_tv_menu',title='HF1 Television',options=options})
    lib.showContext('hf1_tv_menu')
end
CreateThread(function()
    local models={}
    for model in pairs(Config.Models) do models[#models+1]=model end
    exports.ox_target:addModel(models,{{name='hf1_tv_interact',icon='fa-solid fa-tv',label='Interact with TV',distance=Config.InteractDistance,onSelect=function(data) menu(data.entity) end}})
    TriggerServerEvent('hf1_tv:request')
end)
RegisterNetEvent('hf1_tv:rejected',function(reason) notice(reason,'error') end)
RegisterNetEvent('hf1_tv:snapshot',function(data) screens=data or {} end)
RegisterNetEvent('hf1_tv:changed',function(key,data)
    screens[key]=data
    if current and current.key==key then
        if not data then destroy()
        elseif data.kind==current.kind and data.url==current.url then
            current.volume=data.volume
            lastEffectiveVolume=-1 -- recompute selected volume * distance gain
        else pending=true end
    end
end)
CreateThread(function()
    while true do
        local e,dist=closest()
        local key=e and keyFor(e)
        local data=key and screens[key]
        if not e or not data or dist>Config.PerformanceRadius then
            if current then destroy() end
        elseif not current or pending or current.key~=key or current.entity~=e then
            pending=false
            start(e,key,data)
        end
        Wait(Config.ScanInterval)
    end
end)
-- Draw the SAME DUI runtime texture as a large HUD preview while interacting.
-- This is not a second iframe or browser: the preview and physical TV share one DUI.
-- The transparent NUI input surface maps exactly to the preview rectangle.
CreateThread(function()
    while true do
        if focused and dui and IsDuiAvailable(dui) then
            HideHudAndRadarThisFrame()
            DrawRect(0.5, 0.5, 1.0, 1.0, 0, 0, 0, 205)
            DrawSprite(dict, tex, 0.5, 0.5, 0.80, 0.80, 0.0, 255, 255, 255, 255)
            Wait(0)
        else
            Wait(150)
        end
    end
end)
-- Distance-based local gain. Server-selected volume remains unchanged for everyone.
-- When outside PerformanceRadius the scan thread destroys the DUI entirely.
CreateThread(function()
    while true do
        if current and dui and IsDuiAvailable(dui) and DoesEntityExist(current.entity) then
            local dist = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(current.entity))
            local radius = math.max(0.1, Config.PerformanceRadius)
            local full = math.max(0, math.min(radius - 0.01, Config.FullVolumeDistance or 3.0))
            local gain = 0.0
            if dist <= full then gain = 1.0
            elseif dist < radius then
                local t = (radius - dist) / (radius - full)
                gain = t ^ (Config.AudioFadeExponent or 1.0)
            end
            local effective = localMuted and 0 or math.floor(math.max(0, math.min(100, (tonumber(current.volume) or Config.DefaultVolume) * gain)) + 0.5)
            if effective ~= lastEffectiveVolume then
                lastEffectiveVolume=effective
                message({action='volume',volume=effective,muted=localMuted or effective==0})
            end
        end
        Wait(math.max(100, Config.AudioUpdateInterval or 250))
    end
end)
CreateThread(function()
    while true do
        if current and dui and renderId and DoesEntityExist(current.entity) and IsDuiAvailable(dui) then
            local pos=GetEntityCoords(PlayerPedId())
            if #(pos-GetEntityCoords(current.entity))<=Config.PerformanceRadius then
                SetTextRenderId(renderId)
                DrawSprite(dict,tex,0.5,0.5,1.0,1.0,0.0,255,255,255,255)
                SetTextRenderId(GetDefaultScriptRendertargetRenderId())
                Wait(0)
            else Wait(150) end
        else Wait(200) end
    end
end)
RegisterCommand('tvtest',function()
    local e=closest()
    if e then sendUpdate(e,{kind='test'}) else notice('No TV nearby','error') end
end)
RegisterCommand('tvdebug',function()
    local e,d=closest()
    print(('[hf1_tv] nearest=%s dist=%s active=%s dui=%s'):format(e or 'none',d or 'none',current and current.key or 'none',tostring(dui~=nil)))
    if e then
        local model=GetEntityModel(e)
        local cfg=Config.Models[model]
        if cfg then
            local okReg,reg=pcall(IsNamedRendertargetRegistered,cfg.target)
            local okLink,link=pcall(IsNamedRendertargetLinked,model)
            print(('[hf1_tv] model=%s target=%s registered=%s (ok=%s) linked=%s (ok=%s)'):format(model,cfg.target,tostring(reg),tostring(okReg),tostring(link),tostring(okLink)))
        end
    end
end)
RegisterNUICallback('close',function(_,cb)
    if volumeDialog then volumeDialog=nil SetNuiFocus(false,false) SendNUIMessage({action='volumeHide'}) end
    closeFocus()
    cb({ok=true})
end)
RegisterNUICallback('volumeSave',function(data,cb)
    local dlg=volumeDialog
    volumeDialog=nil
    SetNuiFocus(false,false)
    SendNUIMessage({action='volumeHide'})
    if dlg and DoesEntityExist(dlg.entity) and keyFor(dlg.entity)==dlg.key then
        local vol=math.floor(math.max(0,math.min(100,tonumber(data.volume) or Config.DefaultVolume)))
        if dlg.mode=='new' then
            sendUpdate(dlg.entity,{kind=dlg.kind,url=dlg.url,volume=vol})
        elseif dlg.mode=='existing' then
            local latest=screens[dlg.key]
            if latest and latest.kind~='off' and latest.kind~='test' then
                sendUpdate(dlg.entity,{kind=latest.kind,url=latest.url,volume=vol})
            end
        end
    end
    cb({ok=true})
end)
RegisterNUICallback('wheel',function(data,cb)
    if focused and dui and IsDuiAvailable(dui) then
        local x=math.floor(math.max(0,math.min(Config.DuiWidth-1,tonumber(data.x) or 0)))
        local y=math.floor(math.max(0,math.min(Config.DuiHeight-1,tonumber(data.y) or 0)))
        SendDuiMouseMove(dui,x,y)
        SendDuiMouseWheel(dui,math.floor(tonumber(data.delta) or 0),0)
    end
    cb({ok=true})
end)
RegisterNUICallback('mouse',function(data,cb)
    if focused and dui and IsDuiAvailable(dui) then
        local x=math.floor(math.max(0,math.min(Config.DuiWidth-1,tonumber(data.x) or 0)))
        local y=math.floor(math.max(0,math.min(Config.DuiHeight-1,tonumber(data.y) or 0)))
        SendDuiMouseMove(dui,x,y)
        if data.event=='down' then SendDuiMouseDown(dui,'left') elseif data.event=='up' then SendDuiMouseUp(dui,'left') end
    end
    cb({ok=true})
end)
-- Keyboard toolbar: search Google or navigate to a full HTTPS address.
-- This is navigation, not synthetic typing into arbitrary third-party DOM inputs.
RegisterNUICallback('websiteNavigate',function(data,cb)
    if not focused or not current or current.kind~='website' or not dui then
        cb({ok=false,error='No interactive website is active'})
        return
    end
    local mode = type(data)=='table' and data.mode or nil
    local value = type(data)=='table' and data.value or nil
    if type(value)~='string' or #value<1 or #value>1200 or value:find('[%c]') then
        cb({ok=false,error='Enter a valid search or address'})
        return
    end
    local target
    if mode=='search' then
        local encoded=value:gsub('[^%w%-_%.~]',function(c) return ('%%%02X'):format(c:byte()) end)
        target='https://www.google.com/search?q='..encoded
    elseif mode=='address' then
        target=normalizeHttpsUrl(value)
        if not target then
            cb({ok=false,error='Enter a valid HTTPS URL or domain'})
            return
        end
    else
        cb({ok=false,error='Unknown navigation mode'})
        return
    end
    -- Preserve the existing server-side URL policy and multiplayer synchronization.
    local entity=current.entity
    if not entity or not DoesEntityExist(entity) then
        cb({ok=false,error='TV is no longer available'})
        return
    end
    local key=current.key
    if keyFor(entity)~=key then
        cb({ok=false,error='TV changed'})
        return
    end
    sendUpdate(entity,{kind='website',url=target,volume=0})
    closeFocus()
    cb({ok=true})
end)
RegisterNUICallback('key',function(data,cb)
    if focused and dui and IsDuiAvailable(dui) then
        -- FiveM does not expose general keyboard injection into DUI via documented natives.
        -- Website typing must use a supported in-page bridge, not a fake native.
    end
    cb({ok=true})
end)
AddEventHandler('onResourceStop',function(name)
    if name~=GetCurrentResourceName() then return end
    if volumeDialog then volumeDialog=nil SetNuiFocus(false,false) end
    destroy()
    exports.ox_target:removeModel((function() local t={} for m in pairs(Config.Models) do t[#t+1]=m end return t end)(),'hf1_tv_interact')
end)
