-- NO BS SCRIPTS - Mission Plaza UK police station: vehicle gate data (server and clients).
-- Generated data, replaced by every update - do not edit. Every setting is in config.lua, section 1.
-- The gate leaves: model, hinge, closed heading, swing, trigger point and the range / speed of each gate.
if type(MPGateConfig) ~= 'table' then
    print(("^3[%s] config.lua has no MPGateConfig (a mistake in config.lua, or a 1.1.x config.lua): the vehicle gates use their default settings^7"):format(GetCurrentResourceName()))
    MPGateConfig = {}
elseif type(MPGateConfig.gates) == 'table' then
    print(("^3[%s] config.lua: MPGateConfig.gates is the 1.1.x gate list and is ignored; set the range / speed of a gate in MPGateConfig.timing (config.lua, section 1)^7"):format(GetCurrentResourceName()))
end
local C = MPGateConfig
for k, v in pairs({
    enabled = true,
    activationDistance = 12.0,
    speed = 0.35,
    controller = 'builtin',
    locks = { mode = 'auto', matchDistance = 2.0 },
    restrictedOpenForAll = true,
    slideFlip = 1,
}) do
    if C[k] == nil then C[k] = v end   -- the default of a setting config.lua does not set
end
if type(C.locks) == 'table' then   -- a partial locks table keeps the default of each key it leaves out
    for k, v in pairs({ mode = 'auto', matchDistance = 2.0 }) do
        if C.locks[k] == nil then C.locks[k] = v end
    end
end
C.gates = {{["id"]="entrance_gate_left",["model"]="nobs_ukpd_mp_swing_leaf",["hash"]=1895768305,["coords"]={418.96422182378467,-361.4702256768988,46.17608022455308},["heading"]=229.11697471600542,["special"]=7,["room"]="exterior",["mode"]="swing",["swing"]=1,["restricted"]=false,["use"]="public",["group"]="entrance",["trigger"]={421.4584930017337,-358.6959850076611,46.16731158055308},["range"]=12.0,["speed"]=0.35},{["id"]="entrance_gate_right",["model"]="nobs_ukpd_mp_swing_leaf",["hash"]=1895768305,["coords"]={423.8469175419225,-355.83011197910173,46.23328778055308},["heading"]=49.116974716005416,["special"]=7,["room"]="exterior",["mode"]="swing",["swing"]=-1,["restricted"]=false,["use"]="public",["group"]="entrance",["trigger"]={421.4584930017337,-358.6959850076611,46.16731158055308},["range"]=12.0,["speed"]=0.35},{["id"]="exit_gate_left",["model"]="nobs_ukpd_mp_swing_leaf",["hash"]=1895768305,["coords"]={371.233329436901,-381.13430768503997,45.73028158055308},["heading"]=175.1899794557501,["special"]=7,["room"]="exterior",["mode"]="swing",["swing"]=1,["restricted"]=true,["use"]="police",["group"]="exit",["trigger"]={375.61514047118186,-373.54500389221056,45.88778158055308},["range"]=16.0,["speed"]=0.8},{["id"]="exit_gate_right",["model"]="nobs_ukpd_mp_swing_leaf",["hash"]=1895768305,["coords"]={378.66705687952486,-381.75984450152777,45.76696158055308},["heading"]=355.18997945575006,["special"]=7,["room"]="exterior",["mode"]="swing",["swing"]=-1,["restricted"]=true,["use"]="police",["group"]="exit",["trigger"]={375.61514047118186,-373.54500389221056,45.88778158055308},["range"]=16.0,["speed"]=0.8}}
-- config.lua MPGateConfig.timing.entrance / .exit = { range = metres, speed = open ratio per second } override
-- both leaves of that gate.
local timing = type(C.timing) == 'table' and C.timing or {}
for _, g in ipairs(C.gates) do
    local t = timing[g.group]
    if type(t) == 'table' then
        g.range = tonumber(t.range) or g.range
        g.speed = tonumber(t.speed) or g.speed
    end
end
