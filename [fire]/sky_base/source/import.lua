Sky = Sky or {}

local success, result
for i = 1, 50 do
    success, result = pcall(exports["sky_base"].Get, exports["sky_base"], IsDuplicityVersion() and RegisterCommand or nil)
    if success and result then break end
    Wait(100)
end

if success and result then
    Sky = result
else
    print("^1[sky_base] Failed to load Sky export after 5s^0")
end
