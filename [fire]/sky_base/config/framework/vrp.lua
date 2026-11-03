if Sky.Config.framework == "vrp" then
    Sky.FW = {}
    local Tunnel = module("vrp", "lib/Tunnel")
    local Proxy = module("vrp", "lib/Proxy")
    local vRPclient = Tunnel.getInterface("vRP", GetCurrentResourceName())
    local itemsConfig = module("vrp", "cfg/items")

    vRP = Proxy.getInterface("vRP")

    if IsDuplicityVersion() then goto server end 
    -- Client Side from here

    Sky.FW.VehicleProperties = {
        get = exports.ox_lib.getVehicleProperties,
        set = exports.ox_lib.setVehicleProperties,
        codec = "ox",
        export = true
    }

    function Sky.FW.GetPlayerState(key, server_id)
        if server_id then
            return Player(server_id).state[key]
        end
        return LocalPlayer.state[key]
    end

    -- Entered / Exited Vehicle
    Citizen.CreateThread(function()
        local currentVehicle = {}
        local isInVehicle = false
        while true do
            local playerPed = PlayerPedId()

            if not isInVehicle and not IsPlayerDead(PlayerId()) then
                if IsPedInAnyVehicle(playerPed, false) then
                    isInVehicle = true
                    currentVehicle.vehicle = GetVehiclePedIsUsing(playerPed)
                    currentVehicle.seat = GetPedVehicleSeat(playerPed, currentVehicle.vehicle)
                    currentVehicle.plate = GetVehicleNumberPlateText(currentVehicle.vehicle)
                    TriggerEvent("sky_base:enteredVehicle", currentVehicle.vehicle, currentVehicle.plate, currentVehicle.seat)
                end
            elseif isInVehicle then
                if not IsPedInAnyVehicle(playerPed, false) or IsPlayerDead(PlayerId()) then
                    TriggerEvent("sky_base:exitedVehicle", currentVehicle.vehicle, currentVehicle.plate, currentVehicle.seat)
                    currentVehicle = {}
                    isInVehicle = false
                end
            end
            Citizen.Wait(200)
        end
    end)

    function Sky.FW.GetOwnedVehicleCount()
        return nil, "server_only"
    end

    ::server::
    if not IsDuplicityVersion() then return end
    -- Server Side from here

    function Sky.FW.IsPlayerOnline(sourceOrIdentifier)
        local user_id = vRP.getUserId({sourceOrIdentifier})
        if user_id ~= nil then
            return user_id
        else
            return false
        end
    end

    function Sky.FW.GetIdentifier(source)
        if source ~= nil then
            return vRP.getUserId({source})
        else
            return false
        end
    end

    function Sky.FW.GetName(source)
        return Sky.String.SanitizeForSQL(GetPlayerName(source))
    end

    function Sky.FW.GetFirstname(source)
        if source ~= nil then
            local user_id = vRP.getUserId({source})
            if not user_id or not vRP.getUserIdentity then return nil end
            local identity = vRP.getUserIdentity({user_id})
            if identity then
                return Sky.String.SanitizeForSQL(identity.firstname or identity.first_name)
            end
        end
        return nil
    end

    function Sky.FW.GetLastname(source)
        if source ~= nil then
            local user_id = vRP.getUserId({source})
            if not user_id or not vRP.getUserIdentity then return nil end
            local identity = vRP.getUserIdentity({user_id})
            if identity then
                return Sky.String.SanitizeForSQL(identity.lastname or identity.last_name or identity.name)
            end
        end
        return nil
    end

    function Sky.FW.GetBirthdate(source)
        return nil
    end

    function Sky.FW.GetHeight(source)
        return nil
    end

    function Sky.FW.GetPlayerDirectoryQueryConfig()
        return {
            from = "vrp_users u",
            joins = {
                "LEFT JOIN vrp_user_identities ui ON ui.user_id = u.id"
            },
            identifier = "u.id",
            firstname = "COALESCE(ui.firstname, ui.first_name, '')",
            lastname = "COALESCE(ui.lastname, ui.last_name, ui.name, '')",
            gender = "'unknown'",
            dob = "NULL",
            jobName = "NULL",
            jobLabel = "NULL",
            orderBy = "LOWER(COALESCE(ui.firstname, ui.first_name, '')), LOWER(COALESCE(ui.lastname, ui.last_name, ui.name, '')), u.id"
        }
    end

    function Sky.FW.GetAccountMoney(source, account)
        if source ~= nil then
            local user_id = vRP.getUserId({source})
            if account == "bank" then
                return vRP.getBankMoney({user_id})
            else
                return vRP.getMoney({user_id})
            end
            return 0
        end
        return 0
    end

    function Sky.FW.AddAccountMoney(source, account, amount)
        local user_id = vRP.getUserId({source})
        vRP.giveBankMoney({user_id, amount})
    end

    function Sky.FW.RemoveAccountMoney(source, account, amount, options)
        local user_id = vRP.getUserId({source})
        if type(options) == "table" and options.allowOverdraft == true and account == "bank" then
            local balance = vRP.getBankMoney({user_id})
            vRP.setBankMoney({user_id, balance - amount})
            return true
        end
        if vRP.tryBankPayment({user_id, amount}) then
            return true
        end
        return false
    end

    function Sky.FW.GetGang()
        return nil
    end

    function Sky.FW.GetGangData()
        return nil
    end

    function Sky.FW.GetGangUsers()
        return {}
    end

    function Sky.FW.SetGang()
        return false
    end

    function Sky.FW.DoesGangExist()
        return false
    end

    function Sky.FW.GetGangs()
        return {}
    end

    function Sky.FW.PrepareEmptyGroupMembership(name, kind, authorize)
        Sky.Debug("error", "[Sky.FW.PrepareEmptyGroupMembership] Group creation vacancy is unsupported on vRP: %s", tostring(name))
        return nil, "unsupported_framework"
    end

    function Sky.FW.ReadGangMemberSnapshot(gang_name, authorize)
        Sky.Debug("error", "[Sky.FW.ReadGangMemberSnapshot] Raw gang membership snapshots are unsupported on vRP: %s", tostring(gang_name))
        return nil, "unsupported_framework"
    end

    function Sky.FW.ReadJobMemberSnapshot(job_name, authorize)
        Sky.Debug("error", "[Sky.FW.ReadJobMemberSnapshot] Raw Core membership snapshots are unsupported on vRP: %s", tostring(job_name))
        return nil, "unsupported_framework"
    end

    function Sky.FW.ReadJobAdoptionSnapshot(job_name, aliases)
        Sky.Debug("error", "[Sky.FW.ReadJobAdoptionSnapshot] Persisted adoption snapshots are unsupported on vRP: %s", tostring(job_name))
        return nil, "unsupported_framework"
    end

    function Sky.FW.GetJob(source)
        if source ~= nil then
            local user_id = vRP.getUserId({source})
            return vRP.getUserFaction({user_id})
        else
            return false
        end
    end

    function Sky.FW.GetPlayers()
        return vRP.getUsers({})
    end

    function Sky.FW.IsVehicleOwnedByPlayer(source, plate)
        -- Here u need to make a custom logic
    end

    function Sky.FW.GetOwnedVehicleCount(source)
        if not IsDuplicityVersion() then
            return nil, "server_only"
        end

        -- vRP vehicle schemas are server-specific. Override this in the local bridge.
        return nil, "unsupported"
    end

    function Sky.FW.ChangePlayerName(sourceOrIdentifier, firstname, lastname)
        -- vRP identity schemas differ between server distributions. Override this
        -- bridge locally and return true only after the persistent identity changed.
        return false
    end

    function Sky.FW.HasCommandPermission(source, acePerm)
        if source == 0 then return true end
        return IsPlayerAceAllowed(source, acePerm)
    end

    function Sky.FW.SetPlayerState(source, key, value)
        Player(source).state:set(key, value, true)
    end

    function Sky.FW.GetPlayerState(source, key)
        return Player(source).state[key]
    end

    ---Check if a player should be visible on CCTV/Bodycam/Dashcam
    ---@param source string|number
    ---@return boolean
    function Sky.FW.IsPlayerVisibleOnCamera(source)
        local ped = GetPlayerPed(source)
        if not ped or ped == 0 or not DoesEntityExist(ped) then
            return false
        end
        return IsEntityVisible(ped)
    end
end
