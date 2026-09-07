Nui.setLocales = function()
  SendNUIMessage({
    type = "nui:setLocales",
    payload = {
      locales = Locales.data
    }
  })
end

---@param initial { image: string, canvas: string? }? reopens the editor on an existing poster
Nui.handleDisplay = function(value, initial)
  assert(type(value) == "boolean", "Not a valid display value")

  if value then Nui.setLocales() end

  SendNUIMessage({
    type = "nui:handleMenuDisplay",
    payload = {
      display = value,
      initialImage = initial and initial.image or nil,
      initialCanvas = initial and initial.canvas or nil,
    }
  })

  if not value then Nui.isDuringCreation = false end

  SetNuiFocus(value, value)
  Nui.MenuOpened = value
end

if Config.Debug then
  RegisterCommand("wbdispmenu", function(_, args)
    local value = tonumber(args[1]) == 1
    local succ, _ = pcall(Nui.handleDisplay, value)
    if succ then debugC("Succesfully dispatched - value: ", value) end
  end, false)
end

Nui.isDuringCreation = false
Nui.imageBase = nil

---Blocks until the editor hands an image back; the caller is expected to be a thread
local function awaitEditor(initial)
  Nui.isDuringCreation = true
  Nui.handleDisplay(true, initial)
  while Nui.isDuringCreation do
    Citizen.Wait(100)
  end

  assert(Nui.imageBase ~= nil, "Image couldnt be received")
  return Nui.imageBase
end

Nui.dispatchCreation = function()
  return awaitEditor(nil)
end

---Reopens the editor seeded with the poster's flattened image and, when it was
---saved with one, the canvas objects that produced it
Nui.dispatchEdit = function(image, canvas)
  return awaitEditor({ image = image, canvas = canvas })
end

Nui.consumeImage = function()
  local aux = Nui.imageBase
  Nui.imageBase = nil
  return aux
end

RegisterNuiCallback("nui:handleClose", function(_, cb)
  Nui.handleDisplay(false)
  cb(1)
end)

RegisterNuiCallback("nui:handleFrameExport", function(img, cb)
  Nui.handleDisplay(false)
  Nui.imageBase = img
  cb(1)
end)

RegisterNuiCallback("nui:exportFailed", function(_, cb)
  Notify.Functions.Send(T("poster:export_failed"), "error")
  cb(1)
end)
