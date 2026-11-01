local supported_resources = {
    hex_4_hud = true,
    hex_2_hud = true,
    hex_1_hud = true,
    hex_final_hud = true,
    hex_finalhud_v2 = true,
    hex_future_hud = true,
    hex_genesis_hud = true,
    hex_hud_prem = true,
}

local resource = Sky.Config.notification
if not supported_resources[resource] then return end

function Sky.Functions.ShowNotification(title, message, type, time)
    if type == "warn" then type = "warning" end
    exports[resource]:Notify(title or "", message or "", type or "info", time or 5000)
end
