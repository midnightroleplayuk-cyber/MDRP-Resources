Config = Config or {}
Config.UsingPhone = false -- This option will be enabled automatically if using a compatible phone, no need to edit it
Config.PhoneItems = {
    ['phone'] = true,
}

CreateThread(function()
    if GetResourceState("qb-phone") ~= "missing" then
        Config.UsingPhone = "qb-phone"
        return
    end
    if GetResourceState("qs-smartphone-pro") ~= "missing" then
        Config.UsingPhone = "qs-smartphone-pro"
        if IsDuplicityVersion() then
            Config.PhoneItems = exports['qs-smartphone-pro']:getPhoneNames()
        end
        return
    end
    if GetResourceState("lb-phone") ~= "missing" then
        Config.UsingPhone = "lb-phone"
    end
end)