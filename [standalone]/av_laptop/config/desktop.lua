Config = Config or {}

Config.Desktop = {
	wallpapers = {
		{ id = 1, label = "Police", url = "https://r2.fivemanage.com/QmVAYSlqeAlD4IxVbdvu5/police_wallpaper.jpg" },
	},
	toggleableModules = {
		widgets = true,
		terminal = true,
		browser = true,
		files = true,
		notes = true,
		calculator = true,
		weather = true,
		beam = true,
	},
}

if lib.context == "client" then
	RegisterNUICallback("getDesktopConfig", function(_, cb)
		cb(Config.Desktop)
	end)
end
