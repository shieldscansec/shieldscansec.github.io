-- ===================================
-- RIO DE JANEIRO ROLEPLAY - DATABASE
-- ===================================

CREATE DATABASE IF NOT EXISTS `rjroleplay` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `rjroleplay`;

-- Tabela de contas dos jogadores
CREATE TABLE `accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(24) NOT NULL,
  `password` varchar(129) NOT NULL,
  `salt` varchar(129) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `ip` varchar(16) DEFAULT NULL,
  `serial` varchar(50) DEFAULT NULL,
  `registered_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `last_login` datetime DEFAULT NULL,
  `admin_level` int(2) DEFAULT 0,
  `vip_level` int(2) DEFAULT 0,
  `vip_expire` datetime DEFAULT NULL,
  `coins` int(11) DEFAULT 0,
  `total_hours` int(11) DEFAULT 0,
  `banned` tinyint(1) DEFAULT 0,
  `ban_reason` text DEFAULT NULL,
  `ban_admin` varchar(24) DEFAULT NULL,
  `ban_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela de personagens
CREATE TABLE `characters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account_id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `age` int(3) DEFAULT 18,
  `sex` tinyint(1) DEFAULT 0, -- 0=Masculino, 1=Feminino
  `skin` int(3) DEFAULT 26,
  `money` bigint(20) DEFAULT 5000,
  `bank_money` bigint(20) DEFAULT 0,
  `level` int(11) DEFAULT 1,
  `exp` int(11) DEFAULT 0,
  `pos_x` float DEFAULT 1680.3,
  `pos_y` float DEFAULT -2324.8,
  `pos_z` float DEFAULT 13.5,
  `angle` float DEFAULT 90.0,
  `interior` int(3) DEFAULT 0,
  `virtual_world` int(11) DEFAULT 0,
  `health` float DEFAULT 100.0,
  `armour` float DEFAULT 0.0,
  `hunger` int(3) DEFAULT 100,
  `thirst` int(3) DEFAULT 100,
  `energy` int(3) DEFAULT 100,
  `faction_id` int(11) DEFAULT 0,
  `faction_rank` int(2) DEFAULT 0,
  `job_id` int(11) DEFAULT 0,
  `phone_number` varchar(15) DEFAULT NULL,
  `cpf` varchar(14) DEFAULT NULL,
  `rg` varchar(12) DEFAULT NULL,
  `cnh` tinyint(1) DEFAULT 0,
  `weapon_license` tinyint(1) DEFAULT 0,
  `jail_time` int(11) DEFAULT 0,
  `wanted_level` int(2) DEFAULT 0,
  `hospital_time` int(11) DEFAULT 0,
  `created_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `last_login` datetime DEFAULT NULL,
  `total_time` int(11) DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `cpf` (`cpf`),
  UNIQUE KEY `rg` (`rg`),
  UNIQUE KEY `phone_number` (`phone_number`),
  KEY `account_id` (`account_id`),
  FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela de facções
CREATE TABLE `factions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `type` tinyint(1) NOT NULL, -- 0=Criminal, 1=Police, 2=Government, 3=Gang
  `color` int(11) DEFAULT -1,
  `bank` bigint(20) DEFAULT 0,
  `leader` int(11) DEFAULT 0,
  `spawn_x` float DEFAULT 0.0,
  `spawn_y` float DEFAULT 0.0,
  `spawn_z` float DEFAULT 0.0,
  `spawn_angle` float DEFAULT 0.0,
  `spawn_interior` int(3) DEFAULT 0,
  `spawn_vw` int(11) DEFAULT 0,
  `max_members` int(3) DEFAULT 50,
  `created_date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Inserindo facções padrão
INSERT INTO `factions` (`name`, `type`, `color`, `max_members`) VALUES
('Comando Vermelho', 0, 0xFF0000FF, 100),
('Amigos dos Amigos', 0, 0x00FF00FF, 100),
('Terceiro Comando Puro', 0, 0x0000FFFF, 100),
('Milícia', 0, 0x8B4513FF, 100),
('PMERJ', 1, 0x000080FF, 150),
('BOPE', 1, 0x2F4F4FFF, 50),
('CORE', 1, 0x808080FF, 30),
('UPP', 1, 0x4169E1FF, 80),
('Exército Brasileiro', 1, 0x228B22FF, 60),
('PCERJ', 1, 0x00008BFF, 100),
('PRF', 1, 0x483D8BFF, 40);

-- Tabela de inventário
CREATE TABLE `inventory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `character_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `quantity` int(11) DEFAULT 1,
  `slot` int(2) NOT NULL,
  `data` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `character_id` (`character_id`),
  FOREIGN KEY (`character_id`) REFERENCES `characters` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela de itens
CREATE TABLE `items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `model` int(11) DEFAULT 0,
  `type` tinyint(2) NOT NULL, -- 1=Weapon, 2=Food, 3=Drink, 4=Drug, 5=Tool, 6=Document
  `max_stack` int(11) DEFAULT 1,
  `weight` float DEFAULT 0.0,
  `price` int(11) DEFAULT 0,
  `craftable` tinyint(1) DEFAULT 0,
  `description` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela de veículos
