local soundEnabled = require("config.main").EnableSounds

---@alias SoundKey "select" | "add" | "quantity" | "remove" | "purchase" | "error"

---@type table<SoundKey, string[]>
local soundLibrary = {
	select = { "WEAPON_SELECT_OTHER", "HUD_AMMO_SHOP_SOUNDSET" },
	add = { "WEAPON_ATTACHMENT_UNEQUIP", "HUD_AMMO_SHOP_SOUNDSET" },
	quantity = { "WEAPON_ATTACHMENT_EQUIP", "HUD_AMMO_SHOP_SOUNDSET" },
	remove = { "WEAPON_ATTACHMENT_UNEQUIP", "HUD_AMMO_SHOP_SOUNDSET" },
	purchase = { "WEAPON_PURCHASE", "HUD_AMMO_SHOP_SOUNDSET" },
	error = { "ERROR", "HUD_AMMO_SHOP_SOUNDSET" },
}

---@param sound SoundKey
function playSound(sound)
	if not soundEnabled then return end
	PlaySoundFrontend(-1, soundLibrary[sound][1], soundLibrary[sound][2], true)
end
