-- 14: street dealing permission for existing gangs (every rank that can tag can also deal)
UPDATE `vg_ranks`
SET `permissions` = REPLACE(`permissions`, '"graffiti"', '"graffiti","sell_drugs"')
WHERE `permissions` LIKE '%"graffiti"%' AND `permissions` NOT LIKE '%"sell_drugs"%';
