Config = Config or {}

local function clothingScriptCheck(list)
    for resourceName, alias in pairs(list) do
        local state = GetResourceState(resourceName)
        if type(state) == 'string' and state:find('started', 1, true) then
            return alias
        end
    end
    return 'none'
end

local compatibleClothingList = {
    ['op-clothing'] = 'op-clothing',
    ['skinchanger'] = 'skinchanger',
    ['illenium-appearance'] = 'illenium-appearance',
    ['fivem-appearance'] = 'fivem-appearance',
    ['17mov_CharacterSystem'] = '17mov_CharacterSystem',
    ['rcore_clothing'] = 'rcore_clothing',
    ['crm-appearance'] = 'crm-appearance',
    ['tgiann-clothing'] = 'tgiann_clothing',
    ['0r-clothingv2'] = '0r-clothingv2',
}

-- ──────────────────────────────────────────────────────────────────────────────
-- Workshop wardrobe
-- ──────────────────────────────────────────────────────────────────────────────
Config.Clothing = {
    enable = true,
    clothingScript = clothingScriptCheck(compatibleClothingList) or 'none',
    maxOutfits = 20,
    interactRadius = 1.5,
    labelKey = 'wardrobe.target',
}