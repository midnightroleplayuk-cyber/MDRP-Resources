-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

-- Permission identifiers are v2 integration contracts. Default grade policy is
-- assembled in config/shared/config.lua and can be overridden per department:
-- permissions = Config.BuildDepartmentPermissions({
--     ['mdt.announcements.create'] = { 3, 4, 5 },
--     ['mdt.evidence.delete'] = false,
-- })
Config.Departments.police = {
    label = 'Los Santos Police Department',
    color = '#3b82f6',
    logo = '', -- Image URL/path; leave blank to use the default shield icon
    permissions = Config.BuildDepartmentPermissions(),
}
