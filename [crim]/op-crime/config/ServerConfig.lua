-- ──────────────────────────────────────────────────────────────────────────────
-- Server-Side Configuration                                                   
-- (Information) ► Core server behaviour, external APIs, and integration options.
-- (Information) ► These settings affect backend operations such as logging, Steam avatar
--        fetching, and optional compatibility modes.
-- ──────────────────────────────────────────────────────────────────────────────
ServerConfig = {}

-- ──────────────────────────────────────────────────────────────────────────────
-- QB Gangs Integration                                                        
-- (Information) ► Enables compatibility mode for qb-gangs data structures.
-- (Information) ► Requires modified versions of qb-core or qbx_core.
-- (Information) ► Refer to documentation before enabling:
--        https://docs.otherplanet.dev/scripts/op-gangs/integrations/gangs-qb-core-qbox
-- ──────────────────────────────────────────────────────────────────────────────
ServerConfig.EnableQBgangsIntegrations = false

-- ──────────────────────────────────────────────────────────────────────────────
-- Steam API Key                                                              
-- (Information) ► Used to fetch player Steam avatars for UI and logs.
-- (Information) ► Optional — leave empty to disable avatar fetching.
-- ──────────────────────────────────────────────────────────────────────────────
ServerConfig.SteamApiKey = "" -- e.g. "YOUR_STEAM_API_KEY"

-- ──────────────────────────────────────────────────────────────────────────────
-- Discord Webhooks                                                            
-- (Information) ► Webhook URLs for sending server logs and admin actions.
-- (Information) ► Leave blank to disable Discord logging.
-- ──────────────────────────────────────────────────────────────────────────────
ServerConfig.DiscordWebHook = ''       -- General logs (boss menu actions, missions, etc.)
ServerConfig.DiscordWebHookAdmin = ''  -- Admin panel logs (bans, wipes, resets)