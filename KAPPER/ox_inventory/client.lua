if not lib then return end

require 'modules.bridge.client'
require 'modules.interface.client'

local Utils = require 'modules.utils.client'
local Weapon = require 'modules.weapon.client'
local currentWeapon

exports('getCurrentWeapon', function()
	return currentWeapon
end)

RegisterNetEvent('ox_inventory:disarm', function(noAnim)
	currentWeapon = Weapon.Disarm(currentWeapon, noAnim)
end)

RegisterNetEvent('ox_inventory:clearWeapons', function()
	Weapon.ClearAll(currentWeapon)
end)

local StashTarget

exports('setStashTarget', function(id, owner)
	StashTarget = id and {id=id, owner=owner}
end)

---@type boolean | number
local invBusy = true

---@type boolean?
local invOpen = false
local IsPedCuffed = IsPedCuffed
local playerPed = cache.ped

lib.onCache('ped', function(ped)
	playerPed = ped
	Utils.WeaponWheel()
end)

client.player:setr('invBusy', true)
client.player:set('invHotkeys', false)
client.player:set('canUseWeapons', false)

local function canOpenInventory()
    if not PlayerData.loaded then
        return shared.info('cannot open inventory', '(player inventory has not loaded)')
    end

    if IsPauseMenuActive() then return end

    if invBusy or invOpen == nil or (currentWeapon?.timer or 0) > 0 then
        return shared.info('cannot open inventory', '(is busy)')
    end

    if PlayerData.dead or IsPedFatallyInjured(playerPed) then
        return shared.info('cannot open inventory', '(fatal injury)')
    end

    if PlayerData.cuffed or IsPedCuffed(playerPed) then
        return shared.info('cannot open inventory', '(cuffed)')
    end

    return true
end

---@param ped number
---@return boolean
local function canOpenTarget(ped)
	return IsPedFatallyInjured(ped)
	or IsEntityPlayingAnim(ped, 'dead', 'dead_a', 3)
	or IsPedCuffed(ped)
	or IsEntityPlayingAnim(ped, 'mp_arresting', 'idle', 3)
	or IsEntityPlayingAnim(ped, 'missminuteman_1ig_2', 'handsup_base', 3)
	or IsEntityPlayingAnim(ped, 'missminuteman_1ig_2', 'handsup_enter', 3)
	or IsEntityPlayingAnim(ped, 'random@mugging3', 'handsup_standing_base', 3)
end

---@class OpenInventory
---@field id string | integer
---@field label string
---@field type string
---@field slots integer
---@field weight integer
---@field maxWeight integer
---@field coords? vector3
---@field distance? integer
---@field instance? string | number
---@field [string] unknown
local defaultInventory = {
	type = 'newdrop',
	slots = shared.dropslots,
	weight = 0,
	maxWeight = shared.dropweight,
	items = {}
}

local currentInventory = defaultInventory

local function closeTrunk()
	if currentInventory.type == 'trunk' then
		local coords = GetEntityCoords(playerPed, true)
		---@todo animation for vans?
		Utils.PlayAnimAdvanced(0, 'anim@heists@fleeca_bank@scope_out@return_case', 'trevor_action', coords.x, coords.y, coords.z, 0.0, 0.0, GetEntityHeading(playerPed), 2.0, 2.0, 1000, 49, 0.25)

		CreateThread(function()
			local entity = currentInventory.entity
			local door = currentInventory.door
			Wait(900)

			if type(door) == 'table' then
				for i = 1, #door do
					SetVehicleDoorShut(entity, door[i], false)
				end
			else
				SetVehicleDoorShut(entity, door, false)
			end
		end)
	end
end

local CraftingBenches = require 'modules.crafting.client'
local Vehicles = lib.load('data.vehicles')
local Inventory = require 'modules.inventory.client'
local CustomAppearance = require 'modules.customappearance.client'
require 'modules.customstash.client'
require 'modules.customcraft.client'
require 'modules.customshop.client'
local UiTheme = require 'modules.uitheme.client'

-- Generates (and caches) a GTA V headshot for the local ped, returning a
-- url the NUI layer can render via the FiveM `nui-img` scheme.
local headshotHandle, headshotTexture

local function getPlayerMugshot()
	local ped = cache.ped or PlayerPedId()

	if headshotTexture and headshotHandle and IsPedheadshotValid(headshotHandle) then
		return ('https://nui-img/%s/%s'):format(headshotTexture, headshotTexture)
	end

	if headshotHandle then UnregisterPedheadshot(headshotHandle) end

	headshotHandle = RegisterPedheadshot(ped)
	local timeout = GetGameTimer() + 2000

	while not IsPedheadshotReady(headshotHandle) or not IsPedheadshotValid(headshotHandle) do
		if GetGameTimer() > timeout then return nil end
		Wait(0)
	end

	headshotTexture = GetPedheadshotTxdString(headshotHandle)

	return ('https://nui-img/%s/%s'):format(headshotTexture, headshotTexture)
end

-- Sends the local player's display name, money accounts and headshot to the UI header.
-- Framework-specific; currently wired for ESX Legacy. Safe no-op on other frameworks.
local function sendPlayerHeaderData()
	if shared.framework ~= 'esx' then return end

	local ok, ESX = pcall(function() return exports.es_extended:getSharedObject() end)
	if not ok or not ESX then return end

	local data = ESX.GetPlayerData()
	if not data then return end

	local accounts = {}

	for i = 1, #(data.accounts or {}) do
		local account = data.accounts[i]
		accounts[#accounts + 1] = {
			name = account.name,
			money = account.money,
			label = account.label,
		}
	end

	local job = data.job and {
		name = data.job.name,
		label = data.job.label,
		grade = data.job.grade,
		gradeLabel = data.job.grade_label,
	} or nil

	SendNUIMessage({
		action = 'setPlayerData',
		data = {
			name = data.name or GetPlayerName(cache.playerId),
			serverId = GetPlayerServerId(cache.playerId),
			accounts = accounts,
			mugshot = getPlayerMugshot(),
			job = job,
		}
	})
end

-- Keep the UI header money in sync as accounts change while the inventory is open.
RegisterNetEvent('esx:setAccountMoney', function(account)
	if shared.framework ~= 'esx' or not account then return end

	SendNUIMessage({
		action = 'setAccount',
		data = {
			name = account.name,
			money = account.money,
			label = account.label,
		}
	})
end)

-- Keep the UI header job/grade in sync while the inventory is open.
RegisterNetEvent('esx:setJob', function(job)
	if shared.framework ~= 'esx' or not job then return end

	SendNUIMessage({
		action = 'setJob',
		data = {
			name = job.name,
			label = job.label,
			grade = job.grade,
			gradeLabel = job.grade_label,
		}
	})
end)

---@param inv string?
---@param data any?
---@return boolean?
function client.openInventory(inv, data)
	if invOpen then
		if not inv and currentInventory.type == 'newdrop' then
			return client.closeInventory()
		end

		if IsNuiFocused() then
			if inv == 'container' and currentInventory.id == PlayerData.inventory[data].metadata.container then
				return client.closeInventory()
			end

			if currentInventory.type == 'drop' and (not data or currentInventory.id == (type(data) == 'table' and data.id or data)) then
				return client.closeInventory()
			end

			if inv ~= 'drop' and inv ~= 'container' then
				if (data?.id or data) == currentInventory.id then
					-- Triggering exports.ox_inventory:openInventory('stash', 'mystash') twice in rapid succession is weird behaviour
					return warn(("script tried to open inventory, but it is already open\n%s"):format(Citizen.InvokeNative(`FORMAT_STACK_TRACE` & 0xFFFFFFFF, nil, 0, Citizen.ResultAsString())))
				else
					return client.closeInventory()
				end
			end
		end
	elseif IsNuiFocused() then
		-- If triggering from another nui, may need to wait for focus to end.
		Wait(100)

        -- People still complain about this being an "error" and ask "how fix" despite being a warning
        -- for people with above room-temperature iqs to look into resource conflicts on their own.
		-- if IsNuiFocused() then
		-- 	warn('other scripts have nui focus and may cause issues (e.g. disable focus, prevent input, overlap inventory window)')
		-- end
	end

	if inv == 'dumpster' and cache.vehicle then
		return lib.notify({ id = 'inventory_right_access', type = 'error', description = locale('inventory_right_access') })
	end

	if not canOpenInventory() then
        return lib.notify({ id = 'inventory_player_access', type = 'error', description = locale('inventory_player_access') })
    end

    local left, right, accessError

    if inv == 'player' and data ~= cache.serverId then
        local targetId, targetPed, serverId

        if not data then
            targetId, targetPed = Utils.GetClosestPlayer()
            serverId = targetId and GetPlayerServerId(targetId)
            data = serverId
        else
            serverId = type(data) == 'table' and data.id or data
            targetId = serverId and GetPlayerFromServerId(serverId)
            targetPed = targetId and GetPlayerPed(targetId)
        end

        if serverId == cache.serverId then return end

        local targetCoords = targetPed and GetEntityCoords(targetPed)

        if not targetCoords or #(targetCoords - GetEntityCoords(playerPed)) > 1.8 or (not client.hasGroup(shared.police) and not Player(serverId).state.canSteal) then
            return lib.notify({ id = 'inventory_right_access', type = 'error', description = locale('inventory_right_access') })
        end
    end

    if inv == 'shop' and invOpen == false then
        if cache.vehicle then
            return lib.notify({ id = 'cannot_perform', type = 'error', description = locale('cannot_perform') })
        end

        left, right, accessError = lib.callback.await('ox_inventory:openShop', 200, data)
    elseif inv == 'crafting' then
        if cache.vehicle then
            return lib.notify({ id = 'cannot_perform', type = 'error', description = locale('cannot_perform') })
        end

        left, right, accessError = lib.callback.await('ox_inventory:openCraftingBench', 200, data.id, data.index)

        if left then
            right = CraftingBenches[data.id]

            if not right?.items then return end

            local coords, distance

            if not right.zones and not right.points then
                coords = GetEntityCoords(cache.ped)
                distance = 2
            else
                coords = shared.target and right.zones and right.zones[data.index].coords or right.points and right.points[data.index]
                distance = coords and shared.target and right.zones[data.index].distance or 2
            end

            right = {
                type = 'crafting',
                id = data.id,
                label = right.label or locale('crafting_bench'),
                index = data.index,
                slots = right.slots,
                items = right.items,
                coords = coords,
                distance = distance
            }
        end
    elseif invOpen ~= nil then
        if inv == 'policeevidence' then
            if not data then
                local input = lib.inputDialog(locale('police_evidence'), {
                    { label = locale('locker_number'), type = 'number', required = true, icon = 'calculator' }
                }) --[[@as number[]? ]]

                if not input then return end

                data = input[1]
            end
        end

        left, right, accessError = lib.callback.await('ox_inventory:openInventory', false, inv, data)
    end

    if accessError then
        return lib.notify({ id = accessError, type = 'error', description = locale(accessError) })
    end

    -- Stash does not exist
    if not left then
        if left == false then return false end

        if invOpen == false then
            return lib.notify({ id = 'inventory_right_access', type = 'error', description = locale('inventory_right_access') })
        end

        if invOpen then return client.closeInventory() end
    end


    if not cache.vehicle then
        if inv == 'player' then
            Utils.PlayAnim(0, 'mp_common', 'givetake1_a', 8.0, 1.0, 2000, 50, 0.0, 0, 0, 0)
        elseif inv ~= 'trunk' then
            Utils.PlayAnim(0, 'pickup_object', 'putdown_low', 5.0, 1.5, 1000, 48, 0.0, 0, 0, 0)
        end
    end

	client.player:set('invOpen', true)

    SetInterval(client.interval, 100)
    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(true)
    closeTrunk()

    if client.screenblur then Utils.blurIn() end

    currentInventory = right or defaultInventory
    left.items = PlayerData.inventory
    left.groups = PlayerData.groups

    SendNUIMessage({
        action = 'setupInventory',
        data = {
            leftInventory = left,
            rightInventory = currentInventory
        }
    })

    sendPlayerHeaderData()

    if inv and not currentInventory.coords and inv ~= 'container' and inv ~= 'glovebox' then
        currentInventory.coords = GetEntityCoords(playerPed)
    end

    if inv == 'trunk' then
        SetTimeout(200, function()
            ---@todo animation for vans?
            Utils.PlayAnim(0, 'anim@heists@prison_heiststation@cop_reactions', 'cop_b_idle', 3.0, 3.0, -1, 49, 0.0, 0, 0, 0)

            local entity = data.entity or NetworkGetEntityFromNetworkId(data.netid)
            currentInventory.entity = entity
            currentInventory.door = data.door

            if not currentInventory.door then
                local vehicleHash = GetEntityModel(entity)
                local vehicleClass = GetVehicleClass(entity)
                currentInventory.door = vehicleClass == 12 and { 2, 3 } or Vehicles.Storage[vehicleHash] and 4 or 5
            end

            while currentInventory.entity == entity and invOpen and DoesEntityExist(entity) and Inventory.CanAccessTrunk(entity) do
                Wait(100)
            end

            if invOpen then client.closeInventory() end
        end)
    end

    return true
