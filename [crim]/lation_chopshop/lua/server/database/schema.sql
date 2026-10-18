CREATE TABLE IF NOT EXISTS `lation_chopshop` (
    `identifier` VARCHAR(255) NOT NULL,
    `name`       VARCHAR(255) DEFAULT NULL,
    `level`      INT(11)      NOT NULL DEFAULT 1,
    `exp`        INT(11)      NOT NULL DEFAULT 0,
    `vehicles`   INT(11)      NOT NULL DEFAULT 0,
    `parts`      INT(11)      NOT NULL DEFAULT 0,
    PRIMARY KEY (`identifier`),
    KEY `idx_exp` (`exp`)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `lation_chopshop_config` (
    `key`        VARCHAR(64)  NOT NULL,
    `value`      LONGTEXT     NOT NULL,
    `updated_at` TIMESTAMP    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `created_at` TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`key`)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `lation_chopshop_history` (
    `id`         INT(11)      NOT NULL AUTO_INCREMENT,
    `identifier` VARCHAR(255) DEFAULT NULL,
    `type`       VARCHAR(32)  NOT NULL DEFAULT 'part',
    `created_at` TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_history_created_at` (`created_at`)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `lation_chopshop_contracts` (
    `identifier`     VARCHAR(255) NOT NULL,
    `contract`       LONGTEXT     DEFAULT NULL,
    `cooldown_until` INT(11)      DEFAULT NULL,
    `updated_at`     TIMESTAMP    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`identifier`)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

INSERT IGNORE INTO `lation_chopshop_config` (`key`, `value`) VALUES
('setup', '{"interact":"auto","notify":"ox_lib","progress":"ox_lib","menu":"ox_lib","dialogs":"ox_lib","version":true,"blacklistedJobs":["examplejob1","examplejob2"],"police":["police","sheriff"],"stats":{"vehicles":true,"parts":true},"leaderboard":true}'),
('start', '{"peds":[{"coords":{"x":-169.0171,"y":-1352.3877,"z":29.9817,"w":91.8764},"model":"a_m_m_bevhills_01","scenario":"WORLD_HUMAN_CLIPBOARD"}],"randomPed":false,"blip":{"enable":true,"sprite":225,"color":2,"scale":0.9,"label":"Chop Shop"},"hours":{"min":0,"max":24},"police":0,"allowOwned":true,"deleteOwned":false}'),
('experience', '{"levels":{"1":0,"2":5000,"3":10000,"4":25000,"5":75000},"rewards":{"1":{"xp":{"min":25,"max":35}},"2":{"xp":{"min":35,"max":50}},"3":{"xp":{"min":50,"max":75}},"4":{"xp":{"min":75,"max":100}},"5":{"xp":{"min":100,"max":150}}}}'),
('contracts', '{"item":"ls_chop_contract","account":"cash","completionCooldown":0,"despawnVehicle":false,"allowedClasses":[0,1,2,3,4,5,6,7],"tiers":{"street":{"label":"Street","minLevel":1,"vehicleClasses":[0,1,3],"durationSeconds":3600,"cashBonus":500},"suv":{"label":"SUV","minLevel":2,"vehicleClasses":[2],"durationSeconds":4500,"cashBonus":750},"muscle":{"label":"Muscle","minLevel":3,"vehicleClasses":[4],"durationSeconds":5400,"cashBonus":1000},"sports":{"label":"Sports","minLevel":4,"vehicleClasses":[5,6],"durationSeconds":6300,"cashBonus":1500},"super":{"label":"Super","minLevel":5,"vehicleClasses":[7],"durationSeconds":7200,"cashBonus":2500}}}'),
('locations', '{"enabled":false,"radius":25,"coords":[],"blips":{"enable":false,"sprite":225,"color":1,"scale":0.9,"label":"Chop Location","zone":true,"contractOnly":true}}'),
('minigame', '{"wheel":{"lugHoldMs":2150,"audioEnabled":true},"torque":{"rotationsRequired":4,"decayPerSec":2,"minSpeed":4,"fullSpeed":12},"connector":{"flashMs":450},"tap":{"progressRequired":100,"decayPerSec":30,"minCps":2,"fullCps":4.5},"door":{"boltCount":4,"boltHoldMs":2150}}'),
('items', '{"impact_drill":{"item":"ls_impact_drill","require":true,"break_chance":10},"car_jack":{"item":"ls_car_jack","require":true},"parts":{"wheel":"ls_salvaged_wheel","battery":"ls_salvaged_battery","radiator":"ls_salvaged_radiator","alternator":"ls_salvaged_alternator","ecu":"ls_salvaged_ecu","turbo":"ls_salvaged_turbo","door":"ls_salvaged_door"},"prep":{"standModel":"imp_prop_axel_stand_01a","drillProp":"sf_prop_impact_driver_01a","cornersRequired":4,"standInboardOffset":0.38,"standLongitudinalOffset":0.2}}'),
('shops', '{"tool":{"enable":true,"account":"cash","items":{"1":{"item":"ls_impact_drill","price":1500,"icon":"screwdriver-wrench"},"2":{"item":"ls_car_jack","price":750,"icon":"car"}}},"swap":{"enable":true,"account":"cash","items":{"1":{"item":"ls_salvaged_wheel","amount":1,"payout":150,"icon":"life-ring"},"2":{"item":"ls_salvaged_battery","amount":1,"payout":200,"icon":"car-battery"},"3":{"item":"ls_salvaged_radiator","amount":1,"payout":180,"icon":"fan"},"4":{"item":"ls_salvaged_alternator","amount":1,"payout":220,"icon":"bolt"},"5":{"item":"ls_salvaged_ecu","amount":1,"payout":300,"icon":"microchip"},"6":{"item":"ls_salvaged_turbo","amount":1,"payout":350,"icon":"wind"},"7":{"item":"ls_salvaged_door","amount":1,"payout":100,"icon":"door-open"}}}}'),
('logs', '{"service":"none","screenshots":false,"events":{"contract_issued":false,"contract_completed":false,"contract_dismissed":false,"chop_started":false,"vehicle_prepped":false,"part_chopped":false,"strip_completed":false,"tool_broke":false,"item_purchased":false,"parts_swapped":false,"level_up":false,"owned_vehicle_deleted":false},"discord":{"name":"Chop Shop","link":"","image":"https://i.imgur.com/ILTkWBh.png","footer":"https://i.imgur.com/ILTkWBh.png"}}');
