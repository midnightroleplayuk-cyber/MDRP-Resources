if Config.Clothing ~= "4bit_appearance" then return end

function convertSkin(identifier)
    local appearance = exports['4bit_appearance']:getAppearanceByCitizenId(identifier)

    if not appearance then
        return { model = nil, skin = nil }
    end

    return {
        model = appearance.model,
        skin = appearance.features
    }
end