DROP DATABASE vulnerability_finder; 

CREATE DATABASE vulnerability_finder;

use vulnerability_finder;


CREATE TABLE User (
    id INT AUTO_INCREMENT PRIMARY KEY,     
    email VARCHAR(255) NOT NULL UNIQUE,     
    password VARCHAR(255) NOT NULL,         
    is_active BOOLEAN NOT NULL DEFAULT FALSE, 
	fcm_token VARCHAR(255),
    creation_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO User (email, password, is_active, fcm_token)
VALUES 
('john.doe@example.com', '$2b$10$xj/KQMbskScxwk7DhWMqlO/Nkvpvo6pxTQCfOc34sQJkl3/QND9Ia', TRUE, ""),
('jane.smith@example.com', '$2b$10$xj/KQMbskScxwk7DhWMqlO/Nkvpvo6pxTQCfOc34sQJkl3/QND9Ia', TRUE, ""),
('alice.wonderland@example.com', '$2b$10$xj/KQMbskScxwk7DhWMqlO/Nkvpvo6pxTQCfOc34sQJkl3/QND9Ia', FALSE, ""),
('bob.builder@example.com', '$2b$10$xj/KQMbskScxwk7DhWMqlO/Nkvpvo6pxTQCfOc34sQJkl3/QND9Ia', TRUE, ""),
('charlie.brown@example.com', '$2a$10$T/iAXKsAtMJB2rpzvU20hOh74UHlm7PqlLT2yrUtoWelH244J2KfG', TRUE, "");
    

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
('172.16.0.1', 2, '2024-12-16 12:30:00', 2),
('192.168.1.3', 3, '2024-12-17 14:00:00', 3);


-- Indexes for Asset table
CREATE INDEX idx_asset_user_id ON Asset (user_id);



CREATE TABLE Event (
    id INT AUTO_INCREMENT PRIMARY KEY,
    uuid VARCHAR(36) NOT NULL,
    status INT NOT NULL,         
    host VARCHAR(255) NOT NULL,   
    port VARCHAR(10) NOT NULL, 
    priority INT NOT NULL,      
    category_name VARCHAR(255),        
    creation_date DATETIME DEFAULT CURRENT_TIMESTAMP, 
    last_occurrence DATETIME NOT NULL, 
    asset_id INT NOT NULL,  
    updated_at VARCHAR(255) NOT NULL,
    CONSTRAINT fk_asset FOREIGN KEY (asset_id) REFERENCES Asset (id) ON DELETE CASCADE,
    CONSTRAINT unique_host_port_category_priority UNIQUE (host, port, category_name, priority)
);


-- Indexes for Event table
CREATE INDEX idx_event_creation_date ON Event (creation_date);
CREATE INDEX idx_event_host_port ON Event (host, port);
CREATE INDEX idx_event_last_occurrence ON Event (last_occurrence);
CREATE INDEX idx_event_category_name ON Event (category_name);
CREATE INDEX idx_event_priority ON Event (priority);


INSERT INTO Event (
    uuid, 
    status, 
    host, 
    port, 
    priority, 
    category_name, 
    creation_date, 
    last_occurrence, 
    asset_id, 
    updated_at
) VALUES
('a1b2c3d4-e5f6-7g8h-9i0j-k1l2m3n4o5p6', 1, '192.168.1.1', '8080', 3, 'EOL component', '2024-12-20 10:00:00', '2024-12-20 15:00:00', 1, '2024-12-20 15:00:00'),
('b2c3d4e5-f6g7-8h9i-0j1k-l2m3n4o5p6a7', 2, '192.168.1.2', '9090', 2, 'EOL component', '2024-12-19 12:00:00', '2024-12-20 14:30:00', 1, '2024-12-20 15:00:00'),
('c3d4e5f6-g7h8-9i0j-1k2l-m3n4o5p6a7b8', 1, '172.16.0.1', '8080', 1, 'EOL component', '2024-12-18 09:00:00', '2024-12-19 10:00:00', 2, '2024-12-20 15:00:00'),
('d4e5f6g7-h8i9-0j1k-2l3m-n4o5p6a7b8c9', 3, '192.168.1.3', '443', 5, 'EOL component', '2024-12-17 11:00:00', '2024-12-19 16:00:00', 3, '2024-12-20 15:00:00');

CREATE TABLE Notification(
	id INT AUTO_INCREMENT PRIMARY KEY,
	user_id INT NOT NULL,
    fcm_token VARCHAR(255),
    asset_id INT NOT NULL,
    asset_ip VARCHAR(45),
    seen boolean DEFAULT False,
    event_count INT,
    creation_date DATETIME DEFAULT CURRENT_TIMESTAMP
);


