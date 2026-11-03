-- Merge these entries into ox_inventory/data/items.lua.
-- Copy the matching PNG files for the entries that define client.image.
-- Sky_Jobs.Printers removes one item only after a successful refill.
return {
    ["restraint_tool"] = {
        label = "Restraint tool", weight = 200, stack = true, close = true, consume = 0,
        description = "A tool for freeing another person from handcuffs or zipties.",
        client = { image = "wire_cutter.png" },
    },
    ["printer_ink"] = {
        label = "Druckerpatrone", weight = 200, stack = true, close = true, consume = 0,
        description = "Ersatzpatrone zum Nachfüllen eines Druckers.",
        client = { image = "printer_ink.png" },
    },
    ["job_document"] = {
        label = "Dokument", weight = 10, stack = false, close = true, consume = 0,
        description = "Gedruckte Kopie einer Job-Akte.",
        client = { image = "job_document.png" },
    },
    ["printer_paper"] = {
        label = "Druckerpapier",
        weight = 100,
        stack = true,
        close = true,
        consume = 0,
        description = "Papier zum Nachfüllen eines Druckers.",
        client = {
            image = "printer_paper.png",
        },
    },
    ["sky_briefcase"] = {
        label = "Briefcase",
        weight = 1500,
        stack = false,
        close = false,
        consume = 0,
        description = "A lockable case for documents and work materials.",
        client = { image = "sky_briefcase.png" },
        buttons = require "@sky_jobs_base.config.inventory.ox_briefcase_buttons",
    },
    ["sky_case_folder"] = {
        label = "Case Folder",
        weight = 450,
        stack = false,
        close = false,
        consume = 0,
        description = "A folder for case files and loose documents.",
        client = { image = "sky_case_folder.png" },
    },
}
