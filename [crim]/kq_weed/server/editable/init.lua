local tables = {
    ['kq_weed_tables'] = [[
CREATE TABLE IF NOT EXISTS `kq_weed_tables` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tag` varchar(255) NOT NULL DEFAULT '0',
  `placed_by` varchar(50) DEFAULT NULL,
  `coords` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`coords`)),
  `rotation` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`rotation`)),
  `routing_bucket` int(11) NOT NULL,
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`metadata`)),
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `tag` (`tag`),
  KEY `placed_by` (`placed_by`),
  KEY `created_at` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;
    ]],
    ['kq_weed_presses'] = [[
CREATE TABLE IF NOT EXISTS `kq_weed_presses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tag` varchar(255) NOT NULL DEFAULT '0',
  `placed_by` varchar(50) DEFAULT NULL,
  `coords` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`coords`)),
  `rotation` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`rotation`)),
  `routing_bucket` int(11) DEFAULT NULL,
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`metadata`)),
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `tag` (`tag`),
  KEY `placed_by` (`placed_by`),
  KEY `created_at` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;
    ]],
    ['kq_weed_pots'] = [[
CREATE TABLE IF NOT EXISTS `kq_weed_pots` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tag` varchar(255) NOT NULL DEFAULT '0',
  `placed_by` varchar(50) DEFAULT NULL,
  `coords` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`coords`)),
  `rotation` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`rotation`)),
  `routing_bucket` int(11) NOT NULL,
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`metadata`)),
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `tag` (`tag`),
  KEY `placed_by` (`placed_by`),
  KEY `created_at` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;
    ]],
    ['kq_weed_plants'] = [[
CREATE TABLE IF NOT EXISTS `kq_weed_plants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tag` varchar(255) NOT NULL DEFAULT '',
  `state` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`state`)),
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`metadata`)),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `tag` (`tag`) USING BTREE,
  KEY `updated_at` (`updated_at`),
  KEY `tag_index` (`tag`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;
    ]],
}

local function EnsureTablesExists()

    for tableName, insertQuery in pairs(tables) do
        local checkQuery = [[
            SELECT COUNT(*) as count
            FROM information_schema.tables
            WHERE table_name = ']] .. tableName .. [['
        ]]

        local result = DB.SqlQuery(checkQuery)
        if result and result[1] and result[1].count == 0 then
            -- Table does not exist, create it
            DB.SqlMutate(insertQuery)
            print("^2" .. tableName .. " table created successfully.")
        end
    end
end

Citizen.CreateThread(function()
    --Call the function to ensure the tables exists
    Citizen.SetTimeout(50, EnsureTablesExists)
end)

-- Fallback for dynamic door creation allowance
SetConvarReplicated('game_enableDynamicDoorCreation', true)

