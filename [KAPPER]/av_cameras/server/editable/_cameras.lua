-- List of camera items, you can add as many as you want here
Config = Config or {}
Config.CameraItems = {
    ['gopro'] = { -- item name
        canUse = function(playerId) -- add yourn own check to allow player to use this item
            return true -- return true or false
        end,
        -- if true, camera will be marked as technician placed and marked as unassigned in the cameras list
        technician = false,
        settings = {
            modelsList = { 'prop_spycam' }, -- list of camera models, player will be able to choose between them when installing the cameras
            -- Functionality Settings
            expiration = 48, -- in hours, after this time camera will stop working, set to false to disable
            plugged = false, -- if true, cam will be plugged into power source and won't require battery
            rotationAngle = 90, -- 0-360
            -- Vision Modes
            hasNightVision = true,
            hasThermalVision = false,
            -- Features
            allowZoom = true,
            allowVehicleInstall = true,
            allowHacking = true,
            motionDetection = true,
            -- Durability & Damage
            isBreakable = true, -- will break on weapon damage
            damageChance = nil, -- chance in % that cam gets randomly damaged, for technician RP purposes, set to nil to disable
        },
    },
    ['basic_cam'] = { -- item name
        canUse = function(playerId) -- add yourn own check to allow player to use this item
            if Config.UseTechnician then
                local job = exports['av_laptop']:getJob(playerId)
                if job.name ~= Config.TechnicianJobName then
                    return false
                end
            end
            return true
        end,
        -- if true, camera will be marked as technician placed and marked as unassigned in the cameras list
        -- technicians will be required to assign the camera to a player using the Technician App
        technician = Config.UseTechnician,
        settings = {
            modelsList = { -- list of camera models, player will be able to choose between them when installing the cameras
                'prop_cctv_cam_04a',
                'prop_cctv_cam_04b',
                'prop_cctv_cam_04c',
                'prop_cctv_cam_07a',
            },
            -- Functionality Settings
            plugged = false, -- if true, cam will be plugged into power source and won't require battery
            rotationAngle = 90, -- 0-360
            -- Vision Modes
            hasNightVision = true,
            hasThermalVision = false,
            -- Features
            allowZoom = true,
            allowVehicleInstall = false,
            allowHacking = true,
            -- Durability & Damage
            isBreakable = true, -- will break on weapon damage
            damageChance = 10, -- chance in % that cam gets randomly damaged, for technician RP purposes, set to nil to disable
        }
    },
    ['security_cam'] = { -- item name
        canUse = function(playerId) -- add yourn own check to allow player to use this item
            if Config.UseTechnician then
                local job = exports['av_laptop']:getJob(playerId)
                if job.name ~= Config.TechnicianJobName then
                    return false
                end
            end
            return true
        end,
        -- if true, camera will be marked as technician placed and marked as unassigned in the cameras list
        -- technicians will be required to assign the camera to a player using the Technician App
        technician = Config.UseTechnician,
        settings = {
            modelsList = { -- list of camera models, player will be able to choose between them when installing the cameras
                'prop_cctv_cam_04a',
                'prop_cctv_cam_04b',
                'prop_cctv_cam_04c',
                'prop_cctv_cam_07a',
                'prop_cctv_cam_05a',
                'prop_cctv_cam_06a',
            },
            -- Functionality Settings
            plugged = false, -- if true, cam will be plugged into power source and won't require battery
            rotationAngle = 180, -- 0-360
            -- Vision Modes
            hasNightVision = true,
            hasThermalVision = false,
            -- Features
            allowZoom = true,
            allowVehicleInstall = false,
            allowHacking = true,
            motionDetection = true,
            -- Durability & Damage
            isBreakable = true, -- will break on weapon damage
            damageChance = 5, -- chance in % that cam gets randomly damaged, for technician RP purposes, set to nil to disable
            canBeHacked = true, -- can be hacked by hackers app?
        }
    },
    ['server_cam'] = { -- item name
        canUse = function(playerId) -- add yourn own check to allow player to use this item
            if Config.UseTechnician then
                local job = exports['av_laptop']:getJob(playerId)
                if job.name ~= Config.TechnicianJobName then
                    return false
                end
            end
            return true
        end,
        -- if true, camera will be marked as technician placed and marked as unassigned in the cameras list
        -- technicians will be required to assign the camera to a player using the Technician App
        technician = Config.UseTechnician,
        settings = {
            modelsList = { -- list of camera models, player will be able to choose between them when installing the cameras
                'prop_cctv_cam_04a',
                'prop_cctv_cam_04b',
                'prop_cctv_cam_04c',
                'prop_cctv_cam_07a',
                'prop_cctv_cam_05a',
                'prop_cctv_cam_06a',
            },
            -- Functionality Settings
            plugged = true, -- if true, cam will be plugged into power source and won't require battery
            rotationAngle = 180, -- 0-360
            -- Vision Modes
            hasNightVision = true,
            hasThermalVision = false,
            -- Features
            allowZoom = true,
            allowVehicleInstall = false,
            allowHacking = true,
            motionDetection = false,
            -- Durability & Damage
            isBreakable = true, -- will break on weapon damage
            damageChance = 0, -- chance in % that cam gets randomly damaged, for technician RP purposes, set to nil to disable
            canBeHacked = true, -- can be hacked by hackers app?
            replay = true -- Can record activity when not being viewed and allow replaying it
        }
    },
}