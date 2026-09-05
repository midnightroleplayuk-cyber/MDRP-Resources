--------------------
-- PROGRESS BAR ----
--------------------

function useProgressBar(text, time, animation, freeze, onFinish, onCancel, prop)
    local data = {
        anim = animation,
        prop = prop,
        duration = time,
        label = text,
        useWhileDead = true,
        disable = {
            move = true,
        }
    }
    if lib.progressBar(data) then
        onFinish()
    else 
        onCancel()
    end
end