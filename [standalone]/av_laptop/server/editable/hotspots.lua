-- WiFi hotspots
-- canConnect(source) runs on the server: use server exports/functions here (hasJob, isBoss, getPermission, etc).
HotspotList = {
	{
		name = "uwucafe", -- an unique name
		label = "UwU Customers", -- How players will see it in their laptop WiFi
		password = false, -- password (string: "") or false
		coords = { -580.3973, -1059.5032, 22.3442 }, -- coords where this hotspot is located
		distance = 60, -- range in meters, players further than this can't see/use the hotspot (optional, defaults to Config.DefaultWiFiDistance)
		canConnect = function(source) -- run your own check, return true or false to show/hide the hotspot from this player
			return true
		end,
	},
	{
		name = "uwucafe_boss",
		label = "UwU Boss",
		password = "123",
		coords = { -580.3973, -1059.5032, 22.3442 },
		distance = 30, -- smaller range: only works inside the cafe
		canConnect = function(source)
			-- THIS IS JUST AN EXAMPLE!
			-- Checks if the player holds the boss grade and if their job name is 'uwu_cafe'
			local boss = isBoss(source) -- true or false
			local uwu = hasJob(source, "uwu_cafe") -- true or false
			return (boss and uwu) -- both true? returns true, 1 true but other one is false? return false, both false returns false
		end,
	},
	{
		name = "vanilla_employees",
		label = "Vanilla Employees",
		password = "123",
		coords = { 114.7914, -1286.0952, 28.2621 },
		distance = 60,
		canConnect = function(source)
			return true
		end,
	},
	{
		name = "pd_station",
		label = "Mission Row Employees",
		password = "police",
		coords = { 418.5264, -985.2715, 29.4090 },
		distance = 120, -- big building, bigger range
		canConnect = function(source)
			return true
		end,
	},
}
