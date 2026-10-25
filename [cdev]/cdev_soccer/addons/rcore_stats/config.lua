
PublicSharedRCoreStatsConfig = {
    categories = {
        {id = 'minigames', label = 'Minigames'}
    },

    playerStats = {
        {id = "soccer_games_played", label = "Soccer - Games Played", category = "minigames"},
        {id = "soccer_goals_made", label = "Soccer - Goals Made", category = "minigames"},
        {id = "soccer_shots_made", label = "Soccer - Shots Made", category = "minigames"},
        {id = "soccer_save_made", label = "Soccer - Saves Made", category = "minigames"},
        {id = "soccer_passes_made", label = "Soccer - Passes Made", category = "minigames"},
        {id = "soccer_tackles_made", label = "Soccer - Tackles Made", category = "minigames"},
        {id = "soccer_game_wins", label = "Soccer - Game Wins", category = "minigames"},
        {id = "soccer_game_losses", label = "Soccer - Game Losses", category = "minigames"}
    },

    serverStats = {
        {id = "total_games_played", label = "Soccer - Total Games Played", category = "minigames", playerStatId = "soccer_games_played"},
        {id = "total_goals_made", label = "Soccer - Total Goals Made", category = "minigames", playerStatId = "soccer_goals_made"},
        {id = "total_shots_made", label = "Soccer - Total Shots Made", category = "minigames", playerStatId = "soccer_shots_made"},
        {id = "total_save_made", label = "Soccer - Total Saves Made", category = "minigames", playerStatId = "soccer_save_made"},
        {id = "total_passes_made", label = "Soccer - Total Passes Made", category = "minigames", playerStatId = "soccer_passes_made"},
        {id = "total_tackles_made", label = "Soccer - Total Tackles Made", category = "minigames", playerStatId = "soccer_tackles_made"}
    },

    playerAchievements = {
        -- Games Played
        {id = "soccer_game_1", label = "Kickoff Rookie", description = "Play your first game of soccer", icon = "loader-pinwheel", playerStatId = "soccer_games_played", threshold = 1},
        {id = "soccer_game_5", label = "Pitch Regular", description = "Play 5 games of soccer", icon = "loader-pinwheel", playerStatId = "soccer_games_played", threshold = 5},
        {id = "soccer_game_10", label = "Field Veteran", description = "Play 10 games of soccer", icon = "loader-pinwheel", playerStatId = "soccer_games_played", threshold = 10},
        {id = "soccer_game_25", label = "Soccer Enthusiast", description = "Play 25 games of soccer", icon = "loader-pinwheel", playerStatId = "soccer_games_played", threshold = 25},
        {id = "soccer_game_50", label = "Half-Century Hero", description = "Play 50 games of soccer", icon = "loader-pinwheel", playerStatId = "soccer_games_played", threshold = 50},
        {id = "soccer_game_100", label = "Centurion of the Pitch", description = "Play 100 games of soccer", icon = "loader-pinwheel", playerStatId = "soccer_games_played", threshold = 100},
        -- Goals Made
        {id = "soccer_goal_1", label = "First Strike", description = "Score your first goal in soccer", icon = "loader-pinwheel", playerStatId = "soccer_goals_made", threshold = 1},
        {id = "soccer_goal_5", label = "Goal Getter", description = "Score 5 goals in soccer", icon = "loader-pinwheel", playerStatId = "soccer_goals_made", threshold = 5},
        {id = "soccer_goal_10", label = "Double Digits Dynamo", description = "Score 10 goals in soccer", icon = "loader-pinwheel", playerStatId = "soccer_goals_made", threshold = 10},
        {id = "soccer_goal_25", label = "Net Navigator", description = "Score 25 goals in soccer", icon = "loader-pinwheel", playerStatId = "soccer_goals_made", threshold = 25},
        {id = "soccer_goal_50", label = "Scoring Sensation", description = "Score 50 goals in soccer", icon = "loader-pinwheel", playerStatId = "soccer_goals_made", threshold = 50},
        {id = "soccer_goal_100", label = "Goal Machine", description = "Score 100 goals in soccer", icon = "loader-pinwheel", playerStatId = "soccer_goals_made", threshold = 100},
        -- Shots Made
        {id = "soccer_shot_1", label = "Shot Starter", description = "Take your first shot in soccer", icon = "loader-pinwheel", playerStatId = "soccer_shots_made", threshold = 1},
        {id = "soccer_shot_5", label = "Shooter-in-Training", description = "Take 5 shots in soccer", icon = "loader-pinwheel", playerStatId = "soccer_shots_made", threshold = 5},
        {id = "soccer_shot_10", label = "Accuracy Aficionado", description = "Take 10 shots in soccer", icon = "loader-pinwheel", playerStatId = "soccer_shots_made", threshold = 10},
        {id = "soccer_shot_25", label = "Sharp Shooter", description = "Take 25 shots in soccer", icon = "loader-pinwheel", playerStatId = "soccer_shots_made", threshold = 25},
        {id = "soccer_shot_50", label = "Prolific Marksman", description = "Take 50 shots in soccer", icon = "loader-pinwheel", playerStatId = "soccer_shots_made", threshold = 50},
        {id = "soccer_shot_100", label = "Legendary Shooter", description = "Take 100 shots in soccer", icon = "loader-pinwheel", playerStatId = "soccer_shots_made", threshold = 100},
        -- Saves Made
        {id = "soccer_save_1", label = "Goalkeeper's Glove", description = "Make your first save in soccer", icon = "loader-pinwheel", playerStatId = "soccer_save_made", threshold = 1},
        {id = "soccer_save_5", label = "Defense Defender", description = "Make 5 saves in soccer", icon = "loader-pinwheel", playerStatId = "soccer_save_made", threshold = 5},
        {id = "soccer_save_10", label = "Shot Stopper", description = "Make 10 saves in soccer", icon = "loader-pinwheel", playerStatId = "soccer_save_made", threshold = 10},
        {id = "soccer_save_25", label = "Net Guardian", description = "Make 25 saves in soccer", icon = "loader-pinwheel", playerStatId = "soccer_save_made", threshold = 25},
        {id = "soccer_save_50", label = "Last Line of Defense", description = "Make 50 saves in soccer", icon = "loader-pinwheel", playerStatId = "soccer_save_made", threshold = 50},
        {id = "soccer_save_100", label = "Brick Wall", description = "Make 100 saves in soccer", icon = "loader-pinwheel", playerStatId = "soccer_save_made", threshold = 100},
        -- Passes Made
        {id = "soccer_pass_1", label = "Pass Initiator", description = "Make your first pass in soccer", icon = "loader-pinwheel", playerStatId = "soccer_passes_made", threshold = 1},
        {id = "soccer_pass_5", label = "Team Player", description = "Make 5 passes in soccer", icon = "loader-pinwheel", playerStatId = "soccer_passes_made", threshold = 5},
        {id = "soccer_pass_10", label = "Passing Pro", description = "Make 10 passes in soccer", icon = "loader-pinwheel", playerStatId = "soccer_passes_made", threshold = 10},
        {id = "soccer_pass_25", label = "Assist Artist", description = "Make 25 passes in soccer", icon = "loader-pinwheel", playerStatId = "soccer_passes_made", threshold = 25},
        {id = "soccer_pass_50", label = "Playmaker", description = "Make 50 passes in soccer", icon = "loader-pinwheel", playerStatId = "soccer_passes_made", threshold = 50},
        {id = "soccer_pass_100", label = "Midfield Maestro", description = "Make 100 passes in soccer", icon = "loader-pinwheel", playerStatId = "soccer_passes_made", threshold = 100},
        -- Tackles Made
        {id = "soccer_tackle_1", label = "First Tackle", description = "Make your first tackle in soccer", icon = "loader-pinwheel", playerStatId = "soccer_tackles_made", threshold = 1},
        {id = "soccer_tackle_5", label = "Defensive Dynamo", description = "Make 5 tackles in soccer", icon = "loader-pinwheel", playerStatId = "soccer_tackles_made", threshold = 5},
        {id = "soccer_tackle_10", label = "Tackle Titan", description = "Make 10 tackles in soccer", icon = "loader-pinwheel", playerStatId = "soccer_tackles_made", threshold = 10},
        {id = "soccer_tackle_25", label = "Ball Winner", description = "Make 25 tackles in soccer", icon = "loader-pinwheel", playerStatId = "soccer_tackles_made", threshold = 25},
        {id = "soccer_tackle_50", label = "Tackle Master", description = "Make 50 tackles in soccer", icon = "loader-pinwheel", playerStatId = "soccer_tackles_made", threshold = 50},
        {id = "soccer_tackle_100", label = "Defensive Legend", description = "Make 100 tackles in soccer", icon = "loader-pinwheel", playerStatId = "soccer_tackles_made", threshold = 100},
        -- Game Wins
        {id = "soccer_game_win_1", label = "First Victory", description = "Win your first game of soccer", icon = "loader-pinwheel", playerStatId = "soccer_game_wins", threshold = 1},
        {id = "soccer_game_win_5", label = "Winning Streaker", description = "Win 5 games of soccer", icon = "loader-pinwheel", playerStatId = "soccer_game_wins", threshold = 5},
        {id = "soccer_game_win_10", label = "Game Changer", description = "Win 10 games of soccer", icon = "loader-pinwheel", playerStatId = "soccer_game_wins", threshold = 10},
        {id = "soccer_game_win_25", label = "Champion in the Making", description = "Win 25 games of soccer", icon = "loader-pinwheel", playerStatId = "soccer_game_wins", threshold = 25},
        {id = "soccer_game_win_50", label = "Victory Veteran", description = "Win 50 games of soccer", icon = "loader-pinwheel", playerStatId = "soccer_game_wins", threshold = 50},
        {id = "soccer_game_win_100", label = "Ultimate Champion", description = "Win 100 games of soccer", icon = "loader-pinwheel", playerStatId = "soccer_game_wins", threshold = 100},
        -- Game Losses
        {id = "soccer_game_loss_1", label = "Tough Break", description = "Lose your first game of soccer", icon = "loader-pinwheel", playerStatId = "soccer_game_losses", threshold = 1},
        {id = "soccer_game_loss_5", label = "Learning Curve", description = "Lose 5 games of soccer", icon = "loader-pinwheel", playerStatId = "soccer_game_losses", threshold = 5},
        {id = "soccer_game_loss_10", label = "Persistence Pays", description = "Lose 10 games of soccer", icon = "loader-pinwheel", playerStatId = "soccer_game_losses", threshold = 10},
        {id = "soccer_game_loss_25", label = "Keep Pushing", description = "Lose 25 games of soccer", icon = "loader-pinwheel", playerStatId = "soccer_game_losses", threshold = 25},
        {id = "soccer_game_loss_50", label = "Tenacity Tested", description = "Lose 50 games of soccer", icon = "loader-pinwheel", playerStatId = "soccer_game_losses", threshold = 50},
        {id = "soccer_game_loss_100", label = "Resilient Warrior", description = "Lose 100 games of soccer", icon = "loader-pinwheel", playerStatId = "soccer_game_losses", threshold = 100}
    },    
}