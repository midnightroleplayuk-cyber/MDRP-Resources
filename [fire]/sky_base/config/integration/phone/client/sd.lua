if Sky.Config.phone ~= "sd" then return end

-- Only SD needs ox_lib's native client callback. Load after Sky.Cb's client module.
if not lib then
    assert(load(LoadResourceFile("ox_lib", "init.lua"), "@@ox_lib/init.lua"))()
end
assert(lib.name == "ox_lib", "sd-phone call integration requires the standard ox_lib client API")

Sky.Cb.Register("sky_base:phone:sd:answer", function(call_id)
    local response = lib.callback.await("sd-phone:server:call:accept", false, { channel = call_id })
    return { success = response and response.success == true, error = "voice_unavailable" }
end)