end

RegisterNetEvent('ox_inventory:openInventory', client.openInventory)
exports('openInventory', client.openInventory)

RegisterNetEvent('ox_inventory:forceOpenInventory', function(left, right)
	if source == '' then return end

	client.player:set('invOpen', true)

	SetInterval(client.interval, 100)
	SetNuiFocus(true, true)
	SetNuiFocusKeepInput(true)
	closeTrunk()

	if client.screenblur then Utils.blurIn() end

	currentInventory = right or defaultInventory
	currentInventory.ignoreSecurityChecks = true
	left.items = PlayerData.inventory
	left.groups = PlayerData.groups

	SendNUIMessage({
		action = 'setupInventory',
		data = {
			leftInventory = left,
			rightInventory = currentInventory
		}
	})

	sendPlayerHeaderData()
end)

local Animations = lib.load('data.animations')
local Items = require 'modules.items.client'
local usingItem = false

---@param data { name: string, label: string, count: number, slot: number, metadata: table<string, any>, weight: number }
lib.callback.register('ox_inventory:usingItem', function(data, noAnim)
	local item = Items[data.name]

	if item and usingItem then
		if not item.client then return true end
		---@cast item +OxClientProps
		item = item.client

		if type(item.anim) == 'string' then
			item.anim = Animations.anim[item.anim]
		end

		if item.prop then
			if item.prop[1] then
				for i = 1, #item.prop do
					if type(item.prop) == 'string' then
						item.prop = Animations.prop[item.prop[i]]
					end
				end
			elseif type(item.prop) == 'string' then
				item.prop = Animations.prop[item.prop]
			end
		end

		if not item.disable then
			item.disable = { combat = true }
		elseif item.disable.combat == nil then
			-- Backwards compatibility; you probably don't want people shooting while eating and bandaging anyway
			item.disable.combat = true
		end

		local success = (not item.usetime or noAnim or lib.progressBar({
			duration = item.usetime,
			label = item.label or locale('using', data.metadata.label or data.label),
			useWhileDead = item.useWhileDead,
			canCancel = item.cancel,
			disable = item.disable,
			anim = item.anim or item.scenario,
			prop = item.prop --[[@as ProgressProps]]
		})) and not PlayerData.dead

		if success then
			if item.notification then
				lib.notify({ description = item.notification })
			end

			if item.status then
				if client.setPlayerStatus then
					client.setPlayerStatus(item.status)
				end
			end

			return true
		end
	end
end)

local function canUseItem(isAmmo)
	local ped = cache.ped

	return not usingItem
    and (not isAmmo or currentWeapon)
	and PlayerData.loaded
	and not PlayerData.dead
	and not invBusy
	and not lib.progressActive()
	and not IsPedRagdoll(ped)
	and not IsPedFalling(ped)
    and not IsPedShooting(playerPed)
end

---@param data table
---@param cb fun(response: SlotWithItem | false)?
---@param noAnim? boolean
local function useItem(data, cb, noAnim)
	local slotData, result = PlayerData.inventory[data.slot]

	if not slotData or not canUseItem(data.ammo and true) then
        if currentWeapon then
            return lib.notify({ id = 'cannot_perform', type = 'error', description = locale('cannot_perform') })
        end

        return
    end

	if currentWeapon and currentWeapon.timer ~= 0 then
        if not currentWeapon.timer or currentWeapon.timer - GetGameTimer() > 100 then return end

        DisablePlayerFiring(cache.playerId, true)
    end

    if invOpen and data.close then client.closeInventory() end

    usingItem = true
    ---@type boolean?
    result = lib.callback.await('ox_inventory:useItem', 200, data.name, data.slot, slotData.metadata, noAnim)

	if result and cb then
		local success, response = pcall(cb, result and slotData)

		if not success and response then
			warn(('^1An error occurred while calling item "%s" callback!\n^1SCRIPT ERROR: %s^0'):format(slotData.name, response))
		end
	end

    if result then
        TriggerEvent('ox_inventory:usedItem', slotData.name, slotData.slot, next(slotData.metadata) and slotData.metadata)
    end

	Wait(500)
    usingItem = false
end

AddEventHandler('ox_inventory:usedItem', function(name, slot, metadata)
    TriggerServerEvent('ox_inventory:usedItemInternal', slot)
end)

AddEventHandler('ox_inventory:item', useItem)
exports('useItem', useItem)

---@param slot number
---@return boolean?
local function useSlot(slot, noAnim)
	local item = PlayerData.inventory[slot]
	if not item then return end

	local data = Items[item.name]
	if not data then return end

	if canUseItem(data.ammo and true) then
		if data.component and not currentWeapon then
			return lib.notify({ id = 'weapon_hand_required', type = 'error', description = locale('weapon_hand_required') })
		end

		local durability = item.metadata.durability --[[@as number?]]
		local consume = data.consume --[[@as number?]]
		local label = item.metadata.label or item.label --[[@as string]]

		-- Naive durability check to get an early exit
		-- People often don't call the 'useItem' export and then complain about "broken" items being usable
		-- This won't work with degradation since we need access to os.time on the server
		if durability and durability <= 100 and consume then
			if durability <= 0 then
				return lib.notify({ type = 'error', description = locale('no_durability', label) })
			elseif consume ~= 0 and consume < 1 and durability < consume * 100 then
				return lib.notify({ type = 'error', description = locale('not_enough_durability', label) })
			end
		end

		data.slot = slot

		if item.metadata.container then
			return client.openInventory('container', item.slot)
		elseif data.client then
			if invOpen and data.close then client.closeInventory() end

			if data.export then
				return data.export(data, {name = item.name, slot = item.slot, metadata = item.metadata})
			elseif data.client.event then -- re-add it, so I don't need to deal with morons taking screenshots of errors when using trigger event
				return TriggerEvent(data.client.event, data, {name = item.name, slot = item.slot, metadata = item.metadata})
			end
		end

		if data.effect then
			data:effect({name = item.name, slot = item.slot, metadata = item.metadata})
		elseif data.weapon then
			if EnableWeaponWheel or not client.player:get('canUseWeapons') then return end

			if IsCinematicCamRendering() then SetCinematicModeActive(false) end

			if currentWeapon then
                if not currentWeapon.timer or currentWeapon.timer ~= 0 then return end

				local weaponSlot = currentWeapon.slot
				currentWeapon = Weapon.Disarm(currentWeapon)

				if weaponSlot == data.slot then return end
			end

            GiveWeaponToPed(playerPed, data.hash, 0, false, true)
            SetCurrentPedWeapon(playerPed, data.hash, false)

            if data.hash ~= GetSelectedPedWeapon(playerPed) then
                lib.print.info(('failed to equip %s (cause unknown)'):format(item.name))
                return lib.notify({ type = 'error', description = locale('cannot_use', data.label) })
            end

            RemoveWeaponFromPed(cache.ped, data.hash)

			useItem(data, function(result)
				if result then
                    local sleep
					currentWeapon, sleep = Weapon.Equip(item, data, noAnim)

					if sleep then Wait(sleep) end
				end
			end, noAnim)
		elseif currentWeapon then
			if data.ammo then
				if EnableWeaponWheel or currentWeapon.metadata.durability <= 0 then return end

				local clipSize = GetMaxAmmoInClip(playerPed, currentWeapon.hash, true)
				local currentAmmo = GetAmmoInPedWeapon(playerPed, currentWeapon.hash)
				local _, maxAmmo = GetMaxAmmo(playerPed, currentWeapon.hash)

				if maxAmmo < clipSize then clipSize = maxAmmo end

				if currentAmmo == clipSize then return end

				useItem(data, function(resp)
					if not resp or resp.name ~= currentWeapon?.ammo then return end

					if currentWeapon.metadata.specialAmmo ~= resp.metadata.type and type(currentWeapon.metadata.specialAmmo) == 'string' then
						local clipComponentKey = ('%s_CLIP'):format(Items[currentWeapon.name].model:gsub('WEAPON_', 'COMPONENT_'))
						local specialClip = ('%s_%s'):format(clipComponentKey, (resp.metadata.type or currentWeapon.metadata.specialAmmo):upper())

						if type(resp.metadata.type) == 'string' then
							if not HasPedGotWeaponComponent(playerPed, currentWeapon.hash, specialClip) then
								if not DoesWeaponTakeWeaponComponent(currentWeapon.hash, specialClip) then
									warn('cannot use clip with this weapon')
									return
								end

								local defaultClip = ('%s_01'):format(clipComponentKey)

								if not HasPedGotWeaponComponent(playerPed, currentWeapon.hash, defaultClip) then
									warn('cannot use clip with currently equipped clip')
									return
								end

								if currentAmmo > 0 then
									warn('cannot mix special ammo with base ammo')
									return
								end

								currentWeapon.metadata.specialAmmo = resp.metadata.type

								GiveWeaponComponentToPed(playerPed, currentWeapon.hash, specialClip)
							end
						elseif HasPedGotWeaponComponent(playerPed, currentWeapon.hash, specialClip) then
							if currentAmmo > 0 then
								warn('cannot mix special ammo with base ammo')
								return
							end

							currentWeapon.metadata.specialAmmo = nil

							RemoveWeaponComponentFromPed(playerPed, currentWeapon.hash, specialClip)
						end
					end

					if maxAmmo > clipSize then
						clipSize = GetMaxAmmoInClip(playerPed, currentWeapon.hash, true)
					end

					currentAmmo = GetAmmoInPedWeapon(playerPed, currentWeapon.hash)
					local missingAmmo = clipSize - currentAmmo
					local addAmmo = resp.count > missingAmmo and missingAmmo or resp.count
					local newAmmo = currentAmmo + addAmmo

					if newAmmo == currentAmmo then return end

                    AddAmmoToPed(playerPed, currentWeapon.hash, addAmmo)

					if cache.vehicle then
						if cache.seat > -1 or IsVehicleStopped(cache.vehicle) then
							TaskReloadWeapon(playerPed, true)
                        else
                            -- This is a hacky solution for forcing ammo to properly load into the
                            -- weapon clip while driving; without it, ammo will be added but won't
                            -- load until the player stops doing anything. i.e. if you keep shooting,
                            -- the weapon will not reload until the clip empties.
                            -- And yes - for some reason RefillAmmoInstantly needs to run in a loop.
                            lib.waitFor(function()
                                RefillAmmoInstantly(playerPed)

                                local _, ammo = GetAmmoInClip(playerPed, currentWeapon.hash)
                                return ammo == newAmmo or nil
                            end)
                        end
					else
						Wait(100)
						MakePedReload(playerPed)

						SetTimeout(100, function()
							while IsPedReloading(playerPed) do
								DisableControlAction(0, 22, true)
								Wait(0)
							end
						end)
					end

					lib.callback.await('ox_inventory:updateWeapon', false, 'load', newAmmo, false, currentWeapon.metadata.specialAmmo)
				end)
			elseif data.component then
				local components = data.client.component

                if not components then return end

				local componentType = data.type
				local weaponComponents = PlayerData.inventory[currentWeapon.slot].metadata.components

				-- Checks if the weapon already has the same component type attached
				for componentIndex = 1, #weaponComponents do
					if componentType == Items[weaponComponents[componentIndex]].type then
						return lib.notify({ id = 'component_slot_occupied', type = 'error', description = locale('component_slot_occupied', componentType) })
					end
				end

				for i = 1, #components do
					local component = components[i]

					if DoesWeaponTakeWeaponComponent(currentWeapon.hash, component) then
						if HasPedGotWeaponComponent(playerPed, currentWeapon.hash, component) then
							lib.notify({ id = 'component_has', type = 'error', description = locale('component_has', label) })
						else
							useItem(data, function(data)
								if data then
									local success = lib.callback.await('ox_inventory:updateWeapon', false, 'component', tostring(data.slot), currentWeapon.slot)

									if success then
										GiveWeaponComponentToPed(playerPed, currentWeapon.hash, component)
										TriggerEvent('ox_inventory:updateWeaponComponent', 'added', component, data.name)
									end
								end
							end)
						end
						return
					end
				end
				lib.notify({ id = 'component_invalid', type = 'error', description = locale('component_invalid', label) })
			elseif data.allowArmed then
				useItem(data)
            else
                return lib.notify({ id = 'cannot_perform', type = 'error', description = locale('cannot_perform') })
			end
		elseif not data.ammo and not data.component then
			useItem(data)
		end
    end
