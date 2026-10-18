
local success, result = pcall(lib.load, ('server.bridge.%s'):format(shared.framework))
if not success then
    lib.print.error(result)
end
