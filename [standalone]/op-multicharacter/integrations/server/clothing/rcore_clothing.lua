if Config.Clothing ~= "rcore_clothing" then return end

function convertSkin(identifier)
    local rcoreSkin = exports["rcore_clothing"]:getSkinByIdentifier(identifier)

    return {
        skin = rcoreSkin.skin,
        model = rcoreSkin.ped_model,
    }
end