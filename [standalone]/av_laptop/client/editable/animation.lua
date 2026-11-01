local tablet = false
local tabletObj = nil
local tabletDict = "amb@code_human_in_bus_passenger_idles@female@tablet@base"
local tabletAnim = "base"
local tabletProp = `prop_cs_tablet`
local tabletBone = 60309
local tabletOffset = vector3(0.03, 0.002, -0.0)
local tabletRot = vector3(10.0, 160.0, 0.0)
local currentDict, currentAnim = tabletDict, tabletAnim
local cameraPoses = {
	rear = {
		dict = "cellphone@",
		anim = "cellphone_photo_idle",
		bone = 18905,
		offset = vector3(0.165, 0.04, 0.04),
		rot = vector3(390.0, 158.0, 179.0),
		order = 1,
	},
	selfie = {
		dict = "cellphone@self",
		anim = "selfie",
		bone = 57005,
		offset = vector3(0.1466, 0.0064, -0.0737),
		rot = vector3(40.691, 59.9215, -112.1498),
		order = 2,
	},
}

local function attachTablet(bone, offset, rot, order)
	dbug("Attaching tablet to bone", bone, offset, rot, order)
	if not tabletObj or not DoesEntityExist(tabletObj) then
		return
	end
	local playerPed = PlayerPedId()
	AttachEntityToEntity(
		tabletObj,
		playerPed,
		GetPedBoneIndex(playerPed, bone),
		offset.x,
		offset.y,
		offset.z,
		rot.x,
		rot.y,
		rot.z,
		true,
		true,
		false,
		true,
		order or 2,
		true
	)
end

local function loadDict(dict)
	RequestAnimDict(dict)
	local tries = 0
	while not HasAnimDictLoaded(dict) and tries < 50 do
		Wait(50)
		tries += 1
	end
	return HasAnimDictLoaded(dict)
end

function TabletCameraPose(mode)
	local pose = mode and cameraPoses[mode] or nil
	local dict = pose and pose.dict or tabletDict
	local anim = pose and pose.anim or tabletAnim
	if pose then
		attachTablet(pose.bone, pose.offset, pose.rot, pose.order or 2)
	else
		attachTablet(tabletBone, tabletOffset, tabletRot, 2)
	end
	if dict == currentDict and anim == currentAnim then
		return
	end
	if not loadDict(dict) then
		dbug("Camera pose anim dict failed to load", dict, anim)
		return
	end
	local playerPed = PlayerPedId()
	if IsEntityPlayingAnim(playerPed, currentDict, currentAnim, 3) then
		StopAnimTask(playerPed, currentDict, currentAnim, 1.0)
	end
	currentDict, currentAnim = dict, anim
	if tablet then
		TaskPlayAnim(playerPed, currentDict, currentAnim, 3.0, 3.0, -1, 49, 0, 0, 0, 0)
	end
end

function ToggleTablet(toggle)
	if toggle and not tablet then
		tablet = true
		currentDict, currentAnim = tabletDict, tabletAnim
		CreateThread(function()
			loadDict(tabletDict)
			RequestModel(tabletProp)
			while not HasModelLoaded(tabletProp) do
				Wait(150)
			end
			local playerPed = PlayerPedId()
			tabletObj = CreateObject(tabletProp, 0.0, 0.0, 0.0, true, true, false)
			SetCurrentPedWeapon(playerPed, `weapon_unarmed`, true)
			attachTablet(tabletBone, tabletOffset, tabletRot, 2)
			SetModelAsNoLongerNeeded(tabletProp)
			while tablet do
				Wait(100)
				playerPed = PlayerPedId()
				if not IsEntityPlayingAnim(playerPed, currentDict, currentAnim, 3) then
					TaskPlayAnim(playerPed, currentDict, currentAnim, 3.0, 3.0, -1, 49, 0, 0, 0, 0)
				end
			end
			ClearPedSecondaryTask(playerPed)
			Wait(450)
			if tabletObj and DoesEntityExist(tabletObj) then
				DetachEntity(tabletObj, true, false)
				DeleteEntity(tabletObj)
			end
			tabletObj = nil
		end)
	elseif not toggle and tablet then
		tablet = false
		currentDict, currentAnim = tabletDict, tabletAnim
	end
end

function openLaptop() -- Triggered when player opens laptop // just in case u want to trigger something (?)
end

function closeLaptop() -- Triggered when player closes laptop // just in case u want to trigger something (?)
end
