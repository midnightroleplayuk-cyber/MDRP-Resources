lib.callback.register('av_laptop:getJobList', function(_) -- returns a list of all available jobs in your ESX
    return getAllJobs()
end)