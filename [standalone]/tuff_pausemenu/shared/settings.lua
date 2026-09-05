-- ▀█▀ █░█ ▄▀█ █▄░█ █▄▀   █▄█ █▀█ █░█   █▀▀ █▀█ █▀█   █▀█ █░█ █▀█ █▀▀ █░█ ▄▀█ █▀ █▀▀
-- ░█░ █▀█ █▀█ █░▀█ █░█   ░█░ █▄█ █▄█   █▀░ █▄█ █▀▄   █▀▀ █▄█ █▀▄ █▄▄ █▀█ █▀█ ▄█ ██▄

-- Do not touch.
Framework = (GetResourceState("es_extended") == "started" and exports['es_extended']:getSharedObject()) or
(GetResourceState("qb-core") == "started" and exports['qb-core']:GetCoreObject()) or
(GetResourceState("qbx_core") == "started" and exports['qbx_core']:GetCoreObject()) or nil

Settings = {}
Settings.ForceStandalone = false
Settings.Framework = (GetResourceState("es_extended") == "started" and "ESX") or
(GetResourceState("qb-core") == "started" and "QBCore") or (GetResourceState("qbx_core") == "started" and "Qbox") or nil
Settings.Standalone = Settings.ForceStandalone or (Settings.Framework == nil)
-------------------------------------------------------------------------------

Settings.CinematicCamera = {
    enabled = false
}

Settings.PlayerInfo = {
    showName = true,
    showCash = false,
    showBank = false,
    showJob = false
}

Settings.StandaloneInfo = {
    showLogo = true,
    showId = false,
    showLocation = false
}

Settings.Socials = {
    youtube = {
        enabled = false,
        url = "https://www.youtube.com/channel/UCHHl48TO0upGaTjiNAhrarQ"
    },
    discord = {
        enabled = true,
        url = "https://discord.gg/RQArbRYpYj"
    },
    tebex = {
        enabled = true,
        url = "https://tuff-scripts.tebex.io/"
    }
}
