Config = Config or {}
Config.PoliceJobs = {"police", "bcso", "leo"} -- will use this jobs/type for cops count

-- Triggered if not enough cops online when trying to start a mission
function copsNotify(playerId)
  TriggerClientEvent('av_laptop:notificationUI', playerId, Lang['app_title'], Lang['no_cops'], 'error')
end

Config.Missions = {
  ['test_mission'] = { -- index key should be an unique identifier, keep it simple
    label = "Test Robbery", -- shown in app as mission title
    price = 2500, -- number or false
    difficulty = 1, -- from 0 to 5
    level = 0, -- min gang level required
    cops = 0, -- min cops online
    image = "https://r2.fivemanage.com/QmVAYSlqeAlD4IxVbdvu5/laundromat.png",
    description = "Lorem, ipsum dolor sit amet consectetur adipisicing elit. Repudiandae fugiat aspernatur illo enim odio id nam qui ad minus quis.",
    isClient = false, -- true it will trigger "event" client side, false will trigger it server side
    event = "av_gangs:testmission", -- server event to trigger or false to use onTrigger function
    autoStarted = true, -- set the mission status to "started" as soon as it's activated
    canStart = function(playerId, gang)
      -- run your own server check and return true to allow player to start mission
      -- this function runs before any removeMoney or cops check
      return true
    end,
    onTrigger = function(playerId, gang) -- This is triggered server side and only available if event = false
      -- You can use this to trigger an export or event
      -- EXAMPLE
      --[[
        exports['my_heist_script']:StartHeist(playerId)
      ]]--
    end,
  },
}

-- THIS IS JUST AN EXAMPLE FOR THE TEST MISSION
RegisterServerEvent('av_gangs:testmission', function(data)
  print("testmission got triggered, yey!")
  print(json.encode(data))
end)