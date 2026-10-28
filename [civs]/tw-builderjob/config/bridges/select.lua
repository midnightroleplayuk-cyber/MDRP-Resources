
CreateThread(function()
    Wait(0) -- let Config.Framework finish loading
    if not (Config and Config.Framework) then return end

    local picked = TworstBridge.active or TworstBridge.find(Config.Framework)
    if picked then
        TworstBridge.active = picked
        if Config.Debug then
            print(('^2[tw-builderjob][bridge]^7 active: %s (Config.Framework=%s)'):format(picked.name, Config.Framework))
        end
    else
        print(('^1[tw-builderjob][bridge]^7 No bridge for Config.Framework=%s — supported: qb, oldqb, qbox, esx, oldesx, vrp, vrp2, tmc, standalone'):format(tostring(Config.Framework)))
    end
end)
