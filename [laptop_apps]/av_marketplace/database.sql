CREATE TABLE IF NOT EXISTS `av_marketplace_posts` (
  `post_id` VARCHAR(60) NOT NULL,
  `owner` VARCHAR(60) NOT NULL,
  `category` VARCHAR(50) NOT NULL,
  `title` VARCHAR(255) NOT NULL,
  `price` INT NOT NULL,
  `description` LONGTEXT NOT NULL,
  `image` LONGTEXT NOT NULL,
  `seller` VARCHAR(100) NOT NULL,
  `created_at` BIGINT NOT NULL,
  PRIMARY KEY (`post_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `av_marketplace_conversations` (
  `id` INT AUTO_INCREMENT,
  `conversation_id` VARCHAR(60) NOT NULL,
  `post_id` VARCHAR(60) NOT NULL,
  `buyer` VARCHAR(60) NOT NULL,
  `seller` VARCHAR(60) NOT NULL,
  `last_message` LONGTEXT DEFAULT NULL,
  `updated_at` BIGINT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_conversation` (`conversation_id`),
  UNIQUE KEY `unique_chat` (`post_id`, `buyer`, `seller`),
  CONSTRAINT `fk_post` FOREIGN KEY (`post_id`)
  REFERENCES `av_marketplace_posts` (`post_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `av_marketplace_messages` (
  `id` INT AUTO_INCREMENT,
  `conversation_id` VARCHAR(60) NOT NULL,
  `sender` VARCHAR(60) NOT NULL,
  `message` LONGTEXT NOT NULL,
  `type` VARCHAR(20) NOT NULL DEFAULT 'text',
  `metadata` LONGTEXT DEFAULT NULL,
  `is_read` TINYINT(1) NOT NULL DEFAULT 0,
  `created_at` BIGINT NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_conversation` (`conversation_id`),
  CONSTRAINT `fk_conversation` FOREIGN KEY (`conversation_id`)
  REFERENCES `av_marketplace_conversations` (`conversation_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;