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

-- password123 is the default password
