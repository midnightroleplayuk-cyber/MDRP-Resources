-- ====================================================================
-- REGION 4 -- Pipe Yard
-- ====================================================================
-- Placing 28 pipes with the vehicle crane. Pipe stacks are arranged with
-- /pipestand and written to config/data/measured_pipe.lua.
-- ====================================================================

Config.PipeJob          = {}

Config.PipeJob.pipeModel        = 'tworst_buildpipe'

Config.PipeJob.pipeSlots        = {
    { model = 'tworst_buildpipe2',   coords = vec3(1064.670, 2336.180, 52.682), rot = vec3(0.0, 0.0, -88.75) },
    { model = 'tworst_buildpipe2',   coords = vec3(1064.674, 2337.773, 52.682), rot = vec3(0.0, 0.0, -88.75) },
    { model = 'tworst_buildpipe',    coords = vec3(1058.459, 2336.030, 54.445), rot = vec3(0.0, 0.0, -89.32) },
    { model = 'tworst_buildpipe',    coords = vec3(1058.454, 2337.662, 54.445), rot = vec3(0.0, 0.0, -89.32) },

    { model = 'tworst_buildpipe',    coords = vec3(1051.235, 2335.839, 54.445), rot = vec3(0.0, 0.0, -89.32) },
    { model = 'tworst_buildpipe',    coords = vec3(1044.041, 2335.657, 54.445), rot = vec3(0.0, 0.0, -89.32) },
    { model = 'tworst_buildpipe',    coords = vec3(1036.839, 2335.460, 54.445), rot = vec3(0.0, 0.0, -89.32) },
    { model = 'tworst_buildpipe',    coords = vec3(1029.623, 2335.343, 54.445), rot = vec3(0.0, 0.0, -89.32) },
    { model = 'tworst_buildpipe',    coords = vec3(1022.411, 2335.135, 54.445), rot = vec3(0.0, 0.0, -89.32) },
    { model = 'tworst_buildpipe',    coords = vec3(1015.198, 2334.938, 54.445), rot = vec3(0.0, 0.0, -89.32) },
    { model = 'tworst_buildpipe',    coords = vec3(1007.975, 2334.747, 54.445), rot = vec3(0.0, 0.0, -89.32) },
    { model = 'tworst_buildpipe',    coords = vec3(1000.762, 2334.550, 54.445), rot = vec3(0.0, 0.0, -89.32) },
    { model = 'tworst_buildpipe',    coords = vec3(993.538,  2334.347, 54.445), rot = vec3(0.0, 0.0, -89.32) },
    { model = 'tworst_buildpipe',    coords = vec3(986.327,  2334.165, 54.445), rot = vec3(0.0, 0.0, -89.32) },
    { model = 'tworst_buildpipe',    coords = vec3(979.099,  2334.005, 54.445), rot = vec3(0.0, 0.0, -89.32) },

    { model = 'tworst_buildoutpipe', coords = vec3(974.997,  2335.423, 54.419), rot = vec3(0.0, 0.0, -89.32) },
    { model = 'tworst_buildoutpipe', coords = vec3(974.997,  2333.787, 54.419), rot = vec3(0.0, 0.0, -89.32) },

    { model = 'tworst_buildpipe',    coords = vec3(979.099,  2335.633, 54.445), rot = vec3(0.0, 0.0, -89.32) },
    { model = 'tworst_buildpipe',    coords = vec3(986.327,  2335.793, 54.445), rot = vec3(0.0, 0.0, -89.32) },
    { model = 'tworst_buildpipe',    coords = vec3(993.538,  2335.975, 54.445), rot = vec3(0.0, 0.0, -89.32) },
    { model = 'tworst_buildpipe',    coords = vec3(1000.762, 2336.178, 54.445), rot = vec3(0.0, 0.0, -89.32) },
    { model = 'tworst_buildpipe',    coords = vec3(1007.975, 2336.375, 54.445), rot = vec3(0.0, 0.0, -89.32) },
    { model = 'tworst_buildpipe',    coords = vec3(1015.198, 2336.566, 54.445), rot = vec3(0.0, 0.0, -89.32) },
    { model = 'tworst_buildpipe',    coords = vec3(1022.411, 2336.763, 54.445), rot = vec3(0.0, 0.0, -89.32) },
    { model = 'tworst_buildpipe',    coords = vec3(1029.623, 2336.971, 54.445), rot = vec3(0.0, 0.0, -89.32) },
    { model = 'tworst_buildpipe',    coords = vec3(1036.839, 2337.088, 54.445), rot = vec3(0.0, 0.0, -89.32) },
    { model = 'tworst_buildpipe',    coords = vec3(1044.041, 2337.285, 54.445), rot = vec3(0.0, 0.0, -89.32) },
    { model = 'tworst_buildpipe',    coords = vec3(1051.235, 2337.467, 54.445), rot = vec3(0.0, 0.0, -89.32) },
}

