local oxmysql = exports.oxmysql

-- Initialization function for setting up the database and loading necessary resources.
-- This function waits for the oxmysql resource to start, loads the database schema, and creates required tables if they don't exist.
function Init()
    -- Wait for oxmysql resource to be started.
    while GetResourceState('oxmysql') ~= 'started' do
        Wait(0)
    end

    -- Wait for the MySQL connection to be ready.
    while not oxmysql:isReady() do
        Wait(0)
    end

    -- Create necessary database tables for the crafting system if they don't exist.
    oxmysql:transaction({
        [[
            CREATE TABLE IF NOT EXISTS `nxtgn_crafting_blueprints` (
                `uuid` varchar(36) NOT NULL,
                `label` varchar(50) NOT NULL,
                `description` text DEFAULT NULL,
                `uses` int(11) DEFAULT NULL,
                `item` varchar(50) DEFAULT NULL,
                PRIMARY KEY (`uuid`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
        ]],
        [[
            CREATE TABLE IF NOT EXISTS `nxtgn_crafting_categories` (
                `uuid` varchar(36) NOT NULL,
                `title` varchar(50) NOT NULL,
                `description` text NOT NULL DEFAULT '',
                `icon` varchar(50) DEFAULT NULL,
                `image` varchar(255) DEFAULT NULL,
                PRIMARY KEY (`uuid`) USING BTREE
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
        ]],
        [[
            CREATE TABLE IF NOT EXISTS `nxtgn_crafting_recipes` (
                `uuid` varchar(36) NOT NULL,
                `title` varchar(50) NOT NULL,
                `description` text NOT NULL,
                `category` varchar(36) NOT NULL,
                `required_level` int(11) DEFAULT NULL,
                `required_category_level` int(11) DEFAULT NULL,
                `crafting_time` int(11) NOT NULL DEFAULT 10,
                `xp_reward` int(11) DEFAULT 25,
                `prop_model` varchar(50) DEFAULT NULL,
                `prop_rot_x` float DEFAULT NULL,
                `prop_rot_y` float DEFAULT NULL,
                `prop_rot_z` float DEFAULT NULL,
                `prop_offset_x` float DEFAULT NULL,
                `prop_offset_y` float DEFAULT NULL,
                `prop_offset_z` float DEFAULT NULL,
                `cooldown_limit` int(11) DEFAULT NULL,
                `cooldown_window` int(11) DEFAULT NULL,
                `order_index` int(11) DEFAULT NULL,
                `failure_chance` int(11) DEFAULT NULL,
                `failure_mode` varchar(20) DEFAULT NULL,
                PRIMARY KEY (`uuid`),
                KEY `FK_nxtgn_crafting_recipes_nxtgn_crafting_categories` (`category`),
                CONSTRAINT `FK_nxtgn_crafting_recipes_nxtgn_crafting_categories` FOREIGN KEY (`category`) REFERENCES `nxtgn_crafting_categories` (`uuid`) ON DELETE CASCADE ON UPDATE NO ACTION
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
        ]],
        [[
            CREATE TABLE IF NOT EXISTS `nxtgn_crafting_recipe_blueprints` (
                `recipe_id` varchar(36) NOT NULL,
                `blueprint_id` varchar(36) NOT NULL,
                UNIQUE KEY `recipe_id` (`recipe_id`,`blueprint_id`) USING BTREE,
                KEY `FK_nxtgn_crafting_recipe_blueprints_nxtgn_crafting_blueprints` (`blueprint_id`),
                CONSTRAINT `FK_nxtgn_crafting_recipe_blueprints_nxtgn_crafting_blueprints` FOREIGN KEY (`blueprint_id`) REFERENCES `nxtgn_crafting_blueprints` (`uuid`) ON DELETE CASCADE ON UPDATE NO ACTION,
                CONSTRAINT `FK_nxtgn_crafting_recipe_blueprints_nxtgn_crafting_recipes` FOREIGN KEY (`recipe_id`) REFERENCES `nxtgn_crafting_recipes` (`uuid`) ON DELETE CASCADE ON UPDATE NO ACTION
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci ROW_FORMAT=DYNAMIC;
        ]],
        [[
            CREATE TABLE IF NOT EXISTS `nxtgn_crafting_recipe_ingredients` (
                `recipe_id` varchar(36) NOT NULL,
                `item` varchar(50) NOT NULL,
                `count` int(11) NOT NULL DEFAULT 1,
                UNIQUE KEY `recipe_id` (`recipe_id`,`item`),
                CONSTRAINT `FK_nxtgn_crafting_recipe_ingredients_nxtgn_crafting_recipes` FOREIGN KEY (`recipe_id`) REFERENCES `nxtgn_crafting_recipes` (`uuid`) ON DELETE CASCADE ON UPDATE NO ACTION
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
        ]],
        [[
            CREATE TABLE IF NOT EXISTS `nxtgn_crafting_recipe_results` (
                `recipe_id` varchar(36) NOT NULL,
                `item` varchar(50) NOT NULL,
                `count` int(11) NOT NULL DEFAULT 1,
                `metadata` longtext DEFAULT NULL,
                UNIQUE KEY `recipe_id` (`recipe_id`,`item`),
                CONSTRAINT `FK_nxtgn_crafting_recipe_results_nxtgn_crafting_recipes` FOREIGN KEY (`recipe_id`) REFERENCES `nxtgn_crafting_recipes` (`uuid`) ON DELETE CASCADE ON UPDATE NO ACTION
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
        ]],
        [[
            CREATE TABLE IF NOT EXISTS `nxtgn_crafting_bench_types` (
                `uuid` varchar(36) NOT NULL,
                `name` varchar(50) NOT NULL,
                `model` varchar(50) DEFAULT NULL,
                `full_access` int(1) NOT NULL DEFAULT 0,
                `created_by` varchar(255) DEFAULT NULL,
                `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
                PRIMARY KEY (`uuid`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
        ]],
        [[
            CREATE TABLE IF NOT EXISTS `nxtgn_crafting_bench_type_access` (
                `bench_type` varchar(50) NOT NULL,
                `access` varchar(50) NOT NULL,
                `ranks` longtext DEFAULT NULL,
                UNIQUE KEY `bench_type` (`bench_type`,`access`),
                CONSTRAINT `FK__nxtgn_crafting_bench_types` FOREIGN KEY (`bench_type`) REFERENCES `nxtgn_crafting_bench_types` (`uuid`) ON DELETE CASCADE ON UPDATE NO ACTION
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
        ]],
        [[
            CREATE TABLE IF NOT EXISTS `nxtgn_crafting_bench_locations` (
                `uuid` varchar(36) NOT NULL,
                `bench_type` varchar(36) NOT NULL,
                `loc_x` float NOT NULL DEFAULT 0,
                `loc_y` float NOT NULL DEFAULT 0,
                `loc_z` float NOT NULL DEFAULT 0,
                `loc_h` float NOT NULL DEFAULT 0,
                `created_by` varchar(255) DEFAULT NULL,
                `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
                `is_portable` int(11) NOT NULL DEFAULT 0,
                PRIMARY KEY (`uuid`),
                KEY `FK_nxtgn_crafting_bench_locations_nxtgn_crafting_bench_types` (`bench_type`) USING BTREE,
                CONSTRAINT `FK_nxtgn_crafting_bench_locations_nxtgn_crafting_bench_types` FOREIGN KEY (`bench_type`) REFERENCES `nxtgn_crafting_bench_types` (`uuid`) ON DELETE CASCADE ON UPDATE NO ACTION
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
        ]],
        [[
            CREATE TABLE IF NOT EXISTS `nxtgn_crafting_bench_location_crafts` (
                `location` varchar(36) NOT NULL,
                `user_id` varchar(255) DEFAULT NULL,
                `recipe` varchar(255) NOT NULL,
                `quantity` int(11) NOT NULL DEFAULT 1,
                `started_at` int(11) DEFAULT NULL,
                `completed_at` int(11) DEFAULT 0,
                `paused_at` int(11) DEFAULT NULL,
                `craft_id` varchar(50) NOT NULL,
                `removed_items` longtext DEFAULT NULL,
                `result_items` longtext DEFAULT NULL,
                UNIQUE KEY `craft_id` (`craft_id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
        ]],
        [[
            CREATE TABLE IF NOT EXISTS `nxtgn_crafting_bench_type_categories` (
                `uuid` varchar(36) NOT NULL,
                `bench_type` varchar(36) NOT NULL,
                `category` varchar(36) NOT NULL,
                `is_default_denied` int(1) NOT NULL DEFAULT 0,
                PRIMARY KEY (`uuid`),
                UNIQUE KEY `bench_type` (`bench_type`,`category`),
                KEY `FK_bench_type_categories_categories` (`category`),
                CONSTRAINT `FK_bench_type_categories_bench_types` FOREIGN KEY (`bench_type`) REFERENCES `nxtgn_crafting_bench_types` (`uuid`) ON DELETE CASCADE ON UPDATE NO ACTION,
                CONSTRAINT `FK_bench_type_categories_categories` FOREIGN KEY (`category`) REFERENCES `nxtgn_crafting_categories` (`uuid`) ON DELETE CASCADE ON UPDATE NO ACTION
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
        ]],
        [[
            CREATE TABLE IF NOT EXISTS `nxtgn_crafting_bench_type_category_recipes` (
                `bench_type_category` varchar(36) NOT NULL,
                `recipe` varchar(36) NOT NULL,
                UNIQUE KEY `bench_type_category` (`bench_type_category`,`recipe`),
                KEY `FK_bench_type_category_recipes_recipes` (`recipe`),
                KEY `FK_bench_type_category_recipes_bench_types` (`bench_type_category`) USING BTREE,
                CONSTRAINT `FK_bench_type_category_recipes_bench_type_categories` FOREIGN KEY (`bench_type_category`) REFERENCES `nxtgn_crafting_bench_type_categories` (`uuid`) ON DELETE CASCADE ON UPDATE NO ACTION,
                CONSTRAINT `FK_bench_type_category_recipes_recipes` FOREIGN KEY (`recipe`) REFERENCES `nxtgn_crafting_recipes` (`uuid`) ON DELETE CASCADE ON UPDATE NO ACTION
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
        ]],
        [[
            CREATE TABLE IF NOT EXISTS `nxtgn_crafting_players` (
                `identifier` varchar(255) NOT NULL,
                `level` float NOT NULL DEFAULT 1,
                UNIQUE KEY `identifier` (`identifier`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
        ]],
        [[
            CREATE TABLE IF NOT EXISTS `nxtgn_crafting_player_blueprints` (
                `identifier` varchar(255) NOT NULL,
                `blueprint` varchar(36) NOT NULL,
                UNIQUE KEY `identifier` (`identifier`,`blueprint`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
        ]],
        [[
            CREATE TABLE IF NOT EXISTS `nxtgn_crafting_player_history` (
                `identifier` varchar(255) NOT NULL,
                `bench_type` varchar(36) NOT NULL,
                `bench_location` varchar(36) NOT NULL,
                `recipe` varchar(36) NOT NULL,
                `quantity` int(11) DEFAULT NULL,
                `timestamp` timestamp NOT NULL DEFAULT current_timestamp()
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
        ]],
        [[
            CREATE TABLE IF NOT EXISTS `nxtgn_crafting_player_levels` (
                `identifier` varchar(255) NOT NULL DEFAULT '0',
                `category` varchar(36) NOT NULL,
                `level` float NOT NULL DEFAULT 0,
                UNIQUE KEY `identifier` (`identifier`,`category`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
        ]]
    }, function(res)
        Log.info('Tables created', res)

        -- Add cooldown columns to recipes table if they don't exist (upgrade path)
        oxmysql:single([[
            SELECT COUNT(*) AS `count`
            FROM INFORMATION_SCHEMA.COLUMNS
            WHERE TABLE_SCHEMA = DATABASE()
              AND TABLE_NAME = 'nxtgn_crafting_recipes'
              AND COLUMN_NAME = 'cooldown_limit';
        ]], function(col)
            if col and tonumber(col.count) == 0 then
                oxmysql:query_async(
                [[ALTER TABLE `nxtgn_crafting_recipes` ADD COLUMN `cooldown_limit` INT(11) DEFAULT NULL;]])
                Log.info('Added column cooldown_limit to nxtgn_crafting_recipes')
            end
        end)

        oxmysql:single([[
            SELECT COUNT(*) AS `count`
            FROM INFORMATION_SCHEMA.COLUMNS
            WHERE TABLE_SCHEMA = DATABASE()
              AND TABLE_NAME = 'nxtgn_crafting_recipes'
              AND COLUMN_NAME = 'cooldown_window';
        ]], function(col)
            if col and tonumber(col.count) == 0 then
                oxmysql:query_async(
                [[ALTER TABLE `nxtgn_crafting_recipes` ADD COLUMN `cooldown_window` INT(11) DEFAULT NULL;]])
                Log.info('Added column cooldown_window to nxtgn_crafting_recipes')
            end
        end)

        -- Migrate 'access' column from bench types to a new table.
        oxmysql:single([[
            SELECT COUNT(*) AS `count`
            FROM INFORMATION_SCHEMA.COLUMNS
            WHERE TABLE_SCHEMA = DATABASE()
                AND TABLE_NAME = 'nxtgn_crafting_bench_types'
                AND COLUMN_NAME = 'access';
        ]], function(res)
            if res and res.count > 0 then
                local accessRules = oxmysql:query_async([[
                    SELECT `uuid`, `access`
                    FROM `nxtgn_crafting_bench_types`
                    WHERE `access` != 'none'
                ]])

                if accessRules and #accessRules > 0 then
                    for _, benchType in ipairs(accessRules) do
                        oxmysql:insert([[
                            INSERT INTO `nxtgn_crafting_bench_type_access` (`bench_type`, `access`)
                            VALUES (?, ?)
                        ]], { benchType.uuid, benchType.access })
                    end
                end

                oxmysql:query_async([[
                    ALTER TABLE `nxtgn_crafting_bench_types`
                    DROP COLUMN `access`;
                ]])

                Log.info('Access column migrated')
            end
        end)

        -- Add 'metadata' column to recipe results table if it doesn't exist.
        oxmysql:query([[
            IF NOT EXISTS (
                SELECT 1
                FROM INFORMATION_SCHEMA.COLUMNS
                WHERE TABLE_SCHEMA = DATABASE()
                AND TABLE_NAME = 'nxtgn_crafting_recipe_results'
                AND COLUMN_NAME = 'metadata'
            ) THEN
                ALTER TABLE `nxtgn_crafting_recipe_results`
                ADD COLUMN `metadata` LONGTEXT DEFAULT NULL;
            END IF;
        ]])

        -- Add 'uses' column to blueprints table if it doesn't exist.
        oxmysql:query([[
            IF NOT EXISTS (
                SELECT 1
                FROM INFORMATION_SCHEMA.COLUMNS
                WHERE TABLE_SCHEMA = DATABASE()
                AND TABLE_NAME = 'nxtgn_crafting_blueprints'
                AND COLUMN_NAME = 'uses'
            ) THEN
                ALTER TABLE `nxtgn_crafting_blueprints`
                ADD COLUMN `uses` int(11) DEFAULT NULL;
            END IF;
        ]])

        -- Add 'item' column to blueprints table if it doesn't exist.
        oxmysql:query([[
            IF NOT EXISTS (
                SELECT 1
                FROM INFORMATION_SCHEMA.COLUMNS
                WHERE TABLE_SCHEMA = DATABASE()
                AND TABLE_NAME = 'nxtgn_crafting_blueprints'
                AND COLUMN_NAME = 'item'
            ) THEN
                ALTER TABLE `nxtgn_crafting_blueprints`
                ADD COLUMN `item` varchar(50) DEFAULT NULL;
            END IF;
        ]])

        -- Add 'ranks' column to bench type access table if it doesn't exist.
        oxmysql:query([[
            IF NOT EXISTS (
                SELECT 1
                FROM INFORMATION_SCHEMA.COLUMNS
                WHERE TABLE_SCHEMA = DATABASE()
                AND TABLE_NAME = 'nxtgn_crafting_bench_type_access'
                AND COLUMN_NAME = 'ranks'
            ) THEN
                ALTER TABLE `nxtgn_crafting_bench_type_access`
                ADD COLUMN `ranks` LONGTEXT DEFAULT NULL;
            END IF;
        ]])

        -- Add 'order_index' column to recipes table if it doesn't exist.
        oxmysql:query([[
            IF NOT EXISTS (
                SELECT 1
                FROM INFORMATION_SCHEMA.COLUMNS
                WHERE TABLE_SCHEMA = DATABASE()
                AND TABLE_NAME = 'nxtgn_crafting_recipes'
                AND COLUMN_NAME = 'order_index'
            ) THEN
                ALTER TABLE `nxtgn_crafting_recipes`
                ADD COLUMN `order_index` INT(11) DEFAULT NULL;
            END IF;
        ]])

        -- Add 'failure_chance' column to recipes table if it doesn't exist.
        oxmysql:query([[
            IF NOT EXISTS (
                SELECT 1
                FROM INFORMATION_SCHEMA.COLUMNS
                WHERE TABLE_SCHEMA = DATABASE()
                AND TABLE_NAME = 'nxtgn_crafting_recipes'
                AND COLUMN_NAME = 'failure_chance'
            ) THEN
                ALTER TABLE `nxtgn_crafting_recipes`
                ADD COLUMN `failure_chance` INT(11) DEFAULT NULL;
            END IF;
        ]])

        -- Add 'failure_mode' column to recipes table if it doesn't exist.
        oxmysql:query([[
            IF NOT EXISTS (
                SELECT 1
                FROM INFORMATION_SCHEMA.COLUMNS
                WHERE TABLE_SCHEMA = DATABASE()
                AND TABLE_NAME = 'nxtgn_crafting_recipes'
                AND COLUMN_NAME = 'failure_mode'
            ) THEN
                ALTER TABLE `nxtgn_crafting_recipes`
                ADD COLUMN `failure_mode` VARCHAR(20) DEFAULT NULL;
            END IF;
        ]])

        -- v1.2.1: Shared Mode columns on bench_types
        oxmysql:single([[
            SELECT COUNT(*) AS `count`
            FROM INFORMATION_SCHEMA.COLUMNS
            WHERE TABLE_SCHEMA = DATABASE()
              AND TABLE_NAME = 'nxtgn_crafting_bench_types'
              AND COLUMN_NAME = 'shared_levels';
        ]], function(col)
            if col and tonumber(col.count) == 0 then
                oxmysql:query_async(
                [[ALTER TABLE `nxtgn_crafting_bench_types` ADD COLUMN `shared_levels` INT(1) NOT NULL DEFAULT 0;]])
                oxmysql:query_async(
                [[ALTER TABLE `nxtgn_crafting_bench_types` ADD COLUMN `shared_queue` INT(1) NOT NULL DEFAULT 0;]])
                oxmysql:query_async(
                [[ALTER TABLE `nxtgn_crafting_bench_types` ADD COLUMN `shared_queue_claim` VARCHAR(10) NOT NULL DEFAULT 'anyone';]])
                oxmysql:query_async(
                [[ALTER TABLE `nxtgn_crafting_bench_types` ADD COLUMN `shared_queue_cancel` VARCHAR(10) NOT NULL DEFAULT 'anyone';]])
                Log.info('Added shared mode columns to nxtgn_crafting_bench_types')
            end
        end)

        -- v1.2.1: Shared Mode override columns on bench_locations
        oxmysql:single([[
            SELECT COUNT(*) AS `count`
            FROM INFORMATION_SCHEMA.COLUMNS
            WHERE TABLE_SCHEMA = DATABASE()
              AND TABLE_NAME = 'nxtgn_crafting_bench_locations'
              AND COLUMN_NAME = 'shared_levels';
        ]], function(col)
            if col and tonumber(col.count) == 0 then
                oxmysql:query_async(
                [[ALTER TABLE `nxtgn_crafting_bench_locations` ADD COLUMN `shared_levels` INT(1) DEFAULT NULL;]])
                oxmysql:query_async(
                [[ALTER TABLE `nxtgn_crafting_bench_locations` ADD COLUMN `shared_queue` INT(1) DEFAULT NULL;]])
                Log.info('Added shared mode columns to nxtgn_crafting_bench_locations')
            end
        end)

        -- v1.2.3: Add routing_bucket column to bench locations
        oxmysql:single([[
            SELECT COUNT(*) AS `count`
            FROM INFORMATION_SCHEMA.COLUMNS
            WHERE TABLE_SCHEMA = DATABASE()
              AND TABLE_NAME = 'nxtgn_crafting_bench_locations'
              AND COLUMN_NAME = 'routing_bucket';
        ]], function(col)
            if col and tonumber(col.count) == 0 then
                oxmysql:query_async(
                [[ALTER TABLE `nxtgn_crafting_bench_locations` ADD COLUMN `routing_bucket` INT DEFAULT NULL;]])
                Log.info('Added routing_bucket column to nxtgn_crafting_bench_locations')
            end
        end)

        -- v1.2.1: Shared bench type levels table
        oxmysql:query_async([[
            CREATE TABLE IF NOT EXISTS `nxtgn_crafting_bench_type_levels` (
                `bench_type` VARCHAR(36) NOT NULL,
                `category` VARCHAR(36) DEFAULT NULL,
                `level` FLOAT NOT NULL DEFAULT 1,
                UNIQUE KEY (`bench_type`, `category`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
        ]])

        LoadInitialData() -- Load initial data after creating tables.
    end)

    Log.success('Database loaded')
end

-- Generates a random UUID string.
-- @return: A string representing a randomly generated UUID.
local function generateUUID()
    local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function(c)
        local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format('%x', v)
    end)
end

-- Player management table with functions to fetch and update player data.
Player = {
    -- Fetch player crafting level from the database.
    -- @param src: Source of the player.
    -- @param playerId: The identifier of the player.
    -- @return: The player's crafting level if it exists, otherwise nil.
    Fetch = function(src, playerId)
        local res = oxmysql:single_async([[
            SELECT
                `level`
            FROM `nxtgn_crafting_players`
            WHERE `identifier` = ?
        ]], { playerId })

        if not res or res.level == nil then
            return nil
        end
        return res
    end,

    -- Update the player's crafting level in the database.
    -- @param src: Source of the player.
    -- @param playerId: The identifier of the player.
    -- @param data: A table containing the new level data.
    -- @return: True if the level was updated, otherwise false.
    Update = function(src, playerId, data)
        oxmysql:update_async([[
            INSERT INTO `nxtgn_crafting_players` (`identifier`, `level`)
            VALUES (?, ?)
            ON DUPLICATE KEY UPDATE
                `level` = VALUES(`level`)
        ]], { playerId, data.level })

        return true
    end,

    -- Fetch the player's category level for crafting.
    -- @param src: Source of the player.
    -- @param playerId: The identifier of the player.
    -- @param id: The category ID.
    -- @return: The player's level for the category, or nil if not found.
    GetCategoryLevel = function(src, playerId, id)
        local res = oxmysql:single_async([[
            SELECT
                `level`
            FROM `nxtgn_crafting_player_levels`
            WHERE `identifier` = ? AND `category` = ?
        ]], { playerId, id })

        if not res or res.level == nil then
            return nil
        end
        return res.level
    end,

    -- Set the player's category level for crafting.
    -- @param src: Source of the player.
    -- @param playerId: The identifier of the player.
    -- @param id: The category ID.
    -- @param level: The new level for the category.
    -- @return: True if the level was set, otherwise false.
    SetCategoryLevel = function(src, playerId, id, level)
        oxmysql:update_async([[
            INSERT INTO `nxtgn_crafting_player_levels` (`identifier`, `category`, `level`)
            VALUES (?, ?, ?)
            ON DUPLICATE KEY UPDATE `level` = VALUES(`level`)
        ]], { playerId, id, level })

        return true
    end,

    -- Fetch all category levels for the player.
    -- @param src: Source of the player.
    -- @param playerId: The identifier of the player.
    -- @return: A table containing the player's category levels.
    FetchCategoryLevels = function(src, playerId)
        local res = oxmysql:query_async([[
            SELECT
                ncpl.`category`, ncpl.`level`, ncc.`title`
            FROM `nxtgn_crafting_player_levels` ncpl
            INNER JOIN `nxtgn_crafting_categories` ncc ON ncc.`uuid` = ncpl.`category`
            WHERE ncpl.`identifier` = ?
        ]], { playerId })

        if not res then
            return nil
        end

        return res
    end,

    -- Fetch the player's blueprints.
    -- @param src: Source of the player.
    -- @param playerId: The identifier of the player.
    -- @return: A table containing the player's blueprints.
    FetchBlueprints = function(src, playerId)
        local res = oxmysql:query_async([[
            SELECT ncpb.`blueprint`, ncb.`label`
            FROM `nxtgn_crafting_player_blueprints` ncpb
            INNER JOIN `nxtgn_crafting_blueprints` ncb ON ncb.`uuid` = ncpb.`blueprint`
            WHERE ncpb.`identifier` = ?
        ]], { playerId })

        if not res then
            return nil
        end

        return res
    end,

    -- Check if the player has a specific blueprint.
    -- @param src: Source of the player.
    -- @param playerId: The identifier of the player.
    -- @param id: The blueprint ID.
    -- @return: Boolean, true if the player has the blueprint, false otherwise.
    HasBlueprint = function(src, playerId, id)
        local res = oxmysql:single_async([[
            SELECT COUNT(*) AS `count`
            FROM `nxtgn_crafting_player_blueprints`
            WHERE `identifier` = ? AND `blueprint` = ?
        ]], { playerId, id })

        if not res or res.count == nil then
            return nil
        end
        return res.count > 0
    end,

    -- Add a blueprint to the player's account.
    -- @param src: Source of the player.
    -- @param playerId: The identifier of the player.
    -- @param id: The blueprint ID to add.
    -- @return: True if the blueprint was added, otherwise false.
    AddBlueprint = function(src, playerId, id)
        oxmysql:insert_async([[
            INSERT INTO `nxtgn_crafting_player_blueprints` (`identifier`, `blueprint`)
            VALUES (?, ?)
        ]], { playerId, id })

        return true
    end,

    -- Remove a blueprint from the player's account.
    -- @param src: Source of the player.
    -- @param playerId: The identifier of the player.
    -- @param id: The blueprint ID to remove.
    -- @return: True if the blueprint was removed, otherwise false.
    RemoveBlueprint = function(src, playerId, id)
        oxmysql:query_async([[
            DELETE FROM `nxtgn_crafting_player_blueprints`
            WHERE `identifier` = ? AND `blueprint` = ?
        ]], { playerId, id })

        return true
    end,

    -- Add crafting history for the player.
    -- @param src: Source of the player.
    -- @param playerId: The identifier of the player.
    -- @param data: A table containing crafting history data (e.g., benchType, recipe, etc.).
    -- @return: True if the history was added, otherwise false.
    AddHistory = function(src, playerId, data)
        if data.timestamp then
            oxmysql:insert_async([[
                INSERT INTO `nxtgn_crafting_player_history` (`identifier`, `bench_type`, `bench_location`, `recipe`, `quantity`, `timestamp`)
                VALUES (?, ?, ?, ?, ?, FROM_UNIXTIME(?))
            ]], { playerId, data.benchType, data.benchLocation, data.recipe, data.quantity, data.timestamp })
        else
            oxmysql:insert_async([[
                INSERT INTO `nxtgn_crafting_player_history` (`identifier`, `bench_type`, `bench_location`, `recipe`, `quantity`)
                VALUES (?, ?, ?, ?, ?)
            ]], { playerId, data.benchType, data.benchLocation, data.recipe, data.quantity })
        end

        return true
    end,

    -- Sum of crafted quantity for a recipe within a time window (seconds)
    GetRecentRecipeCrafts = function(playerId, recipeId, sinceEpoch)
        local res = oxmysql:single_async([[
            SELECT COALESCE(SUM(`quantity`), 0) AS `used`
            FROM `nxtgn_crafting_player_history`
            WHERE `identifier` = ? AND `recipe` = ? AND `timestamp` >= FROM_UNIXTIME(?)
        ]], { playerId, recipeId, sinceEpoch })

        if not res or res.used == nil then
            return 0
        end
        return tonumber(res.used) or 0
    end,

    -- Detailed recent crafts (quantity and timestamp) within window, ascending by timestamp
    GetRecentRecipeCraftEvents = function(playerId, recipeId, sinceEpoch)
        local rows = oxmysql:query_async([[
            SELECT `quantity`, UNIX_TIMESTAMP(`timestamp`) AS `ts`
            FROM `nxtgn_crafting_player_history`
            WHERE `identifier` = ? AND `recipe` = ? AND `timestamp` >= FROM_UNIXTIME(?)
            ORDER BY `timestamp` ASC
        ]], { playerId, recipeId, sinceEpoch })

        if not rows then return {} end
        return rows
    end,


    -- Clear all player data from the database.
    Clear = function()
        oxmysql:query_async('DELETE FROM `nxtgn_crafting_players`')
        oxmysql:query_async('DELETE FROM `nxtgn_crafting_player_blueprints`')
        oxmysql:query_async('DELETE FROM `nxtgn_crafting_player_history`')
        oxmysql:query_async('DELETE FROM `nxtgn_crafting_player_levels`')
    end
}

-- Categories management table with functions to fetch, create, update, and delete crafting categories.
Categories = {
    -- Fetch all crafting categories.
    -- @return: A table containing all categories.
    Fetch = function()
        local res = oxmysql:query_async([[
            SELECT `uuid`, `title`, `description`, `icon`, `image`
            FROM `nxtgn_crafting_categories`
        ]])

        if not res then return nil end
        return res
    end,

    -- Fetch a specific category by UUID.
    -- @param id: The UUID of the category.
    -- @return: A table containing the category details.
    FetchOne = function(id)
        local res = oxmysql:single_async([[
            SELECT `uuid`, `title`, `description`, `icon`, `image`
            FROM `nxtgn_crafting_categories`
            WHERE `uuid` = ?
        ]], { id })

        if not res then return nil end
        return res
    end,

    -- Search for a category by title.
    -- @param search: The search query to match against category titles.
    -- @return: A table containing the search results.
    SearchCategory = function(search)
        local res = oxmysql:single_async([[
            SELECT `uuid`, `title`, `description`, `icon`, `image`
            FROM `nxtgn_crafting_categories`
            WHERE LOWER(REPLACE(`title`, ' ', '')) LIKE LOWER(REPLACE(?, ' ', ''))
        ]], {
            '%' .. search .. '%'
        })

        return res
    end,

    -- Create a new crafting category in the database.
    -- @param data: A table containing the category data.
    -- @return: The UUID of the new category if created, otherwise nil.
    Create = function(data)
        if not data then return nil end

        local uuid = generateUUID()

        local res = oxmysql:query_async([[
            INSERT INTO `nxtgn_crafting_categories` (`uuid`, `title`, `description`, `icon`, `image`)
            VALUES (?, ?, ?, ?, ?)
        ]], { uuid, data.title, data.description, data.icon, data.image })

        return res and uuid
    end,

    -- Update an existing crafting category.
    -- @param data: A table containing the updated category data.
    -- @return: The result of the update operation.
    Update = function(data)
        if not data then return nil end

        local res = oxmysql:query_async([[
            UPDATE `nxtgn_crafting_categories`
            SET `title` = ?, `description` = ?, `icon` = ?, `image` = ?
            WHERE `uuid` = ?
        ]], { data.title, data.description, data.icon, data.image, data.uuid })

        return res
    end,

    -- Delete a crafting category.
    -- @param categoryId: The UUID of the category to delete.
    -- @return: The result of the delete operation.
    Delete = function(categoryId)
        if not categoryId then return nil end

        local res = oxmysql:query_async([[
            DELETE FROM `nxtgn_crafting_categories` WHERE `uuid` = ?
        ]], { categoryId })

        return res
    end,

    -- Fetch all recipes for a specific category.
    -- @param categoryId: The UUID of the category.
    -- @return: A table containing all recipes for the category.
    FetchRecipes = function(categoryId)
        local recipes = oxmysql:query_async([[
            SELECT
                `uuid`, `title`, `description`, `required_level` AS `requiredLevel`,
                `required_category_level` AS `requiredCategoryLevel`,
                `crafting_time` AS `craftingTime`, `xp_reward` AS `xpReward`, `prop_model` AS `propModel`,
                `prop_rot_x` AS `propRotX`, `prop_rot_y` AS `propRotY`, `prop_rot_z` AS `propRotZ`,
                `prop_offset_x` AS `propOffsetX`, `prop_offset_y` AS `propOffsetY`, `prop_offset_z` AS `propOffsetZ`,
                `cooldown_limit` AS `cooldownLimit`, `cooldown_window` AS `cooldownWindow`,
                `failure_chance` AS `failureChance`, `failure_mode` AS `failureMode`
            FROM `nxtgn_crafting_recipes`
            WHERE `category` = ?
            ORDER BY `order_index` IS NULL, `order_index` ASC, `title` ASC
        ]], { categoryId })

        if not recipes then return nil end

        -- Fetch associated recipe results.
        local idList = {}
        for _, recipe in ipairs(recipes) do
            table.insert(idList, recipe.uuid)
        end

        idList = "'" .. table.concat(idList, "','") .. "'"

        local results = oxmysql:query_async(([[
            SELECT `recipe_id` AS `recipeId`, `item`, `count`, `metadata`
            FROM `nxtgn_crafting_recipe_results`
            WHERE `recipe_id` IN (%s)
        ]]):format(idList))

        if not results then return nil end

        for _, recipe in ipairs(recipes) do
            recipe.results = {}

            for _, result in ipairs(results) do
                if result.recipeId == recipe.uuid then
                    table.insert(recipe.results, {
                        item = result.item,
                        count = result.count,
                        metadata = result.metadata
                    })
                end
            end
        end

        return recipes
    end,

    -- Clear all category data from the database.
    Clear = function()
        oxmysql:query_async('DELETE FROM `nxtgn_crafting_categories`')
    end
}

-- Recipes management table with functions to fetch, create, update, and delete crafting recipes.
Recipes = {
    -- Fetch a specific recipe by UUID.
    -- @param id: The UUID of the recipe.
    -- @return: A table containing the recipe details, including results and ingredients.
    FetchOne = function(id)
        local res = oxmysql:single_async([[
            SELECT
                `uuid`, `title`, `description`, `category`, `required_level` AS `requiredLevel`,
                `required_category_level` AS `requiredCategoryLevel`,
                `crafting_time` AS `craftingTime`, `xp_reward` AS `xpReward`, `prop_model` AS `propModel`,
                `prop_rot_x` AS `propRotX`, `prop_rot_y` AS `propRotY`, `prop_rot_z` AS `propRotZ`,
                `prop_offset_x` AS `propOffsetX`, `prop_offset_y` AS `propOffsetY`, `prop_offset_z` AS `propOffsetZ`,
                `cooldown_limit` AS `cooldownLimit`, `cooldown_window` AS `cooldownWindow`,
                `failure_chance` AS `failureChance`, `failure_mode` AS `failureMode`
            FROM `nxtgn_crafting_recipes`
            WHERE `uuid` = ?
        ]], { id })

        if not res then return nil end

        res.results = oxmysql:query_async([[
            SELECT `item`, `count`, `metadata`
            FROM `nxtgn_crafting_recipe_results`
            WHERE `recipe_id` = ?
        ]], { id })

        res.ingredients = oxmysql:query_async([[
            SELECT `item`, `count`
            FROM `nxtgn_crafting_recipe_ingredients`
            WHERE `recipe_id` = ?
        ]], { id })

        res.blueprints = oxmysql:query_async([[
            SELECT `blueprint_id` AS `blueprintId`
            FROM `nxtgn_crafting_recipe_blueprints`
            WHERE `recipe_id` = ?
        ]], { id })

        return res
    end,

    -- Fetch ingredients for a specific recipe.
    -- @param id: The UUID of the recipe.
    -- @return: A table containing all ingredients for the recipe.
    FetchIngredients = function(id)
        local res = oxmysql:query_async([[
            SELECT `item`, `count`
            FROM `nxtgn_crafting_recipe_ingredients`
            WHERE `recipe_id` = ?
        ]], { id })

        return res
    end,

    -- Fetch blueprints for a specific recipe.
    -- @param id: The UUID of the recipe.
    -- @return: A table containing all blueprints for the recipe.
    FetchBlueprints = function(id)
        local res = oxmysql:query_async([[
            SELECT `blueprint_id` AS `blueprintId`
            FROM `nxtgn_crafting_recipe_blueprints`
            WHERE `recipe_id` = ?
        ]], { id })

        return res
    end,

    -- Create a new recipe in the database.
    -- @param data: A table containing the recipe data.
    -- @return: The UUID of the new recipe if created, otherwise nil.
    Create = function(data)
        if not data then return false end

        local uuid = generateUUID()

        local res = oxmysql:query_async([[
            INSERT INTO `nxtgn_crafting_recipes` (`uuid`, `title`, `description`, `category`, `required_level`,
                `required_category_level`, `crafting_time`, `xp_reward`, `prop_model`, `prop_rot_x`, `prop_rot_y`, `prop_rot_z`, `prop_offset_x`, `prop_offset_y`, `prop_offset_z`, `cooldown_limit`, `cooldown_window`, `failure_chance`, `failure_mode`)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ]],
            { uuid, data.title, data.description, data.category, data.requiredLevel, data.requiredCategoryLevel, data
                .craftingTime, data.xpReward, data.propModel, data.propRot.x, data.propRot.y, data.propRot.z, data
                .propOffset.x, data.propOffset.y, data.propOffset.z, data.cooldownLimit, data.cooldownWindow, data
                .failureChance, data.failureMode })

        if not res then return false end

        -- Insert ingredients.
        if data.ingredients then
            for _, ingredient in ipairs(data.ingredients) do
                oxmysql:query_async([[
                    INSERT INTO `nxtgn_crafting_recipe_ingredients` (`recipe_id`, `item`, `count`)
                    VALUES (?, ?, ?)
                ]], { uuid, ingredient.item, ingredient.count })
            end
        end

        -- Insert results.
        if data.results then
            for _, result in ipairs(data.results) do
                oxmysql:query_async([[
                    INSERT INTO `nxtgn_crafting_recipe_results` (`recipe_id`, `item`, `count`, `metadata`)
                    VALUES (?, ?, ?, ?)
                ]], { uuid, result.item, result.count, result.metadata })
            end
        end

        -- Insert blueprints.
        if data.blueprints then
            for _, blueprint in ipairs(data.blueprints) do
                oxmysql:query_async([[
                    INSERT INTO `nxtgn_crafting_recipe_blueprints` (`recipe_id`, `blueprint_id`)
                    VALUES (?, ?)
                ]], { uuid, blueprint.blueprintId })
            end
        end

        return uuid
    end,

    -- Delete a specific recipe.
    -- @param id: The UUID of the recipe to delete.
    -- @return: True if the recipe was deleted, otherwise false.
    Delete = function(id)
        if not id then return false end

        local res = oxmysql:transaction_async({
            'DELETE FROM `nxtgn_crafting_recipes` WHERE `uuid` = @id',
            'DELETE FROM `nxtgn_crafting_recipe_ingredients` WHERE `recipe_id` = @id',
            'DELETE FROM `nxtgn_crafting_recipe_results` WHERE `recipe_id` = @id',
            'DELETE FROM `nxtgn_crafting_recipe_blueprints` WHERE `recipe_id` = @id'
        }, { id = id })

        return res ~= nil
    end,

    -- Update a recipe in the database.
    -- @param data: A table containing the updated recipe data.
    -- @return: True if the update was successful, otherwise false.
    Update = function(data)
        if not data then return false end

        local res = oxmysql:query_async([[
            UPDATE `nxtgn_crafting_recipes` SET
                `title` = ?, `description` = ?, `required_level` = ?,
                `required_category_level` = ?, `crafting_time` = ?, `xp_reward` = ?,
                `prop_model` = ?, `prop_rot_x` = ?, `prop_rot_y` = ?, `prop_rot_z` = ?,
                `prop_offset_x` = ?, `prop_offset_y` = ?, `prop_offset_z` = ?,
                `cooldown_limit` = ?, `cooldown_window` = ?,
                `failure_chance` = ?, `failure_mode` = ?
            WHERE `uuid` = ?
        ]],
            { data.title, data.description, data.requiredLevel, data.requiredCategoryLevel, data.craftingTime, data
                .xpReward, data.propModel, data.propRot.x, data.propRot.y, data.propRot.z, data.propOffset.x, data
                .propOffset.y, data.propOffset.z, data.cooldownLimit, data.cooldownWindow, data.failureChance, data
                .failureMode, data.uuid })

        if not res then return false end

        -- Delete and re-add ingredients, results, and blueprints.
        local success = oxmysql:transaction_async({
            'DELETE FROM `nxtgn_crafting_recipe_ingredients` WHERE `recipe_id` = @id',
            'DELETE FROM `nxtgn_crafting_recipe_results` WHERE `recipe_id` = @id',
            'DELETE FROM `nxtgn_crafting_recipe_blueprints` WHERE `recipe_id` = @id'
        }, { id = data.uuid })

        if not success then return false end

        -- Re-insert ingredients.
        if data.ingredients then
            for _, ingredient in ipairs(data.ingredients) do
                oxmysql:query_async([[
                    INSERT INTO `nxtgn_crafting_recipe_ingredients` (`recipe_id`, `item`, `count`)
                    VALUES (?, ?, ?)
                ]], { data.uuid, ingredient.item, ingredient.count })
            end
        end

        -- Re-insert results.
        if data.results then
            for _, result in ipairs(data.results) do
                oxmysql:query_async([[
                    INSERT INTO `nxtgn_crafting_recipe_results` (`recipe_id`, `item`, `count`, `metadata`)
                    VALUES (?, ?, ?, ?)
                ]], { data.uuid, result.item, result.count, result.metadata })
            end
        end

        -- Re-insert blueprints.
        if data.blueprints then
            for _, blueprint in ipairs(data.blueprints) do
                oxmysql:query_async([[
                    INSERT INTO `nxtgn_crafting_recipe_blueprints` (`recipe_id`, `blueprint_id`)
                    VALUES (?, ?)
                ]], { data.uuid, blueprint.blueprintId })
            end
        end

        return true
    end,

    SetCategory = function(id, category)
        if not id or not category then return false end

        local res = oxmysql:query_async([[
            UPDATE `nxtgn_crafting_recipes`
            SET `category` = ?
            WHERE `uuid` = ?
        ]], { category, id })

        return res ~= nil
    end,

    UpdateCategoryOrder = function(category, order)
        if not category or not order or #order == 0 then return false end

        local caseStatement = {}
        local uuids = {}

        for _, item in ipairs(order) do
            table.insert(caseStatement, ("WHEN '%s' THEN %d"):format(item.recipe, item.order))
            table.insert(uuids, ("'%s'"):format(item.recipe))
        end

        local query = string.format([[
            UPDATE `nxtgn_crafting_recipes`
            SET `order_index` = CASE `uuid`
                %s
            END
            WHERE `uuid` IN (%s) AND `category` = ?
        ]], table.concat(caseStatement, "\n"), table.concat(uuids, ","))

        local res = oxmysql:query_async(query, { category })

        return res ~= nil
    end,

    -- Clear all recipe data from the database.
    Clear = function()
        oxmysql:query_async('DELETE FROM `nxtgn_crafting_recipes`')
        oxmysql:query_async('DELETE FROM `nxtgn_crafting_recipe_ingredients`')
        oxmysql:query_async('DELETE FROM `nxtgn_crafting_recipe_results`')
        oxmysql:query_async('DELETE FROM `nxtgn_crafting_recipe_blueprints`')
    end
}

-- Blueprints management table with functions to fetch, create, update, and delete crafting blueprints.
Blueprints = {
    -- Fetch a list of blueprints with pagination.
    -- @param offset: The starting offset for pagination.
    -- @param count: The number of blueprints to return.
    -- @param search: (Optional) A search query for filtering blueprints.
    -- @return: A table containing the blueprints.
    Fetch = function(offset, count, search)
        local res = oxmysql:query_async(([[
            SELECT `uuid`, `label`, `description`, `uses`, `item`
            FROM `nxtgn_crafting_blueprints`
            %s LIMIT ? OFFSET ?
        ]]):format(search and "WHERE `label` LIKE '" .. search .. "%'" or ''), { count, offset })

        if not res then return nil end
        return res
    end,

    -- Get the total number of blueprints.
    -- @param search: (Optional) A search query for filtering blueprints.
    -- @return: The total number of blueprints.
    GetTotal = function(search)
        local res = oxmysql:single_async(([[
            SELECT COUNT(*) AS `count`
            FROM `nxtgn_crafting_blueprints`
            %s
        ]]):format(search and "WHERE `label` LIKE '" .. search .. "%'" or ''))

        if not res then return nil end
        return res.count
    end,

    -- Fetch a specific blueprint by UUID.
    -- @param id: The UUID of the blueprint.
    -- @return: A table containing the blueprint details.
    FetchOne = function(id)
        local res = oxmysql:single_async([[
            SELECT `uuid`, `label`, `description`, `uses`, `item`
            FROM `nxtgn_crafting_blueprints`
            WHERE `uuid` = ?
        ]], { id })

        if not res then return nil end

        return res
    end,

    -- Search for a blueprint by label.
    -- @param search: The search query to use.
    -- @return: The UUID of the blueprint if found, otherwise nil.
    SearchBlueprint = function(search)
        local res = oxmysql:single_async([[
            SELECT `uuid`, `label`, `uses`, `item`
            FROM `nxtgn_crafting_blueprints`
            WHERE LOWER(REPLACE(`label`, ' ', '')) LIKE LOWER(REPLACE(?, ' ', ''))
        ]], {
            '%' .. search .. '%'
        })

        if not res then return nil end

        return res
    end,

    -- Create a new blueprint in the database.
    -- @param data: A table containing the blueprint data.
    -- @return: The UUID of the new blueprint if created, otherwise nil.
    Create = function(data)
        if not data then return false end

        local uuid = generateUUID()

        local res = oxmysql:query_async([[
            INSERT INTO `nxtgn_crafting_blueprints` (`uuid`, `label`, `description`, `uses`, `item`)
            VALUES (?, ?, ?, ?, ?)
        ]], { uuid, data.label, data.description, data.uses, data.item })

        return res and uuid
    end,

    -- Update an existing blueprint.
    -- @param data: A table containing the updated blueprint data.
    -- @return: True if the update was successful, otherwise false.
    Update = function(data)
        if not data then return false end

        local res = oxmysql:query_async([[
            UPDATE `nxtgn_crafting_blueprints`
            SET `label` = ?, `description` = ?, `uses` = ?, `item` = ?
            WHERE `uuid` = ?
        ]], { data.label, data.description, data.uses, data.item, data.uuid })

        return res ~= nil
    end,

    -- Delete a specific blueprint.
    -- @param id: The UUID of the blueprint to delete.
    -- @return: True if the blueprint was deleted, otherwise false.
    Delete = function(id)
        if not id then return false end

        local res = oxmysql:query_async([[
            DELETE FROM `nxtgn_crafting_blueprints`
            WHERE `uuid` = ?
        ]], { id })

        return res ~= nil
    end,

    -- Clear all blueprint data from the database.
    Clear = function()
        oxmysql:query_async('DELETE FROM `nxtgn_crafting_blueprints`')
    end
}

-- BenchType management with functions to fetch, create, update, and delete crafting bench types.
BenchTypes = {
    -- Fetch a list of bench types based on filters.
    -- @param data: A table containing filters, order, count, and offset for pagination.
    -- @return: A table containing rows of bench types and the page count.
    Fetch = function(data)
        if not data then return nil end
        local columnFiltersTable, i = {}, 0

        -- Build the filter query.
        for k, v in pairs(data.columnFilters) do
            if i == 0 then
                table.insert(columnFiltersTable, "WHERE")
            else
                table.insert(columnFiltersTable, "AND")
            end
            if type(v) == 'string' then
                table.insert(columnFiltersTable, "`" .. k .. "` LIKE '" .. v .. "%'")
            else
                table.insert(columnFiltersTable, "`" .. k .. "` IN ('" .. table.concat(v, "','") .. "')")
            end
            i = i + 1
        end
        local columnFilters = table.concat(columnFiltersTable, ' ')

        -- Fetch the count of rows.
        local countRow = oxmysql:single_async(([[SELECT COUNT(*) AS `count` FROM `nxtgn_crafting_bench_types` %s]])
        :format(columnFilters))

        if not countRow or countRow.count == nil then return nil end

        -- Fetch the actual rows.
        local res = oxmysql:query_async(([[SELECT `uuid`, `name`,
                    (SELECT COUNT(*) FROM `nxtgn_crafting_bench_locations` WHERE `bench_type` = `nxtgn_crafting_bench_types`.`uuid`) AS `locationCount`,
                    `created_by` AS `createdBy`, `created_at` AS `createdAt`
                    FROM `nxtgn_crafting_bench_types` %s ORDER BY `%s` %s LIMIT %s OFFSET %s]]):format(columnFilters,
            data.orderColumn, data.orderDirection, data.count, data.offset))

        if not res then return nil end

        return { rows = res, pageCount = math.ceil(countRow.count / data.count) }
    end,

    -- Fetch details of a specific bench type.
    -- @param id: The UUID of the bench type.
    -- @return: A table with the bench type details and its categories and recipes.
    FetchOne = function(id)
        local res = oxmysql:single_async([[
            SELECT `name`, `model`, `full_access` AS `fullAccess`,
            `created_by` AS `createdBy`, `created_at` AS `createdAt`,
            `shared_levels` AS `sharedLevels`, `shared_queue` AS `sharedQueue`,
            `shared_queue_claim` AS `sharedQueueClaim`, `shared_queue_cancel` AS `sharedQueueCancel`
            FROM `nxtgn_crafting_bench_types` WHERE `uuid` = ?
        ]], { id })

        if not res then return nil end

        local accessRes = oxmysql:query_async([[
            SELECT `access`, `ranks`
            FROM `nxtgn_crafting_bench_type_access`
            WHERE `bench_type` = ?
        ]], { id })

        res.access = {}

        if accessRes and #accessRes > 0 then
            for _, access in ipairs(accessRes) do
                local ranks = access.ranks and string.split(access.ranks, ',')

                table.insert(res.access, {
                    identifier = access.access,
                    ranks = ranks
                })
            end
        end

        res.categories = oxmysql:query_async([[
            SELECT `uuid`, `category` AS `categoryId`, `is_default_denied` AS `isDefaultDenied`
            FROM `nxtgn_crafting_bench_type_categories` WHERE `bench_type` = ?
        ]], { id })

        if not res.categories then return nil end

        for _, category in ipairs(res.categories) do
            local recipes = oxmysql:query_async([[
                SELECT `recipe` AS `recipeId`
                FROM `nxtgn_crafting_bench_type_category_recipes` WHERE `bench_type_category` = ?
            ]], { category.uuid })

            if not recipes then return nil end

            category.recipes = {}

            for _, recipe in ipairs(recipes) do
                table.insert(category.recipes, recipe.recipeId)
            end
        end

        return res
    end,

    -- Fetch all locations for a specific bench type.
    -- @param id: The UUID of the bench type.
    -- @return: A table of bench locations.
    FetchLocations = function(id)
        local res = oxmysql:query_async([[
            SELECT `uuid`, `loc_x` AS `locationX`, `loc_y` AS `locationY`,
            `loc_z` AS `locationZ`, `loc_h` AS `locationH`,
            `created_by` AS `createdBy`, `created_at` AS `createdAt`, `is_portable` AS `isPortable`,
            `shared_levels` AS `sharedLevels`, `shared_queue` AS `sharedQueue`, `routing_bucket` AS `routingBucket`
            FROM `nxtgn_crafting_bench_locations` WHERE `bench_type` = ?
        ]], { id })

        if not res then return nil end
        return res
    end,

    -- Fetch all categories for a specific bench type.
    -- @param id: The UUID of the bench type.
    -- @return: A table of bench type categories.
    FetchCategories = function(id)
        local res = oxmysql:query_async([[
            SELECT ncg.`uuid`, ncg.`title`, ncg.`description`, ncg.`icon`, ncg.`image`
            FROM `nxtgn_crafting_bench_type_categories` ncbtc
            INNER JOIN `nxtgn_crafting_categories` ncg ON ncg.`uuid` =  ncbtc.`category`
            WHERE `bench_type` = ?
        ]], { id })

        if not res then return nil end

        return res
    end,

    -- Fetch recipes for a category in a specific bench type.
    -- @param id: The UUID of the bench type.
    -- @param categoryId: The UUID of the category.
    -- @return: A table of recipes.
    FetchCategoryRecipes = function(id, categoryId)
        local category = oxmysql:single_async([[
            SELECT `uuid`, `is_default_denied` AS `isDefaultDenied`
            FROM `nxtgn_crafting_bench_type_categories` WHERE `bench_type` = ? AND `category` = ?
        ]], { id, categoryId })

        if not category then return nil end

        local typeRecipes = oxmysql:query_async([[
            SELECT `recipe` AS `recipeId`
            FROM `nxtgn_crafting_bench_type_category_recipes` WHERE `bench_type_category` = ?
        ]], { category.uuid })

        if not typeRecipes then return nil end

        local categoryRecipes = DB.Categories.FetchRecipes(categoryId)

        if not categoryRecipes then return nil end

        local recipes = {}

        for _, recipe in ipairs(categoryRecipes) do
            local include = category.isDefaultDenied == 0

            for _, typeRecipe in ipairs(typeRecipes) do
                if typeRecipe.recipeId == recipe.uuid then
                    include = category.isDefaultDenied == 1
                    break
                end
            end

            if include then
                table.insert(recipes, recipe)
            end
        end

        return recipes
    end,

    -- Fetch all crafting bench types.
    -- @return: A table containing all bench types.
    FetchAll = function()
        local res = oxmysql:query_async([[
            SELECT `uuid`, `name`, `model`, `full_access` AS `fullAccess`,
            `created_by` AS `createdBy`, `created_at` AS `createdAt`,
            `shared_levels` AS `sharedLevels`, `shared_queue` AS `sharedQueue`,
            `shared_queue_claim` AS `sharedQueueClaim`, `shared_queue_cancel` AS `sharedQueueCancel`
            FROM `nxtgn_crafting_bench_types`
        ]])

        if not res then return nil end

        for _, benchType in ipairs(res) do
            benchType.access = {}

            local res = oxmysql:query_async([[
                SELECT `access`, `ranks`
                FROM `nxtgn_crafting_bench_type_access`
                WHERE `bench_type` = ?
            ]], { benchType.uuid })

            if res and #res > 0 then
                for _, access in ipairs(res) do
                    local ranks = access.ranks and string.split(access.ranks, ',')

                    table.insert(benchType.access, {
                        identifier = access.access,
                        ranks = ranks
                    })
                end
            end
        end

        return res
    end,

    -- Search for a bench type by name.
    -- @param search: The search query to match against bench type names.
    -- @return: A table containing the search results.
    Search = function(search)
        local res = oxmysql:single_async([[
            SELECT `uuid`, `name`, `model`, `full_access` AS `fullAccess`,
            `created_by` AS `createdBy`, `created_at` AS `createdAt`,
            `shared_levels` AS `sharedLevels`, `shared_queue` AS `sharedQueue`,
            `shared_queue_claim` AS `sharedQueueClaim`, `shared_queue_cancel` AS `sharedQueueCancel`
            FROM `nxtgn_crafting_bench_types`
            WHERE LOWER(REPLACE(`name`, ' ', '')) LIKE LOWER(REPLACE(?, ' ', ''))
        ]], {
            '%' .. search .. '%'
        })

        return res
    end,

    -- Create a new bench type in the database.
    -- @param data: A table containing the bench type data.
    -- @return: UUID if the bench type was created, otherwise false.
    Create = function(data)
        if not data then return nil end

        local uuid = generateUUID()

        local res = oxmysql:query_async([[
            INSERT INTO `nxtgn_crafting_bench_types` (`uuid`, `name`, `model`, `full_access`, `created_by`, `shared_levels`, `shared_queue`, `shared_queue_claim`, `shared_queue_cancel`)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        ]],
            { uuid, data.name, data.model, data.fullAccess, data.createdBy, data.sharedLevels and 1 or 0, data
            .sharedQueue and 1 or 0, data.sharedQueueClaim or 'anyone', data.sharedQueueCancel or 'anyone' })

        if not res then return nil end

        if data.access then
            for _, access in pairs(data.access) do
                local ranks = ''

                if access.selectedRanks then
                    -- Convert the table to a comma-separated string.
                    ranks = table.concat(access.selectedRanks, ',')
                end

                oxmysql:query_async([[
                    INSERT INTO `nxtgn_crafting_bench_type_access` (`bench_type`, `access`, `ranks`)
                    VALUES (?, ?, ?)
                ]], { uuid, access.identifier, ranks })
            end
        end

        -- Insert categories and associated recipes.
        if not data.fullAccess and data.categories then
            for _, category in pairs(data.categories) do
                local benchTypeCategoryId = generateUUID()
                local res = oxmysql:query_async([[
                    INSERT INTO `nxtgn_crafting_bench_type_categories` (`uuid`, `bench_type`, `category`, `is_default_denied`)
                    VALUES (?, ?, ?, ?)
                ]], { benchTypeCategoryId, uuid, category.categoryId, category.isDefaultDenied })

                if res and #category.recipes > 0 then
                    for _, recipeId in pairs(category.recipes) do
                        oxmysql:query_async([[
                            INSERT INTO `nxtgn_crafting_bench_type_category_recipes` (`bench_type_category`, `recipe`)
                            VALUES (?, ?)
                        ]], { benchTypeCategoryId, recipeId })
                    end
                end
            end
        end

        return uuid
    end,

    -- Delete a specific bench type.
    -- @param id: The UUID of the bench type to delete.
    -- @return: True if the bench type was deleted, otherwise false.
    Delete = function(id)
        if not id then return nil end

        local res = oxmysql:query_async([[
            DELETE FROM `nxtgn_crafting_bench_types` WHERE `uuid` = ?
        ]], { id })

        return res
    end,

    -- Update a specific bench type in the database.
    -- @param data: A table containing updated data for the bench type.
    -- @return: True if the update was successful, otherwise false.
    Update = function(data)
        if not data then return nil end

        local res = oxmysql:query_async([[
            UPDATE `nxtgn_crafting_bench_types`
            SET `name` = ?, `model` = ?, `full_access` = ?,
                `shared_levels` = ?, `shared_queue` = ?, `shared_queue_claim` = ?, `shared_queue_cancel` = ?
            WHERE `uuid` = ?
        ]],
            { data.name, data.model, data.fullAccess, data.sharedLevels and 1 or 0, data.sharedQueue and 1 or 0, data
            .sharedQueueClaim or 'anyone', data.sharedQueueCancel or 'anyone', data.uuid })

        if not res then return nil end

        -- Remove and re-add the access list.
        oxmysql:query_async([[
            DELETE FROM `nxtgn_crafting_bench_type_access` WHERE `bench_type` = ?
        ]], { data.uuid })

        if data.access then
            for _, access in pairs(data.access) do
                local ranks = ''

                if access.selectedRanks then
                    -- Convert the table to a comma-separated string.
                    ranks = table.concat(access.selectedRanks, ',')
                end

                oxmysql:query_async([[
                    INSERT INTO `nxtgn_crafting_bench_type_access` (`bench_type`, `access`, `ranks`)
                    VALUES (?, ?, ?)
                ]], { data.uuid, access.identifier, ranks })
            end
        end

        -- Remove and re-add the categories and recipes.
        oxmysql:query_async([[
            DELETE FROM `nxtgn_crafting_bench_type_categories` WHERE `bench_type` = ?
        ]], { data.uuid })

        if not data.fullAccess and data.categories then
            for _, category in pairs(data.categories) do
                local benchTypeCategoryId = generateUUID()
                local res = oxmysql:query_async([[
                    INSERT INTO `nxtgn_crafting_bench_type_categories` (`uuid`, `bench_type`, `category`, `is_default_denied`)
                    VALUES (?, ?, ?, ?)
                ]], { benchTypeCategoryId, data.uuid, category.categoryId, category.isDefaultDenied })

                if res and #category.recipes > 0 then
                    for _, recipeId in pairs(category.recipes) do
                        oxmysql:query_async([[
                            INSERT INTO `nxtgn_crafting_bench_type_category_recipes` (`bench_type_category`, `recipe`)
                            VALUES (?, ?)
                        ]], { benchTypeCategoryId, recipeId })
                    end
                end
            end
        end

        return res
    end,

    -- Get shared global level for a bench type
    GetSharedLevel = function(benchTypeId)
        local res = oxmysql:single_async([[
            SELECT `level`
            FROM `nxtgn_crafting_bench_type_levels`
            WHERE `bench_type` = ? AND `category` IS NULL
        ]], { benchTypeId })

        if not res or res.level == nil then return nil end
        return res.level
    end,

    -- Set shared global level for a bench type
    SetSharedLevel = function(benchTypeId, level)
        oxmysql:update_async([[
            INSERT INTO `nxtgn_crafting_bench_type_levels` (`bench_type`, `category`, `level`)
            VALUES (?, NULL, ?)
            ON DUPLICATE KEY UPDATE `level` = VALUES(`level`)
        ]], { benchTypeId, level })
        return true
    end,

    -- Get shared category level for a bench type
    GetSharedCategoryLevel = function(benchTypeId, categoryId)
        local res = oxmysql:single_async([[
            SELECT `level`
            FROM `nxtgn_crafting_bench_type_levels`
            WHERE `bench_type` = ? AND `category` = ?
        ]], { benchTypeId, categoryId })

        if not res or res.level == nil then return nil end
        return res.level
    end,

    -- Set shared category level for a bench type
    SetSharedCategoryLevel = function(benchTypeId, categoryId, level)
        oxmysql:update_async([[
            INSERT INTO `nxtgn_crafting_bench_type_levels` (`bench_type`, `category`, `level`)
            VALUES (?, ?, ?)
            ON DUPLICATE KEY UPDATE `level` = VALUES(`level`)
        ]], { benchTypeId, categoryId, level })
        return true
    end,

    -- Clear
    Clear = function()
        oxmysql:query_async('DELETE FROM `nxtgn_crafting_bench_type_category_recipes`')
        oxmysql:query_async('DELETE FROM `nxtgn_crafting_bench_type_categories`')
        oxmysql:query_async('DELETE FROM `nxtgn_crafting_bench_type_access`')
        oxmysql:query_async('DELETE FROM `nxtgn_crafting_bench_types`')
        oxmysql:query_async('DELETE FROM `nxtgn_crafting_bench_type_levels`')
    end
}

-- BenchLocations management table with functions to fetch, create, update, and delete bench locations.
BenchLocations = {
    -- Fetch a list of bench locations based on filters.
    -- @param data: A table containing filters, order, count, and offset for pagination.
    -- @return: A table containing rows of bench locations and the page count.
    Fetch = function(data)
        if not data then return nil end
        local columnFiltersTable, i = {}, 0

        -- Build the filter query.
        for k, v in pairs(data.columnFilters) do
            if i == 0 then
                table.insert(columnFiltersTable, "WHERE")
            else
                table.insert(columnFiltersTable, "AND")
            end
            if type(v) == 'string' then
                table.insert(columnFiltersTable, "nxbl.`" .. k .. "` LIKE '" .. v .. "%'")
            else
                table.insert(columnFiltersTable, "nxbl.`" .. k .. "` IN ('" .. table.concat(v, "','") .. "')")
            end
            i = i + 1
        end
        local columnFilters = table.concat(columnFiltersTable, ' ')

        -- Fetch the count of rows.
        local countRow = oxmysql:single_async(([[SELECT COUNT(*) AS `count` FROM `nxtgn_crafting_bench_locations` nxbl %s]])
        :format(columnFilters))

        if not countRow or countRow.count == nil then return nil end

        -- Fetch the actual rows.
        local res = oxmysql:query_async(([[
            SELECT nxbl.`uuid`, nxbl.`bench_type` AS `benchType`, nxbl.`loc_x` AS `locationX`, nxbl.`loc_y` AS `locationY`, nxbl.`loc_z` AS `locationZ`,
            nxbl.`loc_h` AS `locationH`, nxbl.`created_by` AS `createdBy`, nxbl.`created_at` AS `createdAt`, nxbl.`is_portable` AS `isPortable`,
            nxbl.`shared_levels` AS `sharedLevels`, nxbl.`shared_queue` AS `sharedQueue`, nxbl.`routing_bucket` AS `routingBucket`, ncbt.`name` AS `benchTypeName`
            FROM `nxtgn_crafting_bench_locations` nxbl
            LEFT JOIN `nxtgn_crafting_bench_types` ncbt ON ncbt.`uuid` = nxbl.`bench_type`
            %s
            ORDER BY nxbl.`%s` %s LIMIT %s OFFSET %s
        ]]):format(columnFilters, data.orderColumn, data.orderDirection, data.count, data.offset))

        if not res then return nil end

        return { rows = res, pageCount = math.ceil(countRow.count / data.count) }
    end,

    -- Fetch details of a specific bench location.
    -- @param id: The UUID of the bench location.
    -- @return: A table with the bench location details.
    FetchOne = function(id)
        local res = oxmysql:single_async([[
            SELECT nxbl.`bench_type` AS `benchType`, nxbl.`loc_x` AS `locationX`, nxbl.`loc_y` AS `locationY`, nxbl.`loc_z` AS `locationZ`,
            nxbl.`loc_h` AS `locationH`, nxbl.`created_by` AS `createdBy`, nxbl.`created_at` AS `createdAt`, nxbl.`is_portable` AS `isPortable`,
            nxbl.`shared_levels` AS `sharedLevels`, nxbl.`shared_queue` AS `sharedQueue`, nxbl.`routing_bucket` AS `routingBucket`,
            ncbt.`name` AS `benchTypeName`
            FROM `nxtgn_crafting_bench_locations` nxbl
            LEFT JOIN `nxtgn_crafting_bench_types` ncbt ON ncbt.`uuid` = nxbl.`bench_type`
            WHERE nxbl.`uuid` = ?
        ]], { id })

        if not res then return nil end
        return res
    end,

    -- Fetch all bench locations.
    -- @return: A table containing all bench locations.
    FetchAll = function()
        local res = oxmysql:query_async([[
            SELECT `uuid`, `bench_type` AS `benchType`, `loc_x` AS `locationX`, `loc_y` AS `locationY`,
            `loc_z` AS `locationZ`, `loc_h` AS `locationH`, `created_by` AS `createdBy`, `created_at` AS `createdAt`, `is_portable` AS `isPortable`,
            `shared_levels` AS `sharedLevels`, `shared_queue` AS `sharedQueue`, `routing_bucket` AS `routingBucket`
            FROM `nxtgn_crafting_bench_locations`
        ]])

        if not res then return nil end
        return res
    end,

    -- Create a new bench location in the database.
    -- @param data: A table containing the bench location data.
    -- @return: UUID if the bench location was created, otherwise false.
    Create = function(data)
        if not data then return false end

        local uuid = generateUUID()

        local res = oxmysql:query_async([[
            INSERT INTO `nxtgn_crafting_bench_locations` (`uuid`, `bench_type`, `loc_x`, `loc_y`, `loc_z`, `loc_h`, `created_by`, `is_portable`, `shared_levels`, `shared_queue`, `routing_bucket`)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ]],
            { uuid, data.benchType, data.location.x, data.location.y, data.location.z, data.location.w, data.createdBy,
                data.isPortable, data.sharedLevels, data.sharedQueue, data.routingBucket })

        if not res then
            return false
        end

        return uuid
    end,

    -- Update a bench location in the database.
    -- @param data: A table containing the updated bench location data.
    -- @return: True if the update was successful, otherwise false.
    Update = function(data)
        if not data then return false end

        local res = oxmysql:query_async([[
            UPDATE `nxtgn_crafting_bench_locations`
            SET `bench_type` = ?, `loc_x` = ?, `loc_y` = ?, `loc_z` = ?, `loc_h` = ?, `is_portable` = ?,
                `shared_levels` = ?, `shared_queue` = ?
            WHERE `uuid` = ?
        ]],
            { data.benchType, data.location.x, data.location.y, data.location.z, data.location.w, data.isPortable, data
                .sharedLevels, data.sharedQueue, data.uuid })

        return res ~= nil
    end,

    -- Delete a specific bench location.
    -- @param id: The UUID of the bench location to delete.
    -- @return: True if the bench location was deleted, otherwise false.
    Delete = function(id)
        if not id then return false end

        local res = oxmysql:query_async([[
            DELETE FROM `nxtgn_crafting_bench_locations` WHERE `uuid` = ?
        ]], { id })

        return res ~= nil
    end,

    AddPlayerCraft = function(src, data)
        if not data then return false end

        local res = oxmysql:query_async([[
            INSERT INTO `nxtgn_crafting_bench_location_crafts` (`location`, `user_id`, `recipe`, `quantity`, `started_at`, `completed_at`, `craft_id`, `removed_items`, `result_items`)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        ]], {
            data.location,
            data.userId,
            data.recipe,
            data.quantity,
            data.startedAt,
            data.completedAt,
            data.craftId,
            json.encode(data.removedItems),
            json.encode(data.resultItems)
        })

        return res ~= nil
    end,

    RemovePlayerCraft = function(craftId)
        if not craftId then return false end

        local res = oxmysql:query_async([[
            DELETE FROM `nxtgn_crafting_bench_location_crafts` WHERE `craft_id` = ?
        ]], { craftId })

        return res ~= nil
    end,

    -- Sum queued crafts for a user/recipe since epoch across all locations
    SumQueuedCraftsSince = function(userId, recipeId, sinceEpoch)
        local row = oxmysql:single_async([[
            SELECT COALESCE(SUM(`quantity`), 0) AS `used`
            FROM `nxtgn_crafting_bench_location_crafts`
            WHERE `user_id` = ? AND `recipe` = ? AND `started_at` >= ?
        ]], { userId, recipeId, sinceEpoch })
        if not row or row.used == nil then return 0 end
        return tonumber(row.used) or 0
    end,

    -- Detailed queued crafts (quantity and startedAt) since epoch across all locations
    GetQueuedCraftEventsSince = function(userId, recipeId, sinceEpoch)
        local rows = oxmysql:query_async([[
            SELECT `quantity`, `started_at` AS `ts`
            FROM `nxtgn_crafting_bench_location_crafts`
            WHERE `user_id` = ? AND `recipe` = ? AND `started_at` >= ?
            ORDER BY `started_at` ASC
        ]], { userId, recipeId, sinceEpoch })
        if not rows then return {} end
        return rows
    end,

    UpdatePlayerCraft = function(craftId, updatedData)
        if not craftId or not updatedData then return false end

        local fields, values = {}, {}
        local columns = {
            startedAt = "started_at",
            completedAt = "completed_at",
            pausedAt = "paused_at",
            removedItems = "removed_items",
            resultItems = "result_items",
            quantity = "quantity"
        }

        for key, column in pairs(columns) do
            local value = updatedData[key]
            if value ~= nil then
                table.insert(fields, "`" .. column .. "` = ?")
                table.insert(values, (key == "removedItems" or key == "resultItems") and json.encode(value) or value)
            end
        end

        if #fields == 0 then return false end

        table.insert(values, craftId)
        local query = ("UPDATE `nxtgn_crafting_bench_location_crafts` SET %s WHERE `craft_id` = ?"):format(table.concat(
        fields, ", "))

        return oxmysql:query_async(query, values) ~= nil
    end,

    GetPlayerCrafts = function(userId, location)
        local res = oxmysql:query_async([[
            SELECT `craft_id` AS `craftId`, `recipe`, `quantity`, `started_at` AS `startedAt`, `completed_at` AS `completedAt`, `paused_at` AS `pausedAt`, `removed_items` AS `removedItems`, `result_items` AS `resultItems`
            FROM `nxtgn_crafting_bench_location_crafts`
            WHERE `user_id` = ? AND `location` = ?
        ]], { userId, location })

        if not res then return nil end

        for _, craft in ipairs(res) do
            if craft.removedItems then
                craft.removedItems = json.decode(craft.removedItems)
            end

            if craft.resultItems then
                craft.resultItems = json.decode(craft.resultItems)
            end
        end

        return res
    end,

    GetPlayerCraft = function(craftId)
        local res = oxmysql:single_async([[
            SELECT `craft_id` AS `craftId`, `user_id` as `userId`, `recipe`, `quantity`, `started_at` AS `startedAt`, `completed_at` AS `completedAt`, `paused_at` AS `pausedAt`, `removed_items` AS `removedItems`, `result_items` AS `resultItems`
            FROM `nxtgn_crafting_bench_location_crafts`
            WHERE `craft_id` = ?
        ]], { craftId })

        if not res then return nil end

        if res.removedItems then
            res.removedItems = json.decode(res.removedItems)
        end

        if res.resultItems then
            res.resultItems = json.decode(res.resultItems)
        end

        return res
    end,

    PausePlayerCrafts = function(userId, location)
        local res = oxmysql:query_async([[
            UPDATE `nxtgn_crafting_bench_location_crafts`
            SET `paused_at` = ?
            WHERE `user_id` = ? AND `location` = ? AND (`paused_at` IS NULL OR `paused_at` = 0)
        ]], { os.time(), userId, location })

        return res ~= nil
    end,

    PauseAllPlayerCrafts = function()
        local res = oxmysql:query_async([[
            UPDATE `nxtgn_crafting_bench_location_crafts`
            SET `paused_at` = ?
            WHERE `paused_at` IS NULL OR `paused_at` = 0
        ]], { os.time() })

        return res ~= nil
    end,

    PauseAllCraftsForPlayer = function(userId)
        if not userId then return false end

        local res = oxmysql:query_async([[
            UPDATE `nxtgn_crafting_bench_location_crafts`
            SET `paused_at` = ?
            WHERE `user_id` = ? AND (`paused_at` IS NULL OR `paused_at` = 0)
        ]], { os.time(), userId })

        return res ~= nil
    end,

    GetPlayerQueueCount = function(playerId, locationId)
        local res = oxmysql:single_async([[
            SELECT COUNT(*) as count
            FROM `nxtgn_crafting_bench_location_crafts`
            WHERE `user_id` = ? AND `location` = ? AND completed_at > ?
        ]], { playerId, locationId, os.time() })
        return res and res.count or 0
    end,

    -- Count all active crafts for a player across ALL locations
    GetPlayerGlobalQueueCount = function(playerId)
        local res = oxmysql:single_async([[
            SELECT COUNT(*) as count
            FROM `nxtgn_crafting_bench_location_crafts`
            WHERE `user_id` = ? AND completed_at > ?
        ]], { playerId, os.time() })
        return res and res.count or 0
    end,

    -- Fetch all crafts for a location (shared queue mode)
    GetLocationCrafts = function(location)
        local res = oxmysql:query_async([[
            SELECT `craft_id` AS `craftId`, `user_id` AS `userId`, `recipe`, `quantity`, `started_at` AS `startedAt`, `completed_at` AS `completedAt`, `paused_at` AS `pausedAt`, `removed_items` AS `removedItems`, `result_items` AS `resultItems`
            FROM `nxtgn_crafting_bench_location_crafts`
            WHERE `location` = ?
        ]], { location })

        if not res then return nil end

        for _, craft in ipairs(res) do
            if craft.removedItems then
                craft.removedItems = json.decode(craft.removedItems)
            end

            if craft.resultItems then
                craft.resultItems = json.decode(craft.resultItems)
            end
        end

        return res
    end,

    -- Count active crafts at a location (shared queue mode)
    GetLocationQueueCount = function(locationId)
        local res = oxmysql:single_async([[
            SELECT COUNT(*) as count
            FROM `nxtgn_crafting_bench_location_crafts`
            WHERE `location` = ? AND completed_at > ?
        ]], { locationId, os.time() })
        return res and res.count or 0
    end,

    -- Clear all bench location data from the database.
    Clear = function()
        oxmysql:query_async('DELETE FROM `nxtgn_crafting_bench_locations`')
        oxmysql:query_async('DELETE FROM `nxtgn_crafting_bench_location_crafts`')
    end
}
