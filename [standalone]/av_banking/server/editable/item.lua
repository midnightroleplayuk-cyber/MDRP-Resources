AddEventHandler("ox_inventory:usedItem", function(playerId, name, slotId, metadata)
	if not playerId or not name then
		return
	end
	if type(Config.CardItems) ~= "table" or not Config.CardItems[name] then
		return
	end
	dbug("card item used", name, "by", playerId)
	metadata = metadata or {}
	local uid = tostring(metadata.uid or "")
	if uid == "" then
		dbug("card item has no uid in its metadata")
		NotifyPlayer(playerId, L("card_item_broken"), "error")
		return
	end
	local identifier = GetIdentifier(playerId)
	if not identifier then
		return
	end
	local card = MySQL.single.await("SELECT * FROM av_banking_cards WHERE uid = ?", { uid })
	if not card then
		dbug("no card answers to that uid, the plastic is dead")
		NotifyPlayer(playerId, L("card_item_dead"), "error")
		return
	end
	TriggerClientEvent("av_banking:cardUsed", playerId, {
		uid = uid,
		typeId = card.card_type,
		slot = slotId,
		frozen = Banking.isTrue(card.frozen),
	})
end)
