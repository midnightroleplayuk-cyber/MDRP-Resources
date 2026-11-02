-- Keybind for orders menu
local keybind = lib.addKeybind({
    name = 'orders',
    description = 'Enable cursor',
    defaultKey = 'K',
    disabled = true,
    onPressed = function()
        SetNuiFocus(true,true)
        SendNUIMessage({
            action = "setFocus"
        })
    end,
})

function setKeybind(state)
    keybind:disable(state)
end