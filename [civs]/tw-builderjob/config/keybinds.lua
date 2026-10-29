-- Machine keys. Read as RAW KEYBOARD input rather than RegisterKeyMapping, so
-- the bindings live in our own /keys page instead of FiveM's shared list.

Config = Config or {}

Config.Keybinds = {
    pages = {
        { id = 'genel', label = 'General',       lKey = 'kb_page_genel' },
        { id = 'cv2',   label = 'Mobile Crane',  lKey = 'kb_page_cv2'   },
        { id = 'pump',  label = 'Concrete Pump', lKey = 'kb_page_pump'  },
        { id = 'tower', label = 'Tower Crane',   lKey = 'kb_page_tower' },
    },

    actions = {
        { id = 'genel.interact',    page = 'genel', kind = 'tap', shared = true, label = 'Interact (pick up / place / use)', lKey = 'kb_genel_interact',     vk = 69, ctrl = 38 },
        { id = 'genel.remoteTake',  page = 'genel', kind = 'tap', shared = true, label = 'Take / put back remote',           lKey = 'kb_genel_remote_take',  vk = 69, ctrl = 38 },
        { id = 'genel.remoteStart', page = 'genel', kind = 'tap', shared = true, label = 'Start remote control',             lKey = 'kb_genel_remote_start', vk = 69, ctrl = 38 },
        { id = 'genel.cabin',       page = 'genel', kind = 'tap', shared = true, label = 'Enter cabin / take control',       lKey = 'kb_genel_cabin',        vk = 72, ctrl = 74 },
        { id = 'genel.rigGrab',     page = 'genel', kind = 'tap', shared = true, label = 'Grab hook / attach sling',         lKey = 'kb_genel_rig_grab',     vk = 69, ctrl = 38 },
        { id = 'genel.rigRelease',  page = 'genel', kind = 'tap', shared = true, label = 'Release hook',                     lKey = 'kb_genel_rig_release',  vk = 71, ctrl = 47 },
        { id = 'genel.carryDrop',   page = 'genel', kind = 'tap', shared = true, label = 'Put carried item back on pile',    lKey = 'kb_genel_carry_drop',   vk = 88, ctrl = 73 },
        { id = 'genel.taskDetail',  page = 'genel', kind = 'hold', shared = true, label = 'Task list detail (hold)',           lKey = 'kb_genel_task_detail',  vk = 75 },

        { id = 'cv2.slewL',    page = 'cv2', kind = 'hold', label = 'Slew left',            lKey = 'kb_cv2_slew_l',    vk = 65,  ctrl = 34 },
        { id = 'cv2.slewR',    page = 'cv2', kind = 'hold', label = 'Slew right',           lKey = 'kb_cv2_slew_r',    vk = 68,  ctrl = 35 },
        { id = 'cv2.boomUp',   page = 'cv2', kind = 'hold', label = 'Raise main boom',      lKey = 'kb_cv2_boom_up',   vk = 87,  ctrl = 32 },
        { id = 'cv2.boomDn',   page = 'cv2', kind = 'hold', label = 'Lower main boom',      lKey = 'kb_cv2_boom_dn',   vk = 83,  ctrl = 33 },
        { id = 'cv2.teleOut',  page = 'cv2', kind = 'hold', label = 'Extend telescope',     lKey = 'kb_cv2_tele_out',  vk = 38,  ctrl = 172 },
        { id = 'cv2.teleIn',   page = 'cv2', kind = 'hold', label = 'Retract telescope',    lKey = 'kb_cv2_tele_in',   vk = 40,  ctrl = 173 },
        { id = 'cv2.knuckleL', page = 'cv2', kind = 'hold', label = 'Knuckle boom left',    lKey = 'kb_cv2_knuckle_l', vk = 37,  ctrl = 174 },
        { id = 'cv2.knuckleR', page = 'cv2', kind = 'hold', label = 'Knuckle boom right',   lKey = 'kb_cv2_knuckle_r', vk = 39,  ctrl = 175 },
        { id = 'cv2.slow',     page = 'cv2', kind = 'hold', label = 'Slow mode (precise)',  lKey = 'kb_cv2_slow',      vk = 16,  ctrl = 21 },
        { id = 'cv2.winchDn',  page = 'cv2', kind = 'hold', label = 'Lower rope',           lKey = 'kb_cv2_winch_dn',  vk = 1,   ctrl = 24 },
        { id = 'cv2.winchUp',  page = 'cv2', kind = 'hold', label = 'Raise rope',           lKey = 'kb_cv2_winch_up',  vk = 2,   ctrl = 25 },
        { id = 'cv2.exit',     page = 'cv2', kind = 'tap',  label = 'Exit control',         lKey = 'kb_cv2_exit',      vk = 8,   ctrl = 177 },
        { id = 'cv2.drop',     page = 'cv2', kind = 'tap',  label = 'Drop load on ground',  lKey = 'kb_cv2_drop',      vk = 88,  ctrl = 73 },
        { id = 'cv2.hudToggle',page = 'cv2', kind = 'tap',  label = 'Hide / show remote screen', lKey = 'kb_cv2_hud_toggle', vk = 75 },
        { id = 'cv2.camView',  page = 'cv2', kind = 'tap',  label = 'Camera view', lKey = 'kb_cv2_cam_view', vk = 86 },
        { id = 'cv2.camFollow', page = 'cv2', kind = 'tap', label = 'Camera auto-follow', lKey = 'kb_cv2_cam_follow', vk = 66 },

        { id = 'pump.slewL',   page = 'pump', kind = 'hold', label = 'Slew left',           lKey = 'kb_pump_slew_l',   vk = 65,  ctrl = 34 },
        { id = 'pump.slewR',   page = 'pump', kind = 'hold', label = 'Slew right',          lKey = 'kb_pump_slew_r',   vk = 68,  ctrl = 35 },
        { id = 'pump.boomUp',  page = 'pump', kind = 'hold', label = 'Raise main boom',     lKey = 'kb_pump_boom_up',  vk = 87,  ctrl = 32 },
        { id = 'pump.boomDn',  page = 'pump', kind = 'hold', label = 'Lower main boom',     lKey = 'kb_pump_boom_dn',  vk = 83,  ctrl = 33 },
        { id = 'pump.pakOpen', page = 'pump', kind = 'hold', label = 'Open package',        lKey = 'kb_pump_pak_open',  vk = 37,  ctrl = 174 },
        { id = 'pump.pakClose',page = 'pump', kind = 'hold', label = 'Close package',       lKey = 'kb_pump_pak_close', vk = 39,  ctrl = 175 },
        { id = 'pump.tipOpen', page = 'pump', kind = 'hold', label = 'Extend tip section',  lKey = 'kb_pump_tip_open',  vk = 38,  ctrl = 172 },
        { id = 'pump.tipClose',page = 'pump', kind = 'hold', label = 'Retract tip section', lKey = 'kb_pump_tip_close', vk = 40,  ctrl = 173 },
        { id = 'pump.legs',    page = 'pump', kind = 'tap',  label = 'Deploy / stow outriggers', lKey = 'kb_pump_legs',  vk = 71,  ctrl = 47 },
        { id = 'pump.cover',   page = 'pump', kind = 'tap',  label = 'Open / close hopper lid',  lKey = 'kb_pump_cover', vk = 72,  ctrl = 74 },
        { id = 'pump.pour',    page = 'pump', kind = 'tap',  label = 'Start / stop pouring',     lKey = 'kb_pump_pour',  vk = 69,  ctrl = 38 },
        { id = 'pump.exit',    page = 'pump', kind = 'tap',  label = 'Exit control',             lKey = 'kb_pump_exit',  vk = 8,   ctrl = 177 },
        { id = 'pump.hudToggle',page = 'pump', kind = 'tap', label = 'Hide / show remote screen', lKey = 'kb_pump_hud_toggle', vk = 75 },
        { id = 'pump.camView', page = 'pump', kind = 'tap', label = 'Camera view', lKey = 'kb_pump_cam_view', vk = 86 },

        { id = 'tower.slewL',    page = 'tower', kind = 'hold', label = 'Slew left',        lKey = 'kb_tower_slew_l',     vk = 65,  ctrl = 34 },
        { id = 'tower.slewR',    page = 'tower', kind = 'hold', label = 'Slew right',       lKey = 'kb_tower_slew_r',     vk = 68,  ctrl = 35 },
        { id = 'tower.trolleyO', page = 'tower', kind = 'hold', label = 'Trolley forward',  lKey = 'kb_tower_trolley_out',vk = 87,  ctrl = 32 },
        { id = 'tower.trolleyI', page = 'tower', kind = 'hold', label = 'Trolley back',     lKey = 'kb_tower_trolley_in', vk = 83,  ctrl = 33 },
        { id = 'tower.hookDn',   page = 'tower', kind = 'hold', label = 'Lower hook',       lKey = 'kb_tower_hook_dn',    vk = 1,   ctrl = 24 },
        { id = 'tower.hookUp',   page = 'tower', kind = 'hold', label = 'Raise hook',       lKey = 'kb_tower_hook_up',    vk = 2,   ctrl = 25 },
        { id = 'tower.slow',     page = 'tower', kind = 'hold', label = 'Slow mode (precise)', lKey = 'kb_tower_slow',    vk = 16,  ctrl = 21 },
        { id = 'tower.camView',  page = 'tower', kind = 'tap',  label = 'Cabin camera view',   lKey = 'kb_tower_cam_view', vk = 86 },
        { id = 'tower.exit',     page = 'tower', kind = 'tap',  label = 'Leave cabin',         lKey = 'kb_tower_exit',     vk = 8,  ctrl = 177 },
        { id = 'tower.hudToggle',page = 'tower', kind = 'tap',  label = 'Hide key bar',        lKey = 'kb_tower_hud_toggle', vk = 75, ctrl = 311 },
    },
}
