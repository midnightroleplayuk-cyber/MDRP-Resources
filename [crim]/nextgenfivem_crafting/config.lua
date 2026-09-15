--[[ Bench Options ]]
BenchOptions = {
    allowMultipleUsers = false,            -- Allow multiple users to use the same bench at the same time
    isInvincible = false,                  -- Make the player invincible while using the bench (can only be false if allowMultipleUsers is disabled)
    removeBlueprintOnCraft = false,        -- Remove the blueprint from the player after crafting
    enableSpotlight = true,                -- Enable the spotlight for the bench
    blackoutRenderFix = true,             -- Keep the bench screen readable during a server-wide blackout WITHOUT switching the blackout off. Prefer this over disableBlackoutAtBench: the world around the bench stays completely dark, hidden benches stay hidden, and your own blackout/time script keeps control.
    disableBlackoutAtBench = false,        -- Older, blunter version of the above: force-disables the global blackout on the local client while the player is at a bench. This relights the whole map for that player and cannot hand the blackout state back to an external time script, so use blackoutRenderFix instead unless you have a reason not to.
    enablePortableBenches = true,          -- Enable portable benches. This will allow the player to place the bench themselves with items. (this needs to be setted up, check out the documentation)
    enableBlueprintItems = true,           -- Enable the blueprint items. The player will need to have the blueprint item in their inventory to craft the item. (this needs to be setted up, check out the documentation)
    colors = {
        primary = '#45005a',               -- The primary color of the bench
        neutral = 'hsl(20, 14.3%, 4.1%)'   -- The neutral color of the bench
    },
    hideUnavailableRecipes = true,        -- Hide the recipes that the player can't craft
    filterMissingBlueprintRecipes = false, -- Filter out the recipes that the player doesn't have the blueprint for
    allowViewLockedRecipes = false,        -- Allow players to view locked recipes (preview only, crafting disabled)
    blueprintDurability = {                -- Only works if enableBlueprintItems and removeBlueprintOnCraft is enabled
        isEnabled = true,                 -- Enable or disable blueprint durability
        defaultUses = 3                    -- The default uses of the blueprint
    },
    adminBenchAccess = true,               -- Allow admins to use all benches
    kickPlayerOnDamage = true,             -- Kick the player from the bench if they take damage
    blueprintStrictMode = false,           -- The player must have a blueprint for every item they want to craft. (only works if enableBlueprintItems is enabled)
    pauseCraftingOnExit = false,           -- Pause the crafting process when the player exits the bench
    pauseCraftingOnDisconnect = true,      -- Pause the crafting process when the player disconnects from the server
    cancelCraftingOnExit = false,          -- Cancel all in-progress crafts and refund ingredients when the player exits the bench (takes precedence over pauseCraftingOnExit)
    disableLevelSystem = false,            -- Disable the levels for the bench
    queueLimit = 3,                        -- Maximum number of crafts a player can have in queue at the same bench (0 = unlimited)
    globalQueueLimit = 3,                  -- Maximum number of crafts a player can have in queue across ALL benches (0 = unlimited)
    maxCraftAmount = 0,                    -- Maximum number of items that can be crafted in a single craft operation (0 = unlimited)
    giveXPOnFailure = false,               -- Give XP even when crafting fails
}

--[[
    Translation - The translation file that the script will use. See what translations are available in the 'translations' folder.

    See the documentation for more information on how to add own translation.
]]
Translation = 'en-US'

--[[
    Default Keybinds

    The keybinds can be changed in the game settings.
]]
DefaultKeybinds = {
    ['interact'] = 'E',  -- The key to interact with the bench
    ['pickup'] = 'G',    -- The key to pickup portable benches
    ['exit'] = 'ESCAPE', -- The key to exit the bench

    -- Gizmo placement mode (see PlacementOptions below)
    ['selectGizmo_Mapper'] = 'MOUSE_BUTTON', -- The input mapper for the select key
    ['selectGizmo'] = 'MOUSE_LEFT',          -- The key to grab the highlighted gizmo axis
    ['translationGizmo'] = 'W',              -- The key to switch the gizmo to move mode
    ['rotationGizmo'] = 'R',                 -- The key to switch the gizmo to rotate mode
    ['localGizmo'] = 'Q',                    -- The key to toggle between relative and world space
    ['snapToGroundGizmo'] = 'LMENU',         -- The key to snap the object to the ground
    ['closeGizmo'] = 'RETURN',               -- The key to confirm the placement
    ['cancelGizmo'] = 'X',                   -- The key to cancel the placement
    ['switchModeGizmo'] = 'TAB',             -- The key to switch over to the walk placement mode

    -- Held to hand the mouse back to the camera while placing. Middle mouse is
    -- the editor convention, but it is also where radial/quick wheels usually
    -- sit: a script that opens on the same button will disable the camera
    -- controls for as long as it is open, and the camera will appear frozen.
    -- Move this to a free key if that happens.
    ['adjustCameraGizmo_Mapper'] = 'MOUSE_BUTTON', -- The input mapper for the camera key
    ['adjustCameraGizmo'] = 'MOUSE_MIDDLE',        -- The key to hold to move the camera

    -- Walk placement mode (see PlacementOptions below)
    ['rotateLeftGhost'] = 'LEFT',   -- The key to rotate the object to the left
    ['rotateRightGhost'] = 'RIGHT', -- The key to rotate the object to the right
    ['moveAwayGhost'] = 'UP',       -- The key to push the object further away
    ['moveCloserGhost'] = 'DOWN',   -- The key to pull the object closer
    ['moveUpGhost'] = 'PAGEUP',     -- The key to raise the object
    ['moveDownGhost'] = 'PAGEDOWN', -- The key to lower the object
    ['toggleSnapGhost'] = 'LMENU',  -- The key to toggle ground snapping
    ['confirmGhost'] = 'RETURN',    -- The key to confirm the placement
    ['cancelGhost'] = 'X',          -- The key to cancel the placement
    ['switchModeGhost'] = 'TAB',    -- The key to switch back to the gizmo placement mode
}

