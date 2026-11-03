-- Client inventory ownership must be released before the selected GTA weapon.
function Sky.FW.HolsterWeapon()
    if Sky.Config.inventory == "ox" or Sky.Config.inventory == "qbox" then
        TriggerEvent("ox_inventory:disarm", true)
    end
    SetCurrentPedWeapon(PlayerPedId(), joaat("WEAPON_UNARMED"), true)
end