end
exports('useSlot', useSlot)

---@param id number
---@param slot number
local function useButton(id, slot)
	if PlayerData.loaded and not invBusy and not lib.progressActive() then
		local item = PlayerData.inventory[slot]
		if not item then return end

		local data = Items[item.name]
		local buttons = data?.buttons

		if buttons and buttons[id]?.action then
			buttons[id].action(slot)
		end
	end
end

local function openNearbyInventory() client.openInventory('player') end

exports('openNearbyInventory', openNearbyInventory)

local currentInstance
local playerCoords
local Shops = require 'modules.shops.client'

---@todo remove or replace when the bridge module gets restructured
function OnPlayerData(key, val)
	if key ~= 'groups' and key ~= 'ped' and key ~= 'dead' then return end

	if key == 'groups' then
		Inventory.Stashes()
		Inventory.Evidence()
		Shops.refreshShops()
	elseif key == 'dead' and val then
		currentWeapon = Weapon.Disarm(currentWeapon)
		client.closeInventory()
	end

	Utils.WeaponWheel()
end

-- People consistently ignore errors when one of the "modules" failed to load
if not Utils or not Weapon or not Items or not Inventory then return end

local invHotkeys = false

-- True while the NUI is showing the wardrobe (Clothes) tab. Kept in sync by the
-- openClothing/closeClothing NUI callbacks so the clothing keybind can toggle:
-- press to jump to the Clothes tab, press again while on it to close the inventory.
local clothingTabOpen = false

---@type function?
local function registerCommands()
	if client.enablestealcommand then
		RegisterCommand('steal', openNearbyInventory, false)
	end

	local function openGlovebox(vehicle)
		if not IsPedInAnyVehicle(playerPed, false) or not NetworkGetEntityIsNetworked(vehicle) then return end

		if IsEntityDead(vehicle) then return end

		local vehicleHash = GetEntityModel(vehicle)
		local vehicleClass = GetVehicleClass(vehicle)
		local checkVehicle = Vehicles.Storage[vehicleHash]

		-- No storage or no glovebox
		if (checkVehicle == 0 or checkVehicle == 2) or (not Vehicles.glovebox[vehicleClass] and not Vehicles.glovebox.models[vehicleHash]) then return end

		local isOpen = client.openInventory('glovebox', { netid = NetworkGetNetworkIdFromEntity(vehicle) })

		if isOpen then
			currentInventory.entity = vehicle
		end
	end

	local primary = lib.addKeybind({
		name = 'inv',
		description = locale('open_player_inventory'),
		defaultKey = client.keys[1],
		onPressed = function()
			if invOpen then
				return client.closeInventory()
			end

			if cache.vehicle then
				return openGlovebox(cache.vehicle)
			end

			local closest = lib.points.getClosestPoint()

			if closest and closest.currentDistance < 1.2 and (not closest.instance or closest.instance == currentInstance) then
				if closest.inv == 'crafting' then
					return client.openInventory('crafting', { id = closest.id, index = closest.index })
				elseif closest.inv ~= 'license' and closest.inv ~= 'policeevidence' then
					return client.openInventory(closest.inv or 'drop', { id = closest.invId, type = closest.type })
				end
			end

			return client.openInventory()
		end
	})

	lib.addKeybind({
		name = 'inv2',
		description = locale('open_secondary_inventory'),
		defaultKey = client.keys[2],
		onPressed = function(self)
            if primary:getCurrentKey() == self:getCurrentKey() then
                return warn(("secondary inventory keybind '%s' disabled (keybind cannot match primary inventory keybind)"):format(self:getCurrentKey()))
            end

			if invOpen then
				return client.closeInventory()
			end

			if invBusy or not canOpenInventory() then
				return lib.notify({ id = 'inventory_player_access', type = 'error', description = locale('inventory_player_access') })
			end

			if StashTarget then
				return client.openInventory('stash', StashTarget)
			end

			if cache.vehicle then
				return openGlovebox(cache.vehicle)
			end

			local entity, entityType = Utils.Raycast(2|16)

			if not entity then return end

			if not shared.target and entityType == 3 then
				local model = GetEntityModel(entity)

				if Inventory.Dumpsters:includes(model) then
					return Inventory.OpenDumpster(entity)
				end
			end

			if entityType ~= 2 then return end

			Inventory.OpenTrunk(entity)
		end
	})

	-- Jump straight to the wardrobe / Clothes tab. Default key comes from the
	-- `inventory:clothingkeybind` convar (set in server.cfg); each player can still
	-- rebind it in FiveM's Key Bindings settings. Pressing it again while already on
	-- the Clothes tab closes the inventory.
	lib.addKeybind({
		name = 'invclothing',
		description = locale('open_clothing'),
		defaultKey = GetConvar('inventory:clothingkeybind', 'Y'),
		onPressed = function()
			if invOpen then
				if clothingTabOpen then
					return client.closeInventory()
				end

				return SendNUIMessage({ action = 'openClothesTab' })
			end

			if invBusy or not canOpenInventory() then
				return lib.notify({ id = 'inventory_player_access', type = 'error', description = locale('inventory_player_access') })
			end

			-- No-arg open = the player's OWN inventory (returns true on success),
			-- exactly like the primary keybind's base case.
			if client.openInventory() then
				SendNUIMessage({ action = 'openClothesTab' })
			end
		end
	})

	lib.addKeybind({
		name = 'reloadweapon',
		description = locale('reload_weapon'),
		defaultKey = 'r',
		onPressed = function(self)
			if not currentWeapon or EnableWeaponWheel or not canUseItem(true) then return end

			if currentWeapon.ammo then
				if currentWeapon.metadata.durability > 0 then
					local slotId = Inventory.GetSlotIdWithItem(currentWeapon.ammo, { type = currentWeapon.metadata.specialAmmo }, false)

					if slotId then
						useSlot(slotId)
					end
				else
					lib.notify({ id = 'no_durability', type = 'error', description = locale('no_durability', currentWeapon.label) })
				end
			end
		end
	})

	lib.addKeybind({
		name = 'hotbar',
		description = locale('disable_hotbar'),
		defaultKey = client.keys[3],
		onPressed = function()
			if EnableWeaponWheel or not invHotkeys or IsNuiFocused() or lib.progressActive() then return end
			SendNUIMessage({ action = 'toggleHotbar' })
		end
	})

	for i = 1, 5 do
		lib.addKeybind({
			name = ('hotkey%s'):format(i),
			description = locale('use_hotbar', i),
			defaultKey = tostring(i),
			onPressed = function()
				if invOpen or EnableWeaponWheel or not invHotkeys or IsNuiFocused() then return end
				useSlot(i)
			end
		})
	end

	registerCommands = nil
end

function client.closeInventory()
	if not client.interval then return end

	if invOpen then
		invOpen = nil
		SetNuiFocus(false, false)
		SetNuiFocusKeepInput(false)
		Utils.blurOut()
		closeTrunk()
		SendNUIMessage({ action = 'closeInventory' })
		SetInterval(client.interval, 200)
		Wait(200)

		if invOpen ~= nil then return end

		TriggerServerEvent('ox_inventory:closeInventory')

		currentInventory = defaultInventory
		client.player:set('invOpen', false)
		defaultInventory.coords = nil
	end
end

RegisterNetEvent('ox_inventory:closeInventory', client.closeInventory)
exports('closeInventory', client.closeInventory)

---@param data updateSlot[]
---@param weight number
local function updateInventory(data, weight)
	local changes = {}
    ---@type table<string, number>
	local itemCount = {}

	for i = 1, #data do
		local v = data[i]

		if not v.inventory or v.inventory == cache.serverId then
			v.inventory = 'player'
			local item = v.item

			if currentWeapon?.slot == item?.slot then
                if item.metadata then
				    currentWeapon.metadata = item.metadata
				    TriggerEvent('ox_inventory:currentWeapon', currentWeapon)
                else
                    currentWeapon = Weapon.Disarm(currentWeapon, true)
                end
			end

			local curItem = PlayerData.inventory[item.slot]

			if curItem and curItem.name then
				itemCount[curItem.name] = (itemCount[curItem.name] or 0) - curItem.count
			end

			if item.count then
				itemCount[item.name] = (itemCount[item.name] or 0) + item.count
			end

			changes[item.slot] = item.count and item or false
			if not item.count then item.name = nil end
			PlayerData.inventory[item.slot] = item.name and item or nil
		end
	end

	SendNUIMessage({ action = 'refreshSlots', data = { items = data, itemCount = itemCount} })

    if weight ~= PlayerData.weight then client.setPlayerData('weight', weight) end

	for itemName, count in pairs(itemCount) do
		local item = Items(itemName)

        if item then
            item.count += count

            TriggerEvent('ox_inventory:itemCount', item.name, item.count)

            if count < 0 then
                if shared.framework == 'esx' then
                    TriggerEvent('esx:removeInventoryItem', item.name, item.count)
                end

                if item.client?.remove then
                    item.client.remove(item.count)
                end
            elseif count > 0 then
                if shared.framework == 'esx' then
                    TriggerEvent('esx:addInventoryItem', item.name, item.count)
                end

                if item.client?.add then
                    item.client.add(item.count)
                end
            end
        end
	end

	client.setPlayerData('inventory', PlayerData.inventory)
	TriggerEvent('ox_inventory:updateInventory', changes)
