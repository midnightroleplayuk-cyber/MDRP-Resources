Settings = Settings or {}

Settings.Frameworks = {
    { resource = "es_extended", folder = "ESX",    name = "ESX" },
    { resource = "qb-core",     folder = "QBCore", name = "QBCore" },
    { resource = "qbx_core",    folder = "QBOX",   name = "Qbox" }
}

Settings.Voices = {
    { resource = "pma-voice", folder = "PMAVoice", name = "PMAVoice" },
    { resource = "saltychat", folder = "SaltyChat", name = "SaltyChat" }
}

Settings.Fuel                  = (GetResourceState("ox_fuel") == "started" and "ox_fuel") or
    (GetResourceState("x-fuel") == "started" and "x-fuel") or
    (GetResourceState("LegacyFuel") == "started" and "LegacyFuel") or
    (GetResourceState("cdn-fuel") == "started" and "cdn-fuel") or
    (GetResourceState("Renewed-Fuel") == "started" and "Renewed-Fuel") or
    (GetResourceState("qb-fuel") == "started" and "qb-fuel") or (GetResourceState("lc_fuel") == "started" and "lc_fuel") or
    (GetResourceState("ps-fuel") == "started" and "ps-fuel") or
    (GetResourceState("rcore_fuel") == "started" and "rcore_fuel") or
    (GetResourceState("lj-fuel") == "started" and "lj-fuel") or "native"
