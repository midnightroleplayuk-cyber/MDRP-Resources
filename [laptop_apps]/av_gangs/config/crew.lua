Config = Config or {}
Config.UseCrew = GetResourceState('av_groups') ~= "missing" -- only available if using av_groups
Config.CrewMaxMembers = 6 -- Max members a heist crew can have
Config.CrewDefaultState = "Waiting" -- Default state when crew is created