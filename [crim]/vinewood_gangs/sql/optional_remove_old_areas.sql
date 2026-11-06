-- OPTIONAL. Territory is hexes now, so these tables from the old drawn-areas system are no longer used.
-- They're left alone on purpose (nothing is deleted automatically). Run this yourself if you want them gone.
DROP TABLE IF EXISTS `vg_zone_influence`;
DROP TABLE IF EXISTS `vg_zone_state`;
DROP TABLE IF EXISTS `vg_zones`;
