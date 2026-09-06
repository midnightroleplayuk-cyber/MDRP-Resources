-- Crafting benches are now managed dynamically from the database
-- (ox_inventory_crafting) and created/edited in-game via /oxinventory → Craft tab.
--
-- The original static benches were migrated into the database on first boot from
-- data/crafting_migrate.lua (a one-time copy). The original file is kept as
-- data/crafting.lua.bak for reference.
--
-- Returning an empty table here so the native loader doesn't create duplicate
-- zones for benches that now live in the database.
return {}
