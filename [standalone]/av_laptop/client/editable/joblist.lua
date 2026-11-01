-- Used for av_business, we need a list of all available jobs on your server
jobsList = {}

function getJobs()
    return lib.callback.await('av_laptop:getJobList')
end

exports("getJobsList", function()
    dbug("getJobsList export")
    return lib.callback.await('av_laptop:getJobList')
end)