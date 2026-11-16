-- apex_phone: full database schema (reference / manual install).
-- The resource creates and migrates ALL of these tables by itself on start (CREATE TABLE IF NOT EXISTS + missing
-- columns + indexes), so running this file is OPTIONAL. It is safe to run on an existing database: every statement is
-- IF NOT EXISTS and nothing is dropped or altered. ESX: the resource also adds `users`.`phone_number` (VARCHAR(20)) by itself.
-- Generated from the server scripts of this version; do not edit by hand (edit the CREATE in the .lua instead).

-- apex_phone_accounts (server/main.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_accounts` (
  `citizenid` VARCHAR(64) NOT NULL,
  `account_id` VARCHAR(20) NOT NULL,
  `username` VARCHAR(32) NOT NULL,
  `phone` VARCHAR(20) NOT NULL,
  `pin` VARCHAR(100) NOT NULL DEFAULT '1225',
  `avatar` INT NOT NULL DEFAULT 1,
  `device_id` VARCHAR(32) NULL,
  `sim_id` VARCHAR(32) NULL,
  `settings` LONGTEXT NULL,
  `layout` LONGTEXT NULL,
  `face` LONGTEXT NULL,
  `created` BIGINT NOT NULL,
  `last_seen` BIGINT NULL,
  `pin_len` TINYINT NULL,
  `avatar_photo` LONGTEXT NULL,
  PRIMARY KEY (`citizenid`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `ux_phone` (`phone`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_admin (server/overlay.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_admin` (
  `k` VARCHAR(64) NOT NULL,
  `v` LONGTEXT NOT NULL,
  `updated` BIGINT NOT NULL,
  `by_name` VARCHAR(100) NULL,
  PRIMARY KEY (`k`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_admin_log (server/overlay.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_admin_log` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `at` BIGINT NOT NULL,
  `admin` VARCHAR(100) NULL,
  `ident` VARCHAR(80) NULL,
  `action` VARCHAR(64) NOT NULL,
  `detail` VARCHAR(600) NULL,
  PRIMARY KEY (`id`),
  KEY `at` (`at`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_app_grants (server/main.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_app_grants` (
  `owner` VARCHAR(64) NOT NULL,
  `app` VARCHAR(64) NOT NULL,
  `perm` VARCHAR(16) NOT NULL,
  `created` BIGINT NOT NULL,
  PRIMARY KEY (`owner`,`app`,`perm`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_app_ratings (server/appstore.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_app_ratings` (
  `owner` VARCHAR(64) NOT NULL,
  `app` VARCHAR(64) NOT NULL,
  `stars` TINYINT NOT NULL,
  `title` VARCHAR(60) NULL,
  `text` VARCHAR(300) NULL,
  `username` VARCHAR(32) NULL,
  `created` BIGINT NOT NULL,
  PRIMARY KEY (`owner`,`app`),
  KEY `app` (`app`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_bills (server/main.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_bills` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `owner` VARCHAR(64) NOT NULL,
  `sender` VARCHAR(64) NULL,
  `sender_name` VARCHAR(64) NOT NULL,
  `sender_cid` VARCHAR(64) NULL,
  `society` VARCHAR(50) NULL,
  `amount` INT NOT NULL,
  `reason` VARCHAR(160) NULL,
  `status` VARCHAR(10) NOT NULL DEFAULT 'pending',
  `created` BIGINT NOT NULL,
  `paid_at` BIGINT NULL,
  KEY `owner` (`owner`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_blocks (server/main.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_blocks` (
  `owner` VARCHAR(64) NOT NULL,
  `number` VARCHAR(20) NOT NULL,
  `created` BIGINT NOT NULL,
  PRIMARY KEY (`owner`,`number`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_calls (server/main.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_calls` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `owner` VARCHAR(64) NOT NULL,
  `number` VARCHAR(20) NOT NULL,
  `name` VARCHAR(64) NULL,
  `outgoing` TINYINT NOT NULL DEFAULT 1,
  `answered` TINYINT NOT NULL DEFAULT 0,
  `video` TINYINT NOT NULL DEFAULT 0,
  `duration` INT NOT NULL DEFAULT 0,
  `created` BIGINT NOT NULL,
  `status` VARCHAR(12) NULL,
  KEY `owner` (`owner`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_capp_items (server/capps.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_capp_items` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `app` VARCHAR(32) NOT NULL,
  `module` VARCHAR(24) NOT NULL,
  `kind` VARCHAR(12) NOT NULL,
  `owner` VARCHAR(64) NULL,
  `owner_name` VARCHAR(100) NULL,
  `owner_phone` VARCHAR(32) NULL,
  `anonymous` TINYINT NOT NULL DEFAULT 0,
  `status` VARCHAR(24) NOT NULL,
  `title` VARCHAR(160) NOT NULL,
  `subject` VARCHAR(100) NULL,
  `data` LONGTEXT NULL,
  `assignee` VARCHAR(64) NULL,
  `assignee_name` VARCHAR(100) NULL,
  `x` FLOAT NULL,
  `y` FLOAT NULL,
  `z` FLOAT NULL,
  `at` BIGINT NULL,
  `pinned` TINYINT NOT NULL DEFAULT 0,
  `created` BIGINT NOT NULL,
  `updated` BIGINT NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ams` (`app`,`module`,`status`),
  KEY `owner` (`owner`),
  KEY `amat` (`app`,`module`,`at`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_capp_notes (server/capps.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_capp_notes` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `item` BIGINT NOT NULL,
  `author` VARCHAR(64) NOT NULL,
  `author_name` VARCHAR(100) NULL,
  `staff` TINYINT NOT NULL DEFAULT 0,
  `private` TINYINT NOT NULL DEFAULT 0,
  `text` VARCHAR(1500) NOT NULL,
  `created` BIGINT NOT NULL,
  PRIMARY KEY (`id`),
  KEY `item` (`item`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_close_friends (server/main.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_close_friends` (
  `app` VARCHAR(20) NOT NULL,
  `owner` VARCHAR(32) NOT NULL,
  `friend` VARCHAR(32) NOT NULL,
  PRIMARY KEY (`app`,`owner`,`friend`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_comment_likes (server/main.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_comment_likes` (
  `comment_id` INT NOT NULL,
  `username` VARCHAR(32) NOT NULL,
  PRIMARY KEY (`comment_id`,`username`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_comments (server/main.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_comments` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `post_id` INT NOT NULL,
  `username` VARCHAR(32) NOT NULL,
  `content` VARCHAR(300) NOT NULL,
  `created` BIGINT NOT NULL,
  `parent` INT NULL,
  KEY `post` (`post_id`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_contacts (server/main.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_contacts` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `owner` VARCHAR(64) NOT NULL,
  `name` VARCHAR(64) NOT NULL,
  `number` VARCHAR(20) NOT NULL,
  `avatar` VARCHAR(255) NULL,
  `favorite` TINYINT NOT NULL DEFAULT 0,
  `notes` VARCHAR(500) NULL,
  `avatar_photo` INT NULL,
  KEY `owner` (`owner`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_conversation_members (server/main.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_conversation_members` (
  `conversation_id` INT NOT NULL,
  `member` VARCHAR(40) NOT NULL,
  `role` VARCHAR(8) NOT NULL DEFAULT 'member',
  `joined` BIGINT NOT NULL,
  `last_read_id` INT NULL,
  `left_at` BIGINT NULL,
  PRIMARY KEY (`conversation_id`,`member`),
  KEY `member` (`member`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_conversations (server/main.lua + server/recado_people.lua, server/recado_social.lua, server/recado.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_conversations` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `app` VARCHAR(20) NOT NULL DEFAULT 'sms',
  `title` VARCHAR(40) NOT NULL,
  `avatar` INT NULL,
  `created_by` VARCHAR(40) NOT NULL,
  `created` BIGINT NOT NULL,
  `last_id` INT NULL,
  `description` VARCHAR(300) NULL,
  `invite_code` VARCHAR(12) NULL,
  `send_policy` VARCHAR(8) NOT NULL DEFAULT 'all',
  `edit_policy` VARCHAR(8) NOT NULL DEFAULT 'admins',
  `theme` VARCHAR(20) NULL,
  `kind` VARCHAR(12) NOT NULL DEFAULT 'group',
  `community_id` INT NULL,
  `disappearing` INT NULL
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_crypto (server/main.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_crypto` (
  `citizenid` VARCHAR(64) NOT NULL PRIMARY KEY,
  `bal` DECIMAL(20,8) NOT NULL DEFAULT 0
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_crypto_hist (server/main.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_crypto_hist` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `owner` VARCHAR(64) NOT NULL,
  `label` VARCHAR(80) NOT NULL,
  `amount` DECIMAL(20,8) NOT NULL,
  `created` BIGINT NOT NULL,
  KEY `o` (`owner`,`created`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_crypto_state (server/onion.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_crypto_state` (
  `k` VARCHAR(16) NOT NULL PRIMARY KEY,
  `price` DECIMAL(20,8) NOT NULL DEFAULT 0,
  `series` TEXT NULL,
  `updated` BIGINT NOT NULL DEFAULT 0
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_darkchat (server/main.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_darkchat` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `room` VARCHAR(40) NOT NULL,
  `username` VARCHAR(32) NOT NULL,
  `content` TEXT NULL,
  `image` LONGTEXT NULL,
  `ttl` INT NOT NULL DEFAULT 0,
  `created` BIGINT NOT NULL,
  KEY `room` (`room`,`created`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_darkchat_members (server/main.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_darkchat_members` (
  `citizenid` VARCHAR(64) NOT NULL,
  `room` VARCHAR(40) NOT NULL,
  `username` VARCHAR(32) NOT NULL,
  PRIMARY KEY (`citizenid`,`room`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_eats_addresses (server/eats.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_eats_addresses` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `owner` VARCHAR(64) NOT NULL,
  `label` VARCHAR(64) NOT NULL,
  `note` VARCHAR(120) NULL,
  `x` FLOAT NOT NULL,
  `y` FLOAT NOT NULL,
  `created` BIGINT NOT NULL,
  KEY `owner` (`owner`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_eats_meta (server/eats.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_eats_meta` (
  `owner` VARCHAR(64) NOT NULL PRIMARY KEY,
  `favorites` TEXT NULL,
  `promos` TEXT NULL,
  `pro_until` BIGINT NULL,
  `deliveries` INT NOT NULL DEFAULT 0,
  `earnings` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `rating_sum` INT NOT NULL DEFAULT 0,
  `rating_n` INT NOT NULL DEFAULT 0
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_eats_orders (server/eats.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_eats_orders` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `owner` VARCHAR(64) NOT NULL,
  `phone` VARCHAR(20) NULL,
  `name` VARCHAR(64) NULL,
  `restaurant` VARCHAR(40) NOT NULL,
  `items` LONGTEXT NULL,
  `note` VARCHAR(200) NULL,
  `subtotal` DECIMAL(10,2) NOT NULL DEFAULT 0,
  `fee` DECIMAL(10,2) NOT NULL DEFAULT 0,
  `service` DECIMAL(10,2) NOT NULL DEFAULT 0,
  `smallfee` DECIMAL(10,2) NOT NULL DEFAULT 0,
  `discount` DECIMAL(10,2) NOT NULL DEFAULT 0,
  `tip` DECIMAL(10,2) NOT NULL DEFAULT 0,
  `total` DECIMAL(10,2) NOT NULL DEFAULT 0,
  `pay` VARCHAR(10) NOT NULL DEFAULT 'card',
  `promo` VARCHAR(24) NULL,
  `addr_label` VARCHAR(64) NULL,
  `addr_x` FLOAT NULL,
  `addr_y` FLOAT NULL,
  `status` VARCHAR(16) NOT NULL DEFAULT 'pending',
  `courier` VARCHAR(64) NULL,
  `courier_name` VARCHAR(64) NULL,
  `courier_phone` VARCHAR(20) NULL,
  `courier_npc` TINYINT NOT NULL DEFAULT 0,
  `created` BIGINT NOT NULL,
  `ready_at` BIGINT NULL,
  `delivered` BIGINT NULL,
  `rating` TINYINT NULL,
  `rating_note` VARCHAR(200) NULL,
  KEY `owner` (`owner`),
  KEY `st` (`status`),
  KEY `cour` (`courier`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_eats_pending (server/eats.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_eats_pending` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `owner` VARCHAR(64) NOT NULL,
  `order_id` INT NOT NULL DEFAULT 0,
  `item` VARCHAR(64) NOT NULL,
  `count` INT NOT NULL DEFAULT 1,
  `dish` VARCHAR(64) NULL,
  `refund` DECIMAL(10,2) NOT NULL DEFAULT 0,
  `pay` VARCHAR(10) NOT NULL DEFAULT 'card',
  `status` VARCHAR(12) NOT NULL DEFAULT 'pending',
  `tries` INT NOT NULL DEFAULT 0,
  `created` BIGINT NOT NULL,
  `updated` BIGINT NOT NULL,
  KEY `own` (`owner`, `status`),
  KEY `st` (`status`, `updated`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_findmy (server/findmy.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_findmy` (
  `owner` VARCHAR(64) NOT NULL,
  `target` VARCHAR(64) NOT NULL,
  `kind` VARCHAR(8) NOT NULL DEFAULT 'share',
  `created` BIGINT NOT NULL,
  PRIMARY KEY (`owner`,`target`,`kind`),
  KEY `target` (`target`,`kind`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_follows (server/main.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_follows` (
  `app` VARCHAR(20) NOT NULL,
  `follower` VARCHAR(32) NOT NULL,
  `followed` VARCHAR(32) NOT NULL,
  PRIMARY KEY (`app`,`follower`,`followed`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_garage_meta (server/garage.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_garage_meta` (
  `plate` VARCHAR(16) NOT NULL,
  `owner` VARCHAR(64) NOT NULL,
  `nickname` VARCHAR(40) NULL,
  `favorite` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`plate`, `owner`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_instant_views (server/main.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_instant_views` (
  `instant_id` INT NOT NULL,
  `username` VARCHAR(32) NOT NULL,
  `reaction` VARCHAR(16) NULL,
  `created` BIGINT NOT NULL,
  PRIMARY KEY (`instant_id`,`username`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_instants (server/main.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_instants` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `app` VARCHAR(20) NOT NULL,
  `author` VARCHAR(32) NOT NULL,
  `image` LONGTEXT NULL,
  `text` VARCHAR(160) NULL,
  `ty` FLOAT NOT NULL DEFAULT 0.8,
  `tsize` INT NOT NULL DEFAULT 30,
  `audience` VARCHAR(8) NOT NULL DEFAULT 'close',
  `ready` TINYINT NOT NULL DEFAULT 0,
  `created` BIGINT NOT NULL,
  `expires` BIGINT NOT NULL,
  KEY `live` (`app`,`expires`),
  KEY `author` (`author`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_item_escrow (server/marketplace.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_item_escrow` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `source` VARCHAR(10) NOT NULL,
  `ref_id` INT NOT NULL DEFAULT 0,
  `owner` VARCHAR(64) NOT NULL,
  `item` VARCHAR(64) NOT NULL,
  `count` INT NOT NULL DEFAULT 1,
  `meta` TEXT NULL,
  `status` VARCHAR(16) NOT NULL DEFAULT 'held',
  `target` VARCHAR(64) NULL,
  `created` BIGINT NOT NULL,
  `updated` BIGINT NOT NULL,
  KEY `owner` (`owner`),
  KEY `target_status` (`target`, `status`),
  KEY `ref` (`source`, `ref_id`),
  KEY `status` (`status`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_likes (server/main.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_likes` (
  `post_id` INT NOT NULL,
  `username` VARCHAR(32) NOT NULL,
  PRIMARY KEY (`post_id`,`username`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_lines (server/sim.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_lines` (
  `number` VARCHAR(20) NOT NULL,
  `cid` VARCHAR(64) NOT NULL,
  `slot` TINYINT NOT NULL DEFAULT 1,
  `label` VARCHAR(24) NULL,
  `iccid` VARCHAR(24) NULL,
  `source` VARCHAR(12) NOT NULL DEFAULT 'esim',
  `color` VARCHAR(7) NULL,
  `created` BIGINT NOT NULL,
  PRIMARY KEY (`number`),
  KEY `cid` (`cid`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_mail (server/main.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_mail` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `owner` VARCHAR(64) NOT NULL,
  `sender` VARCHAR(64) NOT NULL,
  `email` VARCHAR(96) NULL,
  `subject` VARCHAR(160) NOT NULL,
  `body` TEXT NULL,
  `read` TINYINT NOT NULL DEFAULT 0,
  `folder` VARCHAR(10) NOT NULL DEFAULT 'inbox',
  `created` BIGINT NOT NULL,
  `recipient` VARCHAR(64) NULL,
  `attachments` TEXT NULL,
  `flagged` TINYINT NOT NULL DEFAULT 0,
  KEY `owner` (`owner`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_market (server/marketplace.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_market` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `owner` VARCHAR(64) NOT NULL,
  `seller_name` VARCHAR(64) NULL,
  `seller_phone` VARCHAR(20) NULL,
  `title` VARCHAR(80) NOT NULL,
  `description` TEXT NULL,
  `price` INT NOT NULL,
  `category` VARCHAR(30) NOT NULL DEFAULT 'Outros',
  `image` LONGTEXT NULL,
  `sold` TINYINT NOT NULL DEFAULT 0,
  `buyer` VARCHAR(64) NULL,
  `created` BIGINT NOT NULL,
  `kind` VARCHAR(10) NOT NULL DEFAULT 'other',
  `item_name` VARCHAR(64) NULL,
  KEY `owner` (`owner`),
  KEY `cat` (`category`, `sold`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_match_profiles (server/match.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_match_profiles` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `owner` VARCHAR(64) NOT NULL,
  `phone` VARCHAR(20) NOT NULL,
  `name` VARCHAR(24) NOT NULL,
  `age` INT NOT NULL DEFAULT 18,
  `gender` VARCHAR(12) NOT NULL DEFAULT 'Outro',
  `seeking` VARCHAR(12) NOT NULL DEFAULT 'Todos',
  `bio` VARCHAR(160) NULL,
  `location` VARCHAR(30) NULL,
  `photos` LONGTEXT NULL,
  `extras` LONGTEXT NULL,
  `paused` TINYINT NOT NULL DEFAULT 0,
  `created` BIGINT NOT NULL,
  UNIQUE KEY `owner` (`owner`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_match_swipes (server/match.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_match_swipes` (
  `owner` VARCHAR(64) NOT NULL,
  `target` INT NOT NULL,
  `liked` TINYINT NOT NULL DEFAULT 0,
  `created` BIGINT NOT NULL,
  PRIMARY KEY (`owner`, `target`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_matches (server/match.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_matches` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `a` VARCHAR(64) NOT NULL,
  `b` VARCHAR(64) NOT NULL,
  `created` BIGINT NOT NULL,
  KEY `a` (`a`),
  KEY `b` (`b`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_media (server/main.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_media` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `owner` VARCHAR(64) NOT NULL,
  `kind` VARCHAR(8) NOT NULL,
  `mime` VARCHAR(40) NOT NULL,
  `data` LONGTEXT NULL,
  `size` INT NOT NULL DEFAULT 0,
  `duration` INT NULL,
  `meta` TEXT NULL,
  `complete` TINYINT NOT NULL DEFAULT 0,
  `created` BIGINT NOT NULL,
  KEY `owner` (`owner`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_social_videos (server/social.lua): videos published on Instashot posts, stories, Reels and Twix
CREATE TABLE IF NOT EXISTS `apex_phone_social_videos` (`id` INT AUTO_INCREMENT PRIMARY KEY, `kind` VARCHAR(8) NOT NULL, `ref_id` INT NOT NULL, `media_id` INT NOT NULL, `photo_id` INT NULL, `app` VARCHAR(20) NOT NULL, `owner` VARCHAR(64) NOT NULL, `duration` INT NOT NULL DEFAULT 0, `size` INT NOT NULL DEFAULT 0, `created` BIGINT NOT NULL, UNIQUE KEY `kind_ref` (`kind`, `ref_id`), KEY `media` (`media_id`), KEY `owner` (`owner`)) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_message_reactions (server/main.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_message_reactions` (
  `message_id` INT NOT NULL,
  `who` VARCHAR(40) NOT NULL,
  `emoji` VARCHAR(16) NOT NULL,
  `created` BIGINT NOT NULL,
  PRIMARY KEY (`message_id`,`who`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_messages (server/main.lua + server/recado.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_messages` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `app` VARCHAR(20) NOT NULL DEFAULT 'sms',
  `sender` VARCHAR(40) NOT NULL,
  `receiver` VARCHAR(40) NOT NULL,
  `type` VARCHAR(16) NOT NULL DEFAULT 'text',
  `content` TEXT NULL,
  `payload` LONGTEXT NULL,
  `read` TINYINT NOT NULL DEFAULT 0,
  `created` BIGINT NOT NULL,
  `delivered_at` BIGINT NULL,
  `read_at` BIGINT NULL,
  `edited_at` BIGINT NULL,
  `reply_to` INT NULL,
  `deleted_sender` TINYINT NOT NULL DEFAULT 0,
  `deleted_receiver` TINYINT NOT NULL DEFAULT 0,
  `deleted_all` BIGINT NULL,
  `conversation_id` INT NULL,
  `expires_at` BIGINT NULL,
  `view_once` TINYINT NOT NULL DEFAULT 0,
  `viewed_at` BIGINT NULL,
  `forwarded` TINYINT NOT NULL DEFAULT 0,
  KEY `pair` (`app`,`sender`,`receiver`),
  KEY `recv` (`app`,`receiver`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_music (server/main.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_music` (
  `citizenid` VARCHAR(64) NOT NULL PRIMARY KEY,
  `data` LONGTEXT NULL,
  `updated` BIGINT NULL
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_notifications (server/main.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_notifications` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `owner` VARCHAR(64) NOT NULL,
  `app` VARCHAR(32) NOT NULL,
  `title` VARCHAR(80) NOT NULL,
  `body` VARCHAR(255) NULL,
  `data` TEXT NULL,
  `icon` VARCHAR(255) NULL,
  `image` VARCHAR(255) NULL,
  `read` TINYINT NOT NULL DEFAULT 0,
  `delivered` TINYINT NOT NULL DEFAULT 0,
  `created` BIGINT NOT NULL,
  `actions` TEXT NULL,
  `type` VARCHAR(12) NULL,
  `duration` INT NULL,
  KEY `owner_created` (`owner`,`created`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_onion (server/main.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_onion` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `owner` VARCHAR(64) NOT NULL,
  `seller_handle` VARCHAR(32) NOT NULL,
  `title` VARCHAR(80) NOT NULL,
  `description` TEXT NULL,
  `price` DECIMAL(16,6) NOT NULL DEFAULT 0,
  `stock` INT NOT NULL DEFAULT 1,
  `category` VARCHAR(30) NOT NULL,
  `image` LONGTEXT NULL,
  `created` BIGINT NOT NULL,
  `kind` VARCHAR(10) NOT NULL DEFAULT 'other',
  `item_name` VARCHAR(64) NULL,
  KEY `cat` (`category`,`created`),
  KEY `owner` (`owner`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_onion_id (server/main.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_onion_id` (
  `citizenid` VARCHAR(64) NOT NULL PRIMARY KEY,
  `handle` VARCHAR(32) NOT NULL,
  `rep` DECIMAL(10,2) NOT NULL DEFAULT 0,
  `votes` INT NOT NULL DEFAULT 0,
  `sales` INT NOT NULL DEFAULT 0,
  `since` BIGINT NOT NULL
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_onion_orders (server/main.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_onion_orders` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `listing` INT NULL,
  `buyer` VARCHAR(64) NOT NULL,
  `buyer_handle` VARCHAR(32) NOT NULL,
  `seller` VARCHAR(64) NOT NULL,
  `seller_handle` VARCHAR(32) NOT NULL,
  `title` VARCHAR(80) NOT NULL,
  `price` DECIMAL(16,6) NOT NULL DEFAULT 0,
  `status` VARCHAR(12) NOT NULL DEFAULT 'pago',
  `rating` INT NULL,
  `created` BIGINT NOT NULL,
  KEY `b` (`buyer`,`created`),
  KEY `s` (`seller`,`created`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_photos (server/main.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_photos` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `owner` VARCHAR(64) NOT NULL,
  `url` LONGTEXT NULL,
  `seed` INT NULL,
  `favorite` TINYINT NOT NULL DEFAULT 0,
  `video` TINYINT NOT NULL DEFAULT 0,
  `duration` INT NULL,
  `poster` MEDIUMTEXT NULL,
  `created` BIGINT NOT NULL,
  KEY `owner` (`owner`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_posts (server/main.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_posts` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `app` VARCHAR(20) NOT NULL,
  `author` VARCHAR(32) NOT NULL,
  `content` TEXT NULL,
  `image` LONGTEXT NULL,
  `reply_to` INT NULL,
  `repost_of` INT NULL,
  `created` BIGINT NOT NULL,
  KEY `app` (`app`,`created`),
  KEY `author` (`author`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_recado_call_history (server/recado_calls.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_recado_call_history` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `owner` VARCHAR(64) NOT NULL,
  `call_id` INT NULL,
  `kind` VARCHAR(10) NOT NULL DEFAULT 'group',
  `conversation` INT NULL,
  `title` VARCHAR(60) NULL,
  `video` TINYINT NOT NULL DEFAULT 0,
  `direction` VARCHAR(4) NOT NULL DEFAULT 'in',
  `status` VARCHAR(12) NOT NULL DEFAULT 'answered',
  `participants` VARCHAR(400) NULL,
  `duration` INT NOT NULL DEFAULT 0,
  `created` BIGINT NOT NULL,
  KEY `owner_created` (`owner`, `created`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_recado_call_links (server/recado_calls.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_recado_call_links` (
  `code` VARCHAR(12) NOT NULL PRIMARY KEY,
  `owner` VARCHAR(64) NOT NULL,
  `owner_number` VARCHAR(20) NOT NULL,
  `title` VARCHAR(60) NOT NULL,
  `video` TINYINT NOT NULL DEFAULT 0,
  `revoked` TINYINT NOT NULL DEFAULT 0,
  `created` BIGINT NOT NULL,
  `expires` BIGINT NOT NULL,
  KEY `owner` (`owner`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_recado_call_scheduled (server/recado_calls.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_recado_call_scheduled` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `code` VARCHAR(12) NOT NULL,
  `owner` VARCHAR(64) NOT NULL,
  `owner_number` VARCHAR(20) NOT NULL,
  `conversation` INT NULL,
  `number` VARCHAR(20) NULL,
  `title` VARCHAR(60) NOT NULL,
  `video` TINYINT NOT NULL DEFAULT 0,
  `start` BIGINT NOT NULL,
  `reminded` TINYINT NOT NULL DEFAULT 0,
  `cancelled` TINYINT NOT NULL DEFAULT 0,
  `message_id` INT NULL,
  `created` BIGINT NOT NULL,
  UNIQUE KEY `code` (`code`),
  KEY `start` (`start`),
  KEY `owner` (`owner`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_recado_channel_admins (server/recado_social.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_recado_channel_admins` (
  `channel_id` INT NOT NULL,
  `number` VARCHAR(20) NOT NULL,
  `role` VARCHAR(8) NOT NULL DEFAULT 'admin',
  `added` BIGINT NOT NULL,
  PRIMARY KEY (`channel_id`, `number`),
  KEY `number` (`number`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_recado_channel_followers (server/recado_social.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_recado_channel_followers` (
  `channel_id` INT NOT NULL,
  `number` VARCHAR(20) NOT NULL,
  `muted` TINYINT NOT NULL DEFAULT 1,
  `last_read` INT NULL,
  `created` BIGINT NOT NULL,
  PRIMARY KEY (`channel_id`, `number`),
  KEY `number` (`number`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_recado_channel_posts (server/recado_social.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_recado_channel_posts` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `channel_id` INT NOT NULL,
  `author` VARCHAR(20) NOT NULL,
  `type` VARCHAR(10) NOT NULL DEFAULT 'text',
  `content` TEXT NULL,
  `payload` TEXT NULL,
  `media_id` INT NULL,
  `created` BIGINT NOT NULL,
  `edited` BIGINT NULL,
  KEY `ch` (`channel_id`, `id`),
  KEY `media` (`media_id`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_recado_channel_reactions (server/recado_social.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_recado_channel_reactions` (
  `post_id` INT NOT NULL,
  `number` VARCHAR(20) NOT NULL,
  `emoji` VARCHAR(16) NOT NULL,
  `created` BIGINT NOT NULL,
  PRIMARY KEY (`post_id`, `number`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_recado_channel_votes (server/recado_social.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_recado_channel_votes` (
  `post_id` INT NOT NULL,
  `number` VARCHAR(20) NOT NULL,
  `options` VARCHAR(64) NOT NULL,
  `created` BIGINT NOT NULL,
  PRIMARY KEY (`post_id`, `number`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_recado_channels (server/recado_social.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_recado_channels` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(40) NOT NULL,
  `description` VARCHAR(300) NULL,
  `avatar` INT NULL,
  `owner` VARCHAR(20) NOT NULL,
  `owner_cid` VARCHAR(64) NOT NULL,
  `code` VARCHAR(12) NULL,
  `listed` TINYINT NOT NULL DEFAULT 1,
  `verified` TINYINT NOT NULL DEFAULT 0,
  `followers` INT NOT NULL DEFAULT 0,
  `created` BIGINT NOT NULL,
  `updated` BIGINT NOT NULL,
  `last_post` BIGINT NULL,
  UNIQUE KEY `ux_code` (`code`),
  KEY `owner` (`owner`),
  KEY `listed` (`listed`, `followers`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_recado_communities (server/recado_social.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_recado_communities` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(40) NOT NULL,
  `description` VARCHAR(300) NULL,
  `avatar` INT NULL,
  `owner` VARCHAR(20) NOT NULL,
  `owner_cid` VARCHAR(64) NOT NULL,
  `announce_id` INT NULL,
  `created` BIGINT NOT NULL,
  `updated` BIGINT NOT NULL,
  KEY `owner` (`owner`),
  KEY `announce` (`announce_id`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_recado_events (server/recado_extras.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_recado_events` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `message_id` INT NULL,
  `conversation_id` INT NULL,
  `creator` VARCHAR(40) NOT NULL,
  `peer` VARCHAR(40) NULL,
  `title` VARCHAR(80) NOT NULL,
  `description` VARCHAR(500) NULL,
  `start` BIGINT NOT NULL,
  `loc_x` DOUBLE NULL,
  `loc_y` DOUBLE NULL,
  `loc_label` VARCHAR(60) NULL,
  `reminder` INT NOT NULL DEFAULT -1,
  `reminded` TINYINT NOT NULL DEFAULT 0,
  `cancelled` TINYINT NOT NULL DEFAULT 0,
  `created` BIGINT NOT NULL,
  KEY `rc_event_due` (`reminded`, `start`),
  KEY `rc_event_message` (`message_id`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_recado_pins (server/recado.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_recado_pins` (
  `thread` VARCHAR(90) NOT NULL,
  `message_id` INT NOT NULL,
  `pinned_by` VARCHAR(40) NOT NULL,
  `created` BIGINT NOT NULL,
  PRIMARY KEY (`thread`, `message_id`),
  KEY `message` (`message_id`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_recado_poll_votes (server/recado_extras.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_recado_poll_votes` (
  `poll_id` INT NOT NULL,
  `voter` VARCHAR(40) NOT NULL,
  `option_idx` TINYINT NOT NULL,
  `created` BIGINT NOT NULL,
  PRIMARY KEY (`poll_id`, `voter`, `option_idx`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_recado_polls (server/recado_extras.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_recado_polls` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `message_id` INT NULL,
  `conversation_id` INT NULL,
  `creator` VARCHAR(40) NOT NULL,
  `peer` VARCHAR(40) NULL,
  `question` VARCHAR(300) NOT NULL,
  `options` TEXT NOT NULL,
  `multi` TINYINT NOT NULL DEFAULT 0,
  `show_voters` TINYINT NOT NULL DEFAULT 0,
  `created` BIGINT NOT NULL,
  KEY `rc_poll_message` (`message_id`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_recado_profiles (server/recado_people.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_recado_profiles` (
  `number` VARCHAR(20) NOT NULL,
  `owner` VARCHAR(64) NULL,
  `name` VARCHAR(40) NOT NULL DEFAULT '',
  `about` VARCHAR(160) NOT NULL DEFAULT '',
  `avatar_media` INT NULL,
  `privacy` TEXT NULL,
  `read_receipts` TINYINT NOT NULL DEFAULT 1,
  `groups_add` VARCHAR(8) NOT NULL DEFAULT 'all',
  `silence_unknown` TINYINT NOT NULL DEFAULT 0,
  `updated` BIGINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`number`),
  KEY `owner` (`owner`),
  KEY `avatar_media` (`avatar_media`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_recado_rsvp (server/recado_extras.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_recado_rsvp` (
  `event_id` INT NOT NULL,
  `who` VARCHAR(40) NOT NULL,
  `answer` VARCHAR(5) NOT NULL,
  `updated` BIGINT NOT NULL,
  PRIMARY KEY (`event_id`, `who`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_recado_stars (server/recado.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_recado_stars` (
  `message_id` INT NOT NULL,
  `who` VARCHAR(40) NOT NULL,
  `created` BIGINT NOT NULL,
  PRIMARY KEY (`message_id`, `who`),
  KEY `who_created` (`who`, `created`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_recado_status (server/recado_social.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_recado_status` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `owner` VARCHAR(20) NOT NULL,
  `owner_cid` VARCHAR(64) NOT NULL,
  `kind` VARCHAR(8) NOT NULL DEFAULT 'text',
  `content` VARCHAR(1000) NULL,
  `media_id` INT NULL,
  `bg` VARCHAR(16) NULL,
  `font` VARCHAR(12) NULL,
  `duration` INT NULL,
  `privacy` VARCHAR(8) NOT NULL DEFAULT 'contacts',
  `audience` TEXT NULL,
  `mentions` TEXT NULL,
  `reshare_of` INT NULL,
  `created` BIGINT NOT NULL,
  `expires` BIGINT NOT NULL,
  KEY `owner` (`owner`, `expires`),
  KEY `expires` (`expires`),
  KEY `media` (`media_id`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_recado_status_prefs (server/recado_social.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_recado_status_prefs` (
  `number` VARCHAR(20) NOT NULL PRIMARY KEY,
  `privacy` VARCHAR(8) NOT NULL DEFAULT 'contacts',
  `audience` TEXT NULL,
  `muted` TEXT NULL,
  `updated` BIGINT NOT NULL
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_recado_status_views (server/recado_social.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_recado_status_views` (
  `status_id` INT NOT NULL,
  `viewer` VARCHAR(20) NOT NULL,
  `liked` TINYINT NOT NULL DEFAULT 0,
  `created` BIGINT NOT NULL,
  PRIMARY KEY (`status_id`, `viewer`),
  KEY `viewer` (`viewer`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_recado_views (server/recado.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_recado_views` (
  `message_id` INT NOT NULL,
  `who` VARCHAR(40) NOT NULL,
  `viewed_at` BIGINT NOT NULL,
  PRIMARY KEY (`message_id`, `who`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_saves (server/main.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_saves` (
  `app` VARCHAR(20) NOT NULL,
  `username` VARCHAR(32) NOT NULL,
  `post_id` INT NOT NULL,
  `created` BIGINT NOT NULL,
  PRIMARY KEY (`app`,`username`,`post_id`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_services (server/main.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_services` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `requester` VARCHAR(64) NOT NULL,
  `requester_name` VARCHAR(64) NULL,
  `requester_phone` VARCHAR(20) NULL,
  `service` VARCHAR(30) NOT NULL,
  `description` VARCHAR(300) NULL,
  `coords` VARCHAR(120) NULL,
  `status` VARCHAR(12) NOT NULL DEFAULT 'pending',
  `accepted_by` VARCHAR(64) NULL,
  `accepted_cid` VARCHAR(64) NULL,
  `created` BIGINT NOT NULL,
  KEY `svc` (`service`,`status`),
  KEY `req` (`requester`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_shop_sales (server/shop.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_shop_sales` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `at` BIGINT NOT NULL,
  `cid` VARCHAR(64) NULL,
  `name` VARCHAR(100) NULL,
  `item` VARCHAR(64) NOT NULL,
  `product` VARCHAR(32) NULL,
  `label` VARCHAR(120) NULL,
  `price` BIGINT NOT NULL,
  `account` VARCHAR(12) NULL,
  `shop` VARCHAR(32) NULL,
  PRIMARY KEY (`id`),
  KEY `at` (`at`),
  KEY `item` (`item`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_showcase_rows (server/showcase.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_showcase_rows` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `tbl` VARCHAR(64) NOT NULL,
  `where_sql` TEXT NOT NULL,
  `params` TEXT NULL,
  `created` BIGINT NOT NULL,
  PRIMARY KEY (`id`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_sims (server/psim.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_sims` (
  `iccid` VARCHAR(24) NOT NULL,
  `number` VARCHAR(20) NOT NULL,
  `device` VARCHAR(24) NULL,
  `account` VARCHAR(64) NULL,
  `label` VARCHAR(24) NULL,
  `home` VARCHAR(64) NULL,
  `origin` VARCHAR(12) NOT NULL DEFAULT 'shop',
  `pending` VARCHAR(64) NULL,
  `created` BIGINT NOT NULL,
  `updated` BIGINT NULL,
  PRIMARY KEY (`iccid`),
  UNIQUE KEY `ux_number` (`number`),
  KEY `device` (`device`),
  KEY `pending` (`pending`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_sims_blocked (server/psim.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_sims_blocked` (
  `iccid` VARCHAR(24) NOT NULL,
  `number` VARCHAR(20) NOT NULL,
  `replaced_by` VARCHAR(24) NULL,
  `cid` VARCHAR(64) NULL,
  `blocked` BIGINT NOT NULL,
  PRIMARY KEY (`iccid`),
  KEY `number` (`number`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_social_accounts (server/main.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_social_accounts` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `app` VARCHAR(20) NOT NULL,
  `owner` VARCHAR(64) NOT NULL,
  `username` VARCHAR(32) NOT NULL,
  `bio` VARCHAR(160) NULL,
  `avatar` VARCHAR(255) NULL,
  `created` BIGINT NOT NULL,
  `name` VARCHAR(40) NULL,
  `website` VARCHAR(90) NULL,
  `private` TINYINT NOT NULL DEFAULT 0,
  `avatar_url` LONGTEXT NULL,
  UNIQUE KEY `app_user` (`app`,`username`),
  KEY `owner` (`app`,`owner`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_stories (server/main.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_stories` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `app` VARCHAR(20) NOT NULL,
  `author` VARCHAR(32) NOT NULL,
  `image` LONGTEXT NULL,
  `text` VARCHAR(160) NULL,
  `tx` FLOAT NOT NULL DEFAULT 0.5,
  `ty` FLOAT NOT NULL DEFAULT 0.5,
  `tsize` INT NOT NULL DEFAULT 28,
  `tcolor` VARCHAR(10) NULL,
  `loc` VARCHAR(40) NULL,
  `created` BIGINT NOT NULL,
  `expires` BIGINT NOT NULL,
  `layers` LONGTEXT NULL,
  `bg` VARCHAR(20) NULL,
  `draw` LONGTEXT NULL,
  `duration` INT NOT NULL DEFAULT 5,
  `close_friends` TINYINT NOT NULL DEFAULT 0,
  KEY `live` (`app`,`expires`),
  KEY `author` (`author`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_story_answers (server/main.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_story_answers` (
  `story_id` INT NOT NULL,
  `layer` VARCHAR(16) NOT NULL,
  `username` VARCHAR(32) NOT NULL,
  `choice` TINYINT NULL,
  `answer` VARCHAR(200) NULL,
  `created` BIGINT NOT NULL,
  PRIMARY KEY (`story_id`,`layer`,`username`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_story_views (server/main.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_story_views` (
  `story_id` INT NOT NULL,
  `username` VARCHAR(32) NOT NULL,
  `liked` TINYINT NOT NULL DEFAULT 0,
  `created` BIGINT NOT NULL,
  PRIMARY KEY (`story_id`,`username`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_thread_meta (server/main.lua + server/recado.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_thread_meta` (
  `owner` VARCHAR(40) NOT NULL,
  `app` VARCHAR(20) NOT NULL,
  `other` VARCHAR(40) NOT NULL,
  `pinned` TINYINT NOT NULL DEFAULT 0,
  `muted_until` BIGINT NULL,
  `pinned_msg` INT NULL,
  `cleared_before` INT NULL,
  `archived` TINYINT NOT NULL DEFAULT 0,
  `marked_unread` TINYINT NOT NULL DEFAULT 0,
  `locked` TINYINT NOT NULL DEFAULT 0,
  `disappearing` INT NULL,
  PRIMARY KEY (`owner`,`app`,`other`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_transactions (server/main.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_transactions` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `owner` VARCHAR(64) NOT NULL,
  `description` VARCHAR(160) NOT NULL,
  `amount` INT NOT NULL,
  `created` BIGINT NOT NULL,
  KEY `owner` (`owner`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_userdata (server/userdata.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_userdata` (
  `owner` VARCHAR(64) NOT NULL,
  `k` VARCHAR(32) NOT NULL,
  `v` LONGTEXT NULL,
  `updated` BIGINT NOT NULL,
  PRIMARY KEY (`owner`,`k`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 1.5.0: Arcade (server/arcade.lua), Fitness and Journal (server/fitness.lua, server/journal.lua),
-- Stocks, Translate and Voice Memos (server/stocks.lua, server/translate.lua, server/voicememos.lua),
-- SDK storage (server/sdk.lua). Every server file also creates its tables on start; this block is for
-- a manual install.
-- ============================================================

-- apex_phone_arcade_scores (server/arcade.lua): the best score of each character per board
CREATE TABLE IF NOT EXISTS `apex_phone_arcade_scores` (
  `owner` VARCHAR(64) NOT NULL,
  `board` VARCHAR(48) NOT NULL,
  `score` BIGINT NOT NULL DEFAULT 0,
  `name` VARCHAR(64) NULL,
  `updated` BIGINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`owner`, `board`),
  KEY `ax_arc_board_score` (`board`, `score`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_arcade_stats (server/arcade.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_arcade_stats` (
  `owner` VARCHAR(64) NOT NULL,
  `k` VARCHAR(32) NOT NULL,
  `v` BIGINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`owner`, `k`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_fitness (server/fitness.lua): one row per character and day
CREATE TABLE IF NOT EXISTS `apex_phone_fitness` (
  `owner` VARCHAR(64) NOT NULL,
  `day` VARCHAR(10) NOT NULL,
  `walk` FLOAT NOT NULL DEFAULT 0,
  `run` FLOAT NOT NULL DEFAULT 0,
  `drive` FLOAT NOT NULL DEFAULT 0,
  `steps` INT NOT NULL DEFAULT 0,
  `active` INT NOT NULL DEFAULT 0,
  `kcal` FLOAT NOT NULL DEFAULT 0,
  PRIMARY KEY (`owner`, `day`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `apex_phone_fitness_goals` (
  `owner` VARCHAR(64) NOT NULL,
  `kcal` INT NOT NULL DEFAULT 400,
  `minutes` INT NOT NULL DEFAULT 30,
  `steps` INT NOT NULL DEFAULT 8000,
  `updated` BIGINT NOT NULL,
  PRIMARY KEY (`owner`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `apex_phone_fitness_awards` (
  `owner` VARCHAR(64) NOT NULL,
  `award` VARCHAR(32) NOT NULL,
  `unlocked` BIGINT NOT NULL,
  PRIMARY KEY (`owner`, `award`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_journal (server/journal.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_journal` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `owner` VARCHAR(64) NOT NULL,
  `created` BIGINT NOT NULL,
  `updated` BIGINT NOT NULL,
  `text` TEXT NULL,
  `mood` VARCHAR(16) NULL,
  `photo_id` INT NULL,
  `place` VARCHAR(80) NULL,
  `weather` VARCHAR(24) NULL,
  `fav` TINYINT NOT NULL DEFAULT 0,
  KEY `owner_created` (`owner`, `created`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_stocks_* (server/stocks.lua): the simulated market and the portfolios
CREATE TABLE IF NOT EXISTS `apex_phone_stocks_state` (
  `symbol` VARCHAR(8) NOT NULL PRIMARY KEY,
  `price` DECIMAL(14,4) NOT NULL DEFAULT 0,
  `trend` DECIMAL(12,8) NOT NULL DEFAULT 0,
  `open` DECIMAL(14,4) NOT NULL DEFAULT 0,
  `high` DECIMAL(14,4) NOT NULL DEFAULT 0,
  `low` DECIMAL(14,4) NOT NULL DEFAULT 0,
  `volume` BIGINT NOT NULL DEFAULT 0,
  `day` VARCHAR(10) NOT NULL DEFAULT '',
  `updated` BIGINT NOT NULL DEFAULT 0
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `apex_phone_stocks_prices` (
  `symbol` VARCHAR(8) NOT NULL,
  `day` VARCHAR(10) NOT NULL,
  `points` MEDIUMTEXT NULL,
  PRIMARY KEY (`symbol`,`day`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `apex_phone_stocks_daily` (
  `symbol` VARCHAR(8) NOT NULL,
  `day` VARCHAR(10) NOT NULL,
  `open` DECIMAL(14,4) NOT NULL,
  `high` DECIMAL(14,4) NOT NULL,
  `low` DECIMAL(14,4) NOT NULL,
  `close` DECIMAL(14,4) NOT NULL,
  `volume` BIGINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`symbol`,`day`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `apex_phone_stocks_portfolio` (
  `owner` VARCHAR(64) NOT NULL,
  `symbol` VARCHAR(8) NOT NULL,
  `qty` INT NOT NULL DEFAULT 0,
  `avg` DECIMAL(14,4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`owner`,`symbol`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `apex_phone_stocks_trades` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `owner` VARCHAR(64) NOT NULL,
  `symbol` VARCHAR(8) NOT NULL,
  `side` VARCHAR(4) NOT NULL,
  `qty` INT NOT NULL,
  `price` DECIMAL(14,4) NOT NULL,
  `fee` INT NOT NULL DEFAULT 0,
  `total` INT NOT NULL DEFAULT 0,
  `created` BIGINT NOT NULL,
  KEY `o` (`owner`,`created`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `apex_phone_stocks_watch` (
  `owner` VARCHAR(64) NOT NULL PRIMARY KEY,
  `symbols` VARCHAR(255) NOT NULL DEFAULT ''
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `apex_phone_stocks_alerts` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `owner` VARCHAR(64) NOT NULL,
  `symbol` VARCHAR(8) NOT NULL,
  `price` DECIMAL(14,4) NOT NULL,
  `above` TINYINT NOT NULL DEFAULT 1,
  `created` BIGINT NOT NULL,
  KEY `o` (`owner`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `apex_phone_stocks_news` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `symbol` VARCHAR(8) NOT NULL,
  `title` VARCHAR(160) NOT NULL,
  `effect` DECIMAL(8,5) NOT NULL DEFAULT 0,
  `created` BIGINT NOT NULL,
  KEY `c` (`created`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_translate_cache (server/translate.lua)
CREATE TABLE IF NOT EXISTS `apex_phone_translate_cache` (
  `k` VARCHAR(80) NOT NULL PRIMARY KEY,
  `src` VARCHAR(8) NOT NULL,
  `dst` VARCHAR(8) NOT NULL,
  `text` TEXT NOT NULL,
  `result` TEXT NOT NULL,
  `detected` VARCHAR(8) NULL,
  `created` BIGINT NOT NULL,
  KEY `c` (`created`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_voicememos (server/voicememos.lua): recordings, stored in chunks
CREATE TABLE IF NOT EXISTS `apex_phone_voicememos` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `owner` VARCHAR(64) NOT NULL,
  `name` VARCHAR(120) NOT NULL,
  `created` BIGINT NOT NULL,
  `duration` INT NOT NULL DEFAULT 0,
  `bytes` INT NOT NULL DEFAULT 0,
  `media_id` INT NULL,
  `mime` VARCHAR(40) NOT NULL DEFAULT 'audio/webm',
  `waveform` TEXT NULL,
  `favorite` TINYINT NOT NULL DEFAULT 0,
  `complete` TINYINT NOT NULL DEFAULT 0,
  `data` LONGTEXT NULL,
  KEY `o` (`owner`,`created`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- apex_phone_app_kv (server/sdk.lua): storage per external app and character (ApexPhone.storage)
CREATE TABLE IF NOT EXISTS `apex_phone_app_kv` (
  `owner` VARCHAR(64) NOT NULL,
  `app` VARCHAR(64) NOT NULL,
  `k` VARCHAR(64) NOT NULL,
  `v` TEXT NULL,
  `updated` BIGINT NOT NULL,
  PRIMARY KEY (`owner`,`app`,`k`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
