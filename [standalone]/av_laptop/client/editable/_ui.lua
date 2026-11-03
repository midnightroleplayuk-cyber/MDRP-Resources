local function hasAvUi()
	return GetResourceState("av_ui") == "started"
end

function showTextUI(text, data) -- I personally don't use the options from ox_lib
	if Config.UIlib == "lation_ui" then
		local keybind, msg = parseInputText(text)
		return exports.lation_ui:showText({
			title = data and data["title"] or nil,
			description = msg,
			keybind = data and data["keybind"] or keybind,
			icon = data and data["icon"] or nil,
			options = data and data["options"] or nil,
		})
	end
	if hasAvUi() then
		return exports.av_ui:showTextUI(text, data)
	end
	lib.showTextUI(text, data)
end

function hideTextUI()
	if Config.UIlib == "lation_ui" then
		exports.lation_ui:hideText()
	elseif hasAvUi() then
		exports.av_ui:hideTextUI()
	else
		lib.hideTextUI()
	end
end

function isTextUIOpen()
	if Config.UIlib == "lation_ui" then
		return exports.lation_ui:isOpen()
	end
	if hasAvUi() then
		return exports.av_ui:isTextUIOpen()
	end
	return lib.isTextUIOpen()
end

function alertDialog(data)
	if Config.UIlib == "lation_ui" then
		return exports.lation_ui:alert(data)
	end
	if hasAvUi() then
		return exports.av_ui:alertDialog(data)
	end
	return lib.alertDialog(data)
end

function inputDialog(label, options, extra)
	if Config.UIlib == "lation_ui" then
		return exports.lation_ui:input({
			title = label,
			subtitle = extra and extra["subtitle"] or nil,
			submitText = extra and extra["submitText"] or nil,
			options = options,
		})
	end
	if hasAvUi() then
		return exports.av_ui:inputDialog(label, options)
	end
	return lib.inputDialog(label, options)
end

function progressBar(data)
	local payload = {
		label = data.label,
		description = data.description,
		duration = data.duration,
		icon = data.icon,
		canCancel = data.canCancel,
		iconColor = data.iconColor,
		color = data.color,
		useWhileDead = data.useWhileDead,
		disable = data.disable or nil,
		anim = data.anim or nil,
		prop = data.prop or nil,
		steps = data.steps or nil,
	}
	return exports[Config.UIlib]:progressBar(payload)
end

function progressCircle(data)
	if Config.UIlib == "lation_ui" then
		return progressBar(data)
	end
	local payload = {
		label = data.label,
		description = data.description,
		duration = data.duration,
		icon = data.icon,
		canCancel = data.canCancel,
		iconColor = data.iconColor,
		color = data.color,
		useWhileDead = data.useWhileDead,
		disable = data.disable or nil,
		anim = data.anim or nil,
		prop = data.prop or nil,
		steps = data.steps or nil,
		position = data.position or "bottom",
	}
	if hasAvUi() then
		return exports.av_ui:progressCircle(payload)
	end
	return lib.progressCircle(payload)
end

function registerContext(data)
	if Config.UIlib == "lation_ui" then
		return exports.lation_ui:registerMenu(data)
	end
	if hasAvUi() then
		return exports.av_ui:registerContext(data)
	end
	lib.registerContext(data)
end

function showContext(name)
	if Config.UIlib == "lation_ui" then
		return exports.lation_ui:showMenu(name)
	end
	if hasAvUi() then
		return exports.av_ui:showContext(name)
	end
	lib.showContext(name)
end

function hideContext()
	if Config.UIlib == "lation_ui" then
		return exports.lation_ui:hideMenu()
	end
	if hasAvUi() then
		return exports.av_ui:hideContext()
	end
	lib.hideContext()
end

exports("showTextUI", showTextUI)
exports("hideTextUI", hideTextUI)
exports("isTextUIOpen", isTextUIOpen)
exports("alertDialog", alertDialog)
exports("inputDialog", inputDialog)
exports("progressBar", progressBar)
exports("registerContext", registerContext)
exports("showContext", showContext)
exports("hideContext", hideContext)
exports("progressCircle", progressCircle)
exports("getUI", function()
	if hasAvUi() then
		return "av_ui"
	end
	return Config.UIlib or "ox_lib"
end)
