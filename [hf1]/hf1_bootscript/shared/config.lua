Config = {}
Config.Job = 'police'
Config.RequireDuty = true
Config.InteractionDistance = 2.5
Config.SessionDistance = 6.0
-- GTA trunk / boot door index is 5. Custom vehicles must have a working boot door.
Config.BootDoorIndex = 5
Config.MinGrade = { clothing = 0, police = 0, traffic = 3, firearms = 5 }

Config.Vehicles = {'srhatpd','cazadorpd','shenronpd','sr6pd','sr3pd','sen5tourpd','strcoupepd','rhinea19xpd','tailstmk','reblaxpd','xlsstrpd','sr8pd','komtmark','strwagmark','taurionpd','clubrpd'}
Config.TrafficVehicles = {'sr6pd','sr3pd','sen5tourpd','strcoupepd','rhinea19xpd','tailstmk','taurionpd','clubrpd'}
Config.FirearmsVehicles = {'reblaxpd','xlsstrpd','sr8pd','komtmark','strwagmark'}

-- The /signs command is used directly; no event integration is required.
Config.Traffic = { mode = 'command', resource = 'bs-propplacer', command = 'signs', event = '', export = '' }
-- bs-propplacer/config.lua sets Config.OpenCommand = 'signs'. Update both if you change it.
-- Set server-only PIN via: set hf1_boot_pin "1234" in server.cfg (change 1234).
Config.PinMaxAttempts = 5
Config.PinCooldownSeconds = 120
Config.SessionSeconds = 180
Config.ActionCooldownMs = 800

-- Item images are loaded from ox_inventory/web/images/<item>.png by default.
-- Override any entry with image = 'custom_image_name' (without .png).
-- ox_inventory item names MUST exist in ox_inventory/data/items.lua; weapon items must be configured there too.
Config.PoliceItems = {
  { id = 'police_tape', label = 'Police Tape', item = 'police_tape', count = 2, minGrade = 0 },
  { id = 'breathalyzer', label = 'Breathalyzer', item = 'breathalyzer', count = 2, minGrade = 0 },
  { id = 'breathalyzer_mouthpiece', label = 'Breathalyzer Mouthpieces', item = 'breathalyzer_mouthpiece', count = 10, minGrade = 0 },

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
Config.Tablet = { logo = 'logo.png', forceName = 'Midnight Police Constabulary', title = 'Boot Equipment System' }
-- IMPORTANT: drawable numbers are specific to YOUR clothing pack and ped sex.
-- Component 11 = jackets/tops; component 3 = arms/gloves; component 8 = undershirts.
-- Fill in the drawable/texture numbers from OP Clothing for your male/female uniforms.
-- No forced undershirt changes. Sample values below are NOT guaranteed to exist.
Config.Clothing = {
  { id = 'highvis', label = 'High Visibility Jacket', image = 'highvis.png', minGrade = 0,
    male = { components = { { component_id = 11, drawable = 619, texture = 0 } } },
    female = { components = { { component_id = 11, drawable = 0, texture = 0 } } } },
  { id = 'gloves', label = 'Blue Protective Gloves', image = 'gloves.png', minGrade = 0,
    male = { components = { { component_id = 3, drawable = 85, texture = 0 } } },
    female = { components = { { component_id = 3, drawable = 0, texture = 0 } } } },
}
-- Items are issued from the vehicle stock conceptually; this script does not deduct physical trunk stock.
-- Enable these if you want a per-player limit until item is returned via the tablet.
Config.TrackIssuedItems = true