CREATE TABLE `vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner_id` int(11) DEFAULT 0,
  `faction_id` int(11) DEFAULT 0,
  `model` int(3) NOT NULL,
  `pos_x` float DEFAULT 0.0,
  `pos_y` float DEFAULT 0.0,
  `pos_z` float DEFAULT 0.0,
  `angle` float DEFAULT 0.0,
  `color1` int(3) DEFAULT -1,
  `color2` int(3) DEFAULT -1,
  `interior` int(3) DEFAULT 0,
  `virtual_world` int(11) DEFAULT 0,
  `plate` varchar(8) DEFAULT NULL,
  `fuel` float DEFAULT 100.0,
  `engine` tinyint(1) DEFAULT 0,
  `lights` tinyint(1) DEFAULT 0,
  `alarm` tinyint(1) DEFAULT 0,
  `locked` tinyint(1) DEFAULT 1,
  `damage_panels` int(11) DEFAULT 0,
  `damage_doors` int(11) DEFAULT 0,
  `damage_lights` int(11) DEFAULT 0,
  `damage_tires` int(11) DEFAULT 0,
  `mod0` int(3) DEFAULT 0,
  `mod1` int(3) DEFAULT 0,
  `mod2` int(3) DEFAULT 0,
  `mod3` int(3) DEFAULT 0,
  `mod4` int(3) DEFAULT 0,
  `mod5` int(3) DEFAULT 0,
  `mod6` int(3) DEFAULT 0,
  `mod7` int(3) DEFAULT 0,
  `mod8` int(3) DEFAULT 0,
  `mod9` int(3) DEFAULT 0,
  `mod10` int(3) DEFAULT 0,
  `mod11` int(3) DEFAULT 0,
  `mod12` int(3) DEFAULT 0,
  `mod13` int(3) DEFAULT 0,
  `paintjob` int(2) DEFAULT 3,
  `impounded` tinyint(1) DEFAULT 0,
  `impound_price` int(11) DEFAULT 0,
  `insurance` int(11) DEFAULT 0,
  `created_date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `plate` (`plate`),
  KEY `owner_id` (`owner_id`),
  KEY `faction_id` (`faction_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela de casas
CREATE TABLE `houses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner_id` int(11) DEFAULT 0,
  `address` varchar(100) NOT NULL,
  `price` int(11) NOT NULL,
  `pos_x` float NOT NULL,
  `pos_y` float NOT NULL,
  `pos_z` float NOT NULL,
  `interior_id` int(3) DEFAULT 0,
  `int_x` float DEFAULT 0.0,
  `int_y` float DEFAULT 0.0,
  `int_z` float DEFAULT 0.0,
  `locked` tinyint(1) DEFAULT 1,
  `rent_price` int(11) DEFAULT 0,
  `for_sale` tinyint(1) DEFAULT 1,
  `alarm` tinyint(1) DEFAULT 0,
  `safe_money` bigint(20) DEFAULT 0,
  `safe_guns` text DEFAULT NULL,
  `safe_drugs` text DEFAULT NULL,
  `created_date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `owner_id` (`owner_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela de empresas
