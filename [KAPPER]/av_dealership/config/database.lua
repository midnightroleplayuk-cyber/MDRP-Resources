-- ESX only. Fills the `type` column of owned_vehicles so garages know where each vehicle belongs
Config = Config or {}
Config.DefaultType = "car"
Config.Types = {
	["boats"] = "boat",
	["helicopters"] = "helicopter",
}