--[[
    Placement Options

    Controls how a workbench is positioned when it is placed out, both from the
    editor and when a player uses a portable bench item.

    'gizmo' - The free camera with a drag-and-drop gizmo. Needs a working mouse
              cursor, which some clients do not get (the game's editor runtime
              refuses to hand one out).
    'ghost' - The bench hovers in front of the player as a semi-transparent
              preview. The player walks to the spot, nudges it with the keyboard
              and confirms. Keyboard only, so it works without a cursor.
]]
PlacementOptions = {
    defaultMode = 'gizmo',  -- The placement mode a player starts in: 'gizmo' or 'ghost'
    allowModeSwitch = true, -- Allow players to switch between the two modes while placing (recommended)
    idleHintSeconds = 8,    -- Seconds without any mouse input in the gizmo before asking the player if they want to switch to walk placement (0 = never ask)
}

--[[
    Discord Logs

    This will log the crafting actions to a discord webhook.
]]
DiscordLogs = {
    enabled = false,                                                                       -- Enable or disable the discord logs
    webhookUrl = 'https://discord.com/api/webhooks/1234567890/abcdefghijklmnopqrstuvwxyz', -- The webhook for the discord logs
}

--[[
    HRS Base Building Integration

    Enable this to allow players to open crafting benches directly from
    props placed through hrs_base_building. See integrations/hrs_base_building.lua
    for setup instructions.
]]
HRSBaseBuilding = {
    enabled = false, -- Set to true to enable the integration
}

EnableOXLibLogger = false -- Enable the ox_lib Logger.
Command = 'crafting'      -- The prefix command for all sub-commands.
Debug = 'no'              -- yes or no. If yes, it will print out debug messages in the console.

--[[
    Framework - The framework that the script will use. See what frameworks are available in the 'frameworks' folder.

    auto: This will automatically detect the framework.
]]
Framework = 'auto'

--[[
    Database Resource - The resource that the script will use to get the database.
    Supported resources: 'auto', 'local', 'oxmysql'

    local: This is used for storing the data inside the script itself.
    auto: This will automatically detect the database resource.
]]
DatabaseResource = 'auto'

--[[
    Inventory Resource - The resource that the script will use to handle the inventory.
    Supported resources: 'auto', 'codem-inventory', 'ox_inventory', 'ps-inventory', 'qb-inventory', 'qs-inventory', 'tgiann-inventory'

    auto: This will automatically detect the database resource.
]]
Inventory = 'auto'

--[[
    Instance Detection

    Used to determine which "instance" a player is in (e.g. inside a house/apartment).
    Benches placed inside an instance will only be visible to players in the same instance.

    By default, this reads the 'instance' state bag on the player entity.
    If no instance is found, it falls back to the player's routing bucket.
    A return value of nil or 0 means the player is in the default world (no instance).

    You can customize this function to work with your housing/apartment script.
    Examples:

    -- Using a different state bag name:
    GetPlayerInstance = function(src)
        local instance = Player(src).state.propertyId
        if instance and instance ~= 0 then return instance end
        return GetPlayerRoutingBucket(src)
    end

    -- Using an export from your housing script:
    GetPlayerInstance = function(src)
        local propertyId = exports['your_housing']:getPlayerProperty(src)
        if propertyId then return propertyId end
        return GetPlayerRoutingBucket(src)
    end
]]
GetPlayerInstance = function(src)
    local instance = Player(src).state.instance
    if instance and instance ~= 0 then return instance end

    local bucket = GetPlayerRoutingBucket(src)
    if bucket ~= 0 then return bucket end

    return nil
end
