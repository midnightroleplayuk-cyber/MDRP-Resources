gg = gg or {} gg.miniBridge = gg.miniBridge or {}

gg.miniBridge.challenge = function(payload)
    if GetResourceState("gg_coinshop") ~= "started" then return end
    return exports.gg_coinshop:challenge({source = payload.source, challenge_id = payload.challenge_id, count = payload.count})
end