-- apex_strategy, esquema
-- Não é obrigatório correr isto à mão: o server/database.lua cria as
-- tabelas no arranque. Fica aqui para quem prefere controlar o SQL.

CREATE TABLE IF NOT EXISTS `apex_strategy_boards` (
    `id`         INT AUTO_INCREMENT PRIMARY KEY,
    `model`      VARCHAR(64)  NOT NULL,
    `name`       VARCHAR(64)  NOT NULL DEFAULT 'Quadro',
    `job`        VARCHAR(32)  NOT NULL DEFAULT '',
    `x`          DOUBLE       NOT NULL,
    `y`          DOUBLE       NOT NULL,
    `z`          DOUBLE       NOT NULL,
    `heading`    DOUBLE       NOT NULL DEFAULT 0,
    `created_by` VARCHAR(64)  NOT NULL DEFAULT '',
    `created_at` TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `apex_strategy_content` (
    `board_id`   INT PRIMARY KEY,
    `doc`        LONGTEXT     NOT NULL,
    `updated_by` VARCHAR(64)  NOT NULL DEFAULT '',
    `updated_at` TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
                 ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
