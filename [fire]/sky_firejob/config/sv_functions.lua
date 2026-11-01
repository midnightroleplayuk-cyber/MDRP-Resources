if not Citizen.Await(SkyJobsReady) then return end

Config.Functions = Config.Functions or {}

-- Server-only dispatch hook for individual fires and missions.
-- context contains title, message, coords, jobs and meta (sourceKey/sourceId/category,
-- plus mission keywordCode, keywordJob, scenarioKey and triggerMode when applicable).
-- source is the initiating player ID, or 0 for missions/server-created fires.
-- Replace the provider call below to forward dispatches to another resource.
-- Return true or a dispatch table on success; false/nil, error_code, error_message on failure.
-- External providers are responsible for their own dispatch lifecycle/cleanup.
-- This code hook is intentionally excluded from /jobconfig.
Config.Functions.sendDispatch = function(source, context)
    local meta = context.meta
    meta.source = source > 0 and source or nil

    return exports["sky_jobs_base"]:createDispatch(
        context.title,
        context.message,
        context.coords,
        context.jobs,
        meta
    )
end