Config.PipeJob.sequentialPlace  = false
Config.PipeJob.lanes = {
    { 1, 3, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 17 },
    { 2, 4, 28, 27, 26, 25, 24, 23, 22, 21, 20, 19, 18, 16 },
}

local function pipePileGroup(cx, cy, cz, models)
    local out = {}
    for i, m in ipairs(models) do
        local col = (i <= 4) and (i - 1) or (i - 5)
        local row = (i <= 4) and 0 or 1
        out[#out + 1] = { model = m, coords = vec3(cx + col * 1.6, cy + row * 1.0, cz), rot = vec3(0.0, 0.0, 0.0) }
    end
    return out
end
Config.PipeJob.pileLayout = {}
do
    local P, P2, PO = 'tworst_buildpipe', 'tworst_buildpipe2', 'tworst_buildoutpipe'
    local measured = {
        { model = P2, coords = vec3(1059.600, 2339.426, 48.963), rot = vec3(0.0, 90.0, 0.0) },
        { model = P2, coords = vec3(1058.792, 2338.522, 49.030), rot = vec3(0.0, 90.0, 0.0) },
        { model = P, coords = vec3(1052.027, 2338.197, 48.972), rot = vec3(0.0, 0.0,  90.0) },
        { model = P, coords = vec3(1052.027, 2339.294, 48.972), rot = vec3(0.0, 0.0, -90.0) },
        { model = P, coords = vec3(1052.027, 2340.123, 48.972), rot = vec3(0.0, 0.0,  90.0) },
        { model = P, coords = vec3(1052.027, 2338.744, 49.881), rot = vec3(0.0, 0.0, -90.0) },
        { model = P, coords = vec3(1052.027, 2339.610, 49.881), rot = vec3(0.0, 0.0,  90.0) },
        { model = P, coords = vec3(1052.027, 2339.212, 50.722), rot = vec3(0.0, 0.0, -90.0) },
        { model = P, coords = vec3(1029.116, 2338.037, 49.018), rot = vec3(0.0, 0.0, 90.0) },
        { model = P, coords = vec3(1029.116, 2338.957, 49.018), rot = vec3(0.0, 0.0, 270.0) },
        { model = P, coords = vec3(1029.116, 2339.877, 49.018), rot = vec3(0.0, 0.0, 90.0) },
        { model = P, coords = vec3(1029.116, 2338.497, 49.888), rot = vec3(0.0, 0.0, 270.0) },
        { model = P, coords = vec3(1029.116, 2339.417, 49.888), rot = vec3(0.0, 0.0, 90.0) },
        { model = P, coords = vec3(1029.116, 2338.957, 50.758), rot = vec3(0.0, 0.0, 270.0) },
        { model = P, coords = vec3(1007.543, 2337.604, 49.947), rot = vec3(0.0, 0.0, 90.0) },
        { model = P, coords = vec3(1007.543, 2338.524, 49.947), rot = vec3(0.0, 0.0, 270.0) },
        { model = P, coords = vec3(1007.543, 2339.444, 49.947), rot = vec3(0.0, 0.0, 90.0) },
        { model = P, coords = vec3(1007.543, 2338.064, 50.817), rot = vec3(0.0, 0.0, 270.0) },
        { model = P, coords = vec3(1007.543, 2338.984, 50.817), rot = vec3(0.0, 0.0, 90.0) },
        { model = P, coords = vec3(1007.543, 2338.524, 51.687), rot = vec3(0.0, 0.0, 270.0) },
        { model = P, coords = vec3(992.880, 2334.639, 50.983), rot = vec3(0.0, 0.0, 180.0) },
        { model = P, coords = vec3(991.960, 2334.639, 50.983), rot = vec3(0.0, 0.0, 0.0) },
        { model = P, coords = vec3(991.040, 2334.639, 50.983), rot = vec3(0.0, 0.0, 180.0) },
        { model = P, coords = vec3(991.960, 2334.639, 51.853), rot = vec3(0.0, 0.0, 0.0) },
        { model = P,  coords = vec3(976.657, 2332.868, 48.110), rot = vec3(0.0, 0.0, 180.0) },
        { model = P,  coords = vec3(975.737, 2332.868, 48.110), rot = vec3(0.0, 0.0, 0.0) },
        { model = P,  coords = vec3(974.817, 2332.868, 48.110), rot = vec3(0.0, 0.0, 180.0) },
        { model = PO, coords = vec3(976.197, 2332.868, 48.980), rot = vec3(0.0, 0.0, 0.0) },
        { model = PO, coords = vec3(975.277, 2332.868, 48.980), rot = vec3(0.0, 0.0, 180.0) },
        { model = P,  coords = vec3(975.737, 2332.868, 49.850), rot = vec3(0.0, 0.0, 0.0) },
    }
    local groups = {}
    local legacyList = {}
    for _, g in ipairs(groups) do
        for _, piece in ipairs(g) do legacyList[#legacyList + 1] = piece end
    end
    do
        local data = TwMeasuredPipe
        if type(data) ~= 'table' then
            print('^1[pipe] config/data/measured_pipe.lua missing — the measured pile falls back to config^7')
        else
            if type(data.pieces) == 'table' then
                for _, e in ipairs(data.pieces) do
                    if type(e) == 'table' and e.model then
                        measured[#measured + 1] = {
                            model  = e.model,
                            coords = vec3(e.x or 0.0, e.y or 0.0, e.z or 0.0),
                            rot    = vec3(e.rx or 0.0, e.ry or 0.0, e.rz or 0.0),
                        }
                        for i = #legacyList, 1, -1 do
                            if legacyList[i].model == e.model then
                                table.remove(legacyList, i)
                                break
                            end
                        end
                    end
                end
                if Config.Debug then
                    print(('[pipe] measured_pipe.lua: %d measured piece(s) loaded, %d legacy left')
                        :format(#data.pieces, #legacyList))
                end
            end
        end
    end
    do
        local nl = {}
        for _, piece in ipairs(legacyList) do
            nl[piece.model] = (nl[piece.model] or 0) + 1
        end
        Config.PipeJob.pileNeedLegacy = nl
    end
    for _, e in ipairs(measured) do
        Config.PipeJob.pileLayout[#Config.PipeJob.pileLayout + 1] = e
    end
    for _, piece in ipairs(legacyList) do
        Config.PipeJob.pileLayout[#Config.PipeJob.pileLayout + 1] = piece
    end

    do
        local need = {
            ['tworst_buildpipe']    = 24,
            ['tworst_buildpipe2']   = 2,
            ['tworst_buildoutpipe'] = 2,
        }
        local have = {}
        for _, e in ipairs(Config.PipeJob.pileLayout) do
            have[e.model] = (have[e.model] or 0) + 1
        end
        local trimmed = {}
        for i = #Config.PipeJob.pileLayout, 1, -1 do
            local m = Config.PipeJob.pileLayout[i].model
            if need[m] and (have[m] or 0) > need[m] then
                have[m] = have[m] - 1
                trimmed[#trimmed + 1] = m
                table.remove(Config.PipeJob.pileLayout, i)
            end
        end
        if #trimmed > 0 then
            local cnt = {}
            for _, m in ipairs(trimmed) do cnt[m] = (cnt[m] or 0) + 1 end
            for m, n in pairs(cnt) do
                print(('[pipe] AUTO-TRIM: %d×%s trimmed FROM THE END (rule: pieces on the ground = slot count)'):format(n, m))
            end
        end
        for m, n in pairs(need) do
            if (have[m] or 0) < n then
                print(('^1[pipe] WARNING: %s is missing — %d/%d (the slots cannot be filled, add some with /pipestand)^7'):format(m, have[m] or 0, n))
            end
        end
    end
end

Config.PipeJob.zoneId           = 'buildermainzone'

Config.PipeJob.siteCenter       = vec3(1063.0, 2337.0, 53.5)
Config.PipeJob.siteRadius       = 150.0

Config.PipeJob.parkedRestoreSeconds = 180

Config.PipeJob.crewProfiles = {
    [1] = { vehicles = { winch = 1 } },
    [2] = { vehicles = { winch = 2 } },
    [3] = { vehicles = { winch = 3 } },
    [4] = { vehicles = { winch = 4 } },
}
Config.PipeJob.rentAllowed = { 'winch' }
Config.PipeJob.minPlayers  = 1
Config.PipeJob.maxPlayers  = 4

Config.PipeJob.vehicleSpawn = {
    coords  = vec3(1055.87, 2341.23, 49.84),
    heading = 289.12,
}

Config.PipeJob.riggingMode      = 'midline'

Config.PipeJob.hookRigPoint     = vec3(0.0, 0.0, 0.25)

Config.PipeJob.machineReach          = 30.0

Config.PipeJob.grabRange             = 3.5
Config.PipeJob.placementRange        = 4.0
Config.PipeJob.placementRotSymmetry  = nil
