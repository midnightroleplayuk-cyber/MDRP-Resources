gangName = nil
gangGrade = 0
oldGangName = nil
oldGangGrade = nil

---------------------------------------------------
-- GANGS
---------------------------------------------------

while Framework == nil do Wait(5) end

RegisterNetEvent("op-crime:jobChanged", function(jobId, jobLabel, rankName)
  reloadGangGarages()
end)

RegisterNetEvent('QBCore:Client:OnGangUpdate', function(GangInfo)
    reloadGangGarages()
end)

RegisterNetEvent('rcore_gangs:client:set_gang', function()
    reloadGangGarages()
end)

RegisterNetEvent('rcore_gangs:client:set_finished_rivalry', function()
    reloadGangGarages()
end)

--RegisterNetEvent('esx:updatePlayerData', function()
--    reloadGangGarages()
--end)

function loadGang()
    while (Fr.GetPlayerData() == nil) do
        Wait(100)
    end

    PlayerData = Fr.GetPlayerData()
    oldGangGrade = gangGrade
    oldGangName = gangName
    gangName = getGangName()
    getGangGrade(function(gr)
        gangGrade = gr
        --reloadGarages()
    end)
end

function reloadGangGarages()
    PlayerData = Fr.GetPlayerData()
    oldGangGrade = gangGrade
    oldGangName = gangName
    gangName = getGangName()
    getGangGrade(function(gr)
        gangGrade = gr
        hideTextUI() 
        reloadGarages()
    end)
end