-- Apex Billing — schema (auto-applied on first start by database.lua)
-- Provided here as a manual fallback for offline databases.

CREATE TABLE IF NOT EXISTS apex_billing_invoices (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    number          VARCHAR(32) NOT NULL UNIQUE,
    issuer_type     ENUM('player','society') NOT NULL DEFAULT 'player',
    issuer_id       VARCHAR(60) NOT NULL,
    issuer_name     VARCHAR(80) NOT NULL,
    issuer_job      VARCHAR(50) DEFAULT NULL,
    issued_by_id    VARCHAR(80) DEFAULT NULL,
    issued_by_name  VARCHAR(80) DEFAULT NULL,
    recipient_id    VARCHAR(60) NOT NULL,
    recipient_type  ENUM('player','society') NOT NULL DEFAULT 'player',
    recipient_name  VARCHAR(80) NOT NULL,
    title           VARCHAR(120) NOT NULL,
    notes           TEXT NULL,
    items           LONGTEXT NOT NULL,
    subtotal        BIGINT NOT NULL DEFAULT 0,
    tax             BIGINT NOT NULL DEFAULT 0,
    total           BIGINT NOT NULL DEFAULT 0,
    vat_rate        FLOAT NOT NULL DEFAULT 0,
    status          ENUM('draft','sent','paid','declined','expired','cancelled') NOT NULL DEFAULT 'sent',
    payment_method  VARCHAR(16) DEFAULT NULL,
    due_at          BIGINT NOT NULL DEFAULT 0,
    paid_at         BIGINT DEFAULT NULL,
    paid_by         VARCHAR(80) DEFAULT NULL,
    created_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_issuer (issuer_type, issuer_id, status, created_at),
    INDEX idx_recipient (recipient_id, status, created_at),
    INDEX idx_society (issuer_job, status, created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS apex_billing_templates (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    owner_type      ENUM('player','society') NOT NULL,
    owner_id        VARCHAR(60) NOT NULL,
    label           VARCHAR(80) NOT NULL,
    title           VARCHAR(120) DEFAULT NULL,
    items           LONGTEXT NOT NULL,
    vat_rate        FLOAT NOT NULL DEFAULT 0,
    notes           TEXT NULL,
    created_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_owner (owner_type, owner_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Money from personal invoices paid while the issuer was offline.
CREATE TABLE IF NOT EXISTS apex_billing_payouts (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    identifier      VARCHAR(60) NOT NULL,
    amount          BIGINT NOT NULL DEFAULT 0,
    reason          VARCHAR(120) DEFAULT NULL,
    created_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_identifier (identifier)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
