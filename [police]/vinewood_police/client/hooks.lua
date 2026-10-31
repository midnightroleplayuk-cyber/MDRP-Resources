-- Hooks for other resources on your server. Left open under escrow: change these to suit your
-- inventory, phone and radio. Each runs on the restrained player's own client.
VPO.Hooks = VPO.Hooks or {}

--- Called when this player is cuffed (true) or released (false).
function VPO.Hooks.OnRestrained(restrained, cuffs)
    -- ox_inventory: no inventory and no weapons while cuffed
    if GetResourceState('ox_inventory') == 'started' then
        LocalPlayer.state:set('invBusy', restrained, false)
        LocalPlayer.state:set('canUseWeapons', not restrained, false)
    end
    -- qb-inventory
    if GetResourceState('qb-inventory') == 'started' then
        LocalPlayer.state:set('inv_busy', restrained, false)
    end
    -- lb-phone: no phone while cuffed
    if GetResourceState('lb-phone') == 'started' then
        pcall(function() exports['lb-phone']:ToggleOpen(false) end)
        pcall(function() exports['lb-phone']:ToggleDisabled(restrained) end)
    end
end

--- Called when this player starts (true) or stops (false) being escorted.
function VPO.Hooks.OnEscorted(escorted, officerServerId) end
