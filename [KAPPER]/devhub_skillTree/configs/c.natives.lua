-- In this file you can add your anti-cheat exports or switch used native to an export that is used in your other scripts.
NATIVES =  {
    SetRunSprintMultiplierForPlayer = function(player, multiplier)
        SetRunSprintMultiplierForPlayer(player, multiplier)
        -- debug
        debugPrint('SetRunSprintMultiplierForPlayer called with multiplier:', multiplier)
    end,
    SetSwimMultiplierForPlayer = function(player, multiplier)
        SetSwimMultiplierForPlayer(player, multiplier)
        -- debug
        debugPrint('SetSwimMultiplierForPlayer called with multiplier:', multiplier)
    end,
    SetPlayerMaxStamina = function(player, maxStamina)
        SetPlayerMaxStamina(player, maxStamina)
        -- debug
        debugPrint('SetPlayerMaxStamina called with maxStamina:', maxStamina)
    end,
    SetPedMaxTimeUnderwater = function(ped, maxTimeUnderwater)
        SetPedMaxTimeUnderwater(ped, maxTimeUnderwater)
        -- debug
        debugPrint('SetPedMaxTimeUnderwater called with maxTimeUnderwater:', maxTimeUnderwater)
    end,
    SetPedMaxHealth = function(ped, maxHealth)
        SetPedMaxHealth(ped, maxHealth)
        SetEntityMaxHealth(ped, maxHealth)
        -- debug
        debugPrint('SetPedMaxHealth called with maxHealth:', maxHealth, GetPedMaxHealth(ped))
    end,
    SetWeaponDamageModifier = function(weapon, damageModifier)
        SetWeaponDamageModifier(weapon, damageModifier)
        -- devhub_weaponTuner OWNS per-weapon damage. To let a weapon-damage perk
        -- (e.g. lowHpWeaponDamageMultiplier) layer ON TOP of the tuned values instead
        -- of overwriting them, comment the line above and uncomment the line below
        -- (and uncomment the SetDamageMultiplier export in devhub_weaponTuner):
        -- exports.devhub_weaponTuner:SetDamageMultiplier(damageModifier)
        -- debug
        debugPrint('SetWeaponDamageModifier called with weapon:', weapon, 'and damageModifier:', damageModifier)
    end,
    SetPlayerStamina = function(player, stamina)
        SetPlayerStamina(player, stamina)
        -- debug
        debugPrint('SetPlayerStamina called with stamina:', stamina)
    end,
    SetEntityHealth = function(entity, health)
        SetEntityHealth(entity, health)
        -- debug
        debugPrint('SetEntityHealth called with health:', health)
    end,
    SetWeaponRecoilShakeAmplitude = function(weapon, recoilShakeAmplitude)
        SetWeaponRecoilShakeAmplitude(weapon, recoilShakeAmplitude)
        -- exports.devhub_weaponTuner:SetRecoilMultiplier(recoilShakeAmplitude)
        -- debug
        debugPrint('SetWeaponRecoilShakeAmplitude called with weapon:', weapon, 'and recoilShakeAmplitude:', recoilShakeAmplitude)
    end,
    SetFeastDamageMultiplier = function(ped, feastDamageMultiplier)
        SetWeaponDamageModifier('WEAPON_UNARMED', feastDamageMultiplier)
        -- debug
        debugPrint('SetFeastDamageMultiplier called with ped:', ped, 'and feastDamageMultiplier:', feastDamageMultiplier)
    end,
}