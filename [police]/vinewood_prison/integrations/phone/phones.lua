-- Phone adapters. Export names checked against each phone's documentation.
-- Add your own the same way: PhoneAdapter.add('name', { resource = '...', sourceOf = fn, numberOf = fn })
local call = PhoneAdapter.call

-- LB Phone: GetSourceFromNumber / GetEquippedPhoneNumber
-- Native calls: CreateCall rings the person's real phone with the prison as the caller,
-- and lb-phone carries the voice. GetCall / EndCall let the prison track and end it.
PhoneAdapter.add('lb-phone', {
    resource = 'lb-phone', priority = 10,
    sourceOf = function(number) return call('lb-phone', 'GetSourceFromNumber', number) end,
    numberOf = function(src) return call('lb-phone', 'GetEquippedPhoneNumber', src) end,
    calls = {
        start = function(prisonerSrc, calleeNumber, callerName)
            return call('lb-phone', 'CreateCall', { phoneNumber = callerName, source = prisonerSrc }, calleeNumber, { requirePhone = false, hideNumber = false })
        end,
        get = function(callId) return call('lb-phone', 'GetCall', callId) end,
        stop = function(prisonerSrc) pcall(function() exports['lb-phone']:EndCall(prisonerSrc) end) end,
        -- lb-phone's call table: treat any of these as "answered"
        answered = function(data)
            if type(data) ~= 'table' then return false end
            return data.answered == true or data.accepted == true or data.connected == true
                or data.state == 'answered' or data.state == 'active' or data.status == 'answered' or data.status == 'active'
        end,
        notify = function(src, title, text)
            pcall(function() exports['lb-phone']:SendNotification(src, { app = 'Phone', title = title, content = text }) end)
        end,
    },
})

-- Quasar Smartphone PRO: GetPhoneNumberFromIdentifier(identifier, mustBeOwner)
PhoneAdapter.add('qs-smartphone-pro', {
    resource = 'qs-smartphone-pro', priority = 20,
    numberOf = function(src)
        return call('qs-smartphone-pro', 'GetPhoneNumberFromIdentifier', Bridge.getIdentifier(src), false)
            or call('qs-smartphone-pro', 'GetPhoneNumberFromIdentifier', GetPlayerIdentifier(src, 0), false)
    end,
})

-- Quasar Smartphone (original): the number comes from qs-base
PhoneAdapter.add('qs-smartphone', {
    resource = 'qs-smartphone', priority = 21,
    numberOf = function(src) return call('qs-base', 'GetPlayerPhone', src) end,
})

-- NPWD: getPhoneNumber(source)
PhoneAdapter.add('npwd', {
    resource = 'npwd', priority = 30,
    numberOf = function(src) return call('npwd', 'getPhoneNumber', src) end,
})

-- TeamsGG YSeries / YFlip / YPhone: GetPlayerSourceIdByPhoneNumber / GetPhoneNumberBySourceId
for i, res in ipairs({ 'yseries', 'yflip', 'yphone' }) do
    PhoneAdapter.add(res, {
        resource = res, priority = 30 + i,
        sourceOf = function(number) local s = call(res, 'GetPlayerSourceIdByPhoneNumber', number) return s and tonumber(s) end,
        numberOf = function(src) local n = call(res, 'GetPhoneNumberBySourceId', src) return n and tostring(n) end,
    })
end

-- GKSPHONE v2: GetSourceByPhone / GetPhoneBySource
PhoneAdapter.add('gksphone', {
    resource = 'gksphone', priority = 40,
    sourceOf = function(number) return call('gksphone', 'GetSourceByPhone', number) end,
    numberOf = function(src) return call('gksphone', 'GetPhoneBySource', src) end,
})

-- High Phone: getPlayerByPhone(number).id / getPlayerPhoneNumber(id)
PhoneAdapter.add('high-phone', {
    resource = 'high-phone', priority = 41,
    sourceOf = function(number)
        local player = call('high-phone', 'getPlayerByPhone', number)
        return player and player.id or nil
    end,
    numberOf = function(src) return call('high-phone', 'getPlayerPhoneNumber', src) end,
})

-- RoadPhone: getPlayerFromPhone(number) / getNumberFromIdentifier(identifier)
PhoneAdapter.add('roadphone', {
    resource = 'roadphone', priority = 42,
    sourceOf = function(number) return call('roadphone', 'getPlayerFromPhone', number) end,
    numberOf = function(src) return call('roadphone', 'getNumberFromIdentifier', Bridge.getIdentifier(src)) end,
})

-- Fallback: the number saved on the character (qb/qbx charinfo.phone, ESX phoneNumber)
PhoneAdapter.add('framework', {
    fallback = true, priority = 99,
    numberOf = function(src) return Bridge.getPhone and Bridge.getPhone(src) or nil end,
})
