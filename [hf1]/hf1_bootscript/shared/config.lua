Config = {}
Config.Job = 'police'
Config.RequireDuty = true
Config.InteractionDistance = 2.5
Config.SessionDistance = 6.0
Config.MinGrade = { clothing = 0, police = 0, traffic = 2, firearms = 4 }
Config.Vehicles = {'srhatpd','cazadorpd','shenronpd','sr6pd','sr3pd','sen5tourpd','strcoupepd','rhinea19xpd','tailstmk','reblaxpd','xlsstrpd','sr8pd','komtmark','strwagmark','taurionpd','clubrpd'}
Config.TrafficVehicles = {'sr6pd','sr3pd','sen5tourpd','strcoupepd','rhinea19xpd','tailstmk','taurionpd','clubrpd'}
Config.FirearmsVehicles = {'reblaxpd','xlsstrpd','sr8pd','komtmark','strwagmark'}
-- Change to the actual client event/export from your installed no-bs prop resource.
Config.Traffic = { mode = 'command', resource = 'bs-propplacer', command = 'signs', event = '', export = '' }
-- bs-propplacer/config.lua sets Config.OpenCommand = 'signs'. Update both if you change it.
-- Set server-only PIN via: set hf1_boot_pin "1234" in server.cfg (change 1234).
Config.PinMaxAttempts = 5
Config.PinCooldownSeconds = 120
Config.SessionSeconds = 180
Config.ActionCooldownMs = 800
-- ox_inventory item names MUST exist in ox_inventory/data/items.lua; weapon items must be configured there too.
Config.PoliceItems = {
  { id = 'radio', label = 'Police Radio', item = 'radio', count = 1, minGrade = 0 },
  { id = 'medkit', label = 'First Aid Kit', item = 'firstaid', count = 1, minGrade = 0 },
}
Config.Firearms = {
  { id = 'pistol', label = 'Service Pistol', item = 'WEAPON_PISTOL', count = 1, minGrade = 4 },
  { id = 'carbine', label = 'Patrol Carbine', item = 'WEAPON_CARBINERIFLE', count = 1, minGrade = 5 },
}
-- Appearance integration: 'illenium-appearance' or 'fivem-appearance'.
-- Full outfits use appearance exports to save current skin then apply configured outfit components/props.
-- Example drawable/texture values are placeholders: replace for your freemode clothing pack.
Config.Appearance = 'op-clothing'
-- OP Clothing advertises illenium-appearance compatibility. If its exports are exposed
-- under a different resource name, update Config.Appearance accordingly.
Config.Tablet = { logo = 'logo.png', forceName = 'POLICE OPERATIONS', title = 'Vehicle Equipment Terminal' }
Config.Clothing = {
  { id = 'highvis', label = 'High Visibility Jacket', minGrade = 0,
    components = { { component_id = 11, drawable = 0, texture = 0 }, { component_id = 8, drawable = 0, texture = 0 } }, props = {} },
  { id = 'gloves', label = 'Protective Gloves', minGrade = 0,
    components = { { component_id = 3, drawable = 0, texture = 0 } }, props = {} },
}
-- Items are issued from the vehicle stock conceptually; this script does not deduct physical trunk stock.
-- Enable these if you want a per-player limit until item is returned via the tablet.
Config.TrackIssuedItems = true
