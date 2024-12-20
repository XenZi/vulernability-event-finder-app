DROP DATABASE vulnerability_finder;

CREATE DATABASE vulnerability_finder;

use vulnerability_finder;


CREATE TABLE User (
    id INT AUTO_INCREMENT PRIMARY KEY,     
    email VARCHAR(255) NOT NULL UNIQUE,     
    password VARCHAR(255) NOT NULL,         
    is_active BOOLEAN NOT NULL DEFAULT FALSE, 
    creation_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP 
);

INSERT INTO User (email, password, is_active)
VALUES 
('john.doe@example.com', '$2b$10$xj/KQMbskScxwk7DhWMqlO/Nkvpvo6pxTQCfOc34sQJkl3/QND9Ia', TRUE),
('jane.smith@example.com', '$2b$10$xj/KQMbskScxwk7DhWMqlO/Nkvpvo6pxTQCfOc34sQJkl3/QND9Ia', TRUE),
('alice.wonderland@example.com', '$2b$10$xj/KQMbskScxwk7DhWMqlO/Nkvpvo6pxTQCfOc34sQJkl3/QND9Ia', FALSE),
('bob.builder@example.com', '$2b$10$xj/KQMbskScxwk7DhWMqlO/Nkvpvo6pxTQCfOc34sQJkl3/QND9Ia', TRUE),
('charlie.brown@example.com', '$2a$10$T/iAXKsAtMJB2rpzvU20hOh74UHlm7PqlLT2yrUtoWelH244J2KfG', TRUE);

CREATE TABLE Asset (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ip VARCHAR(45) NOT NULL UNIQUE,
    notification_priority_level INT DEFAULT 1, 
    creation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_id INT,
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES User (id)
    -- CONSTRAINT unique_ip_user UNIQUE (ip, user_id)
);


INSERT INTO Asset (ip, notification_priority_level, creation_date, user_id) VALUES 
('192.168.1.1', 1, '2024-12-15 10:00:00', 1),
('192.168.1.2', 2, '2024-12-15 11:00:00', 1), 
('172.16.0.1', 3, '2024-12-15 12:00:00', 1),
('192.168.1.3', 1, '2024-12-15 13:00:00', 2);

-- password123 is the default password
