-- Optional: the resource creates these tables automatically on start.
CREATE TABLE IF NOT EXISTS vw_interview_rooms (
    id INT AUTO_INCREMENT PRIMARY KEY,
    label VARCHAR(64) NOT NULL,
    data LONGTEXT NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS vw_interview_sessions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    room_id INT NOT NULL,
    room_label VARCHAR(64),
    case_ref VARCHAR(64),
    interviewee VARCHAR(96),
    interviewee_cid VARCHAR(64),
    notes TEXT,
    officer_name VARCHAR(96),
    officer_id VARCHAR(96),
    officers VARCHAR(600),
    solicitor VARCHAR(96),
    started_at BIGINT NOT NULL,
    duration_ms INT NOT NULL DEFAULT 0,
    status VARCHAR(16) NOT NULL DEFAULT 'recording',
    INDEX idx_room (room_id),
    INDEX idx_started (started_at)
);

CREATE TABLE IF NOT EXISTS vw_interview_media (
    id INT AUTO_INCREMENT PRIMARY KEY,
    session_id INT NOT NULL,
    kind VARCHAR(8) NOT NULL,
    url VARCHAR(512),
    speaker_name VARCHAR(96),
    speaker_id VARCHAR(96),
    offset_ms INT NOT NULL DEFAULT 0,
    duration_ms INT NOT NULL DEFAULT 0,
    status VARCHAR(16) NOT NULL DEFAULT 'ok',
    note VARCHAR(160),
    INDEX idx_session (session_id)
);

CREATE TABLE IF NOT EXISTS vw_interview_replay (
    id INT AUTO_INCREMENT PRIMARY KEY,
    session_id INT NOT NULL,
    data LONGTEXT NOT NULL,
    INDEX idx_session (session_id)
);
