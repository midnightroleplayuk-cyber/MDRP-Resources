MySQL.ready(function()
    CreateThread(function()
        if not NDM.DB.Init() then
            print(('^1[%s] database setup failed. Business systems are disabled.^7'):format(NDM.Resource))
            return
        end

        local venues = NDM.Venue.Load()
        local points = NDM.Points.Load()
        NDM.Supply.Load()
        NDM.Register.Load()
        NDM.Club.Load()
        NDM.Ready = true
        print(('[%s] v%s ready: %d venue(s), %d point(s) loaded.'):format(NDM.Resource, NDM.Version, venues, points))
    end)
end)
