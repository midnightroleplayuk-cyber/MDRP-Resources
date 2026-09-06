-- Stashes are now managed dynamically from the database (ox_inventory_stashes)
-- and created/edited in-game via /oxinventory → Stashes tab.
--
-- The original static stashes were migrated into the database on first boot from
-- data/stashes_migrate.lua (a one-time copy). The original file is kept as
-- data/stashes.lua.bak for reference.
--
-- Returning an empty table here so the native loader doesn't create duplicate
-- zones for stashes that now live in the database.
return {}
