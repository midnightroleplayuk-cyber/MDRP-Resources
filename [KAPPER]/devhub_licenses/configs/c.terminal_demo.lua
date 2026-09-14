-- Only runs when Config.Dev is true

if not Config.Dev then return end

local terminalDemoCoords = vec4(452.6178, -982.5952, 30.6896, 272.4293)

Citizen.CreateThread(function()
    -- Wait for Core to be available
    while Core == nil or Core.Loaded == nil do
        Wait(500)
    end

    -- Add a target zone at the demo coords
    Core.AddCoordsToTarget(terminalDemoCoords, {
        name = "devhub_licenses:terminal_demo",
        event = "devhub_licenses:client:openTerminalDemo",
        icon = "fas fa-id-card-clip",
        label = _T('scan_license'),
        radius = 2.0,
        handler = function(entity, distance, coords, name, bone)
            return true
        end
    })

    debugPrint("^2[devhub_licenses]^7 Terminal demo target added at coords: " .. tostring(terminalDemoCoords))
end)

-- Event triggered when player interacts with the terminal demo target
RegisterNetEvent('devhub_licenses:client:openTerminalDemo', function()
    -- Open the terminal UI with a custom scan callback
    -- The callback receives the scanned license data and returns a result
    local result = exports['devhub_licenses']:showLicenseTerminal(function(license)
        debugPrint("^2[Terminal Demo]^7 License scanned:", license.licenseId, "| Template:", license.template)
        
        -- Close the terminal after 3 seconds
        SetTimeout(3000, function()
            debugPrint("^2[Terminal Demo]^7 Auto-closing terminal after 3 seconds")
            exports['devhub_licenses']:closeLicenseTerminal()
        end)

        -- Always grant access for demo purposes
        return {
            success = true,
            message = "Access Granted"
        }
    end)

    -- Handle the result after the terminal closes
    if result and result.success then
        -- Access granted
    else
        -- Access denied
    end
end)
