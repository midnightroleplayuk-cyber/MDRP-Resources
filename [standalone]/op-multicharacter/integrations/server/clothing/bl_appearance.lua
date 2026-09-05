if Config.Clothing ~= "bl_appearance" then return end

function convertSkin(identifier)
    local appearance = exports.bl_appearance:GetPlayerAppearance(identifier)
    debugPrint("identifier", identifier, "appearance", json.encode(appearance))

    if appearance then
        return {skin = appearance, model = appearance.model}
    else 
        return {skin = {}}
    end
end