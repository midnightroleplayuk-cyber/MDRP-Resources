-- receives the starting checkpoint from the event NOT the racer coords
-- trackId just in case u need it for something
function sendDispatch(trackId, checkpoint)
    local coords = checkpoint['coords']
    if coords then
        -- Add your own dispatch event/export here:
        
    end
end