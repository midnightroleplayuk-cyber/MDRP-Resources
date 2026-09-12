local tgiann_skillbar = GetResourceState("tgiann-skillbar") == "started"

tgiCore.skillCheck = function(time)
    if tgiann_skillbar then
        return exports["tgiann-skillbar"]:taskBar(time, true)
    end

    local dif = "easy"
    if time < 2000 then
        dif = "hard"
    elseif time < 5000 then
        dif = "medium"
    end
    return lib.skillCheck({ dif })
end