end

RegisterNetEvent('ox_inventory:updateSlots', function(items, weights)
	if source ~= '' and next(items) then updateInventory(items, weights) end
end)

RegisterNetEvent('ox_inventory:inventoryReturned', function(data)
	if source == '' then return end
	if currentWeapon then currentWeapon = Weapon.Disarm(currentWeapon) end

	lib.notify({ description = locale('items_returned') })
	client.closeInventory()

	local num, items = 0, {}

	for _, slotData in pairs(data[1]) do
		num += 1
		items[num] = { item = slotData, inventory = cache.serverId }
	end

	updateInventory(items, data[3])
end)

RegisterNetEvent('ox_inventory:inventoryConfiscated', function(message)
	if source == '' then return end
	if message then lib.notify({ description = locale('items_confiscated') }) end
	if currentWeapon then currentWeapon = Weapon.Disarm(currentWeapon) end

	client.closeInventory()

	local num, items = 0, {}

	for slot in pairs(PlayerData.inventory) do
		num += 1
		items[num] = { item = { slot = slot }, inventory = cache.serverId }
	end

	updateInventory(items, 0)
end)


---@param point CPoint
local function nearbyDrop(point)
	if not point.instance or point.instance == currentInstance then
        DrawMarker(client.dropmarker.type, point.coords.x, point.coords.y, point.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, client.dropmarker.scale[1], client.dropmarker.scale[2], client.dropmarker.scale[3],
        ---@diagnostic disable-next-line: param-type-mismatch
        client.dropmarker.colour[1], client.dropmarker.colour[2], client.dropmarker.colour[3], 222, false, false, 0, true, false, false, false)
    end
end

---@param point CPoint
local function onEnterDrop(point)
	if not point.instance or point.instance == currentInstance and not point.entity then
		local model = point.model or client.dropmodel

        -- Prevent breaking inventory on invalid point.model instead use default client.dropmodel
        if not IsModelValid(model) and not IsModelInCdimage(model) then
            model = client.dropmodel
        end
		lib.requestModel(model)

		local entity = CreateObject(model, point.coords.x, point.coords.y, point.coords.z, false, true, true)

		SetModelAsNoLongerNeeded(model)
		PlaceObjectOnGroundProperly(entity)
		FreezeEntityPosition(entity, true)
		SetEntityCollision(entity, false, true)

		point.entity = entity
	end
end

local function onExitDrop(point)
	local entity = point.entity

	if entity then
		Utils.DeleteEntity(entity)
		point.entity = nil
	end
end

local function createDrop(dropId, data)
	local point = lib.points.new({
		coords = data.coords,
		distance = 16,
		invId = dropId,
		instance = data.instance,
		model = data.model
	})

	if point.model or client.dropprops then
		point.distance = 30
		point.onEnter = onEnterDrop
		point.onExit = onExitDrop
	else
		point.nearby = nearbyDrop
	end

	client.drops[dropId] = point
end

RegisterNetEvent('ox_inventory:createDrop', function(dropId, data, owner, slot)
	if client.drops then
		createDrop(dropId, data)
	end

	if owner == cache.serverId then
		if currentWeapon?.slot == slot then
			currentWeapon = Weapon.Disarm(currentWeapon)
		end

		if invOpen and #(GetEntityCoords(playerPed) - data.coords) <= 1 then
			if not cache.vehicle then
				client.openInventory('drop', dropId)
			else
				SendNUIMessage({
					action = 'setupInventory',
					data = { rightInventory = currentInventory }
				})
			end
		end
	end
end)

RegisterNetEvent('ox_inventory:removeDrop', function(dropId)
	if client.drops then
		local point = client.drops[dropId]

		if point then
			client.drops[dropId] = nil
			point:remove()

			if point.entity then Utils.DeleteEntity(point.entity) end
		end
	end
end)

---@type function?
local function setStateBagHandler(stateId)
	AddStateBagChangeHandler('invOpen', stateId, function(_, _, value)
		invOpen = value
	end)

	AddStateBagChangeHandler('invBusy', stateId, function(_, _, value)
		invBusy = value
	end)

    AddStateBagChangeHandler('canUseWeapons', stateId, function(_, _, value)
        if not value and currentWeapon then
            currentWeapon = Weapon.Disarm(currentWeapon)
        end
    end)

	AddStateBagChangeHandler('instance', stateId, function(_, _, value)
		currentInstance = value

		if client.drops then
			-- Iterate over known drops and remove any points in a different instance (ignoring no instance)
			for dropId, point in pairs(client.drops) do
				if point.instance then
					if point.instance ~= value then
						if point.entity then
							Utils.DeleteEntity(point.entity)
							point.entity = nil
						end

						point:remove()
					else
						-- Recreate the drop using data from the old point
						createDrop(dropId, point)
					end
				end
			end
		end
	end)

	AddStateBagChangeHandler('dead', stateId, function(_, _, value)
		Utils.WeaponWheel()
		PlayerData.dead = value
	end)

	AddStateBagChangeHandler('invHotkeys', stateId, function(_, _, value)
		invHotkeys = value
	end)

	setStateBagHandler = nil
end

RegisterNetEvent('txcl:heal', function()
    if source == '' then return end

    PlayerData.dead = false
end)

lib.onCache('seat', function(seat)
	if seat then
		local hasWeapon = GetCurrentPedVehicleWeapon(cache.ped)

		if hasWeapon then
			return Utils.WeaponWheel(true)
		end
	end

	Utils.WeaponWheel(false)
end)

lib.onCache('vehicle', function()
	if invOpen and (not currentInventory.entity or currentInventory.entity == cache.vehicle) then
		return client.closeInventory()
	end
end)

