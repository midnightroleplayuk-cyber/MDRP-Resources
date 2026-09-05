-- ------------------------------------------------------------------------------
-- Custom Peds
-- Players need /allowcustomped before the picker shows.
-- Disable individual peds in Clothing Admin -> Peds.
-- ------------------------------------------------------------------------------

Config.CustomPeds = {
    Enabled      = true,
    ImageBase    = 'https://docs.fivem.net/peds/%s.webp',
    AllowCommand = 'allowcustomped', -- /allowcustomped <serverId>
    AllowAce     = 'op-clothing.customped.allow',
}