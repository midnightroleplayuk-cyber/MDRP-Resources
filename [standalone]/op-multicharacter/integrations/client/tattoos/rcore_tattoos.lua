if Config.Tattoos ~= "rcore_tattoos" then return end

function setPedTattoos(ped, tattoos)
    TriggerEvent('rcore_tattoos:setPedTattoos', ped, tattoos, true)
end