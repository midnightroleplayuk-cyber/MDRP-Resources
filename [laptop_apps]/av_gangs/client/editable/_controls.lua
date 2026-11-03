-- Used to toggle menu opacity and cursor
local toggleMenu = lib.addKeybind({
    name = 'toggleMenu',
    description = 'Press H to toggle menu',
    defaultKey = 'H',
    onPressed = function()
        exports['av_laptop']:hideTextUI()
        if not inAdmin then return end
        SetNuiFocus(true,true)
        SendNUIMessage({
            action = "toggleCursor",
            data = true
        })
    end,
})

toggleMenu:disable(true)

function toggleCursor()
    toggleMenu:disable(false)
    exports['av_laptop']:showTextUI("[H] Toggle Menu")
end

-- Change ped model in shell
local changeModel = lib.addKeybind({
    name = "changeModel",
    description = "Change ped model while in shell creator mode",
    defaultKey = "M"
})

changeModel:disable(true)

function modelState()
    return changeModel:isControlPressed()
end

-- Change ped animation in shell
local changeAnimation = lib.addKeybind({
    name = "changeAnimation",
    description = "Change ped animation while in shell creator mode",
    defaultKey = "K"
})

changeAnimation:disable(true)

function animState()
    return changeAnimation:isControlPressed()
end

function creatorKeys(state)
    changeModel:disable(state)
    changeAnimation:disable(state)
end