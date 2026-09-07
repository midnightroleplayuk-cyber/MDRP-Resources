Builder = {}
Builder.isBuilding = false

if Config.Debug then
  RegisterCommand("stop_building", function()
    Builder.init()
  end, false)
end

-- Live readout of the surface being dragged out. The px figure is what the drawn
-- area works out to at 1080p, so a player can match the export to the wall
Builder.drawMeasurements = function(p1, p2)
  local width  = #(vector3(p1.x, p1.y, 0.0) - vector3(p2.x, p2.y, 0.0))
  local height = math.abs(p1.z - p2.z)
  if width <= 0.0 or height <= 0.0 then return end

  local top = vector3((p1.x + p2.x) / 2.0, (p1.y + p2.y) / 2.0, math.max(p1.z, p2.z) + 0.2)
  local pxW, pxH = World.AspectAt1080p(width, height)

  World.DrawText3D(top, ("%.2fm x %.2fm"):format(width, height))
  World.DrawText3D(top - vector3(0.0, 0.0, 0.22), ("%d x %d @ 1080p"):format(pxW, pxH))
end

Builder.building_thread = function()
  local DisableControlAction = DisableControlAction
  local DrawSphere = DrawSphere
  local IsControlJustPressed = IsControlJustPressed

  local p1
  while Builder.isBuilding do
    DisableControlAction(0, 38, true)
		DisableControlAction(0, 264, true) -- Disable melee
		DisableControlAction(0, 257, true) -- Disable melee
		DisableControlAction(0, 140, true) -- Disable melee
		DisableControlAction(0, 141, true) -- Disable melee
		DisableControlAction(0, 142, true) -- Disable melee
		DisableControlAction(0, 143, true) -- Disable melee
    DisableControlAction(2, 199, true) -- Disable pause menu

    local start,fin = World.GetCoordsInFrontOfCam(0, 5000)
    local ray = StartShapeTestRay(start.x, start.y, start.z, fin.x, fin.y, fin.z, 4294967295, cache.ped, 5000)
    local _, hit, pos, _, _ = GetShapeTestResult(ray)


    if hit then
      DrawSphere(pos.x, pos.y, pos.z, 0.06, Config.server_color.r, Config.server_color.g, Config.server_color.b, 0.5)
    end
    if p1 then
      World.DrawSelectedArea(p1, pos, pos.z, p1.z, Config.server_color.r, Config.server_color.g, Config.server_color.b, 80)
      Builder.drawMeasurements(p1, pos)
    end

    if IsControlJustPressed(0, CONST.STOP_BUILDING_KEY) then
      Builder.isBuilding = false
    elseif IsControlJustPressed(0, CONST.HANDLE_BUILDING_KEY) then
      if p1 then
        Builder.isBuilding = false
        (hit and Poster.dispatchPosterCreationOnArea)(p1, pos)
      else p1 = pos end
    end

    Citizen.Wait(0)
  end
end

Builder.init = function()
  if Builder.isBuilding then return debugC("Already building :: Builder.init") end
  if not lib.callback.await("of_whiteboard:server:do_checks") then
    return lib.notify({
      title = "Poster",
      description = "You don't have permission to build posters",
      type = "error"
    })
  end

  Builder.isBuilding = true
  Citizen.CreateThread(Builder.building_thread)
end

RegisterNetEvent("of_whiteboard:client:start_building", Builder.init)

RegisterNetEvent("of_whiteboard:client:start_editing", function(posterId, image, canvas)
  Citizen.CreateThread(function()
    local succ, _ = pcall(Nui.dispatchEdit, image, canvas)
    if not succ then return debugC("Couldnt get image from Nui.dispatchEdit") end

    TriggerServerEvent("of_whiteboard:server:handlePosterEdit", {
      posterId = posterId,
      baseImg  = Nui.consumeImage(),
    })
  end)
end)
