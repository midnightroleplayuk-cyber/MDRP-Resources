
if _G.__twPrintGateInstalled then return end -- double-wrap safety
_G.__twPrintGateInstalled = true

local _print = print

local KEEP = { 'ERROR', 'HATA', 'BLOCKER', 'UYARI', 'WARN', 'error:' }

local function mustShow(s)
    if s:find('^1', 1, true) or s:find('^3', 1, true) then return true end
    for i = 1, #KEEP do
        if s:find(KEEP[i], 1, true) then return true end
    end
    return false
end

function print(...)
    if Config and Config.Debug then return _print(...) end
    if (_G.__twInCmd or 0) > 0 then return _print(...) end

    local n = select('#', ...)
    local parts = {}
    for i = 1, n do parts[i] = tostring((select(i, ...))) end
    local line = table.concat(parts, '\t')

    if mustShow(line) then return _print(line) end
end
