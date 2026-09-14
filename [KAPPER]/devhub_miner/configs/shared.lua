Shared = {} 

Shared.CalculateNeedXP = function(level)
    return math.floor(100 * (level ^ 1.5))
end 

Shared.Debug = {
    Enabled = false, -- Set to false to disable all debug prints
    Levels = {
        Info = true,    -- General information
        Success = true, -- Success operations
        Warning = true  -- Warnings and potential issues
    }
}

-- Make sure Core.GetJob is working in devhub_lib
Shared.JobRequired = false -- To enable the job, change it to the job name  (e.g. "miner"), otherwise set it to false

Shared.Economy = {
    xp = 100,
    money = 250,
    mulitplerPerLevel = 0.01,
}
Shared.QuestsEnabled = true

-- Do you want to enable the skill tree?
-- This script must be ensured after devhub_skillTree
-- If you want to buy our skill tree, you can find it https://store.devhub.gg/product/6440792-1
-- Shared.SkillTreeEnabled = false
Shared.SkillTreeEnabled = false
 
-- It will give the player extra rewards during mining and smelting
-- If you want to enable the extra rewards, set it to true otherwise set it to false
Shared.ExtraRewardsEnabled = false
 
Shared.Quests = {
    {
        uid = "diamond",
        description = "Collect diamonds",
        value = 2,
        reward = {
            xp = 1000,
            money = 1000,
        },
        icon = "",
        rewardMultiplerPerLevel = 0.1,
        questMultiplerPerLevel = 0.8,
    },
    {
        uid = "emerald",
        description = "Collect emeralds",
        value = 2,
        reward = {
            xp = 1000,
            money = 1000,
        },
        icon = "",
        rewardMultiplerPerLevel = 0.1,
        questMultiplerPerLevel = 0.8,
    },
    {
        uid = "ruby",
        description = "Collect ruby",
        value = 2,
        reward = {
            xp = 1000,
            money = 1000,
        },
        icon = "",
        rewardMultiplerPerLevel = 0.1,
        questMultiplerPerLevel = 0.8,
    },
    {
        uid = "gold",
        description = "Collect gold",
        value = 2,
        reward = {
            xp = 1000,
            money = 1000,
        },
        icon = "",
        rewardMultiplerPerLevel = 0.1,
        questMultiplerPerLevel = 0.8,
    },
    {
        uid = "silver",
        description = "Collect silver",
        value = 2,
        reward = {
            xp = 1000,
            money = 1000,
        },
        icon = "",
        rewardMultiplerPerLevel = 0.1,
        questMultiplerPerLevel = 0.8,
    },
    {
        uid = "steel",
        description = "Collect steel",
        value = 2,
        reward = {
            xp = 1000,
            money = 1000,
        },
        icon = "",
        rewardMultiplerPerLevel = 0.1,
        questMultiplerPerLevel = 0.8,
    },
} 
 
