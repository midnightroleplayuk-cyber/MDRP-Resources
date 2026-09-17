Framework = nil
Fr = {}

jobCache = {}

Fr.getOnlineJobCount = function(jobName)
    local count = 0
    for _, jobData in pairs(jobCache) do
        if jobData.name == jobName then
            count = count + 1
        end
    end
    return count
end

function generatePlate() 
    math.randomseed(GetGameTimer())
    local charSet = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"}

    local generatedPlate = nil

    for i = 1, 8 do
        if generatedPlate == nil then
            generatedPlate = charSet[math.random(#charSet)]
        else 
            generatedPlate = generatedPlate .. charSet[math.random(#charSet)] 
        end	
    end

    local isTaken = Fr.IsPlateTaken(generatedPlate)
    if isTaken then 
        return generatePlate()
    end

    return generatedPlate
end

function getJgJobOwnerId(jobName)
    return "job_" .. tostring(jobName)
end

function isJgJobVehicleOwner(value, jobName)
    if not value or value == "" then return true end
    value = tostring(value)
    return value == getJgJobOwnerId(jobName) or value == tostring(jobName)
end