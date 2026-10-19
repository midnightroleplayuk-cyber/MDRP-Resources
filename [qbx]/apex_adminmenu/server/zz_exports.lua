-- ============================================================
-- Apex Admin — public server exports
-- ------------------------------------------------------------
-- Loaded last (file name starts with `zz_`) so every helper it
-- references already exists. Downstream resources interact with
-- the admin panel through these exports rather than calling the
-- internal functions directly.
-- ============================================================

-- True if the player can open the panel at all.
exports('IsStaff', function(src)
    if not src or src == 0 then return false end
    return PanelCanOpen and PanelCanOpen(src) or false
end)

-- Permission check using the panel's `category.action` keys
-- (e.g. `players.ban`, `vehicles.*`, `*`).
exports('HasAdminPerm', function(src, perm)
    if not src or not perm or perm == '' then return false end
    return PanelHasPerm and PanelHasPerm(src, perm) or false
end)

-- Returns the staff group name + table for a player, or nil if
-- they aren't staff.
exports('GetStaffGroup', function(src)
    if not src or not PanelGetGroup then return nil end
    local name, grp = PanelGetGroup(src)
    return name, grp
end)

-- Append a log row (also pushes to the Event Logs feed + Discord).
exports('Log', function(src, category, action, target, target_lic, details)
    if PanelLog then PanelLog(src, category, action, target, target_lic, details) end
end)

-- Fire a Discord webhook in a specific category. `embed` is the
-- raw Discord embed object.
exports('Discord', function(category, embed)
    if PanelDiscordSend then PanelDiscordSend(category, embed) end
end)

-- Trigger an announce — same payload shape the panel modal builds.
-- Useful for other scripts that want to push a slide-in card.
exports('Announce', function(payload)
    if type(payload) ~= 'table' then return end
    TriggerEvent('apex_adminmenu:panel:announce', payload)
end)

-- Push a real-time alert to the Home dashboard alerts panel.
exports('AddAlert', function(severity, title, message)
    if PanelAddAlert then PanelAddAlert(severity, title, message) end
end)

-- Feed an arbitrary event into the Event Logs live feed.
exports('CaptureEvent', function(name, src, ...)
    if PanelCaptureEvent then PanelCaptureEvent(name, src, ...) end
end)
