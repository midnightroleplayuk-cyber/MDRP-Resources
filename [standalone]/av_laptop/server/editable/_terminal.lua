defaultCommands = {"help", "clear"}
allCommands = {
    -- This commands are only EXAMPLES they will NOT trigger any action, they are just to show how the command structure should look like
    
    -- ['atm-crack'] = { -- command used, should be unique and also a string
    --     show = true, -- true/false display this command when using /help on the terminal
    --     allowed = function(playerId, laptopSerial)
    --         return true
    --     end,
    --     canProcess = function(playerId, laptopSerial, args)
    --         return true
    --     end,
    --     onSuccess = function(playerId, laptopSerial, args)

    --     end,
    --     actions = {
    --         {type = "text", input = "Initializing ATM bypass...", delay = 500},
    --         {type = "progressbar", input = "Sniffing Card Reader", delay = 5000},
    --         {type = "text", input = "Vulnerability found in firmware v4.2", style = "output", delay = 800},
    --         {type = "progressbar", input = "Infecting dispense-buffer", delay = 5000},
    --         {type = "minigame", input = "sniffer", label = "ATM_FIRMWARE_FILTER"}
    --     },
    --     output = {
    --         message = ">>> ATM CRACKED: ENCRYPTION BYPASSED. YOU CAN NOW INSTALL THE SKIMMER.",
    --         color = "teal"
    --     }
    -- },

    -- ['jailbreak'] = { -- command used, should be unique and also a string
    --     show = true, -- true/false display this command when using /help on the terminal
    --     allowed = function(playerId, laptopSerial)
    --         return true
    --     end,
    --     canProcess = function(playerId, laptopSerial, args)
    --         return true
    --     end,
    --     onSuccess = function(playerId, laptopSerial, args)

    --     end,
    --     actions = {
    --         {type = "text", input = "Accessing local kernel bootloader...", delay = 600},
    --         {type = "progressbar", input = "Corrupting security signed-boot", delay = 4000},
    --         {type = "text", input = "Warning: Integrity check bypassed. System unstable.", style = "error", delay = 1000},
    --         {type = "progressbar", input = "Mounting read-write partition", delay = 3500},
    --         {type = "text", input = "Injecting unsigned binary signature...", delay = 500},
    --         {type = "minigame", input = "grid", label = "KERNEL_VULN_MAPPER"}
    --     },
    --     output = {
    --         message = ">>> SYSTEM JAILBROKEN: RESTRICTIONS REMOVED. THIRD-PARTY APPS ENABLED.",
    --         color = "teal"
    --     }
    -- },
    -- ['wifi-crack'] = { -- command used, should be unique and also a string
    --     show = true, -- true/false display this command when using /help on the terminal
    --     args = "<SSID or Network Name>", -- this is just for display in the help menu, it doesn't affect the command processing in any way
    --     allowed = function(playerId, laptopSerial)
    --         return true
    --     end,
    --     canProcess = function(playerId, laptopSerial, args)
    --         if not args or string.len(args) <= 1 then
    --             return false
    --         end
    --         return true
    --     end,
    --     onSuccess = function(playerId, laptopSerial, args)

    --     end,
    --     onError = function(playerId, laptopSerial, args)
    --         return {
    --             message = "ERROR: SSID_SPEC_REQUIRED. USE: wifi-crack [target_ssid]"
    --         }
    --     end,
    --     actions = {
    --         {type = "text", input = "Scanning wireless spectrum...", delay = 800},
    --         {type = "progressbar", input = "Capturing WPA3 Handshake", delay = 6000},
    --         {type = "text", input = "Beacon frames captured. Starting deauthentication attack...", style = "output", delay = 1000},
    --         {type = "progressbar", input = "Injecting malicious packets", delay = 4500},
    --         {type = "text", input = "Handshake data buffer full. Ready for manual bypass.", delay = 500},
    --         {type = "minigame", input = "sniper", label = "WIFI_PROTOCOL_BREACH"}
    --     },
    --     output = {
    --         message = ">>> NETWORK COMPROMISED: WPA3 KEY DECRYPTED. CONNECTION ESTABLISHED.",
    --         color = "teal"
    --     }
    -- },
    -- ['cam-crack'] = { -- command used, should be unique and also a string
    --     show = true, -- true/false display this command when using /help on the terminal
    --     allowed = function(playerId, laptopSerial)
    --         return true
    --     end,
    --     canProcess = function(playerId, laptopSerial, args)
    --         if not args or string.len(args) <= 1 then
    --             return false
    --         end
    --         return true
    --     end,
    --     onSuccess = function(playerId, laptopSerial, args)

    --     end,
    --     onError = function(playerId, laptopSerial, args)
    --         return {
    --             message = "ERROR: CAMERA_ID_REQUIRED. USAGE: cam-crack [id]"
    --         }
    --     end,
    --     actions = {
    --         {type = "text", input = "Establishing remote uplink to CCTV network...", delay = 500},
    --         {type = "progressbar", input = "Scanning for open RTSP ports", delay = 4000},
    --         {type = "text", input = "Port 554 active. Intercepting encrypted stream...", style = "output", delay = 800},
    --         {type = "progressbar", input = "Bypassing admin authentication", delay = 6000},
    --         {type = "text", input = "Credential handshake detected. Initiating bruteforce...", delay = 500},
    --         {type = "minigame", input = "cracker", label = "CCTV_AUTH_BYPASS"}
    --     },
    --     output = {
    --         message = ">>> CAMERA FEED ACCESSED. ENCRYPTION OVERRIDDEN. REMOTE MONITORING ENABLED.",
    --         color = "teal"
    --     }
    -- },
}

exports("addCommand", function(data)
    dbug("addCommand(command)", data and data['command'] or "none")
    if not data or not data['command'] then
        return false, "Invalid command data. 'command' field is required."
    end
    local commandName = data['command']
    allCommands[commandName] = data
    return true, "Command '" .. commandName .. "' added successfully."
end)

exports("removeCommand", function(commandName)
    dbug("removeCommand(commandName)", commandName or "none")
    if not commandName then
        return false, "Command name is required."
    end
    allCommands[commandName] = nil
    return true, "Command '" .. commandName .. "' removed successfully."
end)