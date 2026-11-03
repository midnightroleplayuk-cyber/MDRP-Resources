-- luacheck config for FiveM (CfxLua 5.4). Natives are PascalCase globals.
std = 'lua54'
max_line_length = 170
allow_defined_top = true
ignore = {
    '113/[A-Z].*', -- FiveM natives (PascalCase)
    '212',         -- unused arguments (event handler signatures)
    '631',         -- long lines
}
read_globals = {
    'lib', 'cache', 'exports', 'json', 'source', 'vec2', 'vec3', 'vec4', 'vector2', 'vector3', 'vector4',
    'joaat', 'promise', 'Citizen', 'MySQL', 'Wait', 'CreateThread', 'SetTimeout',
}
globals = {
    'Config', 'Locales', '_L', 'LocaleTable',
    'PoolPhysics', 'PoolTables', 'PoolRack', 'PoolRules', 'PoolCalib', 'PoolCalibServer', 'Calibrate', 'LocalView',
    'Bridge', 'ClientBridge', 'Runtime', 'Economy', 'DB', 'Sessions', 'Admin', 'Spawned', 'Logs',
    'Pool', 'NUI', 'Cam', 'Spectate', 'Hud', 'Render', 'Playback', 'Aim', 'Session',
}
exclude_files = { 'html/**' }
files['fxmanifest.lua'] = { ignore = { '113' } }