RegisterNetEvent('ox_inventory:setPlayerInventory', function(currentDrops, inventory, weight, player)
	if source == '' then return end

    ---@class PlayerData
    ---@field inventory table<number, SlotWithItem?>
    ---@field weight number
    ---@field groups table<string, number>
	PlayerData = player
	PlayerData.id = cache.playerId
	PlayerData.source = cache.serverId
    PlayerData.maxWeight = shared.playerweight

	setmetatable(PlayerData, {
		__index = function(self, key)
			if key == 'ped' then
				return PlayerPedId()
			end
		end
	})

	if setStateBagHandler then setStateBagHandler(('player:%s'):format(cache.serverId)) end

	local ItemData = table.create(0, #Items)

	for _, v in pairs(Items --[[@as table<string, OxClientItem>]]) do
		local buttons = v.buttons and {} or nil

		if buttons then
			for i = 1, #v.buttons do
				buttons[i] = {label = v.buttons[i].label, group = v.buttons[i].group}
			end
		end

		ItemData[v.name] = {
			label = v.label,
			stack = v.stack,
			close = v.close,
			count = 0,
			description = v.description,
			buttons = buttons,
			ammoName = v.ammoname,
			image = v.client?.image,
			-- Feeds the Tarkov-style multi-cell grid and the rarity tint. `grid`
			-- ({width, height}) and `rarity` are optional per-item overrides set in
			-- data/items.lua or data/weapons.lua; everything else is inferred from
			-- the item's own class/weight by the UI (web/src/helpers/itemMeta.ts).
			weight = v.weight,
			grid = v.grid,
			rarity = v.rarity,
			weapon = v.weapon or nil,
			ammo = v.ammo or nil,
			component = v.component or nil,
			tint = v.tint or nil
		}
	end

	for _, data in pairs(inventory) do
		local item = Items[data.name]

		if item then
			item.count += data.count
			ItemData[data.name].count += data.count
			local add = item.client?.add

			if add then
				add(item.count)
			end
		end
	end

	local phone = Items.phone

	if phone and phone.count < 1 then
		pcall(function()
			return exports.npwd:setPhoneDisabled(true)
		end)
	end

	client.setPlayerData('inventory', inventory)
	client.setPlayerData('weight', weight)
	currentWeapon = nil
	Weapon.ClearAll()

	local uiLocales = {}
	local locales = lib.getLocales()

	for k, v in pairs(locales) do
		if k:find('^ui_')then
			uiLocales[k] = v
		end
	end

	uiLocales['$'] = locales['$']
	uiLocales.ammo_type = locales.ammo_type

	client.drops = currentDrops

	for dropId, data in pairs(currentDrops) do
		createDrop(dropId, data)
	end

	local hasTextUi
	local uiOptions = { icon = 'fa-id-card' }

	---@param point CPoint
	local function nearbyLicense(point)
		---@diagnostic disable-next-line: param-type-mismatch
		DrawMarker(2, point.coords.x, point.coords.y, point.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 30, 150, 30, 222, false, false, 0, true, false, false, false)

		if point.isClosest and point.currentDistance < 1.2 then
			if not hasTextUi then
				hasTextUi = point
				lib.showTextUI(point.message, uiOptions)
			end

			if IsControlJustReleased(0, 38) then
				lib.callback('ox_inventory:buyLicense', 1000, function(success, message)
					if success ~= nil then
						lib.notify({
							id = message,
							type = success == false and 'error' or 'success',
							description = locale(message, locale('license', point.type:gsub("^%l", string.upper)))
						})
					end
				end, point.invId)
			end
		elseif hasTextUi == point then
			hasTextUi = false
			lib.hideTextUI()
		end
	end

	for id, data in pairs(lib.load('data.licenses') or {}) do
		lib.points.new({
			coords = data.coords,
			distance = 16,
			inv = 'license',
			type = data.name,
			price = data.price,
			invId = id,
			nearby = nearbyLicense,
			message = ('**%s**  \n%s'):format(locale('purchase_license', data.name), locale('interact_prompt', GetControlInstructionalButton(0, 38, true):sub(3)))
		})
	end

	-- Wait for the NUI to report ready, but never block forever: if the UI fails
	-- to load (e.g. a bad/partial resource download) we still finish setup so the
	-- inventory doesn't get stuck on "is busy" permanently.
	local uiWait = GetGameTimer() + 10000

	while not client.uiLoaded do
		Wait(50)
		if GetGameTimer() > uiWait then
			shared.warning('NUI did not report uiLoaded within 10s — continuing setup anyway')
			break
		end
	end

	SendNUIMessage({
		action = 'init',
		data = {
			locale = uiLocales,
			items = ItemData,
			leftInventory = {
				id = cache.playerId,
				slots = shared.playerslots,
				items = PlayerData.inventory,
				maxWeight = shared.playerweight,
			},
			imagepath = client.imagepath
		}
	})

	PlayerData.loaded = true

	if not client.disablesetupnotification then
		lib.notify({ description = locale('inventory_setup') })
	end

	Shops.refreshShops()
	Inventory.Stashes()
	Inventory.Evidence()

	if registerCommands then registerCommands() end

	TriggerEvent('ox_inventory:updateInventory', PlayerData.inventory)

	client.interval = SetInterval(function()
        local canSteal = canOpenTarget(playerPed)

        if canSteal ~= client.player:get('canSteal') then
            client.player:setr('canSteal', canSteal)
        end

		if invOpen == false then
			playerCoords = GetEntityCoords(playerPed)

			if currentWeapon and IsPedUsingActionMode(playerPed) then
				SetPedUsingActionMode(playerPed, false, -1, 'DEFAULT_ACTION')
			end

		elseif invOpen == true then
			if not canOpenInventory() then
				client.closeInventory()
			else
				playerCoords = GetEntityCoords(playerPed)

				if not currentInventory.ignoreSecurityChecks then
                    local maxDistance = (currentInventory.distance or currentInventory.type == 'stash' and 4.8 or 1.8) + 0.2

					if currentInventory.type == 'otherplayer' then
						local id = GetPlayerFromServerId(currentInventory.id --[[@as number]])
						local ped = GetPlayerPed(id)
						local pedCoords = GetEntityCoords(ped)

						if not id or #(playerCoords - pedCoords) > maxDistance or (not client.hasGroup(shared.police) and not Player(currentInventory.id).state.canSteal) then
							client.closeInventory()
							lib.notify({ id = 'inventory_lost_access', type = 'error', description = locale('inventory_lost_access') })
						else
							TaskTurnPedToFaceCoord(playerPed, pedCoords.x, pedCoords.y, pedCoords.z, 50)
						end

					elseif currentInventory.coords and (#(playerCoords - currentInventory.coords) > maxDistance or canSteal) then
						client.closeInventory()
						lib.notify({ id = 'inventory_lost_access', type = 'error', description = locale('inventory_lost_access') })
					end
				end
			end
		end

		if client.parachute and GetPedParachuteState(playerPed) ~= -1 then
			Utils.DeleteEntity(client.parachute[1])
			client.parachute = false
		end

		if EnableWeaponWheel then return end

		local weaponHash = GetSelectedPedWeapon(playerPed)

		if currentWeapon then
			if weaponHash ~= currentWeapon.hash and currentWeapon.timer then
				local weaponCount = Items[currentWeapon.name]?.count

				if weaponCount > 0 then
					SetCurrentPedWeapon(playerPed, currentWeapon.hash, true)
					SetAmmoInClip(playerPed, currentWeapon.hash, currentWeapon.metadata.ammo)
					SetPedCurrentWeaponVisible(playerPed, true, false, false, false)

					weaponHash = GetSelectedPedWeapon(playerPed)
				end

				if weaponHash ~= currentWeapon.hash then
                    lib.print.info(('%s was forcibly unequipped (caused by game behaviour or another resource)'):format(currentWeapon.name))
					currentWeapon = Weapon.Disarm(currentWeapon, true)
				end
			end
		elseif client.weaponmismatch and not client.ignoreweapons[weaponHash] then
			local weaponType = GetWeapontypeGroup(weaponHash)

			if weaponType ~= 0 and weaponType ~= `GROUP_UNARMED` then
				Weapon.Disarm(currentWeapon, true)
			end
		end
	end, 200)

	local playerId = cache.playerId
	local EnableKeys = client.enablekeys
	local DisablePlayerVehicleRewards = DisablePlayerVehicleRewards
	local DisableAllControlActions = DisableAllControlActions
	local HideHudAndRadarThisFrame = HideHudAndRadarThisFrame
	local EnableControlAction = EnableControlAction
	local DisablePlayerFiring = DisablePlayerFiring
	local HudWeaponWheelIgnoreSelection = HudWeaponWheelIgnoreSelection
	local DisableControlAction = DisableControlAction
	local IsPedShooting = IsPedShooting
	local IsControlJustReleased = IsControlJustReleased

	client.tick = SetInterval(function()
		DisablePlayerVehicleRewards(playerId)

		if invOpen then
			DisableAllControlActions(0)
			HideHudAndRadarThisFrame()

			for i = 1, #EnableKeys do
				EnableControlAction(0, EnableKeys[i], true)
			end

			if currentInventory.type == 'drop' or currentInventory.type == 'newdrop' then
				EnableControlAction(0, 30, true)
				EnableControlAction(0, 31, true)
			end
		else
			if invBusy then
				DisableControlAction(0, 23, true)
				DisableControlAction(0, 36, true)
			end

			if usingItem or invOpen or IsPedCuffed(playerPed) then
				DisablePlayerFiring(playerId, true)
			end

			if not EnableWeaponWheel then
				HudWeaponWheelIgnoreSelection()
				DisableControlAction(0, 37, true)
			end

			if currentWeapon and currentWeapon.timer then
				DisableControlAction(0, 80, true)
				DisableControlAction(0, 140, true)

				if currentWeapon.metadata.durability <= 0 or not currentWeapon.timer then
					DisablePlayerFiring(playerId, true)
				elseif client.aimedfiring and not currentWeapon.melee and currentWeapon.group ~= `GROUP_PETROLCAN` and not IsPlayerFreeAiming(playerId) then
					DisablePlayerFiring(playerId, true)
				end

				local weaponAmmo = currentWeapon.metadata.ammo

				if not invBusy and currentWeapon.timer ~= 0 and currentWeapon.timer < GetGameTimer() then
					currentWeapon.timer = 0

					if weaponAmmo then
						TriggerServerEvent('ox_inventory:updateWeapon', 'ammo', weaponAmmo)

						if client.autoreload and currentWeapon.ammo and GetAmmoInPedWeapon(playerPed, currentWeapon.hash) == 0 then
							local slotId = Inventory.GetSlotIdWithItem(currentWeapon.ammo, { type = currentWeapon.metadata.specialAmmo }, false)

							if slotId then
								CreateThread(function() useSlot(slotId) end)
							end
						end

					elseif currentWeapon.metadata.durability then
						TriggerServerEvent('ox_inventory:updateWeapon', 'melee', currentWeapon.melee)
						currentWeapon.melee = 0
					end
				elseif weaponAmmo then
					if IsPedShooting(playerPed) then
						local currentAmmo
						local durabilityDrain = Items[currentWeapon.name].durability

						if currentWeapon.group == `GROUP_PETROLCAN` or currentWeapon.group == `GROUP_FIREEXTINGUISHER` then
							currentAmmo = weaponAmmo - durabilityDrain < 0 and 0 or weaponAmmo - durabilityDrain
							currentWeapon.metadata.durability = currentAmmo
							currentWeapon.metadata.ammo = (weaponAmmo < currentAmmo) and 0 or currentAmmo

							if currentAmmo <= 0 then
								SetPedInfiniteAmmo(playerPed, false, currentWeapon.hash)
							end
						else
							currentAmmo = GetAmmoInPedWeapon(playerPed, currentWeapon.hash)

							if currentAmmo < weaponAmmo then
								currentAmmo = (weaponAmmo < currentAmmo) and 0 or currentAmmo
								currentWeapon.metadata.ammo = currentAmmo
								currentWeapon.metadata.durability = currentWeapon.metadata.durability - (durabilityDrain * math.abs((weaponAmmo or 0.1) - currentAmmo))
							end
						end

						if currentAmmo <= 0 then
							if cache.vehicle then
								TaskSwapWeapon(playerPed, true)
							end

							currentWeapon.timer = GetGameTimer() + 200
						else currentWeapon.timer = GetGameTimer() + (GetWeaponTimeBetweenShots(currentWeapon.hash) * 1000) + 100 end
					end
				elseif currentWeapon.throwable then
					if not invBusy and IsControlPressed(0, 24) then
						invBusy = 1

						CreateThread(function()
							local weapon = currentWeapon

							while currentWeapon and (not IsPedWeaponReadyToShoot(cache.ped) or IsDisabledControlPressed(0, 24)) and GetSelectedPedWeapon(playerPed) == weapon.hash do
								Wait(0)
							end

							if GetSelectedPedWeapon(playerPed) == weapon.hash then Wait(700) end

							while IsPedPlantingBomb(playerPed) do Wait(0) end

							TriggerServerEvent('ox_inventory:updateWeapon', 'throw', nil, weapon.slot)
							client.player:setr('invBusy', false)

							currentWeapon = nil

							RemoveWeaponFromPed(playerPed, weapon.hash)
							TriggerEvent('ox_inventory:currentWeapon')
						end)
					end
				elseif currentWeapon.melee and IsControlJustReleased(0, 24) and IsPedPerformingMeleeAction(playerPed) then
					currentWeapon.melee += 1
					currentWeapon.timer = GetGameTimer() + 200
				end
			end
		end
	end)

	client.player:setr('invBusy', false)
	client.player:set('invOpen', false)
	client.player:set('invHotkeys', true)
	client.player:set('canUseWeapons', true)
	collectgarbage('collect')
end)

AddEventHandler('onResourceStop', function(resourceName)
	if shared.resource == resourceName then
		client.onLogout()
	end
end)

RegisterNetEvent('ox_inventory:viewInventory', function(left, right)
	if source == '' then return end

	client.player:set('invOpen', true)
	SetInterval(client.interval, 100)
	SetNuiFocus(true, true)
	SetNuiFocusKeepInput(true)
	closeTrunk()

	if client.screenblur then Utils.blurIn() end

	currentInventory = right or defaultInventory
	currentInventory.ignoreSecurityChecks = true
    currentInventory.type = 'inspect'
	left.items = PlayerData.inventory
	left.groups = PlayerData.groups

	SendNUIMessage({
		action = 'setupInventory',
		data = {
			leftInventory = left,
			rightInventory = currentInventory
		}
	})
end)

RegisterNUICallback('uiLoaded', function(_, cb)
	client.uiLoaded = true
	cb(1)

	-- Tell the UI whether we may administer the look, and push the server-wide
	-- theme (if an admin has set one) before anything is drawn.
	UiTheme.Init()
end)

RegisterNUICallback('getItemData', function(itemName, cb)
	cb(Items[itemName])
end)

RegisterNUICallback('removeComponent', function(data, cb)
	cb(1)

	if not currentWeapon then
		return TriggerServerEvent('ox_inventory:updateWeapon', 'component', data)
	end

	if data.slot ~= currentWeapon.slot then
		return lib.notify({ id = 'weapon_hand_wrong', type = 'error', description = locale('weapon_hand_wrong') })
	end

	local itemSlot = PlayerData.inventory[currentWeapon.slot]

    if not itemSlot then return end

	for _, component in pairs(Items[data.component].client.component) do
		if HasPedGotWeaponComponent(playerPed, currentWeapon.hash, component) then
			for k, v in pairs(itemSlot.metadata.components) do
				if v == data.component then
					local success = lib.callback.await('ox_inventory:updateWeapon', false, 'component', k)

					if success then
						RemoveWeaponComponentFromPed(playerPed, currentWeapon.hash, component)
						TriggerEvent('ox_inventory:updateWeaponComponent', 'removed', component, data.component)
					end

					break
				end
			end
		end
	end
end)

RegisterNUICallback('removeAmmo', function(slot, cb)
	cb(1)
	local slotData = PlayerData.inventory[slot]

	if not slotData or not slotData.metadata.ammo or slotData.metadata.ammo == 0 then return end

	local success = lib.callback.await('ox_inventory:removeAmmoFromWeapon', false, slot)

	if success and slot == currentWeapon?.slot then
		SetPedAmmo(playerPed, currentWeapon.hash, 0)
	end
end)

RegisterNUICallback('useItem', function(slot, cb)
	useSlot(slot --[[@as number]])
	cb(1)
end)

local function giveItemToTarget(serverId, slotId, count)
    if type(slotId) ~= 'number' then return TypeError('slotId', 'number', type(slotId)) end
    if count and type(count) ~= 'number' then return TypeError('count', 'number', type(count)) end

    if slotId == currentWeapon?.slot then
        currentWeapon = Weapon.Disarm(currentWeapon)
    end

    Utils.PlayAnim(0, 'mp_common', 'givetake1_a', 1.0, 1.0, 2000, 50, 0.0, 0, 0, 0)

    local notification = lib.callback.await('ox_inventory:giveItem', false, slotId, serverId, count or 0)

    if notification then
        lib.notify({ type = 'error', description = locale(table.unpack(notification)) })
    end
end

exports('giveItemToTarget', giveItemToTarget)

local function isGiveTargetValid(ped, coords)
    if cache.vehicle and GetVehiclePedIsIn(ped, false) == cache.vehicle then
        return true
    end

    local entity = Utils.Raycast(1|4|8|16, coords + vec3(0, 0, 0.5), 0.2)

    return entity == ped and IsEntityVisible(ped)
end

RegisterNUICallback('giveItem', function(data, cb)
	cb(1)

    if usingItem then return end

	if client.giveplayerlist then
		local coords = cache.vehicle and GetWorldPositionOfEntityBone(playerPed, 0) or GetEntityCoords(playerPed)

		local nearbyPlayers = lib.getNearbyPlayers(coords, 3.0)
        local nearbyCount = #nearbyPlayers

		if nearbyCount == 0 then return end

        if nearbyCount == 1 then
			local option = nearbyPlayers[1]

            if not isGiveTargetValid(option.ped, option.coords) then return end

            return giveItemToTarget(GetPlayerServerId(option.id), data.slot, data.count)
        end

        local giveList, n = {}, 0

		for i = 1, #nearbyPlayers do
			local option = nearbyPlayers[i]

            if isGiveTargetValid(option.ped, option.coords) then
				local playerName = Utils.getPlayerName(option.id)
				option.id = GetPlayerServerId(option.id)
                ---@diagnostic disable-next-line: inject-field
				option.label = playerName
				n += 1
				giveList[n] = option
			end
		end

        if n == 0 then return end

		lib.registerMenu({
			id = 'ox_inventory:givePlayerList',
			title = 'Give item',
			options = giveList,
		}, function(selected)
            giveItemToTarget(giveList[selected].id, data.slot, data.count)
        end)

		return lib.showMenu('ox_inventory:givePlayerList')
	end

    if cache.vehicle then
		local seats = GetVehicleMaxNumberOfPassengers(cache.vehicle) - 1

		if seats >= 0 then
			local passenger = GetPedInVehicleSeat(cache.vehicle, cache.seat - 2 * (cache.seat % 2) + 1)

			if passenger ~= 0 and IsEntityVisible(passenger) then
                return giveItemToTarget(GetPlayerServerId(NetworkGetPlayerIndexFromPed(passenger)), data.slot, data.count)
			end
		end

        return
	end

    local entity = Utils.Raycast(1|2|4|8|16, GetOffsetFromEntityInWorldCoords(cache.ped, 0.0, 3.0, 0.5), 0.2)

    if entity and IsPedAPlayer(entity) and IsEntityVisible(entity) and #(GetEntityCoords(playerPed, true) - GetEntityCoords(entity, true)) < 3.0 then
        return giveItemToTarget(GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity)), data.slot, data.count)
    end
end)

