-- 17: permission to call in air drops (ranks that can handle diplomacy: the boss and underboss by default)
UPDATE `vg_ranks`
SET `permissions` = REPLACE(`permissions`, '"diplomacy"', '"diplomacy","airdrops"')
WHERE `permissions` LIKE '%"diplomacy"%' AND `permissions` NOT LIKE '%"airdrops"%';
