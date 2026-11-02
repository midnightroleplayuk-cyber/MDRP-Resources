-- Shared helpers for phone adapters. Each adapter can provide:
--   sourceOf(number) -> player source   (preferred: a direct lookup)
--   numberOf(source) -> phone number    (used to scan online players when there is no direct lookup)
-- priority: lower wins when several phone resources are running.
PhoneAdapter = {}

function PhoneAdapter.call(resource, fn, ...)
    local args = { ... }
    local ok, result = pcall(function() return exports[resource][fn](exports[resource], table.unpack(args)) end)
    if ok and result ~= nil and result ~= false and result ~= '' then return result end
    return nil
end

function PhoneAdapter.add(name, def)
    def.priority = def.priority or 50
    Prison.adapters.phone[name] = def
end
