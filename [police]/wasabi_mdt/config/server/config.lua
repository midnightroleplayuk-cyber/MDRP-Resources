-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

ServerConfig = {}

-- page size for list endpoints (don't crank maxLimit too high)
ServerConfig.Pagination = {
    defaultLimit = 30,
    maxLimit = 100,
}

-- write active calls to DB so they survive a restart
ServerConfig.PersistDispatch = false

-- caps for the report link graph so huge link webs don't explode the payload
ServerConfig.LinkGraph = {
    maxNodes = 60,
    maxDepth = 2,
}

-- pull alerts from ps-dispatch / cd_dispatch into MDT (off by default)
ServerConfig.IngestExternalDispatch = false

-- discord audit webhook — url lives in opensource.lua
ServerConfig.AuditLog = {
    enabled = false,
    -- flip these per action type
    logCreate = true,
    logDelete = true,
    logServe = true,
    logClose = true,
}

-- hourly version check against wasabi_mdt tracker
ServerConfig.UpdateCheck = {
    enabled = true,
}
