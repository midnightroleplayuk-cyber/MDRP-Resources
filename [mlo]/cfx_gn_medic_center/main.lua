Citizen.CreateThread(function()


RequestIpl("gn_medic_pillbox_milo")
	local interiorID = GetInteriorAtCoords(322.2190, -586.7530, 45.7627)
	local int = {
		"rc12b_fixed",
		"rc12b_destroyed",
		"rc12b_default",
		"rc12b_hospitalinterior_lod",
		"rc12b_hospitalinterior"
	}
	Wait(10000)
	for i = 1, #int, 1 do
		if IsIplActive(int[i]) then
			RemoveIpl(int[i])
		end
	end
	RefreshInterior(interiorID)
	LoadInterior(interiorID)
end)