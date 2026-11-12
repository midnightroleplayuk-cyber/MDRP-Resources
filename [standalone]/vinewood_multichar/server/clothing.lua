--[[ ─────────────────────────────────────────────────────────────
    CLOTHING (open file)
    Loads each character's saved look so the selection screen can
    dress their preview ped. The client side lives in
    client/appearance.lua, and new-character creators in client/open.lua.
───────────────────────────────────────────────────────────── ]]
Clothing = {}
Clothing.Name = VMC.DetectClothing()

local decode = Bridge.Decode

local function freemode(char)
    return char.gender == 'female' and 'mp_f_freemode_01' or 'mp_m_freemode_01'
end

-- Qbox / QBCore keep skins in `playerskins` (illenium, fivem-appearance, qb-clothing, op-clothing)
local function fromPlayerskins(chars)
    local ids = {}
    for _, c in ipairs(chars) do ids[#ids + 1] = c.id end
    if #ids == 0 then return end
    local ok, rows = pcall(MySQL.query.await, 'SELECT citizenid, model, skin FROM playerskins WHERE active = 1 AND citizenid IN (?)', { ids })
    if not ok or not rows then return end
    local map = {}
    for _, r in ipairs(rows) do map[r.citizenid] = r end
    for _, c in ipairs(chars) do
        local r = map[c.id]
        if r then
            c.skin = decode(r.skin)
            c.model = c.skin.model or r.model
        end
    end
end

-- rcore_clothing: its own tables, read through its export (returns { ped_model, skin })
local function fromRcore(chars)
    for _, c in ipairs(chars) do
        local ok, data = pcall(function() return exports.rcore_clothing:getSkinByIdentifier(c.id) end)
        if ok and type(data) == 'table' and data.skin then
            c.skin = data -- the whole table goes to setPedSkin, as rcore's own multichar guides do
            c.model = data.ped_model
        else
            c.skin = nil
        end
    end
end

--[[ Custom clothing script? Fill this in and set Config.Clothing = 'custom'.
     Set c.skin (anything your client hook understands) and c.model for each character. ]]
local function fromCustom(chars)
    -- for _, c in ipairs(chars) do
    --     local data = exports.my_clothing:GetSkin(c.id)
    --     c.skin, c.model = data, data and data.model
    -- end
end

function Clothing.Attach(chars)
    local name = Clothing.Name
    if name == 'rcore_clothing' then
        fromRcore(chars)
    elseif name == 'custom' then
        fromCustom(chars)
    elseif Bridge.Name ~= 'esx' then
        fromPlayerskins(chars)
    end
    -- ESX keeps every format in users.skin, already loaded by bridge.lua

    for _, c in ipairs(chars) do
        c.skinFormat = name
        if type(c.skin) == 'table' and not next(c.skin) then c.skin = nil end
        if not c.model and c.skin then
            if c.skin.model then
                c.model = c.skin.model
            elseif c.skin.sex ~= nil then -- skinchanger
                c.model = c.skin.sex == 1 and 'mp_f_freemode_01' or 'mp_m_freemode_01'
            end
        end
        c.model = c.model or freemode(c)
    end
end

CreateThread(function()
    Wait(1000) -- re-check in case the clothing script started after us
    Clothing.Name = VMC.DetectClothing()
    print(('^2[vinewood_multichar]^7 clothing: ^5%s^7'):format(Clothing.Name))
    if Clothing.Name == 'none' then
        print('^3[vinewood_multichar]^7 No clothing script found. Characters will preview in default clothes. Set Config.Clothing if yours isn\'t detected.')
    end
end)
