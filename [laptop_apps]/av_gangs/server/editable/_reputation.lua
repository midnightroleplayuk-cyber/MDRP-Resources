Config = Config or {}

-- Reputation points are just to keep track of gang members activities in the server
-- Higher Rep means the member has been active doing different activities for the gang
-- Check the docs for the add/removeReputation() exports and use them in your own scripts like robberies, drugs, etc...

Config.GraffitiReputation = {
    enabled = true, -- give rep points for placing graffiti
    points = 10, -- amount to add
}

Config.RemoveGraffitiReputation = {
    enabled = true, -- give rep points when removing a rival graffiti
    points = 20, -- amount to add
}

Config.RobNPCReputation = {
    enabled = true, -- add rep points when robbing a rival gang npc
    points = 1, -- amount to add
}