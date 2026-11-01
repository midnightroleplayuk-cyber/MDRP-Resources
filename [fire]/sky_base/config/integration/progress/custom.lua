-- Set Config.progressbar = "custom" to enable this client-side template.
if Sky.Config.progressbar ~= "custom" then return end
if IsDuplicityVersion() then return end

function Sky.Functions.Progress(label_or_data, duration, options, callback)
    -- Support both Progress(data, callback) and Progress(label, duration, options, callback).
    -- Invoke callback(cancelled) when supplied and return true when completed.
    error("Custom progress integration: Progress is not implemented")
end

function Sky.Functions.Bar(label_or_data, duration, options, callback)
    -- Implement a linear progress bar with the same contract as Progress.
    error("Custom progress integration: Bar is not implemented")
end

function Sky.Functions.Circle(label_or_data, duration, options, callback)
    -- Optional circular progress UI. Remove this function when unsupported.
    error("Custom progress integration: Circle is not implemented")
end

Sky.Functions.ProgressBar = Sky.Functions.Progress

function Sky.Functions.CancelProgress()
    error("Custom progress integration: CancelProgress is not implemented")
end

Sky.Functions.CancelBar = Sky.Functions.CancelProgress
Sky.Functions.CancelProgressBar = Sky.Functions.CancelProgress
Sky.Functions.CancelProgressbar = Sky.Functions.CancelProgress
