-- 1916003103 = canonburyroadone
-- 938085186 = canonburyroadtwos
-- 816490351 = canonburyroadthree
-- 168196016 = canonburyroadfour
-- 2063308062 = canonburyroadfive
-- 2080133887 = canonburyroad6
-- 1221028185 = canonburyroadseven  


local zeabra_locations = {
	{coord=vector4(1465.6,3527.35,39.7,80.00),object=nil,object2=nil,style=0},
	{coord=vector4(1458.27,3520.71,39.7,-100.37),object=nil,object2=nil,style=1},
	{coord=vector4(1456.25,3580.71,39.7,100.00),object=nil,object2=nil,style=0},
	{coord=vector4(1453.27,3571.24,39.7,-70.37),object=nil,object2=nil,style=1},
}

local traffic_locations = {
	{coord=vector4(1478.4,3546.71,39.5,209.23),objects={traffic=nil,ped=nil,redlight=nil,orangelight=nil,greenlight=nil,pedred=nil,pedgreen=nil,wait=nil}},
	{coord=vector4(1483.88,3555.31,39.5,27.78),objects={traffic=nil,ped=nil,redlight=nil,orangelight=nil,greenlight=nil,pedred=nil,pedgreen=nil,wait=nil}},
}

local spawned_objects={}

Citizen.CreateThread(function()
	AddTextEntry("canonburyroadone", "Compton Road")
	AddTextEntry("canonburyroadtwos", "Prior Bolton Road")
	AddTextEntry("canonburyroadthree", "Aldwyne Road")
	AddTextEntry("canonburyroadfour", "Aldwyne Place")
	AddTextEntry("canonburyroadfive", "Clephane Road")
	AddTextEntry("canonburyroad6", "Oppidans Road")
	AddTextEntry("canonburyroadseven", "Erskine Road")


	local zeabra = GetHashKey('lc_estate_canonbury_prop_traffic_zeabra')
	local zeabra_light = GetHashKey('lc_estate_canonbury_prop_traffic_zeabra_light')

	local traffic_light = GetHashKey('lc_estate_canonbury_prop_traffic_light')
	local traffic_light_wait = GetHashKey('lc_estate_canonbury_prop_traffic_wait')
	local traffic_light_ped = GetHashKey('lc_estate_canonbury_prop_traffic_light_ped')
	local traffic_light_red = GetHashKey('lc_estate_canonbury_prop_traffic_light1_red_on')
	local traffic_light_organge = GetHashKey('lc_estate_canonbury_prop_traffic_light1_orange_on')
	local traffic_light_green = GetHashKey('lc_estate_canonbury_prop_traffic_light1_green_on')
	local traffic_light_pedred = GetHashKey('lc_estate_canonbury_prop_traffic_light1_pedred_on')
	local traffic_light_pedgreen = GetHashKey('lc_estate_canonbury_prop_traffic_light1_pedgreen_on')



	RequestModel(zeabra)

	while not HasModelLoaded(zeabra) do
		RequestModel(zeabra)
		Citizen.Wait(1)
	end

	RequestModel(zeabra_light)
	while not HasModelLoaded(zeabra_light) do
		RequestModel(zeabra_light)
		Citizen.Wait(1)
	end

	RequestModel(traffic_light)
	while not HasModelLoaded(traffic_light) do
		RequestModel(traffic_light)
		Citizen.Wait(1)
	end

	local object,object2=nil,nil

	for k,i in ipairs(zeabra_locations) do
		object2=create_object(zeabra,i.coord)
		zeabra_locations[k].object2=object2

		object=create_object(zeabra_light,i.coord)
		zeabra_locations[k].object=object
	end

	object=nil
	local xx,xy,xz=nil,nil,nil

	local object3,object4=nil,nil
	for k,i in ipairs(traffic_locations) do
		object=create_object(traffic_light,i.coord)
		traffic_locations[k].objects.traffic=object

		object=create_object(traffic_light_ped,i.coord)
		SetEntityHeading(object,i.coord.w + 180)
		traffic_locations[k].objects.ped=object
		xx,xy,xz=GetOffsetFromEntityInWorldCoords(object,0.2,-0.45,0.0)
		SetEntityCoordsNoOffset(object,xx,xy,xz)

		object=create_object(traffic_light_wait,i.coord)
		SetEntityHeading(object,i.coord.w + 180)
		xx,xy,xz=GetOffsetFromEntityInWorldCoords(object,0.2,-0.45,-0.3)
		SetEntityCoordsNoOffset(object,xx,xy,xz)
		traffic_locations[k].objects.wait=object



		object=create_object(traffic_light_red,i.coord)
		traffic_locations[k].objects.redlight=object
		SetEntityAlpha(object,0)

		object=create_object(traffic_light_organge,i.coord)
		SetEntityAlpha(object,0)
		traffic_locations[k].objects.orangelight=object

		object=create_object(traffic_light_green,i.coord)
		-- print('green light '..tostring(object))
		SetEntityAlpha(object,255)
		traffic_locations[k].objects.greenlight=object
	

		
		object=create_object(traffic_light_pedred,i.coord)
		traffic_locations[k].objects.pedred=object
		SetEntityHeading(object,i.coord.w + 180)
		xx,xy,xz=GetOffsetFromEntityInWorldCoords(object,0.2,-0.45,0.0)
		SetEntityCoordsNoOffset(object,xx,xy,xz)
		SetEntityAlpha(object,255)

		object=create_object(traffic_light_pedgreen,i.coord)
		traffic_locations[k].objects.pedgreen=object
		SetEntityHeading(object,i.coord.w + 180)
		xx,xy,xz=GetOffsetFromEntityInWorldCoords(object,0.2,-0.45,0.0)
		SetEntityCoordsNoOffset(object,xx,xy,xz)
		SetEntityAlpha(object,0) --lr_cs4_roads_long_0
		-- 1292.7251, 3346.91431, 27.16222
		-- 1691.4834, 3706.27563, 47.20534
		Wait(100)
	end

	
	while true do

		local coords = GetEntityCoords(PlayerPedId())
		local zone = GetNameOfZone(coords.x, coords.y, coords.z)
		local zoneLabel = ""
		local var1, var2 = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
		local hash1 = GetStreetNameFromHashKey(var1)
	
		-- print('-- -- --')
		-- print(hash1)
		-- print(var1)

		zeabra_toggle_light(0,0)
		zeabra_toggle_light(1,1)
		Citizen.Wait(500)
		zeabra_toggle_light(1,0)
		zeabra_toggle_light(0,1)
		Citizen.Wait(500)
	end
end)

