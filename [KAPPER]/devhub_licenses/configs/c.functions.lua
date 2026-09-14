OpenClientFunctions = {

    ---Called WHEN the main license MDT tablet is opened.
    ---@param isLaptopApp boolean Whether it's opened as a devhub_laptop app
    OnMdtOpened = function(isLaptopApp)
        TriggerServerEvent('devhub_licenses:server:sendLog', {
            action = "MDT Opened",
            isLaptopApp = tostring(isLaptopApp),
        })
    end,

    ---Called WHEN the main license MDT tablet is closed.
    OnMdtClosed = function()
        TriggerServerEvent('devhub_licenses:server:sendLog', {
            action = "MDT Closed",
        })
    end,

    ---Called WHEN the card holder UI is opened (player's own licenses).
    ---@param licenseCount number Number of licenses displayed
    OnCardHolderOpened = function(licenseCount)
        TriggerServerEvent('devhub_licenses:server:sendLog', {
            action = "Card Holder Opened",
            licenseCount = licenseCount,
        })
    end,

    ---Called WHEN the card holder is closed.
    OnCardHolderClosed = function()
        return
    end,

    ---Called WHEN the favorite hand display is opened.
    ---@param favoriteCount number Number of favorite licenses being shown
    OnFavoriteHandOpened = function(favoriteCount)
        TriggerServerEvent('devhub_licenses:server:sendLog', {
            action = "Favorite Hand Opened",
            favoriteCount = favoriteCount,
        })
    end,

    ---Called WHEN the favorite hand display is closed.
    OnFavoriteHandClosed = function()
        return
    end,

    ---Called WHEN a license is being shown to nearby players (animation + 3D display starts).
    ---Return false to prevent the show action.
    ---@param licenseId string The license ID being shown
    ---@return boolean allowed Return false to block, true (or nil) to allow
    OnShowLicense = function(licenseId)
        TriggerServerEvent('devhub_licenses:server:sendLog', {
            action = "License Shown",
            licenseId = licenseId,
        })
        return true
    end,

    ---Called WHEN a license display overlay appears on your screen (another player showed you their license).
    ---@param templateData table Template visual data (components, layout, background, texture)
    ---@param licenseData table The license's data fields (name, DOB, avatar, etc.)
    ---@param sourceServerId number Server ID of the player who showed the license
    OnLicenseDisplayReceived = function(templateData, licenseData, sourceServerId)
        return
    end,

    ---Called WHEN a newly created license preview animation plays (after picking up a license).
    ---@param previewData table Preview data including template info and license data
    OnNewLicensePreview = function(previewData)
        -- Example: Play a celebration sound
        -- PlaySoundFrontend(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", true)
        return
    end,

    ---Called WHEN another player's licenses are being checked (search animation starts).
    ---Return false to cancel the check.
    ---@param targetServerId number Server ID of the player being searched
    ---@param targetEntity number Entity handle of the target player ped
    ---@return boolean allowed Return false to cancel, true (or nil) to proceed
    OnCheckPlayerLicenses = function(targetServerId, targetEntity)
        TriggerServerEvent('devhub_licenses:server:sendLog', {
            action = "Checking Player Licenses",
            targetServerId = targetServerId,
        })
        return true
    end,

    ---Called WHEN viewing another player's card holder (after fetching their licenses).
    ---@param targetServerId number Server ID of the player being viewed
    ---@param playerName string Display name/identifier of the target player
    ---@param licenseCount number Number of licenses found
    OnViewingPlayerLicenses = function(targetServerId, playerName, licenseCount)
        return
    end,

    ---Called WHEN the license terminal (scanner) is opened.
    OnTerminalOpened = function()
        return
    end,

    ---Called WHEN a license is scanned at the terminal.
    ---@param licenseId string The scanned license ID
    ---@param templateName string Template name of the scanned license
    ---@param licenseData table The license data fields
    OnLicenseScanned = function(licenseId, templateName, licenseData)
        TriggerServerEvent('devhub_licenses:server:sendLog', {
            action = "License Scanned at Terminal",
            licenseId = licenseId,
            templateName = templateName,
        })
    end,

    ---Called WHEN the license terminal is closed.
    OnTerminalClosed = function()
        return
    end,

    ---Called BEFORE the avatar screenshot process begins (player is teleported to studio).
    OnScreenshotStarted = function()
        return
    end,

    ---Called AFTER the screenshot is complete and the player is returned to their original position.
    ---@param imageUrl string|nil The uploaded image URL (nil if upload failed)
    OnScreenshotCompleted = function(imageUrl)
        return
    end,

    ---Called by target handler for hideout entrance door.
    ---NOTE: This is triggered repeatedly by the target system to determine visibility, NOT once on interaction.
    ---Return true to show the door interaction option, false to hide it.
    ---@param entity number The door entity handle
    ---@return boolean visible
    OnHideoutDoorHandler = function(entity)
        return true
    end,

    ---Called by target handler for hideout carpet (entrance to underground).
    ---NOTE: This is triggered repeatedly by the target system to determine visibility, NOT once on interaction.
    ---Return true to show the carpet interaction option, false to hide it.
    ---@param entity number The carpet entity handle
    ---@param distance number Distance from player to carpet
    ---@param coords vector3 Carpet coordinates
    ---@return boolean visible
    OnHideoutCarpetHandler = function(entity, distance, coords)
        return true
    end,
}