-- Returns nearby give targets (server id + display name) for the UI submenu.
-- Lists EVERY player inside the radius (no line-of-sight raycast) so the player
-- can pick whoever they want from the dropdown, not just who they're facing.
RegisterNUICallback('getNearbyPlayers', function(_, cb)
	local coords = cache.vehicle and GetWorldPositionOfEntityBone(playerPed, 0) or GetEntityCoords(playerPed)
	local nearbyPlayers = lib.getNearbyPlayers(coords, 3.0)
	local list, n = {}, 0

	for i = 1, #nearbyPlayers do
		local option = nearbyPlayers[i]

		n += 1
		list[n] = {
			id = GetPlayerServerId(option.id),
			label = Utils.getPlayerName(option.id),
		}
	end

	cb(list)
end)

-- Give a specific item slot to a chosen nearby player (by server id), from the UI dropdown.
RegisterNUICallback('giveItemToPlayer', function(data, cb)
	cb(1)

	if usingItem or type(data.serverId) ~= 'number' or type(data.slot) ~= 'number' then return end

	giveItemToTarget(data.serverId, data.slot, data.count or 0)
end)

RegisterNUICallback('useButton', function(data, cb)
	useButton(data.id, data.slot)
	cb(1)
end)

RegisterNUICallback('exit', function(_, cb)
	client.closeInventory()
	cb(1)
end)

-- ──────────────────────────────────────────────────────────────
--  Admin stash manager (/oxinventory) + in-world placement editor
-- ──────────────────────────────────────────────────────────────

local stashAdminOpen = false

local function openStashAdmin()
	local data = lib.callback.await('ox_inventory:getStashAdminData', false)

	if not data or not data.allowed then
		return lib.notify({ type = 'error', description = 'You are not allowed to use this command.' })
	end

	stashAdminOpen = true
	SetNuiFocus(true, true)
	SetNuiFocusKeepInput(false)

	SendNUIMessage({
		action = 'openStashAdmin',
		data = {
			stashes = data.stashes or {},
			jobs = data.jobs or {},
		}
	})
end

local function closeStashAdmin()
	stashAdminOpen = false
	SetNuiFocus(false, false)
	SetNuiFocusKeepInput(false)
	SendNUIMessage({ action = 'closeStashAdmin' })
end

RegisterCommand('oxinventory', function()
	if stashAdminOpen then return end
	openStashAdmin()
end, false)

-- /greenscreen — toggle a pure chroma-green backdrop behind the inventory, for
-- screenshotting item icons. The green only shows while the inventory NUI is on
-- screen (i.e. the inventory is open), so open the inventory to see it.
local greenscreenOn = false

RegisterCommand('greenscreen', function()
	greenscreenOn = not greenscreenOn

	SendNUIMessage({
		action = 'toggleGreenscreen',
		data = { state = greenscreenOn },
	})

	lib.notify({
		type = greenscreenOn and 'success' or 'inform',
		description = ('Greenscreen %s'):format(greenscreenOn and 'enabled' or 'disabled'),
	})
end, false)

RegisterNUICallback('closeStashAdmin', function(_, cb)
	closeStashAdmin()
	cb(1)
end)

-- Returns the player's current position + heading for quick zone placement.
RegisterNUICallback('stashCurrentPosition', function(_, cb)
	local coords = GetEntityCoords(cache.ped)
	cb({
		x = math.floor(coords.x * 100) / 100,
		y = math.floor(coords.y * 100) / 100,
		z = math.floor(coords.z * 100) / 100,
		heading = math.floor(GetEntityHeading(cache.ped) * 100) / 100,
	})
end)

-- In-world placement. Two modes:
--   • follow  (no prop): a marker tracks the player; Confirm captures the
--                        player's current position + heading.
--   • prop    : a draggable preview — W/A/S/D move, R/F height, Q/E rotate.
--               When repositioning, it starts from the prop's saved coords.
-- Confirm/cancel come from the keyboard OR the themed NUI control bar buttons.
local placementActive = false
local placementAction = nil -- nil | 'confirm' | 'cancel'

local function runPlacementEditor(opts)
	if placementActive then return nil end
	placementActive = true
	placementAction = nil

	local isProp = opts and opts.prop
	local isPed = isProp and opts.ped
	-- Peds are spawned by their feet, props by their centre. The final shop ped is
	-- created at `z - 1.0` (see modules/customshop/client.lua), so the preview ped
	-- is displayed with the same offset while the LOGICAL coords we store stay the
	-- prop-centre height — otherwise the offset would compound and the ped sink.
	local zOffset = isPed and -1.0 or 0.0
	local mode = isProp and 'prop' or 'follow'

	-- Hide the admin panel, show the themed control bar.
	SendNUIMessage({ action = 'hideStashAdminPanel' })
	SendNUIMessage({ action = 'showPlacementBar', data = { mode = mode } })
	SetNuiFocus(true, true)
	SetNuiFocusKeepInput(true)

	local ped = cache.ped
	local model = isProp and joaat(opts.model or 'prop_drop_crate_01') or nil
	local preview

	-- Remove the already-spawned real prop for this entry so we don't end up with
	-- two props while editing; it's rebuilt at the final position after saving.
	if isProp and opts.name then
		if opts.kind == 'craft' then
			exports.ox_inventory:hideCustomCraftProp(opts.name)
		elseif opts.kind == 'shop' then
			exports.ox_inventory:hideCustomShopProp(opts.name)
		else
			exports.ox_inventory:hideCustomStashProp(opts.name)
		end
	end

	-- Starting transform: reposition starts from existing coords, otherwise in
	-- front of the player.
	local x, y, z, heading
	if isProp and opts.coords then
		x, y, z = opts.coords.x + 0.0, opts.coords.y + 0.0, opts.coords.z + 0.0
		heading = (opts.rotation and opts.rotation.z) or GetEntityHeading(ped)
	else
		local base = GetEntityCoords(ped)
		local fwd = GetEntityForwardVector(ped)
		x, y, z = base.x + fwd.x * 1.5, base.y + fwd.y * 1.5, base.z
		heading = GetEntityHeading(ped)
	end

	if isProp then
		lib.requestModel(model, 5000)
		if isPed then
			-- CreatePed so a ped model actually renders (CreateObject with a ped
			-- model spawns nothing — this is why the NPC preview was invisible).
			preview = CreatePed(0, model, x, y, z + zOffset, heading, false, false)
			SetBlockingOfNonTemporaryEvents(preview, true)
			SetEntityInvincible(preview, true)
		else
			preview = CreateObject(model, x, y, z, false, false, false)
		end
		SetEntityCoordsNoOffset(preview, x, y, z + zOffset, false, false, false)
		SetEntityAlpha(preview, 200, false)
		SetEntityCollision(preview, false, false)
		FreezeEntityPosition(preview, true)
		SetEntityHeading(preview, heading)
	end

	local step = 0.05
	local result = nil

	-- Hard safety timeout: never let the editor trap the player forever.
	local deadline = GetGameTimer() + 180000 -- 3 minutes

	while placementActive do
		Wait(0)

		-- Bail out if the admin UI was closed or we've been here too long.
		if not stashAdminOpen or GetGameTimer() > deadline then
			placementActive = false
			break
		end

		DisableAllControlActions(0)
		EnableControlAction(0, 1, true)  -- look LR
		EnableControlAction(0, 2, true)  -- look UD

		if mode == 'prop' then
			local fast = IsDisabledControlPressed(0, 21) -- shift
			local s = fast and step * 4 or step
			local rot = fast and 4.0 or 1.0
			local rad = math.rad(heading)
			local fx, fy = -math.sin(rad), math.cos(rad) -- forward
			local rx, ry = math.cos(rad), math.sin(rad)  -- right

			if IsDisabledControlPressed(0, 32) then x, y = x + fx * s, y + fy * s end -- W
			if IsDisabledControlPressed(0, 33) then x, y = x - fx * s, y - fy * s end -- S
			if IsDisabledControlPressed(0, 34) then x, y = x - rx * s, y - ry * s end -- A
			if IsDisabledControlPressed(0, 35) then x, y = x + rx * s, y + ry * s end -- D
			if IsDisabledControlPressed(0, 45) then z = z + s end -- R (up)
			if IsDisabledControlPressed(0, 23) then z = z - s end -- F (down)
			if IsDisabledControlPressed(0, 44) then heading = (heading + rot) % 360 end -- Q
			if IsDisabledControlPressed(0, 38) then heading = (heading - rot) % 360 end -- E

			if DoesEntityExist(preview) then
				SetEntityCoordsNoOffset(preview, x, y, z + zOffset, false, false, false)
				SetEntityHeading(preview, heading)
			end
		else
			-- follow mode: track the player so Confirm uses their exact spot
			local pc = GetEntityCoords(ped)
			x, y, z = pc.x, pc.y, pc.z
			heading = GetEntityHeading(ped)
			DrawMarker(1, x, y, z - 0.98, 0, 0, 0, 0, 0, heading, 1.5, 1.5, 1.0,
				31, 94, 255, 110, false, false, 0, true, false, false, false)
		end

		local confirm = placementAction == 'confirm' or IsDisabledControlJustReleased(0, 191) or IsDisabledControlJustReleased(0, 201)
		local cancel = placementAction == 'cancel' or IsDisabledControlJustReleased(0, 200) -- Esc

		if confirm then
			-- Read the preview's actual transform so the saved coords match the
			-- crate exactly (3 decimals, no aggressive rounding).
			local fx, fy, fz, fh = x, y, z, heading

			if mode == 'prop' and DoesEntityExist(preview) then
				local pc = GetEntityCoords(preview)
				-- Subtract the ped display offset so the STORED coords are the logical
				-- (prop-centre) height; the final ped spawn re-applies its own -1.0.
				fx, fy, fz = pc.x, pc.y, pc.z - zOffset
				fh = GetEntityHeading(preview)
			end

			local r3 = function(n) return math.floor(n * 1000 + 0.5) / 1000 end

			result = {
				coords = { x = r3(fx), y = r3(fy), z = r3(fz) },
				heading = r3(fh),
				size = { x = 1.5, y = 1.5, z = 2.0 },
				rotation = { x = 0.0, y = 0.0, z = r3(fh) },
			}
			placementActive = false
		elseif cancel then
			placementActive = false
		end
	end

	placementAction = nil

	if preview and DoesEntityExist(preview) then DeleteEntity(preview) end
	if model then SetModelAsNoLongerNeeded(model) end

	-- If editing was cancelled (no result) we hid the real prop earlier — ask the
	-- server to resync so it respawns at its previous position.
	if not result and isProp and opts.name then
		local resyncEvent = opts.kind == 'craft' and 'ox_inventory:requestCustomCraft'
			or opts.kind == 'shop' and 'ox_inventory:requestCustomShops'
			or 'ox_inventory:requestCustomStashes'
		TriggerServerEvent(resyncEvent)
	end

	-- bring the admin panel back
	SendNUIMessage({ action = 'closePlacementBar' })
	SendNUIMessage({ action = 'showStashAdminPanel' })

	if stashAdminOpen then
		SetNuiFocus(true, true)
		SetNuiFocusKeepInput(false)
	end

	return result
