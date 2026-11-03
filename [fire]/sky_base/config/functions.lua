Functions = {}

-- Multi-action interaction help. Customize these two functions to use another HUD or NUI.
-- data: { id, title, actions = { { key, control, label } }, status, statusColor }
local instructional_help_visible = false
local instructional_help_text_entry = "SKY_HELP"

function Functions.ShowInstructionalHelp(data)
    local lines = {}
    if data.title and data.title ~= "" then
        lines[#lines + 1] = "~y~" .. data.title .. "~s~"
    end
    for _, action in ipairs(data.actions or {}) do
        lines[#lines + 1] = (action.control or "") .. "  " .. tostring(action.label or "")
    end
    if data.status and data.status ~= "" then
        lines[#lines + 1] = (data.statusColor or "~c~") .. data.status .. "~s~"
    end

    AddTextEntry(instructional_help_text_entry, table.concat(lines, "~n~"))
    instructional_help_visible = true
end

function Functions.HideInstructionalHelp(id)
    instructional_help_visible = false
end

if not IsDuplicityVersion() then
    CreateThread(function()
        while true do
            if instructional_help_visible then
                BeginTextCommandDisplayHelp(instructional_help_text_entry)
                EndTextCommandDisplayHelp(0, false, true, -1)
                Wait(0)
            else
                Wait(250)
            end
        end
    end)
end

-- Player state.
function Functions.IsPlayerDead()
    if Sky.FW.GetPlayerState("ishandcuffed") or Sky.FW.GetPlayerState("isDead") then
        return true
    elseif GetResourceState("sky_ambulancejob") == "started" then
        return Sky.FW.GetPlayerState("skyAmbulanceDead") == true
    elseif GetResourceState("osp_ambulance") == "started" then
        return exports["osp_ambulance"]:isDead()
    elseif GetResourceState("wasabi_ambulance") == "started" then
        return exports["wasabi_ambulance"]:isPlayerDead()
    elseif GetResourceState("brutal_ambulancejob") == "started" then
        return exports["brutal_ambulancejob"]:IsDead()
    elseif Sky.Config.framework == "mythic" then
        return LocalPlayer.state.isDead
    else
        return IsPlayerDead(PlayerId())
    end
end
