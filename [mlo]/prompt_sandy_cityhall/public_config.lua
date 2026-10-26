Config = {

    FunctionalElevator = true, --[[ 
        If you dont want the elevator to be functional, set this to false 
        (why in this world anyone would want to disable this?) 

        If this is set to false, an entityset will be spawned in every floor.
    ]]

    EnablePlayerAnimations = true, --[[ 
        If you dont want the player to animate when calling the elevator or close/open the doors, set this to false 
    ]]

    Messages = {
        elevatorMoving = "The elevator is moving",
        wrongFloor = "Invalid floor",
        noAccess = "You don't have access to this elevator",
        floorReached = "You have arrived at floor %s",
        waitingForElevator = "Waiting for elevator...",
        selectFloor = "Select Floor",
        elevatorTitle = "Elevator Control",
        callElevator = "Call elevator",
        
        floors = {
            firstFloor = "First Floor",
            secondFloor = "Second Floor",
            thirdFloor = "Third Floor"
        }
    }
}