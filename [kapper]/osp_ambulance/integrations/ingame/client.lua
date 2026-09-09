function inGamePlay()
    --[[  
        Add every game getter export like lasertag, paintball, ffa
        disable damage while in a game 
    ]]
    if 
    GetResourceState("nass_paintball") == "started" and exports["nass_paintball"]:inGame() or 
    GetResourceState("pug-paintball") == "started" and exports["pug-paintball"]:IsInPaintball() or
    GetResourceState("rtx_lasergame") == "started" and exports["rtx_lasergame"]:IsPlayerPlayingLaserGame()
    then
        return true
    end
    
    return false
end