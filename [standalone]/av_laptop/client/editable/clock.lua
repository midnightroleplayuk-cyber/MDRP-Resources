local weatherScript = ""

local function detectWeather()
	if GetResourceState("av_weather") == "started" then
		weatherScript = "av_weather"
		return
	end
	weatherScript = ""
end

CreateThread(detectWeather)

AddEventHandler("onClientResourceStart", function(resource)
	if resource == "av_weather" then detectWeather() end
end)

AddEventHandler("onClientResourceStop", function(resource)
	if resource == "av_weather" then weatherScript = "" end
end)

function WeatherScript()
	return weatherScript
end

function getZoneWeather()
	if weatherScript == "av_weather" then
		local weather = exports["av_weather"]:getZone()
		--        dbug("getZoneWeather()", weather and json.encode(weather))
		return weather
	end
	return false
end

AddEventHandler("av_weather:timeUpdated", function(hour, minutes)
	if LocalPlayer.state.inLaptop and Config.UseGameClock then
		SendNUIMessage({
			action = "clock",
			data = {
				enabled = true,
				hour = hour,
				minutes = minutes,
			},
		})
	end
end)

exports("getWeatherScript", function()
	return weatherScript
end)