Shared.Ores = {
    {
        props = {
            "dh_miner_ore_diamond1",
            "dh_miner_ore_diamond3",
        },
        item = "diamond",
        label = "Diamond",
        blip = {
            enabled = false,
            sprite = 617,
            color = 5,
            scale = 0.7,
            coords = vec3(2928.759033, 2745.326660, 53.625084),
        },
        maxInQuest = 3,
        amountOnMap = 5,
        chanceToDrop = 80,
        coords = {
            vec3(2928.759033, 2745.326660, 53.625084),
            vec3(2958.731445, 2830.047607, 45.081127),
            vec3(2990.866943, 2784.648193, 43.835526),
            vec3(2997.540283, 2762.903809, 42.800682),
            vec3(2967.741943, 2723.511963, 54.121178),
            vec3(2952.428711, 2835.491943, 46.422455),
            vec3(2984.383301, 2748.844727, 56.666382),
            vec3(2992.634277, 2781.300293, 43.481079),
            vec3(2991.972412, 2771.969727, 42.849205),
            vec3(2902.178223, 2777.091309, 54.411907),
            vec3(2934.795654, 2863.040283, 57.244537),
            vec3(2917.253418, 2820.676514, 53.847889),
            vec3(2924.778076, 2824.868164, 52.750572),
            vec3(2957.620850, 2778.088867, 40.269775),
            vec3(2980.739014, 2839.824219, 55.860229),
            vec3(3004.087158, 2776.118652, 43.043076),
            vec3(2953.705811, 2814.083496, 42.120270),
        },
        ExtraRewards = { -- if you want to enable the extra rewards, set Shared.ExtraRewardsEnabled to true
            {
                itemName = "ore", -- the item the player receives during mining
                mineAmount = 1, -- the amount of items the player receives during mining
                smeltingRewardItem = "ingot", -- the item the player receives during smelting
                smeltingAmount = 1, -- the amount of items the player receives during smelting
                smeltingChance = 50 -- the chance (in %) to receive the item during smelting, item from mining will be removed
            },
        }
    },
    {
        props = {
            "dh_miner_ore_emerald1",
            "dh_miner_ore_emerald3",
        },
        blip = {
            enabled = false,
            sprite = 617,
            color = 5,
            scale = 0.7,
            coords = vec3(2939.125488, 2882.049805, 59.872528),
        },
        item = "emerald",
        label = "Emerald",
        maxInQuest = 3,
        amountOnMap = 5,
        chanceToDrop = 80,
        coords = {
            vec3(2939.125488, 2882.049805, 59.872528),
            vec3(2978.171143, 2733.334229, 54.395943),
            vec3(2993.338379, 2799.915283, 43.927074),
            vec3(2977.043701, 2761.892578, 43.071716),
            vec3(2987.590576, 2810.895508, 44.877907),
            vec3(2971.633057, 2728.502441, 54.167522),
            vec3(2938.804199, 2722.379883, 54.188156),
            vec3(2978.380371, 2739.631592, 55.180435),
            vec3(2941.433350, 2866.467529, 57.722805),
            vec3(2920.208496, 2757.511719, 53.658649),
            vec3(2943.053467, 2837.715332, 47.415371),
            vec3(2960.295410, 2779.826416, 40.213387),
            vec3(2929.146484, 2797.916504, 41.000847),
            vec3(2972.899414, 2760.347900, 43.027573),
            vec3(2988.904541, 2775.996582, 42.926502),
        },
        ExtraRewards = { -- if you want to enable the extra rewards, set Shared.ExtraRewardsEnabled to true
            {
                itemName = "ore", -- the item the player receives during mining
                mineAmount = 1, -- the amount of items the player receives during mining
                smeltingRewardItem = "ingot", -- the item the player receives during smelting
                smeltingAmount = 1, -- the amount of items the player receives during smelting
                smeltingChance = 50 -- the chance (in %) to receive the item during smelting, item from mining will be removed
            },
        }
    },
    {
        props = {
            "dh_miner_ore_gold1",
        },
        blip = {
            enabled = false,
            sprite = 617,
            color = 5,
            scale = 0.7,
            coords = vec3(3008.315918, 2756.031982, 54.130589),
        },
        item = "gold",
        label = "Gold",
        maxInQuest = 3,
        amountOnMap = 5,
        chanceToDrop = 80,
        coords = {
            vec3(3008.315918, 2756.031982, 54.130589),
            vec3(2944.250977, 2811.444824, 42.025764),
            vec3(2963.620361, 2718.055664, 54.576271),
            vec3(2988.578613, 2790.696289, 43.984936),
            vec3(2991.082520, 2733.840088, 54.845688),
            vec3(2985.413574, 2754.432373, 42.688755),
            vec3(3013.645020, 2760.748291, 54.099449),
            vec3(2978.509033, 2749.737793, 42.974510),
            vec3(2984.780518, 2828.375488, 55.581692),
        },
        ExtraRewards = { -- if you want to enable the extra rewards, set Shared.ExtraRewardsEnabled to true
            {
                itemName = "ore", -- the item the player receives during mining
                mineAmount = 1, -- the amount of items the player receives during mining
                smeltingRewardItem = "ingot", -- the item the player receives during smelting
                smeltingAmount = 1, -- the amount of items the player receives during smelting
                smeltingChance = 50 -- the chance (in %) to receive the item during smelting, item from mining will be removed
            },
        }
    },
    {
        props = {
            "dh_miner_ore_steel2",
            "dh_miner_ore_steel1"
        },
        blip = {
            enabled = false,
            sprite = 617,
            color = 5,
            scale = 0.7,
            coords = vec3(2983.770508, 2812.955078, 44.331402),
        },
        item = "steel",
        label = "Steel",
        maxInQuest = 3,
        amountOnMap = 5,
        chanceToDrop = 80,
        coords = {
            vec3(2983.770508, 2812.955078, 44.331402),
            vec3(2912.722412, 2815.518799, 54.271591),
            vec3(2953.680908, 2786.752197, 41.468056),
            vec3(2981.723877, 2818.188965, 44.724575),
            vec3(3002.111572, 2782.376953, 43.540409),
            vec3(2989.232666, 2816.856689, 56.013763),
            vec3(2945.453125, 2719.741211, 54.319386),
            vec3(2931.829590, 2801.350342, 41.350513),
            vec3(2952.514160, 2832.994141, 46.304939),
            vec3(2956.119873, 2856.259521, 57.301765),
            vec3(2935.003906, 2791.466309, 40.258930),
            vec3(2989.790039, 2822.568115, 55.388447),
        },
        ExtraRewards = { -- if you want to enable the extra rewards, set Shared.ExtraRewardsEnabled to true
            {
                itemName = "ore", -- the item the player receives during mining
                mineAmount = 1, -- the amount of items the player receives during mining
                smeltingRewardItem = "ingot", -- the item the player receives during smelting
                smeltingAmount = 1, -- the amount of items the player receives during smelting
                smeltingChance = 50 -- the chance (in %) to receive the item during smelting, item from mining will be removed
            },
        }
    },
    { 
        props = {
            "dh_miner_ore_silver1",
            "dh_miner_ore_silver2",
            "dh_miner_ore_silver3",
        }, 
        blip = {
            enabled = false,
            sprite = 617,
            color = 5,
            scale = 0.7,
            coords = vec3(2998.973145, 2789.621826, 43.787643),
        },
        item = "silver",
        label = "Silver",
        maxInQuest = 3,
        amountOnMap = 5,
        chanceToDrop = 80,
        coords = {
            vec3(2998.973145, 2789.621826, 43.787643),
            vec3(2932.276611, 2853.030762, 56.345093),
            vec3(2944.711670, 2788.690674, 40.179852),
            vec3(2985.668701, 2762.770020, 42.726658),
            vec3(2998.314209, 2804.173096, 55.110527),
            vec3(2946.494873, 2872.381104, 58.387623),
            vec3(3005.042725, 2771.062256, 42.890720),
            vec3(3013.436035, 2777.269043, 53.652424),
            vec3(2989.912598, 2802.761230, 44.018745),
            vec3(2948.161865, 2858.631104, 57.178249),
            vec3(2961.307617, 2858.097900, 57.293587),
            vec3(2915.008301, 2765.996582, 53.362713),
            vec3(3015.733154, 2766.360107, 54.050198),
            vec3(3011.167480, 2783.982422, 53.626438),
            vec3(2950.938477, 2837.109375, 46.672943),
            vec3(2994.208496, 2758.333008, 42.805279),
            vec3(2956.027344, 2717.930664, 54.618683),
            vec3(2969.876221, 2757.362549, 43.142487),
            vec3(2946.163086, 2878.538574, 59.060921),
            vec3(2984.755859, 2795.172119, 43.876381),
            vec3(2905.228516, 2811.264648, 54.013142),
            vec3(2986.473389, 2806.641602, 44.016357),
            vec3(2900.673828, 2789.779053, 54.541084),
            vec3(2961.594482, 2820.615967, 43.632992),
            vec3(2969.302246, 2852.435303, 57.111328),
            vec3(2942.401611, 2852.898926, 57.481915),
            vec3(2900.509766, 2783.513428, 54.568634),       
        },
        ExtraRewards = { -- if you want to enable the extra rewards, set Shared.ExtraRewardsEnabled to true
            {
                itemName = "ore", -- the item the player receives during mining
                mineAmount = 1, -- the amount of items the player receives during mining
                smeltingRewardItem = "ingot", -- the item the player receives during smelting
                smeltingAmount = 1, -- the amount of items the player receives during smelting
                smeltingChance = 50 -- the chance (in %) to receive the item during smelting, item from mining will be removed
            },
        }
    },
    {
        props = {
            "dh_miner_ore_ruby1",
            "dh_miner_ore_ruby3",
        },
        blip = {
            enabled = false,
            sprite = 617,
            color = 5,
            scale = 0.7,
            coords = vec3(2933.024902, 2831.664551, 50.145138),
        },
        item = "ruby",
        label = "Ruby",
        maxInQuest = 3,
        amountOnMap = 5,
        chanceToDrop = 80,
        coords = {
            vec3(2933.024902, 2831.664551, 50.145138),
            vec3(2903.570801, 2795.077637, 54.511635),
            vec3(2935.034180, 2805.164551, 41.736118),
            vec3(2965.779297, 2757.805176, 43.195141),
            vec3(3004.400146, 2750.242920, 53.980133),
            vec3(2946.519287, 2836.282227, 47.325645),
            vec3(3001.461914, 2767.593018, 42.879803),
            vec3(2940.318604, 2831.856201, 49.359016),
            vec3(3006.408691, 2793.086182, 53.943748),
            vec3(2992.751221, 2779.030029, 43.285358),
            vec3(2935.980957, 2732.318848, 54.251873),
            vec3(2950.834473, 2716.297852, 54.582573),
            vec3(2987.951172, 2768.601318, 42.968529),
            vec3(2929.977783, 2859.620117, 56.326054),
            vec3(2903.604980, 2804.727295, 54.394188),     
        },
        ExtraRewards = { -- if you want to enable the extra rewards, set Shared.ExtraRewardsEnabled to true
            {
                itemName = "ore", -- the item the player receives during mining
                mineAmount = 1, -- the amount of items the player receives during mining
                smeltingRewardItem = "ingot", -- the item the player receives during smelting
                smeltingAmount = 1, -- the amount of items the player receives during smelting
                smeltingChance = 50 -- the chance (in %) to receive the item during smelting, item from mining will be removed
            },
        }
    }, 
}

 
Shared.Lang = {
    -- UI
    -- hud
    ['Your'] = "Your",
    ['Mission'] = "Mission",
    ['Team'] = "Team",
    -- minigame
    ['Miner'] = "Miner",
    ['Minigame'] = "Minigame",
    ['Time'] = "Time",
    ['Left'] = "Left",
    ['Task'] = "Task",
    ['Progress'] = "Progress",
    ['minigame_winner'] = "You have won",
    ['minigame_loser'] = "You have lost",
    ['Minigame_instruction'] = "⛏️ Miner Mini-Game Instructions ⛏️<br><br> In this mini-game, players must click on the highlighted <span style='color:#4CA64C'>green</span> area within a time limit. If they click on a <span style='color:#FF5D5D'>red</span>  area or miss the green area, they lose the game. ",
    -- mainUI
    ['JobName'] = "Miner",
    ['Job'] = "Job",
    ['CurrentLevel'] = "Level %{currentLevel}",
    ['RequiredXp'] = "Required xp",
    ['Select'] = "Select",
    ['JobUniform'] = "Job Uniform",
    ['JobVehicle'] = "Job Vehicle",
    ['Top3'] = "Top 3",
    ['Leaderboard'] = "Leaderboard",
    ['YourPosition'] = "Your Position",
    ['PlayerLevel'] = "Level %{level}",
    ['Tasks'] = "Tasks",
    ['JobDetails'] = "Job Details",
    ['JobDescription'] = "As a miner, your job is to extract raw ores from designated mining areas. Once you've gathered enough ores, you transport them to a smelting facility where they are refined into bars. After refining, take the bars to the jeweler, who will purchase them from you.",
    ['Rewards'] = "Rewards",
    ['LevelMultiplier'] = "Level Multiplier",
    ['InvitePlayer'] = "Invite Player",
    ['StartJob'] = "Start Job",
    ['Quests'] = "Quests",
    ['QuestNumber'] = "Quest #%{number}",
    ['PlayerId'] = "Player Id",
    ['Invite'] = "Invite",
    ['AreYouSureRemove'] = "Are you sure you want to remove %{userName} form your group?",
    ['AreYouSureLeave'] = "Are you sure you want to leave the group?",
    ['StopJob'] = "Stop Job",
    ['AreYouSureStopJob'] = "Make sure your vehicle is close by and it is empty.",
    -- missionComplete
    ['EarnedXp'] = "Earned xp",
    ['ReceivedMoney'] = "Received money",
    ['Mission'] = "Mission",
    ['Completed'] = "Completed",
    ['FinishedIn'] = "Finished in %{time}",
    ['YourScore'] = "Your score",
    ['TeamPlace'] = "Team place",
    --popup
    ['Cancel'] = "Cancel",
    ['Confirm'] = "Confirm",
    
    -- Script
    ["player_too_far"] = "Player is too far away",
    ["party_invite"] = "Party Invite",
    ["invite_text"] = "You have been invited to group. Do you want to join?",
    ["accept"] = "Accept",
    ["decline"] = "Decline",
    ["group_member_too_far"] = "One of the group members is too far away",
    ["vehicle_not_found"] = "Vehicle not found",
    ["not_enough_money"] = "You don't have enough money",
    ["spawn_point_occupied"] = "Vehicle spawn point is occupied",
    ["quest_finished"] = "You have finished quest",
    ["work_started"] = "You have started the work. Your task is to dig up the right amount of ore.",
    ["ores_collected"] = "You have collected the right amount of ores. Now you have to smelt them. GPS has been updated.",
    ["ores_smelted"] = "You have smelted the ores. Now you have to sell them. GPS has been updated.",
    ["cannot_collect_ores"] = "You can't collect ores right now",
    ["max_amount_reached"] = "You have reached the maximum amount of %{ore}",
    ["cannot_collect_specific"] = "You can't collect %{ore}",
    ["ore_found"] = "You have found %{ore}",
    ["ore_not_found"] = "You have failed to find %{ore}",
    ["wrong_vehicle"] = "You didn't bring the right vehicle",
    ["sell_ingots"] = "Sell ingots",
    ["start_smelting"] = "Start smelting",
    --added in v.1.0.2  
    ["player_is_not_miner"] = "This player is not a miner",
    ["you_need_to_be_miner"] = "You need to be a miner to access this menu",
    ["job_name"] = "Miner job",
     --added in v.1.0.4
    ["sell_the_ingots"] = "Sell the ingots",
    ["collect"] = "Collect ",
    ["smelt"] = "Smelt",
    ["invite_received"] = "You received an invite from ",
    ["N/A"] = "N/A",
    -- added in v.1.0.5
    ["added_to_group"] = "You have been added to the group",
    -- added in 1.0.9
    ['job_finished']  = "Job finished! You have earned %{xp} xp and %{money} money.", -- only if Config.DisableFinishPopup is true
    ['are_you_sure'] = "Are you absolutely sure?",
    ['this_is_really_important'] = "This is really important",
}

-- added in v.1.0.5
Shared.SoundVolume = 0.2 -- in game sound volume