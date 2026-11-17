
do
    local hasNative = type(GetResourceState) == 'function'

    local function up(name)
        if not hasNative then return false end
        local st = GetResourceState(name)
        return st == 'started' or st == 'starting'
    end

    if Config.Framework == 'auto' then
        if not hasNative then
            Config.Framework = 'qb' -- documented default when natives are missing
        elseif up('qbx_core') then
            Config.Framework = 'qb'
            print('[tw-builderjob] QBox (qbx_core) detected -> Framework=qb '
                .. '(qb bridge runs on the qbx_core compatibility layer)')
        elseif up('qb-core') then
            Config.Framework = 'qb'
        elseif up('es_extended') then
            Config.Framework = 'esx'
        elseif up('vrp') then
            Config.Framework = 'vrp'
        else
            Config.Framework = 'standalone'
            if up('core') then
                print('^3[tw-builderjob] a resource named "core" is running and no other framework was found. '
                    .. 'If this server runs TMC, set Config.Framework = "tmc" in config/config.lua^7')
            end
        end
        if hasNative then
            print(('[tw-builderjob] framework auto -> %s'):format(Config.Framework))
        end
    end

    if Config.Inventory == 'auto' then
        if up('ox_inventory') then
            Config.Inventory = 'ox_inventory'
        elseif up('qs-inventory') then
            Config.Inventory = 'qs_inventory'
        elseif up('codem-inventory') then
            Config.Inventory = 'codem-inventory'
        elseif up('tgiann-inventory') then
            Config.Inventory = 'tgiann-inventory'
        elseif up('qb-inventory') then
            Config.Inventory = 'qb_inventory'
        elseif Config.Framework == 'esx' then
            Config.Inventory = 'esx_inventory'
        else
            Config.Inventory = 'qb_inventory'
        end
        if hasNative then
            print(('[tw-builderjob] inventory auto -> %s'):format(Config.Inventory))
        end
    end

    if Config.InventoryImagePath == 'auto' then
        local paths = {
            ox_inventory         = 'nui://ox_inventory/web/images/',
            ['qs_inventory']     = 'nui://qs-inventory/html/images/',
            ['codem-inventory']  = 'nui://codem-inventory/html/itemimages/',
            ['tgiann-inventory'] = 'nui://tgiann-inventory/html/itemimages/',
            qb_inventory         = 'nui://qb-inventory/html/images/',
            esx_inventory        = 'nui://esx_inventory/html/images/',
        }
        Config.InventoryImagePath = paths[Config.Inventory]
            or 'nui://qb-inventory/html/images/'
    end
end

Config.MaxPlayersInLobby = 4

if Config.ClothingScript == nil or Config.ClothingScript == 'auto' then
    local hasNative = type(GetResourceState) == 'function'
    local function up(name)
        if not hasNative then return false end
        local st = GetResourceState(name)
        return st == 'started' or st == 'starting'
    end
    if     up('illenium-appearance') then Config.ClothingScript = 'illenium-appearance'
    elseif up('fivem-appearance')    then Config.ClothingScript = 'fivem-appearance'
    elseif up('rcore_clothing')      then Config.ClothingScript = 'rcore_clothing'
    elseif up('qb-clothing')         then Config.ClothingScript = 'qb-clothing'
    elseif up('esx_skin')            then Config.ClothingScript = 'esx_skin'
    else                                  Config.ClothingScript = 'none'
    end
    if hasNative then
        print(('[tw-builderjob] clothing auto -> %s'):format(Config.ClothingScript))
    end
end
