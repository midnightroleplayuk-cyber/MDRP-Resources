local utils = {}

local GetWorldCoordFromScreenCoord = GetWorldCoordFromScreenCoord
local StartShapeTestLosProbe = StartShapeTestLosProbe
local GetShapeTestResultIncludingMaterial = GetShapeTestResultIncludingMaterial

---@param flag number
---@return boolean hit
---@return number entityHit
---@return vector3 endCoords
---@return vector3 surfaceNormal
---@return number materialHash
function utils.raycastFromCamera(flag)
    local coords, normal = GetWorldCoordFromScreenCoord(0.5, 0.5)
    local destination = coords + normal * 10
    local handle = StartShapeTestLosProbe(coords.x, coords.y, coords.z, destination.x, destination.y, destination.z,
        flag, cache.ped, 4)

    while true do
        Wait(0)
        local retval, hit, endCoords, surfaceNormal, materialHash, entityHit = GetShapeTestResultIncludingMaterial(
        handle)

        if retval ~= 1 then
            ---@diagnostic disable-next-line: return-type-mismatch
            return hit, entityHit, endCoords, surfaceNormal, materialHash
        end
    end
end

function utils.getTexture()
    return lib.requestStreamedTextureDict('shared'), 'emptydot_32'
end

-- SetDrawOrigin is limited to 32 calls per frame. Set as 0 to disable.
local SetDrawOrigin = SetDrawOrigin
local DrawSprite = DrawSprite
local ClearDrawOrigin = ClearDrawOrigin
local GetGameTimer = GetGameTimer
local GetAspectRatio = GetAspectRatio
local colour = vector(155, 155, 155, 175)
local hover = vector(205, 255, 3, 255)
local currentZones = {}
local previousZones = {}
local drawZones = {}
local drawN = 0
local baseSize = 0.02

local function getDrawSpriteLimit()
    local limit = GetConvarInt('ox_target:drawSprite', 24)
    return limit == 0 and -1 or limit
end

local function getSquarePulse()
    return (math.sin(GetGameTimer() * 0.004) + 1) * 0.5
end

local function getSpriteColourComponents(spriteColour)
    return spriteColour.r or spriteColour.x, spriteColour.g or spriteColour.y, spriteColour.b or spriteColour.z,
        spriteColour.a or spriteColour.w or 175
end

---@param coords vector3
---@param playerCoords? vector3
---@return CZone[], boolean
function utils.getNearbyZones(coords, playerCoords)
    if not Zones then return currentZones, false end

    playerCoords = playerCoords or coords

    local n = 0
    local nearbyZones = lib.zones.getNearbyZones()
    drawN = 0
    previousZones, currentZones = currentZones, table.wipe(previousZones)

    local drawLimit = getDrawSpriteLimit()

    for i = 1, #nearbyZones do
        local zone = nearbyZones[i]
        local contains = zone:contains(coords, true)

        if contains then
            n += 1
            currentZones[n] = zone
        end

        if drawLimit > 0 and drawN < drawLimit and zone.drawSprite ~= false then
            local spriteDistance = #(zone.coords - playerCoords)
            local nearPlayer = spriteDistance < 7 or zone:contains(playerCoords)

            if nearPlayer then
                drawN += 1
                drawZones[drawN] = zone
                zone.colour = contains and hover or nil
            end
        end
    end

    local previousN = #previousZones

    if n ~= previousN then
        return currentZones, true
    end

    if n > 0 then
        for i = 1, n do
            local zoneA = currentZones[i]
            local found = false

            for j = 1, previousN do
                local zoneB = previousZones[j]

                if zoneA == zoneB then
                    found = true
                    break
                end
            end

            if not found then
                return currentZones, true
            end
        end
    end

    return currentZones, false
end

function utils.drawZoneSprites(dict, texture)
    if drawN == 0 then return end

    local pulse = getSquarePulse()
    local scale = baseSize * (0.82 + pulse * 0.36)
    local width = scale
    local height = scale * GetAspectRatio(false)

    for i = 1, drawN do
        local zone = drawZones[i]
        local spriteColour = zone.colour or colour
        local r, g, b, a = getSpriteColourComponents(spriteColour)

        if zone.drawSprite ~= false then
            SetDrawOrigin(zone.coords.x, zone.coords.y, zone.coords.z)

            local glowAlpha = math.floor(a * (0.18 + pulse * 0.22))
            DrawSprite(dict, texture, 0, 0, width * 1.35, height * 1.35, 0, r, g, b, glowAlpha)

            local alpha = math.floor(a * (0.62 + pulse * 0.38))
            DrawSprite(dict, texture, 0, 0, width, height, 0, r, g, b, alpha)
        end
    end

    ClearDrawOrigin()
end

function utils.hasExport(export)
    local resource, exportName = string.strsplit('.', export)

    return pcall(function()
        return exports[resource][exportName]
    end)
end

local playerItems = {}

function utils.getItems()
    return playerItems
end

---@param filter string | string[] | table<string, number>
---@param hasAny boolean?
---@return boolean
function utils.hasPlayerGotItems(filter, hasAny)
    if not playerItems then return true end

    local _type = type(filter)

    if _type == 'string' then
        return (playerItems[filter] or 0) > 0
    elseif _type == 'table' then
        local tabletype = table.type(filter)

        if tabletype == 'hash' then
            for name, amount in pairs(filter) do
                local hasItem = (playerItems[name] or 0) >= amount

                if hasAny then
                    if hasItem then return true end
                elseif not hasItem then
                    return false
                end
            end
        elseif tabletype == 'array' then
            for i = 1, #filter do
                local hasItem = (playerItems[filter[i]] or 0) > 0

                if hasAny then
                    if hasItem then return true end
                elseif not hasItem then
                    return false
                end
            end
        end
    end

    return not hasAny
end

---stub
---@param filter string | string[] | table<string, number>
---@return boolean
function utils.hasPlayerGotGroup(filter)
    return true
end

SetTimeout(0, function()
    if utils.hasExport('ox_inventory.Items') then
        setmetatable(playerItems, {
            __index = function(self, index)
                self[index] = exports.ox_inventory:Search('count', index) or 0
                return self[index]
            end
        })

        AddEventHandler('ox_inventory:itemCount', function(name, count)
            playerItems[name] = count
        end)
    end

    if utils.hasExport('ox_core.GetPlayer') then
        require 'client.framework.ox'
    elseif utils.hasExport('es_extended.getSharedObject') then
        require 'client.framework.esx'
    elseif utils.hasExport('qbx_core.HasGroup') then
        require 'client.framework.qbx'
    elseif utils.hasExport('ND_Core.getPlayer') then
        require 'client.framework.nd'
    end
end)

function utils.warn(msg)
    local trace = Citizen.InvokeNative(`FORMAT_STACK_TRACE` & 0xFFFFFFFF, nil, 0, Citizen.ResultAsString())
    local _, _, src = string.strsplit('\n', trace, 4)

    warn(('%s ^0%s\n'):format(msg, src:gsub(".-%(", '(')))
end

return utils
