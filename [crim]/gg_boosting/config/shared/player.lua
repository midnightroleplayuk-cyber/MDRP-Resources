cfg = cfg or {} cfg.player = cfg.player or {}


cfg.player.levels = {}


-- Buffs are special bonuses you unlock as your boosting level increases.
-- Each entry below explains:
--   level      = the player level needed to unlock the bonus
--   buff_type  = what kind of bonus you get (reputation or money)
--   amount     = how strong the bonus is (100 means double rewards)

-- Buffs are added together as you level up they stack.
--  By level 50 the TOTAL bonuses will be:
--   +50% XNT
--   +100% Reputation

cfg.player.buffs = {
    {level = 2,  buff_type = "reputation", amount = 5},
    {level = 2,  buff_type = "currency",   amount = 5},
    {level = 6,  buff_type = "reputation", amount = 15},
    {level = 7,  buff_type = "currency",   amount = 5},
    {level = 10,  buff_type = "reputation", amount = 10},
    {level = 10,  buff_type = "currency",   amount = 10},
    {level = 11,  buff_type = "reputation", amount = 5},
    {level = 15,  buff_type = "reputation", amount = 10},
    {level = 15,  buff_type = "currency",   amount = 5},
    {level = 17,  buff_type = "reputation", amount = 10},
    {level = 19,  buff_type = "currency",   amount = 5},
    {level = 23,  buff_type = "reputation", amount = 10},
    {level = 23,  buff_type = "currency",   amount = 5},
    {level = 27,  buff_type = "reputation", amount = 10},
    {level = 29,  buff_type = "reputation",   amount = 5},
    {level = 33,  buff_type = "reputation", amount = 5},
    {level = 34,  buff_type = "currency",   amount = 5},
    {level = 36,  buff_type = "reputation", amount = 5},   
    {level = 42,  buff_type = "reputation", amount = 5},    
    {level = 44,  buff_type = "reputation", amount = 5}, 
    {level = 50,  buff_type = "currency", amount = 10},
}

-- Level Settings (START)
local A = 2.2           -- base scale (higher = more XP overall)
local B = 2.2           -- growth rate (higher = faster climb at higher levels)
local C = -5            -- offset (shifts curve down so lvl 1 starts near 0)
local maxLevel = 50    -- max player level allowed
local roundTo = 10      -- round XP to nearest number (10 / 50 / 100 etc)

-- Adds levels into cfg.player.levels using our algorithm above
for level = 1, maxLevel do local raw = A * (level ^ B) + C if raw < 0 then raw = 0 end local xp = math.floor(raw / roundTo + 0.5) * roundTo cfg.player.levels[level] = {} cfg.player.levels[level].rewards = {} cfg.player.levels[level].level = level cfg.player.levels[level].reputation = xp end
-- Level Settings (END)
cfg.player.mounted = true



























-- IGNORE
-- IGNORE
-- IGNORE
-- Compiling Progression Page
while not cfg or not cfg.store or not cfg.store.inventory or not cfg.vehicles or not cfg.vehicles.classes or not cfg.settings or not cfg.settings.contracts do Wait(1000) end
for k,v in pairs(cfg.vehicles.classes) do
    local payload = {
        type = 'vehicle_class',
        data = v.class,
        title = lang:get('progression.vehicle_class.l', v.class),
        description = lang:get('progression.vehicle_class.d', v.class),
    }
    table.insert(cfg.player.levels[v.unlock_requirements.required_level].rewards, payload)
end

for k,v in pairs(cfg.player.buffs) do
    if v.buff == "currency" then
        local payload = {
            type = v.buff_type,
            data = v.amount,
            title = lang:get('progression.buff_reputation.l', v.amount),
            description = lang:get('progression.buff_reputation.d', v.amount),
        }
        table.insert(cfg.player.levels[v.level].rewards, payload)
    else
        local payload = {
            type = v.buff_type,
            data = v.amount,
            title = lang:get('progression.buff_currency.l', v.amount, cfg.settings.currency.boosting),
            description = lang:get('progression.buff_currency.d', v.amount, cfg.settings.currency.boosting),
        }
        table.insert(cfg.player.levels[v.level].rewards, payload)
    end
end

for k,v in pairs(cfg.store.inventory) do
    if v.level > 1 then
        local payload = {
            type = "item",
            data = v.item,
            title = lang:get('progression.shop_item.l'),
            description = lang:get('progression.shop_item.d'),
        }
        table.insert(cfg.player.levels[v.level].rewards, payload)
    end
end

if cfg.settings.contracts.vin_scratch and cfg.settings.contracts.vin_scratch_level_req then
    local payload = {
        type = "vin_scratch",
        data = true,
        title = lang:get('progression.vin_scratch.l'),
        description = lang:get('progression.vin_scratch.d'),
    }
    table.insert(cfg.player.levels[cfg.settings.contracts.vin_scratch_level_req].rewards, payload)
end


cfg.player.init = true