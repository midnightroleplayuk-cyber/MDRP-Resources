local screens, current, pending, dui, txd, renderId = {}, nil, nil, nil, nil, nil
local dict = 'hf1_tv_' .. GetPlayerServerId(PlayerId())
local tex = 'display'
local focused = false
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
    if focused then SetNuiFocus(false,false) SetNuiFocusKeepInput(false) focused=false end
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
end
local function sendUpdate(entity, data)
    if not entity or not DoesEntityExist(entity) then return end
    TriggerServerEvent('hf1_tv:update',keyFor(entity),data)
end
local function menu(entity)
    if not DoesEntityExist(entity) then return end
    local key=keyFor(entity)
    local options={
        {title='Play a URL',description='YouTube, Twitch, TikTok, MP4/WebM, HLS test or website',icon='play',onSelect=function()
            local result=lib.inputDialog('HF1 TV - Play',{
                {type='select',label='Content type',required=true,options={{value='youtube',label='YouTube'},{value='video',label='Direct video (MP4/WebM)'},{value='hls',label='HLS stream (.m3u8) - experimental'},{value='twitch',label='Twitch'},{value='tiktok',label='TikTok'},{value='website',label='Website'}}},
                {type='input',label='HTTPS URL',required=true},
                {type='number',label='Volume (0-100)',default=Config.DefaultVolume,min=0,max=100}
            })
            if not result then return end
            if not result[2]:match('^https://') then notice('Use an HTTPS link','error') return end
            sendUpdate(entity,{kind=result[1],url=result[2],volume=result[3]})
        end},
        {title='Toggle Mute',description='Mute or unmute this TV on your client',icon='volume-2',onSelect=function()
            if not current or current.key~=key or not dui then notice('Move closer to the active TV','error') return end
            if current.kind~='youtube' and current.kind~='video' and current.kind~='hls' then notice('Audio control supports YouTube and direct video','error') return end
            localMuted=not localMuted
            lastEffectiveVolume=-1 -- force a new attenuation update
            notice(localMuted and 'TV muted locally' or 'TV unmuted locally','inform')
        end},
        {title='Volume',icon='volume-2',onSelect=function()
            local data=screens[key]
            if not data or data.kind=='off' then notice('TV is not playing','error') return end
            local result=lib.inputDialog('TV Volume',{{type='slider',label='Volume',min=0,max=100,default=data.volume or Config.DefaultVolume}})
            if result then sendUpdate(entity,{kind=data.kind,url=data.url,volume=result[1]}) end
        end},
        {title='Interact with screen',description='Click Twitch content warnings or website controls; ESC to exit',icon='mouse-pointer',onSelect=function()
            local data=screens[key]
            if not data or (data.kind~='website' and data.kind~='twitch') then notice('Start Twitch or a website first','error') return end
            -- NUI is a separate browser instance; direct DUI mouse events are forwarded from it.
            if not current or current.key~=key or not dui then notice('Move closer to the active TV','error') return end
            focused=true
            SetNuiFocus(true,true)
            SendNUIMessage({action='focus',url=data.url})
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
RegisterNUICallback('close',function(_,cb) closeFocus() cb({ok=true}) end)
RegisterNUICallback('mouse',function(data,cb)
    if focused and dui and IsDuiAvailable(dui) then
        local x=math.floor(math.max(0,math.min(Config.DuiWidth-1,tonumber(data.x) or 0)))
        local y=math.floor(math.max(0,math.min(Config.DuiHeight-1,tonumber(data.y) or 0)))
        SendDuiMouseMove(dui,x,y)
        if data.event=='down' then SendDuiMouseDown(dui,'left') elseif data.event=='up' then SendDuiMouseUp(dui,'left') end
    end
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
    destroy()
    exports.ox_target:removeModel((function() local t={} for m in pairs(Config.Models) do t[#t+1]=m end return t end)(),'hf1_tv_interact')
end)
