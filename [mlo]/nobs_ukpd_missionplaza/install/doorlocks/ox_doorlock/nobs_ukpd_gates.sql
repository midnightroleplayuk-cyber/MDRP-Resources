-- Mission Plaza vehicle gates for ox_doorlock (table `ox_doorlock`):
-- leaf model hash, hinge coords and closed heading, checked against the exterior map.
-- The station keeps swinging the leaves and follows these doors' lock (MPGateConfig.controller
-- 'builtin' or 'ox_doorlock'): locked = the gate closes and stays shut, unlocked = automatic for nearby players.
-- The police yard exit starts locked and relocks 15 s after it is unlocked; the public entrance starts unlocked.
-- groups {"police":0} is a placeholder - set your police job(s) and grades.
-- Re-running this file replaces only these doors (names starting nobs_mp_gate_).
DELETE FROM `ox_doorlock` WHERE `name` LIKE 'nobs\_mp\_gate\_%';
INSERT INTO `ox_doorlock` (`name`, `data`) VALUES
	('nobs_mp_gate_entrance', '{"maxDistance":10.0,"state":0,"groups":{"police":0},"hideUi":false,"coords":{"x":421.40557,"y":-358.65017,"z":46.20468},"doors":[{"coords":{"x":418.96422,"y":-361.47023,"z":46.17608},"model":1895768305,"heading":229.12},{"coords":{"x":423.84692,"y":-355.83011,"z":46.23329},"model":1895768305,"heading":49.12}]}'),
	('nobs_mp_gate_exit', '{"maxDistance":10.0,"state":1,"groups":{"police":0},"hideUi":false,"coords":{"x":374.95019,"y":-381.44708,"z":45.74862},"doors":[{"coords":{"x":371.23333,"y":-381.13431,"z":45.73028},"model":1895768305,"heading":175.19},{"coords":{"x":378.66706,"y":-381.75984,"z":45.76696},"model":1895768305,"heading":355.19}],"autolock":15}');
