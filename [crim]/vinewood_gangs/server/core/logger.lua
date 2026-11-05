Logger = {}

-- Uses ox_lib's logger (Datadog / Fivemanage / Loki, configured via convars in ox_lib)
function Logger.Log(src, event, message)
    lib.logger(src or 0, ('vinewood_gangs:%s'):format(event), message)
    Utils.Debug(event, message)
end