end

RegisterNUICallback('stashPlacementEditor', function(data, cb)
	cb(1)
	CreateThread(function()
		local result = runPlacementEditor(data)
		SendNUIMessage({ action = 'stashPlacementResult', data = result })
	end)
end)

-- Confirm / cancel coming from the NUI control bar buttons.
RegisterNUICallback('stashPlacementAction', function(data, cb)
	if placementActive then placementAction = data.action end
	cb(1)
end)

-- Safety: force-cancel the placement editor / admin and release NUI focus if the
-- player ever gets stuck (e.g. the panel closed mid-placement). Restores control
-- without needing to rejoin.
local function forceReleaseAdmin()
	placementAction = 'cancel'
	placementActive = false
	stashAdminOpen = false
	SetNuiFocus(false, false)
	SetNuiFocusKeepInput(false)
	SendNUIMessage({ action = 'closePlacementBar' })
	SendNUIMessage({ action = 'closeStashAdmin' })
	if CustomAppearance and CustomAppearance.StopPreview then CustomAppearance.StopPreview() end
end

RegisterCommand('oxinv_unstuck', function()
	forceReleaseAdmin()

	-- Also clear the inventory "busy/open" state in case setup got stuck (e.g. the
	-- NUI never reported ready), which is what causes the permanent "is busy".
	invBusy = false
	invOpen = false
	if client.player then
		client.player:setr('invBusy', false)
		client.player:set('invOpen', false)
		client.player:set('canUseWeapons', true)
	end

	lib.notify({ type = 'success', description = 'Inventory control released.' })
end, false)

RegisterNUICallback('saveCustomStash', function(data, cb)
	local result = lib.callback.await('ox_inventory:saveCustomStash', false, data)
	cb(result or { ok = false })
end)

RegisterNUICallback('deleteCustomStash', function(data, cb)
	local result = lib.callback.await('ox_inventory:deleteCustomStash', false, data.name)
	cb(result or { ok = false })
end)

-- Crafting admin bridges (NUI → server callback).
RegisterNUICallback('getCraftAdminData', function(_, cb)
	local result = lib.callback.await('ox_inventory:getCraftAdminData', false)
	cb(result or { allowed = false })
end)

RegisterNUICallback('saveCustomCraft', function(data, cb)
	local result = lib.callback.await('ox_inventory:saveCustomCraft', false, data)
	cb(result or { ok = false })
end)

RegisterNUICallback('deleteCustomCraft', function(data, cb)
	local result = lib.callback.await('ox_inventory:deleteCustomCraft', false, data.id)
	cb(result or { ok = false })
end)

-- Shop admin bridges (NUI → server callback).
RegisterNUICallback('getShopAdminData', function(_, cb)
	local result = lib.callback.await('ox_inventory:getShopAdminData', false)
	cb(result or { allowed = false })
end)

RegisterNUICallback('saveCustomShop', function(data, cb)
	local result = lib.callback.await('ox_inventory:saveCustomShop', false, data)
	cb(result or { ok = false })
end)

RegisterNUICallback('deleteCustomShop', function(data, cb)
	local result = lib.callback.await('ox_inventory:deleteCustomShop', false, data.id)
	cb(result or { ok = false })
end)

-- Appearance (marker / blip) admin bridges.
RegisterNUICallback('getAppearance', function(_, cb)
	local result = lib.callback.await('ox_inventory:getAppearance', false)
	cb(result or { allowed = false })
end)

RegisterNUICallback('saveAppearance', function(data, cb)
	local result = lib.callback.await('ox_inventory:saveAppearance', false, data)
	cb(result or { ok = false })
end)

-- Live marker preview while editing the Settings panel. The panel stays open
-- (docked to one side via the NUI) and keeps mouse focus so the sliders remain
-- usable; the marker is drawn in the world beside it and updates live.
RegisterNUICallback('appearancePreviewStart', function(data, cb)
	cb(1)
	SendNUIMessage({ action = 'markerPreviewOn' })
	CustomAppearance.StartPreview(data and data.marker)
end)

RegisterNUICallback('appearancePreviewUpdate', function(data, cb)
	cb(1)
	CustomAppearance.UpdatePreview(data and data.marker)
end)

RegisterNUICallback('appearancePreviewStop', function(_, cb)
	cb(1)
	CustomAppearance.StopPreview()
	SendNUIMessage({ action = 'markerPreviewOff' })
end)

lib.callback.register('ox_inventory:startCrafting', function(id, recipe)
	recipe = CraftingBenches[id].items[recipe]

	return lib.progressCircle({
		label = locale('crafting_item', recipe.metadata?.label or Items[recipe.name].label),
		duration = recipe.duration or 3000,
		canCancel = true,
		disable = {
			move = true,
			combat = true,
		},
		anim = {
			dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
			clip = 'machinic_loop_mechandplayer',
		}
	})
end)

local swapActive = false

---Synchronise and validate all item movement between the NUI and server.
RegisterNUICallback('swapItems', function(data, cb)
    if swapActive or not invOpen or invBusy or usingItem then return cb(false) end

    swapActive = true

	if data.toType == 'newdrop' then
		if cache.vehicle or IsPedFalling(playerPed) then
			swapActive = false
			return cb(false)
		end

		local coords = GetEntityCoords(playerPed)

		if IsEntityInWater(playerPed) then
			local destination = vec3(coords.x, coords.y, -200)
			local handle = StartShapeTestLosProbe(coords.x, coords.y, coords.z, destination.x, destination.y, destination.z, 511, cache.ped, 4)

			while true do
				Wait(0)
				local retval, hit, endCoords = GetShapeTestResult(handle)

				if retval ~= 1 then
					if not hit then return end

					data.coords = vec3(endCoords.x, endCoords.y, endCoords.z + 1.0)

					break
				end
			end
		else
			data.coords = coords
		end
    end

	if currentInstance then
		data.instance = currentInstance
	end

	if currentWeapon and data.fromType ~= data.toType then
		if (data.fromType == 'player' and data.fromSlot == currentWeapon.slot) or (data.toType == 'player' and data.toSlot == currentWeapon.slot) then
			currentWeapon = Weapon.Disarm(currentWeapon, true)
		end
	end

	local success, response, weaponSlot = lib.callback.await('ox_inventory:swapItems', false, data)
    swapActive = false

	cb(success or false)

	if success then
        if weaponSlot and currentWeapon then
            currentWeapon.slot = weaponSlot
        end

		if response then
			updateInventory(response.items, response.weight)
		end
	elseif response then
		if type(response) == 'table' then
			SendNUIMessage({ action = 'refreshSlots', data = { items = response } })
		else
			lib.notify({ type = 'error', description = locale(response) })
		end
	end
end)

RegisterNUICallback('buyItem', function(data, cb)
	---@type boolean, false | { [1]: number, [2]: SlotWithItem, [3]: SlotWithItem | false, [4]: number}, NotifyProps
	local response, data, message = lib.callback.await('ox_inventory:buyItem', 100, data)

	if data then
		updateInventory({
			{
				item = data[2],
				inventory = cache.serverId
			}
		}, data[4])

		if data[3] then
			SendNUIMessage({
				action = 'refreshSlots',
				data = {
					items = {
						{
							item = data[3],
							inventory = 'shop'
						}
					}
				}
			})
		end
	end

	if message then
		lib.notify(message)
	end

	cb(response)
end)

RegisterNUICallback('craftItem', function(data, cb)
	cb(true)

	local id, index = currentInventory.id, currentInventory.index

	for i = 1, data.count do
		local success, response = lib.callback.await('ox_inventory:craftItem', 200, id, index, data.fromSlot, data.toSlot)

		if not success then
			if response then lib.notify({ type = 'error', description = locale(response or 'cannot_perform') }) end
			break
		end
	end

	if currentInventory.type ~= 'crafting' then
		client.openInventory('crafting', { id = id, index = index })
	end
end)

lib.callback.register('ox_inventory:getVehicleData', function(netid)
	local entity = NetworkGetEntityFromNetworkId(netid)

	if entity then
		return GetEntityModel(entity), GetVehicleClass(entity)
	end
end)

-- ============================================================
--  PLAYER STATUS HUD (health / armour / hunger / thirst)
--  Hunger & thirst read from esx_status; pushed to the NUI on a
--  light 1s loop while the inventory is open. Safe no-op if
--  esx_status is absent (hunger/thirst stay at 100).
-- ============================================================
local statusCache = { hunger = 100.0, thirst = 100.0 }

AddEventHandler('esx_status:onTick', function(data)
	if type(data) ~= 'table' then return end
	for i = 1, #data do
		local st = data[i]
		if st and st.name and st.val then
			local pct = st.val / 10000.0
			if st.name == 'hunger' then
				statusCache.hunger = pct
			elseif st.name == 'thirst' then
				statusCache.thirst = pct
			end
		end
	end
end)

