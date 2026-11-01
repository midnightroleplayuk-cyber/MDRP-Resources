Config = {}

-- Player command: /clearprops
Config.Command = 'clearprops'
Config.Cooldown = 5 -- seconds between uses
Config.Keybind = 'X' -- default key; players can rebind in Settings > Key Bindings > FiveM

-- Staff command: /clearpropsid <server id>
-- Needs ace: add_ace group.admin command.clearpropsid allow
Config.AdminCommand = 'clearpropsid'

-- Also stop the stuck animation (holding pose etc.)
Config.ClearAnimation = true

-- Put the player's weapon away as well
Config.HolsterWeapon = false

-- Models that should never be removed (e.g. parachute bags, custom backpacks)
Config.IgnoreModels = {
    -- `p_parachute_s`,
}
