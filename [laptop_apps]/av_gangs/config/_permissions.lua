-- Available permissions for members, read the docs > exports if u want to know how to use them in other scripts
Config = Config or {}
Config.Permissions = {
    {value = "members", label = "Members"}, --gives access to manage members in APP
    {value = "missions", label = "Missions"}, --gives access to missions tab in APP
    {value = "properties", label = "Properties"}, --gives access to properties tab in APP
    {value = "market", label = "Market"}, --gives access to black market tab in APP
    -- you can add more permissions, here's an example:
    -- if you have a garage script that supports gangs u can check if it has permissions to open it
--    {value = "garage", label = "Garage"}
}