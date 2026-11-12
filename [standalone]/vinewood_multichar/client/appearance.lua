Appearance = {}

local function loadModel(model)
    local hash = type(model) == 'number' and model or joaat(model)
    if not IsModelInCdimage(hash) then return nil end
    RequestModel(hash)
    local t = GetGameTimer() + 8000
    while not HasModelLoaded(hash) and GetGameTimer() < t do Wait(0) end
    return HasModelLoaded(hash) and hash or nil
end
Appearance.LoadModel = loadModel

function Appearance.ModelFor(char)
    local m = char.model
    if m and m ~= '' then
        local n = tonumber(m)
        if n then return n end
        return m
    end
    return char.gender == 'female' and 'mp_f_freemode_01' or 'mp_m_freemode_01'
end

-- Minimal skinchanger (ESX) applier for preview peds
local function applySkinchanger(ped, s)
    local function comp(id, d, t) if s[d] then SetPedComponentVariation(ped, id, s[d], s[t] or 0, 2) end end
    local function prop(id, d, t)
        if s[d] == nil then return end
        if s[d] == -1 then ClearPedProp(ped, id) else SetPedPropIndex(ped, id, s[d], s[t] or 0, true) end
    end
    SetPedHeadBlendData(ped, s.mom or s.face or 0, s.dad or s.face or 0, 0, s.skin or 0, s.skin or 0, 0, (s.face_md_weight or 50) / 100, (s.skin_md_weight or 50) / 100, 0.0, false)
    SetPedComponentVariation(ped, 2, s.hair_1 or 0, s.hair_2 or 0, 2)
    SetPedHairColor(ped, s.hair_color_1 or 0, s.hair_color_2 or 0)
    if s.beard_1 then SetPedHeadOverlay(ped, 1, s.beard_1, (s.beard_2 or 10) / 10); SetPedHeadOverlayColor(ped, 1, 1, s.beard_3 or 0, s.beard_4 or 0) end
    if s.eyebrows_1 then SetPedHeadOverlay(ped, 2, s.eyebrows_1, (s.eyebrows_2 or 10) / 10); SetPedHeadOverlayColor(ped, 2, 1, s.eyebrows_3 or 0, s.eyebrows_4 or 0) end
    comp(8, 'tshirt_1', 'tshirt_2'); comp(11, 'torso_1', 'torso_2'); comp(3, 'arms', 'arms_2')
    comp(4, 'pants_1', 'pants_2'); comp(6, 'shoes_1', 'shoes_2'); comp(1, 'mask_1', 'mask_2')
    comp(9, 'bproof_1', 'bproof_2'); comp(7, 'chain_1', 'chain_2'); comp(5, 'bags_1', 'bags_2'); comp(10, 'decals_1', 'decals_2')
    prop(0, 'helmet_1', 'helmet_2'); prop(1, 'glasses_1', 'glasses_2'); prop(2, 'ears_1', 'ears_2')
    prop(6, 'watches_1', 'watches_2'); prop(7, 'bracelets_1', 'bracelets_2')
end

local appliers = {
    ['illenium-appearance'] = function(ped, skin) exports['illenium-appearance']:setPedAppearance(ped, skin) end,
    ['fivem-appearance']    = function(ped, skin) exports['fivem-appearance']:setPedAppearance(ped, skin) end,
    ['qb-clothing']         = function(ped, skin) TriggerEvent('qb-clothing:client:loadPlayerClothing', skin, ped) end,
    ['skinchanger']         = applySkinchanger,
    ['rcore_clothing']      = function(ped, skin) exports.rcore_clothing:setPedSkin(ped, skin) end,
    ['op-clothing']         = function(ped, skin) exports['op-clothing']:SetPedSkin(ped, skin) end,
    -- qs-appearance takes over illenium's exports, so either name works
    ['qs-appearance']       = function(ped, skin)
        local ok = pcall(function() exports['qs-appearance']:setPedAppearance(ped, skin) end)
        if not ok then exports['illenium-appearance']:setPedAppearance(ped, skin) end
    end,
    -- 'custom': fill in Open.ApplyPreviewSkin in client/open.lua
    ['custom']              = function(ped, skin, char) Open.ApplyPreviewSkin(ped, skin, char) end,
}

function Appearance.Apply(ped, char)
    local skin, fmt = char.skin, char.skinFormat
    if not skin or (type(skin) == 'table' and not next(skin)) then
        SetPedDefaultComponentVariation(ped)
        return
    end
    -- ESX servers using skinchanger-format skins with another script fall back to the built-in applier
    if fmt ~= 'skinchanger' and type(skin) == 'table' and skin.sex ~= nil and skin.tshirt_1 ~= nil then fmt = 'skinchanger' end
    local fn = appliers[fmt]
    if not fn then SetPedDefaultComponentVariation(ped) return end
    local ok, err = pcall(fn, ped, skin, char)
    if not ok then
        print(('^3[vinewood_multichar]^7 could not apply %s skin to preview: %s'):format(tostring(fmt), tostring(err)))
        SetPedDefaultComponentVariation(ped)
    end
end
