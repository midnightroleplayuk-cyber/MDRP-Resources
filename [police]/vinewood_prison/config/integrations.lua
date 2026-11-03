-- 'auto' uses the first adapter whose resource is running, otherwise the built-in fallback.
-- Force one by name, e.g. justice = 'manual'.
Config.Integrations = {
    justice = 'auto',  -- vinewood_moj | manual
    records = 'auto',  -- vinewood_mdt | none
    dispatch = 'auto', -- vinewood_dispatch | generic
    -- Phone numbers: lb-phone | qs-smartphone-pro | qs-smartphone | npwd | yseries | yflip | yphone
    --                gksphone | high-phone | roadphone | framework (charinfo / ESX phoneNumber)
    phone = 'auto',
}
