INSERT INTO `addon_account` (`name`, `label`, `shared`) VALUES
	('firefighter', 'Firefighter', 1)
;

INSERT INTO `addon_inventory` (`name`, `label`, `shared`) VALUES
	('firefighter', 'Firefighter', 1)
;

INSERT INTO `jobs` (`name`, `label`, `whitelisted`) VALUES 
    ('firefighter', 'Firefighter', 1)
;

INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES 
    ('firefighter', 0, 'recruit', 'Recruit', 0, '{}', '{}'),
    ('firefighter', 1, 'operator', 'Operator', 0, '{}', '{}'),
    ('firefighter', 2, 'company_officer', 'Company Officer', 0, '{}', '{}'),
    ('firefighter', 3, 'boss', 'Chief', 0, '{}', '{}')
;