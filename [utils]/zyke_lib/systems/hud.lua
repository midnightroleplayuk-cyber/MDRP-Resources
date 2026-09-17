local awaitSystemStarting, override = ...

if (override == "none") then
    Functions.debug.internal("^2HUD system override set to 'none', skipping detection^7")
    return
end

local systems = {
    "jg-hud",
    "esx_hud",
    "wais-hudv6",
    "0r-hud-v3",
    "17mov_Hud",
    "izzy-hudv6",
    "vms_hud",
    "rhud",
    "envi-hud",
    "cx-hud",
    "tgiann-lumihud",
    "izzy-hudv7",
    "hex_4_hud",
    "minimal-hud",
    "izzy-hudv5",
    "tgg-hud",
    "sync-hud",
    "hex_hud_prem",
    "bablo-hud"
}

if (override ~= "auto") then
    for i = 1, #systems do
        if (systems[i] == override) then
            local resState = awaitSystemStarting(override)

            if (resState ~= "started") then
                print("^1========== [WARNING] ==========^7")
                print(("^1> HUD override '%s' is set, but the resource is not started (state: %s)^7"):format(override, resState))
                print("^1> Please make sure the resource is installed and started in your server.cfg^7")
                print("^1> You can change this in dependency_override.lua^7")
            else
                HudSystem = systems[i]
                Functions.debug.internal("^2Using " .. override .. " as HUD system (override)^7")
            end

            return
        end
    end

    local valid = {"auto", "none"}
    for i = 1, #systems do valid[#valid+1] = systems[i] end
    print(("^1[zyke_lib] Invalid HUD override '%s'. Valid options: %s^7"):format(override, table.concat(valid, ", ")))
else
    for i = 1, #systems do
        local resState = awaitSystemStarting(systems[i])

        -- If it's started, we use it
        if (resState == "started") then
            HudSystem = systems[i]
            Functions.debug.internal("^2Using " .. systems[i] .. " as HUD system^7")

            break
        end
    end
end