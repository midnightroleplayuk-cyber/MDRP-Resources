CREATE TABLE `tk_evidence_data` (
	`id` int(11) NOT NULL,
	`lockerId` VARCHAR(255) NULL,
	`identifier` VARCHAR(60) NULL,
	`coords` VARCHAR(255) NOT NULL,
	`time` INT(40) NOT NULL,
	`data` LONGTEXT,

	PRIMARY KEY (`id`)
);

CREATE TABLE `tk_evidence_lockers` (
	`id` VARCHAR(255) NOT NULL,
	`name` VARCHAR(255) NOT NULL,

	PRIMARY KEY (`id`)
);


-- ESX:
ALTER TABLE `users` ADD COLUMN `gsr` INT(40);

-- QB:
ALTER TABLE `players` ADD COLUMN `gsr` INT(40);