CREATE TABLE `businesses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner_id` int(11) DEFAULT 0,
  `name` varchar(50) NOT NULL,
  `type` tinyint(2) NOT NULL, -- 1=24/7, 2=Ammunation, 3=Restaurant, 4=Club, 5=Bank
  `cnpj` varchar(18) DEFAULT NULL,
  `pos_x` float NOT NULL,
  `pos_y` float NOT NULL,
  `pos_z` float NOT NULL,
  `interior_id` int(3) DEFAULT 0,
  `int_x` float DEFAULT 0.0,
  `int_y` float DEFAULT 0.0,
  `int_z` float DEFAULT 0.0,
  `price` int(11) NOT NULL,
  `bank` bigint(20) DEFAULT 0,
  `products` int(11) DEFAULT 100,
  `max_products` int(11) DEFAULT 500,
  `entrance_fee` int(11) DEFAULT 0,
  `locked` tinyint(1) DEFAULT 0,
  `for_sale` tinyint(1) DEFAULT 1,
  `created_date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cnpj` (`cnpj`),
  KEY `owner_id` (`owner_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela de territórios (bocas de fumo)
CREATE TABLE `territories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `faction_id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `min_x` float NOT NULL,
  `min_y` float NOT NULL,
  `max_x` float NOT NULL,
  `max_y` float NOT NULL,
  `color` int(11) DEFAULT -1,
  `money_per_hour` int(11) DEFAULT 1000,
  `drug_production` int(11) DEFAULT 10,
  `last_collect` datetime DEFAULT CURRENT_TIMESTAMP,
  `created_date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `faction_id` (`faction_id`),
  FOREIGN KEY (`faction_id`) REFERENCES `factions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela de logs
CREATE TABLE `logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(20) NOT NULL, -- login, command, chat, money, weapon, etc
  `player_name` varchar(24) DEFAULT NULL,
  `player_ip` varchar(16) DEFAULT NULL,
  `action` text NOT NULL,
  `timestamp` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `type` (`type`),
  KEY `timestamp` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela de bans
CREATE TABLE `bans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player_name` varchar(24) NOT NULL,
  `player_ip` varchar(16) DEFAULT NULL,
  `admin_name` varchar(24) NOT NULL,
  `reason` text NOT NULL,
  `ban_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `expire_date` datetime DEFAULT NULL,
  `active` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `player_name` (`player_name`),
  KEY `player_ip` (`player_ip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela de transações VIP/Coins
CREATE TABLE `transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account_id` int(11) NOT NULL,
  `type` varchar(20) NOT NULL, -- vip, coins, donation
  `amount` decimal(10,2) NOT NULL,
  `coins_amount` int(11) DEFAULT 0,
  `payment_method` varchar(20) DEFAULT NULL, -- pix, pagseguro, picpay
  `payment_id` varchar(100) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'pending', -- pending, completed, failed
  `created_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `completed_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `account_id` (`account_id`),
  FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela de mensagens do celular
CREATE TABLE `phone_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sender_number` varchar(15) NOT NULL,
  `receiver_number` varchar(15) NOT NULL,
  `message` text NOT NULL,
  `sent_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `read_status` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `sender_number` (`sender_number`),
  KEY `receiver_number` (`receiver_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela de chamadas do celular
CREATE TABLE `phone_calls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `caller_number` varchar(15) NOT NULL,
  `receiver_number` varchar(15) NOT NULL,
  `duration` int(11) DEFAULT 0, -- em segundos
  `call_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `answered` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `caller_number` (`caller_number`),
  KEY `receiver_number` (`receiver_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;