-- Resource allowlist. Add another Job Configurator resource to enable its printers.
-- Crime resources are intentionally absent from the shipped defaults.
Config.Printers = {
    enabled = true,
    resources = {
        sky_ambulancejob = true,
        sky_policejob = true,
        sky_mechanicjob = true,
        sky_dojjob = true,
        sky_firejob = true,
        -- Stable configurator key; the runtime resource is sky_jobcreator.
        sky_jobscreator = true,
    },
    secondsPerDocument = 6.0,
    -- Fixed job-record layouts. Only stationery images can be changed per job.
    documentAppearance = { leftImage = "", rightImage = "", watermark = "" },
    -- Defaults for jobs without an explicit printerSettings override.
    queueEnabled = true,
    inkEnabled = false,
    inkCapacity = 1200,
    inkPerDocument = 1,
    inkRefillItem = "printer_ink",
    inkRefillAmount = 1200,
    -- Extra active-print time; FIFO, missing supplies and paper jams pause this timeout.
    queueTimeoutSeconds = 60,
    -- Only applies with paperEnabled. Set jamChance to 0 to disable random jams.
    jamChance = 0.08,
    maintenanceTimeoutSeconds = 45,
    models = {
        { model = "sky_printer_01", class = "office" },
        { model = "prop_printer_01", class = "office" },
        { model = "prop_printer_02", class = "office" },
        { model = "v_res_printer", class = "standard" },
        { model = "v_ret_gc_print", class = "standard" },
        { model = "prop_copier_01", class = "professional" },
        { model = "v_med_cor_photocopy", class = "professional" },
    },
}
