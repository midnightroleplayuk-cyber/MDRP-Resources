-- Auto detect target system using av_laptop config
Config.TargetSystem = true
Config.Interaction = {
	distance = 1.6,
	key = 38,
	icon = "fas fa-credit-card",
}

Config.ATMModels = {
	"prop_fleeca_atm",
	"prop_atm_01",
	"prop_atm_02",
	"prop_atm_03",
}

Config.ATM = {
	tabs = { "cards" },
	scanDistance = 3.0,
	facing = 0.35,
}

--- Sound and animation for the cash machine
Config.ATMEffects = {
	scenario = true,
	sounds = true,
}
