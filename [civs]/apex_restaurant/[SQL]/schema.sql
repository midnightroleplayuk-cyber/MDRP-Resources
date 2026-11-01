-- █████╗ ██████╗ ███████╗██╗  ██╗
-- ██╔══██╗██╔══██╗██╔════╝╚██╗██╔╝
-- ███████║██████╔╝█████╗   ╚███╔╝
-- ██╔══██║██╔═══╝ ██╔══╝   ██╔██╗
-- ██║  ██║██║     ███████╗██╔╝ ██╗
-- ╚═╝  ╚═╝╚═╝     ╚══════╝╚═╝  ╚═╝
--
-- Apex Restaurant — Database Schema
--
-- These tables are created AUTOMATICALLY on first boot (see
-- build/server/database.lua). You only need to run this file manually if
-- you prefer to provision the schema yourself. It is safe to run more than
-- once (every statement uses CREATE TABLE IF NOT EXISTS).
--
-- NOTE: framework job tables (ESX jobs/job_grades/addon_account, or the
--       QBCore/Qbox shared/jobs.lua) are NOT part of this file — they come
--       from your framework. The creator's "Create Job" button provisions
--       them for you per framework.

-- Society funds per job.
CREATE TABLE IF NOT EXISTS apex_restaurant_funds (
    job    VARCHAR(50)  NOT NULL PRIMARY KEY,
    amount INT          NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Shared stash contents (fridge / storage / tray).
CREATE TABLE IF NOT EXISTS apex_restaurant_stashes (
    stash_id VARCHAR(100) NOT NULL,
    item     VARCHAR(64)  NOT NULL,
    count    INT          NOT NULL DEFAULT 0,
    PRIMARY KEY (stash_id, item)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Per-player accumulated work seconds (only counts while on-duty).
CREATE TABLE IF NOT EXISTS apex_restaurant_worktime (
    identifier         VARCHAR(60) NOT NULL,
    job                VARCHAR(50) NOT NULL,
    total_seconds      BIGINT      NOT NULL DEFAULT 0,
    last_session_start BIGINT      DEFAULT NULL,
    last_seen          BIGINT      DEFAULT NULL,
    PRIMARY KEY (identifier, job)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Revenue log (each row = one inflow into society funds).
CREATE TABLE IF NOT EXISTS apex_restaurant_revenue (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    job        VARCHAR(50) NOT NULL,
    amount     INT         NOT NULL,
    source     VARCHAR(32) NOT NULL,
    created_at TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_job_date (job, created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Expense log (NPC shop purchases, withdrawals, etc.).
CREATE TABLE IF NOT EXISTS apex_restaurant_expenses (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    job        VARCHAR(50) NOT NULL,
    amount     INT         NOT NULL,
    source     VARCHAR(32) NOT NULL,
    actor      VARCHAR(80) DEFAULT NULL,
    detail     TEXT        DEFAULT NULL,
    created_at TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_job_date (job, created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Per-player saved work uniforms (component + prop indices).
CREATE TABLE IF NOT EXISTS apex_restaurant_uniforms (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    identifier VARCHAR(60) NOT NULL,
    job        VARCHAR(50) NOT NULL,
    name       VARCHAR(40) NOT NULL,
    data       TEXT        NOT NULL,
    created_at TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_owner (identifier, job)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Customer-shop stock + price (per job + item).
CREATE TABLE IF NOT EXISTS apex_restaurant_shop_stock (
    job   VARCHAR(50) NOT NULL,
    item  VARCHAR(64) NOT NULL,
    qty   INT         NOT NULL DEFAULT 0,
    price INT         NOT NULL DEFAULT 0,
    PRIMARY KEY (job, item)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Generic activity log (sales, cooking, deliveries, HR, treasury, ...).
CREATE TABLE IF NOT EXISTS apex_restaurant_activity (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    job        VARCHAR(50) NOT NULL,
    kind       VARCHAR(32) NOT NULL,
    actor      VARCHAR(60) DEFAULT NULL,
    actor_name VARCHAR(80) DEFAULT NULL,
    detail     TEXT        DEFAULT NULL,
    amount     INT         DEFAULT NULL,
    created_at TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_job_date (job, created_at),
    INDEX idx_job_kind (job, kind)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Customer-facing menu items + style, per job (JSON blobs).
CREATE TABLE IF NOT EXISTS apex_restaurant_menus (
    job        VARCHAR(50) NOT NULL PRIMARY KEY,
    items      LONGTEXT    NOT NULL,
    style      TEXT        DEFAULT NULL,
    updated_at TIMESTAMP   DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Per-job recipe set (preparation + grill + fryer + drinks + coffee).
CREATE TABLE IF NOT EXISTS apex_restaurant_recipes (
    job        VARCHAR(50) NOT NULL PRIMARY KEY,
    data       LONGTEXT    NOT NULL,
    updated_at TIMESTAMP   DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Per-grade rank overrides (label / wage / pay interval).
CREATE TABLE IF NOT EXISTS apex_restaurant_ranks (
    job          VARCHAR(50) NOT NULL,
    grade        INT         NOT NULL,
    label        VARCHAR(80) DEFAULT NULL,
    wage         INT         DEFAULT 0,
    pay_interval INT         DEFAULT 60,
    PRIMARY KEY (job, grade)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Payroll scheduler state, one row per job.
CREATE TABLE IF NOT EXISTS apex_restaurant_payroll (
    job         VARCHAR(50) NOT NULL PRIMARY KEY,
    next_payday BIGINT      DEFAULT 0,
    last_payday BIGINT      DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
