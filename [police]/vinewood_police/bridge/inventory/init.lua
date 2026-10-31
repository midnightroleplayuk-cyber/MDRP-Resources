-- Inventory bridge (server).
--   VPO.Inventory.Name                                 'ox' | 'qb' | 'esx' | nil
--   VPO.Inventory.Count(src, item, metadata)           number
--   VPO.Inventory.Has(src, item, count)                boolean
--   VPO.Inventory.Add(src, item, count, metadata)      boolean
--   VPO.Inventory.Remove(src, item, count, metadata, slot) boolean
--   VPO.Inventory.CanCarry(src, item, count, metadata) boolean
--   VPO.Inventory.List(src)                            { { slot, name, label, count, metadata } }
--   VPO.Inventory.ForceOpen(officer, target)           opens target's inventory for the officer (ox, qb)
--   VPO.Inventory.CanStash()                           property bags supported (ox)
--   VPO.Inventory.MoveToStash(src, stashId, label, keep) moves everything (except keep names) -> moved list
--   VPO.Inventory.ReturnFromStash(stashId, src)        gives back what fits -> returned list, left count
--   VPO.Inventory.OpenStash(officer, stashId, label)
-- Adapters register with VPO.Inventory._Register(name, detectFn, impl).

VPO.Inventory = {}
local Inv = VPO.Inventory
local adapters, order = {}, {}

function Inv._Register(name, detect, impl)
    adapters[name] = { detect = detect, impl = impl }
    order[#order + 1] = name
end

local function pick()
    local want = tostring(Config.Inventory or 'auto'):lower()
    if want ~= 'auto' then return adapters[want] and want or nil end
    for _, name in ipairs(order) do
        local ok, yes = pcall(adapters[name].detect)
        if ok and yes then return name end
    end
    return nil
end

local function impl()
    return Inv.Name and adapters[Inv.Name].impl or nil
end

--- Called once at start, after every adapter file has loaded.
function Inv._Init()
    Inv.Name = pick()
    if not Inv.Name then VPO.Log.warn('No supported inventory found: items will not be checked or given.') end
end

function Inv.Count(src, item, metadata)
    local i = impl(); if not i then return 0 end
    local ok, n = pcall(i.Count, src, item, metadata)
    return ok and tonumber(n) or 0
end

function Inv.Has(src, item, count) return Inv.Count(src, item) >= (count or 1) end

function Inv.Add(src, item, count, metadata)
    local i = impl(); if not i then return false end
    local ok, r = pcall(i.Add, src, item, count or 1, metadata)
    if not ok then VPO.Log.error('inventory add %s failed: %s', item, r) end
    return ok and r == true
end

function Inv.Remove(src, item, count, metadata, slot)
    local i = impl(); if not i then return false end
    local ok, r = pcall(i.Remove, src, item, count or 1, metadata, slot)
    if not ok then VPO.Log.error('inventory remove %s failed: %s', item, r) end
    return ok and r == true
end

function Inv.CanCarry(src, item, count, metadata)
    local i = impl(); if not i then return false end
    local ok, r = pcall(i.CanCarry, src, item, count or 1, metadata)
    return ok and r == true
end

function Inv.List(src)
    local i = impl(); if not i or not i.List then return {} end
    local ok, r = pcall(i.List, src)
    if not ok then VPO.Log.error('inventory list failed: %s', r) end
    return ok and r or {}
end

function Inv.CanForceOpen()
    local i = impl()
    return i ~= nil and i.ForceOpen ~= nil
end

function Inv.ForceOpen(officer, target)
    local i = impl(); if not i or not i.ForceOpen then return false end
    local ok, r = pcall(i.ForceOpen, officer, target)
    if not ok then VPO.Log.error('inventory open failed: %s', r) end
    return ok and r ~= false
end

function Inv.CanStash()
    local i = impl()
    return i ~= nil and i.MoveToStash ~= nil
end

function Inv.MoveToStash(src, stashId, label, keep)
    local i = impl(); if not i or not i.MoveToStash then return nil end
    local ok, r = pcall(i.MoveToStash, src, stashId, label, keep or {})
    if not ok then VPO.Log.error('move to stash failed: %s', r) end
    return ok and r or nil
end

function Inv.ReturnFromStash(stashId, src)
    local i = impl(); if not i or not i.ReturnFromStash then return nil end
    local ok, r, left = pcall(i.ReturnFromStash, stashId, src)
    if not ok then VPO.Log.error('return from stash failed: %s', r) end
    return ok and r or nil, left
end

function Inv.OpenStash(officer, stashId, label)
    local i = impl(); if not i or not i.OpenStash then return false end
    local ok = pcall(i.OpenStash, officer, stashId, label)
    return ok
end
