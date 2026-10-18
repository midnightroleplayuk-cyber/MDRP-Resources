-- Mission Plaza automatic doors for ox_doorlock (table `ox_doorlock`):
-- the entrance slider pair and the two garage rollers (settings: config.lua, section 2). These leaves are moved by the
-- station resource itself; locked = it closes them (also when open) and keeps them shut, unlocked = automatic.
-- They start unlocked. groups {"police":0} is a placeholder - set your police job(s) and grades.
-- Re-running this file replaces only these doors.
DELETE FROM `ox_doorlock` WHERE `name` IN ('nobs_mp_autodoor_entrance', 'nobs_mp_autodoor_garage_bay1', 'nobs_mp_autodoor_garage_bay2');
INSERT INTO `ox_doorlock` (`name`, `data`) VALUES
	('nobs_mp_autodoor_entrance', '{"maxDistance":2.0,"state":0,"groups":{"police":0},"hideUi":false,"coords":{"x":414.8296,"y":-342.10388,"z":45.94298},"doors":[{"coords":{"x":414.41126,"y":-341.9381,"z":45.94298},"model":372540780,"heading":158.38},{"coords":{"x":415.24795,"y":-342.26967,"z":45.94298},"model":633202419,"heading":158.38}]}'),
	('nobs_mp_autodoor_garage_bay1', '{"maxDistance":4.0,"state":0,"groups":{"police":0},"hideUi":false,"coords":{"x":376.37792,"y":-332.22242,"z":45.94298},"model":-604325261,"heading":248.38}'),
	('nobs_mp_autodoor_garage_bay2', '{"maxDistance":4.0,"state":0,"groups":{"police":0},"hideUi":false,"coords":{"x":372.32529,"y":-342.44868,"z":45.94298},"model":-604325261,"heading":248.38}');
