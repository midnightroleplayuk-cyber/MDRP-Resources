Config.Graffiti = {
    requireApproval = true,   -- new designs wait for staff approval in /gangadmin
    allowPictures   = true,   -- picture tags from an image link (always need staff approval);
                              -- links must be on Config.Logos.allowedHosts
    maxDesigns      = 3,      -- saved designs per gang
    maxTextLength   = 14,

    sprayItem   = 'spraycan', -- false = no item needed
    consumeItem = true,       -- one can per tag / cross-out

    sprayTime    = 8000,      -- ms
    crossTime    = 4000,
    cleanTime    = 10000,
    cooldown     = 120,       -- seconds between sprays per player (these four timings can be changed in game: /gangadmin > Tags in world)

    maxDistance  = 3.0,       -- how far from the wall you can spray
    surfaces     = { walls = true, floors = true, ceilings = false }, -- floors include ramps and steps
    onlyInAreas  = true,      -- tags can only go up inside an area (outside, they'd earn no influence)
    surfaceGap   = 0.012,     -- metres the tag is drawn off the surface (smaller = closer, too small can flicker)
    minSpacing   = 2.0,       -- metres between active tags
    maxPerZone   = 6,         -- active tags per gang per zone
    minWidth     = 0.8,
    maxWidth     = 2.4,
    defaultWidth = 1.4,

    passiveInfluence = 0.6,   -- per active tag, every influence tick
    expiryDays       = 14,    -- tags fade away after this long (0 = never)

    renderDistance = 45.0,
    maxRendered    = 30,

    -- Jobs that can scrub tags off, and what they're paid per tag (bank)
    cleanJobs   = { police = true, sanitation = true },
    cleanReward = 150,

    fonts = {
        { key = 'handstyle', label = 'Handstyle', family = 'Sedgwick Ave Display' },
        { key = 'spray',     label = 'Spray',     family = 'Rubik Spray Paint' },
        { key = 'marker',    label = 'Marker',    family = 'Permanent Marker' },
        { key = 'block',     label = 'Block',     family = 'Bungee' },
    },
    styles = { 'plain', 'outline', 'shadow' },
}
