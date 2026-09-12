Utils.rawPrint('^2 ____  _   _   _ _____ ___    ____  _______     __^7')
Utils.rawPrint('^2|  _ \\| | | | | |_   _/ _ \\  |  _ \\| ____\\ \\   / /^7')
Utils.rawPrint('^2| |_) | | | | | | | || | | | | | | |  _|  \\ \\ / / ^7')
Utils.rawPrint('^2|  __/| |__| |_| | | || |_| | | |_| | |___  \\ V /  ^7')
Utils.rawPrint('^2|_|   |_____\\___/  |_| \\___/  |____/|_____|  \\_/   ^7')
Utils.rawPrint('')

if GetResourceState('oxmysql') ~= 'started' then
    Utils.rawPrint('^1[plt_ambulance_job] Database: oxmysql not found - script will not function^7')
end

if GetResourceState('qbx_core') == 'started' then
    Utils.rawPrint('^2[plt_ambulance_job] Framework: qbx_core^7')
elseif GetResourceState('qbx-core') == 'started' then
    Utils.rawPrint('^2[plt_ambulance_job] Framework: qbx-core^7')
elseif GetResourceState('qb-core') == 'started' then
    Utils.rawPrint('^2[plt_ambulance_job] Framework: qb-core^7')
elseif GetResourceState('es_extended') == 'started' then
    Utils.rawPrint('^2[plt_ambulance_job] Framework: es_extended^7')
else
    Utils.rawPrint('^1[plt_ambulance_job] Framework: not found - ensure your framework starts before this script^7')
end

if GetResourceState('ox_target') == 'started' then
    Utils.rawPrint('^2[plt_ambulance_job] Target: ox_target^7')
elseif GetResourceState('qb-target') == 'started' then
    Utils.rawPrint('^2[plt_ambulance_job] Target: qb-target^7')
else
    Utils.rawPrint('^1[plt_ambulance_job] Target: not found - check the bridge folder for a compatible target resource^7')
end

if GetResourceState('ox_lib') == 'started' then
    Utils.rawPrint('^2[plt_ambulance_job] Progress: ox_lib^7')
elseif GetResourceState('progressbar') == 'started' then
    Utils.rawPrint('^2[plt_ambulance_job] Progress: progressbar^7')
else
    Utils.rawPrint('^1[plt_ambulance_job] Progress: not found - check the bridge folder for a compatible progress bar resource^7')
end

if GetResourceState('origen_inventory') == 'started' then
    Utils.rawPrint('^2[plt_ambulance_job] Inventory: origen_inventory^7')
elseif GetResourceState('ox_inventory') == 'started' then
    Utils.rawPrint('^2[plt_ambulance_job] Inventory: ox_inventory^7')
elseif GetResourceState('qs-inventory') == 'started' then
    Utils.rawPrint('^2[plt_ambulance_job] Inventory: qs-inventory^7')
elseif GetResourceState('qb-inventory') == 'started' then
    Utils.rawPrint('^2[plt_ambulance_job] Inventory: qb-inventory^7')
elseif GetResourceState('ps-inventory') == 'started' then
    Utils.rawPrint('^2[plt_ambulance_job] Inventory: ps-inventory^7')
else
    Utils.rawPrint('^1[plt_ambulance_job] Inventory: not found - check the bridge folder for a compatible inventory resource^7')
end

if GetResourceState('mm_carkeys') == 'started' then
    Utils.rawPrint('^2[plt_ambulance_job] Keys: mm_carkeys^7')
elseif GetResourceState('qbx_vehiclekeys') == 'started' then
    Utils.rawPrint('^2[plt_ambulance_job] Keys: qbx_vehiclekeys^7')
elseif GetResourceState('qb-vehiclekeys') == 'started' then
    Utils.rawPrint('^2[plt_ambulance_job] Keys: qb-vehiclekeys^7')
elseif GetResourceState('wasabi_carkeys') == 'started' then
    Utils.rawPrint('^2[plt_ambulance_job] Keys: wasabi_carkeys^7')
elseif GetResourceState('cd_garage') == 'started' then
    Utils.rawPrint('^2[plt_ambulance_job] Keys: cd_garage^7')
elseif GetResourceState('okokGarage') == 'started' then
    Utils.rawPrint('^2[plt_ambulance_job] Keys: okokGarage^7')
else
    Utils.rawPrint('^1[plt_ambulance_job] Keys: not found - check the bridge folder for a compatible key resource^7')
end

if GetResourceState('wasabi_billing') == 'started' then
    Utils.rawPrint('^2[plt_ambulance_job] Billing System: wasabi_billing^7')
else
    Utils.rawPrint('^2[plt_ambulance_job] Billing System: Pluto^7')
end
