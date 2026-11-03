-- Shared inventory-backed containers used by Jobs Base.
--
-- The item names are deliberately resource-owned so every job can use the
-- same physical case. Inventory-specific item definitions are documented in
-- config/inventory/README.md and config/inventory/items_ox.lua.
Config.ItemContainers = {
    enabled = true,
    nativeOxProperties = true,
    items = {
        {
            name = "sky_briefcase",
            label = "Briefcase",
            description = "A lockable case for documents and work materials.",
            weight = 1500,
            slots = 24,
            maxWeight = 25000,
            allowlistEnabled = true,
            allowlist = { "sky_case_folder", "job_document", "doj_document", "doj_law_book" },
            blacklist = { "sky_briefcase" },
            autoShowWhenOwned = true,
            hiddenByDefault = true,
            attachment = {
                model = "prop_ld_case_01",
                bone = 57005,
                offset = { x = 0.15, y = 0.0, z = -0.01 },
                rotation = { x = -90.0, y = -90.0, z = 0.0 },
                rotationOrder = 3, -- Native XZY matches the grip's Blender YZX transform.
                collision = false,
                animation = {
                    dict = "sky_briefcase_grip",
                    name = "grip",
                    flag = 305, -- Loop + upper body + secondary + additive; preserve normal body movement.
                },
            },
        },
        {
            name = "sky_case_folder",
            label = "Case Folder",
            description = "A folder for case files and loose documents.",
            weight = 450,
            slots = 12,
            maxWeight = 8000,
            blacklist = { "sky_briefcase", "sky_case_folder" },
            autoShowWhenOwned = false,
        },
    },
}
