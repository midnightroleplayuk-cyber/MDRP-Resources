if not Shared then Shared = {} end
 
Shared.CalculateNeedXP = function(level)
    return math.floor(100 * (level ^ 1.5))
end 

Shared.Economy = {
    xp = 100,
    money = 250,
    mulitplerPerLevel = 0.01,
}

-- Do you want to enable the skill tree?
-- This script must be ensured after devhub_skillTree
-- If you want to buy our skill tree, you can find it https://store.devhub.gg/product/6440792-1
Shared.SkillTreeEnabled = true

Shared.JobRequired = false -- If you want to require a job to access the job menu, set it to job name

Shared.SoundVolume = 0.25  -- in game sound volume

Shared.QuestsEnabled = true

Shared.Quests = {
    {
        uid = "pick_up_trash",
        description = "Pick up trash",
        value = 15,
        reward = {
            xp = 1000,
            money = 1000,
        },
        icon = "",
        rewardMultiplerPerLevel = 0.1,
        questMultiplerPerLevel = 0.8,
    },
    {
        uid = "pour_chlorine",
        description = "Pour chlorine",
        value = 9,
        reward = {
            xp = 1000,
            money = 1000,
        },
        icon = "",
        rewardMultiplerPerLevel = 0.1,
        questMultiplerPerLevel = 0.8,
    },
    {
        uid = "open_valve",
        description = "Open valve",
        value = 6,
        reward = {
            xp = 1000,
            money = 1000,
        },
        icon = "",
        rewardMultiplerPerLevel = 0.1,
        questMultiplerPerLevel = 0.8,
    },
    {
        uid = "clean_pool_floor",
        description = "Clean pool floor",
        value = 5,
        reward = {
            xp = 1000,
            money = 1000,
        },
        icon = "",
        rewardMultiplerPerLevel = 0.1,
        questMultiplerPerLevel = 0.8,
    },
}

Shared.Debug = false -- If you want to see debug messages in the console, set it to true

Shared.Lang = {
    ['JobName'] = "Pool Cleaner",
    ['JobDescription'] = "As a pool cleaner, your job is to travel to assigned properties and clean swimming pools. Start by removing debris from the water surface and pool floor. Then, check and balance the water’s chemical levels to ensure safety. Clean the pool walls and filters, and inspect equipment like pumps. After the pool is spotless and functioning properly, report the job as completed and collect your payment.",
    ['job_name'] = "Pool Cleaner",
    ["work_started"] = "You have started the work. Your task is to locate and clean designated pools.",
    -- mainUi
    ['Your'] = "Your",
    ['Mission'] = "Mission",
    ['Team'] = "Team",
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
    ['Rewards'] = "Rewards",
    ['LevelMultiplier'] = "Level Multiplier",
    ['InvitePlayer'] = "Invite Player",
    ['StartJob'] = "Start Job",
    ['Quests'] = "Quests",
    ['QuestNumber'] = "Quest #%{number}",
    ['PlayerId'] = "Player Id",
    ['Invite'] = "Invite",
    ["N/A"] = "N/A",
    ['AreYouSureRemove'] = "Are you sure you want to remove %{userName} form your group?",
    ['AreYouSureLeave'] = "Are you sure you want to leave the group?",
    ['StopJob'] = "Stop Job",
    ['AreYouSureStopJob'] = "Make sure your vehicle is close by and it is empty.",
    ['EarnedXp'] = "Earned xp",
    ['ReceivedMoney'] = "Received money",
    ['Mission'] = "Mission",
    ['Completed'] = "Completed",
    ['FinishedIn'] = "Finished in %{time}",
    ['YourScore'] = "Your score",
    ['TeamPlace'] = "Team place",
    ['Cancel'] = "Cancel",
    ['Confirm'] = "Confirm",
    ["added_to_group"] = "You have been added to the group",
    ['go_to_next_location'] = "Go to the next location",
    ["player_is_not_employee"] = "This player is not a employee",
    ["you_need_to_be_employee"] = "You need to be a employee to access this menu",
    ["wrong_vehicle"] = "You didn't bring the right vehicle",
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
    ["sell"] = "Receive Payment",
    --script
    ['pick_up_trash'] = "Pick up trash",
    ['pour_chlorine'] = "Pour chlorine",
    ['open_valve'] = "Open valve",
    ['clean_pool_floor'] = "Clean pool floor",
    ['fully_cleaned'] = "Fully cleaned",
    ['valve_already_opened'] = "Valve already opened",
    ['sale'] = "Collect your salary",
    ['robot_pool_cleaner'] = "Use robot pool cleaner",
    ['robot_controls'] = "<kbd>W</kbd> - Move Forward, <kbd>A</kbd> - Rotate Left, <kbd>D</kbd> - Rotate Right, <kbd>BACKSPACE</kbd> - Exit",
    ['job_finished']  = "Job finished! You have earned %{xp} xp and %{money} money.", -- only if Config.DisableFinishPopup is true
    ['are_you_sure'] = "Are you absolutely sure?",
    ['this_is_really_important'] = "This is really important",
    ['valve_opening_progress'] = "Rotation progress: %{progress}%"
}