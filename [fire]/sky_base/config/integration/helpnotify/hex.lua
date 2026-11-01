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

local resource = Sky.Config.helpnotify
if not supported_resources[resource] then return end

-- HelpNotify is the documented per-frame export, including on HEX HUD v1.
function Sky.Functions.ShowHelpNotification(msg, key)
    exports[resource]:HelpNotify(msg or "", key or "E")
end
