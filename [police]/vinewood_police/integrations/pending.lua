-- Integrations detected now, wired in the phase that needs them once their exports are verified.
-- Until then they report as available but expose no methods, and vinewood_police uses its own fallbacks.
local pending = {
    radio           = { resources = { 'vinewood_radio', 'vinewood-radio' } },                 -- when its exports are checked
}

for name, def in pairs(pending) do
    VPO.Integrations.Define(name, {
        resources = def.resources,
        setup = function(res) return { resource = res, wired = false } end,
    })
end
