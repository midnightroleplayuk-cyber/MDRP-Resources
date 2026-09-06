-- Location/ped shops are now managed dynamically from the database
-- (ox_inventory_shops) and created/edited in-game via /oxinventory → Shops tab.
-- Those were migrated into the DB on first boot from data/shops_migrate.lua (a
-- one-time copy) and MUST NOT be duplicated here, or the native loader would make
-- duplicate zones/blips.
--
-- EXCEPTION — model/prop-based shops (e.g. vending machines) target EVERY existing
-- world prop of a given model. The in-game shop editor only places shops at fixed
-- spawn points, so it cannot represent them; they stay here as static shops and
-- are bound by the stock shops module via ox_target:addModel. The migration skips
-- location-less shops (see modules/customshop/server.lua) so these never become
-- broken "ghost" entries in the DB.

return {
	-- ═════════════════════════════════════════════════════
	-- APEX SCRATCHCARDS — location-less shop (skipped by the DB
	-- migration on purpose, so no ghost entry is created). It is
	-- opened by the lottery-kiosk NPC spawned by apex_scratchcards
	-- (Config.Shop) via:
	--   exports.ox_inventory:openInventory('shop', { type = 'ScratchShop' })
	-- ═════════════════════════════════════════════════════
	ScratchShop = {
		name = 'Lottery Kiosk',
		inventory = {
			{ name = 'scratch_green',     price = 500  },
			{ name = 'scratch_blue',      price = 750  },
			{ name = 'scratch_lucky7',    price = 700  },
			{ name = 'scratch_blackjack', price = 750  },
			{ name = 'scratch_symbols',   price = 800  },
			{ name = 'scratch_gold',      price = 850  },
			{ name = 'scratch_vault',     price = 850  },
			{ name = 'scratch_diamond',   price = 900  },
			{ name = 'lottery_ticket',    price = 1000 },
		},
	},

	VendingMachineDrinks = {
		name = 'Vending Machine',
		inventory = {
			{ name = 'water', price = 10 },
			{ name = 'cola', price = 10 },
		},
		model = {
			`prop_vend_soda_02`, `prop_vend_fridge01`, `prop_vend_water_01`, `prop_vend_soda_01`
		}
	}
}
