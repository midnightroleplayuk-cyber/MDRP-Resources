-- NO BS SCRIPTS - Mission Plaza UK police station: automatic door data (server and clients).
-- Generated data, replaced by every update - do not edit. Every setting is in config.lua, section 2.
-- The front entrance sliders and the garage rollers: model, position, travel, speed, sensor, room and skin.
local missing = {}
if type(MPManagedDoorLocks) ~= 'table' then missing[#missing + 1] = 'MPManagedDoorLocks'; MPManagedDoorLocks = {} end
if type(MPManagedDoors) ~= 'table' then missing[#missing + 1] = 'MPManagedDoors'; MPManagedDoors = {} end
if #missing > 0 then
    print(("^3[%s] config.lua has no %s (a mistake in config.lua, or a 1.1.x config.lua): the automatic doors use their default settings^7"):format(GetCurrentResourceName(), table.concat(missing, ' and ')))
elseif type(MPManagedDoors.doors) == 'table' then
    print(("^3[%s] config.lua: MPManagedDoors.doors is the 1.1.x door list and is ignored; set the opening distances in MPManagedDoors.entrance / .garage (config.lua, section 2)^7"):format(GetCurrentResourceName()))
end
for k, v in pairs({
    mode = 'auto',
    matchDistance = 1.5,
}) do
    if MPManagedDoorLocks[k] == nil then MPManagedDoorLocks[k] = v end   -- the default of a setting config.lua does not set
end
local D = MPManagedDoors
D.doors = {
 {id="entrance_right",hash=372540780,group="entrance",x=414.4112583029218,y=-341.93809539661254,z=45.94298158055308,heading=158.38175948368664,ax=-0.9296592437203817,ay=0.368420534939691,vx=-0.9296592437203817,vy=0.368420534939691,vz=0,sensorX=414.82960496259597,sensorY=-342.1038846373354,travel=0.9,speed=0.75,acceleration=1.8,along=1.4,across=1.6,openAlong=1.6,openAcross=1.9,roomX=415.20539390823444,roomY=-341.15563220874066,roomZ=46.94298158055308,roomHash=1519171249},
 {id="entrance_left",hash=633202419,group="entrance",x=415.24795162227014,y=-342.26967387805826,z=45.94298158055308,heading=158.38175948368664,ax=-0.9296592437203817,ay=0.368420534939691,vx=0.9296592437203817,vy=-0.368420534939691,vz=0,sensorX=414.82960496259597,sensorY=-342.1038846373354,travel=0.9,speed=0.75,acceleration=1.8,along=1.4,across=1.6,openAlong=1.6,openAcross=1.9,roomX=415.20539390823444,roomY=-341.15563220874066,roomZ=46.94298158055308,roomHash=1519171249},
 {id="garage_bay1",hash=3690642035,group="roller",x=376.37791723655977,y=-332.2224238511258,z=45.94298158055308,heading=248.38175948368664,ax=-0.3684205349396915,ay=-0.9296592437203814,vx=0,vy=0,vz=1,travel=3.9,speed=1.5,along=3.5,across=6,openAlong=3.7,openAcross=7,roomX=374.518598749119,roomY=-331.4855827812465,roomZ=46.94298158055308,roomHash=1504070183,keepRoom=true,skinHash=1928607280,skinX=376.84274685841996,skinY=-332.4066341185957,range=175},
 {id="garage_bay2",hash=3690642035,group="roller",x=372.3252913522232,y=-342.44867553205006,z=45.94298158055308,heading=248.38175948368664,ax=-0.3684205349396915,ay=-0.9296592437203814,vx=0,vy=0,vz=1,travel=3.9,speed=1.5,along=3.5,across=6,openAlong=3.7,openAcross=7,roomX=370.46597286478243,roomY=-341.71183446217066,roomZ=46.94298158055308,roomHash=1504070183,keepRoom=true,skinHash=1928607280,skinX=372.7901209740834,skinY=-342.6328857995199,range=175},
}
-- config.lua MPManagedDoors.entrance / .garage override the opening distances of the sliders / the rollers.
local groups = { entrance = D.entrance, roller = D.garage }
for _, d in ipairs(D.doors) do
    local t = groups[d.group]
    if type(t) == 'table' then
        for _, k in ipairs({ 'along', 'across', 'openAlong', 'openAcross' }) do
            if tonumber(t[k]) then d[k] = tonumber(t[k]) end
        end
    end
end
