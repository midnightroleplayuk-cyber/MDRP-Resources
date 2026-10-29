ClubEscorts={}
function ClubFinite(n,min,max) return type(n)=='number' and n==n and n>=min and n<=max end
function ClubNearby(a,b,r)
    return type(b)=='number' and b>0 and b%1==0 and GetPlayerName(b) and GetPlayerPed(a)~=0 and GetPlayerPed(b)~=0
        and GetPlayerRoutingBucket(a)==GetPlayerRoutingBucket(b) and #(GetEntityCoords(GetPlayerPed(a))-GetEntityCoords(GetPlayerPed(b)))<=(r or 3)
end
function ClubAllowedDrink(item)
    for _,entry in pairs(Config.DefaultDrinks or {}) do if entry.item==item then return true end end
    return Config.AllowedDrinkItems and Config.AllowedDrinkItems[item]==true
end
function ClubValidMenu(menu)
    if type(menu)~='table' then return false end
    local count=0
    for key,e in pairs(menu) do
        count=count+1
        if count>100 or type(key)~='string' or #key>80 or type(e)~='table' or not ClubAllowedDrink(e.item)
            or type(e.name)~='string' or #e.name>100 or not ClubFinite(e.price,0,100000) or e.price%1~=0
            or not ClubFinite(e.alcohol,0,100) or type(e.flavors)~='table' or #e.flavors>20 then return false end
        for _,flavor in ipairs(e.flavors) do if not Config.Bartender.flavors[flavor] then return false end end
    end
    return true
end
function ClubWeights(weights)
    if type(weights)~='table' then return false end
    local n=0
    for k,v in pairs(weights) do
        n=n+1
        local alcohol=(Config.Bartender.alcoholBottle and Config.Bartender.alcoholBottle.key) or '_alcohol'
        if n>20 or (not Config.Bartender.flavors[k] and k~=alcohol) or not ClubFinite(v,0,1) then return false end
    end
    return true
end
function ClubStation(src,id,control)
    local station=StationRegistry and StationRegistry[id]
    if not station or GetPlayerPed(src)==0 or #(GetEntityCoords(GetPlayerPed(src))-station.coords)>5 then return false end
    if not control then return true end
    local controller=StationControllers[id] and StationControllers[id][control]
    return controller and controller.source==src and controller.identity==GetIdentifier(src)
end
function ClubStaff(src,id)
    if IsPlayerAdmin(src) then return true end
    local club=Clubs[id]; local job=GetPlayerJobName(src)
    for _,entry in ipairs(club and club.jobs or {}) do if entry.name==job then return true end end
    return false
end
local function release(src)
    for victim,owner in pairs(ClubEscorts) do
        if victim==src or owner==src then TriggerClientEvent('pickle_clubs:escortDetach',victim); ClubEscorts[victim]=nil end
    end
end
AddEventHandler('playerDropped',function() release(source) end)
AddEventHandler('esx:playerLogout',function(src) release(src or source) end)
AddEventHandler('QBCore:Server:OnPlayerUnload',function(src) release(src or source) end)
AddEventHandler('onResourceStop',function(name)
    if name==GetCurrentResourceName() then for victim in pairs(ClubEscorts) do TriggerClientEvent('pickle_clubs:escortDetach',victim) end end
end)
