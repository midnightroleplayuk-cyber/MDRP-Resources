local RESOURCE = "yseries"

if GetResourceState(RESOURCE) == "missing" then return end
if not PhoneBridgeClaim(RESOURCE) then return end 

local function AddApp()
    while true do
        local ok, loaded = pcall(function() return exports[RESOURCE]:GetDataLoaded() end)
        if not ok or loaded then break end
        Wait(500)
    end

    local icon = ("nui://%s/nui/phone-icon.png"):format(GetCurrentResourceName())

    local ok, err = pcall(function()
        exports[RESOURCE]:AddCustomApp({
            key        = PhoneAppMeta.id,
            name       = PhoneAppMeta.name,
            defaultApp = true,
            ui         = PhoneAppUI(),
            icon       = {
                yos      = icon,
                humanoid = icon,
            },
        })
    end)
    if not ok then
        print(("[pickle_restaurants] yseries AddCustomApp failed: %s"):format(tostring(err)))
    end
end

CreateThread(function()
    while GetResourceState(RESOURCE) ~= "started" do Wait(500) end
    AddApp()
end)

AddEventHandler("onResourceStart", function(res)
    if res == RESOURCE then
        AddApp()
    end
end)

AddEventHandler("onResourceStop", function(res)
    if res == GetCurrentResourceName() then
        pcall(function() exports[RESOURCE]:RemoveCustomApp(PhoneAppMeta.id) end)
    end
end)

local PUSH_EXPORTS = { "SendAppMessage", "SendCustomAppMessage" }
local pushExport

function PhoneApp.Send(payload)
    if pushExport then
        PhoneCallExport(RESOURCE, pushExport, PhoneAppMeta.id, payload)
        return
    end
    -- PhoneCallExport, not a bare pcall: a missing export raises on the INDEX, which
    -- as an argument to pcall escapes it entirely (bridge/phone/shared.lua)
    for _, name in ipairs(PUSH_EXPORTS) do
        if PhoneCallExport(RESOURCE, name, PhoneAppMeta.id, payload) then
            pushExport = name
            return
        end
    end
end

function PhoneApp.Notify(_, _) end

function PhoneApp.Number() return nil end

function PhoneApp.Close()
    local ok, open = pcall(function() return exports[RESOURCE]:IsOpen() end)
    if ok and open == false then return end
    pcall(function() exports[RESOURCE]:ToggleOpen(false) end)
end