function zeabra_toggle_light(status,style)
	for k,i in ipairs(zeabra_locations) do
		if style==i.style and DoesEntityExist(i.object) then
			if status==0 then
				SetEntityAlpha(i.object,0)
			else
				SetEntityAlpha(i.object,255)
			end
		end
	end
end

function create_object(hash,coord)
	local object2 = CreateObjectNoOffset(hash,coord.x,coord.y,coord.z, false, false, false)
	FreezeEntityPosition(object2, true)
	SetEntityHeading(object2,coord.w)
	-- print('created -- '..object2 )
	table.insert(spawned_objects,object2)
	return object2
end

RegisterCommand('traffic_wait', function(source, args)
	Citizen.CreateThread(function()
		for k,i in ipairs(traffic_locations) do
			SetEntityAlpha(i.objects.greenlight,0)
			SetEntityAlpha(i.objects.orangelight,255)
		end
		Wait(2000)--2000
		for k,i in ipairs(traffic_locations) do
			SetEntityAlpha(i.objects.redlight,255)
			SetEntityAlpha(i.objects.orangelight,0)
		end
		Wait(2000)--2000
		for k,i in ipairs(traffic_locations) do
			SetEntityAlpha(i.objects.pedred,0)
			SetEntityAlpha(i.objects.pedgreen,255)
		end
		Wait(10000)--1000
		for k,i in ipairs(traffic_locations) do
			SetEntityAlpha(i.objects.pedred,255)
			SetEntityAlpha(i.objects.pedgreen,0)
		end
		Wait(2000)--2000
		for k,i in ipairs(traffic_locations) do
			SetEntityAlpha(i.objects.redlight,0)
		end
		for i=1, 10 do
			for k,i in ipairs(traffic_locations) do
				SetEntityAlpha(i.objects.orangelight,255)
			end
			Wait(350)
			for k,i in ipairs(traffic_locations) do
				SetEntityAlpha(i.objects.orangelight,0)
			end
			Wait(350)
		end
		for k,i in ipairs(traffic_locations) do
			SetEntityAlpha(i.objects.greenlight,255)
		end
	end)
end)

AddEventHandler("onResourceStop",function(name)
	if name ~= GetCurrentResourceName() then return end
	
	for k,i in ipairs(spawned_objects) do
		-- print(i)
		if not DoesEntityExist(i) then return end

		DeleteEntity(i)
	end
end)