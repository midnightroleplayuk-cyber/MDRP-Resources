CREATE TABLE IF NOT EXISTS `lgmods_personal_loans` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `citizen_id` VARCHAR(50) NOT NULL,
  `amount` INT NOT NULL, 
  `remaining_amount` INT NOT NULL, 
  `interest_rate` FLOAT NOT NULL, 
  `term_days` INT NOT NULL, 
  `payment_amount` INT NOT NULL, 
  `next_payment_date` TIMESTAMP NOT NULL, 
  `status` VARCHAR(50) NOT NULL DEFAULT 'active',  'defaulted'
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `citizen_loan_index` (`citizen_id`, `status`)
);

CREATE TABLE IF NOT EXISTS `lgmods_loan_payments` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `loan_id` INT(11) NOT NULL,
  `amount` INT NOT NULL,
  `payment_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` VARCHAR(50) NOT NULL DEFAULT 'completed', 
  PRIMARY KEY (`id`),
  FOREIGN KEY (`loan_id`) REFERENCES `lgmods_personal_loans`(`id`) ON DELETE CASCADE
); 