local function pushPlayerStatus()
	local ped = PlayerPedId()
	if not ped or ped == 0 then return end

	local hp = GetEntityHealth(ped) - 100
	if hp < 0 then hp = 0 elseif hp > 100 then hp = 100 end

	SendNUIMessage({
		action = 'setPlayerStatus',
		data = {
			health = hp,
			armour = GetPedArmour(ped),
			hunger = math.floor(statusCache.hunger + 0.5),
			thirst = math.floor(statusCache.thirst + 0.5),
		}
	})
end

-- Weather hash → { icon category, rough temperature } for the top-nav chip.
local WEATHER_MAP = {}
for name, info in pairs({
	EXTRASUNNY = { cat = 'clear', temp = 31 },
	CLEAR = { cat = 'clear', temp = 27 },
	NEUTRAL = { cat = 'clear', temp = 24 },
	SMOG = { cat = 'fog', temp = 22 },
	FOGGY = { cat = 'fog', temp = 16 },
	OVERCAST = { cat = 'clouds', temp = 19 },
	CLOUDS = { cat = 'clouds', temp = 21 },
	CLEARING = { cat = 'clouds', temp = 18 },
	RAIN = { cat = 'rain', temp = 14 },
	THUNDER = { cat = 'thunder', temp = 13 },
	SNOW = { cat = 'snow', temp = 1 },
	BLIZZARD = { cat = 'snow', temp = -4 },
	SNOWLIGHT = { cat = 'snow', temp = 2 },
	XMAS = { cat = 'snow', temp = 0 },
	HALLOWEEN = { cat = 'fog', temp = 15 },
}) do
	WEATHER_MAP[GetHashKey(name)] = info
end

local function pushWorldInfo()
	local ped = PlayerPedId()
	if not ped or ped == 0 then return end

	local coords = GetEntityCoords(ped)
	local zone = GetLabelText(GetNameOfZone(coords.x, coords.y, coords.z))
	if not zone or zone == '' or zone == 'NULL' then
		zone = GetStreetNameFromHashKey(GetStreetNameAtCoord(coords.x, coords.y, coords.z)) or ''
	end

	local w = WEATHER_MAP[GetNextWeatherTypeHashName()] or { cat = 'clear', temp = 23 }

	SendNUIMessage({
		action = 'setWorld',
		data = { zone = zone, weather = w.cat, temp = w.temp }
	})
end

CreateThread(function()
	local wasOpen = false
	while true do
		if LocalPlayer.state.invOpen then
			pushPlayerStatus()
			pushWorldInfo()
			if not wasOpen then
				wasOpen = true
				-- Just opened: a couple of quick extra pushes so the location/weather
				-- chip is populated even if the NUI mounted a frame after the first push.
				CreateThread(function()
					Wait(120)
					pushWorldInfo()
					Wait(250)
					pushWorldInfo()
				end)
			end
			Wait(1000)
		else
			wasOpen = false
			Wait(300)
		end
	end
end)

-- ============================================================
--  WARDROBE / CLOTHING (see character + take off / put on)
--  Components/props with per-sex "naked" values; take-off saves the
--  current variation so wear() restores it. Preview = a script camera
--  orbiting the real ped (rotated via NUI buttons; NUI has input focus).
-- ============================================================
local CLOTHING_ITEMS = {
	{ key = 'Hat',       header = 'Hat',       prop = true,  id = 0,  empty = { male = -1,  female = -1 } },
	{ key = 'Mask',      header = 'Mask',      prop = false, id = 1,  empty = { male = 0,   female = 0 } },
	{ key = 'Glasses',   header = 'Glasses',   prop = true,  id = 1,  empty = { male = -1,  female = -1 } },
	{ key = 'Earrings',  header = 'Earrings',  prop = true,  id = 2,  empty = { male = -1,  female = -1 } },
	{ key = 'Top',       header = 'Top',       prop = false, id = 11, empty = { male = 15,  female = 15 }, extra = { { id = 8, drawable = 15 }, { id = 3, drawable = 15 } } },
	{ key = 'Armour',    header = 'Armour',    prop = false, id = 9,  empty = { male = 0,   female = 0 } },
	{ key = 'Accessory', header = 'Accessory', prop = false, id = 7,  empty = { male = 0,   female = 0 } },
	{ key = 'Pants',     header = 'Pants',     prop = false, id = 4,  empty = { male = 61,  female = 14 } },
	{ key = 'Bag',       header = 'Bag',       prop = false, id = 5,  empty = { male = 0,   female = 0 } },
	{ key = 'Shoes',     header = 'Shoes',     prop = false, id = 6,  empty = { male = 34,  female = 35 } },
	{ key = 'Watch',     header = 'Watch',     prop = true,  id = 6,  empty = { male = -1,  female = -1 } },
	{ key = 'Bracelet',  header = 'Bracelet',  prop = true,  id = 7,  empty = { male = -1,  female = -1 } },
}

-- What the player has taken off, so it can be put back on: key -> part list.
-- Persisted server-side against the character (modules/clothing/server.lua) — it
-- must survive closing the tab, a resource restart and a relog.
local clothingLast = {}
local clothingLoaded = false
local clothingCam = nil
local clothingOrbit = 0.0

local function clothingSex()
	return GetEntityModel(PlayerPedId()) == `mp_f_freemode_01` and 'female' or 'male'
end

local function clothingFind(key)
	for i = 1, #CLOTHING_ITEMS do
		if CLOTHING_ITEMS[i].key == key then return CLOTHING_ITEMS[i] end
	end
end

-- Clamp a component drawable so we never assign an index the model lacks
-- (which would render the component invisible).
local function clampDrawable(ped, id, d)
	local count = GetNumberOfPedDrawableVariations(ped, id)
	if count and count > 0 and d >= count then d = count - 1 end
	if d < 0 then d = 0 end
	return d
end

local function clothingCurrent(item, ped)
	if item.prop then
		return GetPedPropIndex(ped, item.id), GetPedPropTextureIndex(ped, item.id)
	end
	return GetPedDrawableVariation(ped, item.id), GetPedTextureVariation(ped, item.id)
end

local function clothingIsWorn(item)
	local ped = PlayerPedId()
	local d = clothingCurrent(item, ped)
	if item.prop then return d ~= -1 end
	return d ~= clampDrawable(ped, item.id, item.empty[clothingSex()])
end

local function clothingSave()
	TriggerServerEvent('ox_inventory:setClothingState', clothingLast)
end

-- Pulls the saved "taken off" pieces once per session. Anything the player is
-- actually wearing again (a skin resource re-dressed the ped on spawn) has
-- nothing to restore, so its stale entry is dropped.
local function clothingLoad()
	if clothingLoaded then return end
	clothingLoaded = true

	local saved = lib.callback.await('ox_inventory:getClothingState', false)
	if type(saved) ~= 'table' then return end

	local pruned = false

	for i = 1, #CLOTHING_ITEMS do
		local item = CLOTHING_ITEMS[i]

		if saved[item.key] and clothingIsWorn(item) then
			saved[item.key] = nil
			pruned = true
		end
	end

	clothingLast = saved

	if pruned then clothingSave() end
end

local function clothingSendState()
	local list = {}
	for i = 1, #CLOTHING_ITEMS do
		local it = CLOTHING_ITEMS[i]
		list[#list + 1] = {
			key = it.key,
			header = it.header,
			worn = clothingIsWorn(it),
			canRestore = clothingLast[it.key] ~= nil,
		}
	end
	SendNUIMessage({ action = 'setClothing', data = { items = list } })
end

local function clothingTakeOff(item)
	local ped = PlayerPedId()
	local d, t = clothingCurrent(item, ped)
	local saved = { { id = item.id, prop = item.prop, drawable = d, texture = t } }

	if item.prop then
		ClearPedProp(ped, item.id)
	else
		SetPedComponentVariation(ped, item.id, clampDrawable(ped, item.id, item.empty[clothingSex()]), 0, 0)
		if item.extra then
			for _, e in ipairs(item.extra) do
				saved[#saved + 1] = { id = e.id, prop = false, drawable = GetPedDrawableVariation(ped, e.id), texture = GetPedTextureVariation(ped, e.id) }
				SetPedComponentVariation(ped, e.id, clampDrawable(ped, e.id, e.drawable), 0, 0)
			end
		end
	end

	clothingLast[item.key] = saved
	clothingSave()
end

local function clothingWear(item)
	local saved = clothingLast[item.key]
	if not saved then return end
	local ped = PlayerPedId()
	for _, v in ipairs(saved) do
		if v.prop then
			SetPedPropIndex(ped, v.id, v.drawable, v.texture, true)
		else
			SetPedComponentVariation(ped, v.id, v.drawable, v.texture, 0)
		end
	end
	clothingLast[item.key] = nil
	clothingSave()
end

local function clothingUpdateCam()
	if not clothingCam then return end
	local ped = PlayerPedId()
	local rad = math.rad(clothingOrbit)
	-- Lower camera + look-at slightly below the ped origin so the camera tilts down
	-- a touch: the character rides higher in frame, freeing the bottom of the screen
	-- for the centred rotate controls. (Tune 0.18 / -0.12 to taste.)
	local pos = GetOffsetFromEntityInWorldCoords(ped, math.sin(rad) * 2.2, math.cos(rad) * 2.2, 0.18)
	SetCamCoord(clothingCam, pos.x, pos.y, pos.z)
	PointCamAtEntity(clothingCam, ped, 0.0, 0.0, -0.12, true)
end

local function clothingStartCam()
	if clothingCam then return end
	clothingOrbit = 0.0
	clothingCam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
	clothingUpdateCam()
	SetCamActive(clothingCam, true)
	RenderScriptCams(true, true, 500, true, false)
	-- Clear the inventory's screen blur so the character preview stays sharp.
	Utils.blurOut()
end

local function clothingStopCam()
	if not clothingCam then return end
	RenderScriptCams(false, true, 500, true, false)
	DestroyCam(clothingCam, false)
	clothingCam = nil
	-- Restore the inventory blur when returning to the grid (if still open).
	-- Use the local `invOpen` upvalue, NOT LocalPlayer.state.invOpen: on a full
	-- close the state bag still reads `true` here (it's cleared ~200ms later), which
	-- would re-arm the blur with nothing left to clear it -> screen stuck blurred.
	if client.screenblur and invOpen == true then Utils.blurIn() end
end

RegisterNUICallback('openClothing', function(_, cb)
	clothingTabOpen = true
	-- Was `clothingLast = {}` — which threw away every removed piece each time the
	-- wardrobe opened, making them impossible to put back on.
	clothingLoad()
	clothingStartCam()
	clothingSendState()
	cb(1)
end)

RegisterNUICallback('closeClothing', function(_, cb)
	clothingTabOpen = false
	clothingStopCam()
	cb(1)
end)

RegisterNUICallback('clothingToggle', function(data, cb)
	local item = data and data.key and clothingFind(data.key)
	if item then
		if clothingIsWorn(item) then clothingTakeOff(item) else clothingWear(item) end
		clothingSendState()
	end
	cb(1)
end)

RegisterNUICallback('rotateClothing', function(data, cb)
	clothingOrbit = (clothingOrbit + ((data and data.dir or 1) * 15.0)) % 360.0
	clothingUpdateCam()
	cb(1)
end)

-- Safety: tear the camera down if the inventory closes while the wardrobe is open.
CreateThread(function()
	while true do
		if clothingCam and not LocalPlayer.state.invOpen then
			clothingStopCam()
		end
		Wait(400)
	end
end)
