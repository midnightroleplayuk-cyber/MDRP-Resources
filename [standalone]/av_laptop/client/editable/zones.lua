local points = {}
local busy = false

for _, v in pairs(Config.PCs) do
    points[#points+1] = lib.points.new({
        coords = v['coords'],
        settings = v,
        canUse = v['canUse'],
        label = Lang['open_pc'],
        serial = v['serial'],
        distance = 2
    })
end

for _, v in pairs(points) do
    function v:onExit()
        if isTextUIOpen() then
            hideTextUI()
        end
    end
    function v:nearby()
        if self.currentDistance <= 1.5 then
            if not isTextUIOpen() then
                showTextUI(self.label)
            end
            if IsControlJustPressed(0,38) and not busy then
                busy = true
                if self.canUse() then
                    openPC(self.settings, self.serial)
                else
                    TriggerEvent('av_laptop:notification', Lang['pc_title'], Lang['no_permissions'], 'error')
                end
                CreateThread(function()
                    Wait(3000)
                    busy = false
                end)
            end
        end
    